# -*- coding: utf-8 -*-

from django.conf.urls import url
from rest_framework.authtoken import views
from .views import *


urlpatterns = [
    url(r'^v1/auth/$', views.obtain_auth_token),
    url(r'^v1/hello/$', Hello.as_view()),
    url(r'^v1/register/$', Register.as_view()),
    url(r'^v1/login/$', Login.as_view()),
    url(r'^v1/login/thirdparty/$', LoginThirdParty.as_view()),
    url(r'^v1/devicetoken/$', UserDeviceTokenView.as_view()),

    url(r'^v1/uploadtoken/(?P<key>\w+)/$', UploadTokenView.as_view()),
    url(r'^v1/downloadurl/(?P<key>\w+)/$', PrivateDownloadURL.as_view()),

    url(r'^v1/user/(?P<user_id>\d+)/map/$', UserMapList.as_view()),

    url(r'^v1/task/(?P<task_id>\d+)/$', TaskDetail.as_view()),
    url(r'^v1/task/(?P<task_id>\d+)/choice/$', ChoiceList.as_view()),
    url(r'^v1/choice/(?P<choice_id>\d+)/$', ChoiceDetail.as_view()),
    url(r'^v1/choice/(?P<choice_id>\d+)/option/$', OptionList.as_view()),
    url(r'^v1/option/(?P<option_id>\d+)/$', OptionDetail.as_view()),

    url(r'^v1/map/(?P<map_id>\d+)/$', MapDetail.as_view()),
    url(r'^v1/user/(?P<user_id>\d+)/medal/$', UserMedalList.as_view()),

    url(r'^v1/item/(?P<item_id>\d+)/$', ItemDetail.as_view()),
    url(r'^v1/user/(?P<user_id>\d+)/item/$', UserItemList.as_view()),

    url(r'^v1/anchor/(?P<anchor_id>\d+)/$', AnchorDetail.as_view()),
    url(r'^v1/anchor/(?P<anchor_id>\d+)/task/$', AnchorTask.as_view()),
    url(r'^v1/anchor/(?P<anchor_id>\d+)/story/$', AnchorStory.as_view()),

    url(r'^v1/level/(?P<level_id>\d+)/$', LevelDetail.as_view()),
    url(r'^v1/story/(?P<story_id>\d+)/level/$', StoryLevelList.as_view()),

    url(r'^v1/medal/(?P<medal_id>\d+)/$', MedalDetail.as_view()),
    url(r'^v1/user/(?P<user_id>\d+)/medal/$', UserMedalList.as_view()),

    url(r'^v1/story/(?P<story_id>\d+)/$', StoryDetail.as_view()),
    url(r'^v1/city/(?P<city_id>\d+)/story/$', CityStoryList.as_view()),
    url(r'^v1/coupon/(?P<coupon_id>\d+)/$', CouponDetail.as_view()),
    url(r'^v1/user/(?P<user_id>\d+)/coupon/$', UserCouponList.as_view()),
]
