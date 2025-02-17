import 'package:flutter/material.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

class MySpottingsMapPage extends StatefulWidget {
  final double latitude;
  final double longitude;
  final String title;
  final String imageUrl; // Add image URL parameter

  const MySpottingsMapPage({
    super.key,
    required this.latitude,
    required this.longitude,
    required this.title,
    required this.imageUrl, // Initialize image URL
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
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(widget.title.isNotEmpty ? widget.title : 'Spotting Location'),
      ),
      body: Stack(
        children: [
          MapLibreMap(
            onMapCreated: _onMapCreated,
            onStyleLoadedCallback: _onStyleLoaded,
            initialCameraPosition: CameraPosition(
              target: LatLng(widget.latitude, widget.longitude),
              zoom: 14,
            ),
            styleString: 'https://demotiles.maplibre.org/style.json',
            myLocationEnabled: true,
            myLocationRenderMode: MyLocationRenderMode.normal,
          ),
          if (!isMapReady)
            const Center(child: CircularProgressIndicator()),

          // Positioned widget to display the image and text
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(color: Colors.black26, blurRadius: 5),
                ],
              ),
              child: Row(
                children: [
                  // Image on the left
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      widget.imageUrl,
                      width: 100,  // Set a fixed width for the image
                      height: 100, // Set a fixed height for the image
                      fit: BoxFit.fill, // To display it without scaling
                      errorBuilder: (context, error, stackTrace) => Icon(Icons.image_not_supported, size: 50),
                    ),
                  ),
                  SizedBox(width: 10), // Add space between image and text

                  // Column for title and description on the right
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Description of the sighting goes here.',
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
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
      CameraUpdate.newLatLngZoom(LatLng(widget.latitude, widget.longitude), 14),
    );
    setState(() {});
  }
}
