+++
author = "soli"
keywords = ["cockymang","mqtt broker","in action","mqttaction"]
title = "nginx source code learning"
date = "2022-11-22"
description = "带着些许问题去源码中找答案"
categories = ["nginx"]
tags = ["nginx","sourcecode"]
series = ["Themes Guide"]
image = "https://someblogs.oss-cn-shenzhen.aliyuncs.com/thumb/img1.png"
+++
<!--more-->
## 问题探索
### 事件处理
## 其他
### vscode本地调试
{{< highlight json "linenos=table" >}}
{
    "version": "0.2.0",
    "configurations": [
        {
            "name": "debug nginx",
            "type": "cppdbg",
            "request": "launch",
            "program": "${workspaceFolder}/objs/nginx",
            "stopAtEntry": false,
            "cwd": "${workspaceFolder}",
            "environment": [],
            "externalConsole": false
        }
    ]
}
{{< / highlight >}}
### mkcert创建自签名SSL证书
{{< highlight sh "linenos=table" >}}
mkcert -install # 将 mkcert 的认证机构安装到服务器上
mkcert -CAROOT # 查看 CA 证书的位置，在PC上安装 rootCA.crt 证书
mkcert www.aaa.com aiPlatform.dev localhost 127.0.0.1 ::1 43.139.87.74 # 生成证书
{{< / highlight >}}