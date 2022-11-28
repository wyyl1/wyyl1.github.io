---
title: "故事"
date: 2022-06-05T00:00:02+08:00
draft: true
tags: ["TDD","极客时间"]
categories: ["学习笔记"]
---

## 日常工作

大家好，我是 aoe（读音是汉语拼音），是一名普通的 Java 程序员。日常的主要分工作是：先根据产品部门提出的需求文档评估开发时间，经过几轮激烈的讨论后，或调整功能的优先级顺序或删减功能，
最终根据已定上线日期倒推出开发计划。紧接着就是按计划开发，直至上线。另一部分的工作是排查修改 Bug：有的来新功能、有的来自改动代码引起，最头疼的是时不时来自线上出现的小 Bug 和下班后收到一些需要紧急处理的 Bug。
虽然排查、修复 Bug 几乎占用了 50% 的工作时间，但整体项目进度处于可控状态，线上各项主要功能运行良好，直到有一天，出现了一个非常严重的 Bug ！

## 为什么会关注遗留系统

故事是这样的：我们公司的产品是一款语聊 App，聊天室内用户赠送给主播礼物，主播收到礼物后可以获得报酬 = 礼物价值 ✖️ **主播分成比例**。本次的需求是根据主播评级动态获取**主播分成比例**。正常逻辑是先从 Redis 获取，
如果 Redis 中没有再从数据库获取，如果数据库中也没有就返回一个默认值并保存至  Redis。问题就出在默认值，正常情况下**主播分成比例**应该小于 100%，但由于我的失误，返回了一个无意义的值 -1，在计算主播收益时
所有参与运算的数据都**取绝对值**后再运算，这样 -1 就变成了 1，**主播分成比例**变成了 100%。当财务部门给主播结算报酬时发现要多出几十万，往日不起眼的小 Bug 瞬间升级成了重大 Bug，幸亏发现及时才没有造成更大损失。

这次事件为我敲响了警钟，也开始认真思考如何避免类似问题再次发生，当时的解决方案是：新业务、老系统修改关键业务时引入 TDD ，缩短发现 Bug 的时间，提高代码质量，发现问题时可以及时重构。在此十分感谢公司包容的管理模式，
允许我在开发中尝试 TDD。当时还不知道这就是属于遗留系统现代化，回想起来还真是“万事开头难，开头后更难”。

## 遗留系统现代化实战

第一步：先跟着《Java测试驱动开发》、《测试驱动开发的艺术》两本书练习，同时在项目中使用 TDD。起初思考怎么写测试会占用大部分开发时间，相对于之前的进度也慢了不少。经过一段时间的实践与思考，找出了存在的问题：1、方法
内包含了太多功能，违反了单一原则，所以导致构造测试非常困难。初学者可以将一个方法的代码控制在 10 行，一般来说可以很轻松的构造出该方法的测试用例。如果这样还不能解决问题，分享一下我的学习经验供你参考。郑烨老师的四个专栏
《软件设计之美》、《代码之丑》、《10x程序员工作法》、《程序员的测试课》；王争老师的专栏《设计模式之美》；徐昊老师的专栏《徐昊 · TDD项目实战70讲》；《Head First 设计模式》、《代码整洁之道》、《修改代码的艺术》、《重构》。

第二步：降低核心业务的认知负载。项目中大量使用消息队列驱动业务，虽然降低了耦合性，但极大提高了认知负载。例如使用 SkyWalking 追踪送礼物接口，得到的调用链长度是 300+，业务逻辑一眼望不到尽头。面对这样的庞然大物我先根据数据
流经的系统画出相关系统之间的关系图；然后在分别进入各个系统，探索具体的实现细节，遇到复杂的逻辑梳理出流程图，有效的降低了认知负载。另一种是针对第三方支付的业务特点，提取出了公共接口、合并了相同逻辑的操作。例如每个支付接口都可以通过 HTTPS 请求发起，所以发起请求、保存请求参数和返回结果、接收第三方回调这些操作全部由基类统一处理；不同支付平台对接时只需要按各自要求转换请求参数，解析返回结果、回调数据，就可以完成对接。

第三步：通过植物绞杀模式改造老接口。分享一下如何改造调用链 300+ 送礼物接口。该业务横跨 8 个系统，每个系统中大部分方法的功能都是纠缠不清，很难编写测试，所以干脆新开了一个项目针对遗留系统的接口进行功能测试。这样的好处是测试代码
可以合理规划功能模块，摆脱遗留代码的束缚；编写测试相关代码时可以保持愉悦的心情，因为写的是现代化的代码。测试代码主要记录送礼前后赠送人、受赠人在不同系统的状态（例如钱包余额、礼物数量、亲密度等），再结合送礼的数量和价格验证数据是否正确。有了完整的功能测试做保障后，就可以随心所欲的改造老接口，只要每个功能点改动后立即运行一下测试就能知道结果，顺利替换老接口。

## 现代化带来的好处

最大的好处是排查线上 Bug 的时间越来越少，大部分 Bug 都在 TDD 阶段被解决，而且可以快速定位问题，不但提升了代码质量，还提升了开发效率。同时也拓展了知识面，学到了很多新知识。

## 总结

掌握 TDD 是遗留系统现代化的基础，推荐从 TDD 开启实战。