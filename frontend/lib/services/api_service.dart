import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';
import '../models/site_profile.dart';
import 'package:latlong2/latlong.dart';
import 'package:uuid/uuid.dart';

class ApiService {
  final base = Constants.apiBase;
  final uuid = Uuid();

  Future<bool> submitSiteProfile(SiteProfile site) async {
    final url = Uri.parse('$base/sites/');
    final payload = {
      "id": site.id,
      "user_id": site.userId,
      "site_name": site.siteName,
      "polygon": site.polygon.map((p) => [p.latitude, p.longitude]).toList(),
    };
    final res = await http.post(url, body: jsonEncode(payload), headers: {'Content-Type': 'application/json'});
    return res.statusCode == 201 || res.statusCode == 200;
  }

  Future<Map<String, dynamic>?> getAssessment(String siteId) async {
    final url = Uri.parse('$base/assessments/?site_id=$siteId');
    final res = await http.get(url);
    if (res.statusCode == 200) {
      final list = jsonDecode(res.body);
      if (list is List && list.isNotEmpty) return list[0];
    }
    return null;
  }

  // helper to create new site id
  String newSiteId() => uuid.v4();
}
