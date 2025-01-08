import 'dart:io';
import 'package:ecomap/BottomNavigationBar.dart';
import 'package:ecomap/CustomDrawer.dart';
import 'package:ecomap/REGISTRATION/account.dart';
import 'package:ecomap/home.dart';
import 'package:flutter/material.dart';

class UploadState extends StatefulWidget {
  final String imagePath; // Add imagePath parameter
  const UploadState({super.key, required this.imagePath, required String title});

  @override
  State<UploadState> createState() => _UploadStateState();
}

class _UploadStateState extends State<UploadState> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  String? _currentImagePath;

  @override
  void initState() {
    super.initState();
    _currentImagePath = widget.imagePath;
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
      builder: (context) => const BottomNavigationBarExample(title: 'Home Page'),
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
        backgroundColor: Color(0xFF1B3B13), // AppBar background color
        iconTheme: IconThemeData(
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
              // ignore: prefer_const_constructors
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
      body: 
        Container(
          color:  Color(0xFF1B3B13),
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
                                style: TextStyle(color: Colors.black54, fontSize: 18),
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
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          ElevatedButton.icon(
                            onPressed: _uploadFromGallery,
                            icon: const Icon(Icons.photo_library),
                            label: const Text("Upload from Gallery"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
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
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
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
                    border: OutlineInputBorder(),
                  ),
                ),
          
                const SizedBox(height: 16.0),
          
                // Description Field
                TextField(
                  controller: _descriptionController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                ),
          
                const SizedBox(height: 16.0),
          
                // Date Field
                TextField(
                  controller: _dateController,
                  keyboardType: TextInputType.datetime,
                  decoration: const InputDecoration(
                    labelText: 'Date',
                    hintText: 'YYYY-MM-DD',
                    border: OutlineInputBorder(),
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
                      ),
                      child: const Text('Reset', style: TextStyle(color: Colors.white)),
                    ),
                    ElevatedButton(
                      onPressed: _sendData,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      child: const Text('Send', style: TextStyle(color: Colors.white)),
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
