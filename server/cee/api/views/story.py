# -*- coding: utf-8 -*-

from __future__ import absolute_import
from __future__ import unicode_literals


from rest_framework.views import APIView
from rest_framework.response import Response
from ..models import Story
from ..serializers import StorySerializer


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
