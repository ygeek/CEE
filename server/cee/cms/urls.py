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
    url(r'^coupon/(?P<pk>[0-9]+)/delete/', views.DeleteCoupon.as_view(), name='cms-delete-coupon'),

    url(r'^maps/$', views.MapList.as_view(), name='cms-maps'),
    url(r'^map/add/$', views.AddMap.as_view(), name='cms-add-map'),
    url(r'^map/(?P<pk>[0-9]+)/edit/$', views.EditMap.as_view(), name='cms-edit-map'),
    url(r'^map/(?P<pk>[0-9]+)/delete/$', views.DeleteMap.as_view(), name='cms-delete-map'),
    url(r'^map/(?P<map_id>[0-9]+)/anchors/$', views.AnchorList.as_view(), name='cms-anchor-list'),
    url(r'^map/(?P<map_id>[0-9]+)/anchor/add/$', views.AddAnchor.as_view(), name='cms-add-anchor'),
    url(r'^map/(?P<map_id>[0-9]+)/anchor/(?P<pk>[0-9]+)/edit/$', views.EditAnchor.as_view(), name='cms-edit-anchor'),
    url(r'^map/(?P<map_id>[0-9]+)/anchor/(?P<pk>[0-9]+)/delete/$', views.DeleteAnchor.as_view(),
        name='cms-delete-anchor'),
    url(r'^map/(?P<map_id>[0-9]+)/edit_medal/$', views.EditMedal.as_view(), name='cms-edit-medal'),

    url(r'^stories/$', views.StoryList.as_view(), name='cms-stories'),
    url(r'^story/add/$', views.AddStory.as_view(), name='cms-add-story'),
    url(r'^story/(?P<pk>[0-9]+)/edit/$', views.EditStory.as_view(), name='cms-edit-story'),
    url(r'^story/(?P<pk>[0-9]+)/delete/$', views.DeleteStory.as_view(), name='cms-delete-story'),

    url(r'^story/(?P<story_id>[0-9]+)/items/$', views.ItemList.as_view(), name='cms-item-list'),
    url(r'^story/(?P<story_id>[0-9]+)/item/add/$', views.AddItem.as_view(), name='cms-add-item'),
    url(r'^story/(?P<story_id>[0-9]+)/item/(?P<pk>[0-9]+)/edit/$', views.EditItem.as_view(), name='cms-edit-item'),
    url(r'^story/(?P<story_id>[0-9]+)/item/(?P<pk>[0-9]+)/delete/$', views.DeleteItem.as_view(),
        name='cms-delete-item'),

    url(r'^story/(?P<story_id>[0-9]+)/level/(?P<level_id>[0-9]+)/level_coupons/$', views.LevelCouponList.as_view(),
        name='cms-level-coupons'),
    url(r'^story/(?P<story_id>[0-9]+)/level/(?P<level_id>[0-9]+)/levelcoupon/add/$', views.AddLevelCoupon.as_view(),
        name='cms-add-levelcoupon'),
    url(r'^story/(?P<story_id>[0-9]+)/level/(?P<level_id>[0-9]+)/levelcoupon/(?P<pk>[0-9]+)/delete/$',
        views.DeleteLevelCoupon.as_view(), name='cms-delete-levelcoupon'),

    url(r'^story/(?P<story_id>[0-9]+)/levels/$', views.LevelList.as_view(), name='cms-level-list'),
    url(r'^story/(?P<story_id>[0-9]+)/level/add/$', views.AddLevel.as_view(), name='cms-add-level'),
    url(r'^story/(?P<story_id>[0-9]+)/level/(?P<pk>[0-9]+)/edit/$', views.EditLevel.as_view(), name='cms-edit-level'),
    url(r'^story/(?P<story_id>[0-9]+)/level/(?P<pk>[0-9]+)/delete/$', views.DeleteLevel.as_view(),
        name='cms-delete-level'),
    url(r'^tasks/$', views.TaskList.as_view(), name='cms-tasks'),
    url(r'^task/add/$', views.AddTask.as_view(), name='cms-add-task'),
    url(r'^task/(?P<pk>[0-9]+)/edit/$', views.EditTask.as_view(), name='cms-edit-task'),
    url(r'^task/(?P<pk>[0-9]+)/delete/$', views.DeleteTask.as_view(), name='cms-delete-task'),
    url(r'^task/(?P<task_id>[0-9]+)/choices/$', views.ChoiceList.as_view(), name='cms-choice-list'),
    url(r'^task/(?P<task_id>[0-9]+)/choice/add/$', views.AddChoice.as_view(), name='cms-add-choice'),
    url(r'^task/(?P<task_id>[0-9]+)/choice/(?P<pk>[0-9]+)/edit/$', views.EditChoice.as_view(), name='cms-edit-choice'),
    url(r'^task/(?P<task_id>[0-9]+)/choice/(?P<pk>[0-9]+)/delete/$', views.DeleteChoice.as_view(), name='cms-delete-choice'),
    url(r'^task/(?P<task_id>[0-9]+)/choice/(?P<choice_id>[0-9]+)/options/$', views.OptionList.as_view(), name='cms-option-list'),
    url(r'^task/(?P<task_id>[0-9]+)/choice/(?P<choice_id>[0-9]+)/option/add/$', views.AddOption.as_view(), name='cms-add-option'),
    url(r'^task/(?P<task_id>[0-9]+)/choice/(?P<choice_id>[0-9]+)/option/(?P<pk>[0-9]+)/edit/$', views.EditOption.as_view(), name='cms-edit-option'),
    url(r'^task/(?P<task_id>[0-9]+)/choice/(?P<choice_id>[0-9]+)/option/(?P<pk>[0-9]+)/delete/$', views.DeleteOption.as_view(), name='cms-delete-option'),
]
