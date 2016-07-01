# coding=utf-8
from __future__ import unicode_literals

import json

from django.core.urlresolvers import reverse_lazy, reverse
from django.forms import ModelForm
from django.utils.decorators import method_decorator
from django.views.generic import ListView, CreateView, UpdateView, DeleteView
from django.contrib.admin.views.decorators import staff_member_required

from api.models import LoginAward


@method_decorator(staff_member_required, name='dispatch')
class LoginAwardList(ListView):
    model = LoginAward
    template_name = 'cms/login_awards.html'
    context_object_name = 'login_awards'
    paginate_by = 20


class LoginAwardForm(ModelForm):
    class Meta:
        model = LoginAward
        fields = [
            'desc',
            'coin',
            'gmt_start',
            'gmt_end',
        ]
        labels = {
            'desc': '活动说明',
            'coin': '奖励金币数量',
            'gmt_start': '开始时间',
            'gmt_end': '结束时间',
        }


@method_decorator(staff_member_required, name='dispatch')
class AddLoginAward(CreateView):
    template_name = 'cms/login_award_form.html'
    success_url = reverse_lazy('cms-login-awards')
    form_class = LoginAwardForm


@method_decorator(staff_member_required, name='dispatch')
class EditLoginAward(UpdateView):
    model = LoginAward
    template_name = 'cms/login_award_form.html'
    success_url = reverse_lazy('cms-login-awards')
    form_class = LoginAwardForm


@method_decorator(staff_member_required, name='dispatch')
class DeleteLoginAward(DeleteView):
    model = LoginAward
    context_object_name = 'login_award'
    template_name = 'cms/login_award_confirm_delete.html'
    success_url = reverse_lazy('cms-login-awards')
