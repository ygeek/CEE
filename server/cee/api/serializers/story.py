from rest_framework import serializers
from ..models.story import *


class StorySerializer(serializers.ModelSerializer):
    image_urls = serializers.SerializerMethodField()
    completed = serializers.SerializerMethodField()

    class Meta:
        model = Story
        fields = (
            'id',
            'name',
            'desc',
            'time',
            'good',
            'distance',
            'city',
            'image_urls',
            'completed',
            'levels',
        )

    def __init__(self, *args, **kwargs):
        if 'many' not in kwargs:
            self._user = kwargs.pop('user')
        super(StorySerializer, self).__init__(*args, **kwargs)

    def get_image_urls(self, story):
        return story.image_urls

    def get_completed(self, story):
        user_story = UserStory.objects.get(user=self._user, story=story)
        return user_story.completed


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
