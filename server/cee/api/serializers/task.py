from rest_framework import serializers
from ..models.task import *


class OptionSerializer(serializers.ModelSerializer):
    class Meta:
        model = Option
        fields = ('id', 'choice', 'order', 'desc')


class ChoiceSerializer(serializers.ModelSerializer):
    options = OptionSerializer(many=True, read_only=True)

    class Meta:
        model = Choice
        fields = (
            'id',
            'task',
            'order',
            'name',
            'desc',
            'image_url',
            'answer',
            'options',
        )


class UserTaskSerializer(serializers.ModelSerializer):
    choices = ChoiceSerializer(many=True, read_only=True)
    completed = serializers.BooleanField()

    class Meta:
        model = Task
        fields = ('id', 'name', 'desc', 'choices', 'completed')
