from __future__ import unicode_literals

from django.db import models
from django.contrib.auth.models import User


class ThirdPartyAccount(models.Model):
    uid = models.CharField(max_length=100)
    platform = models.CharField(max_length=50)
    user = models.ForeignKey(User)


class Story(models.Model):
    story_id = models.CharField(max_length=50)
    name = models.CharField(max_length=50)
    desc = models.TextField()
    time = models.IntegerField()
    good = models.IntegerField()
    distance = models.FloatField()
    city = models.CharField(max_length=50)


class Level(models.Model):
    level_id = models.CharField(max_length=50)
    level_type = models.CharField(max_length=50)
    name = models.CharField(max_length=50)
    video_url = models.URLField()
    img_url = models.URLField()
    test = models.TextField()
    number_answer = models.CharField(max_length=50)
    h5_url = models.URLField()


class Item(models.Model):
    item_id = models.CharField(max_length=50)
    item_type = models.CharField(max_length=50)
    title = models.CharField(max_length=50)
    desc = models.TextField()
    data = models.TextField()


class Coupon(models.Model):
    coupon_id = models.CharField(max_length=50)
    gmt_start = models.DateField()
    gmt_end = models.DateField()
    name = models.CharField(max_length=50)
    desc = models.TextField()
    state = models.CharField(max_length=50)
    code = models.CharField(max_length=50)
    is_deleted = models.BooleanField()


class UserMap(models.Model):
    map_id = models.CharField(max_length=50)
    user_id = models.CharField(max_length=50)
    visited = models.BooleanField()
    completed = models.BooleanField()


class Anchor(models.Model):
    anchor_id = models.CharField(max_length=50)
    name = models.CharField(max_length=50)
    desc = models.TextField()
    dx = models.FloatField()
    dy = models.FloatField()


class UserAnchor(models.Model):
    anchor_id = models.CharField(max_length=50)
    user_id = models.CharField(max_length=50)
    completed = models.BooleanField()


class UserItem(models.Model):
    user_id = models.CharField(max_length=50)
    item_id = models.CharField(max_length=50)
    state = models.CharField(max_length=50)


class Map(models.Model):
    name = models.CharField(max_length=30)
    desc = models.CharField(max_length=100)
    x = models.FloatField()
    y = models.FloatField()
    image_url = models.URLField()


class Medal(models.Model):
    name = models.CharField(max_length=30)
    desc = models.CharField(max_length=100)
    icon_url = models.URLField()
    map = models.ForeignKey(Map)


class Task(models.Model):
    name = models.CharField(max_length=30)
    desc = models.CharField(max_length=100)
    medal = models.ForeignKey(Medal)


class Choice(models.Model):
    name = models.CharField(max_length=30)
    desc = models.CharField(max_length=100)
    image_url = models.URLField()
    answer = models.SmallIntegerField()
    task = models.ForeignKey(Task)


class Option(models.Model):
    index = models.SmallIntegerField()
    desc = models.CharField(max_length=100)
    choice = models.ForeignKey(Choice)
