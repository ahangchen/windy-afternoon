# TFusion技术实现

## 图像分类器
图像分类器的任务是在源数据集上做预训练，在目标数据集上计算图片对之间的图像相似度，这里涉及数据预处理，网络构建，训练，调参，预测结果后处理与可视化等工作。
- 数据预处理是一个难点，需要按一定比例构造输入的正负样本对，正样本代表相同的图片对，负样本代表不同的图片对
  - 先统计所有训练集样本的标签，
  - 随机选择一张图，然后按25%的概率选择与其相同标签的图作为正样本，按75%的概率选择与其不同标签的图作为负样本
  - 用generator的方式喂给模型学习
这个过程中大量的矩阵运算都是用numpy实现的，numpy类型的数据能直接作为keras的输入，并且运算速度较快
- 网络构建
使用Siamese网络，用Keras实现，以Tensorflow为backend，大致的原理是，将两张图作为输入，
每张图有一个softmax的person identification多分类损失，同时两张图共同决定另一个损失，即两张图是否一致的二分类。
大致的网络结构如下，这里用了我百度比赛的一个模型的图，也是用的Siamese网络，不同的是TFusion中基础网络不是xception，是resnet，

![](https://github.com/ahangchen/keras-dogs/blob/master/viz/model_combined.png)

 - 难点在于输入样本对的构造：
    - 先统计所有训练集样本的标签，
    - 随机选择一张图，然后按25%的概率选择与其相同标签的图作为正样本，按75%的概率选择与其不同标签的图作为负样本
    - 用generator的方式喂给模型学习
    
## 时空估计

## 融合评分

## 增量训练

## 结果评估

##　Citation

Please cite this paper in your publications if it helps your research:

@article{TFusion, 
title={Unsupervised Cross-dataset Person Re-identification by Transfer Learning of Spatial-Temporal Patterns}, 
author={Jianming, Lv and Weihang, Chen and Qing, Li and Can, Yang}, 
journal={arxiv}, 
year={2017} 
}
