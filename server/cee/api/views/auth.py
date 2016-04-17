# -*- coding: utf-8 -*-

from __future__ import absolute_import
from __future__ import unicode_literals
import hashlib
import uuid

from django.contrib.auth import authenticate
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from rest_framework.authtoken.models import Token

from ..forms import UserForm
from ..models.auth import *


def get_token(user):
    try:
        token = Token.objects.get(user=user)
    except Token.DoesNotExist:
        token = Token.objects.create(user=user)
    return token


class Register(APIView):
    def post(self, request):
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


class Login(APIView):
    def post(self, request):
        username = request.data['username']
        password = request.data['password']
        user = authenticate(username=username, password=password)
        if user is not None:
            if user.is_active:
                token = get_token(user)
                return Response({
                    'code': 0,
                    'auth': token.key,
                })
            else:
                return Response({
                    'code': -2,
                    'msg': 'The user is not active.',
                })
        else:
            return Response({
                'code': -1,
                'msg': 'The username and password were incorrect.',
            })


class LoginThirdParty(APIView):
    def post(self, request):
        uid = request.data['uid']
        platform = request.data['platform']
        try:
            account = ThirdPartyAccount.objects.get(uid=uid, platform=platform)
            user = account.user
        except ThirdPartyAccount.DoesNotExist:
            fake_username = hashlib.sha1(uid).hexdigest()
            fake_email = '{0}@{0}.com'.format(fake_username)
            user = User.objects.create_user(username=fake_username, email=fake_email, password=unicode(uuid.uuid1()))
            ThirdPartyAccount.objects.create(uid=uid, platform=platform, user=user)
        token = get_token(user)
        return Response({
            'code': 0,
            'auth': token.key,
        })


class UserDeviceTokenView(APIView):
    permission_classes = (IsAuthenticated, )

    def post(self, request):
        user = request.user
        device_token = request.data['device_token']
        installation_id = request.data['installation_id']
        try:
            user_token = UserDeviceToken.objects.get(user=user)
            user_token.device_token = device_token
            user_token.installation_id = installation_id
            code = 1
            msg = 'device token updated'
        except UserDeviceToken.DoesNotExist:
            UserDeviceToken.objects.create(user=user,
                                           device_token=device_token,
                                           installation_id=installation_id)
            code = 0
            msg = 'device token registered'
        return Response({
            'code': code,
            'msg': msg,
        })
