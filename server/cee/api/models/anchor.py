from __future__ import unicode_literals

from django.db import models
from django.contrib.auth.models import User
from .map import Map


class Anchor(models.Model):
    name = models.CharField(max_length=30)
    desc = models.TextField()
    dx = models.FloatField()
    dy = models.FloatField()
    anchor_type = models.CharField(max_length=50)


class MapAnchor(models.Model):
    map = models.ForeignKey(Map, related_name='map_anchors')
    anchor = models.ForeignKey(Anchor, related_name='map_anchors')

    class Meta:
        unique_together = (
            ('map', 'anchor'),
        )


class UserAnchor(models.Model):
    user = models.ForeignKey(User, related_name='user_anchors')
    anchor = models.ForeignKey(Anchor, related_name='user_anchors')
    completed = models.BooleanField()

    class Meta:
        unique_together = (
            ('user', 'anchor')
        )
