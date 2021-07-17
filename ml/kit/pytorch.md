# PyTorch踩坑手记

* 多GPU模式下，不能和其他进程共享同一个GPU，否则会出现ConnectionError，应该用环境变量将自己的进程使用的GPU和其他进程使用的GPU分开

* 循环中定义的变量，如果在循环结束后不需要使用，需要del，避免一直占用显存

## torch.unfold
给定一个NCHW的tensor，构造一个k1\*k2的滑动窗口，按照一定的padding, dilation, stride在这个tensor上滑动L次，

$$L = \prod_d \left\lfloor\frac{\text{output\_size}[d] + 2 \times \text{padding}[d] % - \text{dilation}[d] \times (\text{kernel\_size}[d] - 1) - 1}{\text{stride}[d]} + 1\right\rfloor$$

滑动时，将窗口内C\*H\*W个元素flatten，就能得到一个N* (C\*H\*W) * L的tensor；

unfold有什么用呢？可以看到它跟卷积操作很像，如果我们给窗口内flatten后的元素乘上一些权重再求和，再把L个元素变成二维的，那它就跟卷积一样了；

与卷积不同的地方在于，unfold之后，我们可以乘上任意的权重， 比如根据feature预测出一个权重出来，而卷积对于每个窗口里的元素，乘的权重是一样的；

因此unfold可以实现动态权重的卷积。
