import 'package:ecomap/BottomNavigationBar.dart';
import 'package:ecomap/REGISTRATION/login.dart';
import 'package:flutter/material.dart';

void main() => runApp(const EcomapApp());

class EcomapApp extends StatelessWidget {
  const EcomapApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(title: '',), // Start with BottomNavigationBarExample
    );
  }
}
