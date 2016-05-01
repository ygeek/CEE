from rest_framework import serializers
from ..models.map import *


class UserMapSerializer(serializers.ModelSerializer):
    completed = serializers.BooleanField()
    class Meta:
        model = Map
        fields = ('id', 'name', 'desc', 'image_url', 'completed')
