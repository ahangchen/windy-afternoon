## Git / github
### 创建github repos并提交修改（2016-1-9 ）

在[这里](https://github.com/new)创建一个repos，

进入终端，cd到一个目录下，这个目录用来放等下clone的工程
```
git clone https://github.com/ahangchen/AndroidApps 
```
> 这是你新建的repos的地址，从网页地址栏复制出来就好了

可以在刚刚那个目录看到clone下来的repos,比如我这里clone的就是一个空的目录，叫做AndroidApps

随便对这个目录做你想要的操作，我这里放了一个Ink.apk进去  
```
cp ../Ink.apk Ink.apk
```
添加到git的管理下： 
```
git add Ink.apk
```

提交当前目录到git： 
```
git commit -m 提交的注释
```

查看状态（非必须）： 
```
git status
```
提交到github：
```
git push -u origin master *(第一次提交需要加-u建立关联，以后只需要git push origin master)
```
输入github帐密就好了，重新到浏览器看你的工程，是不是有新的文件了？

对了，如果需要拉到服务端的更新，使用git pull即可。
```
git pull
```
发生冲突时，可以打开冲突文件，看到冲突的地方，修改冲突后，可以
```
git commit 冲突的文件 -m comment
```
然后
```
git push origin master
```

### 将本地库和远程库关联
由于我们常有这样的需求，在IDE里创建工程，然后想要推到自己的git服务器上，但IDE通常不支持直接推到github之外的git服务器，所以需要通过git命令来实现。

以开源中国git为例：
- 在git.oschina.net创建一个项目：WeMeet，地址：http://git.oschina.net/underarmy/WeMeet
- 在PyCharm创建一个Django项目：WeMeet
- 在PyCharm中Enable Version Control，选择 git 方式
- 进入终端:
```
cd WeMeet
git remote add origin https://git.oschina.net/underarmy/WeMeet.git
git branch --set-upstream-to=origin/master
git pull
git push origin master
```
然后就可以愉快的在IDE里做正常的git操作了。

### github streak终结者

教你刷爆小绿点：[戳](green_blush.md)

### Git new branch
```
git checkout -b new_name
## 如果没有新的远端就不用执行这句
git push origin new_name
# 用来pull
git branch --set-upstream-to origin/makfus makfus
```

### Git push Terminal免密码
- 原理为ssh免密码登录，具体见SF这个[回答](http://stackoverflow.com/questions/8588768/git-push-username-password-how-to-avoid)
