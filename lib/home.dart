import 'package:ecomap/CustomDrawer.dart';
import 'package:ecomap/REGISTRATION/account.dart';
import 'package:ecomap/draft.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:lottie/lottie.dart';
import 'uploadstate.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required String title});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CameraController? _cameraController;
  bool _isCameraInitialized = false;
  bool _cameraError = false;
  bool _isFlashOn = false; // Track flash state

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
        ResolutionPreset.high,
        enableAudio: false,
      );
      await _cameraController!.initialize();
      if (!mounted) return;

      // Ensure flash is OFF by default
      await _cameraController!.setFlashMode(FlashMode.off);

      setState(() => _isCameraInitialized = true);
    } on CameraException {
      setState(() => _cameraError = true);
    }
  }

  Future<void> _toggleFlash() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) return;

    try {
      if (_isFlashOn) {
        await _cameraController!.setFlashMode(FlashMode.off);
      } else {
        await _cameraController!.setFlashMode(FlashMode.torch); // Force flash ON
      }
      setState(() {
        _isFlashOn = !_isFlashOn;
      });
    } catch (e) {
      print("Error toggling flash: $e");
    }
  }

  Future<void> _takePicture() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) return;

    try {
      // Ensure flash mode is correctly applied before capturing
      await _cameraController!.setFlashMode(_isFlashOn ? FlashMode.torch : FlashMode.off);

      final image = await _cameraController!.takePicture();

      // Ensure flash is turned OFF after taking the picture
      await _cameraController!.setFlashMode(FlashMode.off);
      setState(() => _isFlashOn = false);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UploadState(imagePath: image.path, title: 'Captured Image'),
        ),
      );
    } catch (e) {
      print("Error taking picture: $e");
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
        backgroundColor: Color(0xFF082517),
        iconTheme: IconThemeData(color: Color(0xFFB4E576)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 5.0, top: 10),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AccountPage()),
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: Image.asset(
                  'assets/assets/ecomap_banner.png',
                  width: 100,
                  height: 50,
                ),
              ),
            ),
          ),
        ],
      ),
      drawer: CustomDrawer(),
      body: Center(
        child: _cameraError
            ? Text("Error initializing camera", style: TextStyle(color: Colors.red))
            : _isCameraInitialized
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
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DraftPage(title: ''),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.photo_library, color: Color(0xFF5F7548)),
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
                                  child: const Icon(Icons.camera_alt, color: Colors.white, size: 30.0),
                                ),
                              ),
                              IconButton(
                                onPressed: _toggleFlash,
                                icon: Icon(
                                  _isFlashOn ? Icons.flash_on : Icons.flash_off,
                                  color: Color(0xFF5F7548),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                : Lottie.asset(
                    'assets/animations/main_scene.json',
                    width: 100,
                    height: 100,
                  ),
      ),
    );
  }
}
