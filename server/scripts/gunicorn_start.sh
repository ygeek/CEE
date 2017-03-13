#!/bin/bash

export HOME=/home/cee
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"


NAME="cee"                                  # Name of the application
DJANGODIR=$HOME/cee/dist/cee                # Django project directory
SOCKFILE=$HOME/cee/run/gunicorn.sock        # we will communicte using this unix socket
USER=cee                                    # the user to run as
GROUP=cee                                   # the group to run as
NUM_WORKERS=1                                     # how many worker processes should Gunicorn spawn
DJANGO_SETTINGS_MODULE=cee.settings_server         # which settings file should Django use
DJANGO_WSGI_MODULE=cee.wsgi                     # WSGI module name

# Activate the virtual environment
cd $DJANGODIR
pyenv activate env-CEE
export DJANGO_SETTINGS_MODULE=$DJANGO_SETTINGS_MODULE
export PYTHONPATH=$DJANGODIR:$PYTHONPATH

# Create the run directory if it doesn't exist
RUNDIR=$(dirname $SOCKFILE)
test -d $RUNDIR || mkdir -p $RUNDIR

echo "Starting $NAME as `whoami` at $HOME"

# Start your Django Unicorn
# Programs meant to be run under supervisor should not daemonize themselves (do not use --daemon)
exec gunicorn ${DJANGO_WSGI_MODULE}:application \
  --name $NAME \
  --workers $NUM_WORKERS \
  --user=$USER --group=$GROUP \
  --bind=unix:$SOCKFILE \
  --log-level=debug \
  --log-file=$HOME/cee/logs/gunicorn.log \
  --access-logfile=$HOME/cee/logs/gunicorn_access.log
