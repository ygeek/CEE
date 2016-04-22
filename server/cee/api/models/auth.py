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
    gmt_created = models.DateField(auto_now_add=True)
    gmt_modified = models.DateField(auto_now=True)
    nickname = models.CharField(max_length=50)
    head_img_key = models.CharField(max_length=100, blank=True, null=True)
    sex = models.CharField(max_length=50, blank=True, null=True)
    birthday = models.DateField()
    mobile = models.CharField(max_length=50, blank=True, null=True)
    location = models.CharField(max_length=50, blank=True, null=True)


class UserFriend(models.Model):
    user = models.ForeignKey(User)
    friend = models.ForeignKey(User, related_name='user_relation')

    class Meta:
        unique_together = (
            'user', 'friend'
        )
