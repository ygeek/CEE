# -*- coding: utf-8 -*-

from __future__ import unicode_literals
from __future__ import absolute_import

from rest_framework.views import APIView
from rest_framework.response import Response
from ..models.task import *
from ..serializers.task import *


class TaskDetail(APIView):
    def get(self, request, task_id):
        try:
            task_id = int(task_id)
            task = Task.objects.get(id=task_id)
            serializer = TaskSerializer(task)
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


class AnchorTask(APIView):
    def get(self, request, anchor_id):
        try:
            anchor_id = int(anchor_id)
            anchor = Anchor.objects.get(id=anchor_id)
            anchor_task = anchor.anchor_task.all()
            serializer = AnchorTaskSerializer(anchor_task, many=True)
            return Response({
                'code': 0,
                'task': serializer.data,
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


class ChoiceDetail(APIView):
    def get(self, request, choice_id):
        try:
            choice_id = int(choice_id)
            choice = Choice.objects.get(id=choice_id)
            serializer = ChoiceSerializer(choice)
            return Response({
                'code': 0,
                'choice': serializer.data,
            })
        except ValueError:
            return Response({
                'code': -1,
                'msg': 'invalid choice id: %s' % choice_id
            })
        except Choice.DoesNotExist:
            return Response({
                'code': -2,
                'msg': 'choice not exists',
            })


class ChoiceList(APIView):
    def get(self, request, task_id):
        try:
            task_id = int(task_id)
            task = Task.objects.get(id=task_id)
            choices = task.choices.all()
            serializer = ChoiceSerializer(choices, many=True)
            return Response({
                'code': 0,
                'choices': serializer.data,
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


class OptionDetail(APIView):
    def get(self, request, option_id):
        try:
            option_id = int(option_id)
            option = Option.objects.get(id=option_id)
            serializer = OptionSerializer(option)
            return Response({
                'code': 0,
                'option': serializer.data
            })
        except ValueError:
            return Response({
                'code': -1,
                'msg': 'invalid option id: %s' % option_id
            })
        except Option.DoesNotExist:
            return Response({
                'code': -2,
                'msg': 'option not exists',
            })


class OptionList(APIView):
    def get(self, request, choice_id):
        try:
            choice_id = int(choice_id)
            choice = Choice.objects.get(id=choice_id)
            options = choice.options.all()
            serializer = OptionSerializer(options, many=True)
            return Response({
                'code': 0,
                'options': serializer.data
            })
        except ValueError:
            return Response({
                'code': -1,
                'msg': 'invalid choice id: %s' % choice_id
            })
        except Choice.DoesNotExist:
            return Response({
                'code': -2,
                'msg': 'choice not exists',
            })
