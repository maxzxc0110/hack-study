# 免责声明
>本文渗透的主机经过合法授权。本文使用的工具和方法仅限学习交流使用，请不要将文中使用的工具和渗透思路用于任何非法用途，对此产生的一切后果，本人不承担任何责任，也不对造成的任何误用或损害负责。

# 服务探测

```
┌──(root💀kali)-[~]
└─# nmap -sV -Pn 10.10.11.105                         
Host discovery disabled (-Pn). All addresses will be marked 'up' and scan times will be slower.
Starting Nmap 7.91 ( https://nmap.org ) at 2021-12-02 08:48 EST
Nmap scan report for 10.10.11.105
Host is up (0.34s latency).
Not shown: 998 closed ports
PORT   STATE SERVICE VERSION
22/tcp open  ssh     OpenSSH 7.6p1 Ubuntu 4ubuntu0.5 (Ubuntu Linux; protocol 2.0)
80/tcp open  http    nginx 1.14.0 (Ubuntu)
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

```

## 爆破目录
```
┌──(root💀kali)-[~/dirsearch]
└─# python3 dirsearch.py -e* -t 100 -u http://horizontall.htb/                                                                               

  _|. _ _  _  _  _ _|_    v0.4.2
 (_||| _) (/_(_|| (_| )

Extensions: php, jsp, asp, aspx, do, action, cgi, pl, html, htm, js, json, tar.gz, bak | HTTP method: GET | Threads: 100 | Wordlist size: 15492

Output File: /root/dirsearch/reports/horizontall.htb/-_21-12-02_09-01-00.txt

Error Log: /root/dirsearch/logs/errors-21-12-02_09-01-00.log

Target: http://horizontall.htb/

[09:01:01] Starting: 
[09:01:10] 301 -  194B  - /js  ->  http://horizontall.htb/js/              
[09:01:11] 400 -  182B  - /.%2e/%2e%2e/%2e%2e/%2e%2e/etc/passwd            
[09:01:56] 400 -  182B  - /cgi-bin/.%2e/%2e%2e/%2e%2e/%2e%2e/etc/passwd     
[09:02:01] 301 -  194B  - /css  ->  http://horizontall.htb/css/             
[09:02:06] 200 -    4KB - /favicon.ico                                      
[09:02:11] 301 -  194B  - /img  ->  http://horizontall.htb/img/             
[09:02:15] 403 -  580B  - /js/                                              
[09:02:17] 200 -  901B  - /index.html    
```

只有几个文件夹，没啥有用的发现

尝试爆破vhost，我们使用gobuster 

先把[这个字典](https://github.com/allyshka/vhostbrute)下载到本地

gobuster vhost -u horizontall.htb -w /root/htb/Horizontall/vhostbrute/vhosts.list -t 100