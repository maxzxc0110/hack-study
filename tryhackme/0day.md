# 服务扫描
```
┌──(root💀kali)-[~/tryhackme/0day]
└─# nmap -sV -Pn 10.10.195.33 -p-
Host discovery disabled (-Pn). All addresses will be marked 'up' and scan times will be slower.
Starting Nmap 7.91 ( https://nmap.org ) at 2021-10-20 06:03 EDT
PORT   STATE SERVICE VERSION
22/tcp open  ssh     OpenSSH 6.6.1p1 Ubuntu 2ubuntu2.13 (Ubuntu Linux; protocol 2.0)
80/tcp open  http    Apache httpd 2.4.7 ((Ubuntu))
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel


```

ssh-keyscan -t rsa 10.10.195.33  -p 22

nmap -p22 10.10.195.33 --script ssh2-enum-algos 
nmap -p22 10.10.195.33  --script ssh-hostkey --script-args ssh_hostkey=full
nmap -p22 10.10.195.33 --script ssh-auth-methods --script-args="ssh.user=root"  

ssh -v root@10.10.195.33 id