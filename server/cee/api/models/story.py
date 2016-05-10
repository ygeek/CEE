from __future__ import unicode_literals

from django.db import models
from django.contrib.auth.models import User
from .anchor import *
from .fields import *
from .city import *


class Story(models.Model):
    name = models.CharField(max_length=50, unique=True)
    desc = models.TextField()
    time = models.IntegerField()
    good = models.IntegerField(default=0)
    difficulty = models.IntegerField()
    distance = models.FloatField()
    tags = JsonField()
    city = models.ForeignKey(City, related_name='stories')
    coin = models.IntegerField(default=0)
    image_keys = JsonField()
    tour_image_key = models.CharField(max_length=100)
    hud_image_key = models.CharField(max_length=100)
    owners = models.ManyToManyField(User,
                                    through='UserStory',
                                    related_name='stories')


class UserStory(models.Model):
    user = models.ForeignKey(User, related_name='user_stories')
    story = models.ForeignKey(Story, related_name='user_stories')
    completed = models.BooleanField()
    progress = models.IntegerField()

    class Meta:
        unique_together = (
            ('user', 'story'),
        )


class Level(models.Model):
    name = models.CharField(max_length=50, unique=True)
    content = JsonField()
    stories = models.ManyToManyField(Story,
                                     through='StoryLevel',
                                     related_name='levels')


class StoryLevel(models.Model):
    story = models.ForeignKey(Story, related_name='story_levels')
    level = models.ForeignKey(Level, related_name='story_levels')
    order = models.SmallIntegerField()

    class Meta:
        unique_together = (
            ('story', 'order'),
        )


class Item(models.Model):
    name = models.CharField(max_length=50, unique=True)
    activate_at = models.SmallIntegerField()
    content = JsonField()
    stories = models.ManyToManyField(Story,
                                     through='StoryItem',
                                     related_name='items')


class StoryItem(models.Model):
    story = models.ForeignKey(Story, related_name='story_items')
    item = models.ForeignKey(Item, related_name='story_items')
