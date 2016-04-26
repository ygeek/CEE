# -*- coding: utf-8 -*-

from __future__ import unicode_literals
from __future__ import absolute_import

import math
import geohash
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from ..models.map import *
from ..serializers.map import *
from ..serializers.medal import *


class NearestMap(APIView):
    permission_classes = (IsAuthenticated, )

    def get(self, request, longitude, latitude):
        try:
            longitude = float(longitude)
            latitude = float(latitude)
            # precision:
            #   8       19m
            #   7       76m
            #   6       610m
            #   5       2.4km
            #   4       20km
            #   3       78km
            #   2       630km
            #   1       2500km
            for precision in [6, 5, 4]:
                resp = self._findNearestMap(request.user,
                                            longitude,
                                            latitude,
                                            precision)
                if resp: return resp
            return Response({
                'code': -2,
                'msg': 'no map around',
            })
        except ValueError:
            return Response({
                'code': -1,
                'msg': 'invalid location: (%s,%s)' % (longitude, latitude)
            })

    @classmethod
    def _findNearestMap(cls, user, longitude, latitude, precision):
        hashcode = geohash.encode(latitude,
                                  longitude,
                                  precision=precision)
        hashcodes = geohash.expand(hashcode)
        maps = []
        for hashcode in hashcodes:
            # TODO(stareven): count limit
            for map_ in Map.objects.filter(geohash__startswith=hashcode):
                try:
                    user_map = UserMap.objects.get(user=user, map=map_)
                    if not user_map.completed:
                        maps.append(map_)
                except UserMap.DoesNotExist:
                    maps.append(map_)
        if not maps: return None
        map_ = min(maps,
                   key=lambda map_: cls._haversine(map_.longitude,
                                                   map_.latitude,
                                                   longitude,
                                                   latitude))
        user_map, created = UserMap.objects.get_or_create(
            defaults={'completed': False},
            user=user,
            map=map_)
        serializer = MapSerializer(map_, user=user)
        return Response({
            'code': 0,
            'map': serializer.data
        })

    @staticmethod
    def _haversine(lon1, lat1, lon2, lat2):
        r = 6371
        lon1, lat1, lon2, lat2 = map(math.radians, [lon1, lat1, lon2, lat2])
        dlon = lon2 - lon1
        dlat = lat2 - lat1
        a = math.sin(dlat / 2) ** 2 + math.cos(lat1) * math.cos(lat2) * math.sin(dlon / 2) ** 2
        c = 2 * math.asin(math.sqrt(a))
        return c * r * 1000


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
