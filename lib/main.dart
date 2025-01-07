import 'package:ecomap/BottomNavigationBar.dart';
import 'package:ecomap/REGISTRATION/account.dart';
import 'package:ecomap/REGISTRATION/firstpage.dart';
import 'package:ecomap/REGISTRATION/login.dart';
import 'package:ecomap/home.dart';
import 'package:ecomap/status.dart';
import 'package:ecomap/uploadstate.dart';
import 'package:flutter/material.dart';

void main() => runApp(const EcomapApp());

class EcomapApp extends StatelessWidget {
  const EcomapApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FirstPage(title: '',), // Start with BottomNavigationBarExample
    );
  }
}
// import 'package:flutter/material.dart';

// class AppColors {
//   static const Color background = Color(0xFF101C08); // Dark greenish-black
//   static const Color cardBackground = Color(0xFF1B3B13); // Dark green
//   static const Color accent = Color(0xFF9ECB3C); // Neon green
//   static const Color iconColor = Color(0xFFB4E576); // Light neon green
//   static const Color textColor = Color(0xFFD1F5A0); // Pale green for text
//   static const Color disabled = Color(0xFF5F7548); // Muted green for inactive states
// }
