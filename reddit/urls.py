from django.urls import path, include
from rest_framework_nested import routers
from reddit import views


router = routers.DefaultRouter()
router.register(r'topics', views.TopicViewSet, basename='topic')
router.register(r'users', views.UserViewSet, basename='user')

topics_router = routers.NestedSimpleRouter(router, r'topics', lookup='topic')
topics_router.register(r'posts', views.PostViewSet, basename='post')

urlpatterns = [
    path('', include(router.urls)),
    path('', include(topics_router.urls)),
]