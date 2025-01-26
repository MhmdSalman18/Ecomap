import 'package:ecomap/REGISTRATION/forgotpass.dart';
import 'package:ecomap/REGISTRATION/signup.dart';
import 'package:flutter/material.dart';
import 'package:ecomap/BottomNavigationBar.dart';

import 'package:ecomap/services/api_service.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key, required String title}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Text Controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordValid = true; // Add your validation logic
  bool _isPasswordVisible = false;
  final ApiService apiService = ApiService();

  // Validation States
  bool _isEmailValid = true;

  // Email Validation Regex
  final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  // Validation Methods
  void _validateEmail(String value) {
    setState(() {
      _isEmailValid = _emailRegExp.hasMatch(value);
    });
  }

  void _validatePassword(String value) {
    setState(() {
      _isPasswordValid = value.length >= 8;
    });
  }

  // Login Method
  void _handleLogin() async {
    if (_isEmailValid && _isPasswordValid) {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(
            child: Lottie.asset(
                'assets/animations/main_scene.json',
                width: 100, // Adjust the width as needed
                height: 100, // Adjust the height as needed
              ),
          );
        },
      );

      try {
        // Call login API and get token
        final token = await apiService.loginUser(
            _emailController.text.trim(), _passwordController.text.trim());

        // Dismiss loading indicator
        Navigator.of(context).pop();

        // Save token (you might want to use secure storage)
        await saveToken(token);

        // Navigate to bottom navigation
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => BottomNavigationBarExample(title: ''),
          ),
        );
      } catch (error) {
        // Dismiss loading indicator
        Navigator.of(context).pop();

        // Show error in AlertDialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Login Error', style: TextStyle(color: Colors.red)),
              content: Text(
                error.toString().replaceAll('Exception: ', ''),
                style: TextStyle(color: Colors.black87),
              ),
              backgroundColor: Colors.white,
              actions: <Widget>[
                TextButton(
                  child: Text('OK', style: TextStyle(color: Colors.blue)),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            );
          },
        );
      }
    } else {
      // Show validation error SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please correct the errors in the form'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

// Utility function to save token
  Future<void> saveToken(String token) async {
    // Use SharedPreferences or secure storage
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF082517),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // App Logo
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Image.asset(
                          'assets/assets/giraffe.jpg',
                          height: 250,
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Email TextField with Validation
                      TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          labelStyle: TextStyle(color: Color(0xFFD1F5A0)),
                          hintText: 'Enter your email',
                          errorText:
                              _isEmailValid ? null : 'Invalid email format',
                          errorStyle: TextStyle(color: Colors.red),
                          hintStyle: TextStyle(
                              color: Color(0xFFD1F5A0).withOpacity(0.6)),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.1),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color:
                                  _isEmailValid ? Colors.white54 : Colors.red,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color:
                                  _isEmailValid ? Colors.white54 : Colors.red,
                            ),
                          ),
                          prefixIcon: Icon(Icons.email,
                              color: _isEmailValid
                                  ? Colors.greenAccent
                                  : Colors.red),
                        ),
                        onChanged: _validateEmail,
                        style: TextStyle(color: Color(0xFFD1F5A0)),
                      ),
                      const SizedBox(height: 20),

                      // Password TextField with Validation
                      TextField(
                        controller: _passwordController,
                        obscureText: !_isPasswordVisible,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle: TextStyle(color: Color(0xFFD1F5A0)),
                          hintText: 'Enter your password',
                          errorText: _isPasswordValid
                              ? null
                              : 'Password must be 8+ characters',
                          errorStyle: TextStyle(color: Colors.red),
                          hintStyle: TextStyle(
                              color: Color(0xFFD1F5A0).withOpacity(0.6)),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.1),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: _isPasswordValid
                                  ? Colors.white54
                                  : Colors.red,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: _isPasswordValid
                                  ? Colors.white54
                                  : Colors.red,
                            ),
                          ),
                          prefixIcon: Icon(
                            Icons.lock,
                            color: _isPasswordValid
                                ? Colors.greenAccent
                                : Colors.red,
                          ),
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
                        onChanged: _validatePassword,
                        style: TextStyle(color: Color(0xFFD1F5A0)),
                      ),
                      // const SizedBox(height: 20),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ForgotPasswordPage(),
                              ),
                            );
                          },
                          child: Text(
                            'Forgot Password?',
                            style: TextStyle(
                              color: Color(0xFFD1F5A0),
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                      // Rest of the code remains the same...
                      ElevatedButton(
                        onPressed: _handleLogin,
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                          backgroundColor: Color(0xFFD1F5A0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text('Sign In'),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SignUpPage(
                                  title: '',
                                ),
                              ),
                            );
                          },
                          child: Text(
                            "Don't have an account? Sign up",
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
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Dispose controllers to prevent memory leaks
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
