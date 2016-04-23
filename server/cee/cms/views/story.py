# coding=utf-8

from __future__ import unicode_literals
from django.utils.decorators import method_decorator
from django.views.generic import ListView, DetailView
from django.contrib.admin.views.decorators import staff_member_required

from api.models import Story


@method_decorator(staff_member_required, name='dispatch')
class StoryList(ListView):
    model = Story
    template_name = 'cms/stories.html'
    context_object_name = 'stories'
    paginate_by = 20


@method_decorator(staff_member_required, name='dispatch')
class StoryDetail(DetailView):
    model = Story
    template_name = 'cms/story.html'
    context_object_name = 'story'
