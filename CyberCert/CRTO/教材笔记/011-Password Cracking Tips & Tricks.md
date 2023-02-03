# Password Cracking Tips & Tricks

windows常见哈希： NTLM, NetNTLM, SHA ,Kerberos tickets

可以pth的哈希：NTLM

推荐工具(kali自带)：[hashcat](https://hashcat.net/hashcat/),[John the Ripper](https://www.openwall.com/john/)

# Wordlists

推荐字典：rockyou和[SecLists](https://github.com/danielmiessler/SecLists/tree/master/Passwords)


hashcat例子:
```
D:\Tools\hashcat-6.1.1>hashcat.exe -a 0 -m 1000 C:\Temp\ntlm.txt D:\Tools\rockyou.txt
hashcat (v6.1.1) starting...

58a478135a93ac3bf058a5ea0e8fdb71:Password123
```

参数解释：
```
-a 0 specifies the wordlist attack mode.
-m 1000 specifies that the hash is NTLM.
C:\Temp\ntlm.txt is a text file containing the NTLM hash to crack.
D:\Tools\rockyou.txt is the wordlist.
```

查找字典里符合指定模式的密码串
```
PS C:\> Select-String -Pattern "^Password123$" -Path D:\Tools\rockyou.txt -CaseSensitive

D:\Tools\rockyou.txt:33523:Password123
```

# Wordlist + Rules

```-r```参数是指定密码规则

```
D:\Tools\hashcat-6.1.1>hashcat.exe -a 0 -m 1000 C:\Temp\ntlm.txt D:\Tools\rockyou.txt -r rules\add-year.rule
hashcat (v6.1.1) starting...

acbfc03df96e93cf7294a01a6abbda33:Summer2020
```

```
PS C:\> cat D:\Tools\hashcat-6.1.1\rules\add-year.rule
$2$0$2$0
```


rockyou没有Summer2020这个密码，但是有Summer作为base的密码
```
PS C:\> Select-String -Pattern "^Summer2020$" -Path D:\Tools\rockyou.txt -CaseSensitive
PS C:\> Select-String -Pattern "^Summer$" -Path D:\Tools\rockyou.txt -CaseSensitive

D:\Tools\rockyou.txt:16573:Summer
```

# Masks(掩码)


```
D:\Tools\hashcat-6.1.1>hashcat.exe -a 3 -m 1000 C:\Temp\ntlm.txt ?u?l?l?l?l?l?l?l?d
hashcat (v6.1.1) starting...

64f12cddaa88057e06a81b54e73b949b:Password1
```

参数解释
```
-a 3 specifies the mask attack.
?u?l?l?l?l?l?l?l?d is the mask.
```


```hashcat --help```显示所有掩码字符集
```
? | Charset
===+=========
l | abcdefghijklmnopqrstuvwxyz       #小写字母
u | ABCDEFGHIJKLMNOPQRSTUVWXYZ       #大写字母
d | 0123456789                       #0-9
h | 0123456789abcdef                 #0-9a-z
H | 0123456789ABCDEF                 #0-9A-Z
s | !"#$%&'()*+,-./:;<=>?@[\]^_`{|}~ #特殊字符
a | ?l?u?d?s                         #所有字符集
b | 0x00 - 0xff					     #16进制
``` 


组合各种字符集作为字典格式
```
D:\Tools\hashcat-6.1.1>hashcat.exe -a 3 -m 1000 C:\Temp\ntlm.txt -1 ?d?s ?u?l?l?l?l?l?l?l?1
hashcat (v6.1.1) starting...

fbdcd5041c96ddbd82224270b57f11fc:Password!
```

参数解释
```
-1 ?d?s defines a custom charset (digits and specials).
?u?l?l?l?l?l?l?l?1 is the mask, where ?1 is the custom charset.
```

# Mask Length & Mask Files

掩码长度和掩码文件

指定掩码长度
```
PS C:\> cat D:\Tools\example.hcmask
?d?s,?u?l?l?l?l?1
?d?s,?u?l?l?l?l?l?1
?d?s,?u?l?l?l?l?l?l?1
?d?s,?u?l?l?l?l?l?l?l?1
?d?s,?u?l?l?l?l?l?l?l?l?1
```

以```ZeroPointSecurity```为前缀的密码
```
PS C:\> cat D:\Tools\example2.hcmask
ZeroPointSecurity?d
ZeroPointSecurity?d?d
ZeroPointSecurity?d?d?d
ZeroPointSecurity?d?d?d?d
```

破解
```
D:\Tools\hashcat-6.1.1>hashcat.exe -a 3 -m 1000 C:\Temp\ntlm.txt D:\Tools\example2.hcmask
hashcat (v6.1.1) starting...

f63ebb17e157149b6dfde5d0cc32803c:ZeroPointSecurity1234
```

# Combinator

两个字典的组合
```
PS C:\> cat D:\Tools\list1.txt
purple

PS C:\> cat D:\Tools\list2.txt
monkey
dishwasher
```

组合list1和list2
```
D:\Tools\hashcat-6.1.1>hashcat.exe -a 1 -m 1000 C:\Temp\ntlm.txt D:\Tools\list1.txt D:\Tools\list2.txt -j $- -k $!
hashcat (v6.1.1) starting...

ef81b5ffcbb0d030874022e8fb7e4229:purple-monkey!
```

# Hybrid

hashcat的模式6和模式7是混合模式

使用模式6，指定密码列表，后面加4位数字掩码
```
D:\Tools\hashcat-6.1.1>hashcat.exe -a 6 -m 1000 C:\Temp\ntlm.txt D:\Tools\list.txt ?d?d?d?d
hashcat (v6.1.1) starting...

be4c5fb0b163f3cc57bd390cdc495bb9:Password5555
```

参数解释：
```
-a 6 specifies the hybrid wordlist + mask mode.
?d?d?d?d is the mask.
```

使用模式7，指定4位数字掩码+密码列表
```
D:\Tools\hashcat-6.1.1>hashcat.exe -a 7 -m 1000 C:\Temp\ntlm.txt ?d?d?d?d D:\Tools\list.txt
hashcat (v6.1.1) starting...

28a3b8f54a6661f15007fca23beccc9c:5555Password
```

# kwprocessor
[kwprocessor](https://github.com/hashcat/kwprocessor),基于某种人类习惯规则，比如键盘相邻建生成的密码

例如```qwerty```、```1q2w3e4r```,```6yHnMjU7```


kwprocessor 具有三个主要组件：

基本字符 - 目标语言的字母表。
Keymaps - 键盘布局。
路线 - 键盘字符的方向。


例子：
```
D:\Tools\kwprocessor>kwp64.exe basechars\custom.base keymaps\uk.keymap routes\2-to-10-max-3-direction-changes.route -o D:\Tools\keywalk.txt

PS C:\> Select-String -Pattern "^qwerty$" -Path D:\Tools\keywalk.txt -CaseSensitive

D:\Tools\keywalk.txt:759:qwerty
D:\Tools\keywalk.txt:926:qwerty
D:\Tools\keywalk.txt:931:qwerty
D:\Tools\keywalk.txt:943:qwerty
D:\Tools\keywalk.txt:946:qwerty
```