---
title: "27 | 缓存被污染了，该怎么办？"
date: 2021-04-06T10:30:05+08:00
draft: false
tags: ["Redis"]
categories: ["存储"]
---

- [原文](https://time.geekbang.org/column/article/297270)

> 在一些场景下，有些数据被访问的次数非常少，甚至只会被访问一次。当这些数据服务完访问请求后，如果还继续留存在缓存中的话，就只会白白占用缓存空间。这种情况，就是缓存污染。

## 如何解决缓存污染问题？

Redis 8 种数据淘汰策略吗: noeviction、volatile-random、volatile-ttl、volatile-lru、volatile-lfu、allkeys-lru、allkeys-random 和 allkeys-lfu

**与 LRU 策略相比，LFU 策略中会从两个维度来筛选并淘汰数据：**

- 一是，数据访问的时效性（访问时间离当前时间的远近）
- 二是，数据的被访问次数

### 侧重点

- LRU 策略更加**关注数据的时效性**
- LFU 策略更加**关注数据的访问频次**