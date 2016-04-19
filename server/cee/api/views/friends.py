# -*- coding: utf-8 -*-

from __future__ import absolute_import
from __future__ import unicode_literals

from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from ..models.medal import *
from ..serializers.medal import *


class UserFriendList(APIView):
    permission_classes = (IsAuthenticated, )

    def get(self, request, user_id):
        try:
            user_id = int(user_id)
            user = User.objects.get(id=user_id)
            user_friend = user.user_friend.all()
            friends = [uf.friend for uf in user_friend]
            serializer = UserInfoSerializer(friends, many=True)
            return Response({
                'code': 0,
                'friends': serializer.data
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
