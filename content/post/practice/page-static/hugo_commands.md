---
title: "Hugo 常用命令"
date: 2021-08-26T21:13:05+08:00
draft: false
tags: [”hugo“,"常用命令"]
categories: ["实践","页面静态化"]
---

## 更新升级

**查看版本**

```cmd
hugo version
```

**使用 Brew 升级 hugo 版本**

```cmd
brew upgrade hugo
```

## 日常使用

**Create a New Site**

```cmd
hugo new site quickstart
```

**Add Some Content**

```cmd
hugo new posts/my-first-post.md
```

**Start the Hugo server**

```cmd
hugo server -D

hugo server -D -p 1314

hugo server -D -p 1315 --config config-aoeai.toml
```

**Build static pages**

```cmd
hugo -D

hugo --config config-aoeai.toml -D
```