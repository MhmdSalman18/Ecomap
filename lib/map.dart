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
      appBar: AppBar(title: const Text("Kerala HeatMap Example")),
      body: currentLocation == null
          ? const Center(child: CircularProgressIndicator())
          : SizedBox(
              height: MediaQuery.of(context).size.height,
              child: MapLibreMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: const CameraPosition(
                  target: LatLng(10.8505, 76.2711), // Center of Kerala
                  zoom: 8, // Adjust zoom level for Kerala
                ),
                styleString: "https://demotiles.maplibre.org/style.json",
                myLocationEnabled: true,
                myLocationRenderMode: MyLocationRenderMode.gps,
                onStyleLoadedCallback: () {
                  debugPrint("Map style loaded successfully!");
                  _addHeatMapLayer();
                  _addKeralaBorders();
                },
              ),
            ),
    );
  }

  void _onMapCreated(MapLibreMapController controller) {
    mapController = controller;
    _setKeralaBounds();
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

  void _setKeralaBounds() {
    // Define the bounding box for Kerala
    LatLngBounds keralaBounds = LatLngBounds(
      southwest: LatLng(8.0, 74.5), // Southwest corner of Kerala
      northeast: LatLng(12.8, 77.5), // Northeast corner of Kerala
    );

    // Restrict the camera to these bounds
    mapController.setCameraBounds(
      west: keralaBounds.southwest.longitude,
      north: keralaBounds.northeast.latitude,
      south: keralaBounds.southwest.latitude,
      east: keralaBounds.northeast.longitude,
      padding: 0,
    );
  }

  void _addHeatMapLayer() async {
    try {
      final List<Map<String, dynamic>> features = [
        {
          "type": "Feature",
          "properties": {"weight": 1.0},
          "geometry": {
            "type": "Point",
            "coordinates": [76.2711, 10.8505] // Example point in Kerala
          }
        },
        {
          "type": "Feature",
          "properties": {"weight": 0.8},
          "geometry": {
            "type": "Point",
            "coordinates": [76.5, 10.9] // Another example point in Kerala
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
            15, 3//dadadas
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

  void _addKeralaBorders() async {
    try {
      final Map<String, dynamic> keralaBordersGeoJson = {
        "type": "FeatureCollection",
        "features": [
          {
            "type": "Feature",
            "geometry": {
              "type": "Polygon",
              "coordinates": [
                [
                  [74.5, 8.0],
                  [77.5, 8.0],
                  [77.5, 12.8],
                  [74.5, 12.8],
                  [74.5, 8.0],
                ]
              ],
            },
            "properties": {},
          },
        ],
      };

      await mapController.addSource(
        "keralaBorders",
        GeojsonSourceProperties(data: keralaBordersGeoJson),
      );
      debugPrint("Kerala borders GeoJSON source added!");

      await mapController.addLayer(
        "keralaBorders",
        "line",
        LineLayerProperties(
          lineColor: "rgba(0, 0, 0, 1)",
          lineWidth: 2,
        ),
      );
      debugPrint("Kerala borders layer added!");
    } catch (e) {
      debugPrint("Error adding Kerala borders layer: $e");
    }
  }
}
