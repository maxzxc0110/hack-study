# 枚举

## 主机名
>hostname

## 系统信息
>uname -a

## 内核版本和其他数据信息
>cat /proc/version

## 系统和版本
>cat /etc/issue

## PS命令
查看 Linux 系统上正在运行的进程
>ps


* PID：进程ID（进程唯一）
* TTY：用户使用的终端类型
* TIME：进程使用的 CPU 时间量（这不是该进程运行的时间）
* CMD：正在运行的命令或可执行文件（不会显示任何命令行参数）


>ps -A: 查看所有正在运行的进程

>ps axjf：查看进程树（查看树的形成直到ps axjf下面运行）


>ps aux：aux 选项将显示所有用户的进程 (a)，显示启动进程的用户 (u)，并显示未连接到终端的进程 (x)。查看 ps aux 命令输出，我们可以更好地了解系统和潜在漏洞。

## env命令

显示所有环境变量
尤其关注```$PATH```，可用户权限提升

## sudo -l
列出所有可以用root（或者其他用户）身份执行的命令

## ls
显示所有文件（包括隐藏文件）的详细信息
>ls -alh

## id
显示用户级别和组成员身份

注意：```id + 用户名```可以显示该用户的用户级别和组成员身份

## /etc/passwd
用于发现linux上的系统用户

## history
浏览用户之前使用过的bash历史命令，有可能会暴露用户密码等敏感信息

## ifconfig
查看网络接口和网络配置等信息
也可以使用```ip route```查看网络路由等信息

## netstat
显示所有连接信息

* netstat -a: 显示所有侦听端口和已建立的连接。
* netstat -at或者 netstat -au也可以分别用于列出TCP或 UDP 协议。
* netstat -l: 以“侦听”模式列出端口。这些端口已打开并准备好接受传入连接。
* netstat -s: 按协议列出网络使用统计信息（如下） 这也可以与-t 或-u 选项一起使用以将输出限制为特定协议。
* netstat -tp: 列出带有服务名称和 PID 信息的连接。
* netstat -i：显示接口统计信息
* netstat 您可能在博客文章、文章和课程中最常看到 的用法netstat -ano 可以细分如下：

-a: 显示所有插座
-n: 不解析名称
-o: 显示计时器

## find命令

* find . -name flag1.txt: 在当前目录中找到名为“flag1.txt”的文件
* find /home -name flag1.txt: 在/home目录下找到文件名“flag1.txt”
* find / -type d -name config: 在“/”下找到名为config的目录
* find / -type f -perm 0777: 查找具有 777 权限的文件（所有用户可读、可写和可执行的文件）
* find / -perm a=x: 查找可执行文件
* find /home -user frank: 在“/home”下找到用户“frank”的所有文件
* find / -mtime 10: 查找最近 10 天内修改过的文件
* find / -atime 10: 查找过去 10 天内访问过的文件
* find / -cmin -60：查找在过去一小时（60 分钟）内更改的文件
* find / -amin -60: 查找最近一小时（60 分钟）内的文件访问
* find / -size 50M: 查找大小为 50 MB 的文件 （此命令还可以与 (+) 和 (-) 符号一起使用，以指定大于或小于给定大小的文件。）

>“find”命令往往会产生错误，这有时会使输出难以阅读。这就是为什么明智的做法是使用带有“-type f 2>/dev/null”的“find”命令将错误重定向到“/dev/null”并获得更清晰的输出

### 查找可写文件夹
* find / -writable -type d 2>/dev/null : Find world-writeable folders
* find / -perm -222 -type d 2>/dev/null: Find world-writeable folders
* find / -perm -o w -type d 2>/dev/null: Find world-writeable folders

### 查找可执行文件夹
* find / -perm -o x -type d 2>/dev/null : Find world-executable folders


### 查找所有SUID
* find / -perm -u=s -type f 2>/dev/null

## 其他命令
>locate, grep, cut, sort

# 自动化linux提权枚举脚本

* LinPeas: https://github.com/carlospolop/privilege-escalation-awesome-scripts-suite/tree/master/linPEAS
* LinEnum: https://github.com/rebootuser/LinEnum
* LES (Linux Exploit Suggester): https://github.com/mzet-/linux-exploit-suggester
* Linux Smart Enumeration: https://github.com/diego-treitos/linux-smart-enumeration
* Linux Priv Checker: https://github.com/linted/linuxprivchecker

# 内核漏洞利用

## 内核漏洞利用方法
> 1. 识别内核版本
> 2. 搜索并找到目标系统内核版本的漏洞利用代码
> 3 .运行漏洞利用

## 如何寻找漏洞
> 1. 谷歌搜索漏洞利用代码
> 2. https://tryhackme.com/room/linprivesc
> 3. 漏洞枚举脚本（上面的LES）

## 要注意什么？
> 1. 在谷歌、Exploit-db 或 searchsploit 搜索漏洞时要确认系统内核版本。
> 2. 可能会对系统造成破坏，真实环境需要注意。
> 3. 漏洞利用进行的时候有可能需要进一步的交互，阅读随漏洞利用代码提供的所有注释和说明。
> 4. 利用python和wget把exp传输到目标系统。

## 风险
内核漏洞提权可能会引起系统崩溃或者其他不可修复的破坏，因此在现实环境中要注意这一点，应该作为最后的提权手段。

# Sudo
列出所有以root身份运行的命令
> sudo -l

## 资源
[gtfobins](https://gtfobins.github.io/)

# SUID

列出设置了 SUID 或 SGID 位的文件
> find / -type f -perm -04000 -ls 2>/dev/null


# Capabilities(能力)

列出已启用的功能
> getcap -r / 2>/dev/null

根据显示的功能到[gtfobins](https://gtfobins.github.io/)查找对应的```Capabilities```的提权方法
