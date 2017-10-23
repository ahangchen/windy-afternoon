## ECCV 2016 Hydra CCNN

Towards perspective-free object counting with deep learning，这是一篇发在ECCV 2016上的论文，提出一种多输入的CNN模型来解决Object Counting的问题。

### Object Counting

#### 定义

给定一张图片，输出图片中目标对象的个数，比如下面两张图，左图有36个车，右图有8个猪

![](obj_cnt_exp.png)

#### 常用方法

- Counting by detection
用检测器去检测图中有多少个对象，检测到多少个就认为是多少个

![](detection_cnt.png)

检测有三种方法，整体的检测（图a，检测整个人），部分的检测（图b，检测头），形状的匹配（图c，人的形状抽象成几何图形）

- Counting by Clustering

![](cluster_cnt.png)

  - 在摄像头捕捉到的连续视频帧里，目标移动时，在多个帧之间的位置比较相近，将这些运动物体在多帧图片之间做聚类，聚类中心的个数就是目标的个数
  - 不适用于静止物体
  - 优点：无监督

- Counting by Regression

![](regression_cnt.png)

  - 给定输入图片，ROI，透视图（场景中由远及近的几何关系，用于缩放对象）
  - 提取特征（背景分离，边缘检测，纹理识别）
  - 学习一种映射，将特征回归到对象数量上

回归又分两种，
- 回归对象数量
- 回归对象密度图

具体讲一下回归对象密度图的做法：

  
更多细节可看Related work部分的参考文献
