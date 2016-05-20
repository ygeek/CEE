from __future__ import unicode_literals

from django.db import models
from django.contrib.auth.models import User
from .map import *


class Medal(models.Model):
    map = models.OneToOneField(Map, on_delete=models.CASCADE, related_name='medal')
    name = models.CharField(max_length=30, unique=True)
    desc = models.TextField()
    icon_key = models.CharField(max_length=100)
    owners = models.ManyToManyField(User,
                                    through='UserMedal',
                                    related_name='medals')

    def __unicode__(self):
        return '{0}: {1}'.format(self.id, self.name)


class UserMedal(models.Model):
    user = models.ForeignKey(User, related_name='user_medals')
    medal = models.ForeignKey(Medal, related_name='user_medals')

    class Meta:
        unique_together = (
            ('user', 'medal'),
        )
