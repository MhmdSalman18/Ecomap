import 'package:ecomap/mapmyspottings.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MySpottingsPage extends StatefulWidget {
  const MySpottingsPage({super.key});

  @override
  State<MySpottingsPage> createState() => _MySpottingsPageState();
}

class _MySpottingsPageState extends State<MySpottingsPage> {
  List<dynamic> occurrences = [];
  bool isLoading = true;
  String? errorMessage;
  String? loggedInUserId; // Store logged-in user ID

  @override
  void initState() {
    super.initState();
    loadUserId();
  }

  Future<void> loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user_id'); // Get user ID from local storage
    if (userId != null) {
      setState(() {
        loggedInUserId = userId;
      });
      fetchOccurrences();
    } else {
      setState(() {
        errorMessage = 'User ID not found. Please log in again.';
        isLoading = false;
      });
    }
  }

  Future<void> fetchOccurrences() async {
    const url = 'https://ecomap-zehf.onrender.com/expert/get-occurance';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);

        // Filter occurrences by logged-in user ID
        List<dynamic> userOccurrences = data.where((occurrence) {
          return occurrence['userId'] != null &&
              occurrence['userId']['_id'] == loggedInUserId;
        }).toList();

        setState(() {
          occurrences = userOccurrences;
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
                    final species = occurrence['speciesId'] ?? {};
                    final user = occurrence['userId'] ?? {};
                    final expert = occurrence['expertId'] ?? {};
                    final location = spot['location'] ?? {};
                    final coordinates = location['coordinates'];

                    final double? latitude = (coordinates is List && coordinates.length == 2)
                        ? (coordinates[1] as num?)?.toDouble()
                        : null;
                    final double? longitude = (coordinates is List && coordinates.length == 2)
                        ? (coordinates[0] as num?)?.toDouble()
                        : null;

                    return Card(
                      margin: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                              'Date: ${spot['date']?.split("T")[0] ?? 'Unknown Date'}',
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                species['image'] != null
                                    ? Image.network(
                                        species['image'],
                                        width: 50,
                                        height: 50,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) =>
                                            const Icon(Icons.broken_image),
                                      )
                                    : const Icon(Icons.nature),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Species: ${species['common_name'] ?? 'Unknown'}',
                                        style: const TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        'Scientific Name: ${species['scientific_name'] ?? 'N/A'}',
                                      ),
                                      Text(
                                        'Conservation Status: ${species['conservation_status'] ?? 'Unknown'}',
                                        style: TextStyle(
                                          color: species['conservation_status'] == 'Least Concern'
                                              ? Colors.green
                                              : Colors.red,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Reported by: ${user['name'] ?? 'Unknown'}'),
                                Text('Email: ${user['email'] ?? 'N/A'}'),
                                const SizedBox(height: 5),
                                Text(
                                  'Reviewed by: ${expert['name'] ?? 'Unknown'}',
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text('Expert Email: ${expert['email'] ?? 'N/A'}'),
                              ],
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
