from django.db import models

# Create your models here.
from django.utils.text import slugify

from helpers.models import TimestampModel


class Topic(TimestampModel):
    name = models.CharField(max_length=100, blank=True, default='')
    title = models.CharField(max_length=100, blank=True, default='')
    author = models.ForeignKey('accounts.User', related_name='topics', on_delete=models.CASCADE) #related_name to specifies the name of reverse relation from the user back to model
    description = models.TextField(default='categories')
    urlname = models.SlugField(max_length=100)

    def save(self, *args, **kwargs):
        self.urlname = slugify(self.title)
        super().save(*args, **kwargs)


    class Meta:
        ordering = ['created_at']

class Post(TimestampModel):
    title = models.CharField(max_length=100, blank=True, default='')
    content = models.TextField(default='categories')
    author = models.ForeignKey('accounts.User', related_name='posts', on_delete=models.CASCADE)
    topic = models.ForeignKey('reddit.Topic', related_name='posts', on_delete=models.CASCADE)

    class Meta:
        ordering = ['created_at', 'updated_at',]

class Comment(TimestampModel):
    content = models.TextField(default='categories')
    author = models.ForeignKey('accounts.User', related_name='comments', on_delete=models.CASCADE)
    topic = models.ForeignKey('reddit.Topic', related_name='comments', on_delete=models.CASCADE)
    post = models.ForeignKey('reddit.Post', related_name='comments', on_delete=models.CASCADE)

    class Meta:
        ordering = ['created_at', 'updated_at',]

