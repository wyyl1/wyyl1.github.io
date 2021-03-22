# 第五章、Linux 的文件权限与目录配置

- 文件可存取的身份
    - owner 文件拥有者
    - group 群组（每个账号可以有多个群组）
    - others 其他人

- 每种身份的权限
    - read
    - write
    - execute

## Linux 用户身份与群组记录的文件

- /etc/passwd 记录所有的账户信息
- /etc/shadow 记录个人的密码
- /etc/group 记录所有的组

## 5.2 Linux 文件权限概念

```cmd
$ ls -al
drwxr-xr-x 16 aoe  aoe     4096 Nov 23 11:41 .
drwxr-xr-x  3 root root    4096 Sep 12 17:34 ..
drwxrwxr-x  2 aoe  aoe     4096 Sep 17 13:37 apps
-rw-------  1 aoe  aoe    38063 Nov 23 12:23 .bash_history
-rw-r--r--  1 aoe  aoe      220 Feb 25  2020 .bash_logout
-rw-r--r--  1 aoe  aoe     3771 Sep 14 08:39 .bashrc
[  权限 ][连接][拥有者][群组][文件容量][修改日期][文件名]
```

-rwxr-xr-x


| - | r | w | x | r | - | x | r | - | x |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 文件类型 | 可读 | 可写 | 可执行 |  | 无权限 |  |  |  |  |
|  | 文件拥有者 | 文件拥有者 | 文件拥有者 | 群组 | 群组 | 群组 | 其他人 | 其他人 |  其他人|

- rwx 位置不变
- 第一个字符代表这个文件属性
    - [d] directory 目录
    - [-] 文件
    - [l] link 连接档（link file）
    - [b] block 区块设备档，可存储接口设备；通常集中在 /dev 目录下
    - [c] character 字符设备文件，串行端口设备，例如鼠标、键盘；通常集中在 /dev 目录下
    - [s] sockets 资料接口文件，用于网络通信；通常在 /run 或 /tmp
    - [p] FIFO,pipe 主要解决多个程序同时存取一个文件造成的错误问题
- 文件容量默认单位 bytes

显示完整时间

```cmd
$ ls -l --full-time
```

### 5.2.2 如何改变文件属性与权限

- **chgrp** 改变文件所属群组
- **chown** 改变文件拥有者
- **chmod** 改变文件的权限，SUID，SGID，SBIT 等等

## chgrp （change group 的缩写）
变更范围 **/etc/group** 中的数据

```cmd
# -R 进行递归的持续变更，常用于变更某一目录内所有文件
$ chgrp -R dirname/filename

$ chgrp users test.cfg
```
 
## chown （change owner 的缩写）
变更范围 **/etc/passwd** 中的数据

```cmd
# -R 进行递归的持续变更，常用于变更某一目录内所有文件
$ chown -R 账号名称 文件或目录
$ chown -R 账号名称:组名 文件或目录
```

## chmod 改变文件的权限
- 数字类型
    - r : 4
    - w : 2
    - x : 1

```cmd
# -R 进行递归的持续变更，常用于变更某一目录内所有文件
$ chmod -R 属性累加值 文件或目录

$ chmod 777 .bas
```

- 符号类型
    - u user
    - g group
    - o other
    - a all


| chmod | u<br>g<br>o<br>a | + 加入<br>- 除去<br>= 设定 | r<br>w<br>x | 文件或目录 |
| --- | --- | --- | --- | --- |
 
```cmd
# -rwxr-xr-x 
# u=rwx,go=rx 中间没有空格
$ chmod u=rwx,go=rx .bashrc

# 给所有人加写入权限
$ chmod a+w .bashrc

# 拿回所有人的可执行权限
$ chmod a-x .bashrc
```

**通常要开放的目录至少具备 rx 权限**

## Linux 文件扩展名

- *.sh 脚本或批处理文件，使用 shell 写成
- *Z, *.tar, *.tar.gz, *.zip, *.tgz 压缩文件

## 5.3.1 Linux 目录配置的依据 FHS

- / : root 根目录，与开机系统有关
- /usr : unix software resource 与软件安装/执行有关
- /var : variable 与系统运作过程有关
- /etc : 系统主要的配置文件几乎都放这里；FHS 建议不要放可执行文件在这里
- /etc/opt : （必要）放置第三方协力软件 /opt 的相关配置文件
- /lib : 放置在开机时会用到的函数库，以及 /bin 、/sbin 底下的指令会调用的函数库
- /lib/modules : 主要放置可抽换式的核心相关模块（驱动程序）
- /media : 放置可移除的装置，包括软盘、光盘、DVD 等
- /mnt : 用来暂时挂载额外的装置
- /opt : 放置第三方协力软件
- /run : 放置系统开机后产生的各项信息；可以使用内存来仿真，性能高
- /sbin : 开机过程所需要的，开机、修复、还原系统所需要的指令
- /srv : service 的缩写，网络服务
- /tmp : 存放临时信息，建议定时清理，甚至可以在开机时删除 /tmp 下的所有数据
- /proc : 本身是一个虚拟的文件系统，放置的数据都在内存中
- /sys : 和 /proc 类似，也是一个虚拟的文件系统