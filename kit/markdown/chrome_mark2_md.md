#导出Chrome书签转为markdown

- 首先打开Chrome[书签管理器](chrome://bookmarks/#1),

- 整理 - 书签导出html

![](chrome_mark.png)
- 用python解析html，读取h3标签和a标签，写入文件，代码：

```python
import os
from html.parser import HTMLParser

from utils.file import file_utils


class MyHTMLParser(HTMLParser):
    is_a = False
    is_h3 = False
    links = []
    cur_tag_key = ''
    cur_tag_value = ''

    def __init__(self):
        HTMLParser.__init__(self)

    def handle_starttag(self, tag, attrs):
        # print "Encountered the beginning of a %s tag" % tag
        if tag == 'a':
            self.is_a = True
            if len(attrs) == 0:
                pass
            else:
                for (variable, value) in attrs:
                    if variable == "href":
                        self.cur_tag_value = value
        else:
            self.is_h3 = True

    def handle_data(self, data):
        if self.is_a:
            self.cur_tag_key = data
        elif self.is_h3:
            self.cur_tag_key = data
            self.cur_tag_value = 'h3'

    def handle_endtag(self, tag):
        if tag == 'a' or tag == 'h3':
            self.is_a = False
            self.is_h3 = False
            if self.cur_tag_key == '' and self.cur_tag_value == '':
                pass
            else:
                self.links.append([self.cur_tag_key, self.cur_tag_value])
                self.cur_tag_key = ''
                self.cur_tag_value = ''


def get_links():
    html_code = file_utils.read2mem('/home/cwh/Mission/bookmarks_16_3_23.html')
    hp = MyHTMLParser()
    hp.feed(html_code)
    hp.close()
    try:
        os.remove('star.md')
    except FileNotFoundError:
        pass
    file_utils.append2file('star.md', '#我的收藏\n>他山之石，可以攻玉\n\n开发过程中收藏在Chrome书签栏里的技术文章，独立出来\n\n转换方式：')
    for word in hp.links:
        if word[1] == 'h3':
            file_utils.append2file('star.md', '##' + word[0] + '\n\n')
            print(word[0] + '\n')
        else:
            file_utils.append2file('star.md', '- [' + word[0] + '](' + word[1] + ')\n\n')
            print('- [' + word[0] + '](' + word[1] + ')\n')


get_links()

```

其中fileutil是我的一个文件操作模块，可以在[这里](https://github.com/ahangchen/CodeCounter/blob/master/utils/file/file_utils.py)看到对应的代码，

转换的效果即本博客中的[我的收藏](../../star.md)部分
