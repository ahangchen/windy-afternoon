###gitbook 支持disqus评论

- 注册一个disqus账号
- 右上角齿轮 - add disqus to site 或者直接[这样](https://disqus.com/admin/create/)
- 注册你的站点，注意，这里还不用写网站地址
![](create_site.png)

这里最重要的就是第二个框，这是之后gitbook需要配置的shortname，也就是图中的ahangchen-blogs。

- 然后访问刚刚第二个框的Disqus URL，即https://ahangchen-blog.disqus.com/admin/settings/general/

![](setting.png)


在Website URL中填入你的gitbook地址（我试了一下增加具体的gitbook某本书的url，但不能生效，所以还是使用整个站点的url）


- 在你的gitbook工程根目录，添加一个book.json文件，内容：

```json
{
    "plugins": ["disqus"],
    "pluginsConfig": {
        "disqus": {
            "shortName": "ahangchen-blog"
        }
    }  
}
```