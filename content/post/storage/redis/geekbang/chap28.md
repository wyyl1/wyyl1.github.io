---
title: "28 | Pika：如何基于SSD实现大容量Redis？"
date: 2021-04-06T18:30:05+08:00
draft: false
tags: ["Redis"]
categories: ["存储"]
---

- [原文](https://time.geekbang.org/column/article/298205)

基于大内存的大容量实例在实例恢复、主从同步过程中会引起一系列潜在问题，例如

- 恢复时间增长
- 主从切换开销大
- 缓冲区易溢出

固态硬盘版 Redis [Pika](https://github.com/Qihoo360/pika) （360 开源项目）

- [vire-benchmark](https://deep011.github.io/vire-benchmark)是一个用于压测KV系统的工具（目前支持redis协议和memcached协议）

## Pika 设计目标

- 单实例可以保存大容量数据，同时避免了实例恢复和主从同步时的潜在问题
- 和 Redis 数据类型保持兼容，可以支持使用 Redis 的应用平滑地迁移到 Pika 上

## 大内存 Redis 实例的潜在问题

- 内存快照 RDB 生成和恢复效率低
- 主从节点全量同步时长增加、缓冲区易溢出

## Pika 的整体架构

## Pika 的其他优势与不足

### 优点

- Pika 单实例能保存更多的数据了，实现了实例数据扩容
- 实例重启快
- 主从库重新执行全量同步的风险低

### 不足

- 降低数据的访问性能