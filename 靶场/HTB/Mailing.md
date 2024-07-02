
# 服务

```
┌──(root㉿kali)-[~]
└─# nmap -Pn -p- 10.10.11.14  
Starting Nmap 7.93 ( https://nmap.org ) at 2024-07-02 06:06 EDT
Stats: 0:00:29 elapsed; 0 hosts completed (1 up), 1 undergoing SYN Stealth Scan
SYN Stealth Scan Timing: About 1.34% done; ETC: 06:42 (0:35:37 remaining)
Stats: 0:03:21 elapsed; 0 hosts completed (1 up), 1 undergoing SYN Stealth Scan
SYN Stealth Scan Timing: About 21.94% done; ETC: 06:22 (0:11:55 remaining)
Stats: 0:05:20 elapsed; 0 hosts completed (1 up), 1 undergoing SYN Stealth Scan
SYN Stealth Scan Timing: About 40.99% done; ETC: 06:19 (0:07:41 remaining)
Stats: 0:05:55 elapsed; 0 hosts completed (1 up), 1 undergoing SYN Stealth Scan
SYN Stealth Scan Timing: About 43.33% done; ETC: 06:20 (0:07:44 remaining)
Nmap scan report for 10.10.11.14
Host is up (0.31s latency).
Not shown: 65515 filtered tcp ports (no-response)
PORT      STATE SERVICE
25/tcp    open  smtp                                                                                                
80/tcp    open  http                                                                                                
110/tcp   open  pop3                                                                                                
135/tcp   open  msrpc                                                                                               
139/tcp   open  netbios-ssn                                                                                         
143/tcp   open  imap                                                                                                
445/tcp   open  microsoft-ds                                                                                        
465/tcp   open  smtps                                                                                               
587/tcp   open  submission                                                                                          
993/tcp   open  imaps                                                                                               
5040/tcp  open  unknown                                                                                             
5985/tcp  open  wsman                                                                                               
7680/tcp  open  pando-pub                                                                                           
47001/tcp open  winrm                                                                                               
49664/tcp open  unknown                                                                                             
49665/tcp open  unknown                                                                                             
49666/tcp open  unknown                                                                                             
49667/tcp open  unknown                                                                                             
49668/tcp open  unknown                                                                                             
64869/tcp open  unknown                                                                                             
                                                                                                                    
Nmap done: 1 IP address (1 host up) scanned in 852.80 seconds  
```


写域名
```
echo "10.10.11.14 mailing.htb" >> /etc/hosts
```

查看首页源代码，发现一个文件包含

![](Mailing_files/1.jpg)


```
<a href="download.php?file=instructions.pdf" class="download-button">Download Instructions</a>
```

Thunderbird 115.8.1

CVE-2024-1936