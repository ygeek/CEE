# coding=utf-8

from __future__ import unicode_literals

from django.core.urlresolvers import reverse_lazy
from django.forms import ModelForm, ChoiceField
from django.utils.decorators import method_decorator
from django.views.generic import ListView, DetailView, CreateView, UpdateView, DeleteView
from django.contrib.admin.views.decorators import staff_member_required

from api.models import Story, Level, StoryLevel
from cms.views.widgets import JsonTextArea


@method_decorator(staff_member_required, name='dispatch')
class StoryList(ListView):
    model = Story
    template_name = 'cms/stories.html'
    context_object_name = 'stories'
    paginate_by = 20


class StoryForm(ModelForm):
    class Meta:
        model = Story
        fields = [
            'name',
            'time',
            'distance',
            'difficulty',
            'city',
            'coin',
            'desc',
            'tags',
            'tour_image_key',
            'hud_image_key',
            'image_keys',
        ]
        labels = {
            'name': '名称',
            'city': '城市',
            'time': '预计完成时间（分钟）',
            'distance': '预计移动距离',
            'image_keys': '封面图片',
            'difficulty': '难度',
            'tour_image_key': '示意路线图',
            'hud_image_key': '加载图',
            'desc': '关卡介绍',
            'tags': '标签',
            'coin': '金币'
        }
        widgets = {
            'image_keys': JsonTextArea(),
            'tags': JsonTextArea()
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


class LevelForm(ModelForm):
    type = ChoiceField(choices=[
        ('dialog', '对话关卡'),
        ('video', '视频关卡'),
        ('number', '数字谜题关卡'),
        ('text', '文字谜题关卡'),
        ('empty', '空白关卡'),
        ('h5', 'H5关卡')
    ], label='关卡类型')

    class Meta:
        model = Level
        fields = [
            'name',
            'type',
            'content'
        ]
        labels = {
            'name': '关卡名称',
            'content': '关卡内容'
        }
        widgets = {
            'content': JsonTextArea()
        }


@method_decorator(staff_member_required, name='dispatch')
class AddLevel(CreateView):
    template_name = 'cms/level_form.html'
    success_url = reverse_lazy('cms-stories')
    form_class = LevelForm
    object = None

    def get_story(self):
        return Story.objects.get(pk=self.kwargs['pk'])

    def get_context_data(self, **kwargs):
        context = super(AddLevel, self).get_context_data(**kwargs)
        context['story'] = self.get_story()
        return context

    def post(self, request, *args, **kwargs):
        self.object = None
        form = self.get_form()
        if form.is_valid():
            response = self.form_valid(form)
            story_level = StoryLevel()
            story = self.get_story()
            story_level.story = story
            story_level.level = form.instance
            story_level.order = story.story_levels.count()
            story_level.save()
            return response
        else:
            return self.form_invalid(form)
