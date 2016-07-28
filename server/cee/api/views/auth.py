# -*- coding: utf-8 -*-

from __future__ import absolute_import
from __future__ import unicode_literals
import hashlib
import uuid
import time
import datetime
import logging
import requests

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
    permission_classes = ()

    def post(self, request):
        user_form = UserForm(request.data)
        if user_form.is_valid():
            user = User(username=user_form.cleaned_data['username'])
            user.set_password(user_form.cleaned_data['password'])
            user.save()
            user_mobile = UserMobile(user=user, mobile=user.username)
            user_mobile.save()
            token = Token.objects.create(user=user)
            return Response({
                'code': 0,
                'auth': unicode(token.key),
            })
        else:
            msg = ''
            for field in user_form.errors:
                for error in user_form.errors[field]:
                    msg += error
                    msg += '\n'
            return Response({
                'code': -1,
                'msg': msg,
            })


class ResetPassword(APIView):
    permission_classes = ()

    def post(self, request):
        username = request.data['username']
        password = request.data['password']
        code = request.data['code']
        response = requests.post('https://webapi.sms.mob.com/sms/verify',
                                 data={'appkey': '11e838894b027',
                                       'phone': username,
                                       'zone': '86',
                                       'code': code})
        if response.status_code == 200 and response.json().get('status') == 200:
            try:
                user = User.objects.get(username=username)
                user.set_password(password)
                user.save()
                token = get_token(user)
                return Response({
                    'code': 0,
                    'auth': unicode(token.key),
                })
            except User.DoesNotExist:
                return Response({
                    'code': -2,
                    'msg': '没有这个用户'
                })
        else:
            return Response({
                'code': -1,
                'msg': '短信验证失败'
            })


class Login(APIView):
    permission_classes = ()

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
                    if profile.head_img_key:
                        user_info['head_img_key'] = profile.head_img_key
                    if profile.sex:
                        user_info['sex'] = profile.sex
                    if profile.birthday:
                        user_info['birthday'] = time.mktime(profile.birthday.timetuple())
                    if profile.location:
                        user_info['location'] = profile.location
                    if profile.mobile:
                        user_info['mobile'] = profile.mobile
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
                    'msg': '当前帐号不可用',
                })
        else:
            return Response({
                'code': -1,
                'msg': '用户名或密码不正确',
            })


class LoginThirdParty(APIView):
    permission_classes = ()

    def post(self, request):
        access_token = request.data['access_token']
        uid = request.data['uid']
        platform = request.data['platform']

        auth_failed = Response({
            'code': -1,
            'msg': '验证失败，请重试'
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
                'msg': '不支持该第三方帐号登录'
            })

        try:
            account = ThirdPartyAccount.objects.get(uid=uid, platform=platform)
            user = account.user
        except ThirdPartyAccount.DoesNotExist:
            fake_username = '{0}_{1}'.format(platform, hashlib.sha1(uid).hexdigest())
            fake_email = '{0}@cee{1}.com'.format(fake_username, platform)
            user = User.objects.create_user(username=fake_username, email=fake_email, password=unicode(uuid.uuid1()))
            ThirdPartyAccount.objects.create(uid=uid, platform=platform, user=user)

        token = get_token(user)
        try:
            profile = UserProfile.objects.get(user=user)
            serializer = UserProfileSerializer(profile)
            data = serializer.data.copy()
            data['username'] = user.username
            return Response({
                'code': 0,
                'auth': token.key,
                'username': user.username,
                'user': data,
            })
        except UserProfile.DoesNotExist:
            return Response({
                'code': 0,
                'auth': token.key,
                'username': user.username,
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
            user_token.save()
            code = 0
            msg = 'Device Token 更新成功'
        except UserDeviceToken.DoesNotExist:
            UserDeviceToken.objects.create(user=user,
                                           device_token=device_token,
                                           installation_id=installation_id)
            code = 0
            msg = 'Device Token 注册成功'
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
            data['token'] = get_token(user).key
            return Response({
                'code': 0,
                'profile': data,
            })
        except UserProfile.DoesNotExist:
            return Response({
                'code': -1,
                'msg': '个人信息尚未填写',
            })

    def post(self, request):
        birthday_ts = 0
        try:
            birthday_ts = float(request.data.get('birthday'))
        except ValueError:
            logging.getLogger('debug').log(
                logging.DEBUG,
                'error birthday {0}'.format(repr(request.data.get('birthday'))))

        user = request.user
        nickname = request.data['nickname']
        head_img_key = request.data.get('head_img_key')
        sex = request.data.get('sex')
        birthday = None if birthday_ts is None else datetime.date.fromtimestamp(birthday_ts)
        mobile = request.data.get('mobile')
        if not mobile:
            try:
                user_mobile = UserMobile.objects.get(user=user)
                mobile = user_mobile.mobile
            except UserMobile.DoesNotExist:
                pass
        location = request.data.get('location')
        try:
            user_profile = UserProfile.objects.get(user=user)
            user_profile.nickname = nickname
            user_profile.head_img_key = head_img_key
            user_profile.sex = sex
            user_profile.birthday = birthday
            user_profile.mobile = mobile
            user_profile.location = location
            user_profile.save()
            code = 0
            msg = '个人信息更新成功'
        except UserProfile.DoesNotExist:
            UserProfile.objects.create(user=user,
                                       nickname=nickname,
                                       head_img_key=head_img_key,
                                       sex=sex,
                                       birthday=birthday,
                                       mobile=mobile,
                                       location=location)
            code = 0
            msg = '个人信息保存成功'
        return Response({
            'code': code,
            'msg': msg,
        })

