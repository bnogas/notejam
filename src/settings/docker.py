from settings.base import *  # noqa

ALLOWED_HOSTS = ['*']
STATIC_URL = '/static/'
STATIC_ROOT = os.environ['PROJECT_PATH']+"/static"

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.mysql',
        'NAME': os.environ.get('DB_NAME'),
        'USER': os.environ.get('DB_USER'),
        'PASSWORD': os.environ.get('DB_PASSWORD'),
        'HOST': os.environ.get('DB_HOST'),
        'PORT': int(os.environ.get('DB_PORT', 3306)),
    }
}
