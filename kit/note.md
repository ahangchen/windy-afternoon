# vim

## vim plugin collections（2016-1-22 ）

（参考 [https://www.youtube.com/watch?v=0QFR-\_wUoA0）](https://www.youtube.com/watch?v=0QFR-_wUoA0）)

* vim-pathogen 插件管理工具
* vim-powerline 漂亮的底部状态列
* SelectColors 颜色主题选择
* snipmate 自动生成样式代码
* vim-css-color 颜色相关的代码展示出对应的颜色
* surround 改变word外面的字符，比如把“screen”换成‘screen’
* vim-indent-object 选择同一个缩进范围类的代码
* vim-matchit 匹配符号间的跳转
* vim-ragtag tag代码自动生成
* NERDtree 工程结构
* ctrlp 搜文件
* vim-wiki vim里的记事本

## vim好看的主题 dacular\(2016-1-28\)

darcular 谷歌搜这个名字就有挺多个版本了

## vim复制到全局剪贴板

visual下选中，然后依次输入

> “+y

## vim替换（2016-1-29）

:%s/src/dst

## vim背景透明（2016-2-21）

hi Normal ctermfg=252 ctermbg=none

hi Nontext ctermfg=252 ctermbg=none

最主要的是ctermbg=none

# VSCode

## VSCode python配置
- 安装插件python
- ctrl+shift+P，创建launch.json
- 参考如下配置：

```html
{
    // Use IntelliSense to learn about possible attributes.
    // Hover to view descriptions of existing attributes.
    // For more information, visit: https://go.microsoft.com/fwlink/?linkid=830387
    "version": "0.2.0",
    "configurations": [
        {
            "name": "Python: cur file",
            "type": "python",
            "request": "launch",
            "program": "blog/img_utils.py",
            "args": [
                "--name", "default"
            ],
            "env": {
                "CUDA_VISLBLE_DEVICES": "0,1,2,3",
                "LD_LIBRARY_PATH": "/usr/local/cuda/lib64"
            }
            "python": "/Users/cwh/anaconda3/bin/python",
            "cwd": "${workspaceFolder}"
        }
    ]
}
```

## VSCode 远程服务器配置
- 安装插件remote development
- 添加ssh target
- 打开远程服务器上的目录
- 正常运行，代码就是跑在远程服务器上的了，配置文件里的python路径也设置成远程服务器上的python解释器路径，不需要另外配置SSH远程python解释器

## VSCode一些小设置
- setting中搜new window，把open folder in new window设置为on，避免默认current window打开new folder丢失信息

## VSCode的一些好用插件
- comment line down：注释后指针自动下移一行，可以连续注释多行，符合jetbrain系列习惯
