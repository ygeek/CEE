from rest_framework import serializers
from ..models.map import *


class MapSerializer(serializers.ModelSerializer):
    class Meta:
        model = Map
        fields = ('id', 'name', 'desc', 'image_url')


class UserMapSerializer(MapSerializer):
    completed = serializers.BooleanField()

    class Meta(MapSerializer.Meta):
        fields = MapSerializer.Meta.fields + ('completed', )
