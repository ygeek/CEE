from __future__ import unicode_literals

from django.db import models


class City(models.Model):
    key = models.CharField(max_length=16, primary_key=True)
    name = models.CharField(max_length=64)
    initials = models.CharField(max_length=16)
    pingyin = models.CharField(max_length=64)
    short_name = models.CharField(max_length=64)

    def __unicode__(self):
        return '%s, %s, %s' % (self.name, self.pingyin, self.short_name)
