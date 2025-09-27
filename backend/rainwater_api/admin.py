from django.contrib import admin
from .models import SiteProfile, Assessment, UserProfile

admin.site.register(SiteProfile)
admin.site.register(Assessment)
admin.site.register(UserProfile)
