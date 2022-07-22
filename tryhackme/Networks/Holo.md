首先根据提供的网络拓扑图先扫描一下网段 

![pic](https://github.com/maxzxc0110/hack-study/blob/main/img/1658482726896.jpg)

```
nmap -sV -sC -p- -v 10.200.112.0/24
...
...
Initiating Service scan at 05:24
Scanning 2 services on 10.200.112.250
Completed Service scan at 05:24, 11.28s elapsed (2 services on 1 host)
NSE: Script scanning 10.200.112.250.
Initiating NSE at 05:24
Completed NSE at 05:24, 2.64s elapsed
Initiating NSE at 05:24
Completed NSE at 05:24, 0.35s elapsed
Initiating NSE at 05:24
Completed NSE at 05:24, 0.00s elapsed
Nmap scan report for 10.200.112.250
Host is up (0.089s latency).
Not shown: 65533 closed tcp ports (reset)
PORT     STATE SERVICE VERSION
22/tcp   open  ssh     OpenSSH 7.6p1 Ubuntu 4ubuntu0.5 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey: 
|   2048 0f:6f:f4:97:a2:f1:7a:6a:9c:44:fe:e0:09:05:dd:c6 (RSA)
|   256 59:bd:f8:47:fc:1e:3a:2f:98:fd:84:5f:11:84:f1:84 (ECDSA)
|_  256 f4:cc:6c:f2:ca:dc:fa:74:68:eb:25:b7:f6:ac:09:de (ED25519)
1337/tcp open  http    Node.js Express framework
|_http-title: Error
| http-methods: 
|_  Supported Methods: GET HEAD POST OPTIONS
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

NSE: Script Post-scanning.
Initiating NSE at 05:24
Completed NSE at 05:24, 0.00s elapsed
Initiating NSE at 05:24
Completed NSE at 05:24, 0.00s elapsed
Initiating NSE at 05:24
Completed NSE at 05:24, 0.00s elapsed
Read data files from: /usr/bin/../share/nmap
Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 256 IP addresses (1 host up) scanned in 183.51 seconds
           Raw packets sent: 67774 (2.970MB) | Rcvd: 65852 (2.637MB)

```

详细端口信息
```
┌──(root㉿rock)-[~]
└─# nmap -sV -Pn -A -O 10.200.112.250 -p 22,1337
Starting Nmap 7.92 ( https://nmap.org ) at 2022-07-22 05:32 EDT
Nmap scan report for 10.200.112.250
Host is up (0.088s latency).

PORT     STATE SERVICE VERSION
22/tcp   open  ssh     OpenSSH 7.6p1 Ubuntu 4ubuntu0.5 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey: 
|   2048 0f:6f:f4:97:a2:f1:7a:6a:9c:44:fe:e0:09:05:dd:c6 (RSA)
|   256 59:bd:f8:47:fc:1e:3a:2f:98:fd:84:5f:11:84:f1:84 (ECDSA)
|_  256 f4:cc:6c:f2:ca:dc:fa:74:68:eb:25:b7:f6:ac:09:de (ED25519)
1337/tcp open  http    Node.js Express framework
|_http-title: Error
Warning: OSScan results may be unreliable because we could not find at least 1 open and 1 closed port
Aggressive OS guesses: Linux 4.15 - 5.6 (95%), Linux 5.3 - 5.4 (95%), Linux 2.6.32 (95%), Linux 5.0 - 5.3 (95%), Linux 3.1 (95%), Linux 3.2 (95%), AXIS 210A or 211 Network Camera (Linux 2.6.17) (94%), ASUS RT-N56U WAP (Linux 3.4) (93%), Linux 3.16 (93%), Linux 5.0 (93%)
No exact OS matches for host (test conditions non-ideal).
Network Distance: 1 hop
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

TRACEROUTE (using port 22/tcp)
HOP RTT      ADDRESS
1   88.83 ms 10.200.112.250

OS and Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 18.69 seconds

```