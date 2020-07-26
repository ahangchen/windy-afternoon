# 单目深度
单目深度可以分为两个小领域，一个是Mono depth estimation，是真单目，从图像语义出depth，输出的depth scale通常和真实世界是不对齐的，另一个是Multi view stereo，利用前后帧图像和pose（pose也可能真实模型估出来的），通过对极几何出深度。

## Mono Depth Estimation
- 可以参考知乎上这篇综述，挺完整的：https://zhuanlan.zhihu.com/p/111759578

## Multi view stereo
- MVDepthNet: Real-time Multiview Depth Estimation Neural Network

[code(pytorch)](https://github.com/HKUST-Aerial-Robotics/MVDepthNet)[paper](https://arxiv.org/abs/1807.08563)

3DV2018，大概是第一篇CNN做mvs的论文，基本思路就是把measure frame 利用pose和多个depth warp到ref frame，找到cost最小的depth，找最小的过程用一个unet实现，多个multi view时，对cost volume求平均。

- MVSNet: Depth Inference for Unstructured Multi-view Stereo

[code(tensorflow)](https://github.com/YoYo000/MVSNet)[paper](https://arxiv.org/abs/1804.02505)

ECCV2018，在MVDepthNet基础上添加了对图像的feature提取，并对encode-decode出来的depth加了图像上的refine

- DPSNet: End-to-end Deep Plane Sweep Stereo

[code(pytorch)](https://github.com/sunghoonim/DPSNet) [paper](https://arxiv.org/abs/1905.00538)

ICLR2019，思路和mvsnet基本一致，同时发表，但是代码是pytorch的，看得出是在MVDepthNet上改的，代码质量比较高
