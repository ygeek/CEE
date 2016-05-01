from rest_framework import serializers
from ..models.coupon import *


class CouponSerializer(serializers.ModelSerializer):
    desc = serializers.DictField()

    class Meta:
        model = Coupon
        fields = ('id', 'name', 'desc', 'gmt_start', 'gmt_end')


class UserCouponSerializer(CouponSerializer):
    uuid = serializers.UUIDField()
    consumed = serializers.BooleanField()

    class Meta:
        model = Coupon
        fields = CouponSerializer.Meta.fields + ('uuid', 'consumed')
