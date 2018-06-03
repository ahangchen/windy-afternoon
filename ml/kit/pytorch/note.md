# Pytorch 踩坑日志
- 多GPU模式下，不能和其他进程共享同一个GPU，否则会出现ConnectionError，应该用环境变量将自己的进程使用的GPU和其他进程使用的GPU分开
