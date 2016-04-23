from django import template

register = template.Library()


@register.filter
def map_user_count(value):
    return value.user_maps.count()


@register.filter
def map_complete_count(value):
    return value.user_maps.filter(completed=True).count()
