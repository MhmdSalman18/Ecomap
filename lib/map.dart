import 'package:ecomap/selectanimal.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HeatMap extends StatefulWidget {
  const HeatMap({super.key});

  @override
  State<HeatMap> createState() => _HeatMapState();
}

class _HeatMapState extends State<HeatMap> {
  late MapLibreMapController mapController;
  Location location = Location();
  LatLng? currentLocation;
  bool heatmapAdded = false; // To prevent duplicate layers

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("World HeatMap Example"),
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: _loadAllSpottings,
                  child: const Text("View All Spottings", style: TextStyle(color: Colors.black)),
                ),
                TextButton(
                  onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SelectAnimal(title: '',)),
                  );
                  },
                  child: const Text("Select Animal", style: TextStyle(color: Colors.black)),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text("Select Animal", style: TextStyle(color: Colors.black)),
                ),
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
                        zoom: 10,
                      ),
                      styleString: "https://demotiles.maplibre.org/style.json",
                      myLocationEnabled: true,
                      myLocationRenderMode: MyLocationRenderMode.normal,
                      onStyleLoadedCallback: () {
                        debugPrint("Map style loaded successfully!");
                        _addHeatMapLayer();
                      },
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

  void _getCurrentLocation() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        debugPrint("Location services are disabled.");
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        debugPrint("Location permission denied.");
        return;
      }
    }

    try {
      final LocationData locationData = await location.getLocation();
      if (locationData.latitude != null && locationData.longitude != null) {
        setState(() {
          currentLocation = LatLng(locationData.latitude!, locationData.longitude!);
        });
      } else {
        debugPrint("Invalid location data received.");
      }
    } catch (e) {
      debugPrint("Error getting current location: $e");
    }
  }

  void _loadAllSpottings() async {
    debugPrint("Fetching all spottings...");
    final geoJsonData = await fetchHeatMapData();
    if (geoJsonData != null) {
      setState(() {
        _addHeatMapLayer();
      });
    }
  }

  void _addHeatMapLayer() async {
    if (mapController == null || heatmapAdded) return; // Prevent duplicate layers

    try {
      final response = await fetchHeatMapData();

      if (response == null || !response.containsKey('type')) {
        debugPrint("Invalid GeoJSON data received.");
        return;
      }

      await mapController.addGeoJsonSource("heat", response);

      debugPrint("GeoJSON source added!");

      await mapController.addHeatmapLayer(
        "heat",
        "heatmap-layer",
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

      heatmapAdded = true; // Mark heatmap as added
      debugPrint("Heatmap layer added!");
    } catch (e) {
      debugPrint("Error adding heatmap layer: $e");
    }
  }

  Future<Map<String, dynamic>?> fetchHeatMapData() async {
    try {
      final response = await http.get(Uri.parse("http://192.168.1.6:3000/user/map"));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data is Map<String, dynamic> && data.containsKey('type')) {
          return data;
        } else {
          debugPrint("Received data is not a valid GeoJSON.");
          return null;
        }
      }
      debugPrint("Failed to fetch heatmap data. Status code: ${response.statusCode}");
      return null;
    } catch (e) {
      debugPrint("Error fetching heatmap data: $e");
      return null;
    }
  }
}
