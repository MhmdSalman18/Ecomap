import 'package:flutter/material.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

class MapViewSpeciesPage extends StatefulWidget {
  const MapViewSpeciesPage({super.key, required this.latitude, required this.longitude});

  final double latitude;
  final double longitude;

  @override
  State<MapViewSpeciesPage> createState() => _MapViewSpeciesPageState();
}

class _MapViewSpeciesPageState extends State<MapViewSpeciesPage> {
  late MapLibreMapController mapController;

  void _onMapCreated(MapLibreMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map View Species'),
      ),
      body: MapLibreMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: LatLng(widget.latitude, widget.longitude), // Use the received latitude and longitude
          zoom: 14,
        ),
        styleString: 'https://demotiles.maplibre.org/style.json',
        myLocationEnabled: true,
        myLocationRenderMode: MyLocationRenderMode.normal,
      ),
    );
  }
}
