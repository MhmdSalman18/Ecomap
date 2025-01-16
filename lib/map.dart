import 'package:flutter/material.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'dart:typed_data'; // for handling byte arrays

class HeatMap extends StatefulWidget {
  const HeatMap({super.key});

  @override
  State<HeatMap> createState() => _HeatMapState();
}

class _HeatMapState extends State<HeatMap> {
  late MapLibreMapController mapController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("HeatMap Example")),
      body: Container(
        height: MediaQuery.of(context).size.height, // Full screen height
        child: MapLibreMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: const CameraPosition(
            target: LatLng(37.7749, -122.4194), // San Francisco's coordinates
            zoom: 12,
          ),
          styleString: "https://demotiles.maplibre.org/style.json", // Map style URL
        ),
      ),
    );
  }

  void _onMapCreated(MapLibreMapController controller) {
    mapController = controller;
    _addHeatMapMarkers();
  }

  // Add custom markers to the map
  void _addHeatMapMarkers() async {
    // Sample data with geo-coordinates
    List<LatLng> points = [
      const LatLng(37.7749, -122.4194),
      const LatLng(37.7750, -122.4195),
      const LatLng(37.7751, -122.4196),
      // Add more coordinates as necessary
    ];

    // Load a custom icon and add it to the map style
    await mapController.addImage(
      "custom-marker", // The image name you will reference later
      await _loadCustomMarkerImage(), // Load the image as a byte array
    );

    // Add markers using the custom image
    for (var point in points) {
      await mapController.addSymbol(
        SymbolOptions(
          geometry: point,
          iconImage: "custom-marker", // Reference the image name here
          iconSize: 0.5, // Adjust size
          iconColor: "#FF0000", // Marker color (if applicable)
        ),
      );
    }
  }

  // Load the custom marker image as a byte array
  Future<Uint8List> _loadCustomMarkerImage() async {
    final ByteData data = await DefaultAssetBundle.of(context).load('assets/custom_marker.png');
    return data.buffer.asUint8List();
  }
}
