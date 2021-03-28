# 分类网络最新进展
## Self-training with Noisy Student improves ImageNet classification

> CVPR2020

### Method
- 在有标签数据上训练Teacher,在无标签数据上预测伪标签
- 用有标签数据和伪标签数据从头训练一个Student模型，Student模型
- 把Student当成Teacher，迭代，效果最好的是迭代三次

特别的地方在于：
- model noise: Student比Teacher大，多了Dropout和stochastic depth(训练时，重复的block中，某些会被设置成identity)
- data noise:训练数据加Data augumentation（）
- 一些trick：
  - Teacher网络置信度低的，不会用于训练；
  - ImageNet每个类的图像数量差不多，因此带伪标签的unlabel data也在类别上做了平衡，数量多的类只保存一部分，数量少的类多复制几份

### 效果
感觉其实这些操作平平无奇，效果比有监督的EfficientNet-L2（480M，85.5%）提升了一点：（480M，88.7%）





## Meta Pseudo Labels
### Motivation
使用伪标签无监督学习的方法，因为伪标签可能是错的，所以Student不能超越Teacher，如果能让Teacher在过程中也得到训练，输出更好的标签，Student就有希望输出更好的结果。

### Method
- 在有标签数据上先训练一个Teacher，在无标签数据上预测伪标签
- 用伪标签数据训练Student
- Student在有标签数据上测试，得到Loss
- Teacher根据Student在有标签数据上的Loss，对自身权重进行修正（关键就在于如何修正）

### Detail
假如用伪标签方案训练Student，那么训练目标可以这样表示：
$$\theta_{S}^PL = argmin_{\theta_S} L_u(\theta_T, \theta_S)$$

其中，$$L_u(\theta_T, \theta_S) = E_{x_u}[CE(T(x_u; \theta_T), S(x_u; \theta_S))]$$

如果根据Student在有标签数据集上的表现，优化Teacher，那这个目标可以表示为：$$ min_{\theta_T} L_l (\theta_{S}^{PL}(\theta_T))$$

其中，$$\theta_{S}^{PL}(\theta_T)$$就是伪标签方案下，在Teacher网络的参数$$\theta_T$$下，优化出的最优Student参数，即$$argmin_{\theta_S} L_u(\theta_T, \theta_S)$$

所以问题就在于如何解这个优化问题：$$ min_{\theta_T} L_l (\theta_{S}^{PL}(\theta_T))$$，

首先$$\theta_{S}^{PL}(\theta_T)$$可以通过梯度下降法迭代得到，但它是一个多步的优化过程才能得到的结果，我们用单步优化的结果来近似：$$\theta_{S}^{PL}(\theta_T)=\theta_S - \eta_S * \triangledown_{\theta_S}L_u(\theta_T, \theta_S)$$，那么优化目标就变成了：$$ min_{\theta_T} L_l (\theta_S - \eta_S * \triangledown_{\theta_S}L_u(\theta_T, \theta_S))$$;

那么每在伪标签数据上更新一次Student，就可以在有标签数据上算出Teacher的权重更新量，对Teacher进行更新：$$\theta_T=\theta_T-\eta_T\triangledown_{\theta_T} L_l (\theta_S - \eta_S * \triangledown_{\theta_S}L_u(\theta_T, \theta_S))$$，其中两个梯度都是对CE求导，因此这个更新量可以很容易地求出来；

## 辅助Loss
单独用上面的方法已经可以得到不错的结果了，但如果在训练的时候，配合其他Loss训练，效果更佳；文中提及了unsupervised domain adaption的一些方法，可以在论文附录查询到。


### 效果
在ImageNet上首次干到了90.2%的top1 ACC

