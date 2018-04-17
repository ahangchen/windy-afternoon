##Django note


####Unknown command: 'syncdb'  solution：(2016-2-9)

syncdb command is deprecated in django 1.7. Use the python manage.py migrate instead.

####推荐一个较新版本的django中文文档

http://python.usyiyi.cn/django/intro/tutorial01.html



####install django for python3

sudo pip3 install Django

if for python2

sudo pip install Django

####1.9中的deprecated接口

 https://docs.djangoproject.com/en/1.9/internals/deprecation/

 ####django runserver, 停在performing System checking

 检查引用的py模块中，是否有自动执行的语句。

 比如views.py引用a.py，a.py中执行了一个死循环执行一些监听操作，views.py引用a.py时，就会去执行那段死循环，导致runserver卡住

####在bat中运行python脚本不显示黑框
不用python，用pythonw

####修改DB
```shell
python manage.py makemigrations module_name
python manage.py migrate
```

#### Syncdb
Django1.9中，不能使用syncdb，因为有了migration系统，使用makemigrations, migrate，代替之。

#### Session
Django的Session依赖于本地的数据库，使用Session前，需要执行makemigrations，migrate，Session才能正常工作。

#### Django migrate
migrate时，会去检查数据库里，django_migration表里执行的操作名，从而决定需要执行哪些migration，因此可以删掉这个表里的操作进行回退。

#### 发邮件
- 因为是服务端的问题所以也归在这里好了
- 阿里云服务器上发邮件的时候，由于安全策略，必须使用SSL发邮件
- 代码
```python
def send_163_mail(user, pwd, from_addr, to_addr, subject, content):
    msg = MIMEText(content)
    # 加邮件头
    msg['to'] = to_addr
    msg['from'] = from_addr
    msg['subject'] = subject
    # 发送邮件
    try:
        server = smtplib.SMTP_SSL('smtp.163.com', 465)
        server.starttls()
        server.set_debuglevel(1)
        server.login(user, pwd)  # XXX为用户名，XXXXX为密码
        server.sendmail(msg['from'], msg['to'], msg.as_string())
        server.quit()
        print('发送成功')
    except smtplib.SMTPConnectError:
        print('SMTPConnectError')
```

#### 多APP外键双向依赖
 - makemigrations和migrate时不指定app名，可以自动处理
