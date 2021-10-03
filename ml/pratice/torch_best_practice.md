# Pytorch实验代码的亿些小细节
## 序
你是否有过这样的经历：炼了一大堆的丹，但过了一周回来看结果，忘记了每个模型对应的配置；改了模型中的一个组件，跑起来一个新的训练，这时候测试旧模型却发现结果跟原来不一样了；把所有的训练测试代码写在一个文件里，加入各种if else，最后一个文件上千行，一个周末没看，回来改一个逻辑要找半天……其实这些情况除了深度学习相关的开发，在别的软件开发中也是很常见的，为了解决这些问题，软件行业的开发者形成了很多套路，比如设计模式，提高代码复用性，或者各种最佳实践，比如谷歌、阿里都有一套Java开发最佳实践，各种框架比如客户端的Android，后端的spring，也有各种最佳实践，让开发者的代码更加简洁，更专注于核心的业务实现。在炼丹领域，从2016年至今，各大训练框架互相竞争，互相学习，学术界基于这些框架产出了很多论文，质量越高的论文，往往代码写得也越有条理，最新的论文代码也渐渐形成了一些固定的范式。笔者在学校和工业界阅读过许多论文的开源代码，也基于别人的代码做过不少的改进，有些代码也在工业界落地，自己的炼丹代码也渐渐形成了一些风格，今天就讲讲自己炼丹代码中的一些能让实验更有条理的小习惯。

> 先上代码，欢迎star：https://github.com/ahangchen/torch_base

## 代码结构

```shell
torch_base
├── checkpoints # 存放模型的地方
├── data        # 定义各种用于训练测试的dataset
├── eval.py     # 测试代码
├── loss.py     # 定义各种花里胡哨的loss
├── metrics.py  # 定义各种约定俗成的评估指标
├── model       # 定义各种实验中的模型
├── options.py  # 定义各种实验参数，以命令行形式传入
├── README.md   # 介绍一下自己的repo
├── scripts     # 各种训练，测试脚本
├── train.py    # 训练代码
└── utils       # 各种工具代码
```

checkpoints比较简单，每次训练的模型各自放在一个目录里，scripts目录可以放每次训练或测试用的命令脚本，README.md往往是这个repo的门面，可以放一些介绍性的内容；其他都是代码目录，下面会逐一讲解。

## options
首先要介绍的是options.py这个文件，因为这里定义了各种实验参数，其他模块多多少少都会与它有关，受它控制；通常我们需要把各种参数通过某种方式传给程序，比如命令行参数，或者yaml配置文件，我比较习惯用命令行参数，配合pycharm的configuration使用，或者写在scripts目录的脚本里边，都很方便清晰。命令行传参用到了`argparse`这个lib，这里lib的详细介绍可以看[官网教程](https://docs.python.org/3/library/argparse.html)，这里只挑重点来讲一下：

```python
def parse_common_args(parser):
    parser.add_argument('--model_type', type=str, default='base_model', help='used in model_entry.py')
    parser.add_argument('--data_type', type=str, default='base_dataset', help='used in data_entry.py')
    parser.add_argument('--save_prefix', type=str, default='pref', help='some comment for model or test result dir')
    parser.add_argument('--load_model_path', type=str, default='checkpoints/base_model_pref/0.pth',
                        help='model path for pretrain or test')
    parser.add_argument('--load_not_strict', action='store_true', help='allow to load only common state dicts')
    parser.add_argument('--val_list', type=str, default='/data/dataset1/list/base/val.txt',
                        help='val list in train, test list path in test')
    parser.add_argument('--gpus', nargs='+', type=int)
    return parser

def parse_train_args(parser):
    parser = parse_common_args(parser)
    ...
    return parser

def parse_test_args(parser):
    parser = parse_common_args(parser)
    ...
    return parser
```

我会在外面初始化一个parser，先用parse_common_args添加训练测试共用的一些参数，在parse_train_args和parse_test_args中调用这个公共的函数，这样可以避免有些参数在训练时写了，测试时忘了写，一跑就报错。parse_train_args解析训练相关的参数，parse_test_args解析测试相关的参数；具体参数和用途如下：

- parse_common_args
  - `model_type`: 模型的名字，配合model目录和model_entry.py使用；
  - `data_type`：数据集的名字，配合data目录和data_entry.py使用；
  - `save_prefix`：训练时：实验的名字，可以备注自己改了那些重要组件，具体的参数，会用于创建保存模型的目录；测试时：测试的名字，可以备注测试时做了哪些配置，会用于创建保存测试结果的目录；
  - `load_model_path`：模型加载路径，训练时，作为预训练模型路径，测试时，作为待测模型路径，有的人喜欢传入一个模型名字，再传入一个epoch，但其实没啥必要，就算要循环测多个目录，我们也可以写shell生成对应的load_model_path，而且通常只需要测最后一个epoch的模型；
  - `load_not_strict`：我写了一个`load_match_dict`函数（utils/torch_utils.py），允许加载的模型和当前模型的参数不完全匹配，可多可少，如果打开这个选项，就会调用此函数，这样我们就可以修改模型的某个组件，然后用之前的模型来做预训练啦！如果关闭，就会用torch原本的加载逻辑，要求比较严格的参数匹配；
  - `val_list`: 训练时可以传入验证集list，测试时可以传入测试集list；
  - `gpus`：可以配置训练或测试时使用的显卡编号，在多卡训练时需要用到，测试时也可以指定显卡编号，绕开其他正在用的显卡，当然你也可以在命令行里export CUDA_VISIBLE_DEVICES这个环境变量来控制

- parse_train_args
  - `lr`，`momentum`, `beta`, `weight-decay`: optmizer相关参数，在train.py中初始化optimizer
  - `model_dir`：模型的存储目录，留空，不用传入，会在`get_train_model_dir`函数中确定这个字段的值，创建对应的目录，填充到args中，方便其他模块获得模型路径
  - `train_list`：训练集list路径
  - `batch_size`：训练时的batch size，有人可能会问，为啥测试时不用设置batch size？主要是出于测试时的可视化需求，往往测试需要一张一张forward，所以我习惯将测试batch size为1
  - `epochs`：模型训练epoch数

  - parse_test_args
    - `save_viz`：控制是否保存可视化结果的开关
    - `result_dir`：可视化结果和测试结果的存储目录，留空，不用传入，会在`get_test_result_dir`中自动生成，自动创建目录，这个目录通常位于模型路径下，形如checkpoints/model_name/checkpoint_num/val_info_save_prefix

使用时，调用`prepare_train_args`，就会创建一个包含所有公共参数和训练参数的parser，然后创建一个模型目录，并调用`save_args`函数保存所有参数，返回对应的args。保存参数这一步十分重要，能够避免模型训练完成之后，脚本或命令找不到，忘记自己训练的模型配置这种尴尬局面。

测试时也类似，调用`prepare_test_args`，创建parser，创建目录，保存参数，并返回对应的args。

## data
接下来是data package，在这里，可以为每种数据集定义一个dataset，最好是每个dataset各自形成一个文件，比如[list_dataset.py](https://github.com/ahangchen/torch_base/blob/main/data/list_dataset.py), [mem_list_dataset.py](https://github.com/ahangchen/torch_base/blob/main/data/mem_list_dataset.py)，如果多个dataset都写到一个文件里，随着实验进行，各种修修补补下来，代码就会很长，很难查阅。

这里我们还有一个[data_entry.py](https://github.com/ahangchen/torch_base/blob/main/data/data_entry.py)，可以根据命令行参数，以字典的形式，快捷地选择要构造的dataset，如果你有更多的dataset，可以继续扩展这个字典，字典访问是O(1)的，也可以避免一堆if-else的判断。有了dataset，再用pytorch的dataloader接口包一下，可以支持shuffle，多线程加载数据，非常方便。

通常我们还会在data package里放一个augment.py，可以把数据扩增操作都放进去，因为往往多个dataset都需要调用相同的augmentor，所以最好独立出来，在dataset文件中分别调用。

## model
这里放的就是各种花里胡哨的模型啦，也是炼丹工作最主要的部分。建议每个模型创建一个package，比如[base](https://github.com/ahangchen/torch_base/tree/main/model/base)，[better](https://github.com/ahangchen/torch_base/tree/main/model/better)， [best](https://github.com/ahangchen/torch_base/tree/main/model/best)，甚至[sota](https://github.com/ahangchen/torch_base/tree/main/model/sota)，现代的神经网络结构有一些常用的小组件，比如conv-bn-relu这样的结构，我习惯把它们都放在一个单独的文件[submodules.py](https://github.com/ahangchen/torch_base/blob/main/model/submodules.py)中，可以在各种任务中复用。

与data_entry类似，我们有一个[model_entry.py](https://github.com/ahangchen/torch_base/blob/main/model/model_entry.py)，在`select_model`函数中也是通过字典实现参数名和模型的对应，在`equip_multi_gpu`函数中，可以方便的实现单机多卡，至于多机多卡，我自己用得不多，因为我大多是训练面向无人机上的模型，参数量和计算量要求很小，我们的单机服务器足够train绝大多数模型了，如果是为了更大的batch size加速训练，不如在另一台机器上多跑一组别的实验，总体效率更高。如果大家想看这方面教程，可以留言，我可以补一下对应的代码。

## utils
存放各种可复用的util函数或者类，比如一些通用的可视化代码放到[viz.py](https://github.com/ahangchen/torch_base/blob/main/utils/viz.py)，一些pytorch魔改函数放到[torch_utils.py](https://github.com/ahangchen/torch_base/blob/main/utils/torch_utils.py)，还有基于tensorboard的存图存曲线的[logger.py](https://github.com/ahangchen/torch_base/blob/main/utils/logger.py)，这里主要介绍一下这个日志组件：

### Recoder
一个数据统计工具，在循环里record每次迭代的数据（比如各种评价指标`metrics`），在每个epoch训练完成后，调用summary，得到之前统计的指标各自的均值。这个工具在训练时嵌入到Logger中使用，在测试时由于不需要调用tensorboard，所以直接被eval.py调用。

### Logger
将tensorboard的SummaryWritter包了一层，包含一个recorder，还有一个SummaryWritter；在训练或验证的每个step以name-value的形式record一下对应的曲线数据，name最好用`train/xxx`，`val/xxx`这种形式，这样训练和测试的曲线会显示在两个图中，在每个epoch的最后一个step在每次训练或验证的epoch循环结束时，调用一次save_curves保存曲线，调用一次save_checkpoint保存模型参数；这些操作都在下面的train.py中体现。

## train.py
终于来到核心的训练代码环节，这里我整了一个trainer，将训练中固定的操作封装成一些函数，需要按实际情况修改的操作封装成另外的函数，这样有新任务来了，只需要修改这些函数就行。现在依次介绍这些函数：

- `__init__`：构造函数，初始化了命令行参数`args`，日志工具（[Logger](https://github.com/ahangchen/torch_base/blob/main/utils/logger.py)对象）`logger`，训练验证的两个dataloader，参数优化器`optimizer`，以及模型本身`model`，这里我们有三种方式初始化模型：1. 根据模型的构造函数初始化模型参数，2. 使用torch.load加载模型参数，这种方式要求模型参数和我们的模型定义完全匹配，3. 使用[load_match_dict](https://github.com/ahangchen/torch_base/blob/main/utils/torch_utils.py#L4)加载模型参数，可以找到模型参数和模型定义中，参数量和名字相同的部分进行初始化，适合只改了部分网络结构的模型初始化，作为一种局部pretrain。
- `train`：训练入口，迭代epochs次，每次调用train_per_epoch, val_per_epoch执行训练和测试，再调用logger存储曲线和图像。
- `train_per_epoch`：训练核心代码，将模型切换到训练模式，遍历整个train_loader，调用step进行数据拆包，不同loader返回的数据不同，拆包方式也有差异，还需要用Variable对数据再打包一下，这些操作都独立到step函数里，方便单独修改；再执行模型forward，获取结果，调用compute_metrics计算metrics（训练中也需要观察各种指标，这些指标的计算推荐放在[metrics.py](https://github.com/ahangchen/torch_base/blob/main/metrics.py)），计算loss（各种花里胡哨的loss请放到[loss.py](https://github.com/ahangchen/torch_base/blob/main/loss.py)），反向传播，在每次迭代中都调用logger的record函数，记录metrics，在最后一个step，调用gen_imgs_to_write，将torch的数据转成图像可视化，各种可视化可以写在[viz.py](https://github.com/ahangchen/torch_base/blob/main/utils/viz.py)再调用图像的存储（曲线的存储可以放到外面，每个epoch存一次，但图像不行，除非把图传出去，比较蛋疼）。最后根据print_freq，每隔一段时间打印日志方便观察。
- `val_per_epoch`：与训练类似，差别就是模型在eval模式下，不用计算loss和反向传播；

## eval.py
最后介绍的是测试代码，我把测试的过程包成了一个Evaluator，和trainer也比较类似：
- `__init__`：构造函数，初始化命令行参数`args`，加载模型`model`并切换到eval模式，初始化测试集的data_loader，设置一个recorder用于统计各种评估指标；
- `eval`：测试核心代码，遍历整个测试集，执行forward，得到输入，输出，真值，调用compute_metrics，调用recorder做记录，根据viz_freq，决定这个step是否调用`viz_per_epoch`可视化并保存结果（与训练不同，往往测试集可视化的内容是要向领导/导师/甲方汇报的，不能存到tensorboard里），循环结束时，调用recorder得到所有的评估指标，并将所有metrics写到`result.txt`里，避免测试窗口一关就找不到测试结果了。

## 总结
至此，[torch_base](https://github.com/ahangchen/torch_base)这个工程就基本介绍完了，主要还是实践中遇到的各种大坑小坑，逼着自己给工程加上了亿点点小细节，如果基于这个工程去开发新的任务，可以省去一些的脚手架开发工作，专注于model&&data&&metric&&loss&&viz相关的一些内容，让炼丹bring up更快，效率更高，对我来说还是挺有用的，不知道有没有给你一些启发？如果有什么建议也欢迎在[issue](https://github.com/ahangchen/torch_base/issues)或者[知乎评论区](https://zhuanlan.zhihu.com/p/409662511)告诉我，感谢你的阅读~
