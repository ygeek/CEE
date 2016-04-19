from __future__ import unicode_literals

from django.db import models
from django.contrib.auth.models import User


class UserDeviceToken(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE)
    device_token = models.CharField(max_length=100)
    installation_id = models.CharField(max_length=100)


class ThirdPartyAccount(models.Model):
    uid = models.CharField(max_length=100)
    platform = models.CharField(max_length=50)
    user = models.ForeignKey(User)


class UserProfile(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE)
    gmt_created = models.DateField()
    gmt_modified = models.DateField()
    nickname = models.CharField(max_length=50)
    head_url = models.URLField()
    sex = models.CharField(max_length=50)
    mobile = models.CharField(max_length=50)


class UserFriend(models.Model):
    user = models.ForeignKey(User, related_name='user_relation')
    friend = models.ForeignKey(User, related_name='user_relation')

    class Model:
        unique_together = (
            'user','friend'
        )
