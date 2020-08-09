# 常用库踩坑指南

* paramiko远程环境变量

  由于使用非交互模式ssh，不会加载~/.bashrc或者/etc/profile中的环境变量，需要手动执行source，example:

```python
import paramiko
# 创建SSH对象
ssh = paramiko.SSHClient()
ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
ssh.connect(hostname='222.201.145.236', port=22, username='hadoop', password='psw')
# 执行命令
stdin, stdout, stderr = ssh.exec_command('source /etc/profile\necho $PATH' )
# 获取命令结果
result = stdout.read()
print(result)
# 关闭连接
ssh.close()
```

* jupyter notebook启动

```text
~/anaconda2/bin/jupyter notebook --ip=0.0.0.0 --port=8081
```

* 用ipdb在命令行里debug

[https://xmfbit.github.io/2017/08/21/debugging-with-ipdb/](https://xmfbit.github.io/2017/08/21/debugging-with-ipdb/)

* pycuda安装，找不到cuda.h

> sudo pip3 install --global-option=build_ext --global-option="-I/usr/local/cuda-10.0/targets/aarch64-linux/include/" --global-option="-L/usr/local/cuda-10.0/targets/aarch64-linux/lib/" pycuda
