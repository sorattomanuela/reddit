from django.shortcuts import render

# Create your views here.
from reddit.models import Topic, Post, Comment
from reddit.serializers import TopicSerializer, PostSerializer, CommentSerializer
from reddit.permissions import IsAuthorOrReadOnly
from rest_framework import viewsets, permissions
from accounts.models import User
from reddit.serializers import UserSerializer

class TopicViewSet(viewsets.ModelViewSet):
    queryset = Topic.objects.all() #read a list of objects from a database
    serializer_class = TopicSerializer
    #permission_classes = [permissions.IsAuthenticatedOrReadOnly, IsAuthorOrReadOnly]
    permission_classes = []
    lookup_field = 'slug'

    def perform_create(self, serializer):
        serializer.save(author=self.request.user)

class PostViewSet(viewsets.ModelViewSet):
    queryset = Post.objects.all()
    serializer_class = PostSerializer
    permission_classes = []

    def perform_create(self, serializer):
        serializer.save(author=self.request.user)

class CommentViewSet(viewsets.ModelViewSet):
    queryset = Comment.objects.all()
    serializer_class = CommentSerializer
    permission_classes = []

    def perform_create(self, serializer):
        serializer.save(author=self.request.user)

class UserViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = User.objects.all()
    serializer_class = UserSerializer
    permission_classes = []
