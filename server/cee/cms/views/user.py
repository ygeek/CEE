# coding=utf-8

from __future__ import unicode_literals
from django.contrib.auth.models import User
from django.utils.decorators import method_decorator
from django.views.generic import ListView, DetailView
from django.contrib.admin.views.decorators import staff_member_required


@method_decorator(staff_member_required, name='dispatch')
class UserList(ListView):
    model = User
    template_name = 'cms/users.html'
    context_object_name = 'users'
    paginate_by = 20


@method_decorator(staff_member_required, name='dispatch')
class UserDetail(DetailView):
    model = User
    template_name = 'cms/user.html'
    context_object_name = 'user'
