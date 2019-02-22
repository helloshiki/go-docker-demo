# golang安装
## 下载最新版本
```
https://studygolang.com/dl
```
## 解压/安装，设置环境变量
```
export GOROOT=/home/sk/.software/go
export GOBIN=$GOROOT/bin
export PATH=$GOBIN:$PATH
```
## 安装golang包管理器dep 
```
https://github.com/golang/dep/releases
```

# IDE
## 安装goland
```
https://www.jetbrains.com/go/
```
## 破解
```
http://idea.lanyus.com/
```
按说明操作

# 项目目录结构
```
demo/       # GOPATH
    /bin/   # GOBIN
    /pkg/   
    /src/   # 代码
        /github.com/helloshiki/go-docker-demo/          # 项目代码
                                             /demo/     # golang代码
                                             /deploy/   # 部署文档
                                             /images/   # 制作镜像文档
                                             /web/      # 前端代码
                                             /vendor/   # 项目依赖库
                                             /devenv    # source环境变量 
                                             /docker-env.mk # Makefile docker相关
                                             /version.mk    # Makefile 版本控制
                                             /Makefile      # Makefile
                                             /Gopkg.lock    # dep文件 
                                             /Gopkg.toml    # dep配置文件
```
## devenv
```shell
➜  go-docker-demo git:(master) ✗ pwd
/home/sk/workspace/go-docker-demo/src/github.com/helloshiki/go-docker-demo
➜  go-docker-demo git:(master) ✗ cat devenv 
GOPATH=`pwd`/../../../..    # 自行修改，指向src所在的父目录
GOBIN=$GOPATH/bin           # go install的目录
PATH=$GOPATH/bin:$PATH      # 找到编译的可执行文件

export GOPATH
export PATH
export GOBIN
```
执行命令，设置环境变量 GOPATH GOBIN PATH
```shell
source ./devenv
```

# demo
## dep初始化 
```shell
➜  go-docker-demo git:(master) ✗ pwd
/home/sk/workspace/go-docker-demo/src/github.com/helloshiki/go-docker-demo
➜  go-docker-demo git:(master) ✗ ls
devenv
➜  go-docker-demo git:(master) ✗ dep init 
➜  go-docker-demo git:(master) ✗ ls
devenv  Gopkg.lock  Gopkg.toml  vendor
```
## 下载依赖库
```shell
➜  go-docker-demo git:(master) ✗ dep ensure -v
```

# 制作镜像
## 打包
```shell
➜  go-docker-demo git:(master) ✗ make clean && make docker  # 打包所有
➜  go-docker-demo git:(master) ✗ make demo-docker-clean && make demo-docker  # 打包一个
➜  go-docker-demo git:(master) ✗ sudo docker images | grep demo
registry.cn-hangzhou.aliyuncs.com/tenbayblockchain/demo-demo       1.0.0               b4a1b08ee770        2 minutes ago       266MB
```
## 查看镜像内容是否正确 
```shell
➜  go-docker-demo git:(master) ✗ sudo docker run -it --rm --name zzz registry.cn-hangzhou.aliyuncs.com/tenbayblockchain/demo-demo:1.0.0 bash  
root@fb6b71285925:/# ls
bin  boot  dev  etc  home  lib  lib64  media  mnt  opt  proc  root  run  sbin  srv  sys  tmp  usr  var
root@fb6b71285925:/# which demo 
/usr/bin/demo

➜  compose git:(master) ✗ sudo docker run -it --rm --name zzz registry.cn-hangzhou.aliyuncs.com/tenbayblockchain/demo-web:1.0.0 bash  
root@b0b49cd8a844:/# ls /www/web/
index.html
```

# 运行
## 启动数据库
```shell
➜  compose git:(master) ✗ pwd
/home/sk/workspace/go-docker-demo/src/github.com/helloshiki/go-docker-demo/deploy/compose
➜  compose git:(master) ✗ sudo docker-compose -f deps.yaml up -d
Starting demo_mysql ... done
➜  compose git:(master) ✗ sudo docker-compose -f deps.yaml ps    
   Name                Command             State          Ports       
----------------------------------------------------------------------
demo_mysql   docker-entrypoint.sh mysqld   Up      3306/tcp, 33060/tcp
```
## 启动业务
```shell
➜  compose git:(master) ✗ sudo docker-compose -f deps.yaml ps    
   Name                Command             State          Ports       
----------------------------------------------------------------------
demo_mysql   docker-entrypoint.sh mysqld   Up      3306/tcp, 33060/tcp
➜  compose git:(master) ✗ sudo docker-compose -f demo.yaml up -d 
Starting demo_demo ... done
Starting demo_web  ... done
➜  compose git:(master) ✗ sudo docker-compose -f demo.yaml ps    
  Name                 Command               State         Ports       
-----------------------------------------------------------------------
demo_demo   demo                             Up      6060/tcp, 8088/tcp
demo_web    /usr/local/openresty/bin/o ...   Up      0.0.0.0:80->80/tcp
➜  compose git:(master) ✗ curl 'http://localhost:80/v1/greeting'
{"hello":"world"}                                                                                                                                  
➜  compose git:(master) ✗ curl 'http://localhost:80'            
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Title</title>
</head>
<body>
<h1>Hello, World!</h1>
</body>
</html>
```
