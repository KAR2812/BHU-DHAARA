from rest_framework import serializers
from django.contrib.gis.geos import Polygon, GEOSGeometry
from .models import SiteProfile, Assessment
from django.contrib.auth.models import User

class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ('id', 'username', 'email')

class SiteProfileSerializer(serializers.ModelSerializer):
    polygon = serializers.ListField(child=serializers.ListField(child=serializers.FloatField()), write_only=True)
    geom = serializers.SerializerMethodField(read_only=True)

    class Meta:
        model = SiteProfile
        fields = ('id', 'owner', 'site_name', 'polygon', 'geom', 'created_at')
        read_only_fields = ('id', 'created_at', 'geom')

    def get_geom(self, obj):
        return obj.geom.geojson

    def create(self, validated_data):
        polygon = validated_data.pop('polygon')
        # Expect polygon as list of [lat, lon] pairs. Convert to lon-lat for GeoDjango (x=lon,y=lat)
        coords = [(c[1], c[0]) for c in polygon]
        # Ensure polygon is closed
        if coords[0] != coords[-1]:
            coords.append(coords[0])
        geom = Polygon(coords)
        site = SiteProfile.objects.create(geom=geom, **validated_data)
        return site

class AssessmentSerializer(serializers.ModelSerializer):
    site = serializers.PrimaryKeyRelatedField(queryset=SiteProfile.objects.all())
    class Meta:
        model = Assessment
        fields = ('id', 'site', 'feasible', 'recommended_type', 'estimated_cost', 'details', 'created_at')
        read_only_fields = ('id', 'created_at')
