# -*- coding: utf-8 -*-

from __future__ import absolute_import
from __future__ import unicode_literals

from rest_framework.views import APIView
from rest_framework.response import Response
from ..models import Medal, User
from ..serializers import MedalSerializer


class MedalDetail(APIView):
    def get(self, request, medal_id):
        try:
            medal_id = int(medal_id)
            medal = Medal.objects.get(id=medal_id)
            serializer = MedalSerializer(medal)
            return Response({
                'code': 0,
                'medal': serializer.data
            })
        except ValueError:
            return Response({
                'code': -1,
                'msg': 'invalid medal id: %s' % medal_id
            })
        except Medal.DoesNotExist:
            return Response({
                'code': -2,
                'msg': 'medal not exists',
            })


class UserMedalList(APIView):
    def get(self, request, user_id):
        try:
            user_id = int(user_id)
            user = User.objects.get(id=user_id)
            medals = user.medals.all()
            serializer = MedalSerializer(medals, many=True)
            return Response({
                'code': 0,
                'medals': serializer.data
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
