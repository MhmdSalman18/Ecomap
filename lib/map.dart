import 'package:ecomap/CustomDrawer.dart';
import 'package:ecomap/REGISTRATION/account.dart';
import 'package:ecomap/heatmap.dart';
import 'package:ecomap/myspottings.dart';
import 'package:ecomap/viewspecies.dart';
import 'package:ecomap/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:location/location.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _HeatMapState();
}

class _HeatMapState extends State<MapPage> {
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
                _buildNavButton("View map", null, _loadMap),
                _buildNavButton(
                    "View Heat Map", HeatMap()), // Navigate to MapPage widget
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
        onPressed: onPressed ??
            () {
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
          currentLocation =
              LatLng(locationData.latitude!, locationData.longitude!);
        });

        // Move camera to new location if map is initialized
        if (mapController != null) {
          mapController
              .moveCamera(CameraUpdate.newLatLngZoom(currentLocation!, 12));
        }
      }
    } catch (e) {
      debugPrint("Error getting current location: $e");
    }
  }

  void _loadMap() async {
    debugPrint("Loading map...");

    if (currentLocation == null) {
      debugPrint("Current location is not available yet.");
      await _getCurrentLocation();
      if (currentLocation == null) {
        debugPrint("Failed to get current location.");
        return;
      }
    }

    // Move the map to the current location
    mapController.moveCamera(CameraUpdate.newLatLngZoom(currentLocation!, 12));
  }

  // New function to handle the MapPage button press
  void _viewHeatmap() {
    debugPrint("Loading MapPage...");

    // You can implement MapPage display logic here
    // For now, you can just log a message or add functionality to load a MapPage layer
    // Example:
    // mapController.addSource('MapPage-source', ...);
    // mapController.addLayer('MapPage-layer', ...);
  }
}
