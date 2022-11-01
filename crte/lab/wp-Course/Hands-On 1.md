Task
•  Enumerate following for the us.techcorp.local domain:
−  Users
−  Computers
−  Domain Administrators
−  Enterprise Administrators
−  Kerberos Policy

使用使用 ActiveDirectory module
```
Import-Module C:\AD\Tools\ADModule-master\Microsoft.ActiveDirectory.Management.dll
Import-Module C:\AD\Tools\ADModule-master\ActiveDirectory\ActiveDirectory.psd1
```

使用powerview
```
Import-Module C:\AD\Tools\PowerView.ps1
```


# Users
```
PS C:\ad\Tools> get-netuser|select cn

cn
--
Administrator
Guest
krbtgt
Employee Test
ad connect
mgmtadmin
helpdeskadmin
dbservice
atauser
exchangeadmin
HealthMailbox3bd1057e1eea48559bafaab020a25aa1
HealthMailboxc8de5586472349dd9fd08a03c14803b0
HealthMailbox01f72be58b1f4a888b2afe365ab6f0a6
HealthMailbox128342ca0cad4fa6b4a4b05df5cc4e57
HealthMailboxbb3d25e65cd546d186735c1d8f2e7a22
HealthMailbox87cf12ff67e943ff9cfa5028f5c7c52a
HealthMailboxd51773500e7f46828530b70164823870
HealthMailbox86956b98d46c4f15a319e23b2e567e18
HealthMailbox307c425e28c745f0a6a65127edc1c5db
HealthMailbox7f97592969464789a4da5b8b277a77fc
HealthMailboxd933b3c429bb43cea9e40a6ce35cdb05
exchange manager
exchange user
pawadmin
James  Williams
webmaster
serviceaccount
devuser
testda
decda
appsvc
provisioning svc
Support131User
Support132User
Support133User
Support134User
Support135User
Support136User
Support137User
Support138User
Support139User
Support140User
Support141User
Support142User
Support143User
Support144User
Support145User
Support146User
Support147User
Support148User
Support149User
Support150User
studentuser131
studentuser132
studentuser133
studentuser134
studentuser135
studentuser136
studentuser137
studentuser138
studentuser139
studentuser140
studentuser141
studentuser142
studentuser143
studentuser144
studentuser145
studentuser146
studentuser147
studentuser148
studentuser149
studentuser150

```

# Computers

```
PS C:\ad\Tools> Get-DomainComputer |select cn

cn
--
US-DC
US-EXCHANGE
US-MGMT
US-HELPDESK
US-MSSQL
US-MAILMGMT
US-JUMP
US-WEB
US-ADCONNECT
jumpone
STUDENT131
STUDENT132
STUDENT133
STUDENT134
STUDENT135
STUDENT136
STUDENT137
STUDENT138
STUDENT139
STUDENT140
STUDENT141
STUDENT142
STUDENT143
STUDENT144
STUDENT145
STUDENT146
STUDENT147
STUDENT148
STUDENT149
STUDENT150
```



# Domain Administrators

```
PS C:\ad\Tools> Get-DomainGroup "Domain Admins"


grouptype              : GLOBAL_SCOPE, SECURITY
admincount             : 1
iscriticalsystemobject : True
samaccounttype         : GROUP_OBJECT
samaccountname         : Domain Admins
whenchanged            : 7/19/2019 7:16:32 PM
objectsid              : S-1-5-21-210670787-2521448726-163245708-512
objectclass            : {top, group}
cn                     : Domain Admins
usnchanged             : 282184
dscorepropagationdata  : {7/30/2019 12:35:19 PM, 7/10/2019 4:53:40 PM, 7/10/2019 4:00:03 PM, 7/7/2019 4:11:13 AM...}
memberof               : {CN=Denied RODC Password Replication Group,CN=Users,DC=us,DC=techcorp,DC=local, CN=Administrators,CN=Builtin,DC=us,DC=techcorp,DC=local}
description            : Designated administrators of the domain
distinguishedname      : CN=Domain Admins,CN=Users,DC=us,DC=techcorp,DC=local
name                   : Domain Admins
member                 : {CN=decda,CN=Users,DC=us,DC=techcorp,DC=local, CN=Administrator,CN=Users,DC=us,DC=techcorp,DC=local}
usncreated             : 12315
whencreated            : 7/5/2019 7:49:17 AM
instancetype           : 4
objectguid             : 218cc77d-0e1c-41ed-91b2-730f6279c325
objectcategory         : CN=Group,CN=Schema,CN=Configuration,DC=techcorp,DC=local



PS C:\ad\Tools> Get-DomainGroupMember "Domain Admins" | select -ExpandProperty membername
decda
Administrator
PS C:\ad\Tools>
```

# Enterprise Administrators
```
PS C:\ad\Tools> Get-DomainGroup "Enterprise Admins" -Domain techcorp.local


grouptype              : UNIVERSAL_SCOPE, SECURITY
admincount             : 1
iscriticalsystemobject : True
samaccounttype         : GROUP_OBJECT
samaccountname         : Enterprise Admins
whenchanged            : 11/5/2021 5:12:34 PM
objectsid              : S-1-5-21-2781415573-3701854478-2406986946-519
objectclass            : {top, group}
cn                     : Enterprise Admins
usnchanged             : 972308
dscorepropagationdata  : {7/11/2019 1:25:36 PM, 7/11/2019 1:24:31 PM, 7/10/2019 4:45:33 PM, 7/10/2019 3:58:12 PM...}
memberof               : {CN=Denied RODC Password Replication Group,CN=Users,DC=techcorp,DC=local, CN=Administrators,CN=Builtin,DC=techcorp,DC=local}
description            : Designated administrators of the enterprise
distinguishedname      : CN=Enterprise Admins,CN=Users,DC=techcorp,DC=local
name                   : Enterprise Admins
member                 : CN=Administrator,CN=Users,DC=techcorp,DC=local
usncreated             : 12339
whencreated            : 7/4/2019 9:52:52 AM
instancetype           : 4
objectguid             : 9b290d6f-018b-4f57-b1aa-49802d449360
objectcategory         : CN=Group,CN=Schema,CN=Configuration,DC=techcorp,DC=local
```


# Kerberos Policy
```
PS C:\ad\Tools> (Get-DomainPolicy).KerberosPolicy


MaxTicketAge         : 10
MaxRenewAge          : 7
MaxServiceAge        : 600
MaxClockSkew         : 5
TicketValidateClient : 1
```


 Get-ADGroupMember -Identity 'Enterprise Admins' -Server techcorp.local