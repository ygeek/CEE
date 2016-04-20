# coding=utf-8

from __future__ import unicode_literals, print_function

from django.contrib.admin.views.decorators import staff_member_required
from django.contrib.auth.models import User
from django.shortcuts import render
from django.utils.decorators import method_decorator
from django.views.generic import ListView, DetailView


def index(request):
    return render(request, "cms/index.html")


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
