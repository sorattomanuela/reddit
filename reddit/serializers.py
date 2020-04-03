from rest_framework import serializers
from reddit.models import Topic, Post, Comment
from accounts.models import User

class TopicSerializer(serializers.ModelSerializer):
    class Meta:                     #passing information of models and fields to ModelSerializer
        model = Topic
        fields = ['name', 'title', 'description', 'url', 'slug', 'topic_url',]
        lookup_field = 'slug'
        extra_kwargs = {
            'url': {'lookup_field':'slug'}
        }

class PostSerializer(serializers.ModelSerializer):
    class Meta:
        model = Post
        fields = ['title', 'content', 'author', 'topic',]

class CommentSerializer(serializers.ModelSerializer):
    class Meta:
        model = Comment
        fields = ['author', 'content', 'topic', 'post',]

class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ['full_name', 'email',]