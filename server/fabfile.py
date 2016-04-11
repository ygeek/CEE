from fabric.api import *

env.user = 'nightfade'
env.hosts = ['ceeserver.com']
env.shell = '/bin/bash -l -i -c'


def bootstrap_server():
    sudo(r'apt-get update')
    sudo(r'apt-get upgrade')
    sudo('apt-get install -y make build-essential libssl-dev zlib1g-dev \
            libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm \
            libncurses5-dev libncursesw5-dev')
    sudo('apt-get install python-pip')
    sudo('apt-get install git')
    sudo('apt-get install supervisor')
    sudo('apt-get install nginx')
    sudo('apt-get install libmysqlclient-dev')


def bootstrap_pyenv():
    # install pyenv
    run(r'curl -L https://raw.githubusercontent.com/yyuu/pyenv-installer/master/bin/pyenv-installer | bash')
    append_bash_profile('export PYENV_ROOT="$HOME/.pyenv"')
    append_bash_profile('export PATH="$PYENV_ROOT/bin:$PATH"')
    append_bash_profile('eval "$(pyenv init -)"')
    append_bash_profile('eval "$(pyenv virtualenv-init -)"')
    run(r'source $HOME/.bash_profile')

    # setup vitualenv
    with settings(warn_only=True):
        run(r'pyenv install 2.7.11 -v')
        run(r'pyenv virtualenv 2.7.11 env-CEE')


def append_bash_profile(command_line):
    with settings(warn_only=True):
        result = run('grep -Fxq \'{0}\' $HOME/.bash_profile'.format(command_line))
        if result.return_code != 0:
            run('echo \'{0}\' >> $HOME/.bash_profile'.format(command_line))


def pack():
    local('rm -rf ../dist')
    local('mkdir ../dist')
    tar_files = ['cee', 'scripts', 'requirements.txt']
    local('tar -czvf ../dist/cee.tar.gz --exclude="__pycache__" --exclude="*.pyc" --exclude="*.sqlite3" {0}'.format(' '.join(tar_files)))


def deploy():
    put('../dist/cee.tar.gz', '/tmp/cee.tar.gz')
    run('rm -rf $HOME/cee')
    run('mkdir $HOME/cee')
    with cd('$HOME/cee'):
        run('tar xzf /tmp/cee.tar.gz')
        with prefix('pyenv activate env-CEE'):
            run('pyenv version')
            run('pip install -r requirements.txt')
            run('pip install mysql-python')
    run('rm -rf /tmp/CEE.tar.gz')
    with prefix('pyenv activate env-CEE'):
        with cd('$HOME/CEE/dist'):
            with shell_env(DJANGO_SETTINGS_MODULE='CEE.server_settings'):
                run('python manage.py makemigrations')
                run('python manage.py migrate')
                with settings(warn_only=True):
                    run('python manage.py createsuperuser --username=nightfade')


def start_server():
    run('mkdir -p $HOME/CEE/logs/')
    run('touch $HOME/CEE/logs/gunicorn_supervisor.log')
    run('touch $HOME/CEE/logs/nginx-access.log')
    run('touch $HOME/CEE/logs/nginx-error.log')
    sudo('chmod u+x $HOME/CEE/scripts/gunicorn_start.sh')
    sudo('cp $HOME/CEE/scripts/supervisor.conf /etc/supervisor/conf.d/cee.conf')
    sudo('cp $HOME/CEE/scripts/CEE.nginxconf /etc/nginx/nginx.conf')
    sudo('supervisorctl reread')
    sudo('supervisorctl update')
    status = sudo('supervisorctl status cee')
    run('ls -l $HOME/CEE/scripts')
    if status.find('No such process') > -1:
        sudo('supervisorctl start cee')
    else:
        sudo('supervisorctl restart cee')
    sudo('service nginx restart')

