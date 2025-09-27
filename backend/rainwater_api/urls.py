from django.urls import path, include
from rest_framework import routers
from .views import SiteProfileViewSet, AssessmentViewSet

router = routers.DefaultRouter()
router.register(r'sites', SiteProfileViewSet, basename='siteprofile')
router.register(r'assessments', AssessmentViewSet, basename='assessment')

urlpatterns = [
    path('', include(router.urls)),
]
