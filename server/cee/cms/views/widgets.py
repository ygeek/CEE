import json

from django.forms import Textarea


class JsonTextArea(Textarea):
    def __init__(self, attrs=None):
        if attrs is None:
            attrs = {}
        my_attrs = {'rows': 4, 'readonly': 'true'}
        my_attrs.update(attrs)
        super(JsonTextArea, self).__init__(my_attrs)

    def render(self, name, value, attrs=None):
        if not isinstance(value, basestring):
            value = json.dumps(value)
        return super(JsonTextArea, self).render(name, value, attrs=attrs)
