from __future__ import unicode_literals

from django.db import models
from django.contrib.auth.models import User

class Profile(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE)
    avatar_url = models.URLField()
    gender = models.SmallIntegerField()


class UserDeviceToken(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE)
    device_token = models.CharField(max_length=100)
    installation_id = models.CharField(max_length=100)


class ThirdPartyAccount(models.Model):
    uid = models.CharField(max_length=100)
    platform = models.CharField(max_length=50)
    user = models.ForeignKey(User)


#class User(models.Model):
#    user_id = models.IntegerField()
#    gmt_created = models.DateField()
#    gmt_modified = models.DateField()
#    username = models.CharField(max_length=50)
#    nickname = models.CharField(max_length=50)
#    email = models.EmailField()
#    password = models.CharField(max_length=50)
#    head_url = models.URLField()
#    sex = models.CharField(max_length=50)
#    mobile = models.CharField(max_length=50)
#    is_deleted = models.BooleanField()


class Story(models.Model):
    story_id = models.IntegerField()
    name = models.CharField(max_length=50)
    desc = models.TextField()
    time = models.IntegerField()
    good = models.IntegerField()
    distance = models.FloatField()
    city = models.CharField(max_length=50)


class Level(models.Model):
    level_id = models.IntegerField()
    level_type = models.CharField(max_length=50)
    name = models.CharField(max_length=50)
    video_url = models.URLField()
    img_url = models.URLField()
    test = models.TextField()
    number_answer = models.CharField(max_length=50)
    h5_url = models.URLField()


class Item(models.Model):
    item_id = models.IntegerField()
    item_type = models.CharField(max_length=50)
    title = models.CharField(max_length=50)
    desc = models.TextField()
    data = models.TextField()


class Coupon(models.Model):
    coupon_id = models.IntegerField()
    gmt_start = models.DateField()
    gmt_end = models.DateField()
    name = models.CharField(max_length=50)
    desc = models.TextField()
    state = models.CharField(max_length=50)
    code = models.CharField(max_length=50)
    is_deleted = models.BooleanField()


class UserMap(models.Model):
    map_id = models.IntegerField()
    user_id = models.IntegerField()
    visited = models.BooleanField()
    completed = models.BooleanField()


class Anchor(models.Model):
    anchor_id = models.IntegerField()
    name = models.CharField(max_length=50)
    desc = models.TextField()
    dx = models.FloatField()
    dy = models.FloatField()


class UserAnchor(models.Model):
    anchor_id = models.IntegerField()
    user_id = models.IntegerField()
    completed = models.BooleanField()


class UserItem(models.Model):
    user_id = models.IntegerField()
    item_id = models.IntegerField()
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
    owners = models.ManyToManyField(User, related_name='medals')


class Task(models.Model):
    name = models.CharField(max_length=30)
    desc = models.CharField(max_length=100)
    medal = models.ForeignKey(Medal, related_name='tasks')


class Choice(models.Model):
    task = models.ForeignKey(Task, related_name='choices')
    order = models.IntegerField()
    name = models.CharField(max_length=30)
    desc = models.CharField(max_length=100)
    image_url = models.URLField()
    answer = models.SmallIntegerField()


class Option(models.Model):
    choice = models.ForeignKey(Choice, related_name='options')
    order = models.SmallIntegerField()
    desc = models.CharField(max_length=100)
