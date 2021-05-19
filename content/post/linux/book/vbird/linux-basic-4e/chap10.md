---
title: "第十章、认识与学习BASH"
date: 2021-04-20T10:20:00+08:10
draft: false
tags: ["Linux","BASH","鸟哥的Linux私房菜-基础篇"]
categories: ["Linux","鸟哥的Linux私房菜-基础篇"]
---

> 原书：《鸟哥的Linux私房菜-基础篇》第四版 | 作者：[鳥哥](http://linux.vbird.org/)

## 10.1 认识 BASH 这个 Shell

### 10.1.3 系统的合法 shell 与 /etc/shells 功能

- /bin/bash (就是 Linux 默认的 shell)
- 系统上合法的 shell 要写入 /etc/shells 这个文件

### 10.1.4 Bash shell 的功能

#### 命令别名设置功能: (alias)

### 10.1.5 查询指令是否为 Bash shell 的内置命令: type

### 10.1.6 指令的下达与快速编辑按钮

## 10.2 Shell 的变量功能

### 10.2.2 变量的取用与设置:echo, 变量设置规则, unset

### 10.2.3 环境变量的功能

#### 用 env 观察环境变量与常见环境变量说明

```cmd
# 列出目前的 shell 环境下的所有环境变量与其内容
env
```

#### 用 set 观察所有变量 (含环境变量与自订变量)

```cmd
set
```

#### $ : (关于本 shell 的 PID)

> **$** 本身也是个变量喔

```cmd
# PID
echo $$
```

#### ? : (关于上个执行指令的回传值)

> **?** 也是一个特殊的变量
> 在 bash 里面这个变量非常重要！这个变量 是:“上一个执行的指令所回传的值”， 上面这句话的重点是“上一个指令”与“回传值”两个地 方。当我们执行某些指令时， 这些指令都会回传一个执行后的代码。一般来说，如果成功的执行该指令，则会回传一个 0 值，如果执行过程发生错误，就会回传“错误代码”才对!一般就是以非为 0 的数值来取代。

#### export: 自订变量转成环境变量

### 10.2.4 影响显示结果的语系变量 (locale)

### 10.2.5 变量的有效范围

### 10.2.6 变量键盘读取、阵列与宣告: read, array, declare

#### read

要读取来自键盘输入的变量，就是用 read 这个指令了。这个指令最常被用在 shell script 的撰 写当中， 想要跟使用者对谈?用这个指令就对了。关于 script 的写法，我们会在**第十三章**介绍

```cmd
read [-pt] variable
选项与参数:
 -p :后面可以接提示字符!
 -t :后面可以接等待的“秒数!”这个比较有趣~不会一直等待使用者啦!
```

#### declare / typeset

declare 或 typeset 是一样的功能，就是在“宣告变量的类型”。如果使用 declare 后面并没有接任何参数，那么 bash 就会主动的将所有的变量名称与内容通通叫出来，就好像使用 set 一样啦! 

#### 数组 (array) 变量类型

### 10.2.7 与文件系统及程序的限制关系: ulimit

```cmd
ulimit [-SHacdfltu] [配额]
选项与参数:
-H :hard limit ，严格的设置，必定不能超过这个设置的数值;
-S :soft limit ，警告的设置，可以超过这个设置值，但是若超过则有警告讯息。
在设置上，通常 soft 会比 hard 小，举例来说，soft 可设置为 80 而 hard
设置为 100，那么你可以使用到 90 (因为没有超过 100)，但介于 80~100 之间时，
系统会有警告讯息通知你!
-a :后面不接任何选项与参数，可列出所有的限制额度;
-c :当某些程序发生错误时，系统可能会将该程序在内存中的信息写成文件(除错用)，
这种文件就被称为核心文件(core file)。此为限制每个核心文件的最大容量。
-f :此 shell 可以创建的最大文件大小(一般可能设置为 2GB)单位为 KBytes
-d :程序可使用的最大断裂内存(segment)容量;
-l :可用于锁定 (lock) 的内存量
-t :可使用的最大 CPU 时间 (单位为秒)
-u :单一使用者可以使用的最大程序(process)数量。
```

### 10.2.8 变量内容的删除、取代与替换 (Optional)

## 10.3 命令别名与历史命令

### 10.3.1 命令别名设置: alias, unalias

### 10.3.2 历史命令:history

## 10.4 Bash Shell 的操作环境:

### 10.4.1 路径与指令搜寻顺序

```cmd
$ type -a echo
echo is a shell builtin
echo is /usr/bin/echo
echo is /bin/echo
```

### 10.4.2 bash 的进站与欢迎讯息: /etc/issue, /etc/motd

```cmd
cat /etc/issue
```

/etc/issue.net

- 这个是提供给 telnet 这个远端登陆程序用的。 
- 当我们使用 telnet 连接到主机时，主机的登陆画面就会显示 **/etc/issue.net** 而不是 /etc/issue

如果您想要让使用者登陆后取得一些讯息，例如您想要让大家都知道的讯息， 那么可以将讯息加入 **/etc/motd** 里面去!

### 10.4.3 bash 的环境配置文件

#### login shell

只会读取这两个配置文件

1. /etc/profile:这是系统整体的设置，你最好不要修改这个文件;
2. ~/.bash_profile或~/.bash_login或~/.profile:属于使用者个人设置，你要改自己的数据，就写入这里!

在 login shell 的 bash 环境中，所读取的个人偏好配置文件其实主要 有三个，依序分别是:

1. ~/.bash_profile
2. ~/.bash_login
3. ~/.profile

#### source : 读入环境配置文件的指令

```cmd
source 配置文件文件名

source ~/.bashrc <==下面这两个指令是一样的!
. ~/.bashrc
 
```

#### non-login shell

这种非登陆情况取得 bash 操作接口的环境配置文件又是什么? 当你取得 non-login shell 时，该 bash 配置文件仅会读取 ~/.bashrc

### 10.4.4 终端机的环境设置: stty, set

| 组合按键 | 执行结果 |
| --- | --- |
| Ctrl + C | 终止目前的命令 |
| Ctrl + D | 输入结束(EOF)，例如邮件结束的时候; |
| Ctrl + M | 就是 Enter |
| Ctrl + S | 暂停屏幕的输出 |
| Ctrl + Q | 恢复屏幕的输出 |
| Ctrl + U | 在提示字符下，将整列命令删除 |
| Ctrl + Z | “暂停”目前的命令 |

### 10.4.5 万用字符与特殊符号

## 10.5 数据流重导向

### 10.5.1 什么是数据流重导向

> standard output 与 standard error output 分别代表“标准输出 (STDOUT)”与“标准错误输出 (STDERR)
> 
> 数据流重导向可以 将 standard output (简称 stdout) 与 standard error output (简称 stderr) 分别传送到其他 的文件或设备去

- 标准输入  (stdin):代码为 **0**，使用 **&lt;** 或 **&lt;&lt;**;
- 标准输出  (stdout):代码为 **1**，使用 **&gt;** 或 **&gt;&gt;**;
  - **>** 暴力覆盖
  - **>>** 顺序追加
- 标准错误输出(stderr):代码为 **2**，使用 **2&gt;** 或 **2&gt;&gt;**;
- 垃圾桶黑洞: **/dev/null**
- 结束的输入字符: **<<**

#### 输出

```cmd
# 暴力覆盖
ll > ~/rootfile
ll /home > ~/rootfile

# 顺序追加
ll >> ~/rootfile
ll /home >> ~/rootfile

# 输出错误信息
# 找一个没有权限访问 /root 目录的用户
find /root -name aoe 2> ~/errfile

# 将 stdout 与 stderr 分存到不同的文件去
find /root -name .bashrc > list_right 2> list_error

# 将错误消息丢到垃圾桶
find /root -name aoe 2> /dev/null

# 将错误的数据丢弃，屏幕上显示正确的数据
find /root -name .bashrc > list_right 2> /dev/null

# ⭐️ 将指令的数据全部写入名为 list 的文件中
find /home -name .bashrc > list 2>&1
或
find /home -name .bashrc &> list
```

#### 输入

> 将原本需要由键盘输入的数据，改由文件内容来取代

```cmd
# 利用 cat 指令来创建一个文件的简单流程
cat > catfile
testing
cat
[ctrl] + c 离开
cat catfile

# 用纯文本文件取代键盘的输入
cat > catfile < ~/.bashrc

# 用 cat 直接将输入的讯息输出到 catfile 中， 且当由键盘输入 eof 时，该次输入就结束
cat > catfile << "eof"
1
2
eof
```

### 10.5.2 命令执行的判断依据: <kbd>;</kbd>  <kbd>&&</kbd> <kbd>||</kbd>

#### ; 

> 无脑连续执行（无视报错）
> 分号前的指令执行完后就会立刻接着执 行后面的指令

```cmd
cmd; cmd;
```

#### $? （指令回传值） 与 && 或 ||

> 若前一个指令执行的结果为正确，在 Linux 下面会 回传一个 $? = 0 的值

- **cmd1 && cmd2**
   1. 若 cmd1 执行完毕且正确执行($?=0)，则开始执行 cmd2。
   2. 若 cmd1 执行完毕且为错误 ($?≠0)，则 cmd2 不执行。
- **cmd1 || cmd2**
  1. 若 cmd1 执行完毕且正确执行($?=0)，则 cmd2 不执行。 
  2. 若 cmd1 执 cmd2 行完毕且为错误 ($?≠0)，则开始执行 cmd2。

## 10.6 管线命令 (pipe)

> 管线命令“ | ”仅能处理经由前面一个指令传来的正确信息，也就是 standard output 的 信息，对于 stdandard error 并没有直接处理的能力。
> 
> 在每个管线后面接的第一个数据必定是“指令”喔!而且这个指令必须要能够接受 standard input 的数据才行，这样的指令才可以是为“管线命令”，例如 less, more, head, tail 等都是可以 接受 standard input 的管线命令啦。

- 管线命令仅会处理 standard output，对于 standard error output 会予以忽略 
- 管线命令必须要能够接受来自前一个指令的数据成为 standard input 继续处理才行。

### 10.6.1 撷取命令: cut, grep

#### cut 

- 分割字符串
- 在处理多空格相连的数据时，比较吃力，可以使用 awk

#### grep

```cmd
# 将 last 当中，有出现 root 的那一行就取出来;
last | grep 'root'

# 只要没有 root 的就取出!
last | grep -v 'root'
```

### 10.6.2 排序命令: sort, wc, uniq

#### uniq

去重

```cmd
# 使用 last 将帐号列出，仅取出帐号栏，进行排序后仅取出一位;
last | cut -d ' ' -f1 | sort | uniq

# 如果我还想要知道每个人的登陆总次数呢?
last | cut -d ' ' -f1 | sort | uniq -c
```

#### wc

统计文件中有多少字、行、字符数

### 10.6.3 双向重导向: tee

### 10.6.4 字符转换命令: tr, col, join, paste, expand

#### tr

字符串替换、删除

### 10.6.5 分区命令: split

将一个文件按行数、大小（b、k、m)拆分成多个小文件

### 10.6.6 参数代换: xargs

会使用 xargs 的原因是， 很多指令其实并不支持管线命令，因此我们可以通过 xargs 来提供该指令引用 standard input 之用

### 10.6.7 关于减号 - 的用途