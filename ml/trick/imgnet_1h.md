# Accurate, Large Minibatch SGD
# Training ImageNet in 1 Hour

---

### Main Idea
- Higher training speed requires larger mini-batch size.

> 8192 images one batch, 256 GPUs

- Larger mini-batch size leads to lower accuracy
- Linear scaling rule for adjusting learning rates as a function of minibatch size
- Warmup scheme overcomes optimization challenges early in training

---

### Background
- mini-batch SGD
- Larger mini-batch size lead to lower accuracy.

---

### mini-batch SGD

![](mbgd.png)

---
### mini-batch SGD
- Iteration(in FaceBook Paper):

![](msgd_fomula.png)

- Convergence:
  - Learning Rate: ![](https://www.zhihu.com/equation?tex=%5Cgamma+%3D+1%2F%5Csqrt%7BMK%5Csigma%5E2%7D)
  - Converge Speed: ![](https://www.zhihu.com/equation?tex=1%2F%5Csqrt%7BMK%7D)

  >  M: batch size, K: iteration number, σ²:  stochastic gradient variance

---

### Goal
- Use large minibatches
  - scale to multiple workers
- Maintaining training and generalization accuracy

---

### Solution
- Linear Scaling Rule: When the minibatch size is multiplied by k, multiply the learning rate by k.

### Analysis
- k iteration, minibatch size of n:
![](k_nsgd.png)
- 1 iteration, minibatch size of kn:
![](kn_sgd.png)
- Assume gradients of the above fomulas are equal
  - Two updates can be similar only if we set the second learning rate to k times the first learning rate.

### Conditions that assumption not hold
- Initial training epochs when the network is changing rapidly.
- Results are stable for a large range of sizes, beyond a certain point
![](size-acc.png)

---

### Warm Up
- Low learning rate to solve rapid change of the initial network.
- Constant Warmup: Sudden change of learning rate causes the training error to spike.
- Gradual warmup: Ramping up the learning rate from a small to a large value.
- start from a learning rate of η and increment it by a constant amount at each iteration such that it reaches η̂ = kη after 5 epochs.

---
### Reference
- [Accurate, Large Minibatch SGD: Training ImageNet in 1 Hour](https://research.fb.com/wp-content/uploads/2017/06/imagenet1kin1h3.pdf?)
- [机器之心提问：如何评价Facebook Training ImageNet in 1 Hour这篇论文?](https://www.zhihu.com/question/60874090)
- [Asynchronous Parallel Stochastic Gradient for Nonconvex Optimization](https://arxiv.org/abs/1506.08272)
- [ENTROPY-SGD: BIASING GRADIENT DESCENT INTO WIDE VALLEYS](https://arxiv.org/pdf/1611.01838.pdf)
