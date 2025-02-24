import 'package:ecomap/heatmap.dart';
import 'package:ecomap/home.dart';
import 'package:ecomap/map.dart';
import 'package:ecomap/statushistory.dart';
import 'package:flutter/material.dart';

class Draft1 extends StatefulWidget {
  const Draft1({super.key});

  @override
  State<Draft1> createState() => _Draft1State();
}

class _Draft1State extends State<Draft1> {
  int _selectedIndex = 3; // Default index to Draft1

  // List of pages for BottomNavigationBar, including Draft1
  final List<Widget> _widgetOptions = <Widget>[
    const StatusHistoryPage(title: 'Status'),
    const HomePage(title: 'Homepage'),
    const MapPage(title: "Map"),
    const DraftContent(), // This keeps Draft1 content initially
  ];

  // Handle item selection
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red, // Set background color to red
      
      body: _widgetOptions[_selectedIndex], // Display the selected page
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.sync),
            label: 'Status',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera),
            label: 'Homepage',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on),
            label: 'Map',
          ),
        ],
        currentIndex: _selectedIndex == 3 ? 1 : _selectedIndex, // Keep Draft1 out of the BottomNav
        selectedItemColor: const Color(0xFFB4E576),
        unselectedItemColor: const Color(0xFF5F7548),
        backgroundColor: const Color(0xFF082517),
        onTap: (index) {
          setState(() {
            _selectedIndex = index; // Update only if navigating from Draft1
          });
        },
      ),
    );
  }
}

// This widget contains the content of Draft1 but is inside _widgetOptions
class DraftContent extends StatelessWidget {
  const DraftContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('This is the Draft Page'),
    );
  }
}
