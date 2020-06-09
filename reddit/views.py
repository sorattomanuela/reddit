from reddit.models import Topic, Post, Comment
from reddit.permissions import IsAuthorOrReadOnly
from reddit.serializers import TopicSerializer, PostSerializer, CommentSerializer, UserSerializer
from rest_framework.permissions import AllowAny, IsAuthenticatedOrReadOnly
from rest_framework import viewsets
from accounts.models import User

class TopicViewSet(viewsets.ModelViewSet):
    queryset = Topic.objects.all()                              #read a list of objects from a database
    serializer_class = TopicSerializer
    permission_classes = [IsAuthenticatedOrReadOnly, IsAuthorOrReadOnly]
    lookup_field = 'urlname'

    def perform_create(self, serializer):
        serializer.save(author=self.request.user)

class PostViewSet(viewsets.ModelViewSet):
    queryset = Post.objects.all()
    serializer_class = PostSerializer
    permission_classes = [IsAuthenticatedOrReadOnly, IsAuthorOrReadOnly]

    def perform_create(self, serializer):
        topic_urlname = self.kwargs.get('topic_urlname')
        topic = Topic.objects.filter(urlname=topic_urlname).first()
        serializer.save(author=self.request.user, topic=topic)

class CommentViewSet(viewsets.ModelViewSet):
    queryset = Comment.objects.all()
    serializer_class = CommentSerializer
    permission_classes = [IsAuthenticatedOrReadOnly, IsAuthorOrReadOnly]

    def perform_create(self, serializer):
        post_id = self.kwargs.get('post_pk')
        post = Post.objects.filter(id=post_id).first()
        topic = post.topic                              #grabing list of objects from topic
        serializer.save(author=self.request.user, topic=topic, post=post)


