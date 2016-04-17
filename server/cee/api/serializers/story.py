from rest_framework import serializers
from ..models.story import *


class CitySerializer(serializers.ModelSerializer):
    class Meta:
        model = City
        fields = ('id', 'name')


class AnchorStorySerializer(serializers.ModelSerializer):
    class Meta:
        model = AnchorStory
        fields = ('id', 'anchor', 'story')


class LevelSerializer(serializers.ModelSerializer):
    class Meta:
        model = Level
        fields = (
            'id',
            'type',
            'name',
            'video_url',
            'img_url',
            'text',
            'number_answer',
            'h5_url'
        )


class StoryLevelSerializer(serializers.ModelSerializer):
    class Meta:
        model = StoryLevel
        fields = ('id', 'story', 'level')


class CityStorySerializer(serializers.ModelSerializer):
    class Meta:
        model = CityStory
        fields = ('id', 'city', 'story')


class ItemSerializer(serializers.ModelSerializer):
    class Meta:
        model = Item
        fields = ('id', 'item_type', 'title', 'desc', 'data')


class UserItemSerializer(serializers.ModelSerializer):
    class Meta:
        model = UserItem
        fields = ('id', 'user', 'item')


class StorySerializer(serializers.ModelSerializer):
    class Meta:
        model = Story
        fields = (
            'id',
            'name',
            'desc',
            'time',
            'good',
            'distance',
            'city'
        )
