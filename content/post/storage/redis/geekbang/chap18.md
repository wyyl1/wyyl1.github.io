---
title: "18 | 波动的响应延迟：如何应对变慢的Redis？（上）"
date: 2021-04-01T20:30:05+08:00
draft: false
tags: ["Redis"]
categories: ["存储"]
---

- [原文](https://time.geekbang.org/column/article/286549)

## Redis 真的变慢了吗？

### 查看 Redis 的响应延迟

- 当前环境下的 Redis 基线性能
- redis-cli 命令提供了–intrinsic-latency 选项，可以用来监测和统计测试期间内的最大延迟，这个延迟可以作为 Redis 的基线性能。其中，测试时长可以用–intrinsic-latency 选项的参数来指定。
- 为了避免网络对基线性能的影响，这个命令需要在服务器端直接运行，这也就是说，我们**只考虑服务器端软硬件环境的影响**
- 想了解网络对 Redis 性能的影响，一个简单的方法是用 **iPerf** 这样的工具，测量从 Redis 客户端到服务器端的**网络延迟**

## 如何应对 Redis 变慢？

### 1. 慢查询命令（Redis 自身操作特性的影响）

[Redis 官方文档](https://redis.io/commands/)中对每个命令的**复杂度**都有介绍

当发现 Redis 性能变慢时，可以通过 **Redis 日志**，或者是 **latency monitor 工具**，查询变慢的请求，根据请求对应的具体命令以及官方文档，确认下是否采用了复杂度高的慢查询命令。

如果的确有大量的慢查询命令，有两种处理方式：

- **1. 用其他高效命令代替。比如说，如果你需要返回一个 SET 中的所有成员时，不要使用 SMEMBERS 命令，而是要使用 SSCAN 多次迭代返回，避免一次返回大量数据，造成线程阻塞。**
- **2. 当你需要执行排序、交集、并集操作时，可以在客户端完成，而不要用 SORT、SUNION、SINTER 这些命令，以免拖慢 Redis 实例。**

比较容易忽略的慢查询命令，就是 KEYS。它用于返回和输入模式匹配的所有 key

  - **因为 KEYS 命令需要遍历存储的键值对，所以操作延时高**
  - **KEYS 命令一般不被建议用于生产环境中**

例如，以下命令返回所有包含“name”字符串的 keys。

```cmd
redis> KEYS *name*
1) "lastname"
2) "firstname"
```

### 2. 过期 key 操作（Redis 自身操作特性的影响）

**频繁使用带有相同时间参数的 EXPIREAT 命令设置过期 key**，这就会导致，在同一秒内有大量的 key 同时过期

排查建议和解决方法

- 检查业务代码在使用 EXPIREAT 命令设置 key 过期时间时，是否使用了相同的 UNIX 时间戳
- 有没有使用 EXPIRE 命令给批量的 key 设置相同的过期秒数
- 因为，这都会造成大量 key 在同一时间过期，导致性能变慢
- 可以在 EXPIREAT 和 EXPIRE 的过期时间参数上，加上一个一定大小范围内的随机数，这样，既保证了 key 在一个邻近时间范围内被删除，又避免了同时过期造成的压力