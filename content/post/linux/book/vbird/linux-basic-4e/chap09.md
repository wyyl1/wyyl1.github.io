---
title: "第九章、vim 程序编辑器"
date: 2021-04-20T10:20:00+08:09
draft: false
tags: ["Linux","vim","鸟哥的Linux私房菜-基础篇"]
categories: ["Linux","鸟哥的Linux私房菜-基础篇"]
---

> 原书：《鸟哥的Linux私房菜-基础篇》第四版 | 作者：[鳥哥](http://linux.vbird.org/)

## 9.2 vi 的使用

基本上 vi 共分为三种模式

- 一般指令模式 (command mode)
- 编辑模式 (insert mode)
  - 在一般指令模式中可以进行删除、复制、贴上等等的动作，但是却无法编辑文件内容的! 要 等到你按下“i, I, o, O, a, A, r, R”等任何一个字母之后才会进入编辑模式。注意了!通常在 Linux 中，按下这些按键时，在画面的左下方会出现“ INSERT 或 REPLACE ”的字样，此时才 可以进行编辑。而如果要回到一般指令模式时， 则必须要按下“Esc”这个按键即可退出编辑模 式。
- 命令行命令模式 (command-line mode)
  - 在一般模式当中，输入“ : / ? ”三个中的任何一个按钮，就可以将光标移动到最下面那一列。在 这个模式当中， 可以提供你“搜寻数据”的动作，而读取、存盘、大量取代字符、离开 vi 、显 示行号等等的动作则是在此模式中达成的!

### 9.2.2 按键说明

#### 光标移动

| 按键 |  功能 | 
| --- |  --- | 
| h 或方向键 (←) |  左移 | 
| j 或方向键 (↓) |  下移 | 
| k 或方向键 (↑) |  上移 | 
| l 或方向键 (→) |  右移 | 
| n(数字)  + <kbd>**空格**</kbd> |  光标**向右移动** n 个字符 🍁 **横向**| 
| 0 或 <kbd>**Home**</kbd> |  光标移动到**当前行最左边** 🍁 **横向**| 
| $ 或 <kbd>**End**</kbd>|  光标移动到**当前行最右边** 🍁 **横向**| 
| gg |  移动到文件第一行 | 
| G |  移动到文件最后一行 | 
| n(数字) + G |  移动到第 n 行 | 
| n(数字) + <kbd>**Enter**</kbd> |  光标向下移动 n 行 | 
| H |  光标移动到屏幕上方 | 
| M |  光标移动到屏幕中间 | 
| L |  光标移动到屏幕下方 | 

> 进行多次移动，例如向下移动 30 列，可以使用 **30j** 或 **30↓**

[vim 常用指令示意图](https://blog.csdn.net/deniro_li/article/details/54584100)