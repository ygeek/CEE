# -*- coding: utf-8 -*-

from __future__ import absolute_import
from __future__ import unicode_literals


from rest_framework.views import APIView
from rest_framework.response import Response
from ..models.story import *
from ..serializers.story import *


class LevelDetail(APIView):
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
            serializer = StoryLevelSerializer(story_levels, many=True)
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
