from __future__ import absolute_import
from __future__ import unicode_literals

from .settings import *

DEBUG = False

ALLOWED_HOSTS = ['*']

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.mysql', # Add 'postgresql_psycopg2', 'mysql', 'sqlite3' or 'oracle'.
        'NAME': 'cee_sql',                        # Or path to database file if using sqlite3.
        'USER': 'cee',
        'PASSWORD': 'Jibuzhu123',
        'HOST': 'rm-bp1nge6n4d00t4b01.mysql.rds.aliyuncs.com',
        'PORT': '3306',                      # Set to empty string for default.
    }
}
