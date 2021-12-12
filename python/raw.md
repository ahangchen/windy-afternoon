# 原生模块

Python 原生模块相关知识点

* 在Python3中，单斜杠/表示浮点除法，双斜杠//表示整数除法。
* StringIO在python2中可以用户保存bytes，但在python3中不能保存bytes，要用BytesIO

使用python实现大浮点数排序

```python
import functools

def sort_long_float(f1, f2):
    f1_words = f1.split('.')
    int_str1 = f1_words[0]
    float_str1 = f1_words[1].rstrip('0')
    f2_words = f2.split('.')
    int_str2 = f2_words[0]
    float_str2 = f2_words[1].rstrip('0')
    int1 = int(int_str1)
    int2 = int(int_str2)
    if int1 > int2:
        return 1
    elif int1 < int2:
        return -1
    else:
        if float_str1 > float_str2:
            return 1
        elif float_str1 < float_str2:
            return -1
        else:
            return 0

arr = ['0.5', '0.66', '0.50', '0.60', '0.10']

sorted_arr = sorted(arr, key=functools.cmp_to_key(sort_long_float))
print(sorted_arr)
```

主要利用了两个点：
- python中int可以表示无限大的整数
- 字符串表达小数部分，字符串比对是用字典序，跟小数部分的大小比较逻辑是一样的；
- functools可以用来实现类似C++ sort模板中复杂的cmp函数