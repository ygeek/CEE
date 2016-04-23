# coding=utf-8

from __future__ import unicode_literals
from django.utils.decorators import method_decorator
from django.views.generic import ListView, DetailView
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
