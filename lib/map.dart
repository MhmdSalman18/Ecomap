import 'package:flutter/material.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

class HeatMap extends StatefulWidget {
  const HeatMap({super.key});

  @override
  State<HeatMap> createState() => _HeatMapState();
}

class _HeatMapState extends State<HeatMap> {
  late MapLibreMapController mapController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("HeatMap Example")),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: MapLibreMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: const CameraPosition(
            target: LatLng(37.7749, -122.4194), // San Francisco
            zoom: 12,
          ),
          styleString: "https://demotiles.maplibre.org/style.json",
          onStyleLoadedCallback: () {
            debugPrint("Map style loaded successfully!");
          },
        ),
      ),
    );
  }

  void _onMapCreated(MapLibreMapController controller) {
    mapController = controller;

    // Wait for the style to load before adding layers
    mapController.onStyleLoaded(() {
      debugPrint("Style loaded callback triggered!");
      _addHeatMapLayer();
    });
  }

  void _addHeatMapLayer() async {
    try {
      // Sample data points with weights
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
        // Add more data points as needed
      ];

      // Create GeoJSON source
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

      // Add heatmap layer
      await mapController.addLayer(
        "heat", // source ID
        "heatmap", // layer ID
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

extension on MapLibreMapController {
  void onStyleLoaded(Null Function() param0) {}
}
