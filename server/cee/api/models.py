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


class UserProfile(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE)
    gmt_created = models.DateField()
    gmt_modified = models.DateField()
    nickname = models.CharField(max_length=50)
    head_url = models.URLField()
    sex = models.CharField(max_length=50)
    mobile = models.CharField(max_length=50)


class Story(models.Model):
    name = models.CharField(max_length=50)
    desc = models.TextField()
    time = models.IntegerField()
    good = models.IntegerField()
    distance = models.FloatField()
    city = models.CharField(max_length=50)


class Level(models.Model):
    level_type = models.CharField(max_length=50)
    name = models.CharField(max_length=50)
    video_url = models.URLField()
    img_url = models.URLField()
    test = models.TextField()
    number_answer = models.CharField(max_length=50)
    h5_url = models.URLField()


class Item(models.Model):
    item_type = models.CharField(max_length=50)
    title = models.CharField(max_length=50)
    desc = models.TextField()
    data = models.TextField()


class Coupon(models.Model):
    gmt_start = models.DateField()
    gmt_end = models.DateField()
    name = models.CharField(max_length=30)
    desc = models.TextField()
    state = models.CharField(max_length=50)
    code = models.CharField(max_length=50)
    is_deleted = models.BooleanField()


class UserCoupon(models.Model):
    user = models.ForeignKey(User, related_name='user_coupons')
    coupon = models.ForeignKey(Coupon, related_name='user_coupons')

    class Meta:
        unique_together = (
                ('user', 'coupon'),
            )


class Map(models.Model):
    name = models.CharField(max_length=30)
    desc = models.CharField(max_length=100)
    x = models.FloatField()
    y = models.FloatField()
    image_url = models.URLField()


class UserMap(models.Model):
    user = models.ForeignKey(User, related_name='user_maps')
    map = models.ForeignKey(Map, related_name='user_maps')
    completed = models.BooleanField()

    class Meta:
        unique_together = (
            ('user', 'map'),
        )


class Anchor(models.Model):
    name = models.CharField(max_length=30)
    desc = models.TextField()
    dx = models.FloatField()
    dy = models.FloatField()


class UserAnchor(models.Model):
    user = models.ForeignKey(User, related_name='user_anchors')
    anchor = models.ForeignKey(Anchor, related_name='user_anchorss')
    completed = models.BooleanField()

    class Meta:
        unique_together = (
                ('user', 'anchor')
            )


class UserItem(models.Model):
    user = models.ForeignKey(User, related_name='user_items')
    item = models.ForeignKey(Item, related_name='user_items')
    state = models.CharField(max_length=50)

    class Meta:
        unique_together = (
                ('user', 'item'),
            )


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
    # TODO(stareven): encrypt
    answer = models.SmallIntegerField()


class Option(models.Model):
    choice = models.ForeignKey(Choice, related_name='options')
    order = models.SmallIntegerField()
    desc = models.CharField(max_length=100)
