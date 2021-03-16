# 第六章 Linux 文件与目录管理

## 6.1.2 目录的相关操作


| 操作符 | 功能 |
| --- | --- |
| . | 当前目录 |
| .. | 上一层目录 |
| - | 前一个工作目录 |
| ~ | 当前用户的家目录 |
| ~account | account 用户的的家目录 |

## pwd -P
- -P 显示出真实的路径，而非使用连接（link）路径

## mkdir -mp 新建目录
- -m 配置文件的权限
- -p 递归建立所需所有目录

```cmd
$ mkdir -p test1/test2/test3
```

建立权限为 rwx--x--x 的目录

```cmd
$ mkdir -m 711 test
```

## 6.1.3 关于执行文件路径的变量：$PATH

查看 PATH

```cmd
$ echo $PATH
```
## 6.2.1 文件与目录的检视：ls
- -l 包含文件属性与权限等
- -h 将文件的容量以人类较易读的方式列出来
- -R 连同子目录内容一起列出来
- -S 以文件容量大小排序
- -t 依时间排序
- --full-time 以完整时间模式

## 6.2.2 复制、删除与移动 cp rm mv

## 6.2.3 取得路径的文件名与目录名称

```cmd
$ basename /home/aoe/k8s/test/
test

$ dirname /home/aoe/k8s/test/
/home/aoe/k8s
```

## 6.3 文件内容查阅

- cat Concatenate 由第一行开始显示文件内容
- tac 从最后一行开始显示文件内容
- nl 显示的时候，顺道输出行号
- more 一页一页的显示文件内容
- less 与 more 类似，优点是可以向前翻页
- head 只看头几行
- tail 只看尾巴几行
- od 以二进制的方式读取文件内容

## more 
- 空格键： 向下翻一页
- Enter： 向下翻一行
- /字符串：在显示的文档中，向下搜索【字符串】这个关键词 
- :f ：立刻显示出文件名以及目前显示的行数
- q：立刻离开
- b 或 ctrl + b：往回翻页，只对文件有用，对管线无用

## 6.4.1 文件预设权限 umask
umask 指定**目前用户在建立文件或目录时候的权限默认值**

```cmd
# 数字是拿掉的权限
$ umask
0002

# -S (Symbolic)
$ umask -S
u=rwx,g=rwx,o=rx
```

## 6.4.2 文件隐藏属性
- chattr
    - 只能在 Ext2/Ext3/Ext4 的 Linux 传统文件系统上面完整生效
    - 其他的系统文件不保证完整支持，例如 xfs 仅支持部分参数
 
 ```cmd
 # 执行后 root 用户也删除不了这个文件
 $ chattr + i 文件名
 
 # 取消 i 属性
 $ chattr -i 文件名
 ```

## 6.4.4 观察文件类型 file

```cmd
$ file ~/.bashrc
```

## 6.5.1 脚本文件名的搜寻

- which 寻找 【执行裆】

```cmd
# which -a command
# -a 将所有由 PATH 目录中可以找到的指令均列出，而不止第一个被找到的指令名称
$ which ifconfig
```

## 6.5.2 文件档名的搜寻
- find
    - 不常用
    - 速度慢
    - 扫描硬盘
- whereis
    - 只找系统中某些特定目录下的文件（-l 列出查询的几个主要目录）
- locate
    - 利用数据库搜索文件
    - 在 /var/lib/mlocate/ 里面的数据中搜索
    - 数据库默认每天更新一次，实时性较差
    - updatedb 命令可以更新数据库