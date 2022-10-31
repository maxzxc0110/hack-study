Task
•  Enumerate following for the us.techcorp.local domain:
−  Restricted Groups from GPO
−  Membership of the restricted groups
−  List all the OUs
−  List all the computers in the Students OU.
−  List the GPOs
−  Enumerate GPO applied on the Students OU.


# Restricted Groups from GPO
```
PS C:\ad\Tools>  Get-DomainGPOLocalGroup


GPODisplayName : Mgmt
GPOName        : {B78BFC6B-76DB-4AA4-9CF6-26260697A8F9}
GPOPath        : \\us.techcorp.local\SysVol\us.techcorp.local\Policies\{B78BFC6B-76DB-4AA4-9CF6-26260697A8F9}
GPOType        : RestrictedGroups
Filters        :
GroupName      : US\machineadmins
GroupSID       : S-1-5-21-210670787-2521448726-163245708-1118
GroupMemberOf  : {S-1-5-32-544}
GroupMembers   : {}
```

组名：US\machineadmins


# Membership of the restricted groups

枚举这个组的成员

```
PS C:\ad\Tools> Get-DomainGroupMember -Identity machineadmins
PS C:\ad\Tools>
```

没有组成员

# List all the OUs

```
PS C:\ad\Tools> Get-DomainOU


usncreated             : 7925
systemflags            : -1946157056
iscriticalsystemobject : True
gplink                 : [LDAP://CN={6AC1786C-016F-11D2-945F-00C04fB984F9},CN=Policies,CN=System,DC=us,DC=techcorp,DC=local;0]
whenchanged            : 7/5/2019 7:48:21 AM
objectclass            : {top, organizationalUnit}
showinadvancedviewonly : False
usnchanged             : 7925
dscorepropagationdata  : {7/30/2019 12:40:16 PM, 7/30/2019 12:39:53 PM, 7/30/2019 12:39:00 PM, 7/30/2019 12:35:19 PM...}
name                   : Domain Controllers
description            : Default container for domain controllers
distinguishedname      : OU=Domain Controllers,DC=us,DC=techcorp,DC=local
ou                     : Domain Controllers
whencreated            : 7/5/2019 7:48:21 AM
instancetype           : 4
objectguid             : fc0dd146-a66e-45cc-83ae-9e5a0c39ed91
objectcategory         : CN=Organizational-Unit,CN=Schema,CN=Configuration,DC=techcorp,DC=local

usncreated            : 36615
displayname           : Mgmt
gplink                : [LDAP://cn={B78BFC6B-76DB-4AA4-9CF6-26260697A8F9},cn=policies,cn=system,DC=us,DC=techcorp,DC=local;0]
whenchanged           : 7/15/2019 10:28:28 AM
objectclass           : {top, organizationalUnit}
usnchanged            : 161066
dscorepropagationdata : {7/30/2019 12:40:16 PM, 7/30/2019 12:39:53 PM, 7/30/2019 12:39:00 PM, 7/30/2019 12:35:19 PM...}
name                  : Mgmt
distinguishedname     : OU=Mgmt,DC=us,DC=techcorp,DC=local
ou                    : Mgmt
whencreated           : 7/7/2019 4:12:41 AM
instancetype          : 4
objectguid            : 0fa90533-edbd-44a7-800e-41ff4ff46285
objectcategory        : CN=Organizational-Unit,CN=Schema,CN=Configuration,DC=techcorp,DC=local

usncreated            : 101289
displayname           : MailMgmt
gplink                : [LDAP://cn={7162874B-E6F0-45AD-A3BF-0858DA4FA02F},cn=policies,cn=system,DC=us,DC=techcorp,DC=local;0]
whenchanged           : 7/11/2019 5:20:16 AM
objectclass           : {top, organizationalUnit}
usnchanged            : 101442
dscorepropagationdata : {7/30/2019 12:40:16 PM, 7/30/2019 12:39:53 PM, 7/30/2019 12:39:00 PM, 7/30/2019 12:35:19 PM...}
name                  : MailMgmt
distinguishedname     : OU=MailMgmt,DC=us,DC=techcorp,DC=local
ou                    : MailMgmt
whencreated           : 7/11/2019 5:04:17 AM
instancetype          : 4
objectguid            : a4a7cc10-e139-4fc7-916e-a76ae5659bf0
objectcategory        : CN=Organizational-Unit,CN=Schema,CN=Configuration,DC=techcorp,DC=local

usncreated            : 117904
displayname           : PAW
gplink                : [LDAP://cn={AFC6881A-5AB6-41D0-91C6-F2390899F102},cn=policies,cn=system,DC=us,DC=techcorp,DC=local;0]
whenchanged           : 7/12/2019 7:36:17 AM
objectclass           : {top, organizationalUnit}
usnchanged            : 117918
dscorepropagationdata : {7/30/2019 12:40:16 PM, 7/30/2019 12:39:53 PM, 7/30/2019 12:39:00 PM, 7/30/2019 12:35:19 PM...}
name                  : PAW
distinguishedname     : OU=PAW,DC=us,DC=techcorp,DC=local
ou                    : PAW
whencreated           : 7/12/2019 7:35:46 AM
instancetype          : 4
objectguid            : 1e5c43b5-1f1d-4670-ae65-1df745c9083c
objectcategory        : CN=Organizational-Unit,CN=Schema,CN=Configuration,DC=techcorp,DC=local

usncreated            : 173363
displayname           : Students
gplink                : [LDAP://cn={FCE16496-C744-4E46-AC89-2D01D76EAD68},cn=policies,cn=system,DC=us,DC=techcorp,DC=local;0]
whenchanged           : 7/20/2019 11:48:51 AM
objectclass           : {top, organizationalUnit}
usnchanged            : 330310
dscorepropagationdata : {7/30/2019 12:40:16 PM, 7/30/2019 12:39:53 PM, 7/30/2019 12:39:00 PM, 7/30/2019 12:35:19 PM...}
name                  : Students
distinguishedname     : OU=Students,DC=us,DC=techcorp,DC=local
ou                    : Students
whencreated           : 7/16/2019 7:47:15 AM
instancetype          : 4
objectguid            : 690743cb-3f54-411c-b014-9879a8b1e054
objectcategory        : CN=Organizational-Unit,CN=Schema,CN=Configuration,DC=techcorp,DC=local
```

只看ou字段
```
PS C:\ad\Tools> Get-DomainOU |select ou

ou
--
Domain Controllers
Mgmt
MailMgmt
PAW
Students

```

# List all the computers in the Students OU.

```
PS C:\ad\Tools> (Get-DomainOU -Identity Students).distinguishedname | %{Get-DomainComputer -SearchBase $_} | select name

name
----
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

# List the GPOs
```
PS C:\ad\Tools>  Get-DomainGPO


usncreated               : 7793
systemflags              : -1946157056
displayname              : Default Domain Policy
gpcmachineextensionnames : [{35378EAC-683F-11D2-A89A-00C04FBBCFA2}{53D6AB1B-2488-11D1-A28C-00C04FB94F17}{D02B1F72-3407-48AE-BA88-E8213C6761F1}][{827D319E-6EAC-11D2-A4EA-00C04F79F83A}{803E14A0-B4FB-11D0-A0D0-00A0C90F574B}][{B1BE8D72-6EAC-11D2-A4EA-00C04F79F83A}{53D6AB1B-
                           2488-11D1-A28C-00C04FB94F17}]
whenchanged              : 7/20/2019 11:35:15 AM
objectclass              : {top, container, groupPolicyContainer}
gpcfunctionalityversion  : 2
showinadvancedviewonly   : True
usnchanged               : 329583
dscorepropagationdata    : {7/30/2019 12:35:19 PM, 7/10/2019 4:00:03 PM, 7/10/2019 4:00:03 PM, 7/7/2019 4:11:13 AM...}
name                     : {31B2F340-016D-11D2-945F-00C04FB984F9}
flags                    : 0
cn                       : {31B2F340-016D-11D2-945F-00C04FB984F9}
iscriticalsystemobject   : True
gpcfilesyspath           : \\us.techcorp.local\sysvol\us.techcorp.local\Policies\{31B2F340-016D-11D2-945F-00C04FB984F9}
distinguishedname        : CN={31B2F340-016D-11D2-945F-00C04FB984F9},CN=Policies,CN=System,DC=us,DC=techcorp,DC=local
whencreated              : 7/5/2019 7:48:21 AM
versionnumber            : 6
instancetype             : 4
objectguid               : d0907c7b-9e3e-42e9-ba50-ac23ea8bb598
objectcategory           : CN=Group-Policy-Container,CN=Schema,CN=Configuration,DC=techcorp,DC=local

usncreated               : 7796
systemflags              : -1946157056
displayname              : Default Domain Controllers Policy
gpcmachineextensionnames : [{827D319E-6EAC-11D2-A4EA-00C04F79F83A}{803E14A0-B4FB-11D0-A0D0-00A0C90F574B}]
whenchanged              : 7/10/2019 4:00:04 PM
objectclass              : {top, container, groupPolicyContainer}
gpcfunctionalityversion  : 2
showinadvancedviewonly   : True
usnchanged               : 93743
dscorepropagationdata    : {7/30/2019 12:35:19 PM, 7/10/2019 4:00:03 PM, 7/10/2019 4:00:03 PM, 7/7/2019 4:11:13 AM...}
name                     : {6AC1786C-016F-11D2-945F-00C04fB984F9}
flags                    : 0
cn                       : {6AC1786C-016F-11D2-945F-00C04fB984F9}
iscriticalsystemobject   : True
gpcfilesyspath           : \\us.techcorp.local\sysvol\us.techcorp.local\Policies\{6AC1786C-016F-11D2-945F-00C04fB984F9}
distinguishedname        : CN={6AC1786C-016F-11D2-945F-00C04fB984F9},CN=Policies,CN=System,DC=us,DC=techcorp,DC=local
whencreated              : 7/5/2019 7:48:21 AM
versionnumber            : 2
instancetype             : 4
objectguid               : 4a3e8abf-cb34-4876-be94-ae7b32239c2e
objectcategory           : CN=Group-Policy-Container,CN=Schema,CN=Configuration,DC=techcorp,DC=local

usncreated               : 101297
displayname              : MailMgmt
gpcmachineextensionnames : [{35378EAC-683F-11D2-A89A-00C04FBBCFA2}{D02B1F72-3407-48AE-BA88-E8213C6761F1}][{827D319E-6EAC-11D2-A4EA-00C04F79F83A}{803E14A0-B4FB-11D0-A0D0-00A0C90F574B}][{D76B9641-3288-4F75-942D-087DE603E3EA}{D02B1F72-3407-48AE-BA88-E8213C6761F1}]
whenchanged              : 7/20/2019 11:40:44 AM
objectclass              : {top, container, groupPolicyContainer}
gpcfunctionalityversion  : 2
showinadvancedviewonly   : True
usnchanged               : 329869
dscorepropagationdata    : {7/30/2019 12:35:19 PM, 1/1/1601 12:00:00 AM}
name                     : {7162874B-E6F0-45AD-A3BF-0858DA4FA02F}
flags                    : 0
cn                       : {7162874B-E6F0-45AD-A3BF-0858DA4FA02F}
gpcfilesyspath           : \\us.techcorp.local\SysVol\us.techcorp.local\Policies\{7162874B-E6F0-45AD-A3BF-0858DA4FA02F}
distinguishedname        : CN={7162874B-E6F0-45AD-A3BF-0858DA4FA02F},CN=Policies,CN=System,DC=us,DC=techcorp,DC=local
whencreated              : 7/11/2019 5:04:51 AM
versionnumber            : 7
instancetype             : 4
objectguid               : 0db7d2aa-c1cb-42c2-87f4-71462d0fdad1
objectcategory           : CN=Group-Policy-Container,CN=Schema,CN=Configuration,DC=techcorp,DC=local

usncreated               : 117912
displayname              : PAW
gpcmachineextensionnames : [{35378EAC-683F-11D2-A89A-00C04FBBCFA2}{D02B1F72-3407-48AE-BA88-E8213C6761F1}][{827D319E-6EAC-11D2-A4EA-00C04F79F83A}{803E14A0-B4FB-11D0-A0D0-00A0C90F574B}][{FC491EF1-C4AA-4CE1-B329-414B101DB823}{D02B1F72-3407-48AE-BA88-E8213C6761F1}]
whenchanged              : 1/8/2021 1:51:31 PM
objectclass              : {top, container, groupPolicyContainer}
gpcfunctionalityversion  : 2
showinadvancedviewonly   : True
usnchanged               : 1942061
dscorepropagationdata    : {7/30/2019 12:35:19 PM, 1/1/1601 12:00:00 AM}
name                     : {AFC6881A-5AB6-41D0-91C6-F2390899F102}
flags                    : 0
cn                       : {AFC6881A-5AB6-41D0-91C6-F2390899F102}
gpcfilesyspath           : \\us.techcorp.local\SysVol\us.techcorp.local\Policies\{AFC6881A-5AB6-41D0-91C6-F2390899F102}
distinguishedname        : CN={AFC6881A-5AB6-41D0-91C6-F2390899F102},CN=Policies,CN=System,DC=us,DC=techcorp,DC=local
whencreated              : 7/12/2019 7:36:17 AM
versionnumber            : 11
instancetype             : 4
objectguid               : 34c56720-b64e-49a9-a629-0c4753100c15
objectcategory           : CN=Group-Policy-Container,CN=Schema,CN=Configuration,DC=techcorp,DC=local

usncreated               : 161060
displayname              : Mgmt
gpcmachineextensionnames : [{827D319E-6EAC-11D2-A4EA-00C04F79F83A}{803E14A0-B4FB-11D0-A0D0-00A0C90F574B}]
whenchanged              : 7/15/2019 10:29:13 AM
objectclass              : {top, container, groupPolicyContainer}
gpcfunctionalityversion  : 2
showinadvancedviewonly   : True
usnchanged               : 161076
dscorepropagationdata    : {7/30/2019 12:35:19 PM, 1/1/1601 12:00:00 AM}
name                     : {B78BFC6B-76DB-4AA4-9CF6-26260697A8F9}
flags                    : 0
cn                       : {B78BFC6B-76DB-4AA4-9CF6-26260697A8F9}
gpcfilesyspath           : \\us.techcorp.local\SysVol\us.techcorp.local\Policies\{B78BFC6B-76DB-4AA4-9CF6-26260697A8F9}
distinguishedname        : CN={B78BFC6B-76DB-4AA4-9CF6-26260697A8F9},CN=Policies,CN=System,DC=us,DC=techcorp,DC=local
whencreated              : 7/15/2019 10:28:28 AM
versionnumber            : 2
instancetype             : 4
objectguid               : 6dfdcad7-ecfa-46ca-91ad-869112490e8f
objectcategory           : CN=Group-Policy-Container,CN=Schema,CN=Configuration,DC=techcorp,DC=local

usncreated               : 330304
displayname              : StudentPolicies
gpcmachineextensionnames : [{35378EAC-683F-11D2-A89A-00C04FBBCFA2}{D02B1F72-3407-48AE-BA88-E8213C6761F1}][{827D319E-6EAC-11D2-A4EA-00C04F79F83A}{803E14A0-B4FB-11D0-A0D0-00A0C90F574B}]
whenchanged              : 7/20/2019 2:17:57 PM
objectclass              : {top, container, groupPolicyContainer}
gpcfunctionalityversion  : 2
showinadvancedviewonly   : True
usnchanged               : 338463
dscorepropagationdata    : {7/30/2019 12:35:19 PM, 1/1/1601 12:00:00 AM}
name                     : {FCE16496-C744-4E46-AC89-2D01D76EAD68}
flags                    : 0
cn                       : {FCE16496-C744-4E46-AC89-2D01D76EAD68}
gpcfilesyspath           : \\us.techcorp.local\SysVol\us.techcorp.local\Policies\{FCE16496-C744-4E46-AC89-2D01D76EAD68}
distinguishedname        : CN={FCE16496-C744-4E46-AC89-2D01D76EAD68},CN=Policies,CN=System,DC=us,DC=techcorp,DC=local
whencreated              : 7/20/2019 11:48:51 AM
versionnumber            : 4
instancetype             : 4
objectguid               : b9bb82a1-5cc2-4264-b4f4-bdf6a238817b
objectcategory           : CN=Group-Policy-Container,CN=Schema,CN=Configuration,DC=techcorp,DC=local


```

只查看displayname,distinguishedname
```
PS C:\ad\Tools> Get-DomainGPO | select displayname,distinguishedname

displayname                       distinguishedname
-----------                       -----------------
Default Domain Policy             CN={31B2F340-016D-11D2-945F-00C04FB984F9},CN=Policies,CN=System,DC=us,DC=techcorp,DC=local
Default Domain Controllers Policy CN={6AC1786C-016F-11D2-945F-00C04fB984F9},CN=Policies,CN=System,DC=us,DC=techcorp,DC=local
MailMgmt                          CN={7162874B-E6F0-45AD-A3BF-0858DA4FA02F},CN=Policies,CN=System,DC=us,DC=techcorp,DC=local
PAW                               CN={AFC6881A-5AB6-41D0-91C6-F2390899F102},CN=Policies,CN=System,DC=us,DC=techcorp,DC=local
Mgmt                              CN={B78BFC6B-76DB-4AA4-9CF6-26260697A8F9},CN=Policies,CN=System,DC=us,DC=techcorp,DC=local
StudentPolicies                   CN={FCE16496-C744-4E46-AC89-2D01D76EAD68},CN=Policies,CN=System,DC=us,DC=techcorp,DC=local
```


# Enumerate GPO applied on the Students OU.

```
PS C:\ad\Tools> Get-DomainGPO -Identity '{FCE16496-C744-4E46-AC89-2D01D76EAD68}'


usncreated               : 330304
displayname              : StudentPolicies
gpcmachineextensionnames : [{35378EAC-683F-11D2-A89A-00C04FBBCFA2}{D02B1F72-3407-48AE-BA88-E8213C6761F1}][{827D319E-6EAC-11D2-A4EA-00C04F79F83A}{803E14A0-B4FB-11D0-A0D0-00A0C90F574B}]
whenchanged              : 7/20/2019 2:17:57 PM
objectclass              : {top, container, groupPolicyContainer}
gpcfunctionalityversion  : 2
showinadvancedviewonly   : True
usnchanged               : 338463
dscorepropagationdata    : {7/30/2019 12:35:19 PM, 1/1/1601 12:00:00 AM}
name                     : {FCE16496-C744-4E46-AC89-2D01D76EAD68}
flags                    : 0
cn                       : {FCE16496-C744-4E46-AC89-2D01D76EAD68}
gpcfilesyspath           : \\us.techcorp.local\SysVol\us.techcorp.local\Policies\{FCE16496-C744-4E46-AC89-2D01D76EAD68}
distinguishedname        : CN={FCE16496-C744-4E46-AC89-2D01D76EAD68},CN=Policies,CN=System,DC=us,DC=techcorp,DC=local
whencreated              : 7/20/2019 11:48:51 AM
versionnumber            : 4
instancetype             : 4
objectguid               : b9bb82a1-5cc2-4264-b4f4-bdf6a238817b
objectcategory           : CN=Group-Policy-Container,CN=Schema,CN=Configuration,DC=techcorp,DC=local
```


