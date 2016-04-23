from __future__ import unicode_literals

import json
from django.db import models
from django.core import validators
from django.core import exceptions


class JsonField(models.TextField):
    def __init__(self, *args, **kwargs):
        super(JsonField, self).__init__(*args, **kwargs)

    def from_db_value(self, value, expression, connection, context):
        if value is None:
            return None
        try:
            return json.loads(value)
        except ValueError:
            raise ValidationError('invalid json value')

    def to_python(self, value):
        if value is None:
            return None
        if isinstance(value, dict):
            return value
        try:
            return json.loads(value)
        except ValueError:
            raise ValidationError('invalid json value')
