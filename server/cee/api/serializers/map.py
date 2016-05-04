from rest_framework import serializers
from ..models.map import *


class UserMapSerializer(serializers.ModelSerializer):
    completed = serializers.BooleanField()
    class Meta:
        model = Map
        fields = ('id',
                  'name',
                  'desc',
                  'longitude',
                  'latitude',
                  'image_key',
                  'icon_key',
                  'summary_image_key',
                  'city',
                  'completed')
