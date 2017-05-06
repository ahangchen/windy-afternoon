## 一个android工程应该长什么样
- src
  - 各个功能模块的package（业务代码，包括activity）
  - utils（工具类）
  - view（自定义可重用view）
  - model（各个功能模块的公用基础代码，业务相关，不包括activity，主要是各种manager）
  
- res
    - layout（以前缀区分）
    - activity_xxx
    - include_xxx
    - item_xxx
    - fragment_xxx
