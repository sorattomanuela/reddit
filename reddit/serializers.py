from rest_framework import serializers
from reddit.models import Topic, Post, Comment
from accounts.models import User

class PostSerializer(serializers.ModelSerializer):
    author = serializers.ReadOnlyField(source='author.username')
    topic = serializers.ReadOnlyField(source='topic.urlname')
    class Meta:
        model = Post
        fields = ['title', 'content', 'author', 'topic',]
        read_only_fields = ['author', 'topic',]


class TopicSerializer(serializers.ModelSerializer):
    posts = PostSerializer(many=True)
    class Meta:                     #passing information of models and fields to ModelSerializer
        model = Topic
        fields = ['name', 'title', 'description', 'urlname', 'posts',]
        lookup_field = 'urlname'
        read_only_fields = ['urlname', 'posts',]

class CommentSerializer(serializers.ModelSerializer):
    class Meta:
        model = Comment
        fields = ['author', 'content', 'topic', 'post',]


class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ['full_name', 'email',]