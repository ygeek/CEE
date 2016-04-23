from __future__ import unicode_literals

from django.db import models
from django.contrib.auth.models import User
from .anchor import *
from .fields import *


class Story(models.Model):
    name = models.CharField(max_length=50)
    desc = models.TextField()
    time = models.IntegerField()
    good = models.IntegerField()
    distance = models.FloatField()
    city = models.CharField(max_length=50)
    coin = models.IntegerField()
    image_urls = JsonField()


class UserStory(models.Model):
    user = models.ForeignKey(User, related_name='user_storys')
    story = models.ForeignKey(Story, related_name='user_storys')
    completed = models.BooleanField()
    progress = models.IntegerField()


class Level(models.Model):
    name = models.CharField(max_length=50)
    content = JsonField()
    stories = models.ManyToManyField(Story,
                                     through='StoryLevel',
                                     related_name='levels')


class StoryLevel(models.Model):
    story = models.ForeignKey(Story, related_name='story_levels')
    level = models.ForeignKey(Level, related_name='story_levels')
    order = models.SmallIntegerField()


class Item(models.Model):
    name = models.CharField(max_length=50)
    activate_at = models.SmallIntegerField()
    content = JsonField()
    stories = models.ManyToManyField(Story,
                                     through='StoryItem',
                                     related_name='items')


class StoryItem(models.Model):
    story = models.ForeignKey(Story, related_name='story_items')
    item = models.ForeignKey(Item, related_name='story_items')


class City(models.Model):
    name = models.CharField(max_length=30)


class CityStory(models.Model):
    city = models.ForeignKey(City, related_name='city_story')
    story = models.ForeignKey(Story, related_name='city_story')

    class Meta:
        unique_together = (
            ('city', 'story'),
        )
