import 'package:ecomap/REGISTRATION/login.dart';
import 'package:ecomap/REGISTRATION/uploaddp.dart';
import 'package:flutter/material.dart';
import 'package:ecomap/services/api_service.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key, required String title});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final ApiService apiService = ApiService();

  bool _isUsernameValid = true;
  bool _isEmailValid = true;
  bool _isPasswordValid = true;
  bool _isConfirmPasswordValid = true;
  bool _isPasswordVisible = false;

  void _validateFields() {
    setState(() {
      _isUsernameValid = _usernameController.text.length >= 4;
      _isEmailValid =
          RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
              .hasMatch(_emailController.text);
      _isPasswordValid = _passwordController.text.length >= 8;
      _isConfirmPasswordValid =
          _passwordController.text == _confirmPasswordController.text;
    });
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Input Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _handleSubmit() async {
    _validateFields();

    if (!_isUsernameValid ||
        !_isEmailValid ||
        !_isPasswordValid ||
        !_isConfirmPasswordValid) {
      String errorMessage = '';

      if (!_isUsernameValid)
        errorMessage += 'Username must be at least 4 characters long.\n';
      if (!_isEmailValid) errorMessage += 'Please enter a valid email.\n';
      if (!_isPasswordValid)
        errorMessage += 'Password must be at least 8 characters long.\n';
      if (!_isConfirmPasswordValid) errorMessage += 'Passwords do not match.\n';

      _showErrorDialog(errorMessage);
    } else {
      print("Username: ${_usernameController.text}");
      try {
        // Call the registerUser method from ApiService
        String message = await apiService.registerUser(_usernameController.text,
            _emailController.text, _passwordController.text);

        // Show success message and navigate to the next page
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Success'),
              content: Text(message),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop(); // Close dialog
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const UploadDpPage(
                                title: '',
                              )), // Replace with your next page
                    );
                  },
                ),
              ],
            );
          },
        );
      } catch (error) {
        // Show error message from API or network error
        _showErrorDialog(error.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Color(0xFF1B3B13),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: Image.asset(
                    'assets/assets/panther.jpg',
                    height: 250,
                  ),
                ),
                const SizedBox(height: 30),

                // Username TextField
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'Full Name',
                    labelStyle: const TextStyle(color: Color(0xFFD1F5A0)),
                    hintText: 'Enter your Full Name',
                    hintStyle: TextStyle(
                        color: const Color(0xFFD1F5A0).withOpacity(0.6)),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.white54),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                          color:
                              _isUsernameValid ? Colors.white54 : Colors.red),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                          color: _isUsernameValid
                              ? Colors.greenAccent
                              : Colors.red),
                    ),
                    prefixIcon: const Icon(Icons.account_box,
                        color: Colors.greenAccent),
                  ),
                  style: const TextStyle(color: Color(0xFFD1F5A0)),
                  onChanged: (value) => _validateFields(),
                ),
                const SizedBox(height: 20),

                // Email TextField
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: const TextStyle(color: Color(0xFFD1F5A0)),
                    hintText: 'Enter your email',
                    hintStyle: TextStyle(
                        color: const Color(0xFFD1F5A0).withOpacity(0.6)),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.1),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.white54)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                            color:
                                _isEmailValid ? Colors.white54 : Colors.red)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                            color: _isEmailValid
                                ? Colors.greenAccent
                                : Colors.red)),
                    prefixIcon:
                        const Icon(Icons.email, color: Colors.greenAccent),
                  ),
                  style: const TextStyle(color: Color(0xFFD1F5A0)),
                  onChanged: (value) => _validateFields(),
                ),
                const SizedBox(height: 20),

                // Password TextField
                TextField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: const TextStyle(color: Color(0xFFD1F5A0)),
                  hintText: 'Enter your password',
                  hintStyle: TextStyle(
                    color: const Color(0xFFD1F5A0).withOpacity(0.6)),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.1),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.white54)),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: _isPasswordValid
                        ? Colors.white54
                        : Colors.red)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: _isPasswordValid
                        ? Colors.greenAccent
                        : Colors.red)),
                  prefixIcon:
                    const Icon(Icons.lock, color: Colors.greenAccent),
                  suffixIcon: IconButton(
                    icon: Icon(
                    _isPasswordVisible
                      ? Icons.visibility
                      : Icons.visibility_off,
                    color: Color(0xFFD1F5A0),
                    ),
                    onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                    },
                  ),
                  ),
                  style: const TextStyle(color: Color(0xFFD1F5A0)),
                  onChanged: (value) => _validateFields(),
                ),
                const SizedBox(height: 20),

                // Confirm Password TextField
                TextField(
                  controller: _confirmPasswordController,
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  labelStyle: const TextStyle(color: Color(0xFFD1F5A0)),
                  hintText: 'Re-enter your password',
                  hintStyle: TextStyle(
                    color: const Color(0xFFD1F5A0).withOpacity(0.6)),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.1),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.white54)),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: _isConfirmPasswordValid
                        ? Colors.white54
                        : Colors.red)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: _isConfirmPasswordValid
                        ? Colors.greenAccent
                        : Colors.red)),
                  prefixIcon:
                    const Icon(Icons.lock, color: Colors.greenAccent),
                  suffixIcon: IconButton(
                    icon: Icon(
                    _isPasswordVisible
                      ? Icons.visibility
                      : Icons.visibility_off,
                    color: Color(0xFFD1F5A0),
                    ),
                    onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                    },
                  ),
                  ),
                  style: const TextStyle(color: Color(0xFFD1F5A0)),
                  onChanged: (value) => _validateFields(),
                ),

                const SizedBox(height: 20),

                // Sign Up Button
                ElevatedButton(
                  onPressed: _handleSubmit,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    backgroundColor: const Color(0xFFD1F5A0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Next'),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginPage(
                            title: '',
                          ),
                        ),
                      );
                    },
                    child: Text(
                      "Already have an account? Sign up",
                      style: TextStyle(
                        color: Color(0xFFD1F5A0),
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
