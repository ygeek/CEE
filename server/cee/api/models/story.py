from __future__ import unicode_literals

from django.db import models
from django.contrib.auth.models import User
from django.core import validators
from django.core import exceptions
from .anchor import Anchor
from .fields import *


class ManyURLField(models.CharField):
    @staticmethod
    def _parse(value, separator):
        return value.split(separator)

    class Validator(object):
        def __init__(self, max_count, max_length, separator):
            self._max_count = max_count
            self._max_length = max_length
            self._separator = separator

        def __call__(self, value):
            if value is None:
                return
            urls = ManyURLField._parse(value, self._separator)
            if len(urls) > self._max_count:
                raise exceptions.ValidationError(
                    'More than %d URLs' % self._max_count)
            validators_ = [
                validators.URLValidator(),
                validators.MaxLengthValidator(limit_value=self._max_length)
            ]
            for url in urls:
                for validator in validators_:
                    validator(url)

    def __init__(self,
                 max_count=5, max_length=200, separator=',',
                 *args, **kwargs):
        assert max_count > 0
        assert max_length > 0
        self._max_count = max_count
        self._max_length = max_length
        self._separator = separator
        kwargs['max_length'] = max_count * max_length + max_count - 1
        super(ManyURLField, self).__init__(*args, **kwargs)
        self.validators.append(ManyURLField.Validator(self._max_count, self._max_length, self._separator))

    def deconstruct(self):
        name, path, args, kwargs = super(ManyURLField, self).deconstruct()
        if self._max_count != 5:
            kwargs['max_count'] = self._max_count
        if self._max_length != 200:
            kwargs['max_length'] = self._max_length
        if self._separator != ',':
            kwargs['separator'] = self._separator
        return name, path, args, kwargs

    def from_db_value(self, value, expression, connection, context):
        if value is None:
            return []
        return ManyURLField._parse(value, self._separator)

    def to_python(self, value):
        if value is None:
            return []
        if isinstance(value, list):
            return value
        return ManyURLField._parse(value, self._separator)

    def get_prep_value(self, value):
        return self._separator.join(value)


class LevelField(models.TextField):
    pass


class Story(models.Model):
    name = models.CharField(max_length=50)
    desc = models.TextField()
    time = models.IntegerField()
    good = models.IntegerField()
    distance = models.FloatField()
    city = models.CharField(max_length=50)
    coin = models.IntegerField()
    image_urls = ManyURLField()


class Level(models.Model):
    name = models.CharField(max_length=50)
    content = models.TextField()
    stories = models.ManyToManyField(Story,
                                     related_name='levels')



class City(models.Model):
    name = models.CharField(max_length=30)


class CityStory(models.Model):
    city = models.ForeignKey(City, related_name='city_story')
    story = models.ForeignKey(Story, related_name='city_story')

    class Meta:
        unique_together = (
            ('city', 'story'),
        )


class AnchorStory(models.Model):
    anchor = models.ForeignKey(Anchor, related_name='anchor_story')
    story = models.ForeignKey(Story, related_name='anchor_story')

    class Meta:
        unique_together = (
            ('anchor', 'story'),
        )


class UserStory(models.Model):
    user = models.ForeignKey(User, related_name='user_storys')
    story = models.ForeignKey(Story, related_name='user_storys')
    completed = models.BooleanField()
    level_step = models.IntegerField()


class Item(models.Model):
    item_type = models.CharField(max_length=50)
    title = models.CharField(max_length=50)
    desc = models.TextField()
    data = models.TextField()


class UserItem(models.Model):
    user = models.ForeignKey(User, related_name='user_items')
    item = models.ForeignKey(Item, related_name='user_items')
    state = models.CharField(max_length=50)

    class Meta:
        unique_together = (
            ('user', 'item'),
        )
