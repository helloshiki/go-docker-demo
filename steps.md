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

