# 外部侦查

这章主要讲信息收集

侦查分主动侦查和被动侦查

## 主动侦查
各种扫描

## 被动侦查
借助 Google、LinkedIn、Shodan 和社交媒体进行信息收集


# DNS

dig命令
```
dig cyberbotic.io +short
```

whois命令
```
whois 104.21.90.222
```

[Spoofcheck](https://github.com/BishopFox/spoofcheck)(验证给定域的电子邮件安全性)
```
./spoofcheck.py cyberbotic.io
```

[dnscan](https://github.com/rbsec/dnscan)(用于挖掘子域)
```
./dnscan.py -d cyberbotic.io -w subdomains-100.txt
```

# 社交媒体
谷歌黑语法，通过领英收集信息
```
site:"linkedin.com" "<company name>"
```

intitle, 查找标题中包含特定单词的页面。
```
intitle:apple
```

inurl,在 URL 中查找带有特定单词的页面
```
inurl:apple
```

intext,查找内容中某处包含某个（或多个单词）的页面
```
intext:apple
```

filetype,搜索某种类型的文件
```
site:apple.com filetype:pdf
```

```#..#```,搜索一个范围内 数字
```
site:apple.com filetype:pdf 2020..2022
```

```-```，排除
```
site:apple.com -www -support
```
将返回在 apple.com 上编入索引的页面，不包括www 和support 域。用于查找其他子域