# PowerUp

##  Service Enumeration(服务枚举)
```
Get-ServiceUnquoted             该模块返回包含空格但是没有引号的服务路径的服务
Get-ModifiableServiceFile       该模块返回当前用户可以修改服务的二进制文件或修改其配置文件的服务
Get-ModifiableService           该模块返回当前用户能修改的服务
Get-ServiceDetail               该模块用于返回某服务的信息，用法: Get-ServiceDetail -servicename  服务名
```

Service Abuse(服务滥用) 
```
Invoke-ServiceAbuse          该模块通过修改服务来添加用户到指定组，并可以通过设置 -cmd 参数触发添加用户的自定义命令
Write-ServiceBinary          该模块通过写入一个修补的C#服务二进制文件，它可以添加本地管理程序或执行自定义命令，Write-ServiceBinary与Install-ServiceBinary不同之处自安于，前者生成可执行文件，后者直接安装服务  
Install-ServiceBinary        该模块通过Write-ServiceBinary写一个C#的服务用来添加用户，
Restore-ServiceBinary        该模块用于恢复服务的可执行文件到原始目录，使用：Restore-ServiceBinary -servicename 服务名
```


DLL Hijacking(DLL注入) 
```
Find-ProcessDLLHijack       该模块查找当前正在运行的进程潜在的dll劫持机会。
Find-PathDLLHijack          该模块用于检查当前 %path% 的哪些目录是用户可以写入的
Write-HijackDll             该模块可写入可劫持的dll
```

Registry Checks(注册审核)
```
Get-RegistryAlwaysInstallElevated     该模块用于检查AlwaysInstallElevated注册表项是否被设置，如果已被设置，则意味着SAM文件是以System权限运行的
Get-RegistryAutoLogon                 该模块用于检测Winlogin注册表的AutoAdminLogon项是否被设置，可用于查询默认的用户名和密码
Get-ModifiableRegistryAutoRun         该模块用于检查开机自启的应用程序路径和注册表键值，然后返回当前用户可修改的程序路径，被检查的注册表键值有以下：
    HKLM\Software\Microsoft\Windows\CurrentVersino\Run
    HKLM\Software\Microsoft\Windows\CurrentVersino\RunOnce
    HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Run
    HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunOnce
    HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunService
    HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunOnceService
    HKLM\Software\Microsoft\Windows\CurrentVersion\RunService
    HKLM\Software\Microsoft\Windows\CurrentVersion\RunOnceService
```

Miscellaneous Checks(杂项审核) 
```
Get-ModifiableScheduledTaskFile       该模块用于返回当前用户能够修改的计划任务程序的名称和路径 
Get-Webconfig                         该模块用于返回当前服务器上web.config文件中的数据库连接字符串的明文
Get-ApplicationHost                   该模块利用系统上的applicationHost.config文件恢复加密过的应用池和虚拟目录的密码
Get-SiteListPassword                  该模块检索任何已找到的McAfee的SiteList.xml文件的明文密码
Get-CachedGPPPassword                 该模块检查缓存的组策略首选项文件中的密码
Get-UnattendedInstallFile             该模块用于检查以下路径，查找是否存在这些文件，因为这些文件可能含有部署凭据 
    C:\sysprep\sysprep.xml
    C:\sysprep\sysprep.inf
    C:\sysprep.inf
    C:\Windows\Panther\Unattended.xml
    C:\Windows\Panther\Unattend\Unattended.xml
    C:\Windows\Panther\Unattend.xml
    C:\Windows\Panther\Unattend\Unattend.xml
    C:\Windows\System32\Sysprep\unattend.xml
    C:\Windows\System32\Sysprep\Panther\unattend.xml
```

Other Helpers/Meta-Functions(其他一些模块的帮助) 
```
Get-ModifiablePath                 该模块标记输入字符串并返回当前用户可以修改的文件
Get-CurrentUserTokenGroupSid       该模块返回当前用户参与的所有小岛屿发展中国家，无论它们是否已禁用。
Add-ServiceDacl                    该模块将dacl字段添加到get-service返回的服务对象中
Set-ServiceBinPath                 该模块通过Win 32 api方法将服务的二进制路径设置为指定的值。
Test-ServiceDaclPermission         该模块用于检查所有可用的服务，并尝试对这些打开的服务进行修改。如果能修改，则返回该服务对象。使用：Test-ServiceDaclPermission -servicename 服务名
Write-UserAddMSI                   该模块写入一个MSI安装程序，提示要添加一个用户。
Invoke-AllChecks                   该模块会自动执行 PowerUp.ps1 下所有的模块来检查目标主机是否存在服务配置漏洞
```


## 以下是这些模块提权的原理： 

> Get-ServiceUnquoted 模块提权 (该模块利用了Windows的一个逻辑漏洞，即当文件包含空格时，WindowsAPI会解释为两个路径，并将这两个文件同时执行，这个漏洞在有些时候会造成权限的提升)。
> Test-ServiceDaclPermission 模块提权 (该模块会检查所有可用的服务，并尝试对这些打开的服务进行修改，如果可修改，则存在此漏洞)。Windows系统服务文件在操作系统启动时会加载执行，并且在后台调用可执行文件。比如在每次重启系统时，Java升级程序都会检测出Oracle网站是否有新版Java程序。而类似Java程序之类的系统服务程序，在加载时往往都是运行在系统权限上的。所以如果一个低权限的用户对于此类系统服务调用的可执行文件具有可写的权限，那么就可以将其替换成我们的恶意可执行文件，从而随着系统启动服务器获得系统权限。。 