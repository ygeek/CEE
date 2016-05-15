# coding=utf-8

from __future__ import unicode_literals

from django.core.urlresolvers import reverse_lazy, reverse
from django.db import transaction
from django.forms import ModelForm, ChoiceField
from django.utils.decorators import method_decorator
from django.views.generic import ListView, CreateView, UpdateView, DeleteView
from django.contrib.admin.views.decorators import staff_member_required

from api.models.task import *


@method_decorator(staff_member_required, name='dispatch')
class TaskList(ListView):
    model = Task
    template_name = 'cms/tasks.html'
    context_object_name = 'tasks'
    paginate_by = 20


class TaskForm(ModelForm):
    class Meta:
        model = Task
        fields = [
            'name',
            'desc',
            'location',
            'coin',
            'award_image_key',
        ]
        labels = {
            'name': '名称',
            'desc': '描述',
            'location': '位置',
            'coin': '金币',
            'award_image_key': '奖励图',
        }


@method_decorator(staff_member_required, name='dispatch')
class AddTask(CreateView):
    template_name = 'cms/task_form.html'
    success_url = reverse_lazy('cms-tasks')
    form_class = TaskForm


@method_decorator(staff_member_required, name='dispatch')
class EditTask(UpdateView):
    model = Task
    template_name = 'cms/task_form.html'
    success_url = reverse_lazy('cms-tasks')
    form_class = TaskForm


@method_decorator(staff_member_required, name='dispatch')
class DeleteTask(DeleteView):
    model = Task
    context_object_name = 'task'
    template_name = 'cms/task_confirm_delete.html'
    success_url = reverse_lazy('cms-tasks')


class ChoiceForm(ModelForm):
    class Meta:
        model = Choice
        fields = [
            'task',
            'order',
            'name',
            'desc',
            'image_key',
            'answer',
            'answer_message',
            'answer_next',
            'answer_image_key',
        ]
        labels = {
            'order': '题号',
            'name': '名称',
            'desc': '描述',
            'image_key': '图片',
            'answer': '答案',
        }


@method_decorator(staff_member_required, name='dispatch')
class ChoiceList(ListView):
    template_name = 'cms/choices.html'
    context_object_name = 'choices'

    def get_task(self):
        return Task.objects.get(pk=self.kwargs['task_id'])

    def get_context_data(self, **kwargs):
        context = super(ChoiceList, self).get_context_data(**kwargs)
        context['task'] = self.get_task()
        return context

    def get_queryset(self):
        task = self.get_task()
        return Choice.objects.filter(task=task)


@method_decorator(staff_member_required, name='dispatch')
class AddChoice(CreateView):
    template_name = 'cms/choice_form.html'
    form_class = ChoiceForm
    object = None

    def get_task(self):
        return Task.objects.get(pk=self.kwargs['task_id'])

    def get_success_url(self):
        return reverse('cms-choice-list', kwargs={
            'task_id': self.kwargs['task_id']
        })

    def get_context_data(self, **kwargs):
        context = super(AddChoice, self).get_context_data(**kwargs)
        context['task'] = self.get_task()
        return context

    @transaction.atomic
    def post(self, request, *args, **kwargs):
        self.object = None
        form = self.get_form()
        if form.is_valid():
            response = self.form_valid(form)
            task = self.get_task()
            task.choices.add(form.instance)
            return response
        else:
            return self.form_invalid(form)


@method_decorator(staff_member_required, name='dispatch')
class EditChoice(UpdateView):
    model = Choice
    template_name = 'cms/choice_form.html'
    form_class = ChoiceForm
    object = None

    def get_task(self):
        return Task.objects.get(pk=self.kwargs['task_id'])

    def get_context_data(self, **kwargs):
        context = super(EditChoice, self).get_context_data(**kwargs)
        context['task'] = self.get_task()
        return context

    def get_success_url(self):
        return reverse('cms-choice-list', kwargs={
            'task_id': self.kwargs['task_id']
        })


@method_decorator(staff_member_required, name='dispatch')
class DeleteChoice(DeleteView):
    model = Choice
    context_object_name = 'choice'
    template_name = 'cms/choice_confirm_delete.html'

    def get_success_url(self):
        return reverse('cms-choice-list', kwargs={
            'task_id': self.kwargs['task_id']
        })


class OptionForm(ModelForm):
    class Meta:
        model = Option
        fields = [
            'choice',
            'order',
            'desc',
        ]
        labels = {
            'order': '选项号',
            'desc': '描述',
        }


@method_decorator(staff_member_required, name='dispatch')
class OptionList(ListView):
    template_name = 'cms/options.html'
    context_object_name = 'options'

    def get_task(self):
        return Task.objects.get(pk=self.kwargs['task_id'])

    def get_choice(self):
        return Choice.objects.get(pk=self.kwargs['choice_id'])

    def get_context_data(self, **kwargs):
        context = super(OptionList, self).get_context_data(**kwargs)
        context['task'] = self.get_task()
        context['choice'] = self.get_choice()
        return context

    def get_queryset(self):
        choice = self.get_choice()
        return Option.objects.filter(choice=choice)


@method_decorator(staff_member_required, name='dispatch')
class AddOption(CreateView):
    template_name = 'cms/option_form.html'
    form_class = OptionForm
    object = None

    def get_task(self):
        return Task.objects.get(pk=self.kwargs['task_id'])

    def get_choice(self):
        return Choice.objects.get(pk=self.kwargs['choice_id'])

    def get_context_data(self, **kwargs):
        context = super(AddOption, self).get_context_data(**kwargs)
        context['task'] = self.get_task()
        context['choice'] = self.get_choice()
        return context

    def get_success_url(self):
        return reverse('cms-option-list', kwargs={
            'task_id': self.kwargs['task_id'],
            'choice_id': self.kwargs['choice_id'],
        })

    @transaction.atomic
    def post(self, request, *args, **kwargs):
        self.object = None
        form = self.get_form()
        if form.is_valid():
            response = self.form_valid(form)
            choice = self.get_choice()
            choice.options.add(form.instance)
            return response
        else:
            return self.form_invalid(form)


@method_decorator(staff_member_required, name='dispatch')
class EditOption(UpdateView):
    model = Option
    template_name = 'cms/option_form.html'
    form_class = OptionForm
    object = None

    def get_task(self):
        return Task.objects.get(pk=self.kwargs['task_id'])

    def get_choice(self):
        return Choice.objects.get(pk=self.kwargs['choice_id'])

    def get_context_data(self, **kwargs):
        context = super(EditOption, self).get_context_data(**kwargs)
        context['task'] = self.get_task()
        context['choice'] = self.get_choice()
        return context

    def get_success_url(self):
        return reverse('cms-option-list', kwargs={
            'task_id': self.kwargs['task_id'],
            'choice_id': self.kwargs['choice_id'],
        })


@method_decorator(staff_member_required, name='dispatch')
class DeleteOption(DeleteView):
    model = Option
    context_object_name = 'option'
    template_name = 'cms/option_confirm_delete.html'

    def get_success_url(self):
        return reverse('cms-option-list', kwargs={
            'task_id': self.kwargs['task_id'],
            'choice_id': self.kwargs['choice_id'],
        })
