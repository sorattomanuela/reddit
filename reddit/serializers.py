from rest_framework import serializers
from reddit.models import Topic, Post, Comment
from accounts.models import User


class CommentSerializer(serializers.ModelSerializer):
    author = serializers.ReadOnlyField(source='author.username')
    topic = serializers.ReadOnlyField(source='topic.urlname')
    post = serializers.ReadOnlyField(source='post.title')
    class Meta:
        model = Comment
        fields = ['author', 'content', 'topic', 'post',]
        read_only_fields = ['author', 'topic', 'post',]


class PostSerializer(serializers.ModelSerializer):
    author = serializers.ReadOnlyField(source='author.username')
    topic = serializers.ReadOnlyField(source='topic.urlname')
    comments = CommentSerializer(many=True)
    class Meta:
        model = Post
        fields = ['id', 'title', 'content', 'author', 'topic', 'comments',]
        read_only_fields = ['author', 'topic', 'comments',]


class TopicSerializer(serializers.ModelSerializer):
    posts = PostSerializer(many=True)
    class Meta:                     #passing information of models and fields to ModelSerializer
        model = Topic
        fields = ['name', 'title', 'description', 'urlname', 'posts',]
        lookup_field = 'urlname'
        read_only_fields = ['urlname', 'posts',]


class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ['full_name', 'email',]