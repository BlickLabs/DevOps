
#!/bin/bash

# This runs in port <port>

# Project Name
NAME=""
# Virtualenv Full Path
VIRTUALENV=""
# Project Dir Full Path
PROJECT_DIR=""
# Log File Full Path
LOG_FILE=""
# User who runs the application
USER=<user>
DJANGO_WSGI_MODULE=config.wsgi

echo "Starting $NAME as `whoami` on port <port>"

cd $VIRTUALENV
source bin/activate
cd $PROJECT_DIR

# Your production env variables
# export DJANGO_SETTINGS_MODULE="config.settings.production"

exec gunicorn ${DJANGO_WSGI_MODULE} \
--workers $NUM_WORKERS \
--user=$USER  \
--log-level=debug \
--bind=0.0.0.0:<port> \
--error-logfile $LOG_FILE
