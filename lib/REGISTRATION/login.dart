import 'package:ecomap/BottomNavigationBar.dart';
import 'package:ecomap/REGISTRATION/login.dart';
import 'package:ecomap/REGISTRATION/signup.dart';
import 'package:ecomap/home.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required String title});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(0xFF1B3B13),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // App Logo or Image
                ClipRRect(
                borderRadius: BorderRadius.circular(10.0), // Add border radius
                child: Image.asset(
                  'assets/assets/giraffe.jpg', // Replace with your image path
                  height: 250,
                ),
                ),
              const SizedBox(height: 30),

              // Email TextField
              TextField(
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: Color(0xFFD1F5A0)),
                  hintText: 'Enter your email',
                  hintStyle: TextStyle(color: Color(0xFFD1F5A0).withOpacity(0.6)),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.1),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.white54),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.white54),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.greenAccent),
                  ),
                  prefixIcon: Icon(Icons.email, color: Colors.greenAccent),
                ),
                style: TextStyle(color: Color(0xFFD1F5A0)),
              ),
              const SizedBox(height: 20),

              // Password TextField
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(color: Color(0xFFD1F5A0)),
                  hintText: 'Enter your password',
                  hintStyle: TextStyle(color: Color(0xFFD1F5A0).withOpacity(0.6)),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.1),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.white54),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.white54),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.greenAccent),
                  ),
                  prefixIcon: Icon(Icons.lock, color: Colors.greenAccent),
                ),
                style: TextStyle(color: Color(0xFFD1F5A0)),
              ),
              const SizedBox(height: 20),

              // Forgot Password
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    // Add forgot password functionality here
                  },
                  child: const Text('Forgot Password?', style: TextStyle(color: Color(0xFFD1F5A0))),
                ),
              ),

              // Sign In Button
                  ElevatedButton(
                  onPressed: () {
                    // Add sign-in functionality here
                    Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BottomNavigationBarExample(title: ''),
                    ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    backgroundColor: Color(0xFFD1F5A0),
                    shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // Add border radius
                    ),
                  ),
                  child: const Text('Sign In'),
                  ),
              const SizedBox(height: 20),

              // Don't have an account? Sign Up
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account? ", style: TextStyle(color: Color(0xFFD1F5A0))),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignUpPage(title: ''),
                        ),
                      );
                    },
                    child: const Text('Sign Up', style: TextStyle(color: Color(0xFFD1F5A0))),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
