import 'package:ecomap/CustomDrawer.dart';
import 'package:ecomap/REGISTRATION/account.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart'; // Import for gallery access
import 'uploadstate.dart'; // Import UploadState for navigation

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
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UploadState(
          title: 'Upload State',
          imagePath: image.path,
        ),
      ),
    );
  }

  Future<void> _openGallery() async {
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UploadState(
            title: 'Upload State',
            imagePath: pickedImage.path,
          ),
        ),
      );
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
      appBar: AppBar(
        backgroundColor:
           Color(0xFF1B3B13), // AppBar background color
        iconTheme: IconThemeData(
          color: Color(0xFFB4E576), // Change the hamburger icon color
        ),
        actions: [
          Padding(
            padding:
                const EdgeInsets.only(right: 8.0), // Add padding to the right
            child: GestureDetector(
              onTap: () {
                // Navigate to HomePage
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AccountPage(title: 'Home'),
                  ),
                );
              },
              child: CircleAvatar(
                backgroundImage: NetworkImage(
                    'https://via.placeholder.com/150'), // Replace with your image URL
                radius: 18, // Adjust the size
              ),
            ),
          ),
        ],
      ),
      drawer: CustomDrawer(),
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
                      padding: const EdgeInsets.only(
                          bottom: 20.0), // Add some space from the bottom
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment
                            .spaceEvenly, // Spread the buttons evenly
                        children: [
                          // Gallery button on the left
                          IconButton(
                            onPressed: _openGallery,
                            icon: const Icon(Icons.photo_library,
                                color: Color(0xFF5F7548)),
                          ),
                          // Camera button in the center
                          GestureDetector(
                            onTap: _takePicture,
                            child: Container(
                              width: 70.0,
                              height: 70.0,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFF5F7548),
                              ),
                              child: const Icon(Icons.camera_alt,
                                  color: Color.fromARGB(255, 255, 255, 255), size: 30.0),
                            ),
                          ),
                          // Placeholder for an optional button on the right
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
                  )
                ],
              )
            : const CircularProgressIndicator(),
      ),
    );
  }
}
