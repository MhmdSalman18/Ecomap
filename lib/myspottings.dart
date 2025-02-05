import 'package:ecomap/map2.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class MySpottingsPage extends StatefulWidget {
  const MySpottingsPage({super.key});

  @override
  State<MySpottingsPage> createState() => _MySpottingsPageState();
}

class _MySpottingsPageState extends State<MySpottingsPage> {
  List<dynamic> occurrences = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchOccurrences();
  }

  Future<void> fetchOccurrences() async {
    const url = 'http://192.168.216.180:3000/expert/get-occurance';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        setState(() {
          occurrences = json.decode(response.body);
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load data: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'An error occurred: $e';
        isLoading = false;
      });
    }
  }

  void _viewOnMap(BuildContext context, double latitude, double longitude) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MySpottingsMapPage(latitude: latitude, longitude: longitude),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Spottings')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(child: Text(errorMessage!))
              : ListView.builder(
                  itemCount: occurrences.length,
                  itemBuilder: (context, index) {
                    final occurrence = occurrences[index];
                    final spot = occurrence['spotId'] ?? {};
                    final location = spot['location'] ?? {};
                    final coordinates = location['coordinates'];

                    // Extract latitude and longitude properly
                    final double? latitude = (coordinates is List && coordinates.length == 2)
                        ? (coordinates[1] as num?)?.toDouble()
                        : null;
                    final double? longitude = (coordinates is List && coordinates.length == 2)
                        ? (coordinates[0] as num?)?.toDouble()
                        : null;

                    return Card(
                      margin: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          ListTile(
                            leading: spot['image'] != null && spot['image'].isNotEmpty
                                ? Image.network(
                                    spot['image'],
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) =>
                                        const Icon(Icons.broken_image),
                                  )
                                : const Icon(Icons.image),
                            title: Text(spot['title'] ?? 'Unknown Title'),
                            subtitle: Text(
                              'Description: ${spot['description'] ?? 'No Description'}\n'
                              'Status: ${spot['status'] ?? 'Unknown'}\n'
                              'Date: ${spot['date'] ?? 'Unknown Date'}',
                            ),
                          ),
                          if (latitude != null && longitude != null)
                            TextButton(
                              onPressed: () => _viewOnMap(context, latitude, longitude),
                              child: const Text('View in Map'),
                            ),
                          if (latitude == null || longitude == null)
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'Location not available',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}
