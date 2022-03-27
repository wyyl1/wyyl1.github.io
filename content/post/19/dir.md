---
title: "TDD 学习笔记 | 极客时间 | 徐昊·TDD 项目实战 70 讲"
date: 2022-03-20T00:00:00+08:00
draft: false
tags: ["TDD","目录","极客时间"]
categories: ["学习笔记"]
---

## 简介

> [《极客时间|徐昊·TDD 项目实战 70 讲》](http://gk.link/a/11giR)学习笔记

## 目录

- [01｜TDD演示（1）：任务分解法与整体工作流程](../01) [课程原文链接](http://gk.link/a/11giM)
- [02｜TDD演示（2）：识别坏味道与代码重构](../02) [课程原文链接](http://gk.link/a/11glh)
- [03｜TDD演示（3）：按测试策略重组测试](../03) [课程原文链接](http://gk.link/a/11gHt)
- [04｜TDD演示（4）：实现对于列表参数的支持](../04) [课程原文链接](http://gk.link/a/11hjF)
- [05 06 07｜TDD中的测试](../05)

## 扩展学习

- Martin Folwer [《Mocks Aren't Stubs》](https://martinfowler.com/articles/mocksArentStubs.html)，对于不同的测试替身给予了充分的说明
- Martin Folwer [《UnitTest》](https://martinfowler.com/bliki/UnitTest.html)，TDD 社区所谓的单元测试到底是：**能提供快速反馈的低成本的研发测试**

## 学习群分享

### 有哪些状态验证技术推荐吗？

- 做各种fake mountainbike,mock,in men do, test container
- 目的就是尽量少做行为验证
- **所谓测试策略 就是在保证有效性的同时 尽可能降低测试成本**
- 维持测试有效性 有个最小成本
- 小过这个 测试就无效了 或者不足以支撑长期演化（重构）
- 所以你没办法一直缩短测试时间
- 这也是我们讲的 始终使用状态验证 防止测试失效
- 在状态验证里 通过stub 偷换fake 降低成本

## 热心群友推荐

- [Task：镶金玫瑰-重构](https://www.yuque.com/thinkdeeeper/pgd5kq/vbqc7t)
- [Java Web 项目单元测试/集成测试](https://www.bilibili.com/video/BV1YU4y1a73N?share_source=copy_web)