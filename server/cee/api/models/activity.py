from __future__ import unicode_literals

from django.db import models
from django.contrib.auth.models import User


class LoginAward(models.Model):
    desc = models.TextField()
    coin = models.IntegerField()
    gmt_start = models.DateField()
    gmt_end = models.DateField()

    class Meta:
        index_together = (
            ('gmt_start', 'gmt_end'),
        )


class UserLoginAward(models.Model):
    user = models.ForeignKey(User, related_name='user_login_awards')
    award = models.ForeignKey(LoginAward, related_name='user_login_awards')
    gmt_created = models.DateTimeField(auto_now_add=True)
