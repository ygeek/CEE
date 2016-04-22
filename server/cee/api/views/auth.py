# -*- coding: utf-8 -*-

from __future__ import absolute_import
from __future__ import unicode_literals
import hashlib
import uuid
import time
import datetime

from django.contrib.auth import authenticate
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from rest_framework.authtoken.models import Token

from ..forms import UserForm
from ..models.auth import *
from ..services import verify_qq_openid, verify_weibo_openid, verify_weixin_openid
from ..serializers import UserProfileSerializer


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
                try:
                    profile = UserProfile.objects.get(user=user)
                    user_info = {'username': user.username}
                    if profile.nickname:
                        user_info['nickname'] = profile.nickname
                    if profile.head_url:
                        user_info['head_url'] = profile.head_url
                    if profile.sex:
                        user_info['sex'] = profile.sex
                    if profile.birthday:
                        user_info['birthday'] = time.mktime(profile.birthday.timetuple())
                    if profile.location:
                        user_info['location'] = profile.location
                    return Response({
                        'code': 0,
                        'auth': token.key,
                        'user': user_info,
                    })
                except UserProfile.DoesNotExist:
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
        access_token = request.data['access_token']
        uid = request.data['uid']
        platform = request.data['platform']
        try:
            account = ThirdPartyAccount.objects.get(uid=uid, platform=platform)
            user = account.user
        except ThirdPartyAccount.DoesNotExist:
            auth_failed = Response({
                'code': -1,
                'msg': 'auth failed'
            })
            if platform == 'weixin':
                if not verify_weixin_openid(access_token, uid):
                    return auth_failed
            elif platform == 'weibo':
                if not verify_weibo_openid(access_token, uid):
                    return auth_failed
            elif platform == 'qq':
                if not verify_qq_openid(access_token, uid):
                    return auth_failed
            else:
                return Response({
                    'code': -2,
                    'msg': 'unknown login platform'
                })
            fake_username = '{0}_{1}'.format(platform, hashlib.sha1(uid).hexdigest())
            fake_email = '{0}@cee_{1}.com'.format(fake_username, platform)
            user = User.objects.create_user(username=fake_username, email=fake_email, password=unicode(uuid.uuid1()))
            ThirdPartyAccount.objects.create(uid=uid, platform=platform, user=user)

        token = get_token(user)
        try:
            profile = UserProfile.objects.get(user=user)
            user_info = {'username': user.username}
            if profile.nickname:
                user_info['nickname'] = profile.nickname
            if profile.head_url:
                user_info['head_url'] = profile.head_url
            if profile.sex:
                user_info['sex'] = profile.sex
            if profile.birthday:
                user_info['birthday'] = time.mktime(profile.birthday.timetuple())
            if profile.location:
                user_info['location'] = profile.location
            return Response({
                'code': 0,
                'auth': token.key,
                'user': user_info,
            })
        except UserProfile.DoesNotExist:
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


class UserProfileView(APIView):
    permission_classes = (IsAuthenticated, )

    def get(self, request):
        user = request.user
        try:
            user_profile = UserProfile.objects.get(user=user)
            serializer = UserProfileSerializer(user_profile)
            data = serializer.data.copy()
            data['username'] = user.username
            data['token'] = get_token(user)
            return Response({
                'code': 0,
                'profile': serializer.data,
            })
        except UserProfile.DoesNotExist:
            return Response({
                'code': -1,
                'msg': 'User Profile not Exist',
            })

    def post(self, request):
        birthday_ts = float(request.data.get('birthday'))

        user = request.user
        nickname = request.data['nickname']
        head_img_key = request.data.get('head_img_key')
        sex = request.data.get('sex')
        birthday = None if birthday_ts is None else datetime.date.fromtimestamp(birthday_ts)
        mobile = request.data.get('mobile')
        location = request.data.get('location')
        try:
            user_profile = UserProfile.objects.get(user=user)
            user_profile.nickname = nickname
            user_profile.head_img_key = head_img_key
            user_profile.sex = sex
            user_profile.birthday = birthday
            user_profile.mobile = mobile
            user_profile.location = location
            code = 1
            msg = 'user profile updated'
        except UserProfile.DoesNotExist:
            UserProfile.objects.create(user=user,
                                       nickname=nickname,
                                       head_img_key=head_img_key,
                                       sex=sex,
                                       birthday=birthday,
                                       mobile=mobile,
                                       location=location)
            code = 0
            msg = 'user profile created'
        return Response({
            'code': code,
            'msg': msg,
        })

