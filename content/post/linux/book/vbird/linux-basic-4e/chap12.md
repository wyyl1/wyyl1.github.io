---
title: "第十二章、学习 Shell Scripts"
date: 2021-04-20T10:20:00+08:12
draft: false
tags: ["Linux","BASH","鸟哥的Linux私房菜-基础篇"]
categories: ["Linux","鸟哥的Linux私房菜-基础篇"]
---

> 原书：《鸟哥的Linux私房菜-基础篇》第四版 | 作者：[鳥哥](http://linux.vbird.org/)

## 12.1 什么是 Shell scripts

### 12.1.1 干嘛学习 shell scripts

> 虽然 shell script 号称是程序 (program) ，但实际上， shell script 处理数据的速度上 是不太够的。因为 shell script 用的是外部的指令与 bash shell 的一些默认工具，所以，他常 常会去调用外部的函数库，因此，运算速度上面当然比不上传统的程序语言。 所以啰， shell script 用在系统管理上面是很好的一项工具，但是用在处理大量数值运算上， 就不够好了， 因为 Shell scripts 的速度较慢，且使用的 CPU 资源较多，造成主机资源的分配不良。还好， 我们通常利用 shell script 来处理服务器的侦测，倒是没有进行大量运算的需求啊!所以不必 担心的啦!

### 12.1.2 第一支 script 的撰写与执行

#### 如何执行

- 直接指令下达: shell.sh 文件必须要具备可读与可执行 (rx) 的权限，然后:
  - 绝对路径:使用 /home/dmtsai/shell.sh 来下达指令;
  - 相对路径:假设工作目录在 /home/dmtsai/ ，则使用 ./shell.sh 来执行
  - 变量“PATH”功能:将 shell.sh 放在 PATH 指定的目录内，例如: ~/bin/
- 以 bash 程序来执行:通过“ bash shell.sh ”或“ sh shell.sh ”来执行

hello.sh

```sh
#!/bin/bash
# Program:
#       This program shows "Hello World!" in your screen.
# History:
# 2015/07/16    VBird    First release
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
echo -e "Hello World! \a \n"
exit 0
```

- 主要环境变量的宣告:建议务必要将一些重要的环境变量设置好，鸟哥个人认为， PATH 与 LANG (如果有使用到输出相关的信息时) 是当中最重要的! 如此一来，则可 让我们这支程序在进行时，可以直接下达一些外部指令，而不必写绝对路径呢!比较方便
- 执行成果告知(定义回传值)是否记得我们在第十章里面要讨论一个指令的执行成功与 否，可以使用 **\$?** 这个变量来观察~ 那么我们也可以利用 exit 这个指令来让程序中断， 并且回传一个数值给系统。 在我们这个例子当中，鸟哥使用 exit 0 ，这代表离开 script 并且回传一个 0 给系统， 所以我执行完这个 script 后，若接着下达 echo $? 则可得到 0 的值喔! 更聪明的读者应该也知道了，呵呵!利用这个 exit n (n 是数字) 的功能，我 们还可以自订错误讯息， 让这支程序变得更加的 smart 呢!

### 12.1.3 撰写 shell script 的良好习惯创建

在每个 script 的文件开始处记录好:
- script 的功能;
- script 内较特殊的指令，使用“绝对路径”的方式来下达;
- script 运行时需要的环境变量预先宣告与设置。

## 12.2 简单的 shell script 练习

对谈式脚本:变量内容由使用者决定

showname.sh

```sh
#!/bin/bash
# Program:
#    User inputs his first name and last name.  Program shows his full name.
# History:
# 2015/07/16    VBird    First release
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

read -p "Please input your first name: " firstname # 提示使用者输入
read -p "Please input your last name: " lastname # 提示使用者输入
echo -e "\nYour full name is: ${firstname} ${lastname}" # 结果由屏幕输出
```

### 12.2.2 script 的执行方式差异 (source, sh script, ./script)

#### 利用直接执行的方式来执行 script

```cmd
echo ${firstname} ${lastname}

sh showname.sh

# 没有数据
echo ${firstname} ${lastname}
```

#### 利用 source 来执行脚本:在父程序中执行

```cmd
source showname.sh

# 有数据
echo ${firstname} ${lastname}
```

## 12.3 善用判断式

详见文中表格

```cmd
test
```

- 判断文件、目录是否存在
- 判断文件权限
- 两个文件之间的比较
- 关于两个整数之间的判定
- 判定字符串的数据
- 多重条件判定

### 12.3.2 利用判断符号 [ ]

除了我们很喜欢使用的 test 之外，其实，我们还可以利用判断符号“ [ ] ”(就是中括号啦) 来 进行数据的判断呢! 举例来说，如果我想要知道 ${HOME} 这个变量是否为空的，可以这样 做:

```cmd
[ -z "${HOME}" ] ; echo $?
```

> 必须要注意中括号的两端 需要有空白字符来分隔

### 12.3.3 Shell script 的默认变量($0, $1...)

script 针对参数设定的变量名

path/to/script-name opt1 opt2 opt3 opt4

/path/to/script-name | opt1 | opt2 | opt3 | opt4 |
--- |--- |--- |--- |--- |
$0 | $1 | $2 | $3| $4 |

#### script 内较为特殊的变量

- \$# : 代表后接的参数“个数”，以上表为例这里显示为“ 4 ”;
- \$@ : 代表“ "\$1" "\$2" "\$3" "\$4" ”之意，每个变量是独立的(用双引号括起来);
- \$* : 代表  \$1<u>c</u>\$2<u>c</u>\$3<u>c</u>\$4 ，其中 <u>c</u> 为分隔字符，默 认为空白键， 所以本例中代表“ "\$1 \$2 \$3 \$4" ”之意。

## 12.4 条件判断式

### 12.4.1 利用 if .... then

> if [ 条件判断式 ]; then 
> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;当条件判断式成立时，可以进行的指令工作内容;
fi &nbsp;&nbsp;<==将 if 反过来写，就成为 fi 啦!结束 if 之意!

> if [ 条件判断式 ]; then
> &nbsp;&nbsp;&nbsp;&nbsp;xxx
> else
> &nbsp;&nbsp;&nbsp;&nbsp;xxx
> fi

> if [ 条件判断式 ]; then
> &nbsp;&nbsp;&nbsp;&nbsp;xxx
> elif [ 条件判断式 ]; then
> &nbsp;&nbsp;&nbsp;&nbsp;xxx
> else
> &nbsp;&nbsp;&nbsp;&nbsp;xxx
> fi

### 12.4.2 利用 case ..... esac 判断

```sh
case $变量名称 in    <==关键字为 case ，还有变量前有钱字号
    "第一个变量内容") <==每个变量内容建议用双引号括起来，关键字则为小括号 )
          程序段
          ;;        <==每个类别结尾使用两个连续的分号来处理!
     "第二个变量内容")
          程序段
          ;;
*)                  <==最后一个变量内容都会用 * 来代表所有其他值
          不包含第一个变量内容与第二个变量内容的其他程序执行段
          exit 1
          ;;
esac                <==最终的 case 结尾!“反过来写”思考一下!
```

### 12.4.3 利用 function 功能

```sh
function fname() {
    程序代码
}
```

>  function 也是拥有内置变量的~他的内置变量与 shell script 很类似， 函数名称代表示 \$0 ，而后续接的变量也是以 \$1, \$2... 来取代的

## 12.5 循环 (loop)

### 12.5.1 while do done, until do done (不定循环)

条件成立时进行循环

```sh
while [ condition ]
do 
    程序段落
done
```

与 while 相反，当 condition 条件成立时，终止循环

```sh
until [ condition ]
do 
    程序段落
done
```

### 12.5.2 for...do...done (固定循环)

```sh
for var in con1 con2 con3 ...
do
    程序段
done
```

$var 的变量内容在循环工作时

- 第一次循环时，$var的内容为con1;
- 第二次循环时，$var的内容为con2;
- ...

### 12.5.3 for...do...done 的数值处理

```sh
for (( 初始值; 限制值; 执行步阶 )) 
do
     程序段
done
```

### 12.5.4 搭配乱数与阵列的实验

## 12.6 shell script 的追踪与 debug

```cmd
sh [-nvx] scripts.sh

选项与参数:
 -n :不要执行 script，仅查询语法的问题;
 -v :再执行 sccript 前，先将 scripts 的内容输出到屏幕上;
 -x :将使用到的 script 内容显示到屏幕上，这是很有用的参数!
```