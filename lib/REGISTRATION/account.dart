import 'dart:io';
import 'package:ecomap/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  String _email = '';
  String _name = '';
  bool _isLoading = true;
  File? _profileImage;

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  Future<void> _fetchUserDetails() async {
    try {
      final details = await ApiService().getUserDetails();
      if (details != null) {
        setState(() {
          _email = details['email'] ?? 'N/A';
          _name = details['name'] ?? 'N/A';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _email = 'Error fetching details';
        _name = '';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Color(0xFFD1F5A0)),
        backgroundColor: const Color(0xFF082517),
        elevation: 5,
      ),
      backgroundColor: const Color(0xFF082517),
      body: _isLoading
          ?  Center(child: Lottie.asset(
                'assets/animations/main_scene.json',
                width: 100, // Adjust the width as needed
                height: 100, // Adjust the height as needed
              ),)
          : SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Profile Image
                    Center(
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 60,
                            backgroundImage: _profileImage != null
                                ? FileImage(_profileImage!)
                                : const AssetImage('assets/profile_image.png')
                                    as ImageProvider,
                            backgroundColor: Colors.grey[200],
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: () async {
                                final picker = ImagePicker();
                                final pickedFile = await picker.pickImage(
                                    source: ImageSource.gallery);
                                if (pickedFile != null) {
                                  setState(() {
                                    _profileImage = File(pickedFile.path);
                                  });
                                }
                              },
                              child: const CircleAvatar(
                                radius: 18,
                                backgroundColor: Color(0xFFB4E576),
                                child: Icon(Icons.edit,
                                    size: 20, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Full Name
                    _buildDetailRow( value: _name),
                    const SizedBox(height: 15),

                    // Email
                    _buildDetailRow( value: _email),
                    const SizedBox(height: 30),

                    // Edit Button
                    ElevatedButton.icon(
                      onPressed: () async {
                        final updatedDetails = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditAccountPage(
                              fullName: _name,
                              email: _email,
                              profileImage: _profileImage,
                            ),
                          ),
                        );

                        if (updatedDetails != null) {
                          setState(() {
                            _name = updatedDetails['fullName'];
                            _email = updatedDetails['email'];
                            _profileImage = updatedDetails['profileImage'];
                          });
                        }
                      },
                      icon: const Icon(Icons.edit),
                      label: const Text('Edit Account'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 15),
                        backgroundColor: const Color(0xFFB4E576),
                        textStyle: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildDetailRow({ required String value}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            ' $value',
            style: const TextStyle(fontSize: 20, color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}

class EditAccountPage extends StatefulWidget {
  final String fullName;
  final String email;
  final File? profileImage;

  const EditAccountPage({
    super.key,
    required this.fullName,
    required this.email,
    this.profileImage,
  });

  @override
  State<EditAccountPage> createState() => _EditAccountPageState();
}

class _EditAccountPageState extends State<EditAccountPage> {
  late TextEditingController fullNameController;
  late TextEditingController emailController;
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    fullNameController = TextEditingController(text: widget.fullName);
    emailController = TextEditingController(text: widget.email);
    _selectedImage = widget.profileImage;
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Account',
          style: TextStyle(color: Color(0xFFD1F5A0)),
        ),
        iconTheme: const IconThemeData(color: Color(0xFFD1F5A0)),
        backgroundColor: const Color(0xFF082517),
        elevation: 5,
      ),
      backgroundColor: const Color(0xFF082517),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
        child: Column(
          children: [
            // Profile Image with Edit Option
            GestureDetector(
              onTap: _pickImage,
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: _selectedImage != null
                        ? FileImage(_selectedImage!)
                        : const AssetImage('assets/profile_image.png')
                            as ImageProvider,
                    backgroundColor: Colors.grey[200],
                  ),
                  const Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: Color(0xFFB4E576),
                      child: Icon(Icons.edit, size: 20, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // Full Name Field
            _buildTextField(
              controller: fullNameController,
              label: "Full Name",
            ),
            const SizedBox(height: 20),

            // Email Field
            _buildTextField(
              controller: emailController,
              label: "Email",
            ),
            const SizedBox(height: 30),

            // Save Button
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, {
                  'fullName': fullNameController.text,
                  'email': emailController.text,
                  'profileImage': _selectedImage,
                });
              },
              child: const Text('Save'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                backgroundColor: const Color(0xFFB4E576),
                textStyle: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
  }) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.white),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.white),
        ),
      ),
    );
  }
}
