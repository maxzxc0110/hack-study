# Host Privilege Escalation

主机特权提升

主机提权提升对于横向来说不是必须的。

提权的好处是可以使用 Mimikatz 转储凭据，操作主机持久性，以及修改防火墙等配置

提权的坏处是，可能会暴露你自己。

最小权限原则：
特权提升的前提是，可以实现特定的目标，但是会增加暴露自己（被检测到）的风险，是否提权需要权衡。

工具：
[SharpUp](https://github.com/GhostPack/SharpUp)

C#版本的 PowerUp