# 服务探测

开放端口
```
┌──(root💀kali)-[~/htb/RouterSpace]
└─# nmap -p- --open --min-rate 500 10.10.11.148                                                                                    
Starting Nmap 7.92 ( https://nmap.org ) at 2022-06-22 04:22 EDT
Nmap scan report for 10.10.11.148
Host is up (0.78s latency).
Not shown: 65533 filtered tcp ports (no-response)
Some closed ports may be reported as filtered due to --defeat-rst-ratelimit
PORT   STATE SERVICE
22/tcp open  ssh
80/tcp open  http

Nmap done: 1 IP address (1 host up) scanned in 266.69 seconds

```

详细信息
```
┌──(root💀kali)-[~/htb/RouterSpace]
└─# nmap -sV -Pn -A -O 10.10.11.148 -p 22,80                      
Starting Nmap 7.92 ( https://nmap.org ) at 2022-06-22 04:29 EDT
Nmap scan report for 10.10.11.148
Host is up (0.80s latency).

PORT   STATE SERVICE VERSION
22/tcp open  ssh     (protocol 2.0)
| fingerprint-strings: 
|   NULL: 
|_    SSH-2.0-RouterSpace Packet Filtering V1
| ssh-hostkey: 
|   3072 f4:e4:c8:0a:a6:af:66:93:af:69:5a:a9:bc:75:f9:0c (RSA)
|   256 7f:05:cd:8c:42:7b:a9:4a:b2:e6:35:2c:c4:59:78:02 (ECDSA)
|_  256 2f:d7:a8:8b:be:2d:10:b0:c9:b4:29:52:a8:94:24:78 (ED25519)
80/tcp open  http
| fingerprint-strings: 
|   FourOhFourRequest: 
|     HTTP/1.1 200 OK
|     X-Powered-By: RouterSpace
|     X-Cdn: RouterSpace-7178
|     Content-Type: text/html; charset=utf-8
|     Content-Length: 68
|     ETag: W/"44-V/2nzhvFDx5g1treZgaBnHww1sk"
|     Date: Wed, 22 Jun 2022 08:29:36 GMT
|     Connection: close
|     Suspicious activity detected !!! {RequestID: Twl Z MWr Emd LHg }
|   GetRequest: 
|     HTTP/1.1 200 OK
|     X-Powered-By: RouterSpace
|     X-Cdn: RouterSpace-90812
|     Accept-Ranges: bytes
|     Cache-Control: public, max-age=0
|     Last-Modified: Mon, 22 Nov 2021 11:33:57 GMT
|     ETag: W/"652c-17d476c9285"
|     Content-Type: text/html; charset=UTF-8
|     Content-Length: 25900
|     Date: Wed, 22 Jun 2022 08:29:24 GMT
|     Connection: close
|     <!doctype html>
|     <html class="no-js" lang="zxx">
|     <head>
|     <meta charset="utf-8">
|     <meta http-equiv="x-ua-compatible" content="ie=edge">
|     <title>RouterSpace</title>
|     <meta name="description" content="">
|     <meta name="viewport" content="width=device-width, initial-scale=1">
|     <link rel="stylesheet" href="css/bootstrap.min.css">
|     <link rel="stylesheet" href="css/owl.carousel.min.css">
|     <link rel="stylesheet" href="css/magnific-popup.css">
|     <link rel="stylesheet" href="css/font-awesome.min.css">
|     <link rel="stylesheet" href="css/themify-icons.css">
|   HTTPOptions: 
|     HTTP/1.1 200 OK
|     X-Powered-By: RouterSpace
|     X-Cdn: RouterSpace-63997
|     Allow: GET,HEAD,POST
|     Content-Type: text/html; charset=utf-8
|     Content-Length: 13
|     ETag: W/"d-bMedpZYGrVt1nR4x+qdNZ2GqyRo"
|     Date: Wed, 22 Jun 2022 08:29:27 GMT
|     Connection: close
|     GET,HEAD,POST
|   RTSPRequest, X11Probe: 
|     HTTP/1.1 400 Bad Request
|_    Connection: close
|_http-title: RouterSpace
|_http-trane-info: Problem with XML parsing of /evox/about
2 services unrecognized despite returning data. If you know the service/version, please submit the following fingerprints at https://nmap.org/cgi-bin/submit.cgi?new-service :

```

有一个apk文件
```
http://10.10.11.148/RouterSpace.apk
```


```
┌──(root?rock)-[~/htb/RouterSpace]
└─# apktool d -f RouterSpace.apk -o app
I: Using Apktool 2.6.1-dirty on RouterSpace.apk
I: Loading resource table...
I: Decoding AndroidManifest.xml with resources...
I: Loading resource table from file: /root/.local/share/apktool/framework/1.apk
I: Regular manifest package...
I: Decoding file-resources...
I: Decoding values */* XMLs...
I: Baksmaling classes.dex...
I: Copying assets and libs...
I: Copying unknown files...
I: Copying original files...

```


目录爆破
```
┌──(root㉿rock)-[~]
└─# python3 /root/dirsearch/dirsearch.py -e* -t 100 -u http://10.10.11.148
Missing required dependencies to run.

  _|. _ _  _  _  _ _|_    v0.4.2.6
 (_||| _) (/_(_|| (_| )

Extensions: php, jsp, asp, aspx, do, action, cgi, html, htm, js, json, tar.gz, bak | HTTP method: GET | Threads: 100 | Wordlist size: 15418

Output File: /root/dirsearch/reports/10.10.11.148/_22-06-22_06-20-48.txt

Target: http://10.10.11.148/

[06:20:48] Starting: 
[06:20:48] 301 -  171B  - /js  ->  /js/                                     
[06:21:14] 301 -  173B  - /css  ->  /css/                                   
[06:21:17] 200 -   45KB - /contact.html                                     
[06:21:19] 301 -  177B  - /fonts  ->  /fonts/                               
[06:21:22] 301 -  173B  - /img  ->  /img/                                   
[06:21:24] 200 -   25KB - /index.pHp                                        
[06:21:24] 200 -   25KB - /index.jsp                                        
[06:21:24] 200 -   25KB - /index.aspx                                       
[06:21:24] 200 -   25KB - /index.php                                        
[06:21:25] 200 -   25KB - /index.html                                       
[06:21:43] 400 -    1KB - /servlet/%C0%AE%C0%AE%C0%AF                       
                                                                             
Task Completed

```