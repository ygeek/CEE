from __future__ import unicode_literals

from django.db import models
from django.contrib.auth.models import User
from .city import *


class Map(models.Model):
    name = models.CharField(max_length=30, unique=True)
    desc = models.TextField()
    longitude = models.FloatField()
    latitude = models.FloatField()
    geohash = models.CharField(max_length=16, db_index=True)
    image_key = models.CharField(max_length=100)
    icon_key = models.CharField(max_length=100)
    summary_image_key = models.CharField(max_length=100)
    city = models.ForeignKey(City,
                             related_name='maps')
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
