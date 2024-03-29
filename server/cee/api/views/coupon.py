# -*- coding: utf-8 -*-

from __future__ import absolute_import
from __future__ import unicode_literals

import uuid
from django.db import models
from django.db import transaction
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from ..models.coupon import *
from ..serializers.coupon import *


class UserCouponList(APIView):
    permission_classes = (IsAuthenticated, )

    def get(self, request):
        coupons = request.user.coupons.annotate(
            uuid=models.F('user_coupons__uuid'),
            consumed=models.F('user_coupons__consumed'))
        serializer = UserCouponSerializer(coupons, many=True)
        return Response({
            'code': 0,
            'coupons': serializer.data,
        })


class ConsumeCoupon(APIView):
    def post(self, request, uuid_):
        code = request.data.get('code', '')
        with transaction.atomic():
            try:
                user_coupon = UserCoupon.objects.select_for_update().get(
                    uuid=uuid.UUID(uuid_), consumed=False)
                if code != user_coupon.coupon.code:
                    return Response({
                        'code': -2,
                        'msg': '验证码错误',
                    })
                user_coupon.consumed = True
                user_coupon.save(update_fields=['consumed'])
                return Response({
                    'code': 0,
                    'msg': '验证成功'
                })
            except UserCoupon.DoesNotExist:
                return Response({
                    'code': -1,
                    'msg': '优惠券不存在',
                })
