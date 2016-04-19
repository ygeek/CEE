from rest_framework import serializers
from ..models.map import *


class MapSerializer(serializers.ModelSerializer):
    completed = serializers.SerializerMethodField()

    class Meta:
        model = Map
        fields = ('id', 'name', 'desc', 'image_url', 'completed')

    def __init__(self, *args, **kargs):
        if 'many' not in kargs:
            self._user = kargs.pop('user')
        super(MapSerializer, self).__init__(*args, **kargs)

    def get_completed(self, map_):
        user_map = UserMap.objects.get(user=self._user, map=map_)
        return user_map.completed
