from django import template

register = template.Library()


@register.filter
def coupon_details(value):
    desc = value.desc
    details = ''
    for k in desc:
        v = desc[k]
        details += '%s: %s<br>' % (k, v)
    return details
