# Domain Reconnaissance

域枚举

# PowerView

引入PowerView,注意这一节使用的是开发版的PS
```
beacon> powershell-import C:\Tools\PowerSploit\Recon\PowerView.ps1
```

# Get-Domain

获取当前域
```
beacon> powershell Get-Domain
```

# Get-DomainController
获取DC

```
beacon> powershell Get-DomainController | select Forest, Name, OSVersion | fl
```

# Get-ForestDomain

获取当前林
```
beacon> powershell Get-ForestDomain
```

# Get-DomainPolicyData

返回当前域或指定域/域控制器的默认域策略或域控制器策略。对于查找诸如域密码策略之类的信息很有用。
```
beacon> powershell Get-DomainPolicyData | select -ExpandProperty SystemAccess

MinimumPasswordAge           : 1
MaximumPasswordAge           : 42
MinimumPasswordLength        : 7
PasswordComplexity           : 1
PasswordHistorySize          : 24
LockoutBadCount              : 0
RequireLogonToChangePassword : 0
ForceLogoffWhenHourExpire    : 0
ClearTextPassword            : 0
LSAAnonymousNameLookup       : 0
```

# Get-DomainUser

返回所有（或特定）用户。要仅返回特定属性，请使用-Properties. 默认情况下，返回当前域的所有用户对象，用于-Identity返回特定用户。

```
beacon> powershell Get-DomainUser -Identity nlamb -Properties DisplayName, MemberOf | fl

displayname : Nina Lamb
memberof    : {CN=Roaming Users,CN=Users,DC=dev,DC=cyberbotic,DC=io, CN=Group Policy Creator 
              Owners,CN=Users,DC=dev,DC=cyberbotic,DC=io, CN=Domain Admins,CN=Users,DC=dev,DC=cyberbotic,DC=io, 
              CN=Administrators,CN=Builtin,DC=dev,DC=cyberbotic,DC=io}
```

# Get-DomainComputer

获取域内所有计算机
```
beacon> powershell Get-DomainComputer -Properties DnsHostName | sort -Property DnsHostName
```

# Get-DomainOU

搜索所有organization units(OU) 或特定 OU 对象

```
beacon> powershell Get-DomainOU -Properties Name | sort -Property Name

name              
----              
Domain Controllers
Servers           
Tier 1            
Tier 2            
Workstations
```

# Get-DomainGroup

获取域内所有的组信息
```
beacon> powershell Get-DomainGroup
```

获取所有带```admin```字样的组信息
```
beacon> powershell Get-DomainGroup | where Name -like "*Admins*" | select SamAccountName

samaccountname
--------------
Domain Admins 
Key Admins    
DnsAdmins     
Oracle Admins 
```

# Get-DomainGroupMember

返回特定的组成员信息，这里是返回DA组
```
beacon> powershell Get-DomainGroupMember -Identity "Domain Admins" | select MemberDistinguishedName

MemberDistinguishedName                             
-----------------------                             
CN=Nina Lamb,CN=Users,DC=dev,DC=cyberbotic,DC=io    
CN=Administrator,CN=Users,DC=dev,DC=cyberbotic,DC=io
```

# Get-DomainGPO

返回所有组策略对象 (GPO) 或特定 GPO 对象。要枚举应用于特定机器的所有 GPO，请使用```-ComputerIdentity```

```
beacon> powershell Get-DomainGPO -Properties DisplayName | sort -Property DisplayName

displayname                      
-----------                      
Default Domain Controllers Policy
Default Domain Policy
Roaming Users
Tier 1 Admins
Tier 2 Admins
Windows Defender
Windows Firewall
```


```
beacon> powershell Get-DomainGPO -ComputerIdentity wkstn-1 -Properties DisplayName | sort -Property DisplayName

displayname          
-----------          
Default Domain Policy
LAPS
PowerShell Logging
Roaming Users
Windows Defender
Windows Firewall
```

# Get-DomainGPOLocalGroup

返回所有通过受限组或组策略首选项修改本地组成员资格的GPO。
```
beacon> powershell Get-DomainGPOLocalGroup | select GPODisplayName, GroupName

GPODisplayName GroupName           
-------------- ---------           
Tier 1 Admins  DEV\Developers      
Tier 2 Admins  DEV\1st Line Support
```

# Get-DomainGPOUserLocalGroupMapping

枚举特定域用户/组是特定本地组成员的机器。

```
beacon> powershell Get-DomainGPOUserLocalGroupMapping -LocalGroup Administrators | select ObjectName, GPODisplayName, ContainerName, ComputerName

ObjectName       GPODisplayName ContainerName                                     ComputerName             
----------       -------------- -------------                                     ------------             
1st Line Support Tier 2 Admins  {OU=Tier 2,OU=Servers,DC=dev,DC=cyberbotic,DC=io} {srv-2.dev.cyberbotic.io}
Developers       Tier 1 Admins  {OU=Tier 1,OU=Servers,DC=dev,DC=cyberbotic,DC=io} {srv-1.dev.cyberbotic.io}
```

# Find-DomainUserLocation

查找域用户（默认是DA）登录过的机器
```
beacon> powershell Find-DomainUserLocation | select UserName, SessionFromName

UserName      SessionFromName          
--------      ---------------          
nlamb         wkstn-2.dev.cyberbotic.io
```


# Get-NetSession

返回本地（或远程）机器的会话信息（其中CName是源IP）
```
beacon> powershell Get-NetSession -ComputerName dc-2 | select CName, UserName

CName          UserName
-----          --------
\\10.10.17.231 bfarmer 
\\10.10.17.132 nlamb   
```

# Get-DomainTrust

枚举域信任关系
```
beacon> powershell Get-DomainTrust
```

# [SharpView](https://github.com/tevora-threat/SharpView)

C#版本的powerview

使用SharpView枚举当前域
```
beacon> execute-assembly C:\Tools\SharpView\SharpView\bin\Debug\SharpView.exe Get-Domain

Forest                         : cyberbotic.io
DomainControllers              : {dc-2.dev.cyberbotic.io}
Children                       : {}
DomainMode                     : Unknown
DomainModeLevel                : 7
Parent                         : cyberbotic.io
PdcRoleOwner                   : dc-2.dev.cyberbotic.io
RidRoleOwner                   : dc-2.dev.cyberbotic.io
InfrastructureRoleOwner        : dc-2.dev.cyberbotic.io
Name                           : dev.cyberbotic.io
```

# [ADSearch](https://github.com/tomcarver16/ADSearch)

功能比powerview和shapview少一些，但是有强大的LDAP 查询功能

查找所有以```admins```结尾的域用户组
```
beacon> execute-assembly C:\Tools\ADSearch\ADSearch\bin\Debug\ADSearch.exe --search "(&(objectCategory=group)(cn=*Admins))"

[*] No domain supplied. This PC's domain will be used instead
[*] LDAP://DC=dev,DC=cyberbotic,DC=io
[*] CUSTOM SEARCH: 
[*] TOTAL NUMBER OF SEARCH RESULTS: 6
[+] cn : Domain Admins
[+] cn : Key Admins
[+] cn : DnsAdmins
[+] cn : Oracle Admins
[+] cn : Subsidiary Admins
[+] cn : MS SQL Admins
```

# [BloodHound](https://github.com/BloodHoundAD/BloodHound)

启动neo4j
```
C:\Users\Administrator>cd C:\Tools\neo4j\bin

C:\Tools\neo4j\bin>neo4j.bat console
2021-05-11 10:03:21.143+0000 INFO  Starting...
2021-05-11 10:03:28.065+0000 INFO  ======== Neo4j 4.2.3 ========
2021-05-11 10:03:32.143+0000 INFO  Performing postInitialization step for component 'security-users' with version 2 and status CURRENT
2021-05-11 10:03:32.143+0000 INFO  Updating the initial password in component 'security-users'
2021-05-11 10:03:33.128+0000 INFO  Bolt enabled on localhost:7687.
2021-05-11 10:03:36.096+0000 INFO  Remote interface available at http://localhost:7474/
2021-05-11 10:03:36.096+0000 INFO  Started.
```

登录数据库页面
```
http://localhost:7474/
```

用户名和密码都是：neo4j
需要修改新密码

双击BloodHound.exe启动BloodHound


SharpHound，收集器，负责收集域内各种信息

参数
```
Default - Performs group membership collection, domain trust collection, local group collection, session collection, ACL collection, object property collection, and SPN target collection
Group - Performs group membership collection
LocalAdmin - Performs local admin collection
RDP - Performs Remote Desktop Users collection
DCOM - Performs Distributed COM Users collection
PSRemote - Performs Remote Management Users collection
GPOLocalGroup - Performs local admin collection using Group Policy Objects
Session - Performs session collection
ComputerOnly - Performs local admin, RDP, DCOM and session collection
LoggedOn - Performs privileged session collection (requires admin rights on target systems)
Trusts - Performs domain trust enumeration
ACL - Performs collection of ACLs
Container - Performs collection of Containers
DcOnly - Performs collection using LDAP only. Includes Group, Trusts, ACL, ObjectProps, Container, and GPOLocalGroup.
ObjectProps - Performs Object Properties collection for properties such as LastLogon or PwdLastSet
All - Performs all Collection Methods except GPOLocalGroup.
```

收集DC的信息
```
beacon> execute-assembly C:\Tools\SharpHound3\SharpHound3\bin\Debug\SharpHound.exe -c DcOnly
```

默认情况下，SharpHound 收集的是当前域的信息，需要指定域信息收集，使用```-d```参数

```
beacon> execute-assembly C:\Tools\SharpHound3\SharpHound3\bin\Debug\SharpHound.exe -c DcOnly -d cyberbotic.io
```

## BloodHound查询器

搜索设置了SPN的所有用户
```
MATCH (u:User {hasspn:true}) RETURN u
```

查询所有对其他 机器有约束委派（AllowedToDelegate）的计算机
```
MATCH (c:Computer), (t:Computer), p=((c)-[:AllowedToDelegate]->(t)) RETURN p
```

返回从任何具有 SPN 的用户到DA的最短路径
```
MATCH (u:User {hasspn:true}), (c:Computer), p=shortestPath((u)-[*1..]->(c)) RETURN p
```