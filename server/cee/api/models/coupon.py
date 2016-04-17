from __future__ import unicode_literals

from django.db import models
from django.contrib.auth.models import User


class Coupon(models.Model):
    gmt_start = models.DateField()
    gmt_end = models.DateField()
    name = models.CharField(max_length=30)
    desc = models.TextField()
    state = models.CharField(max_length=50)
    code = models.CharField(max_length=50)
    is_deleted = models.BooleanField()


class UserCoupon(models.Model):
    user = models.ForeignKey(User, related_name='user_coupons')
    coupon = models.ForeignKey(Coupon, related_name='user_coupons')

    class Meta:
        unique_together = (
            ('user', 'coupon'),
        )
