# -*- coding: utf-8 -*-

from __future__ import absolute_import
from __future__ import unicode_literals

import datetime

from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated

from ..models.message import *
from ..serializers.message import *


class UserMessageList(APIView):
    permission_classes = (IsAuthenticated, )

    def get(self, request, timestamp):
        try:
            timestamp = int(timestamp)
            messages = request.user.user_messages.filter(
                timestamp__gt=timestamp,
                is_deleted=False
            )
            serializer = MessageSerializer(messages, many=True)
            return Response({
                'code': 0,
                'messages': serializer.data
            })
        except ValueError:
            return Response({
                'code': -1,
                'msg': '未知错误'
            })


class UserMessageMarkRead(APIView):
    permission_classes = (IsAuthenticated, )

    def post(self, request, message_id):
        try:
            message = Message.objects.get(id=int(message_id))
            message.unread = False
            message.save(update_fields=['unread'])
            return Response({
                'code': 0,
                'msg': '标记消息已读',
            })
        except Message.DoesNotExist:
            return Response({
                'code': -1,
                'msg': '消息不存在',
            })
        except ValueError:
            return Response({
                'code': -2,
                'msg': '未知错误',
            })
