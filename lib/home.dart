import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart'; // Import for gallery access
import 'package:geolocator/geolocator.dart'; // Import Geolocator
import 'uploadstate.dart'; // Import UploadState for navigation
import 'package:geocoding/geocoding.dart'; // Import geocoding package

class HomePage extends StatefulWidget {
  const HomePage({super.key, required String title});

  @override
  State<HomePage> createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {
  CameraController? _cameraController;
  final ImagePicker _picker = ImagePicker(); // Create an ImagePicker instance
  bool _isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) return;

      _cameraController = CameraController(
        cameras.first,
        ResolutionPreset.high, // Use a high resolution for full-body shots
        enableAudio: false,
      );
      await _cameraController!.initialize();
      if (!mounted) return;
      setState(() => _isCameraInitialized = true);
    } on CameraException {
      // Handle exception
    }
  }

  Future<void> _takePicture() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized)
      return;

    final image = await _cameraController!.takePicture();

    // Get current location and address
    Position position = await _getCurrentLocation();
    print(
        'Location: ${position.latitude}, ${position.longitude}'); // Debugging location
    String address =
        await _getAddressFromCoordinates(position.latitude, position.longitude);
    print('Address: $address'); // Debugging address

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UploadState(
          
        ),
      ),
    );
  }

  Future<void> _openGallery() async {
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      // Get current location and address
      Position position = await _getCurrentLocation();
      print(
          'Location: ${position.latitude}, ${position.longitude}'); // Debugging location
      String address = await _getAddressFromCoordinates(
          position.latitude, position.longitude);
      print('Address: $address'); // Debugging address

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              UploadState(
                
              ),
        ),
      );
    }
  }

  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    // Check and request permission
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied');
    }

    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    }

    // Get the current position
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  Future<String> _getAddressFromCoordinates(
      double latitude, double longitude) async {
    try {
      // Get the list of placemarks from coordinates using geocoding
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isEmpty) {
        return 'No address found';
      }
      Placemark placemark = placemarks[0]; // Get the first placemark

      // Construct address
      return '${placemark.name}, ${placemark.locality}, ${placemark.country}';
    } catch (e) {
      print('Error fetching address: $e'); // Log any errors
      return 'Unable to get address';
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _isCameraInitialized
            ? Stack(
                children: [
                  Positioned.fill(
                    child: CameraPreview(_cameraController!),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            onPressed: _openGallery,
                            icon: const Icon(Icons.photo_library,
                                color: Color(0xFF5F7548)),
                          ),
                          GestureDetector(
                            onTap: _takePicture,
                            child: Container(
                              width: 70.0,
                              height: 70.0,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFF5F7548),
                              ),
                              child: const Icon(Icons.camera_alt,
                                  color: Colors.white, size: 30.0),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              // Add functionality if needed
                            },
                            icon: const Icon(Icons.settings,
                                color: Color(0xFF5F7548)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            : const CircularProgressIndicator(),
      ),
    );
  }
}
