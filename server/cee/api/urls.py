# -*- coding: utf-8 -*-

from django.conf.urls import url
from rest_framework.authtoken import views
from .views import Hello, Register, TaskDetail, ChoiceDetail, ChoiceList, OptionDetail, OptionList, MedalDetail


urlpatterns = [
    url(r'^v1/hello/$', Hello.as_view()),
    url(r'^v1/register/$', Register.as_view()),
    url(r'^v1/auth/$', views.obtain_auth_token),

    url(r'^v1/task/(?P<task_id>\d+)/$', TaskDetail.as_view()),
    url(r'^v1/task/(?P<task_id>\d+)/choice/$', ChoiceList.as_view()),
    url(r'^v1/choice/(?P<choice_id>\d+)/$', ChoiceDetail.as_view()),
    url(r'^v1/choice/(?P<choice_id>\d+)/option/$', OptionList.as_view()),
    url(r'^v1/option/(?P<option_id>\d+)/$', OptionDetail.as_view()),

    url(r'^v1/medal/(?P<medal_id>\d+)/$', MedalDetail.as_view()),
]
