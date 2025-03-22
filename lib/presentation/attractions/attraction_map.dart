import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AttractionMap extends StatelessWidget {
  final LatLng location;

  const AttractionMap({super.key, required this.location});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Location'),
        backgroundColor: Colors.blue,
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: location,
          zoom: 14,
        ),
        markers: {
          Marker(
            markerId: const MarkerId('attraction'),
            position: location,
          ),
        },
      ),
    );
  }
}