# 创建和销毁对象
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

## 私有构造器强化不可实例化
只包含static method和static field的对象不希望被实例化，但实际上它有默认的无参构造器，我们仍然可能实例化它。

因此通过将构造器变为私有防止实例化。
```java
public class UtilityClass {
    private UtilityClass() {
        throw new AssertionError();
    }
}
```
这种方法的一个缺点是，这种工具类无法被子类化。

## 避免创建不必要的对象
- String
```java
String s = new String("test");
```
上面这种写法每次都会重新创建两个String对象
```java
String s = "test";
```
JTS 3.10.5保证了相同内容的字符串重用同一个对象，而且只创建一次。

- 延迟初始化
- 单例
- 对象池
- 多态层连接单例层，不需要为每个多态层创建多个单例层
- static执行开销大的代码块，存储执行结果重用
- 对于一个类中，创建开销大，创建后不修改，但会多次读取的对象，适合
- 但如果static创建的对象很少使用，可以考虑延迟初始化，但延迟初始化实现复杂，也会影响性能
- 有些对象初始化后可能改变，但改变后其功能是不变的，应当保持它为一个确定的引用，然后改变引用所指对象的内容，如Map中的keySet
- 优先使用基本类型（int）而非装箱基本类型(Integer)，性能优化
- 重对象才有必要尽可能避免创建，小对象可以由JVM很容易地构造和销毁，比自己维护对象池要好得多


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

## Avoid finalize
- Note
  - finalize不保证执行，尽量不要用
  - System.gc和System.runFinalization只是增加finalize执行的机会
  - finalize有严重的性能损失
  - 通过try - catch - finally来显式释放资源
- 合理用法
  - 作为显式释放资源的backup，或者check
  - 回收native peer
- 父类finalize
  - 显式调用super.finalize()
  - 内部类强制子类执行
```java
public class Foo {
    private final Object finalizeGuardian = new Object() {
        @Override protected void finalize() throws Throwable {
            Foo.finalize();
        }
    };
}
