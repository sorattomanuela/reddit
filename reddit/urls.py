from django.urls import path, include
from rest_framework_nested import routers
from reddit import views


router = routers.DefaultRouter()
router.register(r'topics', views.TopicViewSet, basename='topic')

topics_router = routers.NestedSimpleRouter(router, r'topics', lookup='topic')
topics_router.register(r'posts', views.PostViewSet, basename='post')

posts_router = routers.NestedSimpleRouter(topics_router, r'posts', lookup='post')
posts_router.register(r'comments', views.CommentViewSet, basename='comment')

urlpatterns = [
    path('', include(router.urls)),
    path('', include(topics_router.urls)),
    path('', include(posts_router.urls)),
]