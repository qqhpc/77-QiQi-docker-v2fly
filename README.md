# 使用

## 1. 获取域名及VPS


## 2. 安装docker

```
curl -fsSL https://get.docker.com -o get-docker.sh

sh get-docker.sh
```


## 3. 安装docker-compose
**v2.9.0 版本**
```
sudo curl -SL https://github.com/docker/compose/releases/download/v2.9.0/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose

sudo chmod +x /usr/local/bin/docker-compose

sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
```
**v2.5.0 版本（已安装 v2.9.0 版本，可忽略）**
```
sudo curl -SL https://github.com/docker/compose/releases/download/v2.5.0/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose

sudo chmod +x /usr/local/bin/docker-compose

sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
```
**1.29.2 版本（已安装 v2.9.0 版本，可忽略）**
```
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

sudo chmod +x /usr/local/bin/docker-compose

sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
```


## 4. 安装git并clone代码

```
apt-get install git -y

git clone https://github.com/77-QiQi/docker-v2fly.git
```


## 5. 修改v2ray配置

进入docker-v2fly目录开始修改配置。

**1) `info.conf`** 请于此文件内设置**域名**及**邮箱**，并**修改 <a href="https://www.uuidgenerator.net/" target="_blank">UUID</a> 和 path 。**

**2) `docker-compose.yml`** 可以不用动。


## 6. 添加执行权限并执行一键部署

```
chmod +x ./install.sh

./install.sh
```


## 7. 自行在客户端新增配置

### 完毕！！！



### NGINX可能会选择设置的：

以下命令行将为您提供一个NGINX容器内的bash shell
```
docker exec -it nginx bash
```

在正确的位置添加
```
server_tokens off;
```
