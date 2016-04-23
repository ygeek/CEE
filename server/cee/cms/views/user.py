# coding=utf-8

from __future__ import unicode_literals

from django.contrib.auth.forms import UserCreationForm
from django.contrib.auth.models import User
from django.utils.decorators import method_decorator
from django.views.generic import ListView, DetailView, CreateView, DeleteView, UpdateView
from django.contrib.admin.views.decorators import staff_member_required
from django.core.urlresolvers import reverse_lazy


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


@method_decorator(staff_member_required, name='dispatch')
class AddUser(CreateView):
    form_class = UserCreationForm
    template_name = 'cms/user_form.html'
    success_url = reverse_lazy('cms-users')


@method_decorator(staff_member_required, name='dispatch')
class UpdateUser(UpdateView):
    model = User
    fields = ['username']
    template_name = 'cms/user_form.html'
    success_url = reverse_lazy('cms-users')


@method_decorator(staff_member_required, name='dispatch')
class DeleteUser(DeleteView):
    model = User
    context_object_name = 'user'
    template_name = 'cms/user_confirm_delete.html'
    success_url = reverse_lazy('cms-users')
