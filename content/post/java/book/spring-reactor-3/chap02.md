---
title: "第 2 章 对Flux的探索"
date: 2021-07-09T21:00:02+08:00
draft: false
tags: ["Java","对Flux的探索"]
categories: ["Java","Java编程方法论:响应式Spring Reactor 3设计与实现", "Reactor"]
---

> 笔记来源：《Java编程方法论:响应式Spring Reactor 3设计与实现》ISBN:9787121394768 作者：知秋 出版时间：2020年09月

Flux

- 是可以发出 0 到 N 个元素的生产者
- 核心方法是  ``` public final void subscribe(Subscriber<? super T> actual)  ```

## 2.2 用 Flux.create 创建源

### 2.2.2 Flux 的快速包装方法

#### 支持背压的方法

- just: 可以指定序列中包含的全部元素。创建的 Flux 源序列会在发布元素之后自动结束。
- fromArray、fromIterable、fromStream: 从这些对象中创建 Flux 对象。
- empty: 创建一个不包含任何元素，只发布结束消息的源序列
- error (Throwable error): 创建一个只包含错误消息的源序列
- never: 创建一个不包含任何消息通知的序列
- range: 创建从 start 起始的 count 个 Integer 对象的源序列

#### 不支持背压的方法（想要支持背压，可手动添加 onBackpressureXXX 方法）

- interval (Duration period) 和 interval (Duration delay, Duration period): 创建一个包含了从 0 开始递增的 Long 对象的源序列

```java
@Test
void fluxCreate2_2_2() {
    Flux.just("Hello", "aoeai.com").subscribe(System.out::println);
    Flux.fromArray(new Integer[]{1,2,3,4}).subscribe(System.out::println);
    Flux.empty().subscribe(System.out::println);
    Flux.range(10, 3).subscribe(System.out::println);
    Flux.interval(Duration.ofMillis(100)).subscribe(System.out::println);
    sleep(500);
}
```

## 2.3 蛇形走位的 QueueSubscription

### 2.3.1 无界队列 SpscLinkedArrayQueue

## 2.4 Mono 的二三事

只有 0 到 1 个元素的序列
- 例如：根据 id 查找用户

## 2.5 通过 BaseSubscriber 自定义订阅者

```java
import org.reactivestreams.Subscription;
import reactor.core.publisher.BaseSubscriber;

public class DemoSubscriber <T> extends BaseSubscriber<T> {

    @Override
    public void hookOnSubscribe(Subscription subscription) {
        System.out.println("Subscribed");
        request(1);
    }

    @Override
    public void hookOnNext(T value) {
        System.out.println(value);
        request(1);
    }
}
```

- 在参与订阅的时候，会先调用 **onSubscribe** 方法，通过这个回调方法可以定义：**推** 或 **拉**
  - 拉
    - 在 hookOnSubscribe 回调方法内进行 request 方法调用
    - 然后执行中央的方法 **onNext**，其中包含最重要的消费逻辑，所以必须重写 hookOnNext 回调方法
    - hookOnXXX 方法都是空实现，需要根据自己的实际情况重写
  - 推：调用 request(Long.MAX_VALUE)

```java
@Test
public void DemoSubscriber_test() {
    Flux.just("Hello", "DockerX").subscribe(new DemoSubscriber<>());
}

@Test
public void DemoSubscriber_test2() {
    Flux.just("Hello", "DockerX").subscribe(new BaseSubscriber<>() {
        @Override
        protected void hookOnNext(String value) {
            System.out.println(value);
        }

        @Override
        protected void hookOnSubscribe(Subscription subscription) {
            System.out.println("Subscribed");
            requestUnbounded();
        }
    });
} 
```

## 2.6 将常见的监听器改造成响应式结构

## 2.7 Flux.push 的特殊使用场景及细节探索

- Flux.push 是 Flux.create 的一个变种，值适用处理**单线程**下生产者产生的事件
- 当确定生产端只有一个线程在生产元素，使用 Flux.push 可以因减少一层包装而**提高性能**

## 2.8 对 Flux.handle 的解读