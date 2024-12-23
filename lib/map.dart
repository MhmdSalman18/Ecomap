import 'package:flutter/material.dart';
// import 'package:maplibre_gl/maplibre_gl.dart';

class HeatMap extends StatefulWidget {
  const HeatMap({super.key});

  @override
  State<HeatMap> createState() => _HeatMapState();
}

class _HeatMapState extends State<HeatMap> {
  // late MapLibreMapController mapController;

  // Initial position of the map
  // final LatLng initialPosition = LatLng(37.7749, -122.4194); // Example: San Francisco

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Heat Map"),
      ),
      // body: MapLibreMap(
      //   styleString: 'https://demotiles.maplibre.org/style.json', // Default MapLibre style
      //   initialCameraPosition: CameraPosition(
      //     target: initialPosition,
      //     zoom: 10.0,
      //   ),
      //   onMapCreated: _onMapCreated,
      // ),
    );
  }

  // void _onMapCreated(MapLibreMapController controller) {
  //   mapController = controller;
  //   // Additional setup can be done here
  // }
}
