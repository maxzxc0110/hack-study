# 免责声明
>本文渗透的主机经过合法授权。本文使用的工具和方法仅限学习交流使用，请不要将文中使用的工具和渗透思路用于任何非法用途，对此产生的一切后果，本人不承担任何责任，也不对造成的任何误用或损害负责。


# 服务发现
```
┌──(root💀kali)-[~/tryhackme/Lian_Yu]
└─# nmap -sV -Pn 10.10.148.144 -p-
Host discovery disabled (-Pn). All addresses will be marked 'up' and scan times will be slower.
Starting Nmap 7.91 ( https://nmap.org ) at 2021-11-04 05:22 EDT
Nmap scan report for 10.10.148.144
Host is up (0.30s latency).
Not shown: 65530 closed ports
PORT      STATE SERVICE VERSION
21/tcp    open  ftp     vsftpd 3.0.2
22/tcp    open  ssh     OpenSSH 6.7p1 Debian 5+deb8u8 (protocol 2.0)
80/tcp    open  http    Apache httpd
111/tcp   open  rpcbind 2-4 (RPC #100000)
59642/tcp open  status  1 (RPC #100024)
Service Info: OSs: Unix, Linux; CPE: cpe:/o:linux:linux_kernel

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 3585.05 seconds

```

# ftp尝试登录
尝试用anonymous和Lian_Yu登录ftp，显示Permission denied
```
┌──(root💀kali)-[~]
└─# ftp 10.10.148.144
Connected to 10.10.148.144.
220 (vsFTPd 3.0.2)
Name (10.10.148.144:root): anonymous
530 Permission denied.
Login failed.
ftp> bye
221 Goodbye.
                                                                                                                                                                                                                                            
┌──(root💀kali)-[~]
└─# ftp 10.10.148.144
Connected to 10.10.148.144.
220 (vsFTPd 3.0.2)
Name (10.10.148.144:root): Lian_Yu
530 Permission denied.
Login failed.
ftp> bye
221 Goodbye.

```
我们需要一个ftp的用户名


# 目录爆破
```
┌──(root💀kali)-[~/dirsearch]
└─# python3 dirsearch.py -e* -t 100 -w /usr/share/wordlists/Web-Content/directory-list-2.3-medium.txt -u http://10.10.148.144 

  _|. _ _  _  _  _ _|_    v0.4.2
 (_||| _) (/_(_|| (_| )

Extensions: php, jsp, asp, aspx, do, action, cgi, pl, html, htm, js, json, tar.gz, bak | HTTP method: GET | Threads: 100 | Wordlist size: 220545

Output File: /root/dirsearch/reports/10.10.148.144/_21-11-04_05-23-21.txt

Error Log: /root/dirsearch/logs/errors-21-11-04_05-23-21.log

Target: http://10.10.148.144/

[05:23:21] Starting: 
[05:24:57] 301 -  236B  - /island  ->  http://10.10.148.144/island/        
[05:33:51] 403 -  199B  - /server-status   
```

打开```/island```页面，显示一段话：
```
<h1> Ohhh Noo, Don't Talk............... </h1>

<p> I wasn't Expecting You at this Moment. I will meet you there </p><!-- go!go!go! -->

<p>You should find a way to <b> Lian_Yu</b> as we are planed. The Code Word is: </p><h2 style="color:white"> vigilante</style></h2>
```

vigilante是正确的ftp用户名，但是我们不知道密码
```
┌──(root💀kali)-[~]
└─# ftp 10.10.148.144
Connected to 10.10.148.144.
220 (vsFTPd 3.0.2)
Name (10.10.148.144:root): vigilante
331 Please specify the password.
Password:
530 Login incorrect.
Login failed.
ftp> bye
221 Goodbye.
```