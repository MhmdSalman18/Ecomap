import 'package:flutter/material.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

class MySpottingsMapPage extends StatefulWidget {
  final double latitude;
  final double longitude;

  const MySpottingsMapPage({
    super.key,
    required this.latitude,
    required this.longitude,
  });

  @override
  State<MySpottingsMapPage> createState() => _MySpottingsMapPageState();
}

class _MySpottingsMapPageState extends State<MySpottingsMapPage> {
  MapLibreMapController? mapController;

  void _onMapCreated(MapLibreMapController controller) {
    mapController = controller;
    
    // Add marker after map is initialized
    _addMarker();
  }

  void _addMarker() async {
    if (mapController != null) {
      await Future.delayed(const Duration(milliseconds: 500));
      
      try {
        await mapController!.addSymbol(
          SymbolOptions(
            geometry: LatLng(widget.latitude, widget.longitude),
            iconImage: 'marker',
            iconSize: 1.5,
          ),
        );
      } catch (e) {
        debugPrint('Error adding marker: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Spotting Location')),
      body: MapLibreMap(  // Changed from MaplibreMap to MapLibreMap
        onMapCreated: _onMapCreated,
        onStyleLoadedCallback: _addMarker,
        initialCameraPosition: CameraPosition(
          target: LatLng(widget.latitude, widget.longitude),
          zoom: 14,
        ),
        styleString: 'https://demotiles.maplibre.org/style.json',
        myLocationEnabled: true,
        myLocationRenderMode: MyLocationRenderMode.normal,
      ),
    );
  }
}