## Intent Flag

FLAG_与LaunchMode相比最大的不同是临时性

**1.FLAG_ACTIVITY_NEW_TASK：**

Developer.android.com的说法：

>（1）在新的task中启动这个Activity，

>（2）如果已有一个task包含这个Activity，则这个task被带到前台。

>（3）效果与SingleTask相同。

#### **实验发现**
* 只有从外部（另外的App）启动Activity，并添加FLAG_ACTIVITY_NEW_TASK标识时，表现才与上述相符；

* 但不具有singleTask的clear_top效果。

* 而在同一个APP内启动Activity并添加FLAG_ACTIVITY_NEW_TASK时，与不添加标识效果一样，不仅不会新建task，而且新建的Activity不具有唯一性，与singleTask不完全相同。

* 在同一App内启动Activity时，如果将new_task和multi_task组合使用，就会达到打开新task的效果。


**2.FLAG_ACTIVITY_SINGLE_TOP**

打开的Activity如果在栈顶，则不创建新的实例，并且会触发onNewIntent事件。

与启动launchMode为SINGLE_TOP的Activity一致。

**3.FLAG_ACTIVITY_CLEAR_TOP**

Developer.android.com的说法：

> （1）如果当前task包含这个Activity，这个Activity以上的Activity出栈，这个Activity到达栈顶。

> （2）如果这个Activity是standard模式，这个Activity也出栈，并且重新实例化到达栈顶。

默认行为应该是清除包括这个Activity及其以上Activity的所有Activity，但如果为要启动的Activity设置了特殊的launchMode，则launchMode会影响这个Activity的销毁与否，即：

如果这个Activity是singleTop或singleTask模式，这个Activity不出栈。

singleInstance模式没有CLEAR_TOP的意义，因为它的task中只有自己一个Activity。

**4.FLAG_ACTIVITY_REORDER_TO_FRONT**

如果当前task中包含这个Activity，这个Activity被拉到栈顶，其他Activity的顺序不变，仍在task中。如果这个Activity被设置为SingleTask或者打开这个Activity的时候，还添加了CLEAR_TOP的标签，则会将这个Activity上面的Activity出栈。
