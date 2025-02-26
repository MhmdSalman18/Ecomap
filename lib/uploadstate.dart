import 'dart:io';
import 'package:ecomap/BottomNavigationBar.dart';
import 'package:ecomap/CustomDrawer.dart';
import 'package:ecomap/REGISTRATION/account.dart';
import 'package:ecomap/home.dart';
import 'package:ecomap/map.dart';
import 'package:ecomap/services/api_service.dart';
import 'package:ecomap/services/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lottie/lottie.dart';

class UploadState extends StatefulWidget {
  final String imagePath;
  final int? draftId;

  const UploadState(
      {Key? key, required this.imagePath, required String title, this.draftId})
      : super(key: key);

  @override
  State<UploadState> createState() => _UploadStateState();
}

class _UploadStateState extends State<UploadState> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  final ApiService apiService = ApiService();
  final DatabaseHelper dbHelper = DatabaseHelper();

  String? _currentImagePath;
  String _locationMessage = "Fetching location...";
  int? _draftId;

  @override
  void initState() {
    super.initState();
    _currentImagePath = widget.imagePath;
    _getLocation();
    if (widget.draftId != null) {
      _loadDraft(widget.draftId!);
    }
  }

  Future<void> _getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _locationMessage = "Please enable location services.";
      });
      return;
    }

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

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
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

  Future<void> _loadDraft(int draftId) async {
    final draft = await dbHelper.getDraft(draftId);
    if (draft != null) {
      setState(() {
        _draftId = draft['id'] as int;
        _titleController.text = draft['title'] ?? '';
        _descriptionController.text = draft['description'] ?? '';
        _dateController.text = draft['date'] ?? '';
        _currentImagePath = draft['imagePath'] ?? _currentImagePath;
        _locationMessage = draft['location'] ?? _locationMessage;
      });
    }
  }

  Future<void> _saveDraft() async {
    final draftData = {
      'title': _titleController.text,
      'description': _descriptionController.text,
      'date': _dateController.text,
      'imagePath': _currentImagePath ?? '',
      'location': _locationMessage,
    };

    if (_draftId == null) {
      int id = await dbHelper.insertDraft(draftData);
      setState(() {
        _draftId = id;
      });
    } else {
      await dbHelper.updateDraft(_draftId!, draftData);
    }
  }

  void _resetFields() async {
    setState(() {
      _titleController.clear();
      _descriptionController.clear();
      _dateController.clear();
      _currentImagePath = null;
      _locationMessage = "Fetching location...";
    });

    if (_draftId != null) {
      await dbHelper.deleteDraft(_draftId!);
      setState(() {
        _draftId = null;
      });
    }
  }

  void _sendData() async {
    final title = _titleController.text;
    final description = _descriptionController.text;
    final date = _dateController.text;

    if (title.isEmpty || description.isEmpty || date.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all fields")),
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
          child: Lottie.asset(
        'assets/animations/main_scene.json',
        width: 100,
        height: 100,
      )),
    );

    final result = await apiService.uploadData(
      title: title,
      description: description,
      date: date,
      imagePath: _currentImagePath ?? '',
      location: _locationMessage,
    );

    Navigator.of(context).pop();

    if (result['success']) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BottomNavigationBarExample(title: "Home Page"),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'])),
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
    _saveDraft();
  }

  void _uploadFromGallery() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Upload from gallery functionality coming soon!"),
      ),
    );
  }

  Future<void> _delete() async {
    if (_draftId != null) {
      // Delete existing draft
      await dbHelper.deleteDraft(_draftId!);
    }
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => BottomNavigationBarExample(title: "Status")),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDraft = _draftId != null;
    final deleteButtonText = isDraft ? 'Delete Draft' : 'Delete Entry';

    return PopScope(
      canPop: true,
      onPopInvoked: (bool didPop) async {
        if (didPop) {
          await _saveDraft();
        }
      },
      child: Scaffold(
        backgroundColor: Color(0xFF082517),
        appBar: AppBar(
          backgroundColor: const Color(0xFF082517),
          iconTheme: const IconThemeData(
            color: Color(0xFFB4E576),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AccountPage(),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.only(
                      right: 12.0), // Add padding to the left and right
                  child: Image.asset(
                    'assets/assets/ecomap_banner.png',
                    width: 100, // Adjust the width as needed
                    height: 50, // Adjust the height as needed
                  ),
                ),
              ),
            ),
          ],
        ),
        drawer: CustomDrawer(),
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 16.0),
                  Container(
                    width: double.infinity,
                    height: 420,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                        color: Colors.transparent,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Image Container
                        Container(
                          width: MediaQuery.of(context).size.width * 0.5,
                          height: MediaQuery.of(context).size.height * 0.55,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                            ],
                            image: _currentImagePath != null
                                ? DecorationImage(
                                    image: FileImage(File(_currentImagePath!)),
                                    fit: BoxFit.cover,
                                  )
                                : const DecorationImage(
                                    image: AssetImage(
                                        'assets/images/bg_image.png'),
                                    fit: BoxFit.cover,
                                  ),
                          ),
                          child: _currentImagePath == null
                              ? const Center(
                                  child: Text(
                                    'No Image Available',
                                    style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                )
                              : null,
                        ),

                        // Upload & Retry Buttons (When No Image)
                        if (_currentImagePath == null)
                          Positioned(
                            bottom: 20,
                            child: Column(
                              children: [
                                ElevatedButton.icon(
                                  onPressed: _retryUpload,
                                  icon: const Icon(Icons.refresh, size: 20),
                                  label: const Text("Retry"),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.orange,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 24, vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 5,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                ElevatedButton.icon(
                                  onPressed: _uploadFromGallery,
                                  icon:
                                      const Icon(Icons.photo_library, size: 20),
                                  label: const Text("Upload from Gallery"),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 5,
                                  ),
                                ),
                              ],
                            ),
                          ),

                        // Remove Button (When Image is Uploaded)
                        if (_currentImagePath != null)
                          Positioned(
                            bottom: 16,
                            right: 16,
                            child: ElevatedButton.icon(
                              onPressed: _removeImage,
                              icon: const Icon(Icons.delete, size: 22),
                              label: const Text("Remove"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 5,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Name of the animal',
                      labelStyle: TextStyle(color: Color(0xFFD1F5A0)),
                      border: OutlineInputBorder(),
                    ),
                    style: const TextStyle(color: Color(0xFFD1F5A0)),
                    // REMOVE onChanged: (text) { _saveDraft(); },
                  ),
                  const SizedBox(height: 16.0),
                  TextField(
                    controller: _descriptionController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      labelStyle: TextStyle(color: Color(0xFFD1F5A0)),
                      border: OutlineInputBorder(),
                    ),
                    style: const TextStyle(color: Color(0xFFD1F5A0)),
                    // REMOVE onChanged: (text) { _saveDraft(); },
                  ),
                  const SizedBox(height: 16.0),
                  TextField(
                    controller: _dateController
                      ..text = DateTime.now().toString().split(' ')[0],
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
                    readOnly: true,
                    // REMOVE onChanged: (text) { _saveDraft(); },
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: _resetFields,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Reset',
                            style:
                                TextStyle(color: Colors.white, fontSize: 15)),
                      ),
                      SizedBox(
                        width: 80,
                      ),
                      ElevatedButton(
                        onPressed: _sendData,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Send',
                            style:
                                TextStyle(color: Colors.white, fontSize: 15)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () async {
                      await _saveDraft();
                      Navigator.pop(context);
                    },
                    child: const Text('Save as Draft and Go Back'),
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: _delete,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      deleteButtonText,
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
