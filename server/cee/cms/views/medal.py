# coding=utf-8

from __future__ import unicode_literals

from django.shortcuts import redirect
from django.core.urlresolvers import reverse_lazy, reverse
from django.forms import ModelForm
from django.utils.decorators import method_decorator
from django.views.generic import View, ListView, CreateView, UpdateView, DeleteView, FormView
from django.contrib.admin.views.decorators import staff_member_required

from api.models import Medal


class MedalForm(ModelForm):
    class Meta:
        model = Medal
        fields = ['name', 'desc', 'icon_key']
        labels = {
            'name': '名称',
            'desc': '描述',
            'icon_key': '图标'
        }


@method_decorator(staff_member_required, name='dispatch')
class MedalList(ListView):
    model = Medal
    template_name = 'cms/medals.html'
    context_object_name = 'medals'
    paginate_by = 20


@method_decorator(staff_member_required, name='dispatch')
class AddMedal(CreateView):
    template_name = 'cms/medal_form.html'
    success_url = reverse_lazy('cms-medals')
    form_class = MedalForm


@method_decorator(staff_member_required, name='dispatch')
class EditMedal(UpdateView):
    model = Medal
    template_name = 'cms/medal_form.html'
    success_url = reverse_lazy('cms-medals')
    form_class = MedalForm


@method_decorator(staff_member_required, name='dispatch')
class DeleteMedal(DeleteView):
    model = Medal
    context_object_name = 'medal'
    template_name = 'cms/medal_confirm_delete.html'
    success_url = reverse_lazy('cms-medals')
