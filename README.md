# 使用

## 1. 获取域名及VPS


## 2. 安装docker

```
curl -fsSL https://get.docker.com -o get-docker.sh

sh get-docker.sh
```


## 3. 安装docker-compose

```
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

sudo chmod +x /usr/local/bin/docker-compose

sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
```


## 4. 安装git并clone代码

```
apt-get install git

git clone https://github.com/77-QiQi/docker-v2ray.git
```


## 5. 修改v2ray配置

进入docker-v2ray目录开始修改配置。

**1) `init-letsencrypt.sh`** 将里面的domains和email修改为自己的域名和邮箱。

**2) `docker-compose.yml`** 可以不用动。

**3) `data/v2ray/config.json`** 修改<a href="https://www.uuidgenerator.net/" target="_blank">UUID</a> alterId 及path

**4) `data/nginx/conf.d/v2ray.conf`** 修改所有your_domain为自己的域名，如果前面v2ray配置文件没多做修改，则除域名之外的也不用修改其他地方。


## 6. 添加执行权限并执行一键部署

```
chmod +x ./init-letsencrypt.sh

./init-letsencrypt.sh
```


## 7. 自行在客户端新增配置

### 完毕！！！



### NGINX可能会选择设置的：

以下命令行将为您提供一个nginx容器内的bash shell
```
docker exec -it nginx bash
```

在正确的位置添加
```
server_tokens off;
```
