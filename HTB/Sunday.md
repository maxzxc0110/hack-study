# 免责声明
>本文渗透的主机经过合法授权。本文使用的工具和方法仅限学习交流使用，请不要将文中使用的工具和渗透思路用于任何非法用途，对此产生的一切后果，本人不承担任何责任，也不对造成的任何误用或损害负责。

# 服务发现
```
┌──(root💀kali)-[~/htb/Sunday]
└─# nmap -p- 10.10.10.76 --open                                    
Starting Nmap 7.91 ( https://nmap.org ) at 2021-12-16 04:39 EST
Stats: 0:00:08 elapsed; 0 hosts completed (1 up), 1 undergoing SYN Stealth Scan
SYN Stealth Scan Timing: About 1.59% done; ETC: 04:47 (0:08:14 remaining)
Stats: 0:00:26 elapsed; 0 hosts completed (1 up), 1 undergoing SYN Stealth Scan
SYN Stealth Scan Timing: About 6.29% done; ETC: 04:45 (0:06:27 remaining)
Nmap scan report for 10.10.10.76
Host is up (0.25s latency).
Not shown: 59378 filtered ports, 6152 closed ports
Some closed ports may be reported as filtered due to --defeat-rst-ratelimit
PORT      STATE SERVICE
79/tcp    open  finger
111/tcp   open  rpcbind
22022/tcp open  unknown
34888/tcp open  unknown
61910/tcp open  unknown


```

这部机器全局扫描超级慢，获取服务详细信息看看
```
┌──(root💀kali)-[~/htb/Sunday]
└─# nmap -sV -sC 10.10.10.76 -A -O -p 79,111,22022,34888,61910   
Starting Nmap 7.91 ( https://nmap.org ) at 2021-12-16 04:44 EST
Nmap scan report for 10.10.10.76
Host is up (0.29s latency).

PORT      STATE SERVICE VERSION
79/tcp    open  finger  Sun Solaris fingerd
|_finger: No one logged on\x0D
111/tcp   open  rpcbind 2-4 (RPC #100000)
22022/tcp open  ssh     SunSSH 1.3 (protocol 2.0)
| ssh-hostkey: 
|   1024 d2:e5:cb:bd:33:c7:01:31:0b:3c:63:d9:82:d9:f1:4e (DSA)
|_  1024 e4:2c:80:62:cf:15:17:79:ff:72:9d:df:8b:a6:c9:ac (RSA)
34888/tcp open  unknown
61910/tcp open  unknown
Warning: OSScan results may be unreliable because we could not find at least 1 open and 1 closed port
Device type: WAP|phone
Running: Linux 2.4.X|2.6.X, Sony Ericsson embedded
OS CPE: cpe:/o:linux:linux_kernel:2.4.20 cpe:/o:linux:linux_kernel:2.6.22 cpe:/h:sonyericsson:u8i_vivaz
OS details: Tomato 1.28 (Linux 2.4.20), Tomato firmware (Linux 2.6.22), Sony Ericsson U8i Vivaz mobile phone
Network Distance: 21 hops
Service Info: OS: Solaris; CPE: cpe:/o:sun:sunos

TRACEROUTE (using port 443/tcp)
HOP RTT        ADDRESS
1   250.60 ms  10.10.14.1
2   ... 11
12  1274.17 ms 10.10.14.1
13  1274.24 ms 10.10.14.1
14  1274.28 ms 10.10.14.1
15  ... 20
21  2297.62 ms 10.10.10.76

OS and Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 90.06 seconds


```


```
#!/bin/bash

# http://stackoverflow.com/questions/10929453/read-a-file-line-by-line-assigning-the-value-to-a-variable
display_usage()
{
        echo -e "\nScript takes a file with a list of users as argument"
        echo -e "Usage:\n./finger_enum_user.sh <filename.txt>\n"
}

if [ $# -le 0 ]
then
        display_usage
        exit 1
fi

while IFS='' read -r line || [[ -n "$line" ]]; do

        echo "User :" $line
        finger $line@10.10.10.76 | grep ".  .  .  ."

        echo -e "\n"

done < "$1"

```

┌──(root💀kali)-[~/htb/Sunday]
└─# ./finger_enum_user.sh /usr/share/metasploit-framework/data/wordlists/unix_users.txt 
User : admin
Login       Name               TTY         Idle    When    Where
adm      Admin                              < .  .  .  . >
lp       Line Printer Admin                 < .  .  .  . >
uucp     uucp Admin                         < .  .  .  . >
nuucp    uucp Admin                         < .  .  .  . >
dladm    Datalink Admin                     < .  .  .  . >
listen   Network Admin                      < .  .  .  . >

User : gdm
Login       Name               TTY         Idle    When    Where
gdm      GDM Reserved UID                   < .  .  .  . >

User : mysql
Login       Name               TTY         Idle    When    Where
mysql    MySQL Reserved UID                 < .  .  .  . >

User : nobody
Login       Name               TTY         Idle    When    Where
nobody   NFS Anonymous Access               < .  .  .  . >


User : nobody4
Login       Name               TTY         Idle    When    Where
nobody4  SunOS 4.x NFS Anonym               < .  .  .  . >

User : nuucp
Login       Name               TTY         Idle    When    Where
nuucp    uucp Admin                         < .  .  .  . >

User : postgres
Login       Name               TTY         Idle    When    Where
postgres PostgreSQL Reserved                < .  .  .  . >

User : printer
Login       Name               TTY         Idle    When    Where
lp       Line Printer Admin                 < .  .  .  . >

User : sys
Login       Name               TTY         Idle    When    Where
sys             ???                         < .  .  .  . >
