# coding=utf-8

from __future__ import unicode_literals

import json

from django.core.urlresolvers import reverse_lazy, reverse
from django.forms import ModelForm
from django.utils.decorators import method_decorator
from django.views.generic import ListView, CreateView, UpdateView, DeleteView
from django.contrib.admin.views.decorators import staff_member_required

from api.models import Map, Anchor, Story, Task
from api.serializers import AnchorSerializer


@method_decorator(staff_member_required, name='dispatch')
class MapList(ListView):
    model = Map
    template_name = 'cms/maps.html'
    context_object_name = 'maps'
    paginate_by = 20


class MapForm(ModelForm):
    class Meta:
        model = Map
        fields = [
            'name',
            'longitude',
            'latitude',
            'city',
            'image_key',
            'icon_key',
            'summary_image_key'
        ]
        labels = {
            'name': '名称',
            'longitude': '经度',
            'latitude': '纬度',
            'city': '城市',
            'image_key': '底图',
            'icon_key': '图标',
            'summary_image_key': '加载图'
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


@method_decorator(staff_member_required, name='dispatch')
class AnchorList(ListView):
    template_name = 'cms/anchors.html'
    context_object_name = 'anchors'

    def get_map(self):
        return Map.objects.get(pk=self.kwargs['map_id'])

    def get_queryset(self):
        return self.get_map().anchors.all()

    def get_context_data(self, **kwargs):
        context = super(AnchorList, self).get_context_data(**kwargs)
        context['map'] = self.get_map()
        serializer = AnchorSerializer(context['anchors'], many=True)
        context['anchors_json'] = json.dumps(serializer.data)
        return context


class AnchorForm(ModelForm):
    class Meta:
        model = Anchor
        fields = [
            'name',
            'dx',
            'dy',
            'type',
            'ref_id'
        ]
        labels = {
            'name': '名称',
            'dx': 'x',
            'dy': 'y',
            'type': '类型'
        }


@method_decorator(staff_member_required, name='dispatch')
class AddAnchor(CreateView):
    template_name = 'cms/anchor_form.html'
    form_class = AnchorForm
    object = None

    def get_map(self):
        return Map.objects.get(id=self.kwargs['map_id'])

    def get_context_data(self, **kwargs):
        context = super(AddAnchor, self).get_context_data(**kwargs)
        context['map'] = self.get_map()
        context['stories'] = Story.objects.all()
        context['tasks'] = Task.objects.all()
        return context

    def get_success_url(self):
        return reverse('cms-anchor-list', kwargs={
            'map_id': self.kwargs['map_id']
        })

    def post(self, request, *args, **kwargs):
        self.object = None
        form = self.get_form()
        form.instance.map_id = self.kwargs['map_id']
        if form.is_valid():
            return self.form_valid(form)
        else:
            return self.form_invalid(form)


@method_decorator(staff_member_required, name='dispatch')
class EditAnchor(UpdateView):
    model = Anchor
    template_name = 'cms/anchor_form.html'
    form_class = AnchorForm

    def get_map(self):
        return Map.objects.get(id=self.kwargs['map_id'])

    def get_context_data(self, **kwargs):
        context = super(EditAnchor, self).get_context_data(**kwargs)
        context['map'] = self.get_map()
        context['stories'] = Story.objects.all()
        context['tasks'] = Task.objects.all()
        return context

    def get_success_url(self):
        return reverse('cms-anchor-list', kwargs={
            'map_id': self.kwargs['map_id']
        })


@method_decorator(staff_member_required, name='dispatch')
class DeleteAnchor(DeleteView):
    model = Anchor
    context_object_name = 'anchor'
    template_name = 'cms/anchor_confirm_delete.html'

    def get_success_url(self):
        return reverse('cms-anchor-list', kwargs={
            'map_id': self.kwargs['map_id']
        })
