# coding=utf-8

from __future__ import unicode_literals

from django.core.urlresolvers import reverse_lazy
from django.forms import ModelForm
from django.utils.decorators import method_decorator
from django.views.generic import ListView, DetailView, CreateView, UpdateView, DeleteView
from django.contrib.admin.views.decorators import staff_member_required

from api.models import Map


@method_decorator(staff_member_required, name='dispatch')
class MapList(ListView):
    model = Map
    template_name = 'cms/maps.html'
    context_object_name = 'maps'
    paginate_by = 20


@method_decorator(staff_member_required, name='dispatch')
class MapDetail(DetailView):
    model = Map
    template_name = 'cms/map.html'
    context_object_name = 'map'


class MapForm(ModelForm):
    class Meta:
        model = Map
        fields = [
            'name',
            'longitude',
            'latitude'
        ]
        labels = {
            'name': '名称',
            'longitude': '经度',
            'latitude': '纬度',
        }


@method_decorator(staff_member_required, name='dispatch')
class AddMap(CreateView):
    template_name = 'cms/map_form.html'
    success_url = reverse_lazy('cms-maps')
    form_class = MapForm


@method_decorator(staff_member_required, name='dispatch')
class EditMap(UpdateView):
    model = Map
    template_name = 'cms/map_form.html'
    success_url = reverse_lazy('cms-maps')
    form_class = MapForm


@method_decorator(staff_member_required, name='dispatch')
class DeleteMap(DeleteView):
    model = Map
    context_object_name = 'map'
    template_name = 'cms/map_confirm_delete.html'
    success_url = reverse_lazy('cms-maps')
