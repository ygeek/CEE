# -*- coding: utf-8 -*-

from __future__ import absolute_import
from __future__ import unicode_literals

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
            anchors = map_.anchors.all()
            serializer = AnchorSerializer(anchors,
                                          user=request.user,
                                          many=True)
            return Response({
                'code': 0,
                'anchors': serializer.data
            })
        except ValueError:
            return Response({
                'code': -1,
                'msg': 'invalid map id: %s' % map_id
            })
        except Map.DoesNotExist:
            return Response({
                'code': -2,
                'msg': 'map not exists',
            })
