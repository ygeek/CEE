from rest_framework import serializers
from ..models.map import *


class MapSerializer(serializers.ModelSerializer):
    class Meta:
        model = Map
        fields = ('id', 'name', 'desc', 'image_url')


class UserMapSerializer(serializers.ModelSerializer):
    map = MapSerializer(read_only=True)

    class Meta:
        model = UserMap
        fields = ('map', 'completed')
