# 单目深度
单目深度可以分为两个小领域，一个是Mono depth estimation，是真单目，从图像语义出depth，输出的depth scale通常和真实世界是不对齐的，另一个是Multi view stereo，利用前后帧图像和pose（pose也可能真实模型估出来的），通过对极几何出深度。

## Mono Depth Estimation
- 可以参考知乎上这篇综述，挺完整的：https://zhuanlan.zhihu.com/p/111759578

## Multi view stereo
- MVDepthNet: Real-time Multiview Depth Estimation Neural Network [[code(pytorch)]](https://github.com/HKUST-Aerial-Robotics/MVDepthNet)[[paper]](https://arxiv.org/abs/1807.08563)

> 3DV2018，大概是第一篇CNN做mvs的论文，基本思路就是把measure frame 利用pose和多个depth warp到ref frame，找到cost最小的depth，找最小的过程用一个unet实现，多个multi view时，对cost volume求平均。

- MVSNet: Depth Inference for Unstructured Multi-view Stereo [code(tensorflow)](https://github.com/YoYo000/MVSNet)[paper](https://arxiv.org/abs/1804.02505)

> ECCV2018，在MVDepthNet基础上添加了对图像的feature提取，并对encode-decode出来的depth加了图像上的refine

- DPSNet: End-to-end Deep Plane Sweep Stereo [[code(pytorch)]](https://github.com/sunghoonim/DPSNet) [[paper]](https://arxiv.org/abs/1905.00538)

> ICLR2019，思路和mvsnet基本一致，同时发表，但是代码是pytorch的，看得出是在MVDepthNet上改的，代码质量比较高

- Depth Estimation by Learning Triangulation and Densification of Sparse Points for Multi-view Stereo

arxiv 2020.5月的一篇，用superpoint提描述子，做point match，利用稀疏的匹配点和一些随机点做三角测量（也可以理解为稀疏的cost volume），然后用unet encode-decode把稀疏的深度图变成dense的，相同效果下，计算量小于cost volume的方法，不过只做了室内的实验。

- Fast-MVSNet: Sparse-to-Dense Multi-View Stereo With Learned Propagation and Gauss-Newton Refinement [[code(pytorch)]](https://github.com/svip-lab/FastMVSNet) [[paper]](https://arxiv.org/abs/2003.13017)

> CVPR2020，特征提取层天然会缩小feature map，在小的feature map上做plane sweep，得到winner takes all depth，nearest upsample得到大分辨率depth map，再用原图输出一个kxk的卷积核，根据这个卷积核，用周围的信息丰富depth map，再用warp loss refine depth map，少了encode-decode层，计算量少了很多，plane sweep部分在小分辨率上做的，计算量也小。

- Upgrading Optical Flow to 3D Scene Flow Through Optical Expansion-Supplementary Material

> CVPR2020，推导出optical expansion(物体长度在像素坐标系上的变化)和motion in depth的反比关系（只在没有旋转只有平移时成立），用一个encoder-decoder输出光流，通过一个local affine layer得到初始的expansion，再通过一个encoder-decoder得到refine的expansion，再用一个encoder-decoder得到motion-in-depth，为了得到真正的motion in depth，还需要用一个单目网络出frame1的depth，再用motion in depth换算出frame2的depth，motion in depth的思路比较新奇，但并不怎么实用。

## 其他Depth相关的论文
- Depth Sensing Beyond LiDAR Range

> cvpr2020，构造了一个三目系统，讲了怎么用三目出深度，声称解决超远距离（超过lidar范围）深度估计，但是论文里看不出为啥三目能解这个问题。
