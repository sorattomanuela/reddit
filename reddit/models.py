from django.db import models

# Create your models here.
from helpers.models import TimestampModel


class SubReddit(TimestampModel):
    name = models.CharField(max_length=100, blank=True, default='')
    title = models.CharField(max_length=100, blank=True, default='')
    author = models.ForeignKey('accounts.User', related_name='reddit', on_delete=models.CASCADE)
    description = models.TextField(default='categories')
    urlname = models.SlugField(max_length=100, db_index=True, allow_unicode=False)


    class Meta:
        ordering = ['created_at']

