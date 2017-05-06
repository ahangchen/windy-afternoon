## ListView读DB最佳实践
> 开发中我们常常用listview来呈现DB中的数据，但常见的许多做法，都没能全面考虑读写并发，内存优化。这里希望由浅入深讨论得到一种ListView读DB的最佳实践。

* 需求

> 从服务器获取 头像 + 名字，放到ListView中显示，本地存储 头像url + 名字
> 底部加载更多，加载服务器数据
> 无数据时显示空白页

这里只做逻辑层讨论，UI层，则不做不必要讨论。

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
 

对方案二做一些讨论：

* Q 什么时候关闭cursor？

* A 在cursor不与listview相关联时才能关闭，否则listview滑动中，getView调用cursor.getXXX()方法会报IllegalStateException: attemp to open a database or cursor which is already closed

* Q 怎样读取新数据？

* A 点击加载更多时，重新查询DB，得到新的cursor（读DB线程），并将新的cursor交给listview的adapter（adapter.setCursor），然后adapter.notifyDataSetChanged()（UI主线程），这就引出另一个问题。

* Q adapter.setCursor应该在哪个线程做？

* A 假设放在读DB线程，setCursor后，通知主线程adapter notify，那么在主线程执行notify前，DB线程setCursor后，这段时间内，如果listview的adapter执行getView，就会在onLayhout时产生IllegalStateException，item num of listview changed, but not notify。如果一定要放DB线程做setCursor也行，不过要在onLayout时，与setCursor线程竞争锁，一来影响体验，二来影响性能。所以应该放在主线程做。
  
* Q 数据库数据变动后,应该如何改变adapter?

* A 首先,cursor在读DB线程中必须执行moveToPosition()来达到预读的效果,否则会在主线程读DB造成延迟。所以要在子线程中读DB，而setCursor又要在主线程做，这就需要用handler之类的线程通信来实现，因为子线程不能直接更改listview的adapter使用的cursor，所以，DB中要有一个新的cursor来承载新数据，再通知主线程换掉adapter中的cursor并notifyDataSetChanged。换掉adapter中cursor后，应该在notify后，马上关闭旧cursor。当然这里可以做一个优化，即对cursor做一个引用计数，在activity生命周期结束时清理所有cursor。

* Q 加载更多的实现？

* A 一个footer，会计入listview的adapter的getCount中，adapter.count = localData.count + hasFooter?1:0;为了正确显示加载更多，实际上请求网络数据时，会请求服务器数据量svrCnt，hasFooter = svrCnt > localData.count；而localData.count又是一次异步查DB的过程，所以，为了得到新的数据，我们需要先查DB得到当前position相关的DB数据（一个cursor），同时做一次cursor.getCount()得到hasFooter（一个boolean），这里就涉及到一个刷新策略的问题：

* Q 新数据与footer应该分别刷新listview还是等两个数据都拿到再刷新listview？

* A 分别刷新有两个问题，1，性能问题，2，数据不一致问题，这两个不是致命的，只是影响体验

 


