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
            'desc',
            'dx',
            'dy',
            'type',
            'ref_id',
            'completed',
        )

    def __init__(self, *args, **kargs):
        if 'many' not in kargs:
            self._user = kargs.pop('user')
        super(AnchorSerializer, self).__init__(*args, **kargs)

    def get_completed(self, anchor):
        if anchor.type == Anchor.Type.Task:
            user_task = UserTask.objects.get(
                user=self._user, task_id=anchor.ref_id)
            return user_task.completed
        #if anchor.type == Anchor.Type.Story:
        #    user_story = UserStory.objects.get(
        #        user=self._user, story_id=anchor.ref_id)
        #    return user_story.completed
        #assert False
        return False
