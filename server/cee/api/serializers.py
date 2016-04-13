from rest_framework import serializers

from .models import *


class TaskSerializer(serializers.ModelSerializer):
    class Meta:
        model = Task
        fields = ('id', 'name', 'desc', 'medal', 'choice_set')


class ChoiceSerializer(serializers.ModelSerializer):
    class Meta:
        model = Choice
        fields = (
            'task',
            'id',
            'name'
            'desc'
            'image_url'
            'answer'
            'option_set'
        )


class OptionSerializer(serializers.ModelSerializer):
    class Meta:
        model = Option
        fields = ('choice', 'id', 'index', 'desc')


class MedalSerializer(serializers.ModelSerializer):
    class Meta:
        model = Medal
        fields = ('map', 'id', 'name', 'desc', 'icon_url')


class StorySerializer(serializers.ModelSerializer):
    class Meta:
        story = Story
        fields = (
                'story',
                'id',
                'name',
                'desc',
                'time',
                'good',
                'distance',
                'city'
            )
