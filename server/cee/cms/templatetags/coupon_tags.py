# coding=utf-8
from __future__ import unicode_literals
from django import template

register = template.Library()


@register.filter
def coupon_details(value):
    desc = value.desc
    details = ''
    for k in desc:
        v = desc[k]
        details += '<h5><b>%s</b></h5>' \
                   '<pre>%s</pre>' % (k, v)
    return details


@register.filter
def coupon_story_info(value):
    if value.level_coupons.count() == 0:
        ret = '<div class="row"><div class="col-md-12">这张优惠券没有对应的故事</div></div>'
    else:
        ret = ''
        for level_coupon in value.level_coupons.all():
            content = '<div class="col-md-2 col-xs-6">故事名称:</div>' \
                      '<div class="col-md-2 col-xs-6">%s</div>' \
                      '<div class="col-md-2 col-xs-6">总量:</div>' \
                      '<div class="col-md-2 col-xs-6">%d</div>' \
                      '<div class="col-md-2 col-xs-6">剩余:</div>' \
                      '<div class="col-md-2 col-xs-6">%d</div>' \
                      % (level_coupon.story.name, level_coupon.amount, level_coupon.remain)
            ret += '<div class="row">%s</div>' % content
    return ret


@register.filter
def coupon_get_count(value):
    return value.user_coupons.count()


@register.filter
def coupon_consumed_count(value):
    return value.user_coupons.filter(consumed=True).count()
