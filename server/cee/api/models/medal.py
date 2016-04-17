from __future__ import unicode_literals

from django.db import models
from django.contrib.auth.models import User


class Medal(models.Model):
    name = models.CharField(max_length=30)
    desc = models.CharField(max_length=100)
    icon_url = models.URLField()


class UserMedal(models.Model):
    user = models.ForeignKey(User, related_name='user_medals')
    medal = models.ForeignKey(Medal, related_name='user_medals')

    class Meta:
        unique_together = (
            ('user', 'medal'),
        )
