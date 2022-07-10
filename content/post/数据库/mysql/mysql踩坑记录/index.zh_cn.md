+++
author = "soli"
title = "mysql踩坑记录"
date = "2022-06-18"
description = "mysql踩坑记录"
categories = [
"database"
]
tags = [
"mysql"
]
series = ["Themes Guide"]
aliases = ["migrate-from-jekyl"]
image = "img.png"
+++
<!--more-->
## 防SQL注入
> 禁止使用拼接SQL方式

- PreparedStatement
- 正则表达式
- 字符串过滤