整理于[这个PowerShell 在线教程](https://www.pstips.net/powershell-online-tutorials)

# 1.Powershell交互式

## 1.1Powershell 执行外部命令
启动CMD控制台
打开
```cmd ```

退出
```exit ```

查找可用的Cmd控制台命令
```cmd /c help```

启动外部程序
命令前面加```&```

例子：
以下命令会当成字符串，不可以执行
```"ls"```

可以执行
```&"ls"```



## Powershell 命令集 cmdlets

> cmdlets是Powershell的内部命令，cmdlet的类型名为System.Management.Automation.CmdletInfo，如：

```
Name	             MemberType	             Definition
Equals	             Method	                 bool Equals(System.Object obj)
GetHashCode	         Method	                 int GetHashCode()
```

>下面是全部的Cmdlets命令,每个命令有一个动词和名词组成，命令的作用一目了然。

```
Name	                          ModuleName	
Add-Computer	Microsoft.PowerShell.Management	
Add-Content	Microsoft.PowerShell.Management
```



## Powershell 别名

为什么要有别名？
> cmdlet 的名称由一个动词和一个名词组成，其功能对用户来讲一目了然。但是对于一个经常使用powershell命令的人每天敲那么多命令也很麻烦啊。能不能把命令缩短一点呢？于是“别名”就应运而生了。Powershell内部也实现了很多常用命令的别名。例如Get-ChildItem，列出当前的子文件或目录。它有两个别名：ls 和 dir，这两个别名来源于unix 的shell和windows的cmd。
因此别名有两个作用：

> 继承：继承unix-shell和windows-cmd。
> 方便：方便用户使用。



查询别名所指的真实cmdlet命令

``` Get-Alias -name ls```

查看可用的别名

```  ls alias```或者```Get-Alias ```

创建自己的别名
给记事本创建一个别名
```Set-Alias -Name Edit -Value notepad ```

查看该别名
```Edit ```

删除自己的别名

```del alias:Edit```

## Powershell 执行文件和脚本

> Powershell运行文件和脚本，也必须使用绝对路径或者相对路径，或者要运行的文件必须定义在可受信任的环境变量中

> Powershell拥有自己的脚本，扩展名为“.ps1”

> powershell的默认安全设置禁用了执行脚本，要启用这个功能需要拥有管理员的权限

### Powershell调用入口的优先级
> 别名：控制台首先会寻找输入是否为一个别名，如果是，执行别名所指的命令。因此我们可以通过别名覆盖任意powershell命令，因为别名的优先级最高。

> 函数：如果没有找到别名，会继续寻找函数，函数类似别名，只不过它包含了更多的powershell命令。因此可以自定义函数扩充cmdlet 把常用的参数给固化进去。

> 命令：如果没有找到函数，控制台会继续寻找命令，即cmdlet，powershell的内部命令。

> 脚本：没有找到命令，继续寻找扩展名为“.ps1”的Powershell脚本。

> 文件：没有找到脚本，会继续寻找文件，如果没有可用的文件，控制台会抛出异常。


# 2.Powershell变量
``` ```

## 定义变量
变量的前缀为$
powershell变量名大小写不敏感（$a和$A 是同一个变量)


## Powershell自动化变量


>Powershell 自动化变量 是那些一旦打开Powershell就会自动加载的变量。
>这些变量一般存放的内容包括

>用户信息：例如用户的根目录$home
>配置信息:例如powershell控制台的大小，颜色，背景等。
>运行时信息：例如一个函数由谁调用，一个脚本运行的目录等。

## Powershell环境变量

通过$env访问环境变量
```
PS> $env:windir
C:\Windows
PS> $env:ProgramFiles
C:\Program Files
```

## Powershell变量的作用域

> Powershell所有的变量都有一个决定变量是否可用的作用域。Powershell支持四个作用域：全局、当前、私有和脚本。有了这些作用域就可以限制变量的可见性了，尤其是在函数和脚本中


### 设置单个变量的作用域
到目前为止，看到的变量作用域的改变都是全局的，能不能针对某个具体变量的作用域做一些个性化的设置。

$global
全局变量，在所有的作用域中有效，如果你在脚本或者函数中设置了全局变量，即使脚本和函数都运行结束，这个变量也任然有效。

$script
脚本变量，只会在脚本内部有效，包括脚本中的函数，一旦脚本运行结束，这个变量就会被回收。

$private
私有变量，只会在当前作用域有效，不能贯穿到其他作用域。

$local
默认变量，可以省略修饰符，在当前作用域有效，其它作用域只对它有只读权限。

打开Powershell控制台后，Powershell会自动生成一个新的全局作用域。如果增加了函数和脚本，或者特殊的定义，才会生成其它作用域。在当前控制台，只存在一个作用域，通过修饰符访问，其实访问的是同一个变量：

```
PS> $logo="www.pstips.net"
PS> $logo
www.pstips.net
PS> $private:logo
www.pstips.net
PS> $script:logo
www.pstips.net
PS> $private:logo
www.pstips.net
PS> $global:logo
www.pstips.net
```



































# 3.Powershell数组和哈希表

# 4.Powershell管道

# 5.Powershell使用对象

# 6.Powershell条件判断

# 7.Powershell循环

# 8.Powershell函数

# 9.Powershell脚本

# 10.Powershell命令发现和脚本块

# 11.PowerShell文件系统

# 12.PowerShell注册表