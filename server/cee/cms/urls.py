from __future__ import unicode_literals
from django.conf.urls import url
from . import views


urlpatterns = [
    url(r'^$', views.index, name='cms-index'),
    url(r'^users/$', views.UserList.as_view(), name='cms-users'),
    url(r'^user/add/$', views.AddUser.as_view(), name='cms-add-user'),
    url(r'^user/(?P<pk>[0-9]+)/$', views.UserDetail.as_view(), name='cms-user-detail'),
    url(r'^user/(?P<pk>[0-9]+)/delete/$', views.DeleteUser.as_view(), name='cms-delete-user'),
    url(r'^user/(?P<pk>[0-9]+)/edit/$', views.UpdateUser.as_view(), name='cms-edit-user'),
    url(r'^coupons/$', views.CouponList.as_view(), name='cms-coupons'),
    url(r'^maps/$', views.MapList.as_view(), name='cms-maps'),
    url(r'^map/(?P<pk>[0-9]+)/$', views.MapDetail.as_view(), name='cms-map-detail'),
    url(r'^stories/$', views.StoryList.as_view(), name='cms-stories'),
    url(r'^map/(?P<pk>[0-9]+)/$', views.StoryDetail.as_view(), name='cms-story-detail')
]
