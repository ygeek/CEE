from __future__ import unicode_literals
from django.conf.urls import url
from . import views

urlpatterns = [
    url(r'^$', views.index, name='cms-index'),
    url(r'^uptoken/$', views.QiniuUptoken.as_view()),
    url(r'^downtoken/$', views.QiniuDowntoken.as_view()),
    url(r'^users/$', views.UserList.as_view(), name='cms-users'),
    url(r'^user/add/$', views.AddUser.as_view(), name='cms-add-user'),
    url(r'^user/(?P<pk>[0-9]+)/$', views.UserDetail.as_view(), name='cms-user-detail'),
    url(r'^user/(?P<pk>[0-9]+)/delete/$', views.DeleteUser.as_view(), name='cms-delete-user'),
    url(r'^user/(?P<pk>[0-9]+)/change_password/$', views.ChangeUserPassword.as_view(), name='cms-change-user-password'),
    url(r'^coupons/$', views.CouponList.as_view(), name='cms-coupons'),
    url(r'^coupon/add/', views.AddCoupon.as_view(), name='cms-add-coupon'),
    url(r'^coupon/(?P<pk>[0-9]+)/edit/', views.EditCoupon.as_view(), name='cms-edit-coupon'),
    url(r'^maps/$', views.MapList.as_view(), name='cms-maps'),
    url(r'^map/add/$', views.AddMap.as_view(), name='cms-add-map'),
    url(r'^map/(?P<pk>[0-9]+)/$', views.MapDetail.as_view(), name='cms-map-detail'),
    url(r'^map/(?P<pk>[0-9]+)/edit/$', views.EditMap.as_view(), name='cms-edit-map'),
    url(r'^map/(?P<pk>[0-9]+)/delete/$', views.DeleteMap.as_view(), name='cms-delete-map'),
    url(r'^stories/$', views.StoryList.as_view(), name='cms-stories'),
    url(r'^story/add/$', views.AddStory.as_view(), name='cms-add-story'),
    url(r'^story/(?P<pk>[0-9]+)/edit/$', views.EditStory.as_view(), name='cms-edit-story'),
    url(r'^story/(?P<pk>[0-9]+)/delete/$', views.DeleteStory.as_view(), name='cms-delete-story'),

    url(r'^story/(?P<story_id>[0-9]+)/items/$', views.ItemList.as_view(), name='cms-item-list'),
    url(r'^story/(?P<story_id>[0-9]+)/item/add/$', views.AddItem.as_view(), name='cms-add-item'),
    url(r'^story/(?P<story_id>[0-9]+)/item/(?P<pk>[0-9]+)/edit/$', views.EditItem.as_view(), name='cms-edit-item'),
    url(r'^story/(?P<story_id>[0-9]+)/item/(?P<pk>[0-9]+)/delete/$', views.DeleteItem.as_view(),
        name='cms-delete-item'),

    url(r'^story/(?P<story_id>[0-9]+)/levels/$', views.LevelList.as_view(), name='cms-level-list'),
    url(r'^story/(?P<story_id>[0-9]+)/level/add/$', views.AddLevel.as_view(), name='cms-add-level'),
    url(r'^story/(?P<story_id>[0-9]+)/level/(?P<pk>[0-9]+)/delete/$', views.DeleteLevel.as_view(),
        name='cms-delete-level')
]
