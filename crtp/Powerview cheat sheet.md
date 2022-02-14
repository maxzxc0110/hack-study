模块：
```
Get-NetDomain               #查看域名称
Get-NetDomainController     #获取域控的信息
Get-NetForest               #查看域内详细的信息
Get-Netuser                 #获取域内所有用户的详细信息
Get-NetUser | select name   #获得域内所有用户名
Get-NetGroup        #获取域内所有组信息
Get-NetGroup | select name  #获取域内所有的组名
Get-NetGroup *admin* | select name   #获得域内组中带有admin的
Get-NetGroup "Domain Admins"         #查看组"Domain Admins"组的信息
Get-NetGroup -UserName test   #获得域内组中用户test的信息
 
Get-UserEvent        #获取指定用户日志信息
Get-NetComputer             #获取域内所有机器的详细信息
Get-NetComputer | select name   #获得域内主机的名字
Get-Netshare                #获取本机的网络共享
Get-NetProcess              #获取本机进程的详细信息
Get-NetOU                #获取域内OU信息
Get-NetFileServer      #根据SPN获取当前域使用的文件服务器
Get-NetSession         #获取在指定服务器存在的Session信息
Get-NetRDPSESSION           #获取本机的RDP连接session信息
Get-NetGPO           #获取域内所有组策略对象
Get-ADOBJECT                #获取活动目录的信息
Get-DomainPolicy       #获取域默认策略
 
Invoke-UserHunter           #查询指定用户登录过的机器
Invoke-EnumerateLocalAdmin  #枚举出本地的管理员信息
Invoke-ProcessHunter        #判断当前机器哪些进程有管理员权限
Invoke-UserEventHunter    #根据用户日志获取某域用户登陆过哪些域机器
```