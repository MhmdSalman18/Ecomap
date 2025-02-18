import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ecomap/home.dart';
import 'package:ecomap/map.dart';
import 'package:ecomap/status.dart';
import 'package:ecomap/uploadstate.dart';

class textPage extends StatefulWidget {
  const textPage({super.key});

  @override
  State<textPage> createState() => _textPageState();
}

class _textPageState extends State<textPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Text Page'),
      ),
      body: const BottomNavigationBarExample(title: 'Bottom Navigation Example'),
    );
  }
}

class BottomNavigationBarExample extends StatefulWidget {
  const BottomNavigationBarExample({super.key, required this.title});
  final String title;

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
    MapPage(),
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
        backgroundColor: Color(0xFF082517), // Set BottomNavigationBar background color to red
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