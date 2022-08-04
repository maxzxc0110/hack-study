# 什么是OPSEC？

Operations Security (OPSEC)，美国军方的一个军事术语，应用于网络安全，根据[NIST](https://csrc.nist.gov/glossary/term/opsec)里的定义是

> Systematic and proven process by which potential adversaries can be denied information about capabilities and intentions by identifying, controlling, and protecting generally unclassified evidence of the planning and execution of sensitive activities. The process involves five steps: identification of critical information, analysis of threats, analysis of vulnerabilities, assessment of risks, and application of appropriate countermeasures(通过识别、控制和保护敏感活动的计划和执行的一般非机密证据，可以拒绝潜在对手有关能力和意图的信息的系统且经过验证的过程。 该过程包括五个步骤：识别关键信息、分析威胁、分析漏洞、评估风险和应用适当的对策)

OPSEC流程有五个步骤

1. Identify critical information（识别关键信息）
2. Analyse threats（分析威胁）
3. Analyse vulnerabilities（分析漏洞）
4. Assess risks（评估风险）
5. Apply appropriate countermeasures（采取适当的对策）

![img](https://tryhackme-images.s3.amazonaws.com/user-uploads/5f04259cf9bf5b57aed2c476/room-content/28ab900adf65a15e576f67fda8db0300.png)

# 威胁分析

威胁分析是指识别潜在的对手及其意图和能力

威胁分析旨在回答以下问题：

1. Who is the adversary is?（对手是谁？）
2. What are the adversary’s goals?（对手的目标是什么？）
3. What tactics, techniques, and procedures does the adversary use?（对手使用什么战术、技术和程序？）
4. What critical information has the adversary obtained, if any?（对手获得了哪些关键信息（如果有的话）？）

![img](https://tryhackme-images.s3.amazonaws.com/user-uploads/5f04259cf9bf5b57aed2c476/room-content/e3f76eadfe8d57c095a2d70d19a7a5c8.png)

我们将任何意图并有能力采取行动阻止我们完成行动的对手视为威胁:
```
threat = adversary + intent + capability
```

# 漏洞分析

在确定关键信息和分析威胁之后，我们可以开始进行第三步：分析漏洞。这**不能**与网络安全相关的漏洞相混淆。当对手可以获得关键信息，分析结果，并以影响你的计划的方式行事时，就存在**OPSEC漏洞**。


理解**OPSEC漏洞**，三个例子：

1. 你使用Nmap来发现目标子网中的实时主机，并找到实时主机上的开放端口。此外，你发送各种钓鱼邮件，引导受害者到你托管的钓鱼网页。此外，你使用Metasploit框架，试图利用某些软件漏洞。这是三个独立的活动；但是，如果你使用相同的IP地址来进行这些不同的活动，这将导致一个OPSEC漏洞。一旦发现任何敌对/恶意活动，蓝队应采取行动，如暂时或永久地阻止源IP地址。换句话说，这将阻止对钓鱼服务器使用的目标IP地址的访问，以及Nmap和Metasploit框架使用的源IP地址。
2. 一个不安全的数据库，它被用来存储从钓鱼网站受害者那里收到的数据。如果数据库没有得到适当的保护，它可能会导致恶意的第三方破坏操作，并可能导致数据被渗出并用于攻击你的客户的网络。结果是，你不是帮助你的客户保护他们的网络，而是最终帮助暴露了登录名和密码。
3. 你的一个红队成员在社交媒体上发帖，透露了你客户的名字。如果蓝队监测到这样的信息，就会引发他们更多地了解你的团队和你的方法，以便更好地准备应对预期的渗透企图

# 风险评估

> 在OPSEC中，风险评估需要了解一个事件发生的可能性以及该事件的预期成本。因此，这涉及评估对手利用漏洞的能力

一旦确定了风险级别，就可以考虑采取对策来减轻该风险。我们需要考虑以下三个因素:

1. The efficiency of the countermeasure in reducing the risk（降低风险对策的效率）
2. The cost of the countermeasure compared to the impact of the vulnerability being exploited.（与被利用漏洞的影响相比，对策的成本）
3. The possibility that the countermeasure can reveal information to the adversary（对策可以向对手透露信息的可能性）

# 对策

> Countermeasures are designed to prevent an adversary from detecting critical information, provide an alternative interpretation of critical information or indicators (deception), or deny the adversary’s collection system.(对策旨在防止对手检测到关键信息，提供对关键信息或指标的替代解释（欺骗），或拒绝对手的收集系统。)

例子：

1. 在第一个示例中，我们考虑了运行 Nmap、使用 Metasploit 框架以及使用相同的公共 IP 地址托管网络钓鱼页面的漏洞。对此的对策似乎很明显；为每个活动使用不同的 IP 地址。这样，您可以确保如果检测到一个活动，公共 IP 地址被阻止，其他活动可以继续不受影响。

2. 在第二个示例中，我们考虑了用于存储从网络钓鱼页面接收到的数据的不安全数据库的漏洞。从风险评估的角度来看，我们认为这是高风险的，因为恶意第三方可能会寻找随机的简单目标。在这种情况下，应对措施是确保数据库得到充分保护，以便只有经过授权的人员才能访问数据


# 练习

![img](https://github.com/maxzxc0110/hack-study/blob/main/img/1659606972423.jpg)

![img](https://github.com/maxzxc0110/hack-study/blob/main/img/1659607278954.jpg)

![img](https://github.com/maxzxc0110/hack-study/blob/main/img/1659607489734.jpg)

![img](https://github.com/maxzxc0110/hack-study/blob/main/img/1659607710913.jpg)
