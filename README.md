# 服务端开发环境
## 配置开发环境
### Python版本管理工具：[pyenv](https://github.com/yyuu/pyenv)
```bash
$ brew update
$ brew install pyenv
```
### pyenv plugin：[pyenv-virtualenv](https://github.com/yyuu/pyenv-virtualenv)
```bash
$ brew install pyenv-virtualenv
```

增加初始化语句到`shell`的配置文件：如果是bash就添加到`.bashrc` ，如果是用`zsh`就加到 `.zshrc`。
```bash
$ echo 'eval "$(pyenv init -)"' >> .bashrc
$ echo 'eval "$(pyenv virtualenv-init -)"' >> .bashrc
```

### 配置项目Virtual Env：
```bash
$ pyenv install 2.7.11 -v
$ pyenv virtualenv 2.7.11 env-CEE
```

### 激活Virtual Env：
```bash
$ pyenv activate env-CEE
```

### 安装依赖
```bash
$ pip install -r requirements.txt
```

## 主要开发框架

1. [Django](https://www.djangoproject.com/)
2. [Django REST framework](http://www.django-rest-framework.org/)

## 生产环境服务器配置（配置脚本见代码）

1. [Ngnix](http://nginx.org/)：反响代理，静态文件服务
2. [Gunicron](http://gunicorn.org/)：高并发WSGI
3. [Fabric](http://www.fabfile.org/)：远程部署

# iOS客户端开发环境

1. XCode + XVIM
2. CocoaPods
3. iOS 8.0+
