from rest_framework import serializers
from ..models.story import *


class StorySerializer(serializers.ModelSerializer):
    image_urls = serializers.ListField()
    completed = serializers.SerializerMethodField()
    progress = serializers.SerializerMethodField()

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
            'progress',
            'levels',
        )

    def __init__(self, *args, **kwargs):
        if 'many' not in kwargs:
            self._user = kwargs.pop('user')
        super(StorySerializer, self).__init__(*args, **kwargs)

    def get_completed(self, story):
        user_story = UserStory.objects.get(user=self._user, story=story)
        return user_story.completed

    def get_progress(self, story):
        user_story = UserStory.objects.get(user=self._user, story=story)
        return user_story.progress


class LevelSerializer(serializers.ModelSerializer):
    content = serializers.DictField()
    order = serializers.SerializerMethodField()

    class Meta:
        model = Level
        fields = ('id', 'name', 'order', 'content')

    def __init__(self, *args, **kwargs):
        if 'many' not in kwargs:
            self._story = kwargs.pop('story')
        super(LevelSerializer, self).__init__(*args, **kwargs)

    def get_order(self, level):
        return StoryLevel.objects.get(story=self._story, level=level).order


class CitySerializer(serializers.ModelSerializer):
    class Meta:
        model = City
        fields = ('id', 'name')


class AnchorStorySerializer(serializers.ModelSerializer):
    class Meta:
        model = AnchorStory
        fields = ('id', 'anchor', 'story')


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
