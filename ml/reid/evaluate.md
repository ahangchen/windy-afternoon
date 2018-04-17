## Person Re-id评价指标
- Rank Accuracy：
  
  将gallery中的图片，按照与probe图片的相似度排序，如果在第X个之前就命中，则rankX命中数+1, rankX命中数/probe图片总数则为rankX acc，rankX有时又名为topK，当gallery中存在junk image时，命中junk image时跳过。

- mAP: 
  
  信息检索中的mAP：
  
  对probe中的每个图片，计算一个AP，取平均为mAP，AP为P的均值，P的含义为，probe对应的目标中，第k个命中时，前k个结果中的命中率。
  
  举例：假设有两个主题，主题1有4个相关网页，主题2有5个相关网页。某系统对于主题1检索出4个相关网页，其rank分别为1, 2, 4, 7；对于主题2检索出3个相关网页，其rank分别为1,3,5。对于主题1，平均准确率为(1/1+2/2+3/4+4/7)/4=0.83。对于主题2，平均准确率为(1/1+2/3+3/5+0+0)/5=0.45。则MAP= (0.83+0.45)/2=0.64。
  
  在market1501的评估代码里有另一种计算mAP的方法（可见于[Liang Zheng的综述](https://arxiv.org/pdf/1610.02984v1.pdf)），是求Precision-Recall曲线的面积。这是用[Pascal VOC 2007(The PASCAL Visual Object Classes (VOC) Challenge)的算法](https://link.springer.com/content/pdf/10.1007%2Fs11263-009-0275-4.pdf)，计算的是Precision-Recal曲线下的面积，与信息检索领域计算每次命中时准确率的平均值不同
