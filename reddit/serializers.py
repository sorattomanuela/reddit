from rest_framework import serializers
from reddit.models import Topic
from accounts.models import User

class TopicSerializer(serializers.ModelSerializer):
    class Meta:                     #passing informaion of models and fields to ModelSerializer
        model = Topic
        fields = ['name', 'title', 'description', 'url', 'slug', 'topic_url',]
        lookup_field = 'slug'
        extra_kwargs = {
            'url': {'lookup_field':'slug'}
        }

class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ['full_name', 'email',]