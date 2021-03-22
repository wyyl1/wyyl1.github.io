# 第 20 章 面向对象和函数式编程的混合：Java 和 Scala 的比较

## 20.1 Scala 简介

### 20.1.2 基础数据结构：List、Set、Map、Tuple、Stream以及Option

Java中提供了多种方法以创建不可修改的（unmodifiable）集合。Java中提供了多种方法以创建不可修改的（unmodifiable）集合

```java
Set<Integer> numbers = new HashSet<>();
Set<Integer> newNumbers = Collections.unmodifiableSet(numbers);
```

- 这意味着你无法通过操作变量newNumbers向其中加入新的元素。
- 不过，不可修改集合仅仅是对可变集合进行了一层封装。
- 通过直接访问numbers变量，你还是能向其中加入元素。
- 与此相反，不可变（immutable）集合确保了该集合在任何时候都不会发生变化，无论有多少个变量同时指向它。

## 20.2 函数

### 20.2.1 Scala 中的一等函数

### 20.2.1 匿名函数和闭包

### 20.2.3 柯里化

## 20.3 类和 trait

### 20.3.1 更加简洁的 Scala 类

### 20.3.2 Scala 的 trait 与 Java8 的接口对比

