# coding=utf-8
from __future__ import unicode_literals

import json

from django import template

register = template.Library()


@register.filter
def story_user_count(value):
    return value.user_stories.count()


@register.filter
def story_complete_count(value):
    return value.user_stories.filter(completed=True).count()


@register.filter
def story_level_count(value):
    return value.story_levels.count()


@register.filter
def level_type(value):
    type = value.content['type']
    if type == 'dialog':
        return '对话'
    elif type == 'number':
        return '数字谜题'
    elif type == 'text':
        return '文字谜题'
    elif type == 'video':
        return '视频'
    elif type == 'empty':
        return '空白关卡'
    elif type == 'h5':
        return 'H5关卡'
    else:
        return '未知类型关卡'


@register.filter
def list_json(value):
    items = value
    result = []
    for item in items:
        result.append({
            'id': item.id,
            'text': str(item)
        })
    return json.dumps(result)
