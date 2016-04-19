from __future__ import unicode_literals

from django.db import models
from django.contrib.auth.models import User
from .medal import Medal


class Map(models.Model):
    name = models.CharField(max_length=30)
    desc = models.CharField(max_length=100)
    x = models.FloatField()
    y = models.FloatField()
    image_url = models.URLField()
    medal = models.ForeignKey(Medal, related_name='maps')
    owners = models.ManyToManyField(User,
                                    through='UserMap',
                                    related_name='maps')


class UserMap(models.Model):
    user = models.ForeignKey(User, related_name='user_maps')
    map = models.ForeignKey(Map, related_name='user_maps')
    completed = models.BooleanField()

    class Meta:
        unique_together = (
            ('user', 'map'),
        )
