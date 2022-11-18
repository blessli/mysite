+++
author = "soli"
keywords = ["cockymang","mqtt broker","in action","mqttaction"]
title = "linux cmd collection"
date = "2022-11-14"
description = ""
categories = ["unknown"]
tags = ["linux"]
series = ["Themes Guide"]
image = "https://someblogs.oss-cn-shenzhen.aliyuncs.com/thumb/img7.png"
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
## 安装mysql-8.0.24
cmake命令
```sh
mkdir build && cd build
cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local/mysql -DMYSQL_DATADIR=/usr/local/mysql/data -DCMAKE_C_COMPILER=/usr/bin/gcc -DCMAKE_CXX_COMPILER=/usr/bin/g++ -DSYSCONFDIR=/etc -DWITH_BOOST=/usr/local/boost -DDEFAULT_CHARSET=utf8 -DDEFAULT_COLLATION=utf8_general_ci -DENABLED_LOCAL_INFILE=ON -DWITH_INNODB_MEMCACHED=ON -DWITH_INNOBASE_STORAGE_ENGINE=1 -DWITH_FEDERATED_STORAGE_ENGINE=1 -DWITH_BLACKHOLE_STORAGE_ENGINE=1 -DWITH_ARCHIVE_STORAGE_ENGINE=1 -DWITHOUT_EXAMPLE_STORAGE_ENGINE=1 -DWITH_PERFSCHEMA_STORAGE_ENGINE=1 -DFORCE_INSOURCE_BUILD=1 -DMYSQL_TCP_PORT=3306
```
编译，安装，初始化，启动：
```sh
groupadd mysql
useradd -r -g mysql -s /bin/false mysql
make&&make install
chown -R mysql:mysql /usr/local/mysql/
/usr/local/mysql/bin/mysqld --initialize --user=mysql --basedir=/usr/local/mysql --datadir=/usr/local/mysql/data
/usr/local/mysql/bin/mysqld_safe --defaults-file=/usr/local/mysql/etc/my.cnf
```
