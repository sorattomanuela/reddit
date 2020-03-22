from rest_framework import serializers
from reddit.models import SubReddit
from accounts.models import User

class SubRedditSerializer(serializers.ModelSerializer):
    class Meta:
        model = SubReddit
        fields = ['name', 'title', 'author', 'description', 'urlname',]

class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ['full_name', 'email',]