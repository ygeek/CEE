# coding=utf-8

from __future__ import unicode_literals

from django.core.urlresolvers import reverse_lazy, reverse
from django.db import transaction
from django.forms import ModelForm, ChoiceField
from django.utils.decorators import method_decorator
from django.views.generic import ListView, CreateView, UpdateView, DeleteView
from django.contrib.admin.views.decorators import staff_member_required

from api.models import Story, Level, StoryLevel, LevelCoupon
from cms.views.widgets import JsonTextArea


class LevelCouponForm(ModelForm):

    class Meta:
        model = LevelCoupon
        fields = [
            'coupon',
            'amount'
        ]
        labels = {
            'amount': '优惠卷数量',
        }


@method_decorator(staff_member_required, name='dispatch')
class LevelCouponList(ListView):
    template_name = 'cms/level_coupons.html'
    context_object_name = 'level_coupons'

    def get_story(self):
        return Story.objects.get(pk=self.kwargs['story_id'])

    def get_level(self):
        return Level.objects.get(pk=self.kwargs['level_id'])

    def get_context_data(self, **kwargs):
        context = super(LevelCouponList, self).get_context_data(**kwargs)
        context['story'] = self.get_story()
        context['level'] = self.get_level()
        return context

    def get_queryset(self):
        story = self.get_story()
        level = self.get_level()
        return LevelCoupon.objects.filter(story=story,level=level)


@method_decorator(staff_member_required, name='dispatch')
class AddLevelCoupon(CreateView):
    template_name = 'cms/level_coupon_form.html'
    form_class = LevelCouponForm
    object = None

    def get_story(self):
        return Story.objects.get(pk=self.kwargs['story_id'])

    def get_level(self):
        return Level.objects.get(pk=self.kwargs['level_id'])

    def get_success_url(self):
        return reverse('cms-level-coupons', kwargs={
            'story_id': self.kwargs['story_id'],
            'level_id': self.kwargs['level_id']
        })

    def get_context_data(self, **kwargs):
        context = super(AddLevelCoupon, self).get_context_data(**kwargs)
        context['story'] = self.get_story()
        context['levet'] = self.get_level()
        return context

    @transaction.atomic
    def post(self, request, *args, **kwargs):
        self.object = None
        form = self.get_form()
        if form.is_valid():
            #response = self.form_valid(form)
            level_coupon = LevelCoupon()
            story = self.get_story()
            level = self.get_level()
            level_coupon = form.instance
            level_coupon.story = story
            level_coupon.level = level
            level_coupon.save()
            return self.form_valid(form)
        else:
            return self.form_invalid(form)


@method_decorator(staff_member_required, name='dispatch')
class DeleteLevelCoupon(DeleteView):
    model = LevelCoupon
    context_object_name = 'levelcoupon'
    template_name = 'cms/levelcoupon_confirm_delete.html'

    def get_success_url(self):
        return reverse('cms-level-coupons', kwargs={
            'story_id': self.kwargs['story_id'],
            'level_id': self.kwargs['level_id']
        })

