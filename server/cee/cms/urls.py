from __future__ import unicode_literals
from django.conf.urls import url
from . import views


urlpatterns = [
    url(r'^$', views.index, name='cms-index'),
    url(r'^users/$', views.UserList.as_view(), name='cms-users'),
    url(r'^user/(?P<pk>[0-9]+)', views.UserDetail.as_view(), name='cms-user-detail')
]
