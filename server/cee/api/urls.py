# -*- coding: utf-8 -*-

from django.conf.urls import url
from rest_framework.authtoken import views
from .views import hello, register


urlpatterns = [
    url(r'^v1/hello/$', hello),
    url(r'^v1/register/$', register),
    url(r'^v1/auth/$', views.obtain_auth_token),
]
