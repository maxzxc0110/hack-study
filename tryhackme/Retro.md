# 免责声明
>本文渗透的主机经过合法授权。本文使用的工具和方法仅限学习交流使用，请不要将文中使用的工具和渗透思路用于任何非法用途，对此产生的一切后果，本人不承担任何责任，也不对造成的任何误用或损害负责。

# 服务发现
```
┌──(root💀kali)-[~/tryhackme]
└─# nmap -sV -Pn 10.10.207.255    
Host discovery disabled (-Pn). All addresses will be marked 'up' and scan times will be slower.
Starting Nmap 7.91 ( https://nmap.org ) at 2021-11-05 05:03 EDT
Nmap scan report for 10.10.207.255
Host is up (0.30s latency).
Not shown: 998 filtered ports
PORT     STATE SERVICE       VERSION
80/tcp   open  http          Microsoft IIS httpd 10.0
3389/tcp open  ms-wbt-server Microsoft Terminal Services
Service Info: OS: Windows; CPE: cpe:/o:microsoft:windows

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 32.16 seconds

```


只有一个80服务和数据库

# 爆破目录
```
┌──(root💀kali)-[~/dirsearch]
└─# python3 dirsearch.py -e* -t 100 -w /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt -u http://10.10.207.255

  _|. _ _  _  _  _ _|_    v0.4.2
 (_||| _) (/_(_|| (_| )

Extensions: php, jsp, asp, aspx, do, action, cgi, pl, html, htm, js, json, tar.gz, bak | HTTP method: GET | Threads: 100 | Wordlist size: 220545

Output File: /root/dirsearch/reports/10.10.207.255/_21-11-05_05-03-57.txt

Error Log: /root/dirsearch/logs/errors-21-11-05_05-03-57.log

Target: http://10.10.207.255/

[05:03:57] Starting: 
[05:04:35] 301 -  150B  - /retro  ->  http://10.10.207.255/retro/  
```

扫到一个目录，浏览了一下，是一个wordpress网站
此时分两步枚举，一继续爆破这个目录，二wpsscan枚举wp信息

## wp目录爆破
```
┌──(root💀kali)-[~/dirsearch]
└─# python3 dirsearch.py -e* -t 100 -w /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt -u http://10.10.207.255/retro

  _|. _ _  _  _  _ _|_    v0.4.2
 (_||| _) (/_(_|| (_| )

Extensions: php, jsp, asp, aspx, do, action, cgi, pl, html, htm, js, json, tar.gz, bak | HTTP method: GET | Threads: 100 | Wordlist size: 220545

Output File: /root/dirsearch/reports/10.10.207.255/-retro_21-11-05_05-08-12.txt

Error Log: /root/dirsearch/logs/errors-21-11-05_05-08-12.log

Target: http://10.10.207.255/retro/

[05:08:14] Starting: 
[05:08:21] 301 -  161B  - /retro/wp-content  ->  http://10.10.207.255/retro/wp-content/
[05:08:24] 301 -  162B  - /retro/wp-includes  ->  http://10.10.207.255/retro/wp-includes/
[05:09:04] 301 -  159B  - /retro/wp-admin  ->  http://10.10.207.255/retro/wp-admin/

```

爆出了三个文件夹，且没有文件遍历漏洞，看上去没有什么可以利用的信息

## wp信息枚举
确认wp版本为:5.2.1
```
└─# wpscan --url http://10.10.207.255/retro    

_______________________________________________________________
         __          _______   _____
         \ \        / /  __ \ / ____|
          \ \  /\  / /| |__) | (___   ___  __ _ _ __ ®
           \ \/  \/ / |  ___/ \___ \ / __|/ _` | '_ \
            \  /\  /  | |     ____) | (__| (_| | | | |
             \/  \/   |_|    |_____/ \___|\__,_|_| |_|

         WordPress Security Scanner by the WPScan Team
                         Version 3.8.14
       Sponsored by Automattic - https://automattic.com/
       @_WPScan_, @ethicalhack3r, @erwan_lr, @firefart
_______________________________________________________________

[i] It seems like you have not updated the database for some time.
[?] Do you want to update now? [Y]es [N]o, default: [N]n
[+] URL: http://10.10.207.255/retro/ [10.10.207.255]
[+] Started: Fri Nov  5 05:09:28 2021

Interesting Finding(s):

[+] Headers
 | Interesting Entries:
 |  - Server: Microsoft-IIS/10.0
 |  - X-Powered-By: PHP/7.1.29
 | Found By: Headers (Passive Detection)
 | Confidence: 100%

[+] XML-RPC seems to be enabled: http://10.10.207.255/retro/xmlrpc.php
 | Found By: Direct Access (Aggressive Detection)
 | Confidence: 100%
 | References:
 |  - http://codex.wordpress.org/XML-RPC_Pingback_API
 |  - https://www.rapid7.com/db/modules/auxiliary/scanner/http/wordpress_ghost_scanner
 |  - https://www.rapid7.com/db/modules/auxiliary/dos/http/wordpress_xmlrpc_dos
 |  - https://www.rapid7.com/db/modules/auxiliary/scanner/http/wordpress_xmlrpc_login
 |  - https://www.rapid7.com/db/modules/auxiliary/scanner/http/wordpress_pingback_access

[+] WordPress readme found: http://10.10.207.255/retro/readme.html
 | Found By: Direct Access (Aggressive Detection)
 | Confidence: 100%

[+] The external WP-Cron seems to be enabled: http://10.10.207.255/retro/wp-cron.php
 | Found By: Direct Access (Aggressive Detection)
 | Confidence: 60%
 | References:
 |  - https://www.iplocation.net/defend-wordpress-from-ddos
 |  - https://github.com/wpscanteam/wpscan/issues/1299

[+] WordPress version 5.2.1 identified (Insecure, released on 2019-05-21).
 | Found By: Rss Generator (Passive Detection)
 |  - http://10.10.207.255/retro/index.php/feed/, <generator>https://wordpress.org/?v=5.2.1</generator>
 |  - http://10.10.207.255/retro/index.php/comments/feed/, <generator>https://wordpress.org/?v=5.2.1</generator>

[+] WordPress theme in use: 90s-retro
 | Location: http://10.10.207.255/retro/wp-content/themes/90s-retro/
 | Latest Version: 1.4.10 (up to date)
 | Last Updated: 2019-04-15T00:00:00.000Z
 | Readme: http://10.10.207.255/retro/wp-content/themes/90s-retro/readme.txt
 | Style URL: http://10.10.207.255/retro/wp-content/themes/90s-retro/style.css?ver=5.2.1
 | Style Name: 90s Retro
 | Style URI: https://organicthemes.com/retro-theme/
 | Description: Have you ever wished your WordPress blog looked like an old Geocities site from the 90s!? Probably n...
 | Author: Organic Themes
 | Author URI: https://organicthemes.com
 |
 | Found By: Css Style In Homepage (Passive Detection)
 |
 | Version: 1.4.10 (80% confidence)
 | Found By: Style (Passive Detection)
 |  - http://10.10.207.255/retro/wp-content/themes/90s-retro/style.css?ver=5.2.1, Match: 'Version: 1.4.10'

[+] Enumerating All Plugins (via Passive Methods)

[i] No plugins Found.

[+] Enumerating Config Backups (via Passive and Aggressive Methods)
 Checking Config Backups - Time: 00:00:12 <=============================================================================================================================================================> (137 / 137) 100.00% Time: 00:00:12

[i] No Config Backups Found.

[!] No WPScan API Token given, as a result vulnerability data has not been output.
[!] You can get a free API token with 50 daily requests by registering at https://wpscan.com/register

[+] Finished: Fri Nov  5 05:10:05 2021
[+] Requests Done: 170
[+] Cached Requests: 5
[+] Data Sent: 44.025 KB
[+] Data Received: 221.001 KB
[+] Memory used: 210.141 MB
[+] Elapsed time: 00:00:36

```

## kali搜索这个版本wp的漏洞

显示存在sql注入
```
┌──(root💀kali)-[~]
└─# searchsploit WordPress 5.2.1       
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- ---------------------------------
 Exploit Title                                                                                                                                                                                            |  Path
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- ---------------------------------
WordPress Core < 5.2.3 - Viewing Unauthenticated/Password/Private Posts                                                                                                                                   | multiple/webapps/47690.md
WordPress Core < 5.3.x - 'xmlrpc.php' Denial of Service                                                                                                                                                   | php/dos/47800.py
WordPress Plugin DZS Videogallery < 8.60 - Multiple Vulnerabilities                                                                                                                                       | php/webapps/39553.txt
WordPress Plugin iThemes Security < 7.0.3 - SQL Injection                                                                                                                                                 | php/webapps/44943.txt
WordPress Plugin Link Library 5.2.1 - SQL Injection                                                                                                                                                       | php/webapps/17887.txt
WordPress Plugin Rest Google Maps < 7.11.18 - SQL Injection                                                                                                                                               | php/webapps/48918.sh
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- ---------------------------------
Shellcodes: No Results

```

看说明是某个插件有一个注入漏洞，但测试这个wp不存在这个插件，wpscan也没有扫出这个插件

在首页我们看文章的作者名字叫```wade```，用这个账号尝试登陆wp提示

>ERROR: The password you entered for the username wade is incorrect. 

这表示```wade```这个账号是确实存在的

我们用wpscan枚举用户名也证明确实存在```wade```和```Wade```
```
[+] Enumerating Users (via Passive and Aggressive Methods)
 Brute Forcing Author IDs - Time: 00:01:07 <============================================================================================================================================================> (200 / 200) 100.00% Time: 00:01:07

[i] User(s) Identified:

[+] wade
 | Found By: Author Posts - Author Pattern (Passive Detection)
 | Confirmed By:
 |  Wp Json Api (Aggressive Detection)
 |   - http://10.10.207.255/retro/index.php/wp-json/wp/v2/users/?per_page=100&page=1
 |  Author Id Brute Forcing - Author Pattern (Aggressive Detection)
 |  Login Error Messages (Aggressive Detection)

[+] Wade
 | Found By: Rss Generator (Passive Detection)
 | Confirmed By: Login Error Messages (Aggressive Detection)

```

user.txt的提示是：
>Don't leave sensitive information out in the open, even if you think you have control over it.

我们假设作者在公共场合谈论了跟自己密码有关的信息，也许藏在博客文章里

期中一篇文章好像透露了一些信息
```
Ready Player One

by Wade

I can’t believe the movie based on my favorite book of all time is going to come out in a few days! Maybe it’s because my name is so similar to the main character, but I honestly feel a deep connection to the main character Wade. I keep mistyping the name of his avatar whenever I log in but I think I’ll eventually get it down. Either way, I’m really excited to see this movie! 
```

Ready Player One就是电源《头号玩家》，


wpscan --url http://10.10.207.255/retro -P /usr/share/wordlists/rockyou.txt  -U wade 

wpscan --url http://10.10.207.255/retro -P /usr/share/wordlists/rockyou.txt  -U Wade 