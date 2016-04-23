# -*- coding: utf-8 -*-

from __future__ import absolute_import
from __future__ import unicode_literals


from django.db import models
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from ..models.story import *
from ..models.auth import *
from ..serializers.story import *


# TODO(stareven): city
class CityStoryList(APIView):
    def get(self, request, city_id):
        try:
            city_id = int(city_id)
            city = City.objects.get(id=city_id)
            city_storys = city.city_storys.all()
            for cs in city_storys:
                user_story, created = UserStory.objects.get_or_create(
                    defaults={'completed': False, 'level_step': 0},
                    user=request.user,
                    story=cs.story)
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


class StoryDetail(APIView):
    permission_classes = (IsAuthenticated, )

    def get(self, request, story_id):
        try:
            story_id = int(story_id)
            story = Story.objects.get(id=story_id)
            user_story, created = UserStory.objects.get_or_create(
                defaults={'completed': False, 'progress': 0},
                user=request.user,
                story=story)
            serializer = StorySerializer(story, user=request.user)
            return Response({
                'code': 0,
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


class CompleteStory(APIView):
    permission_classes = (IsAuthenticated, )

    def post(self, request, story_id):
        try:
            story_id = int(story_id)
            story = Story.objects.get(id=story_id)
            affect_rows = UserStory.objects.filter(
                user=request.user, story=story, completed=False).update(
                    completed=True)
            if affect_rows > 0:  # TODO(stareven): do not check affect_rows
                # TODO(stareven): coin change log
                UserCoin.objects.filter(user=request.user).update(
                    amount=models.F('amount') + story.coin)
                awards = [
                    {
                        'type': 'coin',
                        'detail': {
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


class StoryLevelList(APIView):
    permission_classes = (IsAuthenticated, )

    def get(self, request, story_id):
        try:
            story_id = int(story_id)
            story = Story.objects.get(id=story_id)
            UserStory.objects.get_or_create(user=request.user, story=story,
                                            defaults={
                                                'user': request.user,
                                                'story': story,
                                                'progress': 0,
                                                'completed': False})
            levels = story.levels.order_by('story_levels__order')
            serializer = LevelSerializer(levels, story=story, many=True)
            return Response({
                'code': 0,
                'levels': serializer.data,
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


class CompleteStoryLevel(APIView):
    permission_classes = (IsAuthenticated, )

    def post(self, request, story_id, level_id):
        # TODO(stareven): validate
        try:
            story_id = int(story_id)
            level_id = int(level_id)
            story = Story.objects.get(id=story_id)
            level = Level.objects.get(id=level_id)
            story_level = StoryLevel.objects.get(story=story, level=level)
            progress = story_level.order
            UserStory.objects.filter(user=request.user, story=story).update(
                progress=progress)
            # TODO(stareven): add coupon to user
            awards = []
            return Response({
                'code': 0,
                'awards': awards,
             })
        except ValueError:
            return Response({
                'code': -1,
                'msg': 'invalid task/level id: %s/%s' % (story_id, level_id),
            })
        except Story.DoesNotExist:
            return Response({
                'code': -2,
                'msg': 'story not exists',
            })
        except Level.DoesNotExist:
            return Response({
                'code': -3,
                'msg': 'level not exists',
            })
        except StoryLevel.DoesNotExist:
            return Response({
                'code': -4,
                'msg': 'level not in story',
            })


class StoryItemList(APIView):
    permission_classes = (IsAuthenticated, )

    def get(self, request, story_id):
        try:
            story_id = int(story_id)
            story = Story.objects.get(id=story_id)
            items = story.items
            serializer = ItemSerializer(items, many=True)
            return Response({
                'code': 0,
                'items': serializer.data,
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
