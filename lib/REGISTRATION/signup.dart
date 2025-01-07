import 'package:ecomap/REGISTRATION/login.dart';
import 'package:ecomap/REGISTRATION/uploaddp.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key, required String title});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
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
                  'panther.jpg', // Replace with your image path
                  height: 250,
                ),
              ),
              const SizedBox(height: 30),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  labelStyle: TextStyle(color: Color(0xFFD1F5A0)),
                  hintText: 'Enter your Full Name',
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
                  prefixIcon: Icon(Icons.account_box, color: Colors.greenAccent),
                ),
                style: TextStyle(color: Color(0xFFD1F5A0)),
              ),
              const SizedBox(height: 20),

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

              // Sign Up Button
                ElevatedButton(
                onPressed: () {
                  Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UploadDpPage(),
                  ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50), backgroundColor:Color(0xFFD1F5A0), // Set button color to red
                ),
                child: const Text('Next'),
              ),
              const SizedBox(height: 20),

              // Already have an account? Sign In
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account? ", style: TextStyle(color: Color(0xFFD1F5A0))),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(title: '',),
                        ),
                      );
                    },
                    child: const Text('Sign In', style: TextStyle(color: Color(0xFFD1F5A0))),
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
