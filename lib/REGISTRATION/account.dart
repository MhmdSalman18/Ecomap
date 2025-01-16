import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key, required String title});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  String _tempEmail = "user@example.com";
  String _fullName = "John Doe";
  File? _profileImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
                iconTheme: IconThemeData(color: Color(0xFFD1F5A0)),

        // title: const Text('Account Page'),
        backgroundColor: Color(0xFF1B3B13),
        elevation: 5,
      ),
      backgroundColor: const Color(0xFF1B3B13),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
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
                          final pickedFile =
                              await picker.pickImage(source: ImageSource.gallery);
                          if (pickedFile != null) {
                            setState(() {
                              _profileImage = File(pickedFile.path);
                            });
                          }
                        },
                        child: CircleAvatar(
                          radius: 18,
                          backgroundColor:  Color(0xFFB4E576),
                          child: const Icon(Icons.edit, size: 20, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // Full Name
              _buildDetailRow(
                label: "Full Name",
                value: _fullName,
              ),
              const SizedBox(height: 15),

              // Email
              _buildDetailRow(
                label: "Email",
                value: _tempEmail,
              ),
              const SizedBox(height: 30),

              // Edit Button
              ElevatedButton.icon(
                onPressed: () async {
                  final updatedDetails = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditAccountPage(
                        fullName: _fullName,
                        email: _tempEmail,
                        profileImage: _profileImage,
                      ),
                    ),
                  );

                  if (updatedDetails != null) {
                    setState(() {
                      _fullName = updatedDetails['fullName'];
                      _tempEmail = updatedDetails['email'];
                      _profileImage = updatedDetails['profileImage'];
                    });
                  }
                },
                icon: const Icon(Icons.edit),
                label: const Text('Edit Account'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  backgroundColor:  Color(0xFFB4E576),
                  textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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

  Widget _buildDetailRow({required String label, required String value}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text(
        //   '$label: ',
        //   style: const TextStyle(
        //     fontSize: 16,
        //     fontWeight: FontWeight.bold,
        //   ),
        // ),
        Expanded(
          child: Center(
            child: Text(
              value,
              style: const TextStyle(
          fontSize: 16,
          color: Colors.grey,
              ),
            ),
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
        iconTheme: IconThemeData(color: Color(0xFFD1F5A0)),
        backgroundColor: Color(0xFF1B3B13),
        elevation: 5,
      ),
      backgroundColor: const Color(0xFF1B3B13),
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
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor:  Color(0xFFB4E576),
                      child: const Icon(Icons.edit, size: 20, color: Colors.white),
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
                backgroundColor:  Color(0xFFB4E576),
                textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.white),
      ),
      ),
    );
  }
}
