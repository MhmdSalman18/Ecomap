import 'package:ecomap/REGISTRATION/account.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class MapViewSpeciesPage extends StatefulWidget {
  final String speciesId; // Added speciesId for fetching specific data
  final double latitude;
  final double longitude;
  final String speciesImage;
  final String commonName;
  final String scientificName;
  final String conservationStatus;

  const MapViewSpeciesPage({
    super.key,
    required this.speciesId, // Required parameter for API call
    required this.latitude,
    required this.longitude,
    required this.speciesImage,
    required this.commonName,
    required this.scientificName,
    required this.conservationStatus,
  });

  @override
  State<MapViewSpeciesPage> createState() => _MapViewSpeciesPageState();
}

class _MapViewSpeciesPageState extends State<MapViewSpeciesPage> {
  late MapLibreMapController mapController;
  Map<String, dynamic>? geoJsonData;

  @override
  void initState() {
    super.initState();
    _loadGeoJsonData();
  }

  Future<void> _loadGeoJsonData() async {
    try {
      final data = await fetchGeoJsonData();
      setState(() {
        geoJsonData = data;
      });

      debugPrint("GeoJSON Data: $geoJsonData"); // Log to verify data
    } catch (e) {
      debugPrint("Error loading GeoJSON data: $e");
    }
  }

  Future<Map<String, dynamic>> fetchGeoJsonData() async {
    final String apiUrl =
        'https://ecomap-zehf.onrender.com/expert/species-map/${widget.speciesId}';

    debugPrint("Fetching GeoJSON from: $apiUrl"); // Debugging Log

    final response = await http.get(Uri.parse(apiUrl));

    debugPrint("Response Status Code: ${response.statusCode}"); // Log Status

    if (response.statusCode == 200) {
      debugPrint("Response Body: ${response.body}"); // Log API Response

      final Map<String, dynamic> data = json.decode(response.body);

      if (!data.containsKey("features")) {
        debugPrint("Invalid response format: Missing 'features' key");
        throw Exception('Invalid response format: Missing "features" key');
      }

      List<dynamic> features = data["features"];
      for (var feature in features) {
        feature["properties"] ??= {}; // Ensure properties exist
        feature["properties"]["weight"] ??= 1.0; // Default weight if missing
      }

      debugPrint("GeoJSON Data Loaded Successfully!");
      return data;
    } else {
      debugPrint("Failed to load GeoJSON: ${response.body}");
      throw Exception('Failed to load GeoJSON data');
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
          ? Center(
              child: Lottie.asset(
                'assets/animations/main_scene.json',
                width: 100, // Adjust the width as needed
                height: 100, // Adjust the height as needed
              ),
            )
          : Stack(
              children: [
                MapLibreMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(widget.latitude, widget.longitude),
                    zoom: 8,
                  ),
                  styleString:
                      "https://api.maptiler.com/maps/basic/style.json?key=wUaEpt2AO8gpj04Sev8J",
                  onStyleLoadedCallback: () {
                    debugPrint("Map style loaded successfully!");
                    _addHeatMapLayer();
                  },
                ),
                Positioned(
                  bottom: 20,
                  left: 10,
                  right: 10,
                  child: Card(
                    elevation: 8, // Increased shadow for more depth
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(15), // More rounded corners
                    ),
                    color: Color(0xFF082517), // Background color for the card
                    child: Padding(
                      padding: const EdgeInsets.all(15), // Increased padding
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(
                                12), // More rounded corners for the image
                            child: Image.network(
                              widget.speciesImage,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(Icons.broken_image,
                                    size: 60, color: Colors.red);
                              },
                            ),
                          ),
                          const SizedBox(
                              width: 15), // Space between image and text
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.commonName,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors
                                        .white, // Text color for better contrast
                                  ),
                                ),
                                Text(
                                  widget.scientificName,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontStyle: FontStyle.italic,
                                    color: Colors
                                        .white70, // Slightly lighter color
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  "Conservation: ${widget.conservationStatus}",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors
                                        .white54, // Light color for conservation status
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Optionally, you can add an action button or icon here
                          // IconButton(
                          //   icon: Icon(Icons.info, color: Colors.white),
                          //   onPressed: () {
                          //     // Action on button press
                          //   },
                          // ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
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
            0,
            0,
            1,
            1,
          ],
          heatmapIntensity: [
            "interpolate",
            ["linear"],
            ["zoom"],
            0,
            1,
            15,
            3,
          ],
          heatmapColor: [
            "interpolate",
            ["linear"],
            ["heatmap-density"],
            0,
            "rgba(33,102,172,0)",
            0.2,
            "rgb(103,169,207)",
            0.4,
            "rgb(209,229,240)",
            0.6,
            "rgb(253,219,199)",
            0.8,
            "rgb(239,138,98)",
            1,
            "rgb(178,24,43)",
          ],
          heatmapRadius: [
            "interpolate",
            ["linear"],
            ["zoom"],
            0,
            5,
            15,
            40,
          ],
          heatmapOpacity: 0.7,
        ),
      );
      debugPrint("Heatmap layer added!");
    } catch (e) {
      debugPrint("Error adding heatmap layer: $e");
    }
  }
}
