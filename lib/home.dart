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
    if (_cameraController == null || !_cameraController!.value.isInitialized) return;
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
    final XFile? pickedImage = await _picker.pickImage(source: ImageSource.gallery);
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
        title: const Text('Camera App'),
        backgroundColor: Colors.red,
      ),
      body: Center(
        child: _isCameraInitialized
            ? Stack(
                children: [
                  Positioned.fill(
                    child: CameraPreview(_cameraController!),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: ElevatedButton.icon(
                            onPressed: _openGallery,
                            icon: const Icon(Icons.photo_library),
                            label: const Text(''),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: ElevatedButton.icon(
                            onPressed: _takePicture,
                            icon: const Icon(Icons.camera_alt),
                            label: const Text(''),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            : const CircularProgressIndicator(),
      ),
    );
  }
}