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
