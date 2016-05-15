from rest_framework import serializers
from ..models.anchor import *
from ..models.task import *
from ..models.story import *


class UserAnchorSerializer(serializers.ModelSerializer):
    completed = serializers.BooleanField()

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


class AnchorSerializer(serializers.ModelSerializer):
    class Meta:
        model = Anchor
        fields = (
            'id',
            'name',
            'type',
            'dx',
            'dy'
        )