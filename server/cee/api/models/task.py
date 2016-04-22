from __future__ import unicode_literals

from django.db import models
from django.contrib.auth.models import User
from .anchor import Anchor


class Task(models.Model):
    name = models.CharField(max_length=30)
    desc = models.TextField()
    coin = models.IntegerField()
    owners = models.ManyToManyField(User,
                                    through='UserTask',
                                    related_name='tasks')


class Choice(models.Model):
    task = models.ForeignKey(Task, related_name='choices')
    order = models.IntegerField()
    name = models.CharField(max_length=30)
    desc = models.TextField()
    image_url = models.URLField()
    # TODO(stareven): encrypt
    answer = models.SmallIntegerField()


class Option(models.Model):
    choice = models.ForeignKey(Choice, related_name='options')
    order = models.SmallIntegerField()
    desc = models.TextField()


class UserTask(models.Model):
    user = models.ForeignKey(User, related_name='user_tasks')
    task = models.ForeignKey(Task, related_name='user_tasks')
    completed = models.BooleanField()

    class Meta:
        unique_together = (
            ('user', 'task'),
        )
