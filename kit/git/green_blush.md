# 刷遍小绿点

转载请注明出处：https://ahangchen.gitbooks.io/windy-afternoon/content/kit/git/green_blush.html

工程[地址](https://github.com/ahangchen/green)，欢迎star!!!

> 大家都知道，可以从Github上的小绿点看到这个人在Github上的提交代码情况，然而，这天却发现了这样一个bug：

首先github统计小绿点的逻辑是这样的：[戳](https://help.github.com/articles/why-are-my-contributions-not-showing-up-on-my-profile)

然后，某次因为某些原因删工程，发现，对应的小绿点也不见了，并且streak时间也变了

于是猜想，删resp会减小绿点，加resp呢？

于是猜想，删仓库会减小绿点，加仓库呢？

- 测试一下，加回来刚刚删的工程，立竿见影，过去日期的小绿点又回来了。

> 说明，小绿点的时间与push时间没有关系，而是与commit时间相关。

- 再做一个测试，修改系统时间为A，commit，push，发现小绿点出现在A时间点

> 说明，小绿点的时间与git commit时的本地时间相关

于是衍生了这个工程，python脚本刷遍小绿点=。=

> 程序员就是懒啊。。。


改系统时间，commit！

![img](snap.png)

* 这个工程有两个模块，green和heavy，分别实现地毯式浅色提交与集中式深色提交

###green
> 浅色提交

修改green.py中，main部分传入你需要刷的起始时间和结束时间，

```python
if __name__ == '__main__':
    daily_commit(datetime.date(2015, 3, 31), datetime.date(2016, 1, 28))
```

在green目录下，

```
sudo python green.py
git push origin master
```

就能通过修改系统时间实现过去的commit，从而刷遍过去的小绿点（如果是fork工程而不是自己的工程，要提PR）

> 因为修改系统时间使用了date命令（我的环境是ubuntu，windows要用另外的命令），所以要用sudo提高权限执行，否则执行后都是今天的commit

###关键代码
```python
def trick_commit(year, month, day):
    set_sys_time(year, month, day)  # 设置系统时间
    modify()  # 修改文件
    commit()  # 调用git commit
```
具体每个函数的实现可以看green.py，主要是通过系统调用实现

###heavy

> 深色提交

在heavy.py中，main部分传入小绿点方阵最左上角（第一列周日）的日期，要commit的文件所在的目录，配置文件的目录，即可做深色提交

```python
if __name__ == '__main__':
    love_commit(datetime.date(2015, 3, 1), '/media/Software/coding/python/loveci/only.you', 'etc/love')
```

关于配置文件
- 特殊形状通过etc目录下的文件中，配置想要commit的index来实现，当前etc中的love可以实现I ❤ U的效果

- 可以通过这个android工程方便的得到需要commit的index：[grid](https://github.com/ahangchen/grid)

> 这些index的含义是，从github小绿点方阵左上角第一个位置（第一列周日的位置），往后的天数

> 建议新建另一个工程，对它做提交，这样可以通过删除那个工程来达到去掉错误提交的效果，我的heavy工程是 [love](https://github.com/ahangchen/love)

> 似乎是因为git commit的本地记录有上限，一次提交太多commit而没有push，最前面的一部分的commit会丢失，所以一次push的commit不要太多哦，否则就要改配置文件再push一下来补上了

今天还发现一个现象，修改github上自己对应的邮箱，commit记录也会变化，也就是，如果关联了一个有很多commit记录的邮箱，就会自然地有很多小绿点了吧

> 最后，致敬明知Streak有bug，但仍然坚持Streak的人。
