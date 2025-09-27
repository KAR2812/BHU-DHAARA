from django.contrib.gis.db import models
from django.contrib.auth.models import User
import uuid

class UserProfile(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE)
    phone = models.CharField(max_length=30, blank=True, null=True)
    aadhar = models.CharField(max_length=20, blank=True, null=True)

    def __str__(self):
        return self.user.username

class SiteProfile(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    owner = models.ForeignKey(User, related_name='sites', on_delete=models.CASCADE)
    site_name = models.CharField(max_length=200)
    geom = models.PolygonField(srid=4326)  # GeoDjango polygon
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"{self.site_name} ({self.owner.username})"

class Assessment(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    site = models.ForeignKey(SiteProfile, related_name='assessments', on_delete=models.CASCADE)
    feasible = models.BooleanField(default=False)
    recommended_type = models.CharField(max_length=200, blank=True)
    estimated_cost = models.FloatField(default=0.0)
    details = models.TextField(blank=True)
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"Assessment {self.id} for {self.site}"
