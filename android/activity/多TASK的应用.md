## 多TASK的应用

这部分的想法都是基于以下两点：

> 1.Activity可能被复用，可能是复用Activity的功能，还可能是复用Activity的状态；

> 2.Task的作用：target，同一个task中的Activity服务于相同的或者接近的目标（target）。

（一个task的目标往往由task的root Activity决定，因为是root Activity造就了这个task）。

 

**Activity复用情景1：**

>在当前App中，通过Intent，打开了当前App或其他App的一个Activity（standard或singleTop），则这个Activity变成当前task的一部分。

>即：在当前task中打开了一个activity。

**使用理由：**

为了完成task的目标，需要新的Activity的完全参与进来，需要它成为task的一部分，可以这样子复用；

 

**Activity复用情景2：**

>在当前App中，通过Intent，使用FLAG_ACTIVITY_NEW_TASK打开了当前App（新Activity的task_affinity与当前app中其他Activity不同）或其他App的一个Activity（非singleInstance），

* 假如这个Activity没有被打开过，且没有一个task的affinity与这个Activity相同，则这个Activity变为新的task的root Activity，创建了一个新的task。

* 如果有其他的task的affinity与这个Activity相同，则会将旧的task调起，将这个Activity在这个task中打开，

* 假如这个Activity已经被打开过，则会将旧的task调起，如果配合FLAG_ACTIVITY_CLEAR_TOP标签，新的Activity以上的Activity会被销毁，也就是打开了一个全新的Activity以供复用。

* 如果要打开的Activity为singleTask，不论有没有加FLAG_ACTIVITY_CLEAR_TOP标签，都有上层Activity出栈的效果。

以上四种情况都可以归纳为在新的task中打开了要复用的Activity。

**使用理由：**

为了完成task的目标，需要用到新的Activity，但是这个Activity的功能，与原来task的目标有一定差距，体验上是一个新的功能，则需要创建一个独立的task，在这个task完成它的任务后，旧的task可能就不关心这个task了（比如新的task中的activity只是显示一个通知，让用户看一眼，看完就可以不管），或者，新的Activity不应该过度参与到旧的task中，（比如通知看完了就不应该再存在在task中），这种情况下就可以这样复用。

 

与第一种复用情形还有一个区别，这个Task中的Activity在被销毁前是可以被其他task重用的。

 

**Activity复用情景3：**

在当前App中，通过Intent，打开了一个SingleInstance的Activity，会创建一个新的task，且新的task中永远只有一个Activity。

**使用理由：**

与复用情形2一样，因为新的Activity的功能与原来的task的目标有一定差距，所以不能视为同一个task，所以要在新的task中打开这个Activity。

但与情形2不同的是，情形2中，旧的task不关心打开的新Activity，但打开的新Activity所在的task，可以继续创建Activity为新task的目标服务（比如添加附件功能）。

 

而在情形3中，新的task只有一个目标，就是发挥当前Activity的功能。不愿过多地执行更多功能，就需要使用singleInstance的模式。（比如打电话就是纯粹的打电话，打完电话该做什么不是打电话所在的这个task该关心的）

另一方面，新的task在被复用的时候，不会增加Activity，也可以保证其他task重用这个task的时候，不会受到其他task复用时新增Activity的影响。

 

情形2和情形3使得创建后的Activity可以被复用，节省了创建时的开销。
