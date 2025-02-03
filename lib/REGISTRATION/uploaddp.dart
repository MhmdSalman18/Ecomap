import 'package:ecomap/BottomNavigationBar.dart';
import 'package:ecomap/REGISTRATION/login.dart';
import 'package:ecomap/home.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class UploadDpPage extends StatefulWidget {
  const UploadDpPage({super.key, required String title});

  @override
  State<UploadDpPage> createState() => _UploadDpPageState();
}

class _UploadDpPageState extends State<UploadDpPage> {
  File? _image; // To store the selected image

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF082517), // Background color
      appBar: AppBar(
        backgroundColor: const Color(0xFF082517),
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Color(0xFFD1F5A0), // Back icon color
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile Photo Section
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 60,
                backgroundColor: Colors.grey.shade300,
                backgroundImage: _image != null ? FileImage(_image!) : null,
                child: _image == null
                    ? const Icon(
                        Icons.camera_alt,
                        color: Colors.grey,
                        size: 40,
                      )
                    : null,
              ),
            ),
            const SizedBox(height: 20),

            // Instructional Text
            const Text(
              "Tap to upload a profile photo",
              style: TextStyle(
                color: Color(0xFFD1F5A0), // Text color
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 40),

            // Register Button
            ElevatedButton(
              onPressed: () {
                if (_image == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Please upload a profile photo."),
                    ),
                  );
                } else {
                  // Navigate to HomePage
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage(title: "")),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: const Color(0xFFD1F5A0), // Button color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // Rounded corners
                ),
              ),
                child: const Text(
                "Register",
                style: TextStyle(
                  fontSize: 18,
                  color: Color(0xFF082517), // Button text color
                ),
                ),
            ),
          ],
        ),
      ),
    );
  }
}

// HomePage widget definition
