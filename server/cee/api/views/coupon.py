# -*- coding: utf-8 -*-

from __future__ import absolute_import
from __future__ import unicode_literals

import uuid
from django.db import models
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
        try:
            code = request.data.get('code', '')
            user_coupon = UserCoupon.objects.select_for_update().get(
                uuid=uuid.UUID(uuid_), consumed=False)
            if code != user_coupon.coupon.code:
                return Response({
                    'code': -2,
                    'msg': 'code error',
                })
            user_coupon.consumed = True
            user_coupon.save(update_fields=['consumed'])
            return Response({
                'code': 0,
            })
        except UserCoupon.DoesNotExist:
            return Response({
                'code': -1,
                'msg': 'coupon not exists',
            })
