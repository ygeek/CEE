from rest_framework import serializers
from ..models.coupon import *


class UserCouponSerializer(serializers.ModelSerializer):
    class Meta:
        model = UserCoupon
        fields = ('id', 'user', 'coupon')


class CouponSerializer(serializers.ModelSerializer):
    class Meta:
        model = Coupon
        fields = (
            'id',
            'gmt_start',
            'gmt_end',
            'name',
            'desc',
            'state',
            'code'
        )
