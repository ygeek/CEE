from rest_framework import serializers
from ..models.task import *


class AnchorTaskSerializer(serializers.ModelSerializer):
    class Meta:
        model = AnchorTask
        fields = ('id', 'anchor', 'task')


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


class TaskSerializer(serializers.ModelSerializer):
    choices = ChoiceSerializer(many=True, read_only=True)

    class Meta:
        model = Task
        fields = ('id', 'name', 'desc', 'choices')
