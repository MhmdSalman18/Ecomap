import 'package:ecomap/home.dart';
import 'package:ecomap/map.dart';
import 'package:ecomap/status.dart';
import 'package:ecomap/uploadstate.dart';
import 'package:flutter/material.dart';

class BottomNavigationBarExample extends StatefulWidget {
  const BottomNavigationBarExample({super.key, required String title});

  @override
  State<BottomNavigationBarExample> createState() =>
      _BottomNavigationBarExampleState();
}

class _BottomNavigationBarExampleState
    extends State<BottomNavigationBarExample> {
  int _selectedIndex = 0; // Default to 'HomePage'

  // List of pages for BottomNavigationBa
  static const List<Widget> _widgetOptions = <Widget>[
    StatusPage(title: ''),
    HomePage(title: ''),
    HeatMap(),
  ];

  // Handle item selection
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index + 1; // Offset by 1 to manage HomePage
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red, // Set background color to red
      body: Center(
        child: _selectedIndex == 0
            ? const HomePage(title: 'Home') // Show HomePage if index is 0
            : _widgetOptions.elementAt(_selectedIndex - 1), // Show selected page
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.sync),
            label: 'Status',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera),
            label: 'Camera',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on),
            label: 'Map',
          ),
        ],
        currentIndex: _selectedIndex == 0
            ? 0 // Highlight nothing if on HomePage
            : _selectedIndex - 1,
        selectedItemColor:
            _selectedIndex == 0 ? Color(0xFF5F7548) : Color(0xFFB4E576),
        unselectedItemColor:Color(0xFF5F7548),
        backgroundColor: Color(0xFF1B3B13), // Set BottomNavigationBar background color to red
        onTap: _onItemTapped,
      ),
    );
  }

  String _getTitle(int index) {
    switch (index) {
      case 0:
        return 'Status';
      case 1:
        return 'Upload';
      case 2:
        return 'Map';
      default:
        return 'Home';
    }
  }
}
