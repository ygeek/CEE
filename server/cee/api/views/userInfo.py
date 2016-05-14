# -*- coding: utf-8 -*-

from __future__ import absolute_import
from __future__ import unicode_literals

import json
from django.db import IntegrityError
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


class AddFriends(APIView):
    permission_classes = (IsAuthenticated, )

    def post(self, request):
        mobilelist = request.data['mobiles'].split(',')
        count = 0
        if mobilelist is not None:
            for mobile in mobilelist:
                if request.user.username == mobile:
                    continue
                try:
                    friend = User.objects.get(username=mobile)
                    userfriend = UserFriend(user=request.user, friend=friend)
                    userfriend.save()
                    count += 1
                except User.DoesNotExist:
                    pass
                except IntegrityError:
                    pass
        return Response({
            'code': 0,
            'num': count,
        })


class AddWeiboFriends(APIView):
    permission_classes = (IsAuthenticated, )

    def post(self, request):
        weiboids = request.data['uids'].split(',')
        count = 0
        if weiboids is not None:
            for uid in weiboids:
                try:
                    account = ThirdPartyAccount.objects.get(uid=uid, platform='weibo')
                    if request.user.username == account.user.username:
                        continue
                    userfriend = UserFriend(user=request.user, friend=account.user)
                    userfriend.save()
                    count += 1
                except ThirdPartyAccount.DoesNotExist:
                    pass
                except IntegrityError:
                    pass
        return Response({
            'code': 0,
            'num': count,
        })
