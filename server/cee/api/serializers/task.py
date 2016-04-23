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


class TaskSerializer(serializers.ModelSerializer):
    choices = ChoiceSerializer(many=True, read_only=True)
    completed = serializers.SerializerMethodField()

    class Meta:
        model = Task
        fields = ('id', 'name', 'desc', 'choices', 'completed')

    def __init__(self, *args, **kwargs):
        if 'many' not in kwargs:
            self._user = kwargs.pop('user')
        super(TaskSerializer, self).__init__(*args, **kwargs)

    def get_completed(self, task):
        user_task = UserTask.objects.get(user=self._user, task=task)
        return user_task.completed
