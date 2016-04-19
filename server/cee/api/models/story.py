from __future__ import unicode_literals

from django.db import models
from django.contrib.auth.models import User
from .anchor import Anchor


class ImageUrl(models.Model):
    image_url = models.URLField()


class Level(models.Model):
    level_type = models.CharField(max_length=50)
    name = models.CharField(max_length=50)
    video_url = models.URLField()
    img_url = models.URLField()
    test = models.TextField()
    number_answer = models.CharField(max_length=50)
    h5_url = models.URLField()
    coin = models.IntegerField()


class Story(models.Model):
    name = models.CharField(max_length=50)
    desc = models.TextField()
    time = models.IntegerField()
    good = models.IntegerField()
    distance = models.FloatField()
    city = models.CharField(max_length=50)
    image_url = models.ManyToManyField(ImageUrl)
    level = models.ManyToManyField(Level)


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
