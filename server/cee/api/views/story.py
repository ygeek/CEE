# -*- coding: utf-8 -*-

from __future__ import absolute_import
from __future__ import unicode_literals


from rest_framework.views import APIView
from rest_framework.response import Response
from ..models.story import *
from ..serializers.story import *


class StoryDetail(APIView):
    def get(self, request, story_id):
        try:
            story_id = int(story_id)
            story = Story.objects.get(id=story_id)
            serializer = StorySerializer(story)
            return Response({
                'code': 0,
                'story': serializer.data
            })
        except ValueError:
            return Response({
                'code': -1,
                'msg': 'invalid story id: %s' % story_id
            })
        except Story.DoesNotExist:
            return Response({
                'code': -2,
                'msg': 'story not exists',
            })


class CityStoryList(APIView):
    def get(self, request, city_id):
        try:
            city_id = int(city_id)
            city = City.objects.get(id=city_id)
            city_storys = city.city_storys.all()
            serializer = CityStorySerializer(city_storys, many=True)
            return Response({
                'code': 0,
                'storys': serializer.data
            })
        except ValueError:
            return Response({
                'code': -1,
                'msg': 'invalid city id: %s' % city_id
            })
        except City.DoesNotExist:
            return Response({
                'code': -2,
                'msg': 'city not exists',
            })


class AnchorStory(APIView):
    def get(self, request, anchor_id):
        try:
            anchor_id = int(anchor_id)
            anchor = Anchor.objects.get(id=anchor_id)
            anchor_story = anchor.anchor_story.all()
            serializer = AnchorStorySerializer(anchor_story)
            return Response({
                'code': 0,
                'story': serializer.data
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
