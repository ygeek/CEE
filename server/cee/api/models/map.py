from __future__ import unicode_literals

from django.db import models
from django.contrib.auth.models import User
import geohash
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
    published = models.BooleanField(default=False)
    owners = models.ManyToManyField(User,
                                    through='UserMap',
                                    related_name='maps')

    def save(self, *args, **kwargs):
        self.geohash = geohash.encode(longitude=self.longitude, latitude=self.latitude)
        super(Map, self).save(*args, **kwargs)


class UserMap(models.Model):
    user = models.ForeignKey(User, related_name='user_maps')
    map = models.ForeignKey(Map, related_name='user_maps')
    completed = models.BooleanField()

    class Meta:
        unique_together = (
            ('user', 'map'),
        )
