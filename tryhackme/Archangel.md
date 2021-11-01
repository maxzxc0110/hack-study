# 免责声明
>本文渗透的主机经过合法授权。本文使用的工具和方法仅限学习交流使用，请不要将文中使用的工具和渗透思路用于任何非法用途，对此产生的一切后果，本人不承担任何责任，也不对造成的任何误用或损害负责。

# 发现服务
```
┌──(root💀kali)-[~/tryhackme/Archangel]
└─# nmap -sV -Pn 10.10.234.47     
Host discovery disabled (-Pn). All addresses will be marked 'up' and scan times will be slower.
Starting Nmap 7.91 ( https://nmap.org ) at 2021-10-29 05:43 EDT
Nmap scan report for 10.10.234.47
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
└─# python3 dirsearch.py -e* -t 100 -u http://10.10.234.47                                                                        

  _|. _ _  _  _  _ _|_    v0.4.2                                                                                                                                                                                                            
 (_||| _) (/_(_|| (_| )                                                                                                                                                                                                                     
                                                                                                                                                                                                                                            
Extensions: php, jsp, asp, aspx, do, action, cgi, pl, html, htm, js, json, tar.gz, bak | HTTP method: GET | Threads: 100 | Wordlist size: 15492

Output File: /root/dirsearch/reports/10.10.234.47/_21-10-29_06-02-36.txt

Error Log: /root/dirsearch/logs/errors-21-10-29_06-02-36.log

Target: http://10.10.234.47/

[06:02:37] Starting:                                         
[06:03:59] 301 -  312B  - /flags  ->  http://10.10.234.47/flags/            
[06:04:06] 301 -  313B  - /images  ->  http://10.10.234.47/images/          
[06:04:06] 200 -    0B  - /images/                                          
[06:04:08] 200 -   19KB - /index.html                                       
[06:04:29] 301 -  312B  - /pages  ->  http://10.10.234.47/pages/            
[06:04:30] 200 -    0B  - /pages/                                           
[06:04:44] 403 -  277B  - /server-status    
```

/flags 转向youtube一个视频，没有其他信息，应该是个兔子洞
其他文件夹没有其他信息