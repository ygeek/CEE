# -*- coding: utf-8 -*-

from __future__ import unicode_literals
from __future__ import absolute_import

from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from ..models.map import *
from ..serializers.map import *
from ..serializers.medal import *


class NearestMap(APIView):
    permission_classes = (IsAuthenticated, )

    def get(self, request):
        # TODO(stareven): get nearest map
        map_id = 1
        map_ = Map.objects.get(id=map_id)
        user_map, created = UserMap.objects.get_or_create(
            defaults={'completed': False},
            user=request.user,
            map=map_)
        serializer = MapSerializer(map_, user=request.user)
        return Response({
            'code': 0,
            'map': serializer.data
        })


class AcquiredMapList(APIView):
    permission_classes = (IsAuthenticated, )

    def get(self, request):
        maps = request.user.maps
        serializer = MapSerializer(maps, user=request.user, many=True)
        return Response({
            'code': 0,
            'maps': serializer.data,
        })


class CompleteMap(APIView):
    permission_classes = (IsAuthenticated, )

    def post(self, request, map_id):
        # TODO(stareven): validate
        try:
            map_id = int(map_id)
            map_ = Map.objects.get(id=map_id)
            affect_rows = UserMap.objects.filter(
                user=request.user, map=map_, completed=False).update(
                    completed=True)
            if affect_rows > 0:
                serializer = MedalSerializer(map_.medal)
                awards = [
                    {
                        'type': 'medal',
                        'detail': serializer.data,
                    }
                ]
            else:
                awards = []
            return Response({
                'code': 0,
                'awards': awards,
            })
        except ValueError:
            return Response({
                'code': -1,
                'msg': 'invalid map id: %s' % map_id
            })
        except Map.DoesNotExist:
            return Response({
                'code': -2,
                'msg': 'map not exist'
            })
