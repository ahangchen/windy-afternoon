### MySQL err 150
- 十个可能引起mysql 外键错误的原因：

> http://verysimple.com/2006/10/22/mysql-error-number-1005-cant-create-table-mydbsql-328_45frm-errno-150/

- MySql默认charset是瑞典的，应该这样修改：
```sql
ALTER DATABASE db_name DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;

ALTER TABLE db_table CONVERT TO CHARACTER SET utf8 COLLATE utf8_general_ci;
```
