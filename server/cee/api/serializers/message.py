# -*- coding: utf-8 -*-

from __future__ import absolute_import
from __future__ import unicode_literals

from rest_framework import serializers
from ..models.message import *


class MessageSerializer(serializers.ModelSerializer):
    class Meta:
        model = Message
        fields = ('id',
                  'type',
                  'timestamp',
                  'text',
                  'unread',
                  'story_id',
                  'map_id',
                  'coupon_id',
                  'is_local')
