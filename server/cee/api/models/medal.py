from __future__ import unicode_literals

from django.db import models
from django.contrib.auth.models import User
from .map import *


class Medal(models.Model):
    map = models.OneToOneField(Map, on_delete=models.CASCADE)
    name = models.CharField(max_length=30, unique=True)
    desc = models.TextField()
    icon_url = models.URLField()
    owners = models.ManyToManyField(User,
                                    through='UserMedal',
                                    related_name='medals')


class UserMedal(models.Model):
    user = models.ForeignKey(User, related_name='user_medals')
    medal = models.ForeignKey(Medal, related_name='user_medals')

    class Meta:
        unique_together = (
            ('user', 'medal'),
        )
