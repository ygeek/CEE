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
            serializer = TaskSerializer(task, user=request.user)
            return Response({
                'code': 0,
                'task': serializer.data,
            })
        except ValueError:
            return Response({
                'code': -1,
                'msg': 'invalid task id: %s' % task_id,
            })
        except Task.DoesNotExist:
            return Response({
                'code': -2,
                'msg': 'task not exists',
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
            if affect_rows > 0: # TODO(stareven): do not check affect_rows
                # TODO(stareven): coin change log
                UserCoin.objects.filter(user=request.user).update(
                    amount=models.F('amount') + task.coin)
                awards = [
                    {
                        'type': 'coin',
                        'detail': {
                            'amount': task.coin,
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
                'msg': 'invalid task id: %s' % task_id,
            })
        except Task.DoesNotExist:
            return Response({
               'code': -2,
                'msg': 'task not exists',
            })
