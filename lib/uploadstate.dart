import 'package:ecomap/BottomNavigationBar.dart';
import 'package:flutter/material.dart';
import 'package:ecomap/main.dart'; // Import main.dart for navigation
import 'CustomDrawer.dart'; // Import the reusable drawer

class UploadState extends StatefulWidget {
  const UploadState({super.key, required String title});

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
    // Example function to handle sending data
    final title = _titleController.text;
    final description = _descriptionController.text;
    final date = _dateController.text;

    if (title.isNotEmpty && description.isNotEmpty && date.isNotEmpty) {
      // Handle data submission
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 8.0), // Add padding to the right
            child: CircleAvatar(
              radius: 18, // Adjust the size
            ),
          ),
        ],
      ),
      drawer: const CustomDrawer(), // Use the reusable drawer
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Image Container
            
                // Image Field
                Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: GestureDetector(
                  onTap: () {
                  // Handle image upload
                  },
                  child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.height * 0.3,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                    image: AssetImage('demo.jpg'), // Replace with your image path
                    fit: BoxFit.cover,
                    ),
                  ),
                  child: const Center(
                    child: Text(
                    'Tap to upload image',
                    style: TextStyle(color: Colors.black54, fontSize: 18),
                    ),
                  ),
                  ),
                ),
                ),
              // Title Field
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),

              // Description Field
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: TextField(
                  controller: _descriptionController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),

              // Date Field
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: TextField(
                  controller: _dateController,
                  keyboardType: TextInputType.datetime,
                  decoration: const InputDecoration(
                    labelText: 'Date',
                    hintText: 'YYYY-MM-DD',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),

              // Buttons for Reset and Send
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: _resetFields,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                      ),
                      child: const Text(
                        'Reset',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _sendData,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      child: const Text(
                        'Send',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
