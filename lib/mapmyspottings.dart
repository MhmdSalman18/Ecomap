import 'package:ecomap/REGISTRATION/account.dart';
import 'package:ecomap/heatmap.dart';
import 'package:ecomap/map.dart';
import 'package:ecomap/myspottings.dart';
import 'package:ecomap/viewspecies.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

class MySpottingsMapPage extends StatefulWidget {
  final double latitude;
  final double longitude;
  final String title;
  final String imageUrl; // Add image URL parameter
  final String description; // Add description parameter
  final String date; // Add date parameter

  const MySpottingsMapPage({
    super.key,
    required this.latitude,
    required this.longitude,
    required this.title,
    required this.imageUrl, // Initialize image URL
    required this.description, // Initialize description
    required this.date, // Initialize date
  });

  @override
  State<MySpottingsMapPage> createState() => _MySpottingsMapPageState();
}

class _MySpottingsMapPageState extends State<MySpottingsMapPage> {
  MapLibreMapController? mapController;
  bool isMapReady = false;
  Symbol? marker;

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
               child: Padding(
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
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            decoration: BoxDecoration(
              color: Color(0xFF082517),
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MySpottingsPage()),
                      );
                    },
                    child: Text("My Spottings"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ViewSpeciesPage(title: '')),
                      );
                    },
                    child: Text("Explore Species"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HeatMap()),
                      );
                    },
                    child: Text("Heatmap of Sightings"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MapPage(title: '',)),
                      );
                    },
                    child: Text("Open Map"),
                  ),
                ],
              ),
            ),
          ),
          MapLibreMap(
            onMapCreated: _onMapCreated,
            onStyleLoadedCallback: _onStyleLoaded,
            initialCameraPosition: CameraPosition(
              target: LatLng(widget.latitude, widget.longitude),
              zoom: 14,
            ),
            // Updated style URL that should include labels
            styleString: 'https://api.maptiler.com/maps/basic/style.json?key=wUaEpt2AO8gpj04Sev8J',
            myLocationEnabled: true,
            myLocationRenderMode: MyLocationRenderMode.normal,
          ),
          if (!isMapReady)
            Center(
              child: Lottie.asset(
                'assets/animations/main_scene.json',
                width: 100,
                height: 100,
              ),
            ),
          // Positioned widget to display the image and text
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF082517), Color(0xFF082517)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(color: Colors.black26, blurRadius: 10),
                ],
              ),
              child: Row(
                children: [
                  // Image on the left with shadow
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      widget.imageUrl,
                      width: 100,
                      height: 100,
                      fit: BoxFit.fill,
                      errorBuilder: (context, error, stackTrace) =>
                          Icon(Icons.image_not_supported, size: 50),
                    ),
                  ),
                  SizedBox(width: 10), // Add space between image and text

                  // Column for title and description on the right
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.pets_rounded, color: Colors.white, size: 18),
                            SizedBox(width: 5),
                            Text(
                              widget.title,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.white,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Text(
                          widget.description, // Use the passed description
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                        ),
                        SizedBox(height: 5),
                        Text(
                          widget.date, // Display the date
                          style: TextStyle(color: Colors.white54, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onMapCreated(MapLibreMapController controller) {
    mapController = controller;
    controller.addListener(() {
      if (!controller.isCameraMoving && !isMapReady) {
        setState(() {
          isMapReady = true;
        });
      }
    });
  }

  void _onStyleLoaded() {
    _addDefaultMarker();
  }

  void _addDefaultMarker() async {
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      marker = await mapController?.addSymbol(
        SymbolOptions(
          geometry: LatLng(widget.latitude, widget.longitude),
          iconColor: '#FF0000',
        ),
      );
    } catch (e) {
      debugPrint('Error adding marker: $e');
    }
    mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(LatLng(widget.latitude, widget.longitude), 8),
    );
    setState(() {});
  }
}
