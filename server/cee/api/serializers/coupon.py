from rest_framework import serializers
from ..models.coupon import *


class CouponSerializer(serializers.ModelSerializer):
    desc = serializers.DictField()

    class Meta:
        model = Coupon
        fields = ('id', 'name', 'desc', 'gmt_start', 'gmt_end')


class UserCouponSerializer(serializers.ModelSerializer):
    coupon = CouponSerializer()

    class Meta:
        model = UserCoupon
        fields = ('uuid', 'coupon', 'consumed')
