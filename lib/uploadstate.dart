import 'dart:io';
import 'package:flutter/material.dart';
import 'CustomDrawer.dart'; // Import the reusable drawer

class UploadState extends StatefulWidget {
  final String imagePath; // Add imagePath parameter
  const UploadState({super.key, required String title, required this.imagePath});

  @override
  State<UploadState> createState() => _UploadStateState();
}

class _UploadStateState extends State<UploadState> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

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
    // Logic to retry uploading the image
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Retrying image upload..."),
      ),
    );
  }

  void _recaptureImage() {
    // Logic for recapturing the image
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Recapturing image..."),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 17, 0),
        title: const Text("Upload Details"),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: CircleAvatar(radius: 18),
          ),
        ],
      ),
      drawer: const CustomDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 16.0),

              // Image Container with Retry and Recapture Buttons
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: MediaQuery.of(context).size.height * 0.3,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                      image: widget.imagePath.isNotEmpty
                          ? DecorationImage(
                              image: FileImage(File(widget.imagePath)),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: widget.imagePath.isEmpty
                        ? const Center(
                            child: Text(
                              'No Image Available',
                              style: TextStyle(color: Colors.black54, fontSize: 18),
                            ),
                          )
                        : null,
                  ),
                  if (widget.imagePath.isEmpty)
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
                          onPressed: _recaptureImage,
                          icon: const Icon(Icons.camera_alt),
                          label: const Text("Recapture"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                          ),
                        ),
                      ],
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
