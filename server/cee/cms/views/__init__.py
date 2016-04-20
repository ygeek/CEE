# coding=utf-8

from __future__ import unicode_literals

from django.shortcuts import render

from .user import *
from .coupon import *


def index(request):
    return render(request, "cms/index.html")

