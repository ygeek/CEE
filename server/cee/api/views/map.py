# -*- coding: utf-8 -*-

from __future__ import unicode_literals
from __future__ import absolute_import

from rest_framework.views import APIView
from rest_framework.response import Response
from ..models import User, Map
from ..serializers import UserMapSerializer, MapSerializer


class UserMapList(APIView):
    def get(self, request, user_id):
        try:
            user_id = int(user_id)
            user = User.objects.get(id=user_id)
            user_maps = user.user_maps.all()
            serializer = UserMapSerializer(user_maps, many=True)
            return Response({
                'code': 0,
                'medals': serializer.data
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


class MapDetail(APIView):
    def get(self, request, map_id):
        try:
            map_id = int(map_id)
            map = Map.objects.get(id=map_id)
            serializer = MapSerializer(map)
            return Response({
                'code': 0,
                'map': serializer.data
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
