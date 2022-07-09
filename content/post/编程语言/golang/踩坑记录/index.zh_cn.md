+++
author = "soli"
title = "golang踩坑记录"
date = "2022-07-06"
description = "go开发踩坑记录"
categories = [
"language"
]
tags = [
"golang"
]
series = ["Themes Guide"]
aliases = ["migrate-from-jekyl"]
image = "cover.png"
+++
<!--more-->
## 【踩坑一】函数编写
```go
package main

import "fmt"

func func1() error {
	return nil
}
// 推荐这样写，考虑因素：函数入参、返回值、函数局部变量初始化
func correctShow(ids ...int64) (err error) {
	keys := make([]string, 0, len(ids))
	for _, id := range ids {
		keys = append(keys, fmt.Sprintf("data_%d", id))
	}
	if err = func1(); err != nil {
		return
	}
	return
}
// 不推荐这样写
func errorShow(ids []int64) error {
	var keys []string
	for _, id := range ids {
		keys = append(keys, fmt.Sprintf("data_%d", id))
	}
	if err := func1(); err != nil {
		return err
	}
	return nil
}
```
## 【vendor】踩坑二
