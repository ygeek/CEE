# -*- coding: utf-8 -*-

from __future__ import absolute_import
from __future__ import unicode_literals

from django.db import models
from django.contrib.auth.models import User


class Message(models.Model):
    class Type(object):
        Story = 'story'
        Attention = 'attention'
        Coupon = 'coupon'
        Choices = (
            (Story, Story.capitalize()),
            (Attention, Attention.capitalize()),
            (Coupon, Coupon.capitalize()),
        )

    user = models.ForeignKey(User, related_name='user_messages')
    type = models.CharField(max_length=10,
                            choices=Type.Choices)
    timestamp = models.IntegerField()
    text = models.TextField()
    unread = models.BooleanField(default=True)
    story_id = models.IntegerField(blank=True, null=True)
    map_id = models.IntegerField(blank=True, null=True)
    coupon_id = models.IntegerField(blank=True, null=True)
    is_local = models.BooleanField(default=False)
    is_deleted = models.BooleanField(default=False)
