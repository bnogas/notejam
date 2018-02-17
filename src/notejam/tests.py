from django.conf import settings
from django.contrib.auth.models import User


EXCLUDED_APPS = getattr(settings, 'TEST_EXCLUDE', [])


# helper test functions
def create_user(user_data):
    user = User.objects.create(username=user_data['email'], **user_data)
    user.set_password(user_data['password'])
    user.save()
    return user
