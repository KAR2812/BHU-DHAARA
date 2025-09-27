import 'package:flutter/material.dart';
import '../services/api_service.dart';

class AssessmentScreen extends StatefulWidget {
  @override
  _AssessmentScreenState createState() => _AssessmentScreenState();
}

class _AssessmentScreenState extends State<AssessmentScreen> {
  final _siteId = TextEditingController();
  final api = ApiService();
  Map<String, dynamic>? assessment;
  bool loading = false;

  void _fetch() async {
    setState(() { loading = true; });
    final res = await api.getAssessment(_siteId.text.trim());
    setState(() { assessment = res; loading = false; });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Assessment')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [
          TextField(controller: _siteId, decoration: InputDecoration(labelText: 'Site ID')),
          ElevatedButton(onPressed: _fetch, child: Text('Fetch assessment')),
          if (loading) CircularProgressIndicator(),
          if (assessment != null)
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: SingleChildScrollView(
                    child: Text(assessment.toString()),
                  ),
                ),
              ),
            ),
        ]),
      ),
    );
  }
}
