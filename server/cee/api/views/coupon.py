# -*- coding: utf-8 -*-

from __future__ import absolute_import
from __future__ import unicode_literals

import uuid
from rest_framework.views import APIView
from rest_framework.response import Response
from ..models.coupon import *
from ..serializers.coupon import *


class UserCouponList(APIView):
    def get(self, request):
        try:
            user_coupons = request.user.user_coupons
            serializer = UserCouponSerializer(user_coupons, many=True)
            return Response({
                'code': 0,
                'coupons': serializer.data,
            })
        except ValueError:
            return Response({
                'code': -1,
                'msg': 'invalid user id: %s' % user_id,
            })
        except User.DoesNotExist:
            return Response({
                'code': -2,
                'msg': 'user not exists',
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
