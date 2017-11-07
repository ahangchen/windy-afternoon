## Shadowsocks配置
### 服务端
- 安装python
- 安装pip
- pip install shadowsocks
- 编写配置文件

```json
{
       "server":"your.server.ip",
       "server_port":"yourserverport",
       "local_address": "127.0.0.1",
       "local_port":1080,
       "password":"yoursspassword",
       "timeout":300,
       "method":"aes-256-cfb",
       "fast_open": false
}
```
随便保存在某个地方，命名为"自定义名字.json"
- 启动ss服务端：

```shell
ssserver -c /path/to/your/config.json
```

### 客户端
- 安装python
- 安装pip
- pip install shadowsocks
- 编写配置文件（和服务端的文件一模一样）
- 启动ss客户端

```shell
sslocal -c /path/to/your/config.json
```

注意配置文件中的local port是你本地连接的sock代理服务器端口, local_address是你本地连接的sock代理服务器ip

### 需要上网的软件配置
- Chrome：协议选择SOCK5，设置代理服务器ip为127.0.0.1，端口为1080即可，
- 如果希望国内网站不走代理服务器，可以装一下switchomega插件，直接使用X-Tunnel自动切换模式
- ubuntu或mac可以配置全局代理

