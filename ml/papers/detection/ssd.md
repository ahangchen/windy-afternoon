# 读论文系列：Object Detection ECCV2016 SSD

转载请注明作者：[梦里茶](https://github.com/ahangchen)

> Single Shot MultiBox Detector

## Introduction
一句话概括：SSD就是关于类别的多尺度RPN网络

基本思路：
- 基础网络后接多层feature map
- 多层feature map分别对应不同尺度的固定anchor
- 回归所有anchor对应的class和bounding box


## Model
![SSD](https://upload-images.jianshu.io/upload_images/1828517-89fe5dc4d9d31d24.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

- 输入：300x300
- 经过VGG-16（只到conv4_3这一层）
- 经过几层卷积，得到多层尺寸逐渐减小的feature map
- 每层feature map分别做3x3卷积，每个feature map cell(又称slide window)对应k个类别和4个bounding box offset，同时对应原图中6（或4）个anchor(又称default box)
  - 38x38, 最后3x3, 1x1三个feature map的每个feature map cell只对应4个anchor，分别为宽高比: 1:1两种，1:2, 2:1两种，因此总共有 38 x 38 x 4 + 19 x 19 x 6 + 10 x 10 x 6 + 5 x 5 x 6 + 3 x 3 x 4 + 1 x 1 x 4 = 8732 个anchor
  - 其他feature map的feature map cell对应6个anchor，分别为宽高比: 1:1两种，1:2, 2:1两种，1:3， 3:1两种
  - 每层的feature map cell对应的anchor计算方法如下
   -  位置：假设当前feature map cell是位于第i行，第j列，则anchor的中心为 $$\frac{i+0.5}{|f_{k}|},\frac{j+0.5}{|f_{k}|}$$, $$f_{k}$$是第k层feature map的size（比如38）
    - 缩放因子:

    ![Scale](https://upload-images.jianshu.io/upload_images/1828517-91ef6530e5dce4b2.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

    其中$$s_{min}$$为0.2，$$s_{max}$$为0.9，m为添加的feature map的层数，缩放因子就是为不同feature map选择不同的大小的anchor，要求小的feature map对应的anchor尽量大，因为越小的feature map，其feature map cell的感受野就越大
  - anchor宽高：

    ![width](https://upload-images.jianshu.io/upload_images/1828517-ba128e30ed7637e3.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

    ![height](https://upload-images.jianshu.io/upload_images/1828517-4898e977cc483570.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

    其中，$$a_{r}∈\{1,2,3,1/2,1/3\}$$，可以理解为在缩放因子选择好anchor尺寸后，用$$a_{r}$$来控制anchor形状，从而得到多尺度的各种anchor，当$$a_{r}=1$$时，增加一种$$ s_{k}=sqrt(s_{k-1}s_{k+1})$$，于是每个feature map cell通常对应6种anchor。


- 网络的训练目标就是，回归各个anchor对应的类别和位置

## Training
### 样本
- 正样本
选择与bounding box jaccard overlap（两张图的交集/并集）大于0.5的anchor作为正样本

- 样本比例
Hard negative mining：由于负样本很多，需要去掉一部分负样本，先整图经过网络，根据每个anchor的最高类置信度进行排序，选择置信度靠前的样本，这样筛选出来的负样本也会更难识别，并且最终正负样本比例大概是1:3

### Loss
还是一如既往的location loss + classification loss，并为location loss添加了系数α（然而实际上α=1）进行平衡，并在batch维度进行平均

![SSD Loss](https://upload-images.jianshu.io/upload_images/1828517-d6d2d65d71a11cb9.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

- $$x$$是$$x_{ij}^{p}$$的集合$$x_{ij}^{p}={1,0}$$，用于判断第i个anchor是否是第j个bounding box上的p类样本
- $$c$$是$$c_{i}^{p}$$的集合，$$c_{i}^{p}$$是第i个anchor预测为第p类的概率
- l是预测的bounding box集合
- g是ground true bounding box集合

其中定位loss与faster rcnn相同

![Location loss](https://upload-images.jianshu.io/upload_images/1828517-85b5465531c2b9bb.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

这个式子里的k不是很明确，其实想表达不算背景0类的意思，且前景类只为match的类算location loss

分类loss就是很常用的softmax交叉熵了

![classification](https://upload-images.jianshu.io/upload_images/1828517-5f9a84cd98dce905.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

> 核心的内容到这里就讲完了，其实跟YOLO和faster rcnn也很像，是一个用anchor box充当固定的proposal的rpn，并且用多尺度的anchor来适应多种尺度和形状的目标对象。

## Detail
在训练中还用到了data augmentation（数据增强/扩充），每张图片多是由下列三种方法之一随机采样而来
- 使用整图
- crop图片上的一部分，crop出来的min面积为0.1,0.3,0.5,0.7,0.9
- 完全随机地crop

然后这些图片会被resize到固定的大小，随机水平翻转，加入一些图像上的噪声，详情可以参考另一篇论文：

Some improvements on deep convolutional neural network based image classification

从切除实验中，可以看到data augmentaion是很重要的（从65.6到71.6）

![Experiment](https://upload-images.jianshu.io/upload_images/1828517-3ddd324e48e37468.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

这个表中还提到了atrous，其实是指空洞卷积，是图像分割（deeplab）领域首先提出的一个卷积层改进，主要是能让测试速度更快。具体可以参考 [ICLR2015 Deeplab](https://arxiv.org/pdf/1412.7062.pdf)

从这个表中也可以看出多种形状的anchor可以提升准确率

## Result
输入尺寸为300x300，batch size为8的SSD300可以做到实时(59FPS)且准确(74.3% mAP)的测试

## Summary
SSD算是一个改进性的东西，站在Faster RCNN的肩膀上达到了实时且准确的检测
