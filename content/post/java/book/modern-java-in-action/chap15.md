---
title: "第 15 章 CompletableFuture 及反应式编程背后的概念"
date: 2021-04-15T20:50:05+08:00
draft: false
tags: ["Java","Java实战","CompletableFuture 及反应式编程背后的概念"]
categories: ["Java","Java实战（第2版）"]
---

> 笔记来源：《Java实战（第2版）》ISBN:978-7-115-52148-4 作者：拉乌尔·加布里埃尔·乌尔玛,马里奥·富斯科,艾伦·米克罗夫特. 

### 15.1.2 执行器和线程池

03. 线程池的不足

- 如果**早期提交的任务**或者**正在执行的任务**需要**等待后续任务**，可能导致线程池**死锁**

![image](../../../../../post/java/book/modern-java-in-action/chap15-1.png)

尽量避免向线程池提交可能阻塞（譬如睡眠，或者要等待某个事件）的任务

### 15.1.3 其他的线程抽象：非嵌套方法调用

fork/join 潜在危害

- 子线程可能逃逸
- 子线程与执行方法调用的代码会并发执行，为了避免出现数据竞争，编写代码需要特小心

## 15.4 为并发而生的 CompletableFuture 和结合器

```java
  public static void main(String[] args) throws ExecutionException, InterruptedException {
      ExecutorService executorService = Executors.newFixedThreadPool(10);
      int x = 1337;

      CompletableFuture<Integer> a = new CompletableFuture<>();
      CompletableFuture<Integer> b = new CompletableFuture<>();
      CompletableFuture<Integer> c = a.thenCombine(b, (y, z)-> y + z);
      executorService.submit(() -> a.complete(f(x)));
      executorService.submit(() -> b.complete(g(x)));

      System.out.println(c.get());
      executorService.shutdown();
  }
```

###  采用 thenCombine 调度求和计算

- 它只会在 f(x) 和 g(x) 都完成之后才进行
- 避免了CompletableFuture get() 方法的阻塞

## 15.5 “发布-订阅”以及反应式编程

反应式编程三个主要概念

- 订阅者可以订阅的发布者
- 名为订阅的连接
- 消息（也叫事件），他们通过连接传输

### 15.5.2 背压

- 流量控制
- 可以限制信息传输的速率

## 15.6 反应式系统和反应式编程