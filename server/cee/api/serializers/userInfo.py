from rest_framework import serializers
from ..models.story import *
from ..models.auth import *
from ..models.medal import *
from ..models.map import *
from medal import *


class UserInfoSerializer(serializers.ModelSerializer):

    coin = serializers.SerializerMethodField()
    medals = MedalSerializer(many=True, read_only=True)
    friend_num = serializers.SerializerMethodField()
    finish_maps = serializers.SerializerMethodField()
    head_img_key = serializers.SerializerMethodField()

    class Meta:
        model = User
        fields = (
            'id',
            'coin',
            'medals',
            'head_img_key',
            'friend_num',
            'finish_maps',
        )

    def get_coin(self, user):
        try:
            user_coin = UserCoin.objects.get(user=user)
            return user_coin.amount
        except UserCoin.DoesNotExist:
            return 0

    def get_head_img_key(self, user):
        try:
            user_profile = UserProfile.objects.get(user=user)
            return user_profile.head_img_key
        except UserProfile.DoesNotExist:
            return None

    def get_friend_num(self, user):
        try:
            user_friends = UserFriend.objects.filter(user=user)
            return len(user_friends)
        except UserFriend.DoesNotExist:
            return 0

    def get_finish_maps(self, user):
        try:
            user_map = UserMap.objects.filter(user=user, completed=True)
            return len(user_map)
        except UserMap.DoesNotExist:
            return 0


class FriendInfoSerializer(serializers.ModelSerializer):

    nickname = serializers.SerializerMethodField()
    coin = serializers.SerializerMethodField()
    medals = serializers.SerializerMethodField()
    finish_maps = serializers.SerializerMethodField()
    head_img_key = serializers.SerializerMethodField()

    class Meta:
        model = User
        fields = (
            'id',
            'username',
            'nickname',
            'coin',
            'medals',
            'head_img_key',
            'finish_maps',
        )

    def get_nickname(self, user):
        try:
            user_profile = UserProfile.objects.get(user=user)
            return user_profile.nickname
        except UserProfile.DoesNotExist:
            return None

    def get_coin(self, user):
        try:
            user_coin = UserCoin.objects.get(user=user)
            return user_coin.amount
        except UserCoin.DoesNotExist:
            return 0

    def get_medals(self, user):
        try:
            user_medal = UserMedal.objects.filter(user=user)
            return len(user_medal)
        except UserMedal.DoesNotExist:
            return 0

    def get_head_img_key(self, user):
        try:
            user_profile = UserProfile.objects.get(user=user)
            return user_profile.head_img_key
        except UserProfile.DoesNotExist:
            return None

    def get_finish_maps(self, user):
        try:
            user_map = UserMap.objects.filter(user=user, completed=True)
            return len(user_map)
        except UserMap.DoesNotExist:
            return 0
