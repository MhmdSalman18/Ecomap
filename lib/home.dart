import 'dart:io';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required String title});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CameraController? _controller;
  XFile? _image;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    // Get a list of available cameras
    final cameras = await availableCameras();

    // Get a specific camera from the list (e.g., the first one)
    final firstCamera = cameras.first;

    // Initialize the camera controller
    _controller = CameraController(
      firstCamera,
      ResolutionPreset.medium,
    );

    // Listen for camera state changes
    _controller!.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });

    // Initialize the camera
    try {
      await _controller!.initialize();
    } on CameraException catch (e) {
      debugPrint('Error initializing camera: $e');
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _takePicture() async {
    try {
      // Ensure that the camera is initialized
      await _controller!.prepareForVideoRecording();

      // Take the picture
      final image = await _controller!.takePicture();

      setState(() {
        _image = image;
      });
    } on CameraException catch (e) {
      debugPrint('Error taking picture: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Camera App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (_controller != null && _controller!.value.isInitialized)
              CameraPreview(_controller!),
            const SizedBox(height: 20),
            if (_image != null)
              Image.file(
                File(_image!.path),
                width: 300,
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _controller != null && _controller!.value.isInitialized
                  ? _takePicture
                  : null,
              child: const Icon(Icons.camera_alt),
            ),
          ],
        ),
      ),
    );
  }
}