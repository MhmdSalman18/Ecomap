import 'package:ecomap/BottomNavigationBar.dart';
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

drawer: Drawer(
  child: ListView(
    padding: EdgeInsets.zero,
    children: [
      DrawerHeader(
        decoration: const BoxDecoration(
          color: Colors.teal, // Background color for the header
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(
                'https://via.placeholder.com/150', // Replace with your image URL
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Your Name", // Add your name or user name
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              "example@email.com", // Add email or other details
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
      ListTile(
        leading: const Icon(Icons.home),
        title: const Text("Home"),
        onTap: () {
          Navigator.pop(context); // Close the drawer
          // Add navigation to Home
        },
      ),
      ListTile(
        leading: const Icon(Icons.upload),
        title: const Text("Upload"),
        onTap: () {
          Navigator.pop(context);
          // Add navigation to Upload
        },
      ),
      ListTile(
        leading: const Icon(Icons.map),
        title: const Text("Map"),
        onTap: () {
          Navigator.pop(context);
          // Add navigation to Map
        },
      ),
      ListTile(
        leading: const Icon(Icons.settings),
        title: const Text("Settings"),
        onTap: () {
          Navigator.pop(context);
          // Add navigation to Settings
        },
      ),
      const Divider(), // Add a horizontal line
      ListTile(
        leading: const Icon(Icons.logout),
        title: const Text("Logout"),
        onTap: () {
          Navigator.pop(context);
          // Add logout functionality
        },
      ),
    ],
  ),
),
      body: Center(
        child: Column(
          children: [Text("status page")],
        ),
      ),
    );
  }
}
