# -*- coding: utf-8 -*-

from __future__ import absolute_import
from __future__ import unicode_literals

from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from ..models.medal import *
from ..serializers.medal import *


class UserMedalList(APIView):
    permission_classes = (IsAuthenticated, )

    def get(self, request):
        medals = request.user.medals
        serializer = MedalSerializer(medals, many=True)
        return Response({
            'code': 0,
            'medals': serializer.data
        })


class FriendMedalList(APIView):
    permission_classes = (IsAuthenticated, )

    def get(self, request, friend_id):
        try:
            user = User.objects.get(id=friend_id)
            medals = user.medals
            serializer = MedalSerializer(medals, many=True)
            return Response({
                'code': 0,
                'medals': serializer.data
            })
        except User.DoesNotExist:
            return Response({
                'code': -1,
                'msg': '不存在的用户'
            })
