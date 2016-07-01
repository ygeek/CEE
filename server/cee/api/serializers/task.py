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
            'image_key',
            'answer',
            'answer_message',
            'answer_next',
            'answer_image_key',
            'options',
        )


class UserTaskSerializer(serializers.ModelSerializer):
    choices = ChoiceSerializer(many=True, read_only=True)
    completed = serializers.BooleanField()

    class Meta:
        model = Task
        fields = ('id',
                  'name',
                  'desc',
                  'location',
                  'detail_location',
                  'phone',
                  'choices',
                  'completed')
