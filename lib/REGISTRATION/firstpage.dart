import 'package:ecomap/REGISTRATION/login.dart';
import 'package:ecomap/REGISTRATION/signup.dart';
import 'package:flutter/material.dart';

class FirstPage extends StatefulWidget {
  const FirstPage(
      {super.key, required String title, required String imagePath});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(0xFF101C08),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: ClipRRect(
                  borderRadius:
                      BorderRadius.circular(10.0), // Add border radius
                  child: Image.asset(
                    'assets/assets/tiger.jpg', // Updated path to match folder structure
                    height: 250,
                    width: 250,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              const Text(
                'Welcome to Ecomap',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFB4E576),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10.0),
              const Text(
                'Capture wildlife in real-time, map their locations, and contribute to global conservation efforts. Let’s protect nature together!',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40.0),
                SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginPage(
                        title: '',
                        )),
                  );
                  },
                  style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFB4E576),
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  ),
                  child: const Text(
                  'Login',
                  style: TextStyle(fontSize: 18),
                  ),
                ),
                ),
              const SizedBox(height: 16.0),
                SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SignUpPage(title: '',
                        
                        )),
                  );
                  },
                  style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  side: const BorderSide(color: Color(0xFFB4E576)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  ),
                  child: const Text(
                  'Sign Up',
                  style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFFB4E576),
                  ),
                  ),
                ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
