from __future__ import unicode_literals

import json
from django.db import models
from django.core import validators
from django.core import exceptions


class JsonDict(dict):
    def __unicode__(self):
        return json.dumps(self)


class JsonList(list):
    def __unicode__(self):
        return json.dumps(self)


def to_json_value(value):
    if isinstance(value, dict):
        return JsonDict(value)
    elif isinstance(value, list):
        return JsonList(value)
    return value


class JsonField(models.TextField):
    def __init__(self, *args, **kwargs):
        super(JsonField, self).__init__(*args, **kwargs)

    def from_db_value(self, value, expression, connection, context):
        if value is None:
            return None
        try:
            return to_json_value(json.loads(value))
        except ValueError:
            raise exceptions.ValidationError('invalid json value')

    def to_python(self, value):
        if value is None:
            return None
        if isinstance(value, dict) or isinstance(value, list):
            return to_json_value(value)
        try:
            return to_json_value(json.loads(value))
        except ValueError:
            raise exceptions.ValidationError('invalid json value')

    def get_prep_value(self, value):
        return json.dumps(value)
