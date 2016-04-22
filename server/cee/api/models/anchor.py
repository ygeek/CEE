from __future__ import unicode_literals

from django.db import models
from django.contrib.auth.models import User
from .map import Map


class Anchor(models.Model):
    class Type(object):
        Task = 'task'
        Story = 'story'
        Choices = (
            (Task, Task.capitalize()),
            (Story, Story.capitalize()),
        )

    map = models.ForeignKey(Map, related_name='anchors')
    name = models.CharField(max_length=30)
    desc = models.TextField()
    dx = models.FloatField()
    dy = models.FloatField()
    type = models.CharField(max_length=10,
                            choices=Type.Choices)
    ref_id = models.IntegerField()
    owners = models.ManyToManyField(User,
                                    through='UserAnchor',
                                    related_name='anchors')

    class Meta:
        unique_together = (
            ('type', 'ref_id'),
        )


class UserAnchor(models.Model):
    user = models.ForeignKey(User, related_name='user_anchors')
    anchor = models.ForeignKey(Anchor, related_name='user_anchors')

    class Meta:
        unique_together = (
            ('user', 'anchor'),
        )
