# 对于所有对象都通用的方法
## equals
Object本身的equals区分了内存中对象是否是同一个：
- 不需要覆盖equals的情况：
  - 类的每个实例本质上都是唯一的
  - 不关心类是否“逻辑相等”
  - 父类已经覆盖了equals
- 防止私有类的equals被调用，需要覆盖：
```java
@Override public boolean equals(Object o) {
    throw new AssertionError();
}
```
- 需要覆盖equals的情况：value class

equals -> 等价关系：自反，对称，传递，一致

object equals(null)需要返回false
