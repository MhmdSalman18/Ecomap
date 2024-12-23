import 'package:ecomap/BottomNavigationBar.dart';
import 'package:ecomap/CustomDrawer.dart';
import 'package:flutter/material.dart';

class StatusPage extends StatefulWidget {
  const StatusPage({super.key});

  @override
  State<StatusPage> createState() => _StatusPageState();
}

class _StatusPageState extends State<StatusPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
  backgroundColor: Colors.red,
  actions: [
    Padding(
      padding: const EdgeInsets.only(right: 8.0), // Add padding to the right
      child: GestureDetector(
        onTap: () {
          // Navigate to HomePage
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const BottomNavigationBarExample(title: 'Home'),
            ),
          );
        },
        child: CircleAvatar(
          backgroundImage: NetworkImage(
              'https://via.placeholder.com/150'), // Replace with your image URL
          radius: 18, // Adjust the size
        ),
      ),
    ),
  ],
),

      drawer: const CustomDrawer(), // Use the reusable drawer

      body: Center(
        child: Column(
          children: [Text("status page")],
        ),
      ),
    );
  }
}
