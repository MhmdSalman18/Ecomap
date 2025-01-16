import 'package:flutter/material.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:location/location.dart';

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
      appBar: AppBar(title: const Text("HeatMap Example")),
      body: currentLocation == null
          ? const Center(child: CircularProgressIndicator())
          : SizedBox(
              height: MediaQuery.of(context).size.height,
              child: MapLibreMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: currentLocation!,
                  zoom: 12,
                ),
                styleString: "https://demotiles.maplibre.org/style.json",
                myLocationEnabled: true, // Enable current location display
                myLocationRenderMode: MyLocationRenderMode.gps, // Fixed constant
                onStyleLoadedCallback: () {
                  debugPrint("Map style loaded successfully!");
                  _addHeatMapLayer();
                },
              ),
            ),
    );
  }

  void _onMapCreated(MapLibreMapController controller) {
    mapController = controller;
  }

  void _getCurrentLocation() async {
    try {
      final LocationData locationData = await location.getLocation();
      setState(() {
        currentLocation =
            LatLng(locationData.latitude ?? 0.0, locationData.longitude ?? 0.0);
      });
    } catch (e) {
      debugPrint("Error getting current location: $e");
    }
  }

  void _addHeatMapLayer() async {
    try {
      final List<Map<String, dynamic>> features = [
        {
          "type": "Feature",
          "properties": {"weight": 1.0},
          "geometry": {
            "type": "Point",
            "coordinates": [-122.4194, 37.7749]
          }
        },
        {
          "type": "Feature",
          "properties": {"weight": 0.8},
          "geometry": {
            "type": "Point",
            "coordinates": [-122.4195, 37.7750]
          }
        },
        {
          "type": "Feature",
          "properties": {"weight": 0.6},
          "geometry": {
            "type": "Point",
            "coordinates": [-122.4196, 37.7751]
          }
        },
      ];

      await mapController.addSource(
        "heat",
        GeojsonSourceProperties(
          data: {
            "type": "FeatureCollection",
            "features": features,
          },
        ),
      );
      debugPrint("GeoJSON source added!");

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
}
