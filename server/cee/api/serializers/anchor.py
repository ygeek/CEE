from rest_framework import serializers
from ..models.anchor import *


class AnchorSerializer(serializers.ModelSerializer):
    class Meta:
        model = Anchor
        fields = ('id', 'name', 'desc', 'dx', 'dy')


class MapAnchorSerializer(serializers.ModelSerializer):
    class Meta:
        model = MapAnchor
        fields = ('id', 'map', 'anchor')
