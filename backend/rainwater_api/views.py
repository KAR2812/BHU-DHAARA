from rest_framework import viewsets, status
from rest_framework.decorators import action
from rest_framework.response import Response
from django.contrib.auth.models import User
from .models import SiteProfile, Assessment
from .serializers import SiteProfileSerializer, AssessmentSerializer, UserSerializer
from rest_framework.permissions import AllowAny
from django.shortcuts import get_object_or_404

class SiteProfileViewSet(viewsets.ModelViewSet):
    queryset = SiteProfile.objects.all()
    serializer_class = SiteProfileSerializer
    permission_classes = [AllowAny]  # adjust in production

    def create(self, request, *args, **kwargs):
        # Expect owner as user id in payload, or create dummy owner
        owner_id = request.data.get('user_id')
        if owner_id:
            owner = get_object_or_404(User, pk=owner_id)
            request.data['owner'] = owner.pk
        else:
            # fallback to first user
            owner = User.objects.first()
            request.data['owner'] = owner.pk if owner else None
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        site = serializer.save()
        return Response(self.get_serializer(site).data, status=status.HTTP_201_CREATED)

class AssessmentViewSet(viewsets.ModelViewSet):
    queryset = Assessment.objects.all().order_by('-created_at')
    serializer_class = AssessmentSerializer
    permission_classes = [AllowAny]

    @action(detail=False, methods=['get'])
    def by_site(self, request):
        site_id = request.query_params.get('site_id')
        if not site_id:
            return Response({"detail":"site_id param required"}, status=status.HTTP_400_BAD_REQUEST)
        assessments = self.get_queryset().filter(site__id=site_id)
        serializer = self.get_serializer(assessments, many=True)
        return Response(serializer.data)

    def create(self, request, *args, **kwargs):
        # Here you could run ML model to compute feasibility before saving
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        assessment = serializer.save()
        return Response(self.get_serializer(assessment).data, status=status.HTTP_201_CREATED)
