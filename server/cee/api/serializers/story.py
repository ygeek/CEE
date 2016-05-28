from rest_framework import serializers
from ..models.story import *


class UserStorySerializer(serializers.ModelSerializer):
    tags = serializers.ListField()
    image_keys = serializers.ListField()
    completed = serializers.BooleanField(required=False)
    progress = serializers.IntegerField(required=False)
    like = serializers.BooleanField(required=False)

    class Meta:
        model = Story
        fields = (
            'id',
            'name',
            'desc',
            'time',
            'good',
            'difficulty',
            'distance',
            'tags',
            'coin',
            'image_keys',
            'tour_image_key',
            'hud_image_key',
            'published',
            'completed',
            'progress',
            'like',
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
