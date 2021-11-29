# 免责声明
>本文渗透的主机经过合法授权。本文使用的工具和方法仅限学习交流使用，请不要将文中使用的工具和渗透思路用于任何非法用途，对此产生的一切后果，本人不承担任何责任，也不对造成的任何误用或损害负责。

# 服务探测
```
┌──(root💀kali)-[~/htb]
└─# nmap -sV -Pn 10.10.11.116 -p-
Host discovery disabled (-Pn). All addresses will be marked 'up' and scan times will be slower.
Starting Nmap 7.91 ( https://nmap.org ) at 2021-11-29 03:48 EST
Nmap scan report for 10.10.11.116
Host is up (0.34s latency).
Not shown: 65522 closed ports
PORT     STATE    SERVICE        VERSION
22/tcp   open     ssh            OpenSSH 8.2p1 Ubuntu 4ubuntu0.3 (Ubuntu Linux; protocol 2.0)
80/tcp   open     http           Apache httpd 2.4.48 ((Debian))
4566/tcp open     http           nginx
5000/tcp filtered upnp
5001/tcp filtered commplex-link
5002/tcp filtered rfe
5003/tcp filtered filemaker
5004/tcp filtered avt-profile-1
5005/tcp filtered avt-profile-2
5006/tcp filtered wsm-server
5007/tcp filtered wsm-server-ssl
5008/tcp filtered synapsis-edge
8080/tcp open     http           nginx
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 1102.01 seconds

```

## 目录爆破
```
┌──(root💀kali)-[~/dirsearch]
└─# python3 dirsearch.py -e* -t 100 -u http://10.10.11.116                                                                        

  _|. _ _  _  _  _ _|_    v0.4.2
 (_||| _) (/_(_|| (_| )

Extensions: php, jsp, asp, aspx, do, action, cgi, pl, html, htm, js, json, tar.gz, bak | HTTP method: GET | Threads: 100 | Wordlist size: 15492

Output File: /root/dirsearch/reports/10.10.11.116/_21-11-29_04-17-51.txt

Error Log: /root/dirsearch/logs/errors-21-11-29_04-17-51.log

Target: http://10.10.11.116/

[04:17:52] Starting:    
[04:18:57] 200 -    0B  - /config.php                                       
[04:19:00] 301 -  310B  - /css  ->  http://10.10.11.116/css/                
[04:19:16] 200 -   16KB - /index.php                                        
[04:19:17] 200 -   16KB - /index.php/login/                                 
[04:19:18] 403 -  277B  - /js/                                              
```

只有几个文件，查网页源代码无特别发现

index页面需要输入一个名字，点击确定以后会跳到另一个页面，显示我们刚才输入的名字，也就是说很可能是经过数据库的

所以会不会有sql注入？