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

