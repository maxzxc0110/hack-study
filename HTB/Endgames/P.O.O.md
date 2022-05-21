
# 探测

```
┌──(root💀kali)-[~/htb/endgame/POO]
└─# nmap -sV -Pn -A -O 10.13.38.11                                                                                                                                                                                               1 ⨯
Host discovery disabled (-Pn). All addresses will be marked 'up' and scan times will be slower.
Starting Nmap 7.91 ( https://nmap.org ) at 2022-05-20 22:12 EDT
Nmap scan report for 10.13.38.11 (10.13.38.11)
Host is up (0.25s latency).
Not shown: 998 filtered ports
PORT     STATE SERVICE  VERSION
80/tcp   open  http     Microsoft IIS httpd 10.0
| http-methods: 
|_  Potentially risky methods: TRACE
|_http-server-header: Microsoft-IIS/10.0
|_http-title: IIS Windows Server
1433/tcp open  ms-sql-s Microsoft SQL Server 2017 14.00.2027.00; RTM+
| ms-sql-ntlm-info: 
|   Target_Name: POO
|   NetBIOS_Domain_Name: POO
|   NetBIOS_Computer_Name: COMPATIBILITY
|   DNS_Domain_Name: intranet.poo
|   DNS_Computer_Name: COMPATIBILITY.intranet.poo
|   DNS_Tree_Name: intranet.poo
|_  Product_Version: 10.0.17763
| ssl-cert: Subject: commonName=SSL_Self_Signed_Fallback
| Not valid before: 2022-05-17T11:13:53
|_Not valid after:  2052-05-17T11:13:53
|_ssl-date: 2022-05-21T02:13:18+00:00; +4s from scanner time.
Warning: OSScan results may be unreliable because we could not find at least 1 open and 1 closed port
OS fingerprint not ideal because: Missing a closed TCP port so results incomplete
No OS matches for host
Network Distance: 2 hops
Service Info: OS: Windows; CPE: cpe:/o:microsoft:windows

Host script results:
|_clock-skew: mean: 3s, deviation: 0s, median: 2s
| ms-sql-info: 
|   10.13.38.11:1433: 
|     Version: 
|       name: Microsoft SQL Server 2017 RTM+
|       number: 14.00.2027.00
|       Product: Microsoft SQL Server 2017
|       Service pack level: RTM
|       Post-SP patches applied: true
|_    TCP port: 1433

TRACEROUTE (using port 80/tcp)
HOP RTT       ADDRESS
1   249.96 ms 10.10.14.1 (10.10.14.1)
2   249.86 ms 10.13.38.11 (10.13.38.11)

OS and Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 37.47 seconds
```

只有两个端口

全盘扫描也只有两个

# 80

```
┌──(root㉿ss)-[~/htb/endgame/POO]
└─# python3 /root/dirsearch/dirsearch.py -e* -u http://10.13.38.11  

  _|. _ _  _  _  _ _|_    v0.4.2
 (_||| _) (/_(_|| (_| )

Extensions: php, jsp, asp, aspx, do, action, cgi, pl, html, htm, js, json, tar.gz, bak | HTTP method: GET | Threads: 30 | Wordlist size: 15492

Output File: /root/dirsearch/reports/10.13.38.11/_22-05-20_22-20-31.txt

Error Log: /root/dirsearch/logs/errors-22-05-20_22-20-31.log

Target: http://10.13.38.11/

[22:20:32] Starting:                            
[22:20:33] 301 -  145B  - /js  ->  http://10.13.38.11/js/                  
[22:20:34] 403 -  312B  - /.%2e/%2e%2e/%2e%2e/%2e%2e/etc/passwd            
[22:20:35] 200 -   10KB - /.ds_store                                       
[22:20:35] 200 -   10KB - /.DS_Store
[22:20:40] 301 -  151B  - /.trashes  ->  http://10.13.38.11/.trashes/      
[22:20:40] 301 -  151B  - /.Trashes  ->  http://10.13.38.11/.Trashes/
[22:20:44] 301 -  151B  - /META-INF  ->  http://10.13.38.11/META-INF/       
[22:20:44] 403 -    1KB - /META-INF/
[22:20:44] 301 -  155B  - /New%20Folder  ->  http://10.13.38.11/New%20Folder/
[22:20:44] 301 -  161B  - /New%20folder%20(2)  ->  http://10.13.38.11/New%20folder%20(2)/  
[22:21:32] 301 -  146B  - /dev  ->  http://10.13.38.11/dev/                 
[22:21:33] 403 -    1KB - /dev/                                             
[22:21:42] 301 -  149B  - /images  ->  http://10.13.38.11/images/           
[22:21:42] 403 -    1KB - /images/                                          
[22:21:44] 403 -    1KB - /js/                                              
[22:22:02] 301 -  150B  - /plugins  ->  http://10.13.38.11/plugins/         
[22:22:03] 403 -    1KB - /plugins/                                         
[22:22:17] 301 -  152B  - /templates  ->  http://10.13.38.11/templates/     
[22:22:17] 403 -    1KB - /templates/                                       
[22:22:18] 403 -    1KB - /themes/                                          
[22:22:18] 301 -  149B  - /themes  ->  http://10.13.38.11/themes/           
[22:22:20] 301 -  150B  - /uploads  ->  http://10.13.38.11/uploads/         
[22:22:20] 403 -    1KB - /uploads/

```

带指定扩展名爆破
```
┌──(root㉿ss)-[~/htb/endgame/POO]
└─# gobuster dir -t 100  --no-error --url http://10.13.38.11 -w /usr/share/wordlists/Web-Content/directory-list-2.3-medium.txt -x asp,aspx,txt
===============================================================
Gobuster v3.1.0
by OJ Reeves (@TheColonial) & Christian Mehlmauer (@firefart)
===============================================================
[+] Url:                     http://10.13.38.11
[+] Method:                  GET
[+] Threads:                 100
[+] Wordlist:                /usr/share/wordlists/Web-Content/directory-list-2.3-medium.txt
[+] Negative Status codes:   404
[+] User Agent:              gobuster/3.1.0
[+] Extensions:              asp,aspx,txt
[+] Timeout:                 10s
===============================================================
2022/05/20 23:02:55 Starting gobuster in directory enumeration mode
===============================================================
/templates            (Status: 301) [Size: 152] [--> http://10.13.38.11/templates/]
/images               (Status: 301) [Size: 149] [--> http://10.13.38.11/images/]   
/uploads              (Status: 301) [Size: 150] [--> http://10.13.38.11/uploads/]  
/Images               (Status: 301) [Size: 149] [--> http://10.13.38.11/Images/]   
/themes               (Status: 301) [Size: 149] [--> http://10.13.38.11/themes/]   
/admin                (Status: 401) [Size: 1293]                                   
/plugins              (Status: 301) [Size: 150] [--> http://10.13.38.11/plugins/]  
/dev                  (Status: 301) [Size: 146] [--> http://10.13.38.11/dev/]      
/js                   (Status: 301) [Size: 145] [--> http://10.13.38.11/js/]       
/Themes               (Status: 301) [Size: 149] [--> http://10.13.38.11/Themes/]   
/widgets              (Status: 301) [Size: 150] [--> http://10.13.38.11/widgets/]  
/Templates            (Status: 301) [Size: 152] [--> http://10.13.38.11/Templates/]
/IMAGES               (Status: 301) [Size: 149] [--> http://10.13.38.11/IMAGES/]   
/Admin                (Status: 401) [Size: 1293]                                   
/JS                   (Status: 301) [Size: 145] [--> http://10.13.38.11/JS/]       
/Plugins              (Status: 301) [Size: 150] [--> http://10.13.38.11/Plugins/]  
/Uploads              (Status: 301) [Size: 150] [--> http://10.13.38.11/Uploads/]  
/Widgets              (Status: 301) [Size: 150] [--> http://10.13.38.11/Widgets/]  
/Dev                  (Status: 301) [Size: 146] [--> http://10.13.38.11/Dev/]      
/DEV                  (Status: 301) [Size: 146] [--> http://10.13.38.11/DEV/]      
                                                                                   
===============================================================
2022/05/20 23:14:48 Finished
===============================================================

```



## ds_store文件

根据[这篇文章](https://miloserdov.org/?p=3867)里关于ds_store文件的介绍和利用方法

使用[这个exp](https://github.com/gehaxelt/Python-dsstore)可以知道文件夹里有哪些文件

```
┌──(root💀kali)-[~/htb/endgame/POO/Python-dsstore]
└─# python3 ./main.py /root/htb/endgame/POO/ds_store                                                                                                                                                 1 ⨯
Count:  38
admin
admin
admin
dev
dev
dev
iisstart.htm
Images
Images
Images
JS
JS
JS
META-INF
META-INF
META-INF
New folder
New folder
New folder
New folder (2)
New folder (2)
New folder (2)
Plugins
Plugins
Plugins
Templates
Templates
Templates
Themes
Themes
Themes
Uploads
Uploads
Uploads
web.config
Widgets
Widgets
Widgets

```


使用[这个exp](https://github.com/lijiejie/ds_store_exp)可以根据DS_Store下载对应文件夹里的文件
```
┌──(root💀kali)-[~/htb/endgame/POO/ds_store_exp]
└─# python2 ./ds_store_exp.py http://10.13.38.11/.DS_Store
[200] http://10.13.38.11/.DS_Store
[401] http://10.13.38.11/admin
[401] http://10.13.38.11/admin/.DS_Store
[200] http://10.13.38.11/dev/.DS_Store
[200] http://10.13.38.11/Widgets/.DS_Store
[200] http://10.13.38.11/JS/.DS_Store
[403] http://10.13.38.11/Templates
[403] http://10.13.38.11/JS
[403] http://10.13.38.11/Widgets
[200] http://10.13.38.11/Themes/.DS_Store
[403] http://10.13.38.11/Themes
[403] http://10.13.38.11/Uploads
[200] http://10.13.38.11/iisstart.htm
[403] http://10.13.38.11/META-INF
[200] http://10.13.38.11/Images/.DS_Store
[403] http://10.13.38.11/Images
[403] http://10.13.38.11/Plugins
[200] http://10.13.38.11/dev/dca66d38fd916317687e1390a420c3fc/.DS_Store
[200] http://10.13.38.11/dev/304c0c90fbc6520610abbf378e2339d1/.DS_Store
[200] http://10.13.38.11/Widgets/Framework/.DS_Store
[403] http://10.13.38.11/dev/dca66d38fd916317687e1390a420c3fc
[403] http://10.13.38.11/Widgets/CalendarEvents
[403] http://10.13.38.11/Widgets/Menu
[403] http://10.13.38.11/dev/304c0c90fbc6520610abbf378e2339d1
[403] http://10.13.38.11/Widgets/Notifications
[403] http://10.13.38.11/Themes/default
[403] http://10.13.38.11/Widgets/Framework
[200] http://10.13.38.11/Images/iisstart.png
[403] http://10.13.38.11/JS/custom
[403] http://10.13.38.11/dev/dca66d38fd916317687e1390a420c3fc/core
[403] http://10.13.38.11/dev/dca66d38fd916317687e1390a420c3fc/src
[403] http://10.13.38.11/dev/dca66d38fd916317687e1390a420c3fc/include
[403] http://10.13.38.11/Images/icons
[403] http://10.13.38.11/dev
[403] http://10.13.38.11/dev/304c0c90fbc6520610abbf378e2339d1/db
[200] http://10.13.38.11/Widgets/Framework/Layouts/.DS_Store
[403] http://10.13.38.11/dev/dca66d38fd916317687e1390a420c3fc/db
[403] http://10.13.38.11/dev/304c0c90fbc6520610abbf378e2339d1/core
[403] http://10.13.38.11/Widgets/Framework/Layouts/default
[403] http://10.13.38.11/Widgets/Framework/Layouts
[403] http://10.13.38.11/dev/304c0c90fbc6520610abbf378e2339d1/src
[403] http://10.13.38.11/dev/304c0c90fbc6520610abbf378e2339d1/include
[403] http://10.13.38.11/Widgets/Framework/Layouts/custom

```