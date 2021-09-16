#!/bin/bash
# 1. hugo 生成静态文件
# 2. 复制 web-wyyl1 目录下的 .git、.gitignore 到临时目录
# 3. 删除 web-wyyl1 目录
# 4. 将 Hugo 生成的静态内容拷贝到 web-wyyl1 目录
# 5. 将临时目录中的 .git、.gitignore 拷贝到 web-wyyl1 目录
# 6. 删除临时目录
# 7. 提交新代码到码云

_WWW_WYYL1_DIR="/Users/aoe/github/wyyl1/wyyl1.github.io/www.wyyl1.com"
rm -rf $_WWW_WYYL1_DIR
cd /Users/aoe/github/wyyl1/wyyl1.github.io/
hugo --config config.toml,config-wyyl1.com.toml --minify

_WYYL1_DIR="/Users/aoe/gitee/wyyl1"
cd $_WYYL1_DIR
# 临时存储目录
_TEMP_DIR="$_WYYL1_DIR/temp-save"

if  [ -d  "$_TEMP_DIR"  ]; then
    rm -rf $_TEMP_DIR
fi

mkdir $_TEMP_DIR

_WEB_WYYL1_DIR="$_WYYL1_DIR/web-wyyl1"
cd $_WEB_WYYL1_DIR
cp -r .git $_TEMP_DIR
cp .gitignore $_TEMP_DIR

cd $_WYYL1_DIR
rm -rf $_WEB_WYYL1_DIR
cp -r $_WWW_WYYL1_DIR $_WEB_WYYL1_DIR
cp $_TEMP_DIR/.gitignore $_WEB_WYYL1_DIR
cp -r $_TEMP_DIR/.git $_WEB_WYYL1_DIR

rm -rf $_TEMP_DIR

cd $_WEB_WYYL1_DIR
sudo git add .
_time=$(date "+%Y%m%d-%H:%M:%S")
sudo git commit -m "auto commit $_time"
sudo git push -u origin master


echo "完成 $_time"