# -*- coding: utf-8 -*-

from __future__ import absolute_import
from __future__ import unicode_literals

from django.db import connection
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from ..models.anchor import *
from ..serializers.anchor import *


class MapAnchorList(APIView):
    permission_classes = (IsAuthenticated, )

    def get(self, request, map_id):
        try:
            map_id = int(map_id)
            map_ = Map.objects.get(id=map_id)
            nullp = {'sqlite': 'IFNULL', 'mysql': 'ISNULL'}[connection.vendor]
            args = {
                'nullp': nullp,
                'map_id': map_id,
                'user_id': request.user.id,
            }
            task_sql = '''
                SELECT api_anchor.id AS id,
                       api_anchor.name AS name,
                       dx,
                       dy,
                       type,
                       ref_id,
                       %(nullp)s(api_usertask.completed, 0) AS completed
                FROM api_anchor
                    JOIN api_task
                        ON api_anchor.ref_id=api_task.id
                    LEFT JOIN api_usertask
                        ON api_anchor.ref_id=api_usertask.task_id
                WHERE type='task'
                  AND map_id=%(map_id)d
                  AND %(nullp)s(user_id, %(user_id)d)=%(user_id)d
            ''' % args
            story_sql = '''
                SELECT api_anchor.id AS id,
                       api_anchor.name AS name,
                       dx,
                       dy,
                       type,
                       ref_id,
                       %(nullp)s(api_userstory.completed, 0) AS completed
                FROM api_anchor
                    JOIN api_story
                        ON api_anchor.ref_id=api_story.id
                    LEFT JOIN api_userstory
                        ON api_anchor.ref_id=api_userstory.story_id
                WHERE type='story'
                  AND map_id=%(map_id)d
                  AND %(nullp)s(user_id, %(user_id)d)=%(user_id)d
            ''' % args
            task_anchors = list(Anchor.objects.raw(task_sql))
            story_anchors = list(Anchor.objects.raw(story_sql))
            anchors = task_anchors + story_anchors
            serializer = UserAnchorSerializer(anchors, many=True)
            return Response({
                'code': 0,
                'anchors': serializer.data
            })
        except ValueError:
            return Response({
                'code': -1,
                'msg': '无效的地图ID: %s' % map_id
            })
        except Map.DoesNotExist:
            return Response({
                'code': -2,
                'msg': '不存在这个地图',
            })
