+++
author = "soli"
keywords = ["cockymang","mqtt broker","in action","mqttaction"]
title = "Centos工作笔记"
date = "2022-11-14"
description = ""
categories = ["linux"]
tags = ["linux"]
series = ["Themes Guide"]
image = "https://someblogs.oss-cn-shenzhen.aliyuncs.com/thumb/img7.png"
+++
<!--more-->
## centos版本
centos7
```sh
cat /etc/redhat-release
```
## alias
解决重启后alias失效问题。尽量放在home目录下
```sh
vim ~/.bashrc
alias cdhub='cd /home/github'
alias cdclash='cd /home/clash'
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
## 统计80端口连接数
```sh
netstat -nat | grep -i "80" | wc -l
netstat -nat | grep -i "18000" | awk '/^tcp/ {++S[$NF]} END {for(a in S) print a, S[a]}' # 查看TCP连接状态
```
## linux生成32位随机串
```sh
cat /dev/urandom | head -n 10 | md5sum
```
## 磁盘占满排查
```sh
df -hl
du -s /* | sort -nr |head # 选出排在前面的10个，head改成tail则是后面10个
du -sh /* | sort -nr # 加了h排序错乱
du -sh /home/* | sort -nr
```
## 内存占用高排查
```sh
top -o %MEM # 按内存占用排序
vmstat 2 # 每隔2秒展示内存占用情况
kill -9 `ps -ef| grep tail |awk '{print $2}' `
cat /proc/24573/status # 查看进程内存
```
## 健康检查脚本health-check-script
[健康检查脚本](https://github.com/SimplyLinuxFAQ/health-check-script/blob/master/health-check.sh)

[具体使用例子](https://www.jianshu.com/p/759b3bd7360e)
## centos7安装clash
[url1](https://i.jakeyu.top/2021/11/27/centos-%E4%BD%BF%E7%94%A8-Clash-%E6%A2%AF%E5%AD%90/)<br>
[url2](https://199604.com/2001)
## 安装prometheus和grafana
场景: 编写Dockerfile<br>
[grafana8.0.6官网下载](https://grafana.com/grafana/download/8.0.6?edition=oss&pg=get&platform=linux&plcmt=selfmanaged-box1-cta1)<br>
```sh
FROM quay.io/prometheus/prometheus
USER root
RUN echo 'Asia/Shanghai' >/etc/timezone
ADD prometheus.yml /etc/prometheus/
```
## 解压
```sh
tar -zxvf grafana-8.0.6.linux-amd64.tar.gz
```
## 服务启动脚本
```sh
#!/bin/sh
mainpid=$(lsof -i:8686|grep 'LISTEN'|awk '{print $2}')
echo $mainpid
if [ $mainpid > 0 ];then
    echo "main process id:$mainpid"
    kill -9 $mainpid
    if [ $? -eq 0 ];then
    echo "kill $mainpid success"
    go run main.go
    else
    echo "kill $mainpid fail"
    fi
else
    go run main.go
fi
```