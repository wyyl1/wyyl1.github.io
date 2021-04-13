---
title: "The Gremlin Console"
date: 2021-04-12T09:53:05+08:00
draft: false
tags: ["Gremlin","Apache TinkerPop"]
categories: ["存储"]
---

- [The Gremlin Console 官网文档](https://tinkerpop.apache.org/docs/current/tutorials/the-gremlin-console/)
- 需要参考官网图数据关系示例图学习

找到 V(1) 不同类型的箭头指向的 V（顶点）- **只能找到部分顶点**
```gremlin
g.V(1).outE().
           group().
             by(label).
             by(inV())
```

**valueMap()** 以 Map 格式返回
使用 next() 有时可以 Map 格式返回

```gremlin
g.V(1).outE().
           group().
             by(label).
             by(inV()).next()
```

找到 V(1) 不同类型的箭头指向的 V（顶点）- **看起来能找到全部顶点**

```gremlin
g.V(1).outE().
           group().
             by(label).
             by(inV().fold()).next()
```

## Use Case: Ad-hoc Analysis

```gremlin
gremlin> graph = TinkerFactory.createTheCrew()
==>tinkergraph[vertices:6 edges:14]
gremlin> g = traversal().withEmbedded(graph)
==>graphtraversalsource[tinkergraph[vertices:6 edges:14], standard]
gremlin>
gremlin> g.V().hasLabel('person').valueMap()
==>[name:[marko],location:[san diego,santa cruz,brussels,santa fe]]
==>[name:[stephen],location:[centreville,dulles,purcellville]]
==>[name:[matthias],location:[bremen,baltimore,oakland,seattle]]
==>[name:[daniel],location:[spremberg,kaiserslautern,aachen]]
```

cassandra