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

* Ubuntu nautilus 文件浏览器中，Ctrl + L可以将地址变为字符串方便复制

* Ubuntu 16.04发wifi
  - 参考这个[教程](http://ubuntuhandbook.org/index.php/2016/04/create-wifi-hotspot-ubuntu-16-04-android-supported/)

* 解压zip乱码
  - 使用
```shell
unzip -O CP936 xxx.zip
```

* 导入全局证书
```shell
sudo cp your.crt /usr/share/ca-certificates/your.crt
sudo dpkg-reconfigure ca-certificates
```

然后编辑 `/etc/ca-certificates.conf`

然后 
```python
sudo update-ca-certificates
sudo dpkg-reconfigure ca-certificates
```

* Ubuntu kernel 更新后无法登录循环登录
  - 新装了显卡驱动，然后发现过了几天重启就没法登录了，ssh可以登录，-X 登录提示 .Xauthority unwritable
  - 重装NVIDIA显卡驱动，home目录下删除.Xauthor\*几个目录
  - 重启，问题解决
  
  
* 安装NVIDIA官方驱动
  - 根据自己显卡下载对应驱动:http://www.nvidia.cn/Download/index.aspx?lang=cn
  - ctrl alt f1进入命令行模式，运行如下命令：
```shell
sudo service lightdm stop
sudo ./NVIDIA-Linux-x86_64-367.57.run
```
  - 一路确定
  - 然后sudo reboot
  
* 卸载Nvidia官方驱动

> 卸载，很简单，加上 --uninstall 选项再运行一遍安装程序就可以了。例如：假设你的安装程序是 NVIDIA-Linux-x86-169.12-pkg1.run 的话，在 root 下键入 ./NVIDIA-Linux-x86-169.12-pkg1.run --uninstall 就可以卸载了。欲了解安装程序的更多选项，请使用 ./NVIDIA-Linux-x86-169.12-pkg1.run -h 或 ./NVIDIA-Linux-x86-169.12-pkg1.run -A 进行查看。

