from django.urls import path, include
from rest_framework.routers import DefaultRouter
from reddit import views

router = DefaultRouter() #solve the urls forward path
router.register(r'sub-reddit', views.SubRedditViewSet)
router.register(r'users', views.UserViewSet)

urlpatterns = [
    path('', include(router.urls))
]