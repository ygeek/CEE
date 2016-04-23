# -*- coding: utf-8 -*-

from __future__ import absolute_import
from __future__ import unicode_literals


from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from ..models.story import *
from ..serializers.story import *


class LevelDetail(APIView):
    permission_classes = (IsAuthenticated, )

    def get(self, request, level_id):
        try:
            level_id = int(level_id)
            level = Level.objects.get(id=level_id)
            serializer = LevelSerializer(level)
            return Response({
                'code': 0,
                'level': serializer.data
            })
        except ValueError:
            return Response({
                'code': -1,
                'msg': 'invalid level id: %s' % level_id
            })
        except Level.DoesNotExist:
            return Response({
                'code': -2,
                'msg': 'level not exists',
            })
