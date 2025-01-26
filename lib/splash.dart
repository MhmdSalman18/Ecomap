import 'package:ecomap/REGISTRATION/firstpage.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _controller.forward();
    _navigateToHome();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _navigateToHome() async {
    await Future.delayed(const Duration(seconds: 5), () {});
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => FirstPage(title: '', imagePath: '')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF082517),
      body: Center(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FadeTransition(
                opacity: _animation,
                child: ScaleTransition(
                  scale: _animation,
                    child: SizedBox(
                    width: 200, // Set the desired width
                    height: 200, // Set the desired height
                    child: Padding(
                    padding: const EdgeInsets.only(left: 20.0), // Adjust the left padding as needed
                    child: Image.asset('assets/assets/ecomap_banner.png'),
                    ),
                    ),
                ),
              ),
              const SizedBox(height: 10),
              Lottie.asset(
                'assets/animations/main_scene.json',
                width: 100, // Adjust the width as needed
                height: 100, // Adjust the height as needed
              ),
            ],
          ),
        ),
      ),
    );
  }
}
