from rest_framework import serializers
from ..models.map import *


class MapSerializer(serializers.ModelSerializer):
    city = serializers.SlugRelatedField(read_only=True, slug_field='nl_name_2')
    completed = serializers.SerializerMethodField()

    class Meta:
        model = Map
        fields = ('id', 'name', 'desc', 'image_url', 'city', 'completed')

    def __init__(self, *args, **kwargs):
        if 'many' not in kwargs:
            self._user = kwargs.pop('user')
        super(MapSerializer, self).__init__(*args, **kwargs)

    def get_completed(self, map_):
        try:
            user_map = UserMap.objects.get(user=self._user, map=map_)
            return user_map.completed
        except UserMap.DoesNotExist:
            return False
