from __future__ import unicode_literals

import uuid
from django.db import models
from django.contrib.auth.models import User
from .story import *
from .fields import *


class Coupon(models.Model):
    name = models.CharField(max_length=30, unique=True)
    desc = JsonField()
    gmt_start = models.DateField()
    gmt_end = models.DateField()
    code = models.CharField(max_length=10)
    is_deleted = models.BooleanField()
    owners = models.ManyToManyField(User,
                                    through='UserCoupon',
                                    related_name='coupons')


class LevelCoupon(models.Model):
    story = models.ForeignKey(Story, related_name='level_coupons')
    level = models.ForeignKey(Level, related_name='level_coupons')
    coupon = models.ForeignKey(Coupon, related_name='level_coupons')
    amount = models.IntegerField()
    remain = models.IntegerField()


class UserCoupon(models.Model):
    uuid = models.UUIDField(primary_key=True,
                            default=uuid.uuid4,
                            editable=False)
    user = models.ForeignKey(User, related_name='user_coupons')
    coupon = models.ForeignKey(Coupon, related_name='user_coupons')
    story = models.ForeignKey(Story, related_name='user_coupons')
    level = models.ForeignKey(Level, related_name='user_coupons')
    consumed = models.BooleanField()
