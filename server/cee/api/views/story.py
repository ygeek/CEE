# -*- coding: utf-8 -*-

from __future__ import absolute_import
from __future__ import unicode_literals


from django.db import models
from django.db import transaction
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from ..models.map import *
from ..models.story import *
from ..models.auth import *
from ..models.coupon import *
from ..serializers.story import *
from ..serializers.coupon import *


class CityStoryList(APIView):
    def get(self, request, city_key):
        try:
            city = City.objects.get(key=city_key)
            stories = city.stories if request.user.is_staff else city.stories.filter(published=True)
            serializer = UserStorySerializer(stories, many=True)
            return Response({
                'code': 0,
                'stories': serializer.data
            })
        except City.DoesNotExist:
            return Response({
                'code': -1,
                'msg': 'unknown city key: %s' % city_key
            })


class StoryDetail(APIView):
    permission_classes = (IsAuthenticated, )

    def get(self, request, story_id):
        try:
            story_id = int(story_id)
            story = Story.objects.get(id=story_id)
            user_story, created = UserStory.objects.get_or_create(
                defaults={
                    'completed': False,
                    'progress': 0,
                    'like': False},
                user=request.user,
                story=story)
            if created:
                story.completed = False,
                story.progress = 0
                story.like = False
                self._acquire_related_map(request.user, story)
            else:
                story.completed = user_story.completed
                story.progress = user_story.progress
                story.like = user_story.like
            serializer = UserStorySerializer(story)
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

    def _acquire_related_map(self, user, story):
        try:
            anchor = Anchor.objects.get(
                type=Anchor.Type.Story, ref_id=story.id)
            user_map, created = UserMap.objects.get_or_create(
                defaults={'completed': False},
                user=user,
                map_id=anchor.map_id)
        except Anchor.DoesNotExist:
            pass


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
                UserCoin.objects.get_or_create(
                    defaults={'amount': 0},
                    user=request.user);
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


class StartedStoryList(APIView):
    permission_classes = (IsAuthenticated, )

    def get(self, request):
        stories = request.user.stories.annotate(
            completed=models.F('user_stories__completed'),
            progress=models.F('user_stories__progress'),
            like=models.F('user_stories__like')).filter(
                progress__gt=0)
        serializer = UserStorySerializer(stories, many=True)
        return Response({
            'code': 0,
            'stories': serializer.data
        })


class StoryLevelList(APIView):
    permission_classes = (IsAuthenticated, )

    def get(self, request, story_id):
        try:
            story_id = int(story_id)
            story = Story.objects.get(id=story_id)
            UserStory.objects.get_or_create(
                user=request.user, story=story,
                defaults={
                    'user': request.user,
                    'story': story,
                    'progress': 0,
                    'completed': False,
                    'like': False})
            levels = story.levels.annotate(
                order=models.F('story_levels__order')
            ).order_by('story_levels__order')
            serializer = LevelSerializer(levels, many=True)
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
            progress = story_level.order + 1
            affect_rows = UserStory.objects.filter(
                user=request.user, story=story).update(
                    progress=progress)
            awards = []
            with transaction.atomic():
                level_coupons = LevelCoupon.objects.select_for_update().filter(
                    story=story, level=level, remain__gt=0)
                for level_coupon in level_coupons:
                    level_coupon.remain = models.F('remain') - 1
                    level_coupon.save(update_fields=['remain'])
                    user_coupon = UserCoupon.objects.create(
                        user=request.user,
                        coupon=level_coupon.coupon,
                        story=story,
                        level=level,
                        consumed=False)
                    user_coupon.coupon.uuid = user_coupon.uuid
                    user_coupon.coupon.consumed = user_coupon.consumed
                    serializer = UserCouponSerializer(user_coupon.coupon)
                    awards.append({
                        'type': 'coupon',
                        'detail': serializer.data,
                    })
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


class LikeStory(APIView):
    permission_classes = (IsAuthenticated, )

    def post(self, request, story_id, like):
        try:
            story_id = int(story_id)
            story = Story.objects.get(id=story_id)
            user_story, created = UserStory.objects.get_or_create(
                defaults={
                    'completed': False,
                    'progress': 0,
                    'like': False},
                user=request.user,
                story=story)
            affect_rows = UserStory.objects.filter(
                user=request.user, story=story).exclude(
                    like=like).update(
                        like=like)
            if affect_rows > 0:
                delta = affect_rows if like else -affect_rows
                Story.objects.filter(
                    id=story.id).update(
                        good=models.F('good') + delta)
            return Response({
                'code': 0,
                'msg': '操作成功',
            })

        except ValueError:
            return Response({
                'code': -1,
                'msg': '无效的故事ID: %s' % story_id,
            })
        except Story.DoesNotExist:
            return Response({
                'code': -2,
                'msg': '故事不存在',
            })

