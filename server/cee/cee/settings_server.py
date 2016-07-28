from __future__ import absolute_import
from __future__ import unicode_literals

from .settings import *

DEBUG = False

ALLOWED_HOSTS = ['*']

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.mysql', # Add 'postgresql_psycopg2', 'mysql', 'sqlite3' or 'oracle'.
        'NAME': 'cee_sql',                        # Or path to database file if using sqlite3.
        'USER': 'cee_admin',
        'PASSWORD': 'cee_2016',
        'HOST': 'rdsc4y151z16bvnyfm90.mysql.rds.aliyuncs.com',
        'PORT': '3306',                      # Set to empty string for default.
    }
}
