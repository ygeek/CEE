from rest_framework import serializers

from .models import CityStory, UserMap, UserCoupon, Medal, Map, Option, Choice, Task, Story, Coupon, User, City

class CityStorySerializer(serializers.ModelSerializer):
    class Meta:
        model = CityStory
        fields = ('id', 'city', 'story')


class UserMapSerializer(serializers.ModelSerializer):
    class Meta:
        model = UserMap
        fields = ('id', 'user', 'map', 'completed')


class UserCouponSerializer(serializers.ModelSerializer):
    class Meta:
        model = UserCoupon
        fields = ('id', 'user', 'coupon')


class CitySerializer(serializers.ModelSerializer):
    class Meta:
        model = City
        fields = ('id', 'name')


class MedalSerializer(serializers.ModelSerializer):
    class Meta:
        model = Medal
        fields = ('id', 'name', 'desc', 'icon_url')


class MapSerializer(serializers.ModelSerializer):
    medal = MedalSerializer(read_only=True)

    class Meta:
        model = Map
        fields = ('id', 'name', 'desc', 'x', 'y', 'image_url', 'medal')


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


class StorySerializer(serializers.ModelSerializer):
    class Meta:
        model = Story
        fields = (
            'id',
            'name',
            'desc',
            'time',
            'good',
            'distance',
            'city'
        )


class CouponSerializer(serializers.ModelSerializer):
    class Meta:
        model = Coupon
        fields = (
            'id',
            'gmt_start',
            'gmt_end',
            'name',
            'desc',
            'state',
            'code'
        )


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
            'email',
        )
        write_only_fields = ('password',)
        read_only_fields = ('is_staff', 'is_superuser', 'is_active', 'date_joined')
