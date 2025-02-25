import 'dart:convert';
import 'package:ecomap/REGISTRATION/account.dart';
import 'package:ecomap/mapmyspottings.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Upload {
  final String image;
  final String title;
  final String description;
  final String status;
  final String date;
  final Map<String, dynamic>? location;

  Upload({
    required this.image,
    required this.title,
    required this.description,
    required this.status,
    required this.date,
    this.location,
  });

  factory Upload.fromJson(Map<String, dynamic> json) {
    return Upload(
      image: json['image'],
      title: json['title'],
      description: json['description'],
      status: json['status'],
      date: json['date'],
      location: json['location'] != null
          ? json['location'] as Map<String, dynamic>
          : null,
    );
  }
}

class MySpottingsPage extends StatefulWidget {
  @override
  _UserUploadsScreenState createState() => _UserUploadsScreenState();
}

class _UserUploadsScreenState extends State<MySpottingsPage> {
  List<Upload> uploads = [];
  List<Upload> filteredUploads = [];
  bool isLoading = true;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchUploads();
    searchController.addListener(_filterUploads);
  }

  Future<void> fetchUploads() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('auth_token');

  if (token == null || token.isEmpty) {
    setState(() => isLoading = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('No authentication token found.')),
    );
    return;
  }

  try {
    final response = await http.get(
      Uri.parse('https://ecomap-zehf.onrender.com/user/uploads'),
      headers: {'x-authtoken': token},
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      setState(() {
        uploads = data
            .map((item) => Upload.fromJson(item))
            .where((upload) => upload.status.toLowerCase() == "approved")
            .toList();
        filteredUploads = uploads;
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch uploads: ${response.reasonPhrase}')),
      );
    }
  } catch (e) {
    setState(() => isLoading = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Network error occurred: $e')),
    );
  }
}


  void _filterUploads() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredUploads = uploads.where((upload) {
        return upload.title.toLowerCase().contains(query) ||
            upload.description.toLowerCase().contains(query);
      }).toList();
    });
  }

  void viewOnMap(Upload upload) {
    if (upload.location != null &&
        upload.location?['coordinates'] != null &&
        upload.location?['coordinates'] is List &&
        upload.location?['coordinates'].length == 2) {
      double? latitude =
          double.tryParse(upload.location!['coordinates'][1].toString());
      double? longitude =
          double.tryParse(upload.location!['coordinates'][0].toString());

      if (latitude != null && longitude != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MySpottingsMapPage(
              latitude: latitude,
              longitude: longitude,
              title: upload.title,
              imageUrl: upload.image,
              description: upload.description,
              date: upload.date,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid location data')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No location data available')),
      );
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF082517),
      appBar: AppBar(
        backgroundColor: Color(0xFF082517),
        title: Text(
          'My Spottings',
          style: TextStyle(color: Color(0xFFB4E576), fontWeight: FontWeight.bold),
        ),
        iconTheme: IconThemeData(color: Color(0xFFB4E576)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AccountPage()),
                );
              },
 child: Padding(
              padding: const EdgeInsets.only(right: 12.0), // Add padding to the left and right
              child: Image.asset(
                'assets/assets/ecomap_banner.png',
                width: 100, // Adjust the width as needed
                height: 50, // Adjust the height as needed
              ),
              ),            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search species...',
                hintStyle: TextStyle(color: Colors.white70),
                prefixIcon: Icon(Icons.search, color: Colors.white70),
                filled: true,
                fillColor: Color(0xFF0E3B2C),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: isLoading
                ? Center(
                    child: Lottie.asset(
                      'assets/animations/main_scene.json',
                      width: 120,
                      height: 120,
                    ),
                  )
                : filteredUploads.isEmpty
                    ? Center(
                        child: Text(
                          'No spottings found.',
                          style: TextStyle(color: Colors.white70, fontSize: 18),
                        ),
                      )
                    : ListView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        itemCount: filteredUploads.length,
                        itemBuilder: (context, index) {
                          final upload = filteredUploads[index];
                          return Card(
                            color: Color(0xFF0E3B2C), // Dark Greenish
                            elevation: 6,
                            shadowColor: Colors.black54, // Soft shadow
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            margin: EdgeInsets.symmetric(vertical: 8),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      upload.image,
                                      width: 70,
                                      height: 70,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Container(
                                          width: 70,
                                          height: 70,
                                          color: Colors.grey[300],
                                          child: Icon(Icons.image_not_supported, color: Colors.grey[600]),
                                        );
                                      },
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          upload.title,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          upload.description,
                                          style: TextStyle(
                                            color: Colors.white70,
                                            fontSize: 14,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          upload.date.substring(0, 10),
                                          style: TextStyle(color: Colors.white54, fontSize: 14),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  ElevatedButton.icon(
                                    onPressed: () => viewOnMap(upload),
                                    icon: Icon(Icons.location_pin, color: Color(0xFF082517)),
                                    label: Text("View", style: TextStyle(color: Color(0xFF082517))),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(0xFFB4E576),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
