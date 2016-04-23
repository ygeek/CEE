# coding=utf-8

from __future__ import unicode_literals

from django.contrib.auth.forms import UserCreationForm, AdminPasswordChangeForm
from django.contrib.auth.models import User
from django.shortcuts import get_object_or_404
from django.utils.decorators import method_decorator
from django.views.generic import ListView, DetailView, CreateView, DeleteView, UpdateView, FormView
from django.contrib.admin.views.decorators import staff_member_required
from django.core.urlresolvers import reverse_lazy, reverse
from django.forms.models import modelform_factory

from api.models import UserProfile


@method_decorator(staff_member_required, name='dispatch')
class UserList(ListView):
    model = User
    template_name = 'cms/users.html'
    context_object_name = 'users'
    paginate_by = 20


@method_decorator(staff_member_required, name='dispatch')
class UserDetail(DetailView, UpdateView):
    model = User
    template_name = 'cms/user.html'
    context_object_name = 'user'
    fields = ['username', 'email']
    profile_form_class = modelform_factory(UserProfile,
                                           fields=[
                                               'nickname',
                                               'birthday',
                                               'mobile',
                                           ],
                                           labels={
                                               'nickname': '昵称',
                                               'birthday': '生日',
                                               'mobile': '手机',
                                           }
                                           )
    object = None
    profile = None

    def get_context_data(self, **kwargs):
        context = {'profile_form': self.profile_form_class(instance=self.get_profile())}
        context.update(super(UserDetail, self).get_context_data(**kwargs))
        return context

    def get_success_url(self):
        return reverse('cms-user-detail', kwargs={'pk': self.object.id})

    def form_valid(self, form, profile_form):
        profile_form.save()
        return super(UserDetail, self).form_valid(form)

    def form_invalid(self, form, profile_form):
        return self.render_to_response(self.get_context_data(form=form, profile_form=profile_form))

    def get_profile(self):
        try:
            profile = self.object.userprofile
        except UserProfile.DoesNotExist:
            profile = UserProfile(user=self.object)
        return profile

    def get(self, request, *args, **kwargs):
        self.object = self.get_object()
        self.profile = self.get_profile()
        return self.render_to_response(self.get_context_data())

    def post(self, request, *args, **kwargs):
        self.object = self.get_object()
        self.profile = self.get_profile()
        form = self.get_form()
        profile_form = self.profile_form_class(self.request.POST, instance=self.profile)
        if form.is_valid() and profile_form.is_valid():
            return self.form_valid(form, profile_form)
        else:
            return self.form_invalid(form, profile_form)


@method_decorator(staff_member_required, name='dispatch')
class AddUser(CreateView):
    form_class = UserCreationForm
    template_name = 'cms/user_form.html'
    success_url = reverse_lazy('cms-users')

    def get_context_data(self, **kwargs):
        return super(AddUser, self).get_context_data(**kwargs)


@method_decorator(staff_member_required, name='dispatch')
class ChangeUserPassword(FormView):
    template_name = 'cms/user_form.html'
    success_url = reverse_lazy('cms-users')

    def get_form(self, form_class=None):
        user_id = self.kwargs['pk']
        user = get_object_or_404(User, pk=user_id)
        return AdminPasswordChangeForm(user, **self.get_form_kwargs())


@method_decorator(staff_member_required, name='dispatch')
class DeleteUser(DeleteView):
    model = User
    context_object_name = 'user'
    template_name = 'cms/user_confirm_delete.html'
    success_url = reverse_lazy('cms-users')
