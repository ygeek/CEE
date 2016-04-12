from __future__ import unicode_literals

from django.db import models

# Create your models here.
class Story(models.Model):
    story_id = models.CharField(max_length=50)
    name = models.CharField(max_length=50)
    desc = models.TextField()
    time = models.IntegerField()
    good = models.IntegerField()
    distance = models.FloatField()
    level_ids = 
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
    gmt_start = modules.DateField()
    gmt_end = modules.DateField()
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


