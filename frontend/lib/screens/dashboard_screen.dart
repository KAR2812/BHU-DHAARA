import 'package:flutter/material.dart';
import 'site_geomap_screen.dart';
import 'assessment_screen.dart';

class DashboardScreen extends StatelessWidget {
  final String userId;
  DashboardScreen({required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [
          ElevatedButton(onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => SiteGeomapScreen(userId: userId)));
          }, child: Text('Add / Geomap Site')),
          ElevatedButton(onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => AssessmentScreen()));
          }, child: Text('View Assessments')),
        ]),
      ),
    );
  }
}
