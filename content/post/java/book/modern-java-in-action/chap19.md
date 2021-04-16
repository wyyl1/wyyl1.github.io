---
title: "第 19 章 函数式编程的技巧"
date: 2021-04-15T20:50:05+08:00
draft: false
tags: ["Java","Java实战","函数式编程的技巧"]
categories: ["Java","Java实战（第2版）"]
---

> 笔记来源：《Java实战（第2版）》ISBN:978-7-115-52148-4 作者：拉乌尔·加布里埃尔·乌尔玛,马里奥·富斯科,艾伦·米克罗夫特. 

## 19.1 无处不在的函数

### 19.1.1 高阶函数

- 接受至少一个函数作为参数
- 返回的结果是一个函数

### 19.1.2 柯里化

> 柯里化（英语：Currying），是把接受多个参数的函数变换成接受一个单一参数（最初函数的第一个参数）的函数，并且返回接受余下的参数而且返回结果的新函数的技术。
> 
> - 可以将具有多个参数的函数转换为一个单参数的函数链。这种转变是现在被称为“柯里化”的过程。
> 
> —— [维基百科](https://zh.wikipedia.org/wiki/%E6%9F%AF%E9%87%8C%E5%8C%96)

#### 优点

- 复用转换逻辑
- 为不同的转换因子创建不同的转换方法
- 解耦
- 可以延迟执行

#### 特点

- 返回值类型、参数类型相同
- 可以将一组参数拆成一个一个的函数组合
  - function int (int a, int b, int c) -> function int (int a)(int b)(int c)

#### 示例代码

```java
import java.util.Random;
import java.util.function.IntUnaryOperator;

/**
 * @author aoe
 * @date 2021/3/2
 */
public class Currying {

    public static void main(String[] args) {
        System.out.println("正常思维计算 " + getCoin(1,2,lucky()));

        IntUnaryOperator buyCar = curryingCoin(100_000, 1);
        System.out.println("柯里化（减少一个参数） 买车 " + buyCar.applyAsInt(lucky()));

        IntUnaryOperator buyGun = curryingCoin(300_000, 6);
        System.out.println("柯里化（减少一个参数） 买枪 " + buyGun.applyAsInt(lucky()));

        IntUnaryOperator buyFruit = curryingCoin(2_000, 10);
        System.out.println("柯里化（减少一个参数） 买水果 " + buyFruit.applyAsInt(lucky()));

        // 参数：用户等级
        IntUnaryOperator buyMotorcycle = curryingBuy(1);
        // 参数：价格
        IntUnaryOperator luckyMotorcycle = curryingLucky(buyMotorcycle.applyAsInt(555_000));
        // 参数：幸运值
        System.out.println("柯里化（只有一个参数） 买摩托车 " + luckyMotorcycle.applyAsInt(lucky()));
    }

    // 正常思维
    /**
     * 获得金币奖励
     * @param price 商品价格
     * @param userLevel 用户等级
     * @param lucky 幸运值
     * @return
     */
    static int getCoin(int price, int userLevel, int lucky){
        return (price + userLevel) * lucky;
    }

    // 柯里化入门：减少一个参数
    static IntUnaryOperator curryingCoin(int price, int userLevel){
        // 金币奖励所有计算逻辑
        return (int lucky) -> (price + userLevel) * lucky;
    }

    // 柯里化进阶：拆分为一个参数
    // 购买逻辑
    static IntUnaryOperator curryingBuy(int userLevel) {
        // 金币奖励：价格、用户等级之间的逻辑
        return (int price) -> price + userLevel;
    }

    // 幸运值逻辑
    static IntUnaryOperator curryingLucky(int buyPrice) {
        // 金币奖励所有计算逻辑 = 购买逻辑 + 幸运值逻辑
        return (int lucky) -> buyPrice * lucky;
    }

    static int lucky(){
        Random random = new Random();
        return random.ints().findAny().getAsInt();
    }
}
```

 ## 19.2 持久化数据结构

 ### 19.2.1 破坏式更新和函数式更新的比较

 ### 19.2.2 另一个使用 Tree 的例子

 ### 19.2.3 采用函数式的方法
- 通过共享内存创建不可变数据

## 19.3 Stream 的延迟计算

- 无法声明一个递归的 Stream，因为 Stream 仅能使用一次

### 19.3.1 自定义的 Stream

### 19.3.2 创建你自己的延迟列表

## 19.4 模式匹配

Java 暂时并未提供这一个特性

### 19.4.1 访问者模式

### 19.4.2 用模式匹配力挽狂澜

## 19.5 杂项

### 19.5.1 缓存或记忆表

### 19.5.2 “返回同样的对象”意味着什么

### 19.5.3 结合器