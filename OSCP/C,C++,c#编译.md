# linux

普通编译
```
gcc exp.c -o exp
```

64位kali编译32位程序
```
gcc exp.c -o exp -m32
```

对于很老的linux机器，编译的时候需要加上参数 ```-Wl,--hash-style=both -m32```
```
gcc -Wl,--hash-style=both -o 9542 9542.c -m32
```

kali上编译c#
```
sudo apt install mono-devel

mcs Wrapper.cs
```



# windows

```
i686-w64-mingw32-gcc exp.c -o exp.exe [-lws2_32]

i686-w64-mingw32-g++ exp.cpp -o exp.exe [-lws2_32]


x86_64-w64-mingw32-gcc -o main64.exe main.c

x86_64-w64-mingw32-g++ -o main32.exe main.c
```