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
            'image_keys',
            'tour_img_key',
            'completed',
            'progress',
        )

    def __init__(self, *args, **kwargs):
        if 'many' not in kwargs:
            self._user = kwargs.pop('user')
        super(StorySerializer, self).__init__(*args, **kwargs)

    def get_completed(self, story):
        try:
            user_story = UserStory.objects.get(user=self._user, story=story)
            return user_story.completed
        except UserStory.DoesNotExist:
            return False

    def get_progress(self, story):
        try:
            user_story = UserStory.objects.get(user=self._user, story=story)
            return user_story.progress
        except UserStory.DoesNotExist:
            return 0


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


class ItemSerializer(serializers.ModelSerializer):
    content = serializers.DictField()

    class Meta:
        model = Item
        fields = ('id', 'name', 'activate_at', 'content')
