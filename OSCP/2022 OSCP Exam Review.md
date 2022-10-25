上周五我参加了OSCP（Offensive Security Certified Professional，进攻性安全认证专家）考试，并于周六提交了考试报告，就在周日晚上大概十二点，我收到了来自offsec的邮件，通知我已经通过了认证。

我最终解决了AD的三台机器+两台独立机器的完全控制权限+另一台机器的初始shell。另外我还做完了课本习题和lab里的超过10台机器的报告，如果所有报告都没有被扣分的话，我最后的成绩应该是90+10分。

我大概花了一年多的时间去准备这个考试，期间有过很多困惑，踩过许多坑，我在学习的过程当中受到过很多人的启发，因此现在我也想写一篇学习回顾，以（希望能够）帮助那些当初和我一样不知道如何入门的学员，如果你是渗透测试的大佬，那么这篇东西只是浪费你的时间，因为它真的很基础。


# 我的背景
我本职工作是一个程序员，此前没有任何渗透测试经历，当时的我知道nmap是扫描器，kali是专门做渗透测试的，但没怎么用过，说是零基础也不为过。因为出于兴趣我想系统学习渗透测试，就在一年多以前我知道了OSCP这个认证，那时候我想以考促学，并且OSCP学费还挺贵的，我觉得这样或许能push自己一把。我没有一开始就报名，我记得当时我注册了offsec的账号，为了了解购买流程我还下了一个订单，但是没有付款。然后过了没多久，新加坡的David就打了一个越洋电话给我，问我是不是有兴趣学习，还说可以给我申请一个很优惠的折扣。我说我对于这个东西完全是零基础，我可能现在还不合适去报名。然后David说没关系，还建议我先到HTB打打靶机学习。应该说这还是挺良心的，不会让一个0基础的人盲目去报名。事实证明，延迟报名的决定非常正确，如果你像我当初一样对渗透是零基础，那建议还是补一下基础知识，我后面会分享到我当初遇到的那些我感觉很好的课程和平台。


# 新版本vs旧版本
众所周知，OSCP在2022年1月初启用了新版本的考试结构。

旧版本的考试结构：
1台简单机器 10分
2台中等机器 20分x2
2台困难机器 25分x2，其中一台为bof题，必出，圈内评价是送分题。

总分达到70分通过考试，完成所有课后练习+10台lab报告可以另外+5分


新版本的考试结构：
AD包含3台机器，总共40分，只有攻入DC才有分，没有过程分，也就是要么40分全拿，要么0分。
3台独立机器，每台20分，bof题不是必出，而且需要提权。
完成所有课后练习+10台lab报告（包含4台域机器）可以另外+10分

总分也是达到70分通过考试。

应该说新版本考试结构难度增加了不少。

# 如何准备？

我在考试之前在各个平台打了一些靶机，我后来统计了一下：

TryHackMe：53
OSCP LAB：75
HTB：60
PG：40
vulnhub：11


## TryHackMe
我认为TryHackMe是很好的专题学习平台，以及是很好的基础学习平台，但是我不推荐打太多里面的靶机，因为他们多数都是CTF形式，与OSCP相去甚远。从技术的角度，一个零基础学员从任何方向出发当然都是进步，但是从考试的角度，我们还是要有的放矢，毕竟时间也是资源。
我完成了TryHackMe里的```Complete Beginner```，```Offensive Pentesting```，```CompTIA Pentest+```三个路径，这三个路径的学习让我对渗透测试有了一个初步的了解。我非常建议初学者跟着这些路径学习。而且TryHackMe非常良心，他的很多房间都是免费的，就算续费每个月也只是需要10美元。这个花费对于你将可以学到的知识来说简直是不值一提。
后面TryHackMe又出了好几个学习路径，我现在还没有去做，在这里不评价，我想我后面有时间会去做一下。


## OSCP LAB
我在今年三月份报的名，报的是两个月的课程。需要注意的是，今年4月以后OSCP只有三个月的课程了，价格是1499美元。
我在第一个月完成了课本上的所有习题以及打了40台靶机，在第二个月我完成了剩下的35台靶机。这两个月可以说是我目前人生最累的两个月，几乎每天下班以后我都要肝到晚上一两点，第二天还要上班。这期间有痛苦，有绝望，有焦虑同时也是收获满满。OSCP之旅绝对是一个折磨之旅，我看到有朋友的评论是"比高考还累"。
OSCP Lab是一个多级的网络，它外网有40台左右的机器，但是我觉得它最有意思的是内网，有些内网你还需要转发多次才能访问。这样的靶机环境一般在其他平台很少遇到，因此会是一个很不错的学习体验。我看到有些早期的学员说内网很卡，我这边觉得还好，可能是offsec后来升级了OSCP LAB的网络。但是我自己为备考也拉了一条300M的网线，以及买了一个美国节点的vps，整个OSCP Lab的旅程中我觉得网络非常舒服。
这里有一个小技巧，我不知道这算不算offsec的一个bug，OSCP Lab其实是有多个节点的，而且同样的vpn可以登录不同的节点，我一般扫描探测和爆破的时候用的是美国的vps（跟lab的延时大概是10ms以内），其他手动的枚举或者拿shell时用的是本地kali机。需要注意，因为lab各个节点是独立的，在美国vps触发的rev shell，在本地kali是接收不到的。但是vps可以省去你很多探测和爆破的时间。

鉴于OSCP现在只有3个月lab time的选择，这是绝对够时间打完OSCP所有lab的。关于什么时候应该去论坛看hint，我的理解是，当你觉得你已经穷尽了你目前所知道的所有方法和技巧还是没有进度，那就去看。我认为不必去忌讳看hint这个东西，你就是来学习的，不懂很正常，基本上你不可能去hack一个你完全不懂的东西。相反的，如果你都觉得OSCP Lab对你一点难度都没有，那么OSCP只是浪费你的时间，你应该去挑战更难的东西。

## HTB
我强烈推荐这个HTB的OSCP vm like list，同时这也是很多OSCP前辈的一致推荐。如果你备考的时间有限，我建议你就好好打一下这个list里面的机器。
![image.png](https://upload-images.jianshu.io/upload_images/9177635-e3bd414d3ba3e22a.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


## PG
这个是offsec的亲儿子，也有很多前辈推荐里面的机器作为OSCP的练习，考试里单机的难度大概相当于里面的中等难度机器。


## vulnhub
vulnhub好像是被offsec收购了，好多机器都在PG里。我打的不多，感觉有些还是偏向CTF。。


## 那么应该打多少台机器才好参加考试呢？
我听说有人打了30多台就通过了OSCP考试，有的大佬打了400多台。。。我的理解是，越多越好，你在练习中踩的坑越多，在考试的时候才会越游刃有余，Practice make prefect。

官方有一个靶机数量与通过率的表格，打过的靶机数量和通过率是正相关的，这也符合人的直觉。

对比各个平台靶机的难度，我主观上的感觉是：HTB > PG > OSCP Lab

我觉得备考打这三个lab就够了

1. HTB的那个OSCP VM LIKE LIST的机器。

2. PG里中等难度机器。

3. OSCP所有lab机器。

如果你实在备考时间有限，那推荐上面的1和3。

# 英语
OSCP的教材和视频都是全英文的，你在备考中看到的所有文章，资料等等99%都会是英文，所以英文是逃不掉的。
我自己也是英语渣，但是好在计算机类的英语词汇固定，语法结构也简单，看多几次也就知道了，实在不懂还可以在线翻译嘛，所以在英语上不必有太大的压力。如果你实在很想学习，你总是会想得到办法的。


# 笔记
从你决定要开始OSCP之旅，无论以前你有没有记录笔记的习惯，从现在都要开始记录。开一个博客，或者自己记录一份文档。
记录一切你遇到的东西，命令，技巧，原理，靶机wp。记完以后尝试去整理他们，反复阅读，这也是一个学习的过程，而且很重要。
这一年来我大概记了十几万字的笔记和wp，我习惯用markdown格式记录，这样我可以用sublime快速查找我想知道的一切记录过的东西。

# 考试
我预定的是周五早上9点钟的考试，前一天晚上我还吃了安眠药睡觉，因为我习惯性焦虑，容易考试前失眠。好在那天我睡的还挺好。
我为考试准备了咖啡，巧克力，红牛，面包和一些饺子，整个考试期间我喝了三杯美式咖啡和一瓶红牛，这的确让我考试的时候异常亢奋，但是第二天我非常痛苦，完全没办法睡觉。
我用了6个小时完成了AD部分的内容，之后3个小时，我拿到了一台主机的完全控制权限。然后我又花了几个小时，拿到了一台单机的foothold，但是后面提权的部分，我在这台机器卡了很久，一直到凌晨一点，我跟监考人员说我太累了需要休息一下。然后我睡了大概一个多小时（其实也没睡着，因为我喝太多咖啡了），在凌晨两点我醒来，我决定先放一下那台机器的提权，再看看另外一台单机，从凌晨2点一直到早上6点，我完全卡死在这台机器的foothold里，然后我跟监考人员说我要休息一下，之后我躺在床上突然想到了一个点，于是马上起来验证，结果成功进入这台机器，此时距离考试结束还有两个多小时，我发现我唯一那次msf的机会还没用，于是我决定上msf，用了10分钟拿到了这台机器的system权限。我用剩下的时间补充了一些截图，然后结束了这个23小时45分钟的考试。

我在OSCP之前学习过CRTP的课程，老实说OSCP的AD部分的内容，无论广度和深度完全都比不上CRTP。但是我在这里不是说你在考OSCP之前要去考个CRTP，完全没有必要，而且我也没有过CRTP考试。。（T_T）。OSCP考试里ad方面的知识全都在教程里，没有任何超纲的东西。但是考试时ad部分难的可能是ad之外的东西。。。

关于考试，我的建议是每隔一两个小时，要起来喝水，走动一下，或者躺一下。就我做程序员的经验，我职业生涯中遇到的所有技术上能说的是难题的东西，要么是我躺在床上想到解决方法，要么是我走在路上想到的解决方法，但是绝对不会是坐在电脑前想到的。一旦卡住了就起来走走，放轻松。OSCP考试除了考验技术以外，我觉得很大一部分也是考验一个人的心理承受能力。因为这种24小时的考试真的是太变态了，如果心态崩了那本来很容易的东西可能会被你miss掉。


# 报告
第二天我陆陆续续花了一天时间写完了报告，多数都是先写中文，然后放到deepl上去翻译的，我没有任何渗透测试工作经历，因此我不太知道一个合格的渗透测试报告应该是怎么样的，好在官方有个报告模板，我就按照那个模板来写。一直忙到当天晚上差不多12点，我提交了我的考试报告和练习报告。


# 资源

以下是我备考过程当中遇到的一些我觉得很好的资源：

[hacktricks](https://book.hacktricks.xyz/welcome/readme):黑客圣经，你在备考中每天都应该会去翻阅它。
[PayloadsAllTheThings](https://github.com/swisskyrepo/PayloadsAllTheThings):各种cheetsheet，和hacktricks有重合的地方，但是更侧重各种命令的记录，我弄rev shell的时候经常翻阅。
[gtfobins](https://gtfobins.github.io/):linux提权宝典。
[bufferoverflowprep](https://tryhackme.com/room/bufferoverflowprep):最好的Buffer Overflow练习，专门为OSCP准备。
[linux提权房间1](https://tryhackme.com/room/linprivesc):tryhackme上的一个提权房间
[linux提权房间2](https://tryhackme.com/room/linuxprivesc):另外一个linux的提权房间，专门为OSCP制作，在[udemy](https://www.udemy.com/course/linux-privilege-escalation/?referralCode=0B0B7AA1E52B4B7F4C06)上有对应的视频课程。
[windows提权房间](https://tryhackme.com/room/windows10privesc):上面提权系列的windows姐妹版，也是专门为OSCP制作,在[udemy](https://www.udemy.com/course/windows-privilege-escalation/?referralCode=9A533B41ECB74227E574)上有对应的视频课程。
[what-to-do-with-new-oscp](https://medium.com/@0xtd/what-to-do-with-new-oscp-c5026eef67e4):老外整理的关于OSCP里AD部分的学习资源集锦。
[hackingarticles](https://www.hackingarticles.in/):三哥整理的一个博客，有很多很好的思路和方法的介绍。
[0xdf](https://0xdf.gitlab.io/):0xdf的博客，HTB官方打lab人员，能学到很多技巧。
[IppSec](https://www.youtube.com/channel/UCa6eh7gCkpPo5XXUDfygQQA):IppSec的youtube频道，也是HTB官方的，同样的也可以学习到很多技巧。

# 最后
我觉得一旦你觉得要准备OSCP的时候，一定要好好跟家里人/女朋友/老婆沟通，跟他们解释为什么你需要那么多时间自己一个人在电脑前鼓捣。我觉得整个备考期间我牺牲了好多跟女友和家里人相处的时间，每每回想总是心中有愧，我要感谢我的女友小头，她一直很理解和支持我去做这一切，接下来我想花多点时间陪伴身边的人。
