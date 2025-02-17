import 'package:ecomap/REGISTRATION/account.dart';
import 'package:ecomap/myspottings.dart';
import 'package:ecomap/viewspecies.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:lottie/lottie.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

class HeatMap extends StatefulWidget {
  const HeatMap({super.key});

  @override
  State<HeatMap> createState() => _HeatMapState();
}

class _HeatMapState extends State<HeatMap> {
  late MapLibreMapController mapController;
  Location location = Location();
  LatLng? currentLocation;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
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
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildNavButton("View my spottings", MySpottingsPage()),
                _buildNavButton("View species", ViewSpeciesPage(title: '')),
                _buildNavButton("View Heatmap", null, _viewHeatmap),
              ],
            ),
          ),
          Expanded(
            child: currentLocation == null
                ? Center(
                    child: Lottie.asset(
                      'assets/animations/main_scene.json',
                      width: 100,
                      height: 100,
                    ),
                  )
                : SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: MapLibreMap(
                      onMapCreated: _onMapCreated,
                      initialCameraPosition: CameraPosition(
                        target: currentLocation!,
                        zoom: 12,
                      ),
                      styleString: "https://demotiles.maplibre.org/style.json",
                      myLocationEnabled: true,
                      myLocationRenderMode: MyLocationRenderMode.normal,
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavButton(String text, Widget? page, [VoidCallback? onPressed]) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: TextButton(
        onPressed: onPressed ?? () {
          if (page != null) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => page),
            );
          }
        },
        child: Text(text, style: TextStyle(color: Color(0xFFB4E576))),
        style: TextButton.styleFrom(
          side: BorderSide(color: Color(0xFFB4E576)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
    );
  }

  void _onMapCreated(MapLibreMapController controller) {
    mapController = controller;
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) return;
    }

    PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) return;
    }

    try {
      final LocationData locationData = await location.getLocation();
      if (locationData.latitude != null && locationData.longitude != null) {
        setState(() {
          currentLocation = LatLng(locationData.latitude!, locationData.longitude!);
        });

        // Move camera to new location if map is initialized
        if (mapController != null) {
          mapController.moveCamera(CameraUpdate.newLatLngZoom(currentLocation!, 12));
        }
      }
    } catch (e) {
      debugPrint("Error getting current location: $e");
    }
  }

  Future<Map<String, dynamic>?> fetchHeatMapData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null) {
        throw Exception('User not authenticated');
      }

      final response = await http.get(
        Uri.parse('https://ecomap-zehf.onrender.com/user/map'),
        headers: {
          'Content-Type': 'application/json',
          'x-authtoken': token,
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data is Map<String, dynamic> && data.containsKey('type')) {
          return data;
        } else {
          throw Exception('Invalid GeoJSON data');
        }
      }

      throw Exception('Failed to fetch heatmap data');
    } catch (e) {
      print('Error fetching heatmap data: $e');
      rethrow;
    }
  }

  void _viewHeatmap() async {
    try {
      final heatmapData = await fetchHeatMapData();
      if (heatmapData != null) {
        _addHeatmapLayer(heatmapData);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error fetching heatmap data: $e")));
    }
  }

  void _addHeatmapLayer(Map<String, dynamic> heatmapData) {
    try {
      // Add GeoJSON source for the heatmap data
      mapController.addSource(
        'heatmap-source',
        GeojsonSourceProperties(data: json.encode(heatmapData)),
      );

      // Add Heatmap Layer
      mapController.addHeatmapLayer(
        'heatmap-layer',
        'heatmap-source',
        HeatmapLayerProperties(
          heatmapColor: [
            [0, 'rgba(33,102,172,0)'],
            [0.2, 'rgb(103,169,207)'],
            [0.4, 'rgb(209,229,240)'],
            [0.6, 'rgb(253,219,199)'],
            [0.8, 'rgb(239,138,98)'],
            [1, 'rgb(178,24,43)']
          ],
          heatmapRadius: 15,
        ),
      );
    } catch (e) {
      print("Error adding heatmap layer: $e");
    }
  }
}
