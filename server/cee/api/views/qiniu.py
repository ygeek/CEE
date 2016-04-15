# -*- coding: utf-8 -*-

from __future__ import unicode_literals
from __future__ import absolute_import

import qiniu
from rest_framework.views import APIView
from rest_framework.permissions import IsAdminUser
from rest_framework.response import Response
from rest_framework.status import HTTP_400_BAD_REQUEST
from ..config import QiniuConfig


class UploadTokenView(APIView):
    permission_classes = (IsAdminUser,)

    def get(self, request, key=None):
        if not key:
            content = {'code': -1,
                       'msg': 'missing parameter "key"'}
            return Response(data=content, status=HTTP_400_BAD_REQUEST)
        q = qiniu.Auth(QiniuConfig.ACCESS_KEY, QiniuConfig.SECRET_KEY)
        token = q.upload_token(QiniuConfig.BUCKET_NAME, key)

        return Response({
            'code': 0,
            'upload_token': token,
        })
