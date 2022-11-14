+++
author = "soli"
keywords = ["cockymang","mqtt broker","in action","mqttaction"]
title = "go source code learning"
date = "2022-11-14"
description = ""
categories = ["language"]
tags = ["sourcecode"]
series = ["Themes Guide"]
aliases = ["migrate-from-jekyl"]
image = "https://someblogs.oss-cn-shenzhen.aliyuncs.com/thumb/img1.png"
+++
<!--more-->
## 编译
编译脚本(all.bash/make.bash)中注释掉，跳过编译test，否则太慢
```sh
mkdir -p ~/mygo/bin
cd ~/mygo/bin
ln -sf /usr/local/projs/go/bin/go mygo
mygo version
mygo run helloworld.go
```