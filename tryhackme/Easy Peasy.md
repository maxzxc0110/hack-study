# 免责声明
>本文渗透的主机经过合法授权。本文使用的工具和方法仅限学习交流使用，请不要将文中使用的工具和渗透思路用于任何非法用途，对此产生的一切后果，本人不承担任何责任，也不对造成的任何误用或损害负责。

# 服务探测
```
┌──(root💀kali)-[~/tryhackme/EasyPeasy]
└─# nmap -sV -Pn 10.10.67.41 -p-
Host discovery disabled (-Pn). All addresses will be marked 'up' and scan times will be slower.
Starting Nmap 7.91 ( https://nmap.org ) at 2021-11-12 03:25 EST
Nmap scan report for 10.10.67.41
Host is up (0.30s latency).
Not shown: 65532 closed ports
PORT      STATE SERVICE VERSION
80/tcp    open  http    nginx 1.16.1
6498/tcp  open  ssh     OpenSSH 7.6p1 Ubuntu 4ubuntu0.3 (Ubuntu Linux; protocol 2.0)
65524/tcp open  http    Apache httpd 2.4.43 ((Ubuntu))
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 829.53 seconds


```

80端口，打开是一个nginx的欢迎页面，源代码找到flag3
```
They are activated by symlinking availableconfiguration files from their respectiveFl4g 3 : flag{9fdafbd64c47471a8f54cd3fc64cd312}*-available/ counterparts. These should be managedby using our helpers
```

65524也一个http端口，打开是一个apache的欢迎页，源代码无特别东西。

## 爆破80目录

```
┌──(root💀kali)-[~/dirsearch]
└─# python3 dirsearch.py -e* -t 100 -u http://10.10.67.41 -w /usr/share/wordlists/Web-Content/directory-list-2.3-medium.txt

  _|. _ _  _  _  _ _|_    v0.4.2
 (_||| _) (/_(_|| (_| )

Extensions: php, jsp, asp, aspx, do, action, cgi, pl, html, htm, js, json, tar.gz, bak | HTTP method: GET | Threads: 100 | Wordlist size: 220545

Output File: /root/dirsearch/reports/10.10.67.41/_21-11-12_03-36-16.txt

Error Log: /root/dirsearch/logs/errors-21-11-12_03-36-16.log

Target: http://10.10.67.41/

[03:36:17] Starting: 
[03:37:38] 301 -  169B  - /hidden  ->  http://10.10.67.41/hidden/    
```

/hidden文件夹下有一张图片，下载到本地以后不能分离出文件，可能需要密码


## 爆破65524目录

```
┌──(root💀kali)-[~/dirsearch]
└─# python3 dirsearch.py -e* -t 100 -u http://10.10.67.41:65524/                                                                  

  _|. _ _  _  _  _ _|_    v0.4.2
 (_||| _) (/_(_|| (_| )

Extensions: php, jsp, asp, aspx, do, action, cgi, pl, html, htm, js, json, tar.gz, bak | HTTP method: GET | Threads: 100 | Wordlist size: 15492

Output File: /root/dirsearch/reports/10.10.67.41-65524/-_21-11-12_03-51-03.txt

Error Log: /root/dirsearch/logs/errors-21-11-12_03-51-03.log

Target: http://10.10.67.41:65524/

[03:51:04] Starting:    
[03:52:34] 200 -   11KB - /index.html                                       
[03:53:12] 200 -  153B  - /robots.txt                                       
```

robots.txt显示：
```
User-Agent:*
Disallow:/
Robots Not Allowed
User-Agent:a18672860d0510e5ab6699730763b250
Allow:/
This Flag Can Enter But Only This Flag No More Exceptions
```


md5解出来是：```flag{1m_s3c0nd_fl4g}```,为flag2

下载easypeasy.txt文件到本地，grep以后得到flag3
```
┌──(root💀kali)-[~/tryhackme/EasyPeasy]
└─# cat easypeasy.txt|grep flag                                                                                                                                                                                                         1 ⨯
flag{9fdafbd64c47471a8f54cd3fc64cd312}
flagsrule
flags2
flags101
flagirl
flagflag
flagator
flag93
flag890
flag2006
flag11

```


#bruteStegHide.sh 
#!/bin/bash

for line in `cat $2`;do
    steghide extract -sf $1 -p $line > /dev/null 2>&1
    if [[ $? -eq 0 ]];then
        echo 'password is: '$line
        exit
    fi  
done
