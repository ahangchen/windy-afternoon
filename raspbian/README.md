## 树莓派小记

### 树莓派开发实战 

> Simon Monk著 人民邮电出版社

#### 与ubuntu不同的命令
- rasp-config：各种配置
#### Tips
- 当前最新版本：树莓派3B型
- P3 保护壳：防止短路
- P4 电源：推荐1.5A至2A的
- P6 系统：推荐Raspbian
- P6 sd卡放/目录，U盘放home目录
- P7 NOOBS刷系统（FAT32）
- P10 有源USB集线器
- 

### 踩坑日志
- 树莓派录音，存在多个麦克风时，通过 plughw x:0指定使用哪个麦克风

```shell
sudo arecord -D "plughw:x,0" -d 5 tmp.wav
```

需要查看麦克风对应的序号，内置的声卡x=0，列表中第一个x=1,第二个x=2，依次类推
```shell
$pi@raspberry-pi: sudo arecord -l
**** List of CAPTURE Hardware Devices ****
card 0: U0x46d0x825 [USB Device 0x46d:0x825], device 0: USB Audio [USB Audio]
  Subdevices: 1/1
  Subdevice #0: subdevice #0
card 1: Device [USB PnP Sound Device], device 0: USB Audio [USB Audio]
  Subdevices: 1/1
  Subdevice #0: subdevice #0
```

- 通过noobs安装raspbian的时候，千万不要联网！不要连wifi也不要插网线，否则会从网上重新下载镜像，超级慢！本来6.3MB/s的事情变成200kB/s

- [树莓派3B+上RTL8188CUS无线网卡启用monitor模式](rtlwifi.md)

### Reference
- https://www.raspberrypi.org/documentation/
- https://www.yuanmas.com/info/DEzk2AdLOY.html
- https://segmentfault.com/a/1190000000414341（ffmpeg视频分段）
