from __future__ import absolute_import

from rest_framework import serializers

from ..models import *


class UserSerializer(serializers.ModelSerializer):
    def create(self, validated_data):
        user = super(UserSerializer, self).create(validated_data)
        user.set_password(validated_data['password'])
        return user

    def update(self, instance, validated_data):
        user = super(UserSerializer, self).update(instance=instance, validated_data=validated_data)
        user.set_password(validated_data['password'])
        user.save()
        return user

    class Meta:
        user = User
        fields = (
            'username',
            'password',
        )
        write_only_fields = ('password',)
        read_only_fields = ('is_staff', 'is_superuser', 'is_active', 'date_joined')


class UserProfileSerializer(serializers.ModelSerializer):
    class Meta:
        model = UserProfile
        fields = (
            'nickname',
            'head_img_key',
            'sex',
            'birthday',
            'mobile',
            'location',
        )
