import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

typedef OnPolygonChanged = void Function(List<LatLng> polygon);

class MapWidget extends StatefulWidget {
  final List<LatLng> initialPolygon;
  final OnPolygonChanged onPolygonChanged;

  MapWidget({Key? key, this.initialPolygon = const [], required this.onPolygonChanged}) : super(key: key);

  @override
  _MapWidgetState createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  List<LatLng> polygon = [];

  @override
  void initState() {
    super.initState();
    polygon = List.from(widget.initialPolygon);
  }

  void _addPoint(LatLng point) {
    setState(() {
      polygon.add(point);
    });
    widget.onPolygonChanged(polygon);
  }

  void _clear() {
    setState(() {
      polygon.clear();
    });
    widget.onPolygonChanged(polygon);
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Expanded(
        child: FlutterMap(
          options: MapOptions(
            center: polygon.isNotEmpty ? polygon[0] : LatLng(20.5937, 78.9629),
            zoom: 13.0,
            onTap: (pos, latlng) => _addPoint(latlng),
          ),
          children: [
            TileLayer(
              urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
              subdomains: ['a', 'b', 'c'],
            ),
            if (polygon.isNotEmpty)
              PolygonLayer(polygons: [
                Polygon(points: polygon, color: Colors.blue.withOpacity(0.3), borderStrokeWidth: 2, borderColor: Colors.blue)
              ]),
            MarkerLayer(markers: polygon.asMap().entries.map((e) {
              return Marker(width: 30, height: 30, point: e.value, builder: (_) {
                return Container(
                  child: Icon(Icons.location_on, color: Colors.red),
                );
              });
            }).toList()),
          ],
        ),
      ),
      Row(
        children: [
          ElevatedButton(onPressed: _clear, child: Text("Clear polygon")),
          SizedBox(width: 12),
          Text("Tap map to add polygon vertices")
        ],
      )
    ]);
  }
}
