# Matlab Remote IPC 实现数据自动化处理
> 转载请注明作者[梦里茶](https://github.com/ahangchen)

## 需求
在研究中遇到这样一种需求，
- 在Matlab端做GPU运算；
- 在Python端做数据清洗和数据分析；
- 两端分属两个服务器；
- M端需要等待P端完成数据清洗才能开始做训练和预测
- P端需要等待M端完成训练和预测才能做数据分析

## 问题
- 数据很多，不适合将两端合并到一个服务器上
- 存在增量训练，对同一份数据，可能要结合多份额外数据进行N次传输
- 由于采用10折交叉验证，数据划分为10份，总共要进行10×N次传输
- M端和P端都需要各自运行一段时间才能出结果，需要等待，说快不快，说慢不慢

> 上面的几个点使得训练的过程非常繁琐耗时

## 探索
作为不耐心而且懒的程序员，超过15秒的事情就想要自动化，于是开始想能不能把上面这个过程自动化

### 方案一 用一种语言重写另一方的代码
- Python端逻辑复杂，与数据关联密切，重构为Matlab代码工程量大（而且我还是比较熟悉Python）
- Matlab端是某篇论文的代码，使用了MatConvNet这个库做CNN，用Python实现工程量也很大，而且因为是别人的代码，还可能有很多未知的坑

### 方案二 使用[第三方库](http://mlabwrap.sourceforge.net/)作为Lib相互调用
- 由于Matlab端涉及GPU运算，配置比较复杂
- 作为库相互调用使得两个模块的耦合增加，不符合解耦原则
- 需要编写接口代码

### 方案三 Matlab和Python进行进程间通信
- 进程间通信要求两边各有一个可执行程序，但是Matlab打包麻烦（需要下另一个收费的打包工具）具体看[这里](https://www.youtube.com/watch?v=6b_NmBEW9ak)，在GUI界面中操作相对方便，并且打包后不好调试
- 远程进程间通信有许多方案可以选择，例如socket，这个工作量比上面的方案小，但也需要额外编写一部分功能代码

### 方案四 (Final)使用Matlab进行执行shell命令进行scp，以文件的方式进行数据传输
- 改动的代码最少
- 依旧是两个模块，依旧低耦合
- 通信性能没有库调用或者Socket那么好，但程序主要性能瓶颈不在数据传输，而在于训练和预测，所以没关系
- 执行ssh的时候可以同时执行另一个服务器上的命令，从而调用Python端脚本进行Python端工作

下面具体讲方案四的实现

## 实现
### Matlab执行shell命令
```matlab
setenv('d_name', dataset_name);
setenv('std_idx', num2str(i));
% transport raw image predict data
!env LD_LIBRARY_PATH='' scp ${d_name}_train.log cwh@192.168.231.171:/home/cwh/coding/Project/data/${std_idx}-train/renew_pid.log
!env LD_LIBRARY_PATH='' ssh cwh@192.168.231.171 "cd /home/cwh/coding/Project; python data_analysis.py data/${std_idx}-train"
```

其中
- 通过setenv来设置环境变量，从而动态决定要执行的脚本的内容
- 在matlab代码中，使用`!`开头，代表这是一行shell命令
- 需要把LD_LIBRARY_PATH这个环境变量置为空，防止使用matlab自带的一些lib，导致ssh等命令执行失败

### SSH
- Matlab是有一个[库](https://cn.mathworks.com/matlabcentral/fileexchange/27999-ssh-from-matlab--updated--+-sftp-scp)可以做ssh和scp的
- 但是，不想把密码写在代码里，并且懒得去用第三方的东西
- 于是想直接用shell调用
- shell调用有一个老大难的问题，就是需要输密码
- 受Hadoop分布式配置的启发，发现可以做ssh免密码配置，避开输密码的问题
- 免密码具体参考这个[教程](https://my.oschina.net/aiguozhe/blog/33994)
- ssh配置免密之后，scp也是免密的，另外还有一个好处，ssh可以通过`""`来嵌入ssh之后要执行的代码，从而做Python调用

### Python
- 如果之前Python端是用IDE开发的，转为shell调用就要注意两个问题
  - 路径，cd到正确的目录，Python端的文件操作和lib import的相对路径是相对于要执行的py文件
  - 库
   ```shell
    # 加载对应的库
    env LD_LIBRARY_PATH='/your/lib/path/sth.so'
    ```
  - 命令行参数，参考这个[教程](http://lingxiankong.github.io/blog/2014/01/14/command-line-parser/)

### 同步控制
- 由于matlab调用shell命令时会陷入等待，会等待命令完成再执行下一步，不像socket发完消息后不知道什么时候另一边运行结束，所以不需要自己实现排队等待同步互斥的东西
- 如果需要在等待的时候做些并发，可以考虑[matlab 并行工具箱](http://blog.sina.com.cn/s/blog_45eac6860100lzlk.html)，结合Python端的并发几乎就是一个分布式框架了，有空再深入去搞一搞

## SUMMARY
- matlab调shell
- shell中ssh做远程进程调用
- scp做数据传输
- 效果：尽可能轻量地解决自动化的问题
