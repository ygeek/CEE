# -*- coding: utf-8 -*-

from __future__ import absolute_import
from __future__ import unicode_literals


from rest_framework.views import APIView
from rest_framework.response import Response
from ..models.story import *
from ..serializers.story import *


class ItemDetail(APIView):
    def get(self, request, item_id):
        try:
            item_id = int(item_id)
            item = Item.objects.get(id=item_id)
            serializer = ItemSerializer(item)
            return Response({
                'code': 0,
                'item': serializer.data
            })
        except ValueError:
            return Response({
                'code': -1,
                'msg': 'invalid item id: %s' % item_id
            })
        except Item.DoesNotExist:
            return Response({
                'code': -2,
                'msg': 'item not exists',
            })


class UserItemList(APIView):
    def get(self, request, user_id):
        try:
            user_id = int(user_id)
            user = User.objects.get(id=user_id)
            user_items = user.user_items.all()
            items = [ui.item for ui in user_items]
            serializer = ItemSerializer(items, many=True)
            return Response({
                'code': 0,
                'items': serializer.data
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
