# Graph + Reid

今天解读港中文商汤联合实验室沈岩涛老师在CVPR2018和ECCV2018上发表的两篇关于Graph+Person reid的文章：

CVPR2018：Deep Group-shuffling Random Walk for Person Re-identification
ECCV2018：Person Re-identification with Deep Similarity-Guided Graph Neural Network

# Motivation and Related Work
person reid这个任务是为probe图像在gallery图片集中寻找属于同一个人的图片，所以通常的做法都是考虑probe和gallery之间的关系，但有时候probe和gallery的差别太大，比如一个正面的人和一个背面的人，假如我有一个侧面的人的图片，跟两者都很像，就有可能用这个中间图片将两者关联起来。在这之前其实也有人提出过一些方法，比如CVPR2017:Re-ranking person re-identification with k-reciprocal encoding. 先计算出gallery图片之间的相似度，将较相似的图片的rank拉近。

但这些方法大多是将这种关系抽取和利用作为一个后处理的过程，对图像模型的训练起不到帮助。并且对gallery之间的相似度提取大多是基于已经训练好的图像模型，加上无监督的聚类方法，提取gallery图片之间的相似度关系，这种无监督方法较弱，不能充分利用数据集中的监督信息。

因此这两篇文章开始将gallery之间的关系（下面简称G2G）融入到图像模型的训练里。Graph由许多节点和边构成，在Reid问题里，节点就是一个个的人的图像，边就是图像之间的相似度。利用一个batch中的所有图像在关系图上的关联，提供更多的监督信号，将模型训练的更好。之所以说更多的监督信号，是因为以往我们一个batch的label只有batch_size对样本之间的相似关系，但将batch中的所有图片看成batch size个图之后，每个图之间有batch gallery size x batch gallery size个相似度关系可以学习，就引入了更多的监督信号。

## Overview
![Graph+Reid](https://upload-images.jianshu.io/upload_images/1828517-3eeab806b8db617e.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


这两篇文章是同一班人马写的，所以其实整体结构上都很像，我们结合起来分析：
- DGRW是用Random Walk的方式将G2G的相似度信息用来更新P2G的**相似度关系**，在反向传播时通过G2G这个很多相似度关联的图对原来的图像模型提供更多的训练。
- SGGNN是用G2G的相似度关系对P2G的**相似度特征**进行修正，从而得到更好的相似度特征，并且也通过G2G之间的大量关联提供了更多的监督信号。
 
## Deep Group-shuffling Random Walk 
与其他Reid方法一样，首先训练一个图像模型提取图像特征，对特征计算相似度可以得到probe中所有图片与gallery中所有图片之间的相似度，与其他Reid方法不同，但与reranking相同的是，我们也可以计算出所有gallery图片之间的相似度。给定一张probe图片，它和所有gallery之间的相似度向量为y，所有gallery之间的相似度矩阵为W，我们将一张probe图片和所有gallery图片合起来看成一个图，根据random walk的思想，probe图片这个节点walk到第j张gallery图片的概率是y<sub>j</sub>，接着，从probe节点出发，经过其他节点k，再到达gallery图片j的概率是y<sub>k</sub> * W<sub>kj</sub>，那么，从probe节点出发，走两步（包含了所有中间节点的可能）到达图片j的概率就是：

$$∑_{k=1}^n W_{kj}\*y^k$$

到达所有图片j的概率拼成一个新的向量，我们就可以得到：

$$y^{(t+1)} = Wy^(t)$$

论文里讲t拓展到了无穷大，并加入了权重因子λ对walk前后的概率进行了平衡，最终化简为了这样的形式：

$$y^(\infty)=(1-\lambda)(I-\lambdaW)^{-1}y^{(0)}$$

但根本的道理就是上面所述的Random walk思想。

这样我们就得到了一组更好的P2G相似度，并且我们反向传播的时候，这组相似度的梯度会传到W矩阵上，W矩阵是由前边图像模型得出的，也就会传到前面的模型上，从而对模型提供更多的监督信号。

论文里还有一个创新点是，将视觉特征分成了K个group，每个group的特征都可以单独拿出来用，这样我们就可以做K个上边提到的random walk，于是监督信号更多了，同时因为视觉特征被拆成了K份，每一份都只是原特征的一小部分，相当于dropout了一部分信息，也能很大程度上防止过拟合。但其实这个方法并不见得比dropout优雅，实验效果也差不多。

![Group shuffle](https://upload-images.jianshu.io/upload_images/1828517-60e2f4a1af81c017.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

实现上还有一个小的细节，把所有图片构成一个graph的话，开销太大了，所以训练时graph其实只是所有图片的一个子图，
- 首先每个batch有64个人，每个人有4张图，这样batch size就是256（流下了贫穷的泪水），
- 训练时，首先有256个softmax loss，
- 然后对于64个人，每个人的4张图中取1张做probe，3张做gallery，galley是所有人一起用的（这样就有正样本也有负样本）
- 这样W矩阵就是64*3x64*3，对角线为0，于是就有192*192个g2g相似度，同时有64个p2g的相似度。这些相似度可以用真实标签约束，也可以直接用feature求出来，论文里是用feature求的；
- 为每个人得到更新后的p2g向量，对这64个长度为192的p2g向量加二分类loss就完成训练模型的搭建了
- 测试时先算所有p2g相似度，然后对每个probe，选择top75个gallery组成G2G图，用这个G2G更新P2G相似度，从而获得更准的ranking结果

## Deep Similarity-Guided Graph Neural Network
这篇文章跟上一篇很多地方是一样的，我们来讲讲不同的地方。

### Graph and node
这篇文章声称每个节点是一个P2G的图像对，但在讨论中，图里的P都是相同的，所以我觉得可以认为这其实也是一个G2G的图，只不过每个节点的value变成了SiameseCNN算出来的P2G的相似度向量d<sub>i</sub>，我们用通常的Siamese二分类loss和softmax多分类loss约束d<sub>i</sub>，同时我们希望能用G2G的相似度矩阵W来进一步修正d<sub>i</sub>，

### feature update
考虑一下用类似random walk的模式来更新相似度向量：：


$$d_i^{t+1}=(1-α)d_i^{t+1}+αWd_i^t$$

但d<sub>i</sub><sup>t</sup>毕竟不是相似度的结果向量，而是相似度特征向量，所以上面这个式子其实是不成立的，于是进入拼凑模式，文中定义了一个消息向量:

$$t_i=F(d_i)$$

这个F就是d到t的映射，

![F](https://upload-images.jianshu.io/upload_images/1828517-50343f1495032758.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

如图，通过两层FC+BN+ReLU，将相似度特征d映射为一个能够根据相似度矩阵W修正特征向量的消息向量t，由于权重是可训练的，所以下面这个式子就成立了：

$$d_i^{t+1}=(1-α)d_i^{t+1}+αWt_i^t$$

文中说W*t得到的结果是fusion feature，其实我觉得这种G2G相似度和特征的fusion没有Random Walk来得优雅，然后用fusion feature和原来的feature做加权和，其实这种加权和的方式来修正原来的feature也值得商榷。不过这种update形式也是借鉴自其他的Graph Neural Network方法：


$$d_i^{t+1}=(1-α)d_i^{t+1}+α\sum_{j=1}^N h(d_i,d_j)t_i^t$$

这里边的h往往是无监督的，而SGGNN的W是可以有监督训练得到的，就比其他GNN的方法要好一点。

实现细节上，与DGRW类似
- 选择48个人，每个人有4个图，共192张图
- 每个人的4张图里，一张做probe，其他做gallery，gallery是所有人共用的，于是有Mx(K-1)=144个gallery图片（论文里的顺序应该是写反了）
- 用siamese CNN算出48*144个P2G相似度，144*144个G2G相似度
- 为每个probe取top100个gallery图片构成G2G图，于是W矩阵大小为100x100
- 用W矩阵更新p2g相似度特征，对相似度特征加dense层再做二分类loss约束即可
- 测试与DGRW基本相同，区别只在于更新的是相似度feature而非相似度结果。

## Experiment
跟别的方法对比就不用看了，我们来看Ablation Study

DGRW
![DGRW result](https://upload-images.jianshu.io/upload_images/1828517-ed3760233b72cdbc.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

baseline rank1就91%了我还能说什么，流下了不会调参的泪水，不过看baseline+triplet居然还掉了，说明他们的hack泛化能力其实不强，另外针对两个主要的创新点，group shuffle也没有比dropout效果要好多少，random walk也没有比reranking好多少。不过有一个现象，mAP比top1提高的多，说明这种基于g2g关系的方法，通常是用得分较高的gallery图像把gallery中得分比较低的对象拉上来了。

SGGNN

![SGGNN result](https://upload-images.jianshu.io/upload_images/1828517-bee386b73d9e9d3e.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

结果也跟random walk类似。

## 总结
将graph之间的关联融合到神经网络训练中提供了更丰富的监督信号，基于Graph的方法虽然结果上提升不明显（可能是baseline太强了吧），但创新性是有的。
