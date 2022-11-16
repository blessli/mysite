+++
author = "soli"
keywords = ["cockymang","mqtt broker","in action","mqttaction"]
title = "linux cmd collection"
date = "2022-11-14"
description = ""
categories = ["unknown"]
tags = ["linux"]
series = ["Themes Guide"]
aliases = ["migrate-from-jekyl"]
image = "https://someblogs.oss-cn-shenzhen.aliyuncs.com/thumb/img1.png"
+++
<!--more-->
centos版本
```sh
cat /etc/redhat-release
```
## alias
解决重启后alias失效问题：
```sh
vim ~/.bashrc
alias cdcode='cd /usr/local/projs'
source ~/.bashrc
```
## 查看项目代码行数
```sh
yum -y install cloc
cloc src
```
## 显示当前文件夹大小
```sh
du -hs
```
## 安装git2.x
```sh
sudo yum install https://packages.endpointdev.com/rhel/7/os/x86_64/endpoint-repo.x86_64.rpm
sudo yum install git
git --version
git config --global user.name "Your Name"
git config --global user.email "email@example.com"
ssh-keygen -t rsa -C "your_email@youremail.com"
cat /root/.ssh/id_rsa.pub
```
## gcc升级到7.13
```sh
sudo yum install centos-release-scl
sudo yum install devtoolset-7-gcc*
ln -sf /opt/rh/devtoolset-7/root/usr/bin/gcc /usr/bin/gcc
ln -sf /opt/rh/devtoolset-7/root/usr/bin/g++ /usr/bin/g++
```
## 安装cmake3
```sh
yum -y install cmake3
sudo ln -s /usr/bin/cmake3 /usr/bin/cmake
cmake --version
```
安装指定版本
```sh
wget https://github.com/Kitware/CMake/releases/download/v3.24.0/cmake-3.24.0-linux-x86_64.tar.gz
tar -zxvf cmake-3.24.0-linux-x86_64.tar.gz
ln -sf /usr/local/cmake-3.24.0-linux-x86_64/bin/cmake /usr/bin/cmake
```
## linux开启swap分区
```sh
dd if=/dev/zero of=/swapfile bs=64M count=64
chmod 0600 /swapfile
mkswap /swapfile
swapon /swapfile
swapon -s
```
https://www.cnblogs.com/Axianba/p/13131620.html
