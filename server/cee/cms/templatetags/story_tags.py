from django import template

register = template.Library()


@register.filter
def story_user_count(value):
    return value.user_stories.count()


@register.filter
def story_complete_count(value):
    return value.user_stories.filter(completed=True).count()
