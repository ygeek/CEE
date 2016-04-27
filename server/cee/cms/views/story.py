# coding=utf-8

from __future__ import unicode_literals

import json

from django.core.urlresolvers import reverse_lazy
from django.forms import ModelForm, Textarea
from django.utils.decorators import method_decorator
from django.views.generic import ListView, DetailView, CreateView, UpdateView, DeleteView
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


class JsonTextArea(Textarea):
    def render(self, name, value, attrs=None):
        value = json.dumps(value)
        return super(JsonTextArea, self).render(name, value, attrs=attrs)


class StoryForm(ModelForm):
    class Meta:
        model = Story
        fields = ['name', 'time', 'distance', 'city', 'image_urls']
        labels = {
            'name': '名称',
            'city': '城市',
            'time': '预计完成时间（分钟）',
            'distance': '预计移动距离',
            'image_urls': '封面图片'
        }
        widgets = {
            'image_urls': JsonTextArea(attrs={'rows': 4, 'readonly': 'true'})
        }


@method_decorator(staff_member_required, name='dispatch')
class AddStory(CreateView):
    template_name = 'cms/story_form.html'
    success_url = reverse_lazy('cms-stories')
    form_class = StoryForm


@method_decorator(staff_member_required, name='dispatch')
class EditStory(UpdateView):
    model = Story
    template_name = 'cms/story_form.html'
    success_url = reverse_lazy('cms-stories')
    form_class = StoryForm


@method_decorator(staff_member_required, name='dispatch')
class DeleteStory(DeleteView):
    model = Story
    context_object_name = 'story'
    template_name = 'cms/story_confirm_delete.html'
    success_url = reverse_lazy('cms-stories')
