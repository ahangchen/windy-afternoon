# 光流相关论文阅读

Flow基本套路

- multi scale feature pyramid
- warp and correlation，得到cost
- 对不同scale的feature pyramid计算residual flow，实现refine

## RAFT
- 先把不同scale所有可能flow的cost算好，在计算出flow后look up得到cost
- 使用GRU实现不同scale coarse to fine的refine

## FastFlowNet
> ICRA 2021, 在TX2上用TensorRt可以跑到5Hz的模型

- 在feature提取层上先用卷积+stride降采样，再用pooling降采样，得到比较好的pyramid feature，
- 在correlation层，搜索半径为3的区域全部用来计算cost，在搜索半径大于3的部分，只采样计算其中一半的元素的cost，从而减少计算量
- cost到flow的过程用的是ShuffleNet中的SBD模块
- 从小scale开始做cost2flow，warp 大scale feature后再做一次cost2flow得到residual flow，总计六次，五次是refine