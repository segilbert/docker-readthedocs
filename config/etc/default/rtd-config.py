from readthedocs.settings.dev import *

# Setting Overrides
# See readthedocs/settings/*.py for settings that need to be modified

import os
environ = os.environ

# Set this to the root domain where this RTD installation will be running
PRODUCTION_DOMAIN = os.getenv('RTD_PRODUCTION_DOMAIN', 'localhost:8000')

# Set the Slumber API host
SLUMBER_API_HOST = os.getenv('RTD_SLUMBER_API_HOST', "http://" + PRODUCTION_DOMAIN)

# Turn off email verification
ACCOUNT_EMAIL_VERIFICATION = 'none'

# Enable private Git doc repositories
ALLOW_PRIVATE_REPOS = True

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql_psycopg2',
        'NAME': environ['DB_ENV_DB_NAME'],
        'USER': environ['DB_ENV_DB_USER'],
        'PASSWORD': environ['DB_ENV_DB_PASS'],
        'HOST': 'db',
        'PORT': 5432,
    }
}
SITE_ROOT = '/app'
ES_HOSTS = ['elasticsearch:9200']
REDIS = {
    'host': 'redis',
    'port': 6379,
    'db': 0,
}
BROKER_URL = 'redis://redis:6379/0'
CELERY_RESULT_BACKEND = 'redis://redis:6379/0'
DEBUG = True
CELERY_ALWAYS_EAGER = False
