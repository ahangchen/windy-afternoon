## 一个由PROGUARD与FASTJSON引起的血案

更新微信sdk导致ComposeData中的内部类ComposeDataSender方法被混淆

根本原因，fastjson使用姿势不对。

**问题描述：**

一个发件人列表里，应当呈现的数据（这里命名为ComposeData）为空

（1）业务逻辑层

获取发件人列表时，如果Composedata超时，会从网络重新拉取Json格式的ComposeData，拉取后利用FastJson的toString()方法，将ComposeData写入DB。

混淆情况下，toString()生成的json字符串会缺少alias字段。

**定位问题到FastJson的toString()。**

（2）FastJson层

FastJson执行JSON类的toString()方法时，

对普通的Object对象（这里是ComposeDataSender），会将这个对象当做JavaBean对象处理，

在JavaBeanSerializer中，找到这个对象的getter方法，

来确定要生成的Json格式数据中，K-V的值。

在JavaBeanSerializer中打log，发现不混淆时，getter有4个（getNick(),getAlias(),getType(),getSignvalid()），混淆后，只找到一个getter（getType()）。

**定位问题到getter方法。**

（3）混淆后的ComposeDataSender

反编译没问题的旧包和有问题的新包，

**发现， 旧包的ComposeDataSender有getAlias()和getType()方法和一个被混淆后的return this.XXX方法（混淆前为getNick()方法）**

**新包的ComposeDataSender有getType()方法和两个被混淆后的return this.XXX方法（混淆前为getNick(),getAlias()方法）
**

导致发件人列表为空的原因：

获取发件人列表时，依赖于需要读取DB中的各个别名帐号的alias和type ，

旧包中，getAlias()和getType()方法没有混淆，toString()时存入DB的数据是可用的（实际上，nick字段在4.1.1也丢失了，但由于没有使用到这个字段，不会引起问题）

新包中，getType()方法没有混淆，其他getter被混淆，toString()存入DB的数据只有type（丢失了nick，alias），所以在获取发件人列表时，alias为空

（4）新包丢失alias分析

在反编译后的旧包所有代码中中查找getAlias()

可以看到mm.sdk.contact中有RContact这个类，包含了getAlias方法，因为是第三方库，其中public的getAlias方法没有被混淆，

因为proguard混淆时，同名的方法（不论是否在同一个类中）是被替换为相同的名字，（可以查看~\build\outputs\mapping\debug\mapping.txt查看混淆时变量和方法的替换规则）

所以，代码中所有getAlias方法都没有被混淆，（相同的情况还可以在ComposeDataSender里看到，accountId属性虽然是私有的，但也没有被混淆）

而新包中，更新了mm.sdk，去掉了RContact这个类，没有getAlias方法，所以ComposeDataSender里的getAlias被混淆

而getType()没有丢失：

查找getType()方法，发现在新包或旧包中的很多第三方库中仍然被保留，所以没有被混淆，toString()时仍然可以将type字段正确存入DB

（经实验，把ComposeDataSender里的type名字改为senderType，并相应地改变get方法和set方法，就会被混淆）

（5）解决方案

修改ComposeData toString()方法，原有toString()方法，在处理items这一array对象时，直接往JSONArray中存入了ComposeDataSender对象，

所以toString生成K-V时会依赖于ComposeDataSender的getter方法。

修改为：

**往JSONArray中存入JSONObject对象，将K-V信息存入JSONObject，解析时走MapSerializer流程，不需要依赖于ComposeDataSender的getter方法。不会受混淆影响。
**
 
