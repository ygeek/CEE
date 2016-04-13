from __future__ import unicode_literals
import hashlib
import uuid

from django.contrib.auth import authenticate
from django.db.models import ObjectDoesNotExist
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


class Hello(APIView):
    def get(self, request):
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


def get_token(user):
    try:
        token = Token.objects.get(user=user)
    except ObjectDoesNotExist:
        token = Token.objects.create(user=user)
    return token


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
        except ObjectDoesNotExist:
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
        print(repr(request.data))
        device_token = request.data['device_token']
        installation_id = request.data['installation_id']
        try:
            user_token = UserDeviceToken.objects.get(user=user)
            user_token.device_token = device_token
            user_token.installation_id = installation_id
            code = 1
            msg = 'device token updated'
        except ObjectDoesNotExist:
            UserDeviceToken.objects.create(user=user,
                                           device_token=device_token,
                                           installation_id=installation_id)
            code = 0
            msg = 'device token registered'
        return Response({
            'code': code,
            'msg': msg,
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


class StoryDetail(APIView):
    def get(self, request, story_id):
        try:
            story_id = int(story_id)
            story = Story.objects.get(story_id=story_id)
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


class CouponDetail(APIView):
    def get(self, request, coupon_id):
        try:
            coupon_id = int(coupon_id)
            coupon = Coupon.objects.get(coupon_id=coupon_id)
            serializer = CouponSerializer(coupon)
            return Response({
                'code': 0,
                'coupon': serializer.data
            })
        except ValueError:
            return Response({
                'code': -1,
                'msg': 'invalid coupon id: %s' % coupon_id
            })
        except Coupon.DoesNotExist:
            return Response({
                'code': -2,
                'msg': 'coupon not exists',
            })


class CouponList(APIView):
    def get(self, request, user_id):
        try:
            user_id = int(user_id)
            user = User.objects.get(user_id=user_id)
            coupons = user.choice_set.all()
            serializer = CouponSerializer(coupons, many=True)
            return Response({
                'code': 0,
                'coupons': serializer.data
            })
        except ValueError:
            return Response({
                'code': -1,
                'msg': 'invalid user id: %s' % user_id
            })
        except User.DoesNotExist:
            return Response({
                'code': -2,
                'msg': 'user not exists',
            })
