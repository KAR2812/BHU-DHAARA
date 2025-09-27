import 'package:latlong2/latlong.dart';

class SiteProfile {
  final String id;
  final String userId;
  final String siteName;
  final List<LatLng> polygon; // polygon coordinates, ordered

  SiteProfile({required this.id, required this.userId, required this.siteName, required this.polygon});

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "user_id": userId,
      "site_name": siteName,
      "polygon": polygon.map((p) => [p.latitude, p.longitude]).toList(),
    };
  }

  factory SiteProfile.fromMap(Map<String, dynamic> m) {
    List coords = m['polygon'] ?? [];
    List<LatLng> polygon = coords.map<LatLng>((c) => LatLng(c[0], c[1])).toList();
    return SiteProfile(id: m['id'], userId: m['user_id'], siteName: m['site_name'], polygon: polygon);
  }
}
