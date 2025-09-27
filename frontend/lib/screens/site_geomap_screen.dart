import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import '../widgets/map_widget.dart';
import '../models/site_profile.dart';
import '../services/api_service.dart';

class SiteGeomapScreen extends StatefulWidget {
  final String userId;
  SiteGeomapScreen({required this.userId});

  @override
  _SiteGeomapScreenState createState() => _SiteGeomapScreenState();
}

class _SiteGeomapScreenState extends State<SiteGeomapScreen> {
  List<LatLng> polygon = [];
  final _name = TextEditingController();
  final api = ApiService();

  void _onPolygonChanged(List<LatLng> p) => setState(() { polygon = p; });

  void _submit() async {
    if (polygon.length < 3) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Draw at least 3 points')));
      return;
    }
    final site = SiteProfile(id: api.newSiteId(), userId: widget.userId, siteName: _name.text.trim().isEmpty ? "Unnamed" : _name.text.trim(), polygon: polygon);
    final ok = await api.submitSiteProfile(site);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(ok ? 'Site saved' : 'Failed to save')));
    if (ok) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Geomap Site')),
      body: Column(children: [
        Padding(padding: const EdgeInsets.all(8.0), child: TextField(controller: _name, decoration: InputDecoration(labelText: 'Site name'))),
        Expanded(child: MapWidget(initialPolygon: polygon, onPolygonChanged: _onPolygonChanged)),
        ElevatedButton(onPressed: _submit, child: const Text('Submit site geometry')),
      ]),
    );
  }
}
