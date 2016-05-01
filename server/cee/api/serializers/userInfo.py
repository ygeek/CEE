from rest_framework import serializers
from ..models.story import *
from ..models.auth import *
from ..models.medal import *

class UserInfoSerializer(serializers.ModelSerializer):

    coin = serializers.SerializerMethodField()
    medals = serializers.SerializerMethodField()
    head_img = serializers.SerializerMethodField()

    class Meta:
        model = User
        fields = ('id','coin','medals','head_img')


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

    def get_head_img(self, user):
        try:
            user_profile = UserProfile.objects.get(user=user)
            return user_profile.head_img_key
        except UserProfile.DoesNotExist:
            return None

