from __future__ import unicode_literals

from django.shortcuts import render
from rest_framework import viewsets
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated
from rest_framework.request import Request
from rest_framework.response import Response
from rest_framework.authtoken.models import Token
from rest_framework.views import APIView
from .forms import UserForm, User
from .models import *
from .serializers import *


@api_view(['GET'])
def hello(request):
    if request.user and request.user.is_authenticated():
        return Response({
            'hello': 'world',
            'user': unicode(request.user),
            'auth': unicode(request.auth),
        })
    else:
        return Response({
            'hello': 'world'
        })


@api_view(['POST'])
def register(request):
    user_form = UserForm(request.data)
    if user_form.is_valid():
        if User.objects.filter(username=user_form.cleaned_data['username']).count() > 0:
            return Response({
                'code': -1,
                'msg': 'username exists'
            })
        if User.objects.filter(email=user_form.cleaned_data['email']).count() > 0:
            return Response({
                'code': -2,
                'msg': 'email exists'
            })
        user = user_form.save()
        token = Token.objects.create(user=user)
        return Response({
            'code': 0,
            'auth': unicode(token.key),
        })
    else:
        return Response({
            'code': -1,
            'msg': unicode(user_form.errors),
        })


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
            choices = task.choice_set.all()
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
            options = choice.option_set.all()
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


class MedalDetail(APIView):
    def get(self, request, medal_id):
        try:
            medal_id = int(medal_id)
            medal = Option.objects.get(id=medal_id)
            serializer = OptionSerializer(medal)
            return Response({
                'code': 0,
                'medal': serializer.data
            })
        except ValueError:
            return Response({
                'code': -1,
                'msg': 'invalid medal id: %s' % medal_id
            })
        except Option.DoesNotExist:
            return Response({
                'code': -2,
                'msg': 'medal not exists',
            })
