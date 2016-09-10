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

## 构造参数多的时候，使用Builder
- M1: 多参数重载构造函数
> 代码可读性差
- M2：Java Bean（setter，getter）
  - 简单
  - set过程中对象属性不完整
  - 不能单例化
- M3:Builder
```java
public class Line {
    private final int length;
    private final int id;
    public static class Builder {
        private final int id;
        private final int length = 0;
        public Builder(int id) {
            this.id = id;
        }
        
        public Builder length(int len) {
            length = len;
            return this;
        }
        public Line build() {
            return new Line(this);
        }
    }
    private Line(Builder builder) {
        id = builder.id;
        length = builder.length;
    }
    public static void main(String[]args) {
        Line line = new Line.Builder(0).length(1).build();
    }
}
```
   - 传递构造参数时像setter一样明确
   - build()调用构造器时，可以执行参数检查进行约束，在build之后才使用返回类，就能保证属性的完整性。
   - 可以向Builder传递模板参数，让它的build()方法返回任意类型
   - Class.newInstance调用无参构造函数，但无参构造函数不存在时，编译不会报错，而Builder的检查则弥补了这一点。

## 私有构造器或枚举类型实现单例
- M1：
```java
public class Elvis {
    public static final Elvis INSTANCE = new Elvis();
    private Elvis() {}
    public void leaveTheBuilding(){}
}
```

> 反射可以调用到私有的构造器

- M2:
```java
public class Elvis {
    private static final Elvis INSTANCE = new Elvis();
    private Elvis() {}
    public static Elvis getInstance() {return INSTANCE;}
    public void leaveTheBuilding() {}
}
```

> 灵活，可以通过修改getInstance()方法，决定是否返回单例对象

- 防止反序列化出错
```java
private Object readResolve() {
    return INSTANCE;
}
```
- 枚举单例（Java 1.5）
```java
public enum Elvis {
    INSTANCE;
    public void leaveTheBuilding() {}
}
```

> 简洁，序列化，防止多实例化，最佳方法

## 私有构造器以保证不可实例化
- 工具类常常是不希望被实例化的
- 对于不希望实例化的类，可以将其构造方法设置为private
```java
public class Util {
  private Util() {
      throw new AssertionError();
  }
}
```

## 避免创建不必要的昂贵对象
- 方法
  - 延迟初始化
  - 单例
  - 对象池
  - 多态层连接单例层，不需要为每个多态层创建多个单例层
  
  > 多个查询可以共用一个数据库连接
  
  - 装箱基本类型代价比基本类型更昂贵，小心自动装箱
- 注意
  - 重用对象代价太重太复杂则没有明显优化
  - 小对象的创建和销毁很廉价

## 引用泄露
java中没有内存泄露，只有引用泄露。比如一个Stack的实现：
```java
public class Stack {
    private Object[] elements;
    private int size = 0;
    // ...
    public Object pop() {
        return elements[--size];
    }
    
}
```
这里的pop操作只改变了size，而没有将elements[size-1]的引用移除，Stack对象一直持有element的引用，应该改为：
```java
public Object pop() {
    Object result = elements[--size];
    elemets[size] = null;
    return result;
}
```
通过置null去掉stack中elements数组对element对象的引用

> 在这个例子中，由于Stack是自己在管理内存，存储池包含了对象引用单元（即elements数组）

需要警惕引用泄露的情形：
- 类中有对象引用单元
- 缓存
- 监听器与回调：bind而没有unbind，好的做法是只保存回调的弱引用。
