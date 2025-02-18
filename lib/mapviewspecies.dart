import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:http/http.dart' as http;

class MapViewSpeciesPage extends StatefulWidget {
  const MapViewSpeciesPage({
    super.key,
    required this.latitude,
    required this.longitude,
    required this.speciesImage,
  });

  final double latitude;
  final double longitude;
  final String speciesImage;

  @override
  State<MapViewSpeciesPage> createState() => _MapViewSpeciesPageState();
}

class _MapViewSpeciesPageState extends State<MapViewSpeciesPage> {
  MapLibreMapController? mapController; // Nullable to avoid null errors

  void _onMapCreated(MapLibreMapController controller) async {
    mapController = controller;

    // Ensure mapController is initialized before proceeding
    if (mapController == null) {
      debugPrint("Error: Map controller not initialized");
      return;
    }

    // Convert network image to Uint8List
    Uint8List? markerImage = await _fetchImage(widget.speciesImage);

    if (markerImage != null) {
      await mapController!.addImage("species-marker", markerImage);
    }

    // Ensure mapController is still available before adding marker
    if (mapController != null) {
      mapController!.addSymbol(
        SymbolOptions(
          geometry: LatLng(widget.latitude, widget.longitude),
          iconSize: 1.5,
          iconImage: markerImage != null ? "species-marker" : "marker-15",
        ),
      );
    } else {
      debugPrint("Error: Map controller became null before adding marker");
    }
  }

  // Fetch image from network and convert to Uint8List
  Future<Uint8List?> _fetchImage(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return response.bodyBytes;
      } else {
        debugPrint("Failed to load image: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Error loading image: $e");
    }
    return null;
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
