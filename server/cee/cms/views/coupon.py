# coding=utf-8
from __future__ import unicode_literals

import json

from django.core.urlresolvers import reverse_lazy
from django.forms import ModelForm
from django.utils.decorators import method_decorator
from django.views.generic import ListView, CreateView, UpdateView
from django.contrib.admin.views.decorators import staff_member_required

from api.models import Coupon
from cms.views.widgets import JsonTextArea


@method_decorator(staff_member_required, name='dispatch')
class CouponList(ListView):
    model = Coupon
    template_name = 'cms/coupons.html'
    context_object_name = 'coupons'
    paginate_by = 20


class CouponForm(ModelForm):
    class Meta:
        model = Coupon
        fields = [
            'name',
            'location',
            'gmt_start',
            'gmt_end',
            'code',
            'desc',
            'image_key'
        ]
        labels = {
            'name': '名称',
            'location': '餐厅',
            'gmt_start': '开始时间',
            'gmt_end': '结束时间',
            'code': '消费密码',
            'desc': '描述',
            'image_key': '配图'
        }
        widgets = {
            'desc': JsonTextArea()
        }


@method_decorator(staff_member_required, name='dispatch')
class AddCoupon(CreateView):
    template_name = 'cms/coupon_form.html'
    success_url = reverse_lazy('cms-coupons')
    form_class = CouponForm


@method_decorator(staff_member_required, name='dispatch')
class EditCoupon(UpdateView):
    model = Coupon
    template_name = 'cms/coupon_form.html'
    success_url = reverse_lazy('cms-coupons')
    form_class = CouponForm
