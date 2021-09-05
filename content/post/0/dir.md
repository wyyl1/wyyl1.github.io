---
title: "Java实战（第2版）学习笔记"
date: 2021-04-15T00:00:00+08:00
draft: false
tags: ["Java","Java实战","目录"]
categories: ["Java","Java实战（第2版）","学习笔记"]
---

## 简介

- 书名：Java实战（第2版）
- 书号：978-7-115-52148-4
- 原书名：Modern Java in Action: Lambda, streams, functional and reactive programming
- 原书号：9781617293566
- 源码下载地址：https://www.ituring.com.cn/book/2659 "随书下载"处下载
- 作者：拉乌尔·加布里埃尔·乌尔玛,马里奥·富斯科,艾伦·米克罗夫特. 

## 目录

- [第 3 章 Lambda 表达式](../03)
- [第 4 章 引入流](../04)
- [第 5 章 使用流](../05)
- [第 6 章 用流收集数据](../06)
- [第 7 章 并行数据处理与性能](../07)
- [第 8 章 Collection API 的增强功能](../08)
- [第 9 章 重构、测试和调试](../09)
- [第 10 章 基于 Lambda 的领域特定语言](../10)
- [第 11 章 用 Optional 取代 null](../11)
- [第 12 章 新的日期和时间 API](../12)
- [第 14 章 Java 模块系统](../14)
- [第 15 章 CompletableFuture 及反应式编程背后的概念](../15) 🦋
- [第 16 章 CompletableFuture：组合式异步编程](../16) 🦋
- [第 17 章 反应式编程](../17)
- [第 18 章 函数式的思考](../18)
- [第 19 章 函数式编程的技巧](../19)
- [第 20 章 面向对象和函数式编程的混合：Java 和 Scala 的比较](../20)
- [第 21 章 结论以及 Java 的未来](../21)

## 随书源码说明
Java8InAction
===============

This repository contains all the source code for the examples and quizzes in the book Java 8 in Action: Lambdas, Streams and functional-style programming.

You can purchase the book here: [http://manning.com/urma/](http://manning.com/urma/) or on Amazon

The source code for all examples can be found in the directory [src/main/java/lambdasinaction](https://github.com/java8/Java8InAction/tree/master/src/main/java/lambdasinaction)

* Chapter 1: Java 8: why should you care?
* Chapter 2: Passing code with behavior parameterization
* Chapter 3: Lambda expressions
* Chapter 4: Working with Streams
* Chapter 5: Processing data with streams
* Chapter 6: Collecting data with streams
* Chapter 7: Parallel data processing and performance
* Chapter 8: Refactoring, testing, debugging
* Chapter 9: Default methods
* Chapter 10: Using Optional as a better alternative to null
* Chapter 11: CompletableFuture: composable asynchronous programming
* Chapter 12: New Date and Time API
* Chapter 13: Thinking functionally
* Chapter 14: Functional programming techniques
* Chapter 15: Blending OOP and FP: comparing Java 8 and Scala
* Chapter 16: Conclusions and "where next" for Java
* Appendix A: Miscellaneous language updates
* Appendix B: Miscellaneous library updates
* Appendix C: Performing multiple operations in parallel on a Stream
* Appendix D: Lambdas and JVM bytecode
We will update the repository as we update the book. Stay tuned!

### Make sure to have JDK8 installed
The latest binary can be found here: http://www.oracle.com/technetwork/java/javase/overview/java8-2100321.html

$ java -version

java version "1.8.0_05"
Java(TM) SE Runtime Environment (build 1.8.0_05-b13)
Java HotSpot(TM) 64-Bit Server VM (build 25.5-b02, mixed mode)


You can download a preview version here: https://jdk8.java.net/

### Compile/Run the examples
Using maven:

$ mvn compile

$ cd target/classes

$ java lambdasinaction/chap1/FilteringApples


Alternatively you can compile the files manually inside the directory src/main/java

You can also import the project in your favorite IDE:
    * In IntelliJ use "File->Open" menu and navigate to the folder where the project resides
    * In Eclipse use "File->Import->Existing Maven Projects" (also modify "Reduntant super interfaces" to report as Warnings instead of Errors
    * In Netbeans use "File->Open Project" menu