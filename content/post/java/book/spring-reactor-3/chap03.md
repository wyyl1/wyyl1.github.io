---
title: "第 3 章 调度器"
date: 2021-07-09T21:00:03+08:00
draft: false
tags: ["Java","调度器"]
categories: ["Java","Java编程方法论:响应式Spring Reactor 3设计与实现", "Reactor"]
---

> 笔记来源：《Java编程方法论:响应式Spring Reactor 3设计与实现》ISBN:9787121394768 作者：知秋 出版时间：2020年09月

## 3.1 深入理解 Schedulers.elastic

## 3.2 深入解读 publishOn

```java
@Test
public void DemoSubscriber_test_flux_generate3() {
    final Random random = new Random();
    Flux.generate(ArrayList::new, (list, sink) -> {
        int value = random.nextInt(100);
        list.add(value);
        System.out.println("所发射元素产生的线程: "+Thread.currentThread().getName());
        sink.next(value);
        sleep(2);
        if (list.size() == 6) {
            sink.complete();
        }
        return list;
    })
            .publishOn(Schedulers.elastic(),2)
//                .publishOn(custom_Scheduler(),2)
            .map(x -> String.format("[%s] %s", Thread.currentThread().getName(), x))
            .subscribe(System.out::println);
    sleep(2000);
}
```

注释掉会有意外惊喜

- sleep(2);
- .publishOn(custom_Scheduler(),2)

## 3.3 深入解读 subscribeOn

> - 订阅只会产生一次，source.subscribe(this) 只会执行一次
> - 如果执行链中存在多个 subscribeOn 方法
>   - 只有第一个有效果
>   - 其他只执行政策的元素下发操作

## 3.4 Flux.parallel & Flowable.parallel 的并行玩法

## 3.5 ParallelFlux.runOn & ParallelFlowable.runOn 的调度实现

- 可以适配多个订阅者