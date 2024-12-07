import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HeatMap extends StatefulWidget {
  const HeatMap({super.key});

  @override
  State<HeatMap> createState() => _HeatMapState();
}

class _HeatMapState extends State<HeatMap> {
  late GoogleMapController _mapController;
  final LatLng _initialPosition = const LatLng(37.7749, -122.4194); // Example: San Francisco
  final Set<Marker> _markers = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text("Heat Map"),
      ),
      drawer: const Drawer(),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _initialPosition,
          zoom: 10.0,
        ),
        markers: _markers,
        onMapCreated: (GoogleMapController controller) {
          _mapController = controller;
          setState(() {
            _markers.add(
              Marker(
                markerId: const MarkerId('initial_marker'),
                position: _initialPosition,
                infoWindow: const InfoWindow(title: "San Francisco"),
              ),
            );
          });
        },
      ),
    );
  }
}
