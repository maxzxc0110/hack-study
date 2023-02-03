Task
•  Enumerate following for the us.techcorp.local domain:
−  ACL for the Domain Admins group
−  All modify rights/permissions for the studentuserx

# ACL for the Domain Admins group

```
PS C:\ad\Tools> Get-DomainObjectAcl -Identity "Domain Admins" -ResolveGUIDs -Verbose
VERBOSE: [Get-DomainSearcher] search base: LDAP://US-DC.US.TECHCORP.LOCAL/DC=US,DC=TECHCORP,DC=LOCAL
VERBOSE: [Get-DomainSearcher] search base: LDAP://US-DC.US.TECHCORP.LOCAL/DC=techcorp,DC=local
VERBOSE: [Get-DomainUser] filter string: (&(samAccountType=805306368)(|(samAccountName=krbtgt)))
VERBOSE: [Get-DomainSearcher] search base: LDAP://US-DC.US.TECHCORP.LOCAL/CN=Schema,CN=Configuration,DC=techcorp,DC=local
VERBOSE: [Get-DomainSearcher] search base: LDAP://US-DC.US.TECHCORP.LOCAL/CN=Extended-Rights,CN=Configuration,DC=techcorp,DC=local
VERBOSE: [Get-DomainObjectAcl] Get-DomainObjectAcl filter string: (&(|(|(samAccountName=Domain Admins)(name=Domain Admins)(displayname=Domain Admins))))


AceQualifier           : AccessAllowed
ObjectDN               : CN=Domain Admins,CN=Users,DC=us,DC=techcorp,DC=local
ActiveDirectoryRights  : CreateChild, DeleteChild, ListChildren
ObjectAceType          : ms-Exch-Active-Sync-Devices
ObjectSID              : S-1-5-21-210670787-2521448726-163245708-512
InheritanceFlags       : ContainerInherit
BinaryLength           : 72
AceType                : AccessAllowedObject
ObjectAceFlags         : ObjectAceTypePresent, InheritedObjectAceTypePresent
IsCallback             : False
PropagationFlags       : InheritOnly
SecurityIdentifier     : S-1-5-21-2781415573-3701854478-2406986946-1119
AccessMask             : 7
AuditFlags             : None
IsInherited            : False
AceFlags               : ContainerInherit, InheritOnly
InheritedObjectAceType : inetOrgPerson
OpaqueLength           : 0

AceQualifier           : AccessAllowed
ObjectDN               : CN=Domain Admins,CN=Users,DC=us,DC=techcorp,DC=local
ActiveDirectoryRights  : CreateChild, DeleteChild, ListChildren
ObjectAceType          : ms-Exch-Active-Sync-Devices
ObjectSID              : S-1-5-21-210670787-2521448726-163245708-512
InheritanceFlags       : ContainerInherit
BinaryLength           : 72
AceType                : AccessAllowedObject
ObjectAceFlags         : ObjectAceTypePresent, InheritedObjectAceTypePresent
IsCallback             : False
PropagationFlags       : InheritOnly
SecurityIdentifier     : S-1-5-21-2781415573-3701854478-2406986946-1119
AccessMask             : 7
AuditFlags             : None
IsInherited            : False
AceFlags               : ContainerInherit, InheritOnly
InheritedObjectAceType : User
OpaqueLength           : 0

AceQualifier           : AccessAllowed
ObjectDN               : CN=Domain Admins,CN=Users,DC=us,DC=techcorp,DC=local
ActiveDirectoryRights  : ReadProperty
ObjectAceType          : User-Account-Restrictions
ObjectSID              : S-1-5-21-210670787-2521448726-163245708-512
InheritanceFlags       : None
BinaryLength           : 60
AceType                : AccessAllowedObject
ObjectAceFlags         : ObjectAceTypePresent, InheritedObjectAceTypePresent
IsCallback             : False
PropagationFlags       : None
SecurityIdentifier     : S-1-5-32-554
AccessMask             : 16
AuditFlags             : None
IsInherited            : False
AceFlags               : None
InheritedObjectAceType : inetOrgPerson
OpaqueLength           : 0


...
...
```


# All modify rights/permissions for the studentuserx

查詢当前账号时是否有任何修改权限
```
PS C:\ad\Tools> Find-InterestingDomainAcl -ResolveGUIDs |?{$_.IdentityReferenceName -match "studentuser138"}
```

没有任何输出


枚举StudentUsers用户组有无任何修改权限
```
PS C:\ad\Tools> Find-InterestingDomainAcl -ResolveGUIDs |?{$_.IdentityReferenceName -match "StudentUsers"}
WARNING: [Find-InterestingDomainAcl] Unable to convert SID 'S-1-5-21-210670787-2521448726-163245708-1147' to a distinguishedname with Convert-ADName
WARNING: [Find-InterestingDomainAcl] Unable to convert SID 'S-1-5-21-210670787-2521448726-163245708-1147' to a distinguishedname with Convert-ADName
WARNING: [Find-InterestingDomainAcl] Unable to convert SID 'S-1-5-21-210670787-2521448726-163245708-1147' to a distinguishedname with Convert-ADName


ObjectDN                : CN=Support131User,CN=Users,DC=us,DC=techcorp,DC=local
AceQualifier            : AccessAllowed
ActiveDirectoryRights   : GenericAll
ObjectAceType           : None
AceFlags                : None
AceType                 : AccessAllowed
InheritanceFlags        : None
SecurityIdentifier      : S-1-5-21-210670787-2521448726-163245708-1116
IdentityReferenceName   : studentusers
IdentityReferenceDomain : us.techcorp.local
IdentityReferenceDN     : CN=StudentUsers,CN=Users,DC=us,DC=techcorp,DC=local
IdentityReferenceClass  : group

ObjectDN                : CN=Support132User,CN=Users,DC=us,DC=techcorp,DC=local
AceQualifier            : AccessAllowed
ActiveDirectoryRights   : GenericAll
ObjectAceType           : None
AceFlags                : None
AceType                 : AccessAllowed
InheritanceFlags        : None
SecurityIdentifier      : S-1-5-21-210670787-2521448726-163245708-1116
IdentityReferenceName   : studentusers
IdentityReferenceDomain : us.techcorp.local
IdentityReferenceDN     : CN=StudentUsers,CN=Users,DC=us,DC=techcorp,DC=local
IdentityReferenceClass  : group



....
....
```
