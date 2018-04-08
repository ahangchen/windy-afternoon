# 读论文系列：Object Detection NIPS2015 Faster RCNN

> 转载请注明作者：[梦里茶](https://github.com/ahangchen)

Faster RCNN在Fast RCNN上更进一步，将Region Proposal也用神经网络来做，如果说Fast RCNN的最大贡献是ROI pooling layer和Multi task，那么RPN（Region Proposal Networks）就是Faster RCNN的最大亮点了。使用RPN产生的proposals比selective search要少很多（300vs2000）,因此也一定程度上减少了后面detection的计算量。

## Introduction
Fast RCNN之后，detection的计算瓶颈就卡在了Region Proposal上。一个重要原因就是，Region Proposal是用CPU算的，但是直接将其用GPU实现一遍也有问题，许多提取规则其实是可以重用的，因此有必要找一种能够共享算力的GPU版Region Proposal。

Faster RCNN则是专门训练了一个卷积神经网络来回归bounding box，从而代替region proposal。这个网络完全由卷积操作实现，并且引入anchor以应对对象形状尺寸各异的问题，测试速度与Fast RCNN相比速度极快。

这个网络叫做region proposal layer.

## RPN
![RPN](https://upload-images.jianshu.io/upload_images/1828517-955cf7abb99e8de2.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


训练数据就是图片和bounding box

- 输入任意尺寸的图片，缩放到800×600
- 输入到一个基础卷积神经网络，比如ZF或者VGG，以ZF为例，得到一个51×39的feature map
- 用一个小的网络在feature map上滑窗，算每个3x3窗口的feature，输出一个长度为256的向量，这个操作很自然就是用3×3卷积来实现，于是可以得到一个51×39×256的feature map
- 每个256向量跟feature map上一个3×3窗口对应，也跟800×600的原图上9个区域相对应，具体讲一下这个9个区域：

  - 卷积后feature map上的每个3x3的区域对应原图上一个比较大的感受野，用ZF做前面的卷积层，感受野为171×171，用VGG感受野为228×228
  - 我们想用feature map来判断它的感受野是否是前景，从而将感受野作为proposal，但是对象并不总是正方形的，于是我们需要对感受野做一个替换，得到多种形状的proposal
  - 我们让每个3x3的区域（图中橙色方格）和原图上九个区域相对应，这九个区域的中心（灰色方格）就是感受野的中心
  - 九个区域有九种尺寸分别是

  > 128x128    128x64      64x128
256x256    256x128   128x256
512x512    512x256   256x512

  - 这九个区域我们也成为9个anchor，或者9个reference box
  - 如此，每个特征就能和原图上形状和尺寸各异的区域对应起来了

- 回到刚刚的256向量，将这个向量输入一个FC，得到2x9个输出，代表9个anchor为前景还是背景的概率
  - 学习用的标签设置：如果anchor与真实bounding box重叠率大于0.7，就当做是前景，如果小于0.3，就当做背景
- 将256向量输入另一个FC，得到4x9个输出，代表9个anchor的修正后的位置信息(x,y,w,h)
  - 学习用的标签就是真实的bounding box，用的还是之s前Faster RCNN的bounding box regression

> 两个FC在实现的时候是分别用两个1x1卷积实现的
![FC](https://upload-images.jianshu.io/upload_images/1828517-c23f035a21b10c24.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
以橙色为例，256向量和W1矩阵相乘，得到长度为18的向量，这样的操作在51x39个feature都要做一遍，实现起来就很自然变成了用一个1x1的卷积核在feature map上做卷积啦，这样也暗含了一个假设，不同位置的slide window对于anchor的偏好是相同的，是一个参数数量与精度的权衡问题。


- 于是我们会得到图片上51x39x9≈20K个anchor为前景的概率，以及修正后的位置

上面这个过程可以完全独立地训练，得到一个很好的Region Proposal Network

理论上我们可以用上面这个流程去训练RPN，但训练RPN的时候，一个batch会直接跑20K个anchor开销太大了。
- 因此每个batch是采一张图里的256个anchor来训练全连接层和卷积层；
- 这256个anchor里正负样本比例为1:1，正样本128个，负样本128个，
- 如果正样本不足128个，用负样本填充，这也意味着并非所有的背景anchor都会拿来训练RPN，因为前景的anchor会远少于背景的anchor，丢掉一些背景anchor才能保证样本平衡，丢背景anchor的时候是以slide window为单位丢的，下面会说明。
- 具体实现上，先算所有anchor，再算所有anchor与bounding box的重叠率，按重叠率区分正负样本，然后选择batch中的256个anchor，参与训练。同一张图会多次参与训练，直到图中的正anchor用完。

因此最终的一个mini batch的训练损失函数为：

![RPN Loss](https://upload-images.jianshu.io/upload_images/1828517-ee7376ecb88a3b64.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

其中，
- p<sub>i</sub>是一个batch中的多个anchor属于前景/后景的预测概率向量，t<sub>i</sub>是一个batch中正anchor对应的bounding box位置向量
- L<sub>cls</sub>是softmax二分类损失
- L<sub>reg</sub>跟Fast RCNN中的bounding box regression loss一样，乘一个p<sub>i</sub>* ，意味着只有前景计算bounding box regression loss
- 论文中说N<sub>cls</sub>为256，也就是mini-batch size，N<sub>reg</sub>约为256 * 9=2304（论文中说约等于2400）,这意味着一对p对应9个t，这种对应关系也体现在全连接层的输出个数上，由于两个task输出数量差别比较大，所以要做一下归一化。

> 但这就意味着loss中的mini-batch size是以3x3的slide window为单位的，因为只有slide window和anchor的个数才有这种1:9的关系，而挑选训练样本讲的mini-batch size却是以anchor为单位的，所以我猜实际操作是这样的：
- 先选256个anchor，
- 然后找它们对应的256个slide window，
- 然后再算这256个slide window对应的256×9个anchor的loss，每个slide window对应一个256特征，有一个L<sub>cls</sub>，同时对应9个anchor，有9个L<sub>reg</sub>

论文这里讲得超级混乱，可以感受下：

![minibatch anchor](https://upload-images.jianshu.io/upload_images/1828517-f3ed1471a7298350.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


## Proposal layer
其实这也可以算是RPN的一部分，不过这部分不需要训练，所以单独拉出来讲
- 接下来我们会进入一个proposal layer，根据前面得到的这些信息，挑选region给后面的fast rcnn训练
  - 图片输入RPN后，我们手头的信息：anchor，anchor score，anchor location to fix
  - 用全连接层的位置修正结果修正anchor位置
  - 将修正后的anchor按照前景概率从高到底排序，取前6000个
  - 边缘的anchor可能超出原图的范围，将严重超出边缘的anchor过滤掉

![Anchor Filter](https://upload-images.jianshu.io/upload_images/1828517-30beac72a97b3fe8.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

  - 对anchor做非极大抑制，跟RCNN一样的操作
  - 再次将剩下的anchor按照anchor score从高到低排序（仍然可能有背景anchor的），取前300个作为proposals输出，如果不足300个就…也没啥关系，比如只有100个就100个来用，其实不足300个的情况很少的，你想Selective Search都有2000个。

## Fast RCNN
接下来就是按照Fast RCNN的模式来训练了，我们可以为每张图前向传播从proposal_layer出来得到最多300个proposals，然后
- 取一张图的128个proposal作为样本（有正有负），一张图可以取多次，直到proposal用完

![](https://upload-images.jianshu.io/upload_images/1828517-59eabb44802971e9.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/700)

- 喂给Fast RCNN做分类和bounding box回归，这里跟RPN很像，但又有所不同，
  - BB regressor：拟合proposal和bounding box，而非拟合anchor和bounding box
  - Classifier：Object多分类，而非前景背景二分类

## 迭代训练
RPN和Fast RCNN其实是很像的，因此可以一定程度上共享初始权重，实际训练顺序如下（MATLAB版）：
1.  先用ImageNet pretrain ZF或VGG
2. 训练RPN
3. 用RPN得到的proposal去训练Fast RCNN
4. 用Fast RCNN训练得到的网络去初始化RPN
5. 冻结RPN与Fast RCNN共享的卷积层，Fine tune RPN
6. 冻结RPN与Fast RCNN共享的卷积层，Fine tune Fast RCNN

论文中还简单讲了一下另外两种方法：
- 将整个网络合起来一块训练，而不分步，但由于一开始训练时RPN还不稳定，所以训练Fast RCNN用的proposal是固定的anchor，最后效果差不多，训练速度也快。

![Approximate joint training](https://upload-images.jianshu.io/upload_images/1828517-6b6aabc2a40fd690.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

- 整个网络合起来一起训练，不分步，训练Fast RCNN用的proposals是RPN修正后的anchor，但这种动态的proposal数量不好处理，用的是一种RoI warping layer来解决，这又是另一篇论文的东西了。

## SUMMARY
网络结构和训练过程都介绍完了，实验效果也是依样画葫芦，就不再介绍了，整体来说，Faster RCNN这篇论文写得很乱，很多重要的细节都要去看代码才能知道是怎么回事，得亏是效果好才能中NIPS。。
