# -*- coding: utf-8 -*-

from __future__ import absolute_import
from __future__ import unicode_literals

from rest_framework.views import APIView
from rest_framework.response import Response
from ..models import Coupon, User
from ..serializers import CouponSerializer, UserCouponSerializer


class CouponDetail(APIView):
    def get(self, request, coupon_id):
        try:
            coupon_id = int(coupon_id)
            coupon = Coupon.objects.get(id=coupon_id)
            serializer = CouponSerializer(coupon)
            return Response({
                'code': 0,
                'coupon': serializer.data
            })
        except ValueError:
            return Response({
                'code': -1,
                'msg': 'invalid coupon id: %s' % coupon_id
            })
        except Coupon.DoesNotExist:
            return Response({
                'code': -2,
                'msg': 'coupon not exists',
            })


class CouponList(APIView):
    def get(self, request, user_id):
        try:
            user_id = int(user_id)
            user = User.objects.get(id=user_id)
            user_coupons = user.user_coupons.all()
            serializer = CouponSerializer(user_coupons, many=True)
            return Response({
                'code': 0,
                'coupons': serializer.data
            })
        except ValueError:
            return Response({
                'code': -1,
                'msg': 'invalid user id: %s' % user_id
            })
        except User.DoesNotExist:
            return Response({
                'code': -2,
                'msg': 'user not exists',
            })
