# -*- coding: utf-8 -*-

from __future__ import absolute_import
from __future__ import unicode_literals


from rest_framework.views import APIView
from rest_framework.response import Response
from ..models import Anchor
from ..serializers import AnchorSerializer, MapAnchorSerializer

class AnchorDetail(APIView):
    def get(self, request, anchor_id):
        try:
            anchor_id = int(anchor_id)
            anchor = Anchor.objects.get(id=anchor_id)
            serializer = AnchorSerializer(anchor)
            return Response({
                'code': 0,
                'anchor': serializer.data
            })
        except ValueError:
            return Response({
                'code': -1,
                'msg': 'invalid anchor id: %s' % anchor_id
            })
        except Anchor.DoesNotExist:
            return Response({
                'code': -2,
                'msg': 'anchor not exists',
            })


class MapAnchorList(APIView):
    def get(self, request, map_id):
        try:
            map_id = int(map_id)
            map = Map.objects.get(id=map_id)
            map_anchors = map.map_anchors.all()
            serializer = MapAnchorSerializer(map_anchors, many=True)
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
