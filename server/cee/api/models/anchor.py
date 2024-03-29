# coding=utf-8
from __future__ import unicode_literals

from django.db import models
from django.contrib.auth.models import User
from .map import Map


class Anchor(models.Model):
    class Type(object):
        Task = 'task'
        Story = 'story'
        Choices = (
            (Task, '选择题'),
            (Story, '故事'),
        )

    map = models.ForeignKey(Map, related_name='anchors')
    name = models.CharField(max_length=30, unique=True)
    dx = models.IntegerField()
    dy = models.IntegerField()
    type = models.CharField(max_length=10,
                            default='task',
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
