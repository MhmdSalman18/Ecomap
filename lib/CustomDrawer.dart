import 'package:ecomap/home.dart';
import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Color(0xFF101C08), // Set the background color for the drawer
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFF101C08), // Background color for the header
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Your Name", // Add your name or user name
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
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
              leading:
                  Icon(Icons.home, color: Color(0xFFB4E576)), // Red icon color
              title: const Text("Home",
                  style: TextStyle(color: Color(0xFFD1F5A0))),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomePage(

                      title: '',
                    ),
                  ),
                );
                // Add navigation to Home
              },
            ),
            ListTile(
              leading: Icon(Icons.upload,
                  color: Color(0xFFB4E576)), // Red icon color
              title: const Text("Upload",
                  style: TextStyle(color: Color(0xFFD1F5A0))),
              onTap: () {
                Navigator.pop(context);
                // Add navigation to Upload
              },
            ),
            ListTile(
              leading:
                  Icon(Icons.map, color: Color(0xFFB4E576)), // Red icon color
              title:
                  const Text("Map", style: TextStyle(color: Color(0xFFD1F5A0))),
              onTap: () {
                Navigator.pop(context);
                // Add navigation to Map
              },
            ),
            ListTile(
              leading: Icon(Icons.settings,
                  color: Color(0xFFB4E576)), // Red icon color
              title: const Text("Settings",
                  style: TextStyle(color: Color(0xFFD1F5A0))),
              onTap: () {
                Navigator.pop(context);
                // Add navigation to Settings
              },
            ),
            const Divider(), // Add a horizontal line
            ListTile(
              leading: Icon(Icons.logout,
                  color: Color(0xFFB4E576)), // Red icon color
              title: const Text("Logout",
                  style: TextStyle(color: Color(0xFFD1F5A0))),
              onTap: () {
                Navigator.pop(context);
                // Add logout functionality
              },
            ),
          ],
        ),
      ),
    );
  }
}
