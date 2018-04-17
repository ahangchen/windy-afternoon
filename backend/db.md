# 数据库
## Oracle
#### 记录oracle sql plus 执行时所有的输入输出：

```sql
spool d:\xx.txt
SQL statement
spool off (关闭)
```

## MySQL
#### MySQL err 150
- 十个可能引起mysql 外键错误的原因：

> http://verysimple.com/2006/10/22/mysql-error-number-1005-cant-create-table-mydbsql-328_45frm-errno-150/

- MySql默认charset是瑞典的，应该这样修改：
```sql
ALTER DATABASE db_name DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;

ALTER TABLE db_table CONVERT TO CHARACTER SET utf8 COLLATE utf8_general_ci;
```

## MongoDB
- [教程](http://www.runoob.com/mongodb/mongodb-connections.html)
- 常用命令

```shell  
# 启动mongodb后端
mongod
# 连接mongodb
mongo
mongodb://user:psw@ip[:port]/dbname
# 查看与切换数据库（不存在会创建），展示所有的文档
show dbs
use reid
db.getCollectionNames()
# 查询文档（传统意义的表）
db.col_name.find()
```

