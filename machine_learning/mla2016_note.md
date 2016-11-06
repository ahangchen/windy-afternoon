# MLA2016 南京
## 开幕式
- ppt会在[网站](http://lamda.nju.edu.cn/conf/mla16/program.htm)上共享
- 每年的会议也会由清华大学出版社整理为《机器学习及其应用》一书
- 公众号：MLA2016

> 以下笔记整理与会议期间，主要关注机器学习应用方向，对于一些比较小众或者高深的topic，由于个人水平有限，会跳过一部分不讲。

## Presentation（11月5日）
### 分布式学习 
- 背景
  + 大数据分布式学习介绍
  + 大数据自然地分散存储
- 问题
  + 数据分为子集，子集运算，output平均
  + 分布式结果与单机运算结果理论上是否应该近似？？
- 常用方法
  + 最小二乘回归：最小化预测与实际值差异 - 过拟合 - 假设空间
  + 假设空间越大学习效果越好
  + 具体应用时假设空间会被限制
  + 目标函数要学好，需要与kernel空间有联系，具体关系由一个函数描述
  + kernel空间
  + 假设空间越大，函数光滑性越好

- 回归分布式学习
  - 函数复杂度：λ趋向无穷的速度
  - 衡量学习算法的好坏 

- 单机结果与分布式结果的误差由一个公式描述，这个公式表述了：
  - 分布式能达到单机效果
  - m一般越大越接近单机结果，分的多variance越小，但不能分到底，要有一个限制
- 数学上的问题：最小二乘回归能得出minimize rate吗？用二次分解解决

- 深度学习困境：
  - 黑箱：强加条件可能有效但不明所以
  - 浅层神经网络做不了局部近似，两层可以做到，三层与两层效果往往有很大差别，但不明所以
  - 希望从数学上说明更多层数能获得许多不同的结构层次信息
    - 内积学的是多个方向上的东西，多层时方向维度信息指数增加
  - sgd
  - 在经典结构上加些几何结构能学到数学上对应的结构
  - minor gradient
  - 深度网络，函数有结构才能学得好

### ML in NLU，CL，NLP
- NLP && DL
- 机器翻译，情感分析，自动摘要，问答系统，关系抽取
- 挑战
  - 未知现象太多
  - 歧义，双关，隐喻
  - 跨文化语义
 - 方法
   - 规则：词法，词性
   - 统计：概率，贝叶斯，语言模型，翻译模型，解码器
     - 分词-短语-翻译-调序
   - 常用方法，开源工具
   - example：
     - 由字构词，识别词的位置做为特征，进一步得到词义
     - 词义消岐，词性，位置
     - 文本分类，分类器组合
- 深度学习
  - RBM无监督做图像，HMM语音识别的突破
  - 词向量
   - one hot 相乘为0！
   - 近似词放在相近的地方
   - 词表规模， 词向量维度的确定
   - 词向量获取CBOW，etc
  - 句子语义表达：RNN，attention（在句子中的重要性，可用眼动仪测量）
  - 翻译：生词 - 概率优化 - 同义词 - 拆词 - 补词
- 《统计自然语言处理》宗成庆
  - 深度学习不等于深度理解
    - 难以全文分析，就缺乏归纳推理
    - 常识学习
  - 深度学习泛滥，应该多考虑其他机器学习方法的出路

### 忆阻
- 硬件模拟大脑计算
- 内存基于电容，易失，忆阻不易失
- BP更新权重需要用外部电路辅助实现

## Spotlight
- hulu：CF-NADE神经网络协同过滤推荐
- CNN可视化，随机权重少量训练，重构图像，验证ML也不一定需要大量训练 **
- 估计光泽量，反射量，考量对数变换
- 深度网络缩小文本与图像的语义差异，再映射？？
- 迁移学习：模型的联合概率分布有差异
- 高维非凸最优化
- 函数偏移值强化学习
- 异构人脸识别
- loss function求和优化，共享内存异步优化
- 深度学习+哈希学习
- 蒙特卡罗预测状态

## Presentation 11-06
### 迁移学习 kernel embedding of distribution
- 分类聚类，增强学习
- wifi室内定位，N个路由器，N维向量，
  - 连续空间：回归问题
  - 设备移动，记录位置和路由器强度
  - 回归学习定位系统
  - WiFi对温度敏感，所以强度会发生变化，不同目标设备也会影响强度值
  - 使用迁移学习，让后来的设备适配先前的设备模型
- 情感分析
  - 用户情感词可能很多种，不同产品会有不同类型的情感词
  - 添加enable标签
- Bug predict

- 机器学习强假设：训练与测试数据需要来源相同，分布相同，特征相同
- 其实我们只需要收集一些enable数据和一点feature数据（半监督）
- 添加迁移学习方法预测target
- 异构迁移，同构迁移
- 监督迁移，半监督，无监督迁移
- 基于样本迁移学习
  - source跟target在数据集上有重叠
- 基于特征迁移学习
  - 训练集与测试集只有一部分重叠特征
  - 特征映射到一个空间，在这个空间训练集与测试集接近
- 基于参数迁移学习
  - 可能迁移目标与源在参数上相近
- 基于关系迁移学习
  - source和target在数据之间的关系可能相同

- 通用的基于特征的迁移学习
  - source和target结构相似，
  - 假设它们有潜在的相同因子
  - 去掉一些因子，使得数据的分布不变，那这些因子就是它们的共同特征
  - 同时还要尽量保持原来的数值
  - 最小化source和target分布的差异
  - RKHS
  - 找一个向量代表一组数据
  - 增加多维统计信息比如(E[x] E[x2] ...)
  - 无穷维，用核函数形式展示

### 搜索引擎信息检索
- 略

### 可视化特征学习与表达
- 特征的寻找，低维表达高维图像数据 - 子空间
- 稀疏特征表达 **
- 人脸 - 关键点定位 - 让模拟关键点与实际关键点误差最小，先拟合再回归
- CSR
- hypergraph base：feature hyper edge： 轮廓
  - 空间大，边不能自适应非均匀自适应分布

### Bug mining
- 自然语言与程序语言存在不同
- 需要根据问题本身进行设计

### 多任务学习
- school数据集：每个学校单独预测，多个学校同时联合训练
  - 弥补训练数据的缺失
- 训练过程中多任务联合，抓住任务间联系，建模，预测
- 重点在任务之间的关联
  - 假设所有任务相似
    - 假设所有任务参数向量接近，让所有任务共享方差，简单，假设太强
  - 特征空间相似
    - 共享同一组特征：所有任务都会使用特征中的某一部分，group sparsity l1,q norm 规范化，最小化norm，使得共享稀疏特征
  - 共享低维子空间
    - rank minimization，增加一个rank项，rank最小化
  - 共享结构，聚簇，图，树
    - 聚簇：同一个族中的任务距离更相近
  - 学习外围任务

- 避免无关因素影响
- 约定
  - 每个任务有一个特征矩阵，不同任务样本数量不同，矩阵长度不同，但所有任务的特征相同，矩阵宽度相同
  - 每个任务有一个参数向量
  - 用以上符号表达几乎所有多任务模型
  - 损失：正常的预测与实际值的偏差
  - 规范化参数

- 然而上述假设都有点强，需要分开：W = P + Q，任务由相关部分和不相关部分组成
  - l2 norm，在Q中让有些列为0，表示有些列是有特异性的

- 任务之间的关系：task-level（这种假设还是比较强）
- feature-level：任务在某些特征上是否相关，有何相关

> 协同聚类

- 规范化项
  - 仍然W = P + Q模型
  - Q描述协同聚类效果
  - 模拟任务与特征之间的协同聚类
  - Q的一个行是一个特征，Q的一个列是一个任务
  - 在Z向量上聚类
  - 两个规范化项
  - 第二个规范化项是非凸的，需要CoCMTL优化

- 优化
  - Low rank MTL
  - 为求解添加核范数 nuclear norm，做一个松弛
  - 矩阵信息主要由奇异值大的特征向量表达，很受核范数影响，产生负面因素
  - 在核范数前增加权值，奇异值越大，权重越小，权值自动优化，需要设计优化算法
  - 这个权重也是非凸，但物理意义更接近矩阵的秩
  - 权值的优化：近似非凸函数，随机权值，逐步调节
  - 权值优化收敛性：一定会收敛，收敛速度还可以

- 轨迹回归
 - 一个序列，含有多个路段的数据，预测通过路线的时间
 - n 个轨迹对，每个路段的行驶距离，需要预计走过每个路段的时间
- 挑战：
  - 不同时间走过一个路段的耗时是不同的
  - 轨迹数据非常稀疏
  - 训练样本有限
  - 不能单任务
- 将序列按时间划分成多个子集，每个时间段的预测分别为一个任务（比如早高峰一个任务，晚高峰一个任务， 平常时间为一个任务）
  - 相邻时间代价变化光滑，存在全局光滑性
  - 存在局部突出变化
- 分解
  - P 模拟全局平滑性质
  - Q 抓住局部性质
  - P 时间上的平滑性，空间上的平滑性
  - Q 异常现象，l inf,1 范数，达到列稀疏效果，描述了某些任务与其他大部分任务之间的区别
    - 高峰代价由全路段最大代价决定
- 建模完成
- 优化非平滑，需要近似
- 苏州出租车行驶数据，6W轨迹信息
- Q矩阵每列的最大值画出来，几乎描述了高峰的局部现象

### 大数据
- 核心：分析处理
- 大数据分析与处理的核心基础，搭建新平台，研发新算法
- 数据预处理，算法工程化
- 处理：计算机为基础
- 分析：数学为基础
- 基于全数据中心估计
- 基于数据分解的分布估计
- ADMM
- 理论决定深度结构
- 模型族决定假设空间
- 深度学习解决模型选择与参数选择
- 解反问题的一个新思路：模型求解与范例学习

### 自适应动态规划 - 学习控制
- 略

### 人脸识别
- triplet loss不需占用额外显存
- seetaface

## Spotlight
- 社交影响驾驶行为
  - 车联网
  - 司机之间的社交分享提高司机经验
  - 启发：在同一个地方都停留超过10分钟，就可能是有社交关系
  - 2013纽约出租车行驶数据集
  - 从行为模式建模出社交关系
  - 用社交关系得到权重作用于行为模式预测
  - 行为模式得到轨迹

## Special Session

> 顶会Review(以下环节中paper部分表示很值得关注的paper)

- ML
  - ICML
    - 神经网络，深度学习，优化，再增强学习，矩阵构造，无监督学习，在线学习，学习理论，应用
    - 过去十年最有影响文章：dynamic topic models
    - rnn,采样，动态组织模型深度强化学习 
  - NIPS
    - 论文数取决于场地。。
    - learning，model, network，optimization，deep， inference，贝叶斯
    - 顶会有tutorial，tensorflow，NVIDIA gpu介绍
    - 邀请牛人分享
    - workshop：bayesian, application, deep learning, new areas, others
    - Paper: 
      - Competitive Distribution Estimation: Why is Good-Turing Gooding good
      - Fast Convergence of Regularized Learning in Games
    - startup:
      - ai startup: openai was founded
    - hot areas: new models: optimization for dl , bayesian, reinference
    - adaptive data analysis: 实验不可泛化，需要避免
    - review: 每篇论文有六个reviewer，review会公开（重要）
    
  - COLT
    - 计算机理论文章进入这个圈子
    - 十大机构占半
    - 一小群数学家在这里开会
    - bandit, 计算机理论，online, 限制学习， 监督学习,pac
    - 两个invited talk
    - Paper: 
      - Multi-scale exploration of convex functions and bandit convex optimization
      - Provably manipulation-resistant reputation systems (协同过滤)
    - dl：理论：
    - the power of depth for feedforward neural networks
    - benefits of depth in neural networks
    - on the expressive power of deep learning: a tensor analysis
    - 深层少节点可行，浅层多节点才行
    - Paper
      - Online Learning in Repeated Auctions: 拍卖，true value unknow the true value
      - Learning Simple Auctions：证明多项式级样本可以达到买卖平衡
- AI
  - AAAI
    - tripleAI
    - topic: machine learning method, ml app, 博弈论,
    - 计算机视觉，web，nlp, 认知模型
    - 启发式，多智能，不确定，规划调度
    - 鲁棒AI
    - paper:
      - Bidirectional Search  That  Is  Guaranteed  to  Meet  in  the Middle
      - Toward  a Taxonomy  and Computational Models  of  Abnormalities in  Images
    - What is hot: meeting and competitions
  - [IJCAI](http://ijcai-16.org/index.php/welcome/view/accepted_papers)
    - deep learning渐弱
    - 传统领域review比较多，ml review少
    - ml, ai arguement 少
    - 投稿时解释清楚问题
    - co-author list投稿后一般不可变
    - 限制author投稿数量
    - knowledge graph, knowledge base
    - paper: 
      - Hierarchical Finite State Controllers for Generalized Planning
      - Using Task Features for Zero-Shot Knowledge Transfer in Lifelong Learning
- DM
  - [KDD](http://www.kdd.org/kdd2016/program/accepted-papers)
    - sigkdd
    - talks多
    - classical ml , techniques still , pronounce for solving dm tasks
    - graph, streawm, heterogeneous
    - clustering, neural network
    - paper:
      + FRAUDAR: Bounding Graph Fraud in the Face of Camouflage
      + Ranking Causal Anomalies via Temporal and Dynamical Analysis on Vanishing Correlations
      + TRIEST: Counting Local and Global Triangles in Fully-Dynamic Streams with Fixed Memory Size
      + Predicting Matchups and Preferences in Context
    - kdd有点看author
    - graphs over time:densification laws, shinking dismeters
    - kdd china: acm 数据挖掘中国分会
  - [ICDM](http://www.cs.uvm.edu/~icdm/Awards/BestPapers.shtml)
    - 数据挖掘blabla
    - 盲审,关注可重现性
    - Paper
      - Fast Random Walk with Restart and its Applications
      - Diamond Sampling for Approximate Maximum All-pairs Dot-product (MAD) Search 
      - From Micro to Macro: Uncovering and Predicting Information Cascading Process with Behavioral Dynamics 
    - 新应用，正面的论文title，
    - 不要早于两周提交，
    - 多跨界合作
    - 神经网络，学习 ⬆️
- Other
  - ISCA
    - 处理器架构
    - 寒武纪团队
    - 深度学习处理器
  - AI statistics↑
    - ai, ml, statistics
    - 在美国受认可
    - \<4人审核，逐层审核
    - 高斯，图模型，优化，在线学习，聚类，矩阵，推理，贝叶斯，压缩感知，稀疏编码，深度学习
    - 半监督，nonlinear embedding and manifold learning , semi-supervised learning ↓
    - Paper
      - Provable Bayesian Inference via Particle Mirror Descent

  - UAI
    - AI的不确定性
    - 图模型，贝叶斯，因果推断
    - Paper
      + Stability of Causal Inference
      + Online learning with Erdos-Renyi side-observation graphs
    - bayesian, reinforce, optimization
    - 非凸问题，凸近似
    - 深度神经网络自由度
    - 理论理解，迁移学习中协同矩阵重构
    - 因果发现，贝叶斯应用，ml on health
    - 外国比较火，DL不太火 
  - ICLR
    - 小
    - emergeing
    - dl
    - open review
  - ACML
    - 亚太
    - 长文16页
    - 4-5 review
    - 两轮投稿
    - 会议转期刊 -> MLJ
    - ML
  - SIGIR
    - 信息检索
    - ML
    - search new trend from google
    - IR
      - Matching
      - Translation
      - classification
      - structured predicction
    - Word Embedding, rnn, cnn
  - ACM multimedia
    - 多媒体
    - 多个投稿方向
    - 视觉，多媒体搜索，，
    - DL on Multimedia，图片检索，视频分析
    - 图像视频自动描述
    - 多模态社交媒体主体意见挖掘
    - CNN分析菜肴
  - CVPR
    - CV
    - 应用Dl
    - 3D
    - 紧密结合工业界
    - 主题提取
    - 视频问答
    - imagenet
  - ICCV
    - CV
    - 提前投
    - DL ↑
    - Track
  - ACL
    - 计算语言学、自然语言处理
    - 工业界应用
    - 双盲审
    - 语义，语法，ML，资源与评估
  - ACM SIGGRAPH
    - 图形学顶会
    - 工业界，艺术界
    - TOG
    - Geometry
    - Animation
    - Human Model
    - 3d print, image processing， render↓
    - VR, AR, ML
    - novelty
    - 视觉效果
