# -*- coding: utf-8 -*-

from __future__ import unicode_literals
from __future__ import absolute_import

from django.db import models
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from ..models.auth import *
from ..models.task import *
from ..serializers.task import *
from ..serializers.medal import *


class TaskDetail(APIView):
    permission_classes = (IsAuthenticated, )

    def get(self, request, task_id):
        try:
            task_id = int(task_id)
            task = Task.objects.get(id=task_id)
            user_task, created = UserTask.objects.get_or_create(
                defaults={'completed': False},
                user=request.user,
                task=task)
            if created:
                task.completed = False
            else:
                task.completed = user_task.completed
                UserCoin.objects.get_or_create(
                    defaults={'amount': 0},
                    user=request.user)
                affect_rows = UserCoin.objects.filter(
                    user=request.user, amount__gte=100).update(
                        amount=models.F('amount') - 100)
                if affect_rows == 0:
                    return Response({
                        'code': -3,
                        'msg': '金币不足',
                    })
            serializer = UserTaskSerializer(task)
            return Response({
                'code': 0,
                'task': serializer.data,
            })
        except ValueError:
            return Response({
                'code': -1,
                'msg': '任务id有问题: %s' % task_id,
            })
        except Task.DoesNotExist:
            return Response({
                'code': -2,
                'msg': '不存在的任务',
            })


class CompleteTask(APIView):
    permission_classes = (IsAuthenticated, )

    def post(self, request, task_id):
        try:
            task_id = int(task_id)
            task = Task.objects.get(id=task_id)
            affect_rows = UserTask.objects.filter(
                user=request.user, task=task, completed=False).update(
                    completed=True)
            awards = []
            if affect_rows > 0: # TODO(stareven): do not check affect_rows
                # TODO(stareven): coin change log
                UserCoin.objects.get_or_create(
                    defaults={'amount': 0},
                    user=request.user);
                UserCoin.objects.filter(user=request.user).update(
                    amount=models.F('amount') + task.coin)
                awards.append({
                    'type': 'coin',
                    'detail': {
                        'amount': task.coin,
                    }
                })
                try:
                    medal = task.medal
                    user_medal, created = UserMedal.objects.get_or_create(
                        user=request.user, medal=medal)
                    serializer = MedalSerializer(medal)
                    awards.append({
                        'type': 'medal',
                        'detail': serializer.data,
                    })
                except Medal.DoesNotExist:
                    pass
            else:
                awards = []
            return Response({
                'code': 0,
                'image_key': task.award_image_key,
                'awards': awards,
            })
        except ValueError:
            return Response({
                'code': -1,
                'msg': '非法的任务id: %s' % task_id,
            })
        except Task.DoesNotExist:
            return Response({
               'code': -2,
               'msg': '这是一个不存在的任务',
            })
