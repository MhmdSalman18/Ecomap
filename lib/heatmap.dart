import 'package:ecomap/REGISTRATION/account.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> fetchGeoJsonData() async {
  final response = await http.get(Uri.parse('https://ecomap-zehf.onrender.com/user/map'));

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);

    // Ensure each feature has a weight property
    List<dynamic> features = data["features"];
    for (var feature in features) {
      feature["properties"] ??= {}; // Ensure properties exist
      feature["properties"]["weight"] ??= 1.0; // Set default weight if missing
    }

    return data;
  } else {
    throw Exception('Failed to load GeoJSON data');
  }
}

class HeatMap extends StatefulWidget {
  const HeatMap({super.key});

  @override
  State<HeatMap> createState() => _HeatMapState();
}

class _HeatMapState extends State<HeatMap> {
  late MapLibreMapController mapController;
  Map<String, dynamic>? geoJsonData;

  @override
  void initState() {
    super.initState();
    _loadGeoJsonData();
  }

  void _loadGeoJsonData() async {
    try {
      final data = await fetchGeoJsonData();
      setState(() {
        geoJsonData = data;
      });
    } catch (e) {
      debugPrint("Error loading GeoJSON data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
   backgroundColor: Color(0xFF082517),
      appBar: AppBar(
        backgroundColor: Color(0xFF082517),
        iconTheme: IconThemeData(
          color: Color(0xFFB4E576),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AccountPage(),
                  ),
                );
              },
              child: CircleAvatar(),
            ),
          ),
        ],
      ),
      body: geoJsonData == null
          ?  Center(child:  Lottie.asset(
                'assets/animations/main_scene.json',
                width: 100, // Adjust the width as needed
                height: 100, // Adjust the height as needed
              ),) // Show loading spinner
          : MapLibreMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: const CameraPosition(
                target: LatLng(10.8505, 76.2711), // Default center of Kerala
                zoom: 8,
              ),
              styleString: "https://demotiles.maplibre.org/style.json",
              onStyleLoadedCallback: () {
                debugPrint("Map style loaded successfully!");
                _addHeatMapLayer();
                _moveToHeatmapArea();
              },
            ),
    );
  }

  void _onMapCreated(MapLibreMapController controller) {
    mapController = controller;
  }

  void _addHeatMapLayer() async {
    try {
      if (geoJsonData == null) return;

      await mapController.addSource(
        "heat",
        GeojsonSourceProperties(data: geoJsonData!),
      );

      await mapController.addLayer(
        "heat",
        "heatmap",
        HeatmapLayerProperties(
          heatmapWeight: [
            "interpolate",
            ["linear"],
            ["get", "weight"],
            0, 0,
            1, 1,
          ],
          heatmapIntensity: [
            "interpolate",
            ["linear"],
            ["zoom"],
            0, 1,
            15, 3,
          ],
          heatmapColor: [
            "interpolate",
            ["linear"],
            ["heatmap-density"],
            0, "rgba(33,102,172,0)",
            0.2, "rgb(103,169,207)",
            0.4, "rgb(209,229,240)",
            0.6, "rgb(253,219,199)",
            0.8, "rgb(239,138,98)",
            1, "rgb(178,24,43)",
          ],
          heatmapRadius: [
            "interpolate",
            ["linear"],
            ["zoom"],
            0, 5,
            15, 40,
          ],
          heatmapOpacity: 0.7,
        ),
      );
      debugPrint("Heatmap layer added!");
    } catch (e) {
      debugPrint("Error adding heatmap layer: $e");
    }
  }

  void _moveToHeatmapArea() {
    if (geoJsonData == null) return;

    List<dynamic> features = geoJsonData!["features"];
    if (features.isEmpty) return;

    // Find the bounding box of the heatmap data
    double minLat = 90, maxLat = -90, minLng = 180, maxLng = -180;

    for (var feature in features) {
      if (feature["geometry"]["type"] == "Point") {
        List<dynamic> coordinates = feature["geometry"]["coordinates"];
        double lng = coordinates[0];
        double lat = coordinates[1];

        if (lat < minLat) minLat = lat;
        if (lat > maxLat) maxLat = lat;
        if (lng < minLng) minLng = lng;
        if (lng > maxLng) maxLng = lng;
      }
    }

    if (minLat == 90 || maxLat == -90 || minLng == 180 || maxLng == -180) {
      debugPrint("No valid heatmap points found.");
      return;
    }

    // Set camera to the bounding box of the heatmap
    LatLngBounds bounds = LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );

    mapController.moveCamera(CameraUpdate.newLatLngBounds(bounds));
    debugPrint("Moved to heatmap area!");
  }
}
