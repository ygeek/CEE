# -*- coding: utf-8 -*-

from __future__ import absolute_import
from __future__ import unicode_literals


from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from ..models.story import *
from ..serializers.story import *


class LevelDetail(APIView):
    permission_classes = (IsAuthenticated, )

    def get(self, request, Level_id):
        try:
            level_id = int(level_id)
            level = Level.objects.get(id=level_id)
            serializer = LevelSerializer(level)
            return Response({
                'code': 0,
                'level': serializer.data
            })
        except ValueError:
            return Response({
                'code': -1,
                'msg': 'invalid level id: %s' % level_id
            })
        except Level.DoesNotExist:
            return Response({
                'code': -2,
                'msg': 'level not exists',
            })


class StoryLevelList(APIView):
    def get(self, request, story_id):
        try:
            story_id = int(story_id)
            story = Story.objects.get(id=story_id)
            story_levels = story.story_levels.all()
            levels = [sl.level for sl in story_levels]
            serializer = LevelSerializer(levels, many=True)
            return Response({
                'code': 0,
                'levels': serializer.data
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


class CompleteLevel(APIView):
    permission_classes = (IsAuthenticated, )

    def post(self, request, level_id):
        try:
            level_id = int(level_id)
            user_story = UserStory.objects.filter(
                request.user,request.story, completed=False).update(level_step=request.level_step)
            if affect > 0:
                    # get coupon
                    # add coupon to user
                try:
                    user_coin= UserCoin.objects.get(user=request.user)
                    coin = UserCoin.objects.get(request.user).coin + task.coin
                except UserCoin.DoesNotExist:
                    coin = 0

                user_coin, created = UserCoin.objects.get_or_create(
                    user = request.user,
                    coin = coin)

                awards = [
                    {
                        'type': 'coin',
                        'detail': {
                            'amount': task.coin
                        }
                    },
                    {
                        'type': 'coupon',
                        'detail':{
                            'amount': None # get coupon
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
                'msg': 'invalid level id: %s' % level_id,
            })
        except Level.DoesNotExist:
            return Response({
                'code': -2,
                'msg': 'level not exists',
            })
