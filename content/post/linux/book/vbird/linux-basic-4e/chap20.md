---
title: "第二十章、基础系统设置与备份策略"
date: 2021-04-20T10:20:00+08:20
draft: false
tags: ["Linux","计算机概论","鸟哥的Linux私房菜-基础篇"]
categories: ["Linux","鸟哥的Linux私房菜-基础篇"]
---

> 原书：《鸟哥的Linux私房菜-基础篇》第四版 | 作者：[鳥哥](http://linux.vbird.org/)

## 20.1 系统基本设置

- [网络基础-鸟哥](http://linux.vbird.org/linux_server/0110network_basic.php)

### 手动设置固定 IP

### 自动取得 IP 参数

### 修改主机名称

```cmd
# 显示目前的主机名称与相关信息
hostnamectl

# hostnamectl [set-hostname 你的主机名]
# 尝试修改主机名称为 www.centos.vbird
hostnamectl set-hostname www.centos.vbird
cat /etc/hostname
```

## 20.1.2 日期与时间设置

### 时区的显示与设置

```cmd
timedatectl [commamd]
```

选项与参数:
 - list-timezones :列出系统上所有支持的时区名称
 - set-timezone :设置时区位置
 - set-time :设置时间
 - set-ntp :设置网络校时系统
 

```cmd
# 1. 显示目前的时区与时间等信息
timedatectl
Local time: Tue 2015-09-01 19:50:09 CST # 本地时间
 Universal time: Tue 2015-09-01 11:50:09 UTC # UTC 时间，可称为格林威治标准时间
  RTC time: Tue 2015-09-01 11:50:12
Timezone: Asia/Taipei (CST, +0800) # 就是时区啰!
  NTP enabled: no
 NTP synchronized: no
 RTC in local TZ: no
 DST active: n/a

# 2. 查看是否有 Shanghai 的时区
timedatectl list-timezones |grep Shanghai

# 3. 设置时区
timedatectl set-timezone "Asia/Shanghai"
```

### 时间的调整

```cmd
timedatectl set-time "2015-09-01 12:02"
```

### 用 ntpdate 手动网络校时

```cmd
ntpdate tock.stdtime.gov.tw

hwclock -w
```

## 20.1.3 语系设置

查看

```cmd
localectl
```

## 20.1.4 防火墙简易设置

## 20.2 服务器硬件数据的收集

## 20.2.1 以系统内置 dmidecode 解析硬件配备

秀出整个系统的硬件信息，例如主板型号等等
 
```cmd
dmidecode -t 1
```

内存相关的数据呢?
 
```cmd
dmidecode -t 17
```

## 20.2.2 硬件资源的收集与分析

- gdisk:第七章曾经谈过，可以使用 gdisk -l 将分区表列出; 
- dmesg:第十六章谈过， 观察核心运行过程当中所显示的各项讯息记录; 
- vmstat:第十六章谈过，可分析系统 (CPU/RAM/IO) 目前的状态; 
- lspci:列出整个 PC 系统的 PCI 接口设备!很有用的指令; 
- lsusb:列出目前系统上面各个 USB 端口的状态，与连接的 USB 设备; 
- iostat:与 vmstat 类似，可实时列出整个 CPU 与周边设备的 Input/Output 状态。

### iostat

磁盘由开机到现在，已经存取多少数据

```cmd
选项与参数:
 -c :仅显示 CPU 的状态;
 -d :仅显示储存设备的状态，不可与 -c 一起用;
 -k :默认显示的是 block ，这里可以改成 K Bytes 的大小来显示;
 -m :与 -k 类似，只是以 MB 的单位来显示结果。
 -t :显示日期出来;
```
 
```cmd
# 显示一下目前整个系统的 CPU 与储存设备的状态
iostat

# 上面数据总共分为上下两部分，上半部显示的是 CPU 的当下信息;
# 下面数据则是显示储存设备包括 /dev/vda 的相关数据，他的数据意义:
# tps :平均每秒钟的传送次数!与数据传输“次数”有关，非容量!
# kB_read/s :开机到现在平均的读取单位;
# kB_wrtn/s :开机到现在平均的写入单位;
# kB_read :开机到现在，总共读出来的文件单位;
# kB_wrtn :开机到现在，总共写入的文件单位;

# 仅针对 vda ，每两秒钟侦测一次，并且共侦测三次储存设备
iostat -d 2 3 vda

# 仔细看一下，如果是有侦测次数的情况，那么第一次显示的是“从开机到现在的数据”，
# 第二次以后所显示的数据则代表两次侦测之间的系统传输值!举例来说，上面的信息中，
# 第二次显示的数据，则是两秒钟内(本案例)系统的总传输量与平均值
```

## 20.2.3 了解磁盘的健康状态

smartd 服务：怎么知道你的磁盘是好是坏啊?

SMART 其实是“ Self-Monitoring, Analysis and Reporting Technology System ”的缩写，主要 用来监测目前常见的 ATA 与 SCSI 界面的磁盘， 只是，要被监测的磁盘也必须要支持 SMART 的协定才行!否则 smartd 就无法去下达指令

> ⚠️ 特别强调的是，因为进行磁盘自我检查时，可能磁盘的 I/O 状态会比较频繁，因此不建 议在系统忙碌的时候进行喔! 否则系统的性能是可能会被影响的哩!要注意!要注意!

## 20.3 备份要点

## 20.3.1 备份数据的考虑

造成系统损毁的问题

- 硬件问题
- 软件与人的问题
- 主机角色不同，备份任务也不同

## 20.3.2 哪些 Linux 数据具有备份的意义

### 有必要备份的文件

- 一类是系统基本设置信息
- 一类则是类似网络服务的内容数据

#### 操作系统本身需要备份的文件

主要跟“帐号与系统配置文件”有关系

- /etc/passwd, /etc/shadow, /etc/group, /etc/gshadow, /home
- 由于 Linux 默认的重要参数文件都在 /etc/ 下面，所以只要将这个目录备份下来的话， 那么 几乎所有的配置文件都可以被保存的!
- /home 目录是一般用户的主文件夹，自然也需要来备份一番!
- 由于使用者会有邮 件吧!所以呢，这个 /var/spool/mail/ 内容也需要备份呦!
- 如果你曾经自行更动过 核心，那么 /boot 里头的信息也就很重要啰!

**必须要备份的文件为**

- /etc/ 整个目录 
- /home/ 整个目录 
- /var/spool/mail/ 
- /var/spoll/{at|cron}/ 
- /boot/
- /root/
- 如果你自行安装过其他的软件，那么 /usr/local/ 或 /opt 也最好备份一下!

#### 网络服务的数据库方面

- /var/spool/mail/, /var/spool/cron/, /var/spool/at/
- /var/lib/

### 不需要备份的目录

- /dev :这个随便你要不要备份
- /proc, /sys, /run:这个真的不需要备份啦!
- /mnt, /media:如果你没有在这个目录内放置你自己系统的东西，也不需要备份 
- /tmp :干嘛存暂存盘!不需要备份!

## 20.3.3 备份用储存媒体的选择

- 异地备援系统
- 储存媒体的考虑
  - NAS 储存设备

## 20.4 备份的种类、频率与工具的选择

## 20.4.1 完整备份之累积备份 (Incremental backup)

### 累积备份的原则

> 累积备份，指的是在系统在进行完第一次完整备份后，经过一段时间的运行， 比较系 统与备份文件之间的差异，仅备份有差异的文件而已。而第二次累积备份则与第一次累积备 份的数据比较， 也是仅备份有差异的数据而已。如此一来，由于仅备份有差异的数据，因此 备份的数据量小且快速!备份也很有效率。 

### 累积备份使用的备份软件

完整备份常用的工具有 dd, cpio, xfsdump/xfsrestore 等等

- dd 可以直接读取磁盘的扇区 (sector) 而不理会文件系统，是相当良好的备份 工具!不过缺点就是慢很多!
- cpio 是能够备份所有文件名，不过，得要配合 find 或其他找文 件名的指令才能够处理妥当。
- 可以直接进行累积备份的就是 xfsdump 这个指令，详细的指令与参数用法，请前往**第八章**查阅

命令举例详见原文

## 20.4.2 完整备份之差异备份 (Differential backup)

> 差异备份与累积备份有点类似，也是需要进行第一次的完整备份后才能够进行。只是差异备 份指的是:每次的备份都是与原始的完整备份比较的结果。所以系统运行的越久，离完整备 份时间越长， 那么该次的差异备份数据可能就会越大!

## 20.4.3 关键数据备份

备份关键数据鸟哥最爱使用 tar 来处理了!如果想要分门别类的将各种不同的服务在不同的时 间备份使用不同文件名， 配合 date 指令是非常好用的工具!例如下面的案例是依据日期来备 份 mariadb 的数据库喔!

```cmd
tar -jpcvf mysql.`date +%Y-%m-%d`.tar.bz2 /var/lib/mysql
```

备份是非常重要的工作，你可不希望想到才进行吧?交给系统自动处理就对啦!请自己撰写 script ， 配合 crontab 去执行吧!这样子，备份会很轻松喔!

## 20.5 鸟哥的备份策略

## 20.5.1 每周系统备份的 script

[backupwk-0.1.sh 脚本下载](http://linux.vbird.org/linux_basic/0580backup/backupwk-0.1.sh)

```shell
#!/bin/bash
# ====================================================================
# 使用者參數輸入位置：
# basedir=你用來儲存此腳本所預計備份的資料之目錄(請獨立檔案系統)
basedir=/backup/weekly

# ====================================================================
# 底下請不要修改了！用預設值即可！
PATH=/bin:/usr/bin:/sbin:/usr/sbin; export PATH
export LANG=C

# 設定要備份的服務的設定檔，以及備份的目錄
named=$basedir/named
postfixd=$basedir/postfix
vsftpd=$basedir/vsftp
sshd=$basedir/ssh
sambad=$basedir/samba
wwwd=$basedir/www
others=$basedir/others
userinfod=$basedir/userinfo
# 判斷目錄是否存在，若不存在則予以建立。
for dirs in $named $postfixd $vsftpd $sshd $sambad $wwwd $others $userinfod
do
	[ ! -d "$dirs" ] && mkdir -p $dirs
done

# 1. 將系統主要的服務之設定檔分別備份下來，同時也備份 /etc 全部。
cp -a /var/named/chroot/{etc,var}	$named
cp -a /etc/postfix /etc/dovecot.conf	$postfixd
cp -a /etc/vsftpd/*			$vsftpd
cp -a /etc/ssh/*			$sshd
cp -a /etc/samba/*			$sambad
cp -a /etc/{my.cnf,php.ini,httpd}	$wwwd
cd /var/lib
  tar -jpc -f $wwwd/mysql.tar.bz2 	mysql
cd /var/www
  tar -jpc -f $wwwd/html.tar.bz2 	html cgi-bin
cd /
  tar -jpc -f $others/etc.tar.bz2	etc
cd /usr/
  tar -jpc -f $others/local.tar.bz2	local

# 2. 關於使用者參數方面
cp -a /etc/{passwd,shadow,group}	$userinfod
cd /var/spool
  tar -jpc -f $userinfod/mail.tar.bz2	mail
cd /
  tar -jpc -f $userinfod/home.tar.bz2	home
cd /var/spool
  tar -jpc -f $userinfod/cron.tar.bz2	cron at
```

### 启用定时任务

```cmd
vi /etc/crontab

# 加入这两行即可 (请注意你的文件目录!不要照抄呦!)
30 3 * * 0 root /backup/backupwk.sh
30 2 * * * root /backup/backupday.sh
```

## 20.5.3 远端备援的 script

```cmd
vi /backup/rsync.sh

#!/bin/bash
remotedir=/home/backup/
basedir=/backup/weekly
host=127.0.0.1
id=dmtsai

# 下面为程序阶段!不需要修改喔!
rsync -av -e ssh $basedir ${id}@${host}:${remotedir}
```

## 20.6 灾难复原的考虑

