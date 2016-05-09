# -*- coding: utf-8 -*-

from __future__ import absolute_import
from __future__ import unicode_literals

from rest_framework.views import APIView
from rest_framework.response import Response


from .auth import *
from .map import *
from .story import *
from .task import *
from .coupon import *
from .medal import *
from .qiniu import *
from .anchor import *
from .level import *
from .item import *
from .userInfo import *
from .message import *


class Hello(APIView):
    """ Example view """

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
