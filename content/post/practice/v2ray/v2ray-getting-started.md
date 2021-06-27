# V2Ray 入门

- [新 V2Ray 白话文指南](https://guide.v2fly.org/)

systemctl enable v2ray; systemctl start v2ray

## MacOS

通过 Homebrew (opens new window)包管理器安装：brew install v2ray，随命令一起下载的 geosite.dat 和 geoip.dat 放置在 /usr/local/share/v2ray/ 目录下

vim /usr/local/etc/v2ray/config.json

run v2ray-core without starting at login

```cmd
brew services run v2ray-core
```

run v2ray-core and register it to launch at login via:

```cmd
brew services start v2ray-core
```