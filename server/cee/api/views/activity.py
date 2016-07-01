# -*- coding: utf-8 -*-

from __future__ import unicode_literals
from __future__ import absolute_import

import datetime
from django.db import models
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from ..models.auth import *
from ..models.activity import *


class LoginAwards(APIView):
    permission_classes = (IsAuthenticated, )

    def post(self, request):
        check_awards = LoginAward.objects.filter(
            gmt_start__lte=datetime.date.today(),
            gmt_end__gte=datetime.date.today())
        awards = []
        for award in check_awards:
            user_login_award, created = UserLoginAward.objects.get_or_create(
                user=request.user,
                award=award)
            if created:
                UserCoin.objects.filter(user=request.user).update(
                    amount=models.F('amount') + award.coin)
                awards.append({
                    'type': 'coin',
                    'detail': {
                        'amount': award.coin,
                        'desc': award.desc,
                    }
                })
        return Response({
            'code': 0,
            'awards': awards,
        })

