# Effective Java 学习笔记
## 静态工厂方法代替构造器
- 有名称，接口比构造器更易懂

> BigInteger.probablePrime

- 可以实现单例、对象池、内存重用

> 单例模式

- 可以返回return类型的子类，面向接口编程
 - 可以让返回的类非public
 - 可以通过不同的工厂方法返回不同子类
 
 > Java Collections Framework

- 利用类型推导，简化模板参数
```java
Map<String, List<String>> m = HashMap.newInstance();
```
- 由于返回的子类型是private，就无法直接实例化这些子类型
- 静态工厂方法在Javadoc中没有辨识度
- 常用名称：
> valueOf, of, getInstance, newInstance, getType, newType

## 构造参数多的时候，使用Constructor
