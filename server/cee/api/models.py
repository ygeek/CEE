from __future__ import unicode_literals

from django.db import models
from django.contrib.auth.models import User


class City(models.Model):
    name = models.CharField(max_length=30)


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


class CityStory(models.Model):
    city = models.ForeignKey(City, related_name='city_storys')
    story = models.ForeignKey(Story, related_name='city_storys')

    class Meta:
        unique_together = (
            ('city', 'story'),
        )


class Level(models.Model):
    level_type = models.CharField(max_length=50)
    name = models.CharField(max_length=50)
    video_url = models.URLField()
    img_url = models.URLField()
    test = models.TextField()
    number_answer = models.CharField(max_length=50)
    h5_url = models.URLField()


class StoryLevel(models.Model):
    story = models.ForeignKey(Story, related_name='story_levels')
    level = models.ForeignKey(Level, related_name='story_levels')

    class Meta:
        unique_together = (
            ('story', 'level'),
        )


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


class Medal(models.Model):
    name = models.CharField(max_length=30)
    desc = models.CharField(max_length=100)
    icon_url = models.URLField()
    owners = models.ManyToManyField(User, related_name='medals')


class UserMedal(models.Model):
    user = models.ForeignKey(User, related_name='user_medals')
    medal = models.ForeignKey(Medal, related_name='user_medals')

    class Meta:
        unique_together = (
            ('user', 'medal'),
        )


class Map(models.Model):
    name = models.CharField(max_length=30)
    desc = models.CharField(max_length=100)
    x = models.FloatField()
    y = models.FloatField()
    image_url = models.URLField()
    medal = models.ForeignKey(Medal, related_name='maps')


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
    anchor_type = models.CharField(max_length=50)


class Task(models.Model):
    name = models.CharField(max_length=30)
    desc = models.CharField(max_length=100)


class MapAnchor(models.Model):
    map = models.ForeignKey(Map, related_name='map_anchors')
    anchor = models.ForeignKey(Anchor, related_name='map_anchors')

    class Meta:
        unique_together = (
            ('map', 'anchor'),
        )


class AnchorTask(models.Model):
    anchor = models.ForeignKey(Anchor, related_name='anchor_task')
    task = models.ForeignKey(Task, related_name='anchor_task')

    class Meta:
        unique_together = (
            ('anchor', 'task'),
        )


class AnchorStory(models.Model):
    anchor = models.ForeignKey(Anchor, related_name='anchor_story')
    story = models.ForeignKey(Story, related_name='anchor_story')

    class Meta:
        unique_together = (
            ('anchor', 'story'),
        )


class UserAnchor(models.Model):
    user = models.ForeignKey(User, related_name='user_anchors')
    anchor = models.ForeignKey(Anchor, related_name='user_anchors')
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
