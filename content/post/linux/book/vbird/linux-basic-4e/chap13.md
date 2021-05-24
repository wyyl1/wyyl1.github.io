---
title: "第十三章、Linux 帐号管理与 ACL 权限设置"
date: 2021-04-20T10:20:00+08:13
draft: false
tags: ["Linux","帐号管理与 ACL 权限设置","鸟哥的Linux私房菜-基础篇"]
categories: ["Linux","鸟哥的Linux私房菜-基础篇"]
---

> 原书：《鸟哥的Linux私房菜-基础篇》第四版 | 作者：[鳥哥](http://linux.vbird.org/)

## 13.1 Linux 的帐号与群组

### 13.1.1 使用者识别码: UID 与 GID

- /etc/passwd ID 与帐号的对应就在
- /etc/group 群组关系å

**每一个文件都具有的属性**

- 一个是使用者 ID (User ID ，简称 **UID**)
- 一个是群组 ID (Group ID ，简称 **GID**)

查看系统中有没有一个名为 aoe 的用户

```cmd
$ id aoe
```

### 13.1.2 使用者帐号

1. 登入 Linux 主机
2. /etc/passwd 是否有输入的账号
3. 将账号对应的 UID 与 GID （/etc/group) 中读出来
4. /etc/shadow 核对密码：找出对应的账号与 UID

#### /etc/passwd 文件结构

每一行都代表一个帐号，有几行就代表有几个帐号在你的系统 中! 不过需要特别留意的是，里头很多帐号本来就是系统正常运行所必须要的，我们可以简 称他为系统帐号， 例如 bin, daemon, adm, nobody 等等，这些帐号请不要随意的杀掉他呢!

第三个字段是 **UID**
第四个字段是 **GID**

```cmd
$ cat /etc/passwd | grep aoe
aoe:x:1000:1000:i3:/home/aoe:/bin/bash
```

UID 详细说明见文章图表

#### /etc/shadow文件结构

存放密码

### 13.1.3 关于群组: 有效与初始群组、groups, newgrp

#### /etc/group 文件结构


- 1. 群组名称:
  - 就是群组名称啦!同样用来给人类使用的，基本上需要与第三字段的GID对
应。
- 2. 群组密码:
  - 通常不需要设置，这个设置通常是给“群组管理员”使用的，目前很少有这个 机会设置群组管理员啦! 同样的，密码已经移动到 /etc/gshadow 去，因此这个字段只会 存在一个“x”而已;
- 3. GID:
  - 就是群组的ID啊。我们/etc/passwd第四个字段使用的GID对应的群组名，就是 由这里对应出来的!
- 4. 此群组支持的帐号名称:
  - 我们知道一个帐号可以加入多个群组，那某个帐号想要加入此 群组时，将该帐号填入这个字段即可。 举例来说，如果我想要让 dmtsai 与 alex 也加入 root 这个群组，那么在第一行的最后面加上“dmtsai,alex”，注意不要有空格， 使成为 ``` root:x:0:dmtsai,alex ```就可以啰~

#### 有效群组(effective group)与初始群组(initial group)

查看自己拥有的群组

```cmd
groups
```

newgrp: 有效群组的切换

```cmd
newgrp users
```

## 13.2 帐号管理