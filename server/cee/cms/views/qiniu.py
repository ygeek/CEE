from __future__ import absolute_import, unicode_literals

import qiniu
import urllib
from django.utils.decorators import method_decorator
from django.views.decorators.csrf import csrf_exempt
from django.views.generic import View
from django.http import JsonResponse

from api.config import QiniuConfig


class QiniuUptoken(View):
    def get(self, request):
        if request.user.is_active and request.user.is_staff:
            q = qiniu.Auth(QiniuConfig.ACCESS_KEY, QiniuConfig.SECRET_KEY)
            token = q.upload_token(QiniuConfig.BUCKET_NAME)
            return JsonResponse({
                'uptoken': token,
            })
        else:
            return JsonResponse({}, status=403)


@method_decorator(csrf_exempt, name='dispatch')
class QiniuDowntoken(View):
    def post(self, request):
        if request.user.is_active and request.user.is_staff:
            params = dict([kv.split('=') for kv in urllib.unquote(request.body).split('&')])
            key, domain = params['key'], params['domain']
            q = qiniu.Auth(QiniuConfig.ACCESS_KEY, QiniuConfig.SECRET_KEY)
            base_url = 'http://{0}/{1}'.format(domain, key)
            private_url = q.private_download_url(base_url)
            return JsonResponse({
                'url': private_url,
            })
        else:
            return JsonResponse({}, status=403)
