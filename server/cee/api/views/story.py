# -*- coding: utf-8 -*-

from __future__ import absolute_import
from __future__ import unicode_literals


from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from ..models.story import *
from ..serializers.story import *


class StoryDetail(APIView):
    permission_classes = (IsAuthenticated, )

    def get(self, request, story_id):
        try:
            story_id = int(story_id)
            story = Story.objects.get(id=story_id)
            user_story, created = UserStory.objects.get_or_create(
                defaults = {'completed': False,'level_step':0},
                user = request.user,
                story = story)
            serializer = StorySerializer(story)
            return Response({
                'code': 0,
                'completed': user_story.completed,
                'story': serializer.data,
            })
        except ValueError:
            return Response({
                'code': -1,
                'msg': 'invalid story id: %s' % story_id,
            })
        except Story.DoesNotExist:
            return Response({
                'code': -2,
                'msg': 'story not exists',
            })


class CompletedStory(APIView):
    permission_classes = (IsAuthenticated, )

    def post(self, request, story_id):
        try:
            story_id = int(story_id)
            story = Story.objects.get(id=story_id)
            affect_rows = UserStory.objects.filter(
                user=request.user, story = story, completed=False).update(
                    completed=True)
            if affect_rows > 0:
                awards = [
                    {
                        'type': 'coin',
                        'detail':{
                            'amount': story.coin,
                        }
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
                'awards': 'invalid story id: %s' % story_id,
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
            for cs in city_storys:
                user_story, created = UserStory.objects.get_or_create(
                    defaults = {'completed': False,'level_step': 0},
                    user = request.user,
                    story = cs.story)
            storys = [cs.story for cs in city_storys]
            serializer = StorySerializer(storys, many=True)
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
            for ans in anchor_story:
                user_story, created = UserStory.objects.get_or_create(
                    defaults = {'completed': False,'level_step': 0},
                    user = request.user,
                    story = ans.story)
            storys = [ans.story for ans in anchor_story]
            serializer = AnchorStorySerializer(storys)
            return Response({
                'code': 0,
                'completed': user_story.completed,
                'story': serializer.data,
            })
        except ValueError:
            return Response({
                'code': -1,
                'msg': 'invalid anchor id: %s' % anchor_id,
            })
        except Anchor.DoesNotExist:
            return Response({
                'code': -2,
                'msg': 'anchor not exists',
            })
