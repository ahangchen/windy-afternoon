# ACTIVITY四种LAUNCHMODE


#### **1.Standard**

默认模式，多次实例化，按序入栈出栈。

#### **2.SingleTop**

栈顶Activity不会被重复创建，会触发onNewIntent()事件，不在栈顶时可以多次实例化。

#### **3.SingleTask**

Developer.android.com的说法：

> （1）新建一个task，创建一个Activity；

> （2）如果存在一个不同的task包含这个Activity的实例，会切换到这个task，将这个Activity以上的Activity弹出，并且触发这个Activity的onNewIntent事件；

（2）描述了不会新建task的情况，但是：

实验发现（2）的前提条件，有一点问题：

**（1）“包含这个Activity的实例”不是必要条件：**

如果没有一个task包含这个Activity的实例，但是，存在一个task包含与这个Activity属于同一个App的其他Activity的实例，这时不会新建task，而是切换到这个task中，在这个task中新建这个Activity。

**（2） “不同的task”不是必要条件：**

如果不存在一个不同的task包含这个Activity的实例，但是在当前的task中本身就存在这个Activity实例，不会新建task，而会在当前task中，将这个Activity以上的Activity弹出，并且触发这个Activity的onNewIntent事件；

#### **4.SingleInstance**

（1）如果没有一个task包含这个Activity的实例，会新建一个task，创建一个Activity；

（2）如果存在一个task包含这个Activity的实例，会切换到这个task，并且触发这个Activity的onNewIntent事件，Activity独占task。没有描述弹出其他Activity的必要。

（3）在包含这个Activity的task中，仅包含这个一个Activity，如果需要打开新的Activity，必须在其他task中打开，如果新建了task，task的根activity为新打开的这个Activity，之后打开这个Activity时，都不会新建Activity，只会将这个task带到前台。

