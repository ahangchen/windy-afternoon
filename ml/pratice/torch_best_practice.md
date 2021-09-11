# 如何让炼丹更有条理

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

  - parse_test_args
    - `save_viz`：控制是否保存可视化结果的开关
    - `result_dir`：可视化结果和测试结果的存储目录，留空，不用传入，会在`get_test_result_dir`中自动生成，自动创建目录，这个目录通常位于模型路径下，形如checkpoints/model_name/checkpoint_num/val_info_save_prefix

使用时，调用`prepare_train_args`，就会创建一个包含所有公共参数和训练参数的parser，然后创建一个模型目录，并调用`save_args`函数保存所有参数，返回对应的args。保存参数这一步十分重要，能够避免模型训练完成之后，脚本或命令找不到，忘记自己训练的模型配置这种尴尬局面。

测试时也类似，调用`prepare_test_args`，创建parser，创建目录，保存参数，并返回对应的args。