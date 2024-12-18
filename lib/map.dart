import 'package:flutter/material.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

class HeatMap extends StatefulWidget {
  const HeatMap({super.key});

  @override
  State<HeatMap> createState() => _HeatMapState();
}

class _HeatMapState extends State<HeatMap> {
  late MaplibreMapController _mapController;

  // Initial position of the map
  final LatLng _initialPosition = const LatLng(37.7749, -122.4194); // Example: San Francisco

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Heat Map"),
      ),
      body: MaplibreMap(
        styleString: "https://demotiles.maplibre.org/style.json", // Default MapLibre style
        initialCameraPosition: CameraPosition(
          target: _initialPosition,
          zoom: 10.0, // Initial zoom level
        ),
        onMapCreated: _onMapCreated,
        myLocationEnabled: true,
        myLocationTrackingMode: MyLocationTrackingMode.tracking,
      ),
    );
  }

  void _onMapCreated(MaplibreMapController controller) {
    _mapController = controller;
    // Additional setup if needed, such as adding markers or layers.
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }
}
