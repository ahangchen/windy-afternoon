# Linux && Hardware

## Linux Note

### 临时切换到root用户

> sudo su

### 用 &&组合两个命令，比如：

> cd dir && ls

### chown

> chown user:group filename

### chmod 

> chmod +x file

### add sudo user

> sudo usermod -aG sudo newuser

### ubuntu换源后，务必执行

> sudo apt-get clean && sudo apt-get autoremove 清除cache

### vsphere client 中修改ubuntu控制台大小

* 先按这个link操作：[http://jingyan.baidu.com/article/fc07f98977b60f12ffe5199b.html](http://jingyan.baidu.com/article/fc07f98977b60f12ffe5199b.html)
* 然后在系统设置中修改屏幕分辨率，就能调整到比较适合的尺寸。

### 一行代码统计代码行数

```text
find . -iregex ".*\.\(cpp\|h\|java\|sh\)$" | xargs wc -l
```

想要增加统计的代码类型，就在正则表达式里填后缀就好

### 开启后台进程并脱离terminal生命周期

有时候我们会想要开启后台进程，往往会用&的符号，但这样开的进程在关闭terminal的时候也会被杀死，因此还要加一个disown，解绑进程和终端：

```text
./test.sh & disown
```

## ubuntu搜索软件源

```
sudo apt-cache search ros(关键字)
```

### Ubuntu 全局代理

系统设置-网络-代理设置-手动-填自己的代理服务器地址和端口即可

### 导入全局证书

```text
sudo cp your.crt /usr/share/ca-certificates/your.crt
sudo dpkg-reconfigure ca-certificates
```

或者编辑 `/etc/ca-certificates.conf`

然后

```text
sudo update-ca-certificates
sudo dpkg-reconfigure ca-certificates
```

### Ubuntu desktop应用设置环境变量

直接上代码

```text
[Desktop Entry]
Version=1.0
Type=Application
Name=Pycharm
Exec=env LD_LIBRARY_PATH=:/usr/local/cuda/lib64:/usr/local/cuda/lib64 /home/cwh/software/pycharm-2016.1.4/bin/pycharm.sh
Icon=/home/cwh/software/pycharm-2016.1.4/bin/pycharm.png
Name[zh_CN]=Pycharm
```

### Ubuntu控制端远程登陆另外的设备

* 可以考虑remmina，或者rdesktop，
* remmina是ubuntu自带的，启动和配置可以通过图形化界面实现，并且持久化配置信息
* rdesktop需要自己另外安装

  ```text
  sudo apt-get install rdesktop
  ```

* 安装后通过参数启动远程，启动后的远程比remmina好看，例子:[使用rdesktop远程并设定分辨率](http://blog.sina.com.cn/s/blog_408184cf01010qpw.html)
* 比较喜欢rdesktop，有空写一个shell程序来保存配置

### Ubuntu SSH带界面

```text
ssh -XC user@host
```

### Ubuntu被控端允许远程

* sudo vino-preferences，允许远程
* 安装远程桌面环境

  ```text
  sudo apt-get install xfce4
  sudo apt-get install xrdp tightvncserver
  echo "xfce4-session" >~/.xsession
  sudo service xrdp restart
  ```

* 其中xfce4 tab键默认会因为键位冲突不能自动补全，需要执行 `xfwm4-settings`，在 按键 - 切换同一应用程序的窗口，清除它的快捷键
* xfce4-settings-manager, Prefered applications,可以修改默认的终端和文件管理器
* 用windows远程ubuntu时，mstsc命令后加/span，可以实现多屏扩展
* 可以[修改xfce的主题](https://blog.gtwang.org/linux/xfce-theme-manager-xubuntu/)
* 可以修改vncserver分辨率：

```text
vncserver -geometry 1920x1080
```

这样就能启动一个指定分辨率为1920x1080的vnc会话

* 如果需要在mac上远程Ubuntu，需要在Ubuntu上开启vncserver: 命令行输入vncserver\(初次运行输入设置密码\)，并将~/.vnc/xstartup文件改为：

```text
#!/bin/bash
xrdb $HOME/.Xresources
startxfce4 &
```

以此解决花屏问题

* 关闭一个vncserver：

```text
vncserver -kill :k
```

k是你的vncserver的编号，比如端口号5904的vncserver应该是4

在各个平台上可以下载[vncviewer](https://www.realvnc.com/download/viewer/)来连接vncserver

### ubuntu18.04远程

如果是ubuntu18.04，则不需要安装xfce，可以直接通过xorg远程原生ubuntu：

```
sudo apt-get install xrdp
```

参考：https://zhuanlan.zhihu.com/p/93438433


### 共享代理给手机

* 条件一：电脑能科学上网（我用了xx-net）
* 条件二：电脑和手机处于同一个局域网里
* 操作：在xx-net的目录中搜索proxy.ini，将ini中，127.0.0.1改成0.0.0.0
* 查看自己电脑的ip
* android手机wifi连接那里，设置代理，设置ip为电脑ip，端口为8087\(xx-net的代理端口\)
* end

### Ubuntu nautilus 文件浏览器中，Ctrl + L可以将地址变为字符串方便复制

### Ubuntu 16.04发wifi

* 参考这个[教程](http://ubuntuhandbook.org/index.php/2016/04/create-wifi-hotspot-ubuntu-16-04-android-supported/)

### 解压zip乱码

* 使用

  ```text
  unzip -O CP936 xxx.zip
  ```

### Ubuntu kernel 更新后无法登录循环登录

* 新装了显卡驱动，然后发现过了几天重启就没法登录了，ssh可以登录，-X 登录提示 .Xauthority unwritable
* 重装NVIDIA显卡驱动，home目录下删除.Xauthor\*几个目录
* 重启，问题解决

### 安装NVIDIA官方驱动

* 根据自己显卡下载对应驱动:[http://www.nvidia.cn/Download/index.aspx?lang=cn](http://www.nvidia.cn/Download/index.aspx?lang=cn)
* ctrl alt f1进入命令行模式，运行如下命令：

  ```text
  sudo service lightdm stop
  sudo ./NVIDIA-Linux-x86_64-367.57.run
  ```

* 一路确定
* 然后sudo reboot

### 卸载Nvidia官方驱动

> 卸载，很简单，加上 --uninstall 选项再运行一遍安装程序就可以了。例如：假设你的安装程序是 NVIDIA-Linux-x86-169.12-pkg1.run 的话，在 root 下键入 ./NVIDIA-Linux-x86-169.12-pkg1.run --uninstall 就可以卸载了。欲了解安装程序的更多选项，请使用 ./NVIDIA-Linux-x86-169.12-pkg1.run -h 或 ./NVIDIA-Linux-x86-169.12-pkg1.run -A 进行查看。

### rar

* ubuntu 默认的解压工具不能解压rar，需要安装rar和unrar
* 附上各种解压命令的[链接](http://alex09.iteye.com/blog/647128)

  ```text
  sudo apt-get install rar
  sudo apt-get install unrar
  # 解压
  sudo rar x abc.rar
  # 压缩
  sudo rar a abc.rar abc
  ```

  **ssh免密码登录**

  看这个[链接](https://my.oschina.net/aiguozhe/blog/33994)

最关键的命令是

> ssh-keygen -t rsa

### MatlabR2015b卡在启动界面

* 要用sudo运行 matlab
* 附上matlab安装[教程](http://www.jianshu.com/p/60038ffa8870)
* 如果启动matlab出现crash，段错误等等，执行：

  ```text
  sudo apt-get install matlab-support
  ```

按提示执行并确认，rename什么的都要选yes

## Ubuntu 安装nginx并配置web前端服务器

```text
sudo apt-get install nginx
vi mywebsite.conf
```

写入

```text
server {
    listen 8080;
    charset utf-8;
    root /home/your/wesite;
    location / {
    }
}
```

配置到nginx

```text
cd /etc/nginx/conf.d
sudo ln -s /your/conf/path/mywebsite.conf
```

注意网站不能在/root目录下，否则一定会出现403

重启nginx

```text
sudo nginx -s reload
```

## ssh反向代理访问内网

* 参考[&gt;&gt;](http://b.liuctic.com/2013/12/ssh%E6%AD%A3%E5%90%91%E5%8F%8D%E5%90%91%E8%BF%9E%E6%8E%A5%E7%9A%84%E5%BC%BA%E5%A4%A7%E5%8A%9F%E8%83%BD%E4%BB%A5%E5%8F%8Aautossh%E3%80%90%E8%BD%AC%E8%BD%BD%E4%B8%A4%E7%AF%87%E3%80%91/)，采用autossh
* 需要注意设置GatewayPorts yes，参考[&gt;&gt;](http://www.netcan666.com/2016/09/28/ssh%E9%9A%A7%E9%81%93%E5%8F%8D%E5%90%91%E4%BB%A3%E7%90%86%E5%AE%9E%E7%8E%B0%E5%86%85%E7%BD%91%E5%88%B0%E5%85%AC%E7%BD%91%E7%AB%AF%E5%8F%A3%E8%BD%AC%E5%8F%91/)
* 其他内网穿透的方法还有teamviewer, openvpn, ngrok，有空再研究看看

## 编译opencv

* 当opencv放在ntfs格式的磁盘上,并在ubuntu上编译时,会有如下错误:

`CMake fails to deterimine the bitness of target platform. opencv ubuntu`

## Caffe官网安装教程没告诉你的东西

* Ubuntu上,hdf5是带serial的,需要添加头文件和lib:
  * 在Make.config中,修改:

```text
INCLUDE_DIRS := $(PYTHON_INCLUDE) /usr/local/include /usr/include/hdf5/serial/
```

或者直接运行

```text
find . -type f -exec sed -i -e 's^"hdf5.h"^"hdf5/serial/hdf5.h"^g' -e 's^"hdf5_hl.h"^"hdf5/serial/hdf5_hl.h"^g' '{}' \;
```

* 连接hdf5的库:

```text
cd /usr/lib/x86_64-linux-gnu
sudo ln -s libhdf5_serial.so.8.0.2 libhdf5.so
sudo ln -s libhdf5_serial_hl.so.8.0.2 libhdf5_hl.so
```

* make pycaffe之后,需要在~/.bashrc添加pythonpath:

```text
export PYTHONPATH=/path/to/caffe/python:$PYTHONPATH
```

* 如果pycaffe使用了anaconda的numpy,关联了mkl,则需要在~/.bashrc中添加mkl的preload

```text
export LD_PRELOAD=/opt/intel/mkl/lib/intel64/libmkl_core.so:/opt/intel/mkl/lib/intel64/libmkl_sequential.so
```

* apt-get 安装的protobuf是跟随ubuntu g++版本的，但cuda的安装是落后于g++版本的，如果g++降级过，用这个低版本g++编译caffe时，会导致找不到高版本的protobuf，应当将g++升级回来:

```text
sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-4.4 20
```

但是g++升级又会导致编译时cuda不兼容，实际上cuda不是完全不兼容，只要把`/usr/local/cuda/include/host_config.h`中的这三行注释掉就行：

```cpp
//#if __GNUC__ > 5 || (__GNUC__ == 5 && __GNUC_MINOR__ > 3)

//#error -- unsupported GNU version! gcc versions later than 5.3 are not supported!

//#endif /* __GNUC__ > 5 || (__GNUC__ == 5 && __GNUC_MINOR__ > 1) */
```

* caffe编译时只兼容apt-get的protobuf，不兼容其他高版本的，如果做了上面的修改仍然有问题，需要将系统中（比如anaconda中）的其他protobuf卸载
* caffe python3, make pycaffe会提示找不到-lboost\_python3，需要：

```text
sudo ln -s libboost_python-py35.so libboost_python3.so
```

## OpenCV GPU编译CUDA-8兼容问题

[https://github.com/thrust/thrust/issues/800](https://github.com/thrust/thrust/issues/800)

## 查看端口占用

```text
 netstat -ap | grep 8080
```

## ubuntu 破解密码

[http://blog.topspeedsnail.com/archives/6042](http://blog.topspeedsnail.com/archives/6042)

## screen 常用命令

* start new session

`screen -S sessionname`

* detach and kill session:

`$ screen -X -S [session # you want to kill] quit`

* detach current session

`$ screen -d [session id]`

* switch to other session

`$ screen -r session id`

* show sessions

`$ screen -r`

`screen -list`

* screen中滚动屏幕

ctrl+a+\[进入复制模式，然后就可以上下左右键控制了

## GCC降级

`sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.8 100`

## cmake

编写CMakeLists.txt，然后`cmake .`，然后make，也可以建立一个build目录，在里边`cmake ..`，然后 make，使得生成的文件都在build里，CMakeLists.txt例子：

```text
project(hello_world)
add_library(lib0 lib0.cpp)
add_executable(hello_world hello_world.cpp)
target_link_library(hello_world lib0)
```

# nvidia解占用

> fuser -v /dev/nvidia*
 
# 过滤想要的文本行

> awk 'NR%10==0' file 

# Ubuntu 18.04录屏
ctrl+shift+alt+r 开启和关闭录制

# VSCode离线安装插件
> code --install-extension xxx.vsix
