from __future__ import unicode_literals

# This is an auto-generated Django model module created by ogrinspect.
from django.contrib.gis.db import models as gismodels


class City(gismodels.Model):
    id_0 = gismodels.IntegerField()
    iso = gismodels.CharField(max_length=3)
    name_0 = gismodels.CharField(max_length=75)
    id_1 = gismodels.IntegerField()
    name_1 = gismodels.CharField(max_length=75)
    id_2 = gismodels.IntegerField()
    name_2 = gismodels.CharField(max_length=75)
    hasc_2 = gismodels.CharField(max_length=15)
    ccn_2 = gismodels.IntegerField()
    cca_2 = gismodels.CharField(max_length=254)
    type_2 = gismodels.CharField(max_length=50)
    engtype_2 = gismodels.CharField(max_length=50)
    nl_name_2 = gismodels.CharField(max_length=75)
    varname_2 = gismodels.CharField(max_length=150)
    geom = gismodels.MultiPolygonField(srid=-1)

    def __unicode__(self):
        return '{}, {}, {}'.format(self.name_1, self.name_2, self.nl_name_2)
