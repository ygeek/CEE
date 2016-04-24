from rest_framework import serializers
from ..models.anchor import *
from ..models.task import *
from ..models.story import *


class AnchorSerializer(serializers.ModelSerializer):
    completed = serializers.SerializerMethodField()

    class Meta:
        model = Anchor
        fields = (
            'id',
            'name',
            'dx',
            'dy',
            'type',
            'ref_id',
            'completed',
        )

    def __init__(self, *args, **kwargs):
        if 'many' not in kwargs:
            self._user = kwargs.pop('user')
        super(AnchorSerializer, self).__init__(*args, **kwargs)

    def get_completed(self, anchor):
        if anchor.type == Anchor.Type.Task:
            try:
                user_task = UserTask.objects.get(
                    user=self._user, task_id=anchor.ref_id)
                return user_task.completed
            except UserTask.DoesNotExist:
                return False
        if anchor.type == Anchor.Type.Story:
            try:
                user_story = UserStory.objects.get(
                    user=self._user, story_id=anchor.ref_id)
                return user_story.completed
            except UserStory.DoesNotExist:
                return False
        assert False
        return False
