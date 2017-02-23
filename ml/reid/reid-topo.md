## Our Method
- retrain the image classifier
- deep learning model
- 不依赖场景

## Monitoring Activities from Multiple Video Streams: Establishing a Common Coordinate Frame（LSCTM-19-18）
- 只比较同一时刻不同空间的图片
- 通过拼合地面来决定摄像头之间的重叠与关联

## Tracking Across Multiple Cameras With Disjoint Views（LSCTM-19-14）
- 融合space-time和appearance的概率公式做最终的预测
- 用appearance的相似来建立关联，从而学习出space-time模型
  - 找到appearance最相近的两个object进行时空迁移概率的学习
- 没有对图像分类器做进一步的优化
- 场景中有多个人物时，只有图像分类器生效
- 比较不同时间空间的图片

## A Stochastic Approach to Tracking Objects Across Multiple Cameras(LSCTM-19-10)
- 训练Markov时空模型
- 训练是通过识别一个人携带的红色球的运动来进行的（用球产生轨迹训练集）
- 预测时结合时空和图像分类器预测
- 没有重新训练图像分类器

## LEARNING A MULTI-CAMERA TOPOLOGY （LSCTM-19-11）
- Detect and Track object
- 场景中找到入口和出口
- 建立所有入口和出口结点的迁移拓扑结构
- Markov-train和HMM建立概率模型
- 没有重新训练图像分类器


## 总结 根据摄像头拓扑辅助Re-id，

- 在知道拓扑的情况下，可以用于对结果直接进行剪枝减少搜索空间，
-  在不知道拓扑的情况下，需要学习拓扑，
-  学习拓扑往往将时空模型表达为概率模型，用概率密度函数表示，常用Markov建模。
-  学习拓扑通常需要知道轨迹之间的关联，这种关联基本上也是用图像分类器来做，具体体现为tracking等。
-  概率模型的建模和最后辅助图像分类器预测都有许多概率的文章可以做。

