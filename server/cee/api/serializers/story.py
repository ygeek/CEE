from rest_framework import serializers
from ..models.story import *


class UserStorySerializer(serializers.ModelSerializer):
    image_keys = serializers.ListField()
    completed = serializers.BooleanField()
    progress = serializers.IntegerField()

    class Meta:
        model = Story
        fields = (
            'id',
            'name',
            'desc',
            'time',
            'good',
            'distance',
            'image_keys',
            'tour_img_key',
            'completed',
            'progress',
        )


class LevelSerializer(serializers.ModelSerializer):
    content = serializers.DictField()
    order = serializers.IntegerField()

    class Meta:
        model = Level
        fields = ('id', 'name', 'order', 'content')


class ItemSerializer(serializers.ModelSerializer):
    content = serializers.DictField()

    class Meta:
        model = Item
        fields = ('id', 'name', 'activate_at', 'content')
