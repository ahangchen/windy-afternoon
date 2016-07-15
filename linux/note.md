##Linux Note

* 用 &&组合两个命令，比如：

 > cd dir && ls

* ubuntu换源后，务必执行
> sudo apt-get clean && sudo apt-get autoremove
清除cache

 * vsphere client 中修改ubuntu控制台大小
 - 先按这个link操作：http://jingyan.baidu.com/article/fc07f98977b60f12ffe5199b.html
 - 然后在系统设置中修改屏幕分辨率，就能调整到比较适合的尺寸。
 
* 一行代码统计代码行数
```shell
find . -iregex ".*\.\(cpp\|h\|java\|sh\)$" | xargs wc -l 
```
想要增加统计的代码类型，就在正则表达式里填后缀就好

* 开启后台进程并脱离terminal生命周期
有时候我们会想要开启后台进程，往往会用&的符号，但这样开的进程在关闭terminal的时候也会被杀死，因此还要加一个disown，解绑进程和终端：
```shell
./test.sh & disown
```

* Ubuntu 全局代理

系统设置-网络-代理设置-手动-填自己的代理服务器地址和端口即可

* Ubuntu desktop应用设置环境变量
直接上代码

```
[Desktop Entry]
Version=1.0
Type=Application
Name=Pycharm
Exec=env LD_LIBRARY_PATH=:/usr/local/cuda/lib64:/usr/local/cuda/lib64 /home/cwh/software/pycharm-2016.1.4/bin/pycharm.sh
Icon=/home/cwh/software/pycharm-2016.1.4/bin/pycharm.png
Name[zh_CN]=Pycharm
```

* Ubuntu控制端远程登陆另外的设备

  - 可以考虑remmina，或者rdesktop，
  - remmina是ubuntu自带的，启动和配置可以通过图形化界面实现，并且持久化配置信息
  - rdesktop需要自己另外安装
```
sudo apt-get install rdesktop
```
  - 安装后通过参数启动远程，启动后的远程比remmina好看，例子:[使用rdesktop远程并设定分辨率](http://blog.sina.com.cn/s/blog_408184cf01010qpw.html)
  - 比较喜欢rdesktop，有空写一个shell程序来保存配置

* Ubuntu SSH带界面
```
ssh -XC user@host
```

* Ubuntu被控端允许远程
  - sudo vino-preferences，允许远程
  - 安装远程桌面环境
```
sudo apt-get install xfce4
sudo apt-get install xrdp vnc4server
echo "xfce4-session" >~/.xsession
sudo service xrdp restart
```

* 共享代理给手机
  - 条件一：电脑能科学上网（我用了xx-net）
  - 条件二：电脑和手机处于同一个局域网里
  - 操作：在xx-net的目录中搜索proxy.ini，将ini中，127.0.0.1改成0.0.0.0
  - 查看自己电脑的ip
  - android手机wifi连接那里，设置代理，设置ip为电脑ip，端口为8087(xx-net的代理端口)
  - end

* Ubuntu 系统设置-网络-网络代理-手动-设置成xx-net的代理地址即可全局翻墙

