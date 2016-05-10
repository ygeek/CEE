from fabric.api import *

env.user = 'cee'
env.hosts = ['101.201.48.167']
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
    dist_dir = '../dist'
    local('rm -rf {0}'.format(dist_dir))
    local('mkdir {0}'.format(dist_dir))
    tar_files = ['cee', 'scripts', 'requirements.txt']
    for entry in tar_files:
        local('cp -r {0} {1}'.format(entry, dist_dir))
    with lcd(dist_dir):
        local('python -m compileall -f .')
        local('tar -czvf cee.tar.gz --exclude="__pycache__" '
               '--exclude="*.py" '
               '--exclude="*.sqlite3" {0}'.format(' '.join(tar_files)))


def deploy():
    put('../dist/cee.tar.gz', '/tmp/cee.tar.gz')
    run('rm -rf $HOME/cee')
    run('mkdir -p $HOME/cee/dist')
    with cd('$HOME/cee/dist'):
        run('tar xzf /tmp/cee.tar.gz')
        with prefix('pyenv activate env-CEE'):
            run('pyenv version')
            run('pip install -r requirements.txt')
            run('pip install mysql-python')
    run('rm -rf /tmp/cee.tar.gz')
    with prefix('pyenv activate env-CEE'):
        with cd('$HOME/cee/dist/cee'):
            with shell_env(DJANGO_SETTINGS_MODULE='cee.settings_server'):
                run('python manage.pyc makemigrations')
                run('python manage.pyc makemigrations api')
                run('python manage.pyc makemigrations cms')
                run('python manage.pyc makemigrations django_cron')
                run('python manage.pyc migrate')
                run('python manage.pyc collectstatic')
                run('python manage.pyc runcrons')
                run('python manage.pyc shell < data/city.py.data')
                run('python manage.pyc shell < data/sample.py.data')
                run('cp data/sample_h5_level.html static')


def create_superuser():
    with prefix('pyenv activate env-CEE'):
        with cd('$HOME/cee/dist/cee'):
            with shell_env(DJANGO_SETTINGS_MODULE='cee.settings_server'):
                with settings(warn_only=True):
                    run('python manage.pyc createsuperuser')


def start_service():
    run('mkdir -p $HOME/cee/logs/')
    run('mkdir -p $HOME/cee/run/')
    run('touch $HOME/cee/logs/gunicorn_supervisor.log')
    run('touch $HOME/cee/logs/nginx-access.log')
    run('touch $HOME/cee/logs/nginx-error.log')
    sudo('chmod u+x $HOME/cee/dist/scripts/gunicorn_start.sh')
    sudo('cp $HOME/cee/dist/scripts/supervisor.conf /etc/supervisor/conf.d/cee.conf')
    sudo('cp $HOME/cee/dist/scripts/cee.nginxconf /etc/nginx/nginx.conf')
    sudo('supervisorctl reread')
    sudo('supervisorctl update')
    status = sudo('supervisorctl status cee')
    run('ls -l $HOME/cee/dist/scripts')
    if status.find('No such process') > -1:
        sudo('supervisorctl start cee')
    else:
        sudo('supervisorctl restart cee')
    sudo('service nginx restart')

