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