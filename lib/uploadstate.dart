import 'dart:io';
import 'package:ecomap/BottomNavigationBar.dart';
import 'package:ecomap/CustomDrawer.dart';
import 'package:ecomap/REGISTRATION/account.dart';
import 'package:ecomap/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';

class UploadState extends StatefulWidget {
  final String imagePath; // Add imagePath parameter
  const UploadState(
      {super.key, required this.imagePath, required String title});

  @override
  State<UploadState> createState() => _UploadStateState();
}

class _UploadStateState extends State<UploadState> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  String? _currentImagePath;
  String _locationMessage = "Fetching location...";
  
  @override
  void initState() {
    super.initState();
    _currentImagePath = widget.imagePath;
    _getLocation(); // Fetch location on initialization
  }

  Future<void> _getLocation() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Check if location services are enabled
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    setState(() {
      _locationMessage = "Please enable location services.";
    });
    return;
  }

  // Check for location permissions
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      setState(() {
        _locationMessage = "Location permissions are denied.";
      });
      return;
    }
  }

  if (permission == LocationPermission.deniedForever) {
    setState(() {
      _locationMessage = "Location permissions are permanently denied.";
    });
    return;
  }

  // Fetch the current position
  try {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high, // Use high accuracy for precision
    );
    setState(() {
      _locationMessage =
          "Latitude: ${position.latitude}, Longitude: ${position.longitude}";
    });
  } catch (e) {
    setState(() {
      _locationMessage = "Error fetching location: $e";
    });
  }
}


  void _resetFields() {
    setState(() {
      _titleController.clear();
      _descriptionController.clear();
      _dateController.clear();
    });
  }

  void _sendData() {
    final title = _titleController.text;
    final description = _descriptionController.text;
    final date = _dateController.text;

    if (title.isNotEmpty && description.isNotEmpty && date.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Data Sent: $title, $description, $date"),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill in all fields"),
        ),
      );
    }
  }

  void _retryUpload() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) =>
            const BottomNavigationBarExample(title: 'Home Page'),
      ),
    );
  }

  void _removeImage() {
    setState(() {
      _currentImagePath = null;
    });
  }

  void _uploadFromGallery() {
    // Logic to pick an image from the gallery
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Upload from gallery functionality coming soon!"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B3B13), // AppBar background color
        iconTheme: const IconThemeData(
          color: Color(0xFFB4E576),
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
              child: const CircleAvatar(
                backgroundImage: NetworkImage(
                    'https://via.placeholder.com/150'), // Replace with your image URL
                radius: 18, // Adjust the size
              ),
            ),
          ),
        ],
      ),
      drawer: CustomDrawer(),
      body: Container(
        color: const Color(0xFF1B3B13),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 16.0),

              // Image Container with Retry, Recapture, and Remove Buttons
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 1,
                    height: MediaQuery.of(context).size.height * 0.3,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                      image: _currentImagePath != null
                          ? DecorationImage(
                              image: FileImage(File(_currentImagePath!)),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: _currentImagePath == null
                        ? const Center(
                            child: Text(
                              'No Image Available',
                              style: TextStyle(
                                  color: Colors.black54, fontSize: 18),
                            ),
                          )
                        : null,
                  ),
                  if (_currentImagePath == null)
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          onPressed: _retryUpload,
                          icon: const Icon(Icons.refresh),
                          label: const Text("Retry"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        ElevatedButton.icon(
                          onPressed: _uploadFromGallery,
                          icon: const Icon(Icons.photo_library),
                          label: const Text("Upload from Gallery"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  if (_currentImagePath != null)
                    Positioned(
                      bottom: 8.0,
                      right: 8.0,
                      child: ElevatedButton.icon(
                        onPressed: _removeImage,
                        icon: const Icon(Icons.delete),
                        label: const Text("Remove"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 16.0),

              // Title Field
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  labelStyle: TextStyle(color: Color(0xFFD1F5A0)),
                  border: OutlineInputBorder(),
                ),
                style: const TextStyle(color: Color(0xFFD1F5A0)),
              ),

              const SizedBox(height: 16.0),

              // Description Field
              TextField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  labelStyle: TextStyle(color: Color(0xFFD1F5A0)),
                  border: OutlineInputBorder(),
                ),
                style: const TextStyle(color: Color(0xFFD1F5A0)),
              ),

              const SizedBox(height: 16.0),

              // Date Field
              TextField(
                controller: _dateController,
                keyboardType: TextInputType.datetime,
                decoration: const InputDecoration(
                  labelText: 'Date',
                  hintText: 'YYYY-MM-DD',
                  labelStyle: TextStyle(color: Color(0xFFD1F5A0)),
                  hintStyle: TextStyle(color: Color(0xFFD1F5A0)),
                  border: OutlineInputBorder(),
                  suffixIcon:
                      Icon(Icons.calendar_today, color: Color(0xFFD1F5A0)),
                ),
                style: const TextStyle(color: Color(0xFFD1F5A0)),
                onTap: () async {
                  FocusScope.of(context).requestFocus(FocusNode());
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      _dateController.text =
                          pickedDate.toString().split(' ')[0];
                    });
                  }
                },
              ),

              const SizedBox(height: 24.0),

              GestureDetector(
                onLongPress: () {
                  Clipboard.setData(ClipboardData(text: _locationMessage));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Location copied to clipboard"),
                    ),
                  );
                },
                child: Text(
                  "Location is: $_locationMessage",
                  style: const TextStyle(color: Color(0xFFD1F5A0)),
                ),
              ),

              const SizedBox(height: 24.0),

              // Buttons for Reset and Send
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _resetFields,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Reset',
                        style: TextStyle(color: Colors.white)),
                  ),
                  ElevatedButton(
                    onPressed: _sendData,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Send',
                        style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),

              const SizedBox(height: 16.0),
            ],
          ),
        ),
      ),
    );
  }
}
