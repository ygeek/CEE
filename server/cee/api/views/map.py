# -*- coding: utf-8 -*-

from __future__ import unicode_literals
from __future__ import absolute_import

import math
import geohash
from django.db import models
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from ..models.map import *
from ..serializers.map import *
from ..serializers.medal import *


class NearestMap(APIView):
    permission_classes = (IsAuthenticated, )

    def get(self, request, longitude, latitude, city_key=None):
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
            for precision in [6, 5, 4, 3]:
                map_ = self._findNearestMap(request.user,
                                            city_key,
                                            longitude,
                                            latitude,
                                            precision)
                if map_ is None: continue
                serializer = UserMapSerializer(map_)
                return Response({
                    'code': 0,
                    'map': serializer.data
                })
            return Response({
                'code': -2,
                'msg': '附近没有发现地图',
            })
        except ValueError:
            return Response({
                'code': -1,
                'msg': '经纬度有问题: (%s,%s)' % (longitude, latitude)
            })

    @classmethod
    def _findNearestMap(cls,
                        user, city_key,
                        longitude, latitude, precision):
        hashcode = geohash.encode(latitude,
                                  longitude,
                                  precision=precision)
        args = {
            'nullp': 'IFNULL',  # for sqlite(ISNULL for MySQL)
            'user_id': user.id,
            'geohash': hashcode,
            'city': '',
        }
        if city_key is not None:
            args['city'] = 'AND city_id=%s' % city_key
        sql = '''
            SELECT api_map.id AS id,
                   name,
                   desc,
                   image_key,
                   %(nullp)s(completed, 0) AS completed
            FROM api_map
                LEFT JOIN api_usermap
                    ON api_map.id=api_usermap.map_id
            WHERE %(nullp)s(user_id, %(user_id)d)=%(user_id)d
              AND %(nullp)s(completed, 0)=0
              AND geohash LIKE '%(geohash)s%%'
              %(city)s
            LIMIT 1
        ''' % args
        maps = list(Map.objects.raw(sql))
        if not maps: return None
        map_ = maps[0]
        user_map, created = UserMap.objects.get_or_create(
            defaults={'completed': False},
            user=user,
            map=map_)
        return map_

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
        maps = request.user.maps.annotate(
            completed=models.F("user_maps__completed"))
        serializer = UserMapSerializer(maps, many=True)
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
