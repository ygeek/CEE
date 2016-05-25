# -*- coding: utf-8 -*-

from __future__ import absolute_import
from __future__ import unicode_literals

import json
from django.db import IntegrityError
from django.db.models import Q
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


class CheckFriends(APIView):
    permission_classes = (IsAuthenticated, )

    def post(self, request):
        mobilelist = request.data['mobiles'].split(',')
        users = []
        if mobilelist is not None:
            for mobile in mobilelist:
                if request.user.username == mobile:
                    continue
                try:
                    friend = User.objects.get(username=mobile)
                    userfriend = UserFriend.objects.get(user=request.user, friend=friend)
                except User.DoesNotExist:
                    pass
                except UserFriend.DoesNotExist:
                    users.append(friend)
        serializer = FriendInfoSerializer(users, many=True)
        return Response({
            'code': 0,
            'friends': serializer.data,
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


class CheckWeiboFriends(APIView):
    permission_classes = (IsAuthenticated, )

    def post(self, request):
        weiboids = request.data['uids'].split(',')
        users = []
        if weiboids is not None:
            for uid in weiboids:
                try:
                    account = ThirdPartyAccount.objects.get(uid=uid, platform='weibo')
                    if request.user.username == account.user.username:
                        continue
                    userfriend = UserFriend.objects.get(user=request.user, friend=account.user)
                except ThirdPartyAccount.DoesNotExist:
                    continue
                except UserFriend.DoesNotExist:
                    if account:
                        users.append(account.user)
        serializer = FriendInfoSerializer(users, many=True)
        return Response({
            'code': 0,
            'friends': serializer.data,
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


class FollowFriend(APIView):
    permission_classes = (IsAuthenticated, )

    def post(self, request):
        uid = request.data['id']
        try:
            friend = User.objects.get(id=uid)
            if request.user.username == friend.username:
                return Response({
                    'code': -3,
                    'msg': '不能添加自己为好友'
                })
            userfriend = UserFriend(user=request.user, friend=friend)
            userfriend.save()
            return Response({
                'code': 0,
                'msg': '成功添加好友'
            })
        except User.DoesNotExist:
            return Response({
                'code': -1,
                'msg': '用户不存在'
            })
        except IntegrityError:
            return Response({
                'code': -2,
                'msg': '已经添加了这个好友啦'
            })


class SearchFriends(APIView):
    permission_classes = (IsAuthenticated, )

    def post(self, request):
        query = request.data['query']
        exist = UserFriend.objects.filter(user=request.user)
        friends = User.objects\
            .filter(Q(username__icontains=query) |
                    Q(userprofile__nickname__icontains=query),
                    ~Q(username=request.user.username)) \
            .exclude(pk__in=exist)
        serializer = FriendInfoSerializer(friends, many=True)
        return Response({
            'code': 0,
            'friends': serializer.data
        })
