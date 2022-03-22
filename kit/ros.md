# ROS

- 从某个时间开始play bag：`rosbag play -t 10 xxx.bag`，其中，10的单位为秒，表示从多少秒开始play
- crop bag中的一段：`rosbag filter xxx.bag t.to_sec() >=163465898.xxx`，取bag中符合filter条件的部分
- 列出所有topic：
  - rostopic list
  - rostopic list -b xxx.bag
- 打印某个topic具体内容：
  - `rostopic echo /topic`
  - `rostopic echo /topic -b xxx.bag`
