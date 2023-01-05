# 免责声明
>本文渗透的主机经过合法授权。本文使用的工具和方法仅限学习交流使用，请不要将文中使用的工具和渗透思路用于任何非法用途，对此产生的一切后果，本人不承担任何责任，也不对造成的任何误用或损害负责。

# 服务探测
```
┌──(root💀kali)-[~/tryhackme/Anthem]
└─# nmap -sV -Pn 10.10.59.87   
Host discovery disabled (-Pn). All addresses will be marked 'up' and scan times will be slower.
Starting Nmap 7.91 ( https://nmap.org ) at 2021-11-17 21:19 EST
Nmap scan report for 10.10.158.120
Host is up (0.31s latency).
Not shown: 998 filtered ports
PORT     STATE SERVICE       VERSION
80/tcp   open  http          Microsoft HTTPAPI httpd 2.0 (SSDP/UPnP)
3389/tcp open  ms-wbt-server Microsoft Terminal Services
Service Info: OS: Windows; CPE: cpe:/o:microsoft:windows

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 71.38 seconds

```

## 目录爆破
```
┌──(root💀kali)-[~/dirsearch]
└─# python3 dirsearch.py -e* -t 100 -u http://10.10.59.87                                                                                                                                                                          130 ⨯

  _|. _ _  _  _  _ _|_    v0.4.2
 (_||| _) (/_(_|| (_| )

Extensions: php, jsp, asp, aspx, do, action, cgi, pl, html, htm, js, json, tar.gz, bak | HTTP method: GET | Threads: 100 | Wordlist size: 15492

Output File: /root/dirsearch/reports/10.10.158.120/_21-11-17_21-35-14.txt

Error Log: /root/dirsearch/logs/errors-21-11-17_21-35-14.log

Target: http://10.10.158.120/

[21:35:18] Starting:           
[21:35:28] 200 -    5KB - /.aspx                                           
[21:35:38] 301 -  152B  - /.vscode  ->  http://10.10.158.120/.vscode/      
[21:35:48] 302 -  126B  - /Install  ->  /umbraco/                           
[21:35:48] 302 -  126B  - /INSTALL  ->  /umbraco/                           
[21:35:52] 403 -    2KB - /Trace.axd                                        
[21:35:52] 200 -    3KB - /Search                                                    
[21:37:39] 301 -  118B  - /archive  ->  /                                   
[21:37:39] 301 -  118B  - /archive.aspx  ->  /                              
[21:37:47] 200 -    4KB - /authors                                          
[21:37:56] 400 -   46B  - /base/                                             
[21:38:03] 200 -    5KB - /blog/                                             
[21:38:09] 200 -    5KB - /blog                                                 
[21:38:19] 200 -    3KB - /categories                                        
[21:39:19] 200 -    5KB - /default.aspx                                                                     
[21:40:12] 302 -  126B  - /install  ->  /umbraco/                             
[21:40:12] 302 -  126B  - /install/  ->  /umbraco/                            
[21:40:55] 200 -  192B  - /robots.txt                                         
[21:40:56] 200 -    2KB - /rss                                                
[21:40:58] 200 -    3KB - /search                                             
[21:41:18] 200 -    1KB - /sitemap                                            
[21:41:51] 200 -    3KB - /tags   
```