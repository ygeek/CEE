# -*- coding: utf-8 -*-

from __future__ import unicode_literals
from __future__ import absolute_import

#import qiniu
from rest_framework.views import APIView
from rest_framework.permissions import IsAdminUser
from rest_framework.response import Response
from ..config import QiniuConfig


class UploadTokenView(APIView):
    permission_classes = (IsAdminUser,)

    def get(self, request, key):
        q = qiniu.Auth(QiniuConfig.ACCESS_KEY, QiniuConfig.SECRET_KEY)
        token = q.upload_token(QiniuConfig.BUCKET_NAME, key)
        return Response({
            'code': 0,
            'upload_token': token,
        })


class PrivateDownloadURL(APIView):
    def get(self, request, key):
        q = qiniu.Auth(QiniuConfig.ACCESS_KEY, QiniuConfig.SECRET_KEY)
        base_url = 'http://{0}/{1}'.format(QiniuConfig.BUCKET_DOMAIN, key)
        private_url = q.private_download_url(base_url)
        return Response({
            'code': 0,
            'private_url': private_url,
        })
