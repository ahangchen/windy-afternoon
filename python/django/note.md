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

