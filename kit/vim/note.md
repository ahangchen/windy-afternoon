##VIM NOTE



###vim plugin collections（2016-1-22 ）

（参考 https://www.youtube.com/watch?v=0QFR-_wUoA0）

* vim-pathogen  插件管理工具

* vim-powerline 漂亮的底部状态列

* SelectColors 颜色主题选择

* snipmate  自动生成样式代码

* vim-css-color  颜色相关的代码展示出对应的颜色

* surround  改变word外面的字符，比如把“screen”换成‘screen’

* vim-indent-object 选择同一个缩进范围类的代码

* vim-matchit 匹配符号间的跳转

* vim-ragtag tag代码自动生成

* NERDtree 工程结构

* ctrlp 搜文件

* vim-wiki vim里的记事本

 

###vim好看的主题 dacular(2016-1-28) 
darcular 谷歌搜这个名字就有挺多个版本了

###vim复制到全局剪贴板

visual下选中，然后依次输入 
> “+y



###vim替换（2016-1-29）

:%s/src/dst

 
###vim背景透明（2016-2-21）

hi Normal  ctermfg=252 ctermbg=none

hi Nontext  ctermfg=252 ctermbg=none

最主要的是ctermbg=none