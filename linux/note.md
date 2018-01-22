## Linux Note

### 临时切换到root用户

> sudo su

### 用 &&组合两个命令，比如：

 > cd dir && ls

### ubuntu换源后，务必执行
> sudo apt-get clean && sudo apt-get autoremove
清除cache

### vsphere client 中修改ubuntu控制台大小
 - 先按这个link操作：http://jingyan.baidu.com/article/fc07f98977b60f12ffe5199b.html
 - 然后在系统设置中修改屏幕分辨率，就能调整到比较适合的尺寸。

### 一行代码统计代码行数
```shell
find . -iregex ".*\.\(cpp\|h\|java\|sh\)$" | xargs wc -l
```
想要增加统计的代码类型，就在正则表达式里填后缀就好

### 开启后台进程并脱离terminal生命周期
有时候我们会想要开启后台进程，往往会用&的符号，但这样开的进程在关闭terminal的时候也会被杀死，因此还要加一个disown，解绑进程和终端：
```shell
./test.sh & disown
```

### Ubuntu 全局代理

系统设置-网络-代理设置-手动-填自己的代理服务器地址和端口即可

### 导入全局证书
```shell
sudo cp your.crt /usr/share/ca-certificates/your.crt
sudo dpkg-reconfigure ca-certificates
```

或者编辑 `/etc/ca-certificates.conf`

然后
```shell
sudo update-ca-certificates
sudo dpkg-reconfigure ca-certificates
```


### Ubuntu desktop应用设置环境变量
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

### Ubuntu控制端远程登陆另外的设备

  - 可以考虑remmina，或者rdesktop，
  - remmina是ubuntu自带的，启动和配置可以通过图形化界面实现，并且持久化配置信息
  - rdesktop需要自己另外安装
```
sudo apt-get install rdesktop
```
  - 安装后通过参数启动远程，启动后的远程比remmina好看，例子:[使用rdesktop远程并设定分辨率](http://blog.sina.com.cn/s/blog_408184cf01010qpw.html)
  - 比较喜欢rdesktop，有空写一个shell程序来保存配置

### Ubuntu SSH带界面
```
ssh -XC user@host
```

### Ubuntu被控端允许远程
  - sudo vino-preferences，允许远程
  - 安装远程桌面环境
```
sudo apt-get install xfce4
sudo apt-get install xrdp tightvncserver
echo "xfce4-session" >~/.xsession
sudo service xrdp restart
```

- 其中xfce4 tab键默认会因为键位冲突不能自动补全，需要执行 `xfwm4-settings`，在 按键 - 切换同一应用程序的窗口，清除它的快捷键
- 可以[修改xfce的主题](https://blog.gtwang.org/linux/xfce-theme-manager-xubuntu/)
- 可以修改vncserver分辨率：

```
vncserver -geometry 1920x1080
```
这样就能启动一个指定分辨率为1920x1080的vnc会话


- 如果需要在mac上远程Ubuntu，需要在Ubuntu上开启vncserver: 命令行输入vncserver(初次运行输入设置密码)，并将~/.vnc/xstartup文件改为：

```shell
#!/bin/bash
xrdb $HOME/.Xresources
startxfce4 &
```

以此解决花屏问题

- 关闭一个vncserver：

```shell
vncserver -kill :k
```

k是你的vncserver的编号，比如端口号5904的vncserver应该是4

在各个平台上可以下载[vncviewer](https://www.realvnc.com/download/viewer/)来连接vncserver

### 共享代理给手机
  - 条件一：电脑能科学上网（我用了xx-net）
  - 条件二：电脑和手机处于同一个局域网里
  - 操作：在xx-net的目录中搜索proxy.ini，将ini中，127.0.0.1改成0.0.0.0
  - 查看自己电脑的ip
  - android手机wifi连接那里，设置代理，设置ip为电脑ip，端口为8087(xx-net的代理端口)
  - end


### Ubuntu nautilus 文件浏览器中，Ctrl + L可以将地址变为字符串方便复制

### Ubuntu 16.04发wifi
  - 参考这个[教程](http://ubuntuhandbook.org/index.php/2016/04/create-wifi-hotspot-ubuntu-16-04-android-supported/)

### 解压zip乱码
  - 使用
```shell
unzip -O CP936 xxx.zip
```

### Ubuntu kernel 更新后无法登录循环登录
  - 新装了显卡驱动，然后发现过了几天重启就没法登录了，ssh可以登录，-X 登录提示 .Xauthority unwritable
  - 重装NVIDIA显卡驱动，home目录下删除.Xauthor\*几个目录
  - 重启，问题解决


### 安装NVIDIA官方驱动
  - 根据自己显卡下载对应驱动:http://www.nvidia.cn/Download/index.aspx?lang=cn
  - ctrl alt f1进入命令行模式，运行如下命令：
```shell
sudo service lightdm stop
sudo ./NVIDIA-Linux-x86_64-367.57.run
```
  - 一路确定
  - 然后sudo reboot

### 卸载Nvidia官方驱动

> 卸载，很简单，加上 --uninstall 选项再运行一遍安装程序就可以了。例如：假设你的安装程序是 NVIDIA-Linux-x86-169.12-pkg1.run 的话，在 root 下键入 ./NVIDIA-Linux-x86-169.12-pkg1.run --uninstall 就可以卸载了。欲了解安装程序的更多选项，请使用 ./NVIDIA-Linux-x86-169.12-pkg1.run -h 或 ./NVIDIA-Linux-x86-169.12-pkg1.run -A 进行查看。

### rar
 - ubuntu 默认的解压工具不能解压rar，需要安装rar和unrar
 - 附上各种解压命令的[链接](http://alex09.iteye.com/blog/647128)
```
sudo apt-get install rar
sudo apt-get install unrar
# 解压
sudo rar x abc.rar
# 压缩
sudo rar a abc.rar abc
```
### ssh免密码登录
看这个[链接](https://my.oschina.net/aiguozhe/blog/33994)

最关键的命令是

> ssh-keygen -t rsa

### MatlabR2015b卡在启动界面
- 要用sudo运行 matlab
- 附上matlab安装[教程](http://www.jianshu.com/p/60038ffa8870)
- 如果启动matlab出现crash，段错误等等，执行：
```
sudo apt-get install matlab-support
```

按提示执行并确认，rename什么的都要选yes

## Ubuntu 安装nginx并配置web前端服务器

```shell
sudo apt-get install nginx
vi mywebsite.conf
```

写入
```
server {
	listen 8080;
	charset utf-8;
	root /home/your/wesite;
	location / {
	}
}
```
配置到nginx

```shell
cd /etc/nginx/conf.d
sudo ln -s /your/conf/path/mywebsite.conf
```
注意网站不能在/root目录下，否则一定会出现403

重启nginx
```shell
sudo nginx -s reload
```

## ssh反向代理访问内网
- 参考[>>](http://b.liuctic.com/2013/12/ssh%E6%AD%A3%E5%90%91%E5%8F%8D%E5%90%91%E8%BF%9E%E6%8E%A5%E7%9A%84%E5%BC%BA%E5%A4%A7%E5%8A%9F%E8%83%BD%E4%BB%A5%E5%8F%8Aautossh%E3%80%90%E8%BD%AC%E8%BD%BD%E4%B8%A4%E7%AF%87%E3%80%91/)，采用autossh
- 需要注意设置GatewayPorts yes，参考[>>](http://www.netcan666.com/2016/09/28/ssh%E9%9A%A7%E9%81%93%E5%8F%8D%E5%90%91%E4%BB%A3%E7%90%86%E5%AE%9E%E7%8E%B0%E5%86%85%E7%BD%91%E5%88%B0%E5%85%AC%E7%BD%91%E7%AB%AF%E5%8F%A3%E8%BD%AC%E5%8F%91/)
- 其他内网穿透的方法还有teamviewer, openvpn, ngrok，有空再研究看看

## 编译opencv
- 当opencv放在ntfs格式的磁盘上,并在ubuntu上编译时,会有如下错误:

`CMake fails to deterimine the bitness of target platform. opencv ubuntu`

## Caffe官网安装教程没告诉你的东西
- Ubuntu上,hdf5是带serial的,需要添加头文件和lib:
  - 在Make.config中,修改:
  ```shell
  INCLUDE_DIRS := $(PYTHON_INCLUDE) /usr/local/include /usr/include/hdf5/serial/
  ```
  
  - 连接hdf5的库:
  
```shell
cd /usr/lib/x86_64-linux-gnu
sudo ln -s libhdf5_serial.so.8.0.2 libhdf5.so
sudo ln -s libhdf5_serial_hl.so.8.0.2 libhdf5_hl.so
```
- make pycaffe之后,需要在~/.bashrc添加pythonpath:

```shell
export PYTHONPATH=/path/to/caffe/python:$PYTHONPATH
```

- 如果pycaffe使用了anaconda的numpy,关联了mkl,则需要在~/.bashrc中添加mkl的preload

```shell
export LD_PRELOAD=/opt/intel/mkl/lib/intel64/libmkl_core.so:/opt/intel/mkl/lib/intel64/libmkl_sequential.so
```

## OpenCV GPU编译CUDA-8兼容问题

https://github.com/thrust/thrust/issues/800
