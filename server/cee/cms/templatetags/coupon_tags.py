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
