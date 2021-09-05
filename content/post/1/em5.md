---
title: "加餐（五） | Redis有哪些好用的运维工具？"
date: 2021-04-17T21:01:12+08:00
draft: false
tags: ["Redis","运维"]
categories: ["存储"]
---

[极客时间 | 《Redis核心技术与实战》学习笔记目录](../dir)

[原文](https://time.geekbang.org/column/article/305195)

## 最基本的监控命令：INFO 命令

> INFO 命令会返回丰富的实例运行监控信息，这个命令是 Redis 监控工具的基础

无论是单实例或是集群，建议重点关注一下 **stat、commandstat、cpu 和 memory 这四个参数的返回结果**，这里面包含了命令的执行情况（比如命令的执行次数和执行时间、命令使用的 CPU 资源），内存资源的使用情况（比如内存已使用量、内存碎片率），CPU 资源使用情况等，这可以帮助我们判断实例的运行状态和资源消耗情况。

## 面向 Prometheus 的 Redis-exporter 监控

## 数据迁移工具 Redis-shake

## 集群管理工具 CacheCloud