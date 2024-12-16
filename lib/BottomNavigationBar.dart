import 'package:ecomap/home.dart';
import 'package:ecomap/map.dart';
import 'package:ecomap/status.dart';
import 'package:ecomap/upload.dart';
import 'package:flutter/material.dart';

class BottomNavigationBarExample extends StatefulWidget {
  const BottomNavigationBarExample({super.key});

  @override
  State<BottomNavigationBarExample> createState() =>
      _BottomNavigationBarExampleState();
}

class _BottomNavigationBarExampleState
    extends State<BottomNavigationBarExample> {
  int _selectedIndex = 0; // Default to 'HomePage'

  // List of pages for BottomNavigationBar
  static const List<Widget> _widgetOptions = <Widget>[
    StatusPage(),
    UploadImage(),
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
      appBar: AppBar(
        title: Text(_selectedIndex == 0
            ? 'Ecomap - Home'
            : _getTitle(_selectedIndex - 1)),
        backgroundColor: Colors.teal,
      ),
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
            icon: Icon(Icons.camera_enhance),
            label: 'Upload',
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
            _selectedIndex == 0 ? Colors.grey : Colors.amber[800],
        unselectedItemColor: Colors.grey,
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
