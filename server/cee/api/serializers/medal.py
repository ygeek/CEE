from rest_framework import serializers
from ..models.medal import *


class MedalSerializer(serializers.ModelSerializer):
    class Meta:
        model = Medal
        fields = ('id', 'name', 'desc', 'icon_key')
