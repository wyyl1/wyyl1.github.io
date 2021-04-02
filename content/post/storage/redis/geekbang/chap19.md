---
title: "19 | 波动的响应延迟：如何应对变慢的Redis？（下）"
date: 2021-04-01T21:30:05+08:00
draft: false
tags: ["Redis"]
categories: ["存储"]
---

- [原文](https://time.geekbang.org/column/article/287819)

## 文件系统：AOF 模式

- write 只要把日志记录写到内核缓冲区，就可以返回了，并不需要等待日志实际写回到磁盘
- fsync 需要把日志记录写回到磁盘后才能返回，时间较长

| AOF 写回策略 | 执行的系统调用|
| --- | --- |
| no | 调用 write 写日志文件，由操作系统周期性地将日志写回磁盘 |
| everysec | 每秒调用一次 fsync，将日志写回磁盘 |
| always | 每执行一个操作，就调用一次 fsync 将日志写回磁盘 |

使用 **everysec** 时，Redis 允许丢失一秒的操作记录

- Redis 主线程并不需要确保每个操作记录日志都写回磁盘
- Redis 会使用后台的子线程**异步**完成 fsync 的操作

使用 **always** 时，Redis 需要确保每个操作记录日志都写回磁盘，如果用后台子线程异步完成，主线程就无法及时地知道每个操作是否已经完成了

- Redis 使用主线程**同步**完成

### AOF 重写

- 为了避免日志文件不断增大，Redis 会执行 AOF 重写，生成体量缩小的新的 AOF 日志文件
- AOF 重写本身需要的时间很长，也容易阻塞 Redis 主线程，所以，Redis 使用**子进程**来进行 AOF 重写

**潜在的风险点**：AOF 重写会对磁盘进行大量 IO 操作，同时，fsync 又需要等到数据写到磁盘后才能返回，所以，当 AOF 重写的压力比较大时，就会导致 fsync 被阻塞。虽然 fsync 是由后台子线程负责执行的，但是，主线程会监控 fsync 的执行进度。

如果业务应用对延迟非常敏感，但同时允许一定量的数据丢失，那么，可以把配置项 no-appendfsync-on-rewrite 设置为 yes

```cmd
no-appendfsync-on-rewrite yes
```

- 这个配置项设置为 yes 时，表示在 AOF 重写时，不进行 fsync 操作

## 操作系统：swap

- 有命令可以查看有多少数据量发生了 swap
- 最直接的解决方法就是**增加机器内存**

## 操作系统：内存大页

在实际生产环境中部署时，建议你不要使用内存大页机制，操作也很简单，只需要执行下面的命令就可以了：

```cmd
echo never /sys/kernel/mm/transparent_hugepage/enabled
```

## 小结

### Redis 性能变慢时，9 个检查点的 Checklist

1. 获取 Redis 实例在当前环境下的基线性能。
2. 是否用了慢查询命令？如果是的话，就使用其他命令替代慢查询命令，或者把聚合计算命令放在客户端做。
3. 是否对过期 key 设置了相同的过期时间？对于批量删除的 key，可以在每个 key 的过期时间上加一个随机数，避免同时删除。
4. 是否存在 bigkey？ 对于 bigkey 的删除操作，如果你的 Redis 是 4.0 及以上的版本，可以直接利用异步线程机制减少主线程阻塞；如果是 Redis 4.0 以前的版本，可以使用 SCAN 命令迭代删除；对于 bigkey 的集合查询和聚合操作，可以使用 SCAN 命令在客户端完成。
5. Redis AOF 配置级别是什么？业务层面是否的确需要这一可靠性级别？如果我们需要高性能，同时也允许数据丢失，可以将配置项 no-appendfsync-on-rewrite 设置为 yes，避免 AOF 重写和 fsync 竞争磁盘 IO 资源，导致 Redis 延迟增加。当然， 如果既需要高性能又需要高可靠性，最好使用高速固态盘作为 AOF 日志的写入盘。
6. Redis 实例的内存使用是否过大？发生 swap 了吗？如果是的话，就增加机器内存，或者是使用 Redis 集群，分摊单机 Redis 的键值对数量和内存压力。同时，要避免出现 Redis 和其他内存需求大的应用共享机器的情况。
7. 在 Redis 实例的运行环境中，是否启用了透明大页机制？如果是的话，直接关闭内存大页机制就行了。
8. 是否运行了 Redis 主从集群？如果是的话，把主库实例的数据量大小控制在 2~4GB，以免主从复制时，从库因加载大的 RDB 文件而阻塞。
9. 是否使用了多核 CPU 或 NUMA 架构的机器运行 Redis 实例？使用多核 CPU 时，可以给 Redis 实例绑定物理核；使用 NUMA 架构时，注意把 Redis 实例和网络中断处理程序运行在同一个 CPU Socket 上。

## 强悍的留言—Kaito

### 关于如何分析、排查、解决Redis变慢问题的checklist

1. 使用复杂度过高的命令（例如SORT/SUION/ZUNIONSTORE/KEYS），或一次查询全量数据（例如LRANGE key 0 N，但N很大）

分析：a) 查看slowlog是否存在这些命令 b) Redis进程CPU使用率是否飙升（聚合运算命令导致）

解决：a) 不使用复杂度过高的命令，或用其他方式代替实现（放在客户端做） b) 数据尽量分批查询（LRANGE key 0 N，建议N<=100，查询全量数据建议使用HSCAN/SSCAN/ZSCAN）

2. 操作bigkey

分析：a) slowlog出现很多SET/DELETE变慢命令（bigkey分配内存和释放内存变慢） b) 使用redis-cli -h $host -p $port --bigkeys扫描出很多bigkey

解决：a) 优化业务，避免存储bigkey b) Redis 4.0+可开启lazy-free机制

3. 大量key集中过期

分析：a) 业务使用EXPIREAT/PEXPIREAT命令 b) Redis info中的expired_keys指标短期突增

解决：a) 优化业务，过期增加随机时间，把时间打散，减轻删除过期key的压力 b) 运维层面，监控expired_keys指标，有短期突增及时报警排查

4. Redis内存达到maxmemory

分析：a) 实例内存达到maxmemory，且写入量大，淘汰key压力变大 b) Redis info中的evicted_keys指标短期突增

解决：a) 业务层面，根据情况调整淘汰策略（随机比LRU快） b) 运维层面，监控evicted_keys指标，有短期突增及时报警 c) 集群扩容，多个实例减轻淘汰key的压力

5. 大量短连接请求

分析：Redis处理大量短连接请求，TCP三次握手和四次挥手也会增加耗时

解决：使用长连接操作Redis

6. 生成RDB和AOF重写fork耗时严重

分析：a) Redis变慢只发生在生成RDB和AOF重写期间 b) 实例占用内存越大，fork拷贝内存页表越久 c) Redis info中latest_fork_usec耗时变长

解决：a) 实例尽量小 b) Redis尽量部署在物理机上 c) 优化备份策略（例如低峰期备份） d) 合理配置repl-backlog和slave client-output-buffer-limit，避免主从全量同步 e) 视情况考虑关闭AOF f) 监控latest_fork_usec耗时是否变长

7. AOF使用awalys机制

分析：磁盘IO负载变高

解决：a) 使用everysec机制 b) 丢失数据不敏感的业务不开启AOF

8. 使用Swap

分析：a) 所有请求全部开始变慢 b) slowlog大量慢日志 c) 查看Redis进程是否使用到了Swap

解决：a) 增加机器内存 b) 集群扩容 c) Swap使用时监控报警

9. 进程绑定CPU不合理

分析：a) Redis进程只绑定一个CPU逻辑核 b) NUMA架构下，网络中断处理程序和Redis进程没有绑定在同一个Socket下

解决：a) Redis进程绑定多个CPU逻辑核 b) 网络中断处理程序和Redis进程绑定在同一个Socket下

10. 开启透明大页机制

分析：生成RDB和AOF重写期间，主线程处理写请求耗时变长（拷贝内存副本耗时变长）

解决：关闭透明大页机制

11. 网卡负载过高

分析：a) TCP/IP层延迟变大，丢包重传变多 b) 是否存在流量过大的实例占满带宽

解决：a) 机器网络资源监控，负载过高及时报警 b) 提前规划部署策略，访问量大的实例隔离部署

总之，Redis的性能与CPU、内存、网络、磁盘都息息相关，任何一处发生问题，都会影响到Redis的性能。

主要涉及到的包括业务使用层面和运维层面：业务人员需要了解Redis基本的运行原理，使用合理的命令、规避bigke问题和集中过期问题。运维层面需要DBA提前规划好部署策略，预留足够的资源，同时做好监控，这样当发生问题时，能够及时发现并尽快处理。

## 感悟

Redis 变慢？一波操作下来不快也得快