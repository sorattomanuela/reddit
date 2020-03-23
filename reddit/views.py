from django.shortcuts import render

# Create your views here.
from reddit.models import SubReddit
from reddit.serializers import SubRedditSerializer
from reddit.permissions import IsAuthorOrReadOnly
from rest_framework import viewsets, permissions
from accounts.models import User
from reddit.serializers import UserSerializer

class SubRedditViewSet(viewsets.ModelViewSet):
    queryset = SubReddit.objects.all()
    serializer_class = SubRedditSerializer
    #permission_classes = [permissions.IsAuthenticatedOrReadOnly, IsAuthorOrReadOnly]
    permission_classes = []

    def perform_create(self, serializer):
        serializer.save(author=self.request.user)

class UserViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = User.objects.all()
    serializer_class = UserSerializer
    permission_classes = []
