import 'package:ecomap/CustomDrawer.dart';
import 'package:ecomap/REGISTRATION/account.dart';
import 'package:ecomap/heatmap.dart';
import 'package:ecomap/myspottings.dart';
import 'package:ecomap/viewspecies.dart';
import 'package:flutter/material.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key, required String title});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late MapLibreMapController mapController;

  @override
  void initState() {
    super.initState();
    // You can initialize any state variables here if needed
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
              child:   Padding(
              padding: const EdgeInsets.only(right: 12.0), // Add padding to the left and right
              child: Image.asset(
                'assets/assets/ecomap_banner.png',
                width: 100, // Adjust the width as needed
                height: 50, // Adjust the height as needed
              ),
              ),
            ),
          ),
        ],
      ),
      drawer: CustomDrawer(),
      body: Stack(
        children: [
          // Map widget
          MapLibreMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: LatLng(10.0, 76.0), // Default location (adjust if needed)
              zoom: 5,
            ),
            styleString: "https://api.maptiler.com/maps/basic/style.json?key=wUaEpt2AO8gpj04Sev8J",
          ),
          // Left-aligned vertical navigation bar
          Positioned(
            top: 10, // Start lower to avoid overlap with AppBar
            left: 16,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: Column(
                mainAxisSize: MainAxisSize.min, // Adjust height based on content
                crossAxisAlignment: CrossAxisAlignment.start, // Align buttons to the left
                children: [
                  // Animate each button separately
                  TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: 0.0, end: 1.0),
                    duration: Duration(seconds: 1),
                    builder: (context, opacity, child) {
                      return Opacity(
                        opacity: opacity,
                        child: _buildNavButton("My Spottings", MySpottingsPage(), Icons.camera),
                      );
                    },
                  ),
                  SizedBox(height: 10), // Add space between buttons
                  TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: 0.0, end: 1.0),
                    duration: Duration(seconds: 1),
                    builder: (context, opacity, child) {
                      return Opacity(
                        opacity: opacity,
                        child: _buildNavButton("Explore Species", ViewSpeciesPage(title: ''), Icons.search),
                      );
                    },
                  ),
                  SizedBox(height: 10), // Add space between buttons
                  TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: 0.0, end: 1.0),
                    duration: Duration(seconds: 1),
                    builder: (context, opacity, child) {
                      return Opacity(
                        opacity: opacity,
                        child: _buildNavButton("Heatmap of Sightings", HeatMap(), Icons.heat_pump),
                      );
                    },
                  ),
                  // SizedBox(height: 10), // Add space between buttons
                  // _buildNavButton("Open Map", null, Icons.map, _loadMap),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _loadMap,
        backgroundColor: Color(0xFFB4E576),
        child: Icon(Icons.my_location, color: Colors.black),
      ),
    );
  }

  Widget _buildNavButton(String text, Widget? page, IconData icon, [VoidCallback? onPressed]) {
    return ElevatedButton.icon(
      onPressed: onPressed ?? () {
        if (page != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => page),
          );
        }
      },
      icon: Icon(icon, color: Colors.white),
      label: Text(text, style: TextStyle(color: Colors.white)),
      style: ElevatedButton.styleFrom(
        foregroundColor: Color(0xFF1B3A6D),
        backgroundColor: Color(0xFF082517), // Button background color
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      ),
    );
  }

  void _onMapCreated(MapLibreMapController controller) {
    mapController = controller;
  }

  void _loadMap() {
    debugPrint("Loading map...");
    mapController.moveCamera(CameraUpdate.newLatLngZoom(LatLng(10.0, 76.0), 5));
  }
}
