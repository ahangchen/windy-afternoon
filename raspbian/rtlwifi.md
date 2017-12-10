# It works! RTL8188 monitor mode on Raspberry 3B+（树莓派无线网卡监听模式）


项目里需要在树莓派上运行抓包程序，需要使用无线网卡，进入监听模式，进行抓包；

默认的无线网卡是不支持monitor模式的，支持monitor模式的网卡列表可以在[这里查到](https://wikidevi.com/wiki/Wireless_adapters/Chipset_table)

于是我选了两个RTL8188CUS的USB无线网卡，足够便宜，而且京东上找得到（吐槽：京东上好多无线网卡都不写芯片组型号，还有很多是不支持monitor模式的MTK7610，而且搜索芯片组型号基本搜不到商品，但是京东可以开发票报销啊，而且快啊，淘宝药丸，吐槽完毕）

在ubuntu上插入USB接口，ifconfig一下，可以看到多了一个设备wl********，名字太长了，重启一下系统，它会变成wlan0或wlan1（如果有多个无线网卡的话），这样方便操作一点

这里需要注意区分那个卡是自己插上去的新卡，在终端输入iwconfig，如果wlan1 Nickname是“<WIFI@REALTEK>”，wlan1就是我们新买的RTL8188啦，
