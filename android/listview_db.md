##ListView读DB最佳实践
> 开发中我们常常用listview来呈现DB中的数据，但常见的许多做法，都没能全面考虑读写并发，内存优化。这里希望由浅入深讨论得到一种ListView读DB的最佳实践。

* 需求

> 从服务器获取 头像 + 名字，放到ListView中显示，本地存储 头像url + 名字
> 底部加载更多，加载服务器数据
> 无数据时显示空白页

这里只做逻辑层讨论，UI层，比如下拉刷新如何实现，则不做不必要讨论。

* 分析
 - 首先，从服务器获取，就涉及异步写DB，以及在写DB时的并发读
 - 用户随时可能发起写DB操作
 - 是否能够加载更多，是需要从server获取的另一个数据，listview的item数量与这个值相关（影响getCount）
 - 考虑listview数据源清空的正确姿势

* 架构
 - 至少三个线程，UI主线程，读DB线程，网络请求写DB线程
 - M层：头像url + 名字
 - V层：listview，footer作为加载更多
 - C层：adapter
 
* Adapter的设计
 - 方案一 Cursor读取DB，遍历Cursor把数据都放到一个list放在内存里，关掉cursor，listview访问list作为数据源
 优点：没有cursor关闭问题，以及cursorwindow被置换的风险
 缺点： 一次读出DB数据会占用大量内存空间，采取游标窗口的设计，需要实现java层的cursorwindow，成本太高
 - 方案二 Cursor读取DB，listview访问cursor作为数据源
 优点：cursor机制自动达到所取即所需的机制，不会占用太多内存。
 缺点：必须谨慎考虑关闭Cursor的时机。

用方案二来满足上面几个需求：
