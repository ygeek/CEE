from rest_framework import serializers
from ..models.story import *


class UserInfoSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ('id')
