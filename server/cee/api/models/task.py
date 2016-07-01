from __future__ import unicode_literals

from django.db import models
from django.contrib.auth.models import User
from .anchor import Anchor
from .medal import *


class Task(models.Model):
    name = models.CharField(max_length=30, unique=True)
    desc = models.TextField()
    location = models.TextField()
    coin = models.IntegerField()
    award_image_key = models.CharField(max_length=100)
    owners = models.ManyToManyField(User,
                                    through='UserTask',
                                    related_name='tasks')
    medal = models.ForeignKey(Medal,
                              null=True,
                              blank=True,
                              related_name='task')


    def __unicode__(self):
        return '{0}:{1}'.format(self.name, self.location)


class Choice(models.Model):
    task = models.ForeignKey(Task, related_name='choices')
    order = models.SmallIntegerField()
    name = models.CharField(max_length=30, unique=True)
    desc = models.TextField()
    image_key = models.CharField(max_length=100)
    # TODO(stareven): encrypt
    answer = models.SmallIntegerField()
    answer_message = models.TextField()
    answer_next = models.TextField()
    answer_image_key = models.CharField(max_length=100)

    class Meta:
        unique_together = (
            ('task', 'order'),
        )


class Option(models.Model):
    choice = models.ForeignKey(Choice, related_name='options')
    order = models.SmallIntegerField()
    desc = models.TextField()

    class Meta:
        unique_together = (
            ('choice', 'order'),
        )


class UserTask(models.Model):
    user = models.ForeignKey(User, related_name='user_tasks')
    task = models.ForeignKey(Task, related_name='user_tasks')
    completed = models.BooleanField()

    class Meta:
        unique_together = (
            ('user', 'task'),
        )
