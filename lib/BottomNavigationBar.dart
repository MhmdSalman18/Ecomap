import 'package:ecomap/heatmap.dart';
import 'package:ecomap/home.dart';
import 'package:ecomap/map.dart';
import 'package:ecomap/status.dart';

import 'package:flutter/material.dart';

class BottomNavigationBarExample extends StatefulWidget {
  final String title; // Use title to determine the initial page

  const BottomNavigationBarExample({super.key, required this.title});

  @override
  State<BottomNavigationBarExample> createState() =>
      _BottomNavigationBarExampleState();
}

class _BottomNavigationBarExampleState
    extends State<BottomNavigationBarExample> {
  int _selectedIndex = 0; // Default to 'StatusPage'

  // List of pages for BottomNavigationBar
  static const List<Widget> _widgetOptions = <Widget>[
    StatusPage(title: 'Status'),
    HomePage(title: "title"),
    MapPage(),
  ];

  @override
  void initState() {
    super.initState();
    // Update _selectedIndex based on the initial title
    _selectedIndex = _getIndexFromTitle(widget.title);
  }

  // Handle item selection
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Get index from title
  int _getIndexFromTitle(String title) {
    switch (title) {
      case 'Status':
        return 0;
      case 'CamPage':
        return 1;
      case 'Map':
        return 2;
      default:
        return 1; // Default to StatusPage if title is invalid
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red, // Set background color to red
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex), // Show selected page
      ),
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
        currentIndex: _selectedIndex,
        selectedItemColor: Color(0xFFB4E576),
        unselectedItemColor: Color(0xFF5F7548),
        backgroundColor:
            Color(0xFF082517), // Set BottomNavigationBar background color
        onTap: _onItemTapped,
      ),
    );
  }
}
