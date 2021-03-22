---
title: "Hugo"
date: 2021-03-19T21:13:05+08:00
draft: false
tags: [”hugo“,"页面静态化"]
categories: ["实践","页面静态化"]
---

- [官网](https://gohugo.io/)

## 快速入门

### Create a New Site

```cmd
hugo new site quickstart
```

### Add Some Content

```cmd
hugo new posts/my-first-post.md
```

### Start the Hugo server

```cmd
hugo server -D
```

### Build static pages

```cmd
hugo -D
```

## 常用配置

### 文章默认模板

- [Archetypes | Hugo - Static Site Generator | Tutorial 8](https://www.youtube.com/watch?v=bcme8AzVh6o&list=PLLAZ4kZ9dFpOnyRlyS-liKL5ReHDcj4G3&index=8)

```cmd
themes/even/archetypes/default.md
```

自定义目录模板

```cmd
themes/even/archetypes/dir1.md

# 使用dir1.md的模板
hugo new dir1/c.md
```

### tags、categories

- [Taxonomies | Hugo - Static Site Generator | Tutorial 10](https://www.youtube.com/watch?v=pCPCQgqC8RA&list=PLLAZ4kZ9dFpOnyRlyS-liKL5ReHDcj4G3&index=10)

Markdown 文件

```md
---
title: "第七章 Linux 磁盘与文件系统管理"
date: 2021-03-17T13:31:34+08:00
draft: true
tags: ["Linux", "tag1"]
categories: ["游戏", "乐途"]
---
```

config.toml

```toml
[taxonomies]
  tag = "tags"
  series = "series"
  category = "categories"
```

**重启服务后生效**

### HTML 文件中使用变量

- [Data Files | Hugo - Static Site Generator | Tutorial 20](https://www.youtube.com/watch?v=FyPgSuwIMWQ&list=PLLAZ4kZ9dFpOnyRlyS-liKL5ReHDcj4G3&index=20)
- 官方文档 [Data Templates](https://gohugo.io/templates/data-templates/)

**只有在 html 文件中起作用！**

### 自定义目录的 index.html

- [List Page Templates | Hugo - Static Site Generator | Tutorial 12](https://www.youtube.com/watch?v=8b2YTSMdMps&list=PLLAZ4kZ9dFpOnyRlyS-liKL5ReHDcj4G3&index=12)
- 官方文档 [Data Templates](https://gohugo.io/templates/data-templates/)

### 使用本地图片

将图片放置在 **static** 目录下

### 在新标签页打开连接

-  [Markdown Render Hooks](https://gohugo.io/getting-started/configuration-markup)

layouts/_default/_markup/render-link.html

```html
<a href="{{ .Destination | safeURL }}"{{ with .Title}} title="{{ . }}"{{ end }}  target="_blank" {{ if strings.HasPrefix .Destination "http" }} rel="noopener"{{ end }}>{{ .Text | safeHTML }}</a>
```


## toml

- [TOML 官方文档 汉化](https://github.com/LongTengDao/TOML/blob/%E9%BE%99%E8%85%BE%E9%81%93-%E8%AF%91/toml-v1.0.0.md)

## 添加 标签

- [Blog养成记(4) Hugo中增加tags等分类](https://orianna-zzo.github.io/sci-tech/2018-01/blog%E5%85%BB%E6%88%90%E8%AE%B04-hugo%E4%B8%AD%E5%A2%9E%E5%8A%A0tags%E7%AD%89%E5%88%86%E7%B1%BB/)