# -*- coding: utf-8 -*-

from __future__ import absolute_import
from __future__ import unicode_literals

from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from ..models.auth import *
from ..serializers.userInfo import *


class UserInfo(APIView):
    permission_classes = (IsAuthenticated, )

    def get(self,request):
        serializer = UserInfoSerializer(request.user)
        return Response({
            'code': 0,
            'userInfo': serializer.data
        })


class UserFriendList(APIView):
    permission_classes = (IsAuthenticated, )

    def get(self, request):
        user = request.user
        user_friend = user.user_friend.all()
        friends = [uf.friend for uf in user_friend]
        serializer = FriendInfoSerializer(friends, many=True)
        return Response({
            'code': 0,
            'num': len(serializer.data),
            'friends': serializer.data
        })


class addFriends(APIView):
    permission_classes = (IsAuthenticated, )

    def post(self, request, friendList):
        pass

