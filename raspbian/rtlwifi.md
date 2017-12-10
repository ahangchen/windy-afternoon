# 树莓派无线网卡监听模式
> It works! RTL8188 monitor mode on Raspberry 3B+ 

### Background
项目里需要在树莓派上运行抓包程序，需要使用无线网卡，进入监听模式，进行抓包；

默认的无线网卡是不支持monitor模式的，支持monitor模式的网卡列表可以在[这里查到](https://wikidevi.com/wiki/Wireless_adapters/Chipset_table)

于是我选了两个RTL8188CUS的USB无线网卡，足够便宜，而且京东上找得到（吐槽：京东上好多无线网卡都不写芯片组型号，还有很多是不支持monitor模式的MTK7610，而且搜索芯片组型号基本搜不到商品，但是京东可以开发票报销啊，而且物流快啊，淘宝药丸，想要买网卡的同学上京东搜RTL8188能搜到网卡的，跟客服确认一下是不是RTL8188CUS就行，吐槽完毕）

### Ubuntu 试水
在ubuntu上插入USB接口，ifconfig一下，可以看到多了一个设备wl********，名字太长了，重启一下系统，它会变成wlan0或wlan1（如果有多个无线网卡的话），这样方便操作一点

这里需要注意区分哪个卡是自己插上去的新卡，在终端输入iwconfig，如果wlan1 Nickname是“<WIFI@REALTEK>”，wlan1就是我们新买的RTL8188啦，

```shell
pi@raspberrypi:~ $ iwconfig
eth0      no wireless extensions.

wlan1     unassociated  Nickname:"<WIFI@REALTEK>"
          Mode:Auto  Frequency=2.412 GHz  Access Point: Not-Associated   
          Sensitivity:0/0  
          Retry:off   RTS thr:off   Fragment thr:off
          Power Management:off
          Link Quality:0  Signal level:0  Noise level:0
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:0   Missed beacon:0

lo        no wireless extensions.

wlan0     IEEE 802.11  ESSID:off/any  
          Mode:Managed  Access Point: Not-Associated   Tx-Power=31 dBm   
          Retry short limit:7   RTS thr:off   Fragment thr:off
          Power Management:on

```

接着尝试关掉wlan1，让它进入待命状态，再设置监听模式，再启动wlan1

```shell
pi@raspberrypi:~ $ sudo ifconfig wlan1 down
pi@raspberrypi:~ $ sudo iwconfig wlan1 mode monitor
pi@raspberrypi:~ $ sudo ifconfig wlan1 up
```

没有报错，说明这个网卡确实支持monitor模式，也可以再执行iwconfig，可以看到wlan1的Mode从Auto变成了monitor。

### 树莓派翻车
然而到了raspbian（我试过Ubuntu mate也一样）上，同样执行

```shell
pi@raspberrypi:~ $ sudo iwconfig wlan1 mode monitor
Error for wireless request "Set Mode" (8B06) :
    SET failed on device wlan1 ; Invalid argument.
```

去网上搜这个问题，回答都是很多年前的了，很少有在树莓派3B上试过的方案，最靠谱的一个答案在[这里](https://www.findhao.net/easycoding/1498)，在树莓派2B+的年代，raspbian禁用了rtlwifi驱动，因为它再raspbian上不稳定，对于rtl8188cus，会去使用rtl8192cu的驱动（恩，这是正确的做法），但是在raspbian上，一旦使用了rtl8192cu的驱动，网卡就开不了监听模式，所以需要重新编译raspbian内核，将rtlwifi驱动打开，将rtl8192驱动关掉。

然而！在2017年的现在，我下载了raspbian的内核源码，发现官网已经把rtlwifi的驱动打开了！并且在这种情况下还是不能使用monitor模式！

### 峰回路转
在网上继续搜索有没有什么奇技淫巧可以解决这个问题，忽然发现这个[工程](https://github.com/hexameron/rtlwifi)

在这个工程里编译了linux3.6上的rtlwifi，替换到raspbian的驱动里边去

意识到，既然raspbian现在已经编译了rtlwifi和rtl8192两个驱动，那么就应该手动关掉rtl8192的驱动，手动启用rtlwifi的驱动！

- 首先查看自己的内核版本

```shell
pi@raspberrypi:~ $ uname -a
Linux raspberrypi 4.9.41-v7+ #1023 SMP Tue Aug 8 16:00:15 BST 2017 armv7l GNU/Linux
```

- 确认是否确实编译了rtlwifi的驱动

```shell
pi@raspberrypi:/lib/modules/4.9.41-v7+/kernel/drivers/net/wireless/realtek $ ls
rtl818x  rtl8192cu  rtl8xxxu  rtlwifi
```

可以看到有rtlwifi

- 然后检查当前使用的驱动

```shell
pi@raspberrypi:~ $ lsmod | grep 8192
8192cu                582217  0
cfg80211              543091  2 8192cu,brcmfmac
```

显示的是8192cu，确实是rtl8192cu的驱动，如果是使用rtlwifi的驱动，显示的应该是rtl8192cu

- 手动禁用rtl8192驱动
```shell
pi@raspberrypi:~ $ sudo depmod 4.9.41-v7+
pi@raspberrypi:~ $ sudo rmmod 8192cu
pi@raspberrypi:~ $ sudo modprobe rtl8192cu
```

- 再尝试将网卡设为监听模式

```shell
pi@raspberrypi:~ $ sudo ifconfig wlan1 down
pi@raspberrypi:~ $ sudo iwconfig wlan1 mode monitor
pi@raspberrypi:~ $ sudo ifconfig wlan1 up
```

一切正常！

## 总结
想要在树莓派3B+上使用RTL8188CUS开启无线网卡监听模式，就把rtl8192的驱动禁用掉，把rtlwifi的驱动开起来就好了
