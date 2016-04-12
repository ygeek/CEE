from __future__ import unicode_literals

from django.shortcuts import render
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated
from rest_framework.request import Request
from rest_framework.response import Response
from rest_framework.authtoken.models import Token
from .forms import UserForm, User


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
