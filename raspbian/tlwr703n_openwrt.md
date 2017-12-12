# TP-LINK TL-WR703N v1.7 openwrt flashing

TP-LINK TL-WR703N是一个小型的路由器，可以有线转WiFi，3G转WiFi，很多人拿它刷openwrt系统，然后可以在上面各种搞事。

### V1.7以前
通常刷openwrt的做法是，
- 下载一个openwrt [factory镜像](http://downloads.openwrt.org/attitude_adjustment/12.09/ar71xx/generic/openwrt-ar71xx-generic-tl-wr703n-v1-squashfs-factory.bin)
- 打开路由器，
- 笔记本连接路由器发出来的WiFi，比如：TP-LINK-90-1B-18
- 在浏览器输入192.168.1.1，选择左边“系统工具”-“软件升级”-“浏览”
- 找到刚刚下载的镜像bin文件，确定
- 然后就会自动把openwrt刷到板子里边了

### V1.7以后
然而！上面的方法只有在2012年12月生产的WR703N（型号在FW build 121204以后的，这个在路由器管理界面可以看到，如果你的型号跟我的一样是3.17.1 Build 140120 Rel.56593n，那么恭喜你中奖了，只能通过下面这种方式或者TTL硬件方式刷openwrt）上才有用，在之后的板子上，选择完bin文件会提示“上传的文件与硬件版本不符”，导致无法从web管理界面刷写系统！

原因是，2012年12月之后的系统升级，对bin文件做了RSA签名校验，无法刷第三方的系统。

一番搜索之后发现有个[国外的牛人](https://pastebin.com/0wzMthfr)利用TP-LINK家长控制的漏洞，让路由板执行一些代码，成功刷写openwrt系统，这个方法的英文版也被放到了openwrt wr703的官方wiki上，可以说是相当靠谱了，国内有人也整理了一个[中文版](https://boweihe.me/2015/11/02/wr703n-v1-7-%E7%A0%B4%E8%A7%A3openwrt%EF%BC%88%E6%8F%90%E7%A4%BA%E5%AF%86%E7%A0%81%E9%94%99%E8%AF%AF%E7%AD%89%E9%97%AE%E9%A2%98%E7%9A%84%E8%A7%A3%E5%86%B3%EF%BC%89/)，但有些步骤还是不够详细，于是我整理了一个完整的版出来，让大家少踩一些坑。

#### 搭建tftp服务器
- 以MacOS为例，
