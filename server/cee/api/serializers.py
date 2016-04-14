from rest_framework import serializers

from .models import *


class MedalSerializer(serializers.ModelSerializer):
    class Meta:
        model = Medal
        fields = ('id', 'name', 'desc', 'icon_url')


class OptionSerializer(serializers.ModelSerializer):
    class Meta:
        model = Option
        fields = ('id', 'choice', 'order', 'desc')


class ChoiceSerializer(serializers.ModelSerializer):
    option_set = OptionSerializer(many=True, read_only=True)

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
            'option_set',
        )


class TaskSerializer(serializers.ModelSerializer):
    medal = MedalSerializer(read_only=True)
    choice_set = ChoiceSerializer(many=True, read_only=True)

    class Meta:
        model = Task
        fields = ('id', 'name', 'desc', 'medal', 'choice_set')


class StorySerializer(serializers.ModelSerializer):
    class Meta:
        story = Story
        fields = (
                'id',
                'story_id',
                'name',
                'desc',
                'time',
                'good',
                'distance',
                'city'
            )


class CouponSerializer(serializers.ModelSerializer):
    class Meta:
        coupon = Coupon
        fields = (
                'id',
                'coupon_id',
                'gmt_start',
                'gmt_end',
                'name',
                'desc',
                'state',
                'code'
                )


class UserSerializer(serializers.ModelSerializer):
    class Meta:
        user = User
        fields = (
                'id',
                'user_id'
                )
