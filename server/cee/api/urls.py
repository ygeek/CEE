# -*- coding: utf-8 -*-

from django.conf.urls import url
from rest_framework.authtoken import views
from .views import *


def remove_space(s):
    return ''.join(s.split())


urlpatterns = [
    url(r'^v1/auth/$', views.obtain_auth_token),
    url(r'^v1/hello/$', Hello.as_view()),
    url(r'^v1/register/$', Register.as_view()),
    url(r'^v1/login/$', Login.as_view()),
    url(r'^v1/login/thirdparty/$', LoginThirdParty.as_view()),
    url(r'^v1/devicetoken/$', UserDeviceTokenView.as_view()),
    url(r'^v1/userprofile/$', UserProfileView.as_view()),

    url(r'^v1/uploadtoken/$', UploadTokenView.as_view()),
    url(r'^v1/downloadurl/(?P<key>[\w\-]+)/$', PrivateDownloadURL.as_view()),

    url(r'^v1/item/(?P<item_id>\d+)/$', ItemDetail.as_view()),
    url(r'^v1/user/(?P<user_id>\d+)/item/$', UserItemList.as_view()),

    # User(open)
    url(r'^v1/user/medals/$', UserMedalList.as_view()),
    url(r'^v1/user/friends/$', UserFriendList.as_view()),
    url(r'^v1/user/info/$', UserInfo.as_view()),
    url(r'^v1/user/addfriends/', AddFriends.as_view()),

    # Map
    url(remove_space(
        r'''^v1/
        city/(?P<city_key>\w+)/
        map/nearest/(?P<longitude>[0-9.]+),
                    (?P<latitude>[0-9.]+)/
        $'''),
        NearestMap.as_view()),
    url(remove_space(
        r'''^v1/
        map/nearest/(?P<longitude>[0-9.]+),
                    (?P<latitude>[0-9.]+)/
        $'''),
        NearestMap.as_view()),
    url(r'^v1/map/acquired/$', AcquiredMapList.as_view()),
    url(r'^v1/map/(?P<map_id>\d+)/complete/$', CompleteMap.as_view()),
    url(r'^v1/map/completed/count/$', CompletedMapCount.as_view()),
    # Anchor
    url(r'^v1/map/(?P<map_id>\d+)/anchor/$', MapAnchorList.as_view()),
    # Task
    url(r'^v1/task/(?P<task_id>\d+)/$', TaskDetail.as_view()),
    url(r'^v1/task/(?P<task_id>\d+)/complete/$', CompleteTask.as_view()),
    # Story
    url(r'^v1/city/(?P<city_key>\w+)/story/$', CityStoryList.as_view()),
    url(r'^v1/story/(?P<story_id>\d+)/$', StoryDetail.as_view()),
    url(r'^v1/story/started/$', StartedStoryList.as_view()),
    url(r'^v1/story/(?P<story_id>\d+)/level/$', StoryLevelList.as_view()),
    url(r'^v1/story/(?P<story_id>\d+)/item/$', StoryItemList.as_view()),
    url(r'^v1/story/(?P<story_id>\d+)/complete/$', CompleteStory.as_view()),
    url(r'^v1/story/(?P<story_id>\d+)/level/(?P<level_id>\d+)/complete/$',
        CompleteStoryLevel.as_view()),
    # Coupon
    url(r'^v1/coupon/$', UserCouponList.as_view()),
    url(r'^v1/coupon/(?P<uuid_>[-a-z0-9]{36})/consume/$',
        ConsumeCoupon.as_view()),

    # Message
    url(r'^v1/messages/(?P<timestamp>\d+)/', UserMessageList.as_view()),
    url(r'^v1/message/(?P<message_id>\d+)/read/', UserMessageMarkRead.as_view()),
]
