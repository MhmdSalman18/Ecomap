import 'dart:convert';
import 'package:ecomap/mapmyspottings.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Upload {
  final String image;
  final String title;
  final String description;
  final String status;
  final String date;
    final Map<String, dynamic>? location; // Keep location as a Map

  

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
            location: json['location'] != null ? json['location'] as Map<String, dynamic> : null,

    );
  }
}

class MySpottingsPage extends StatefulWidget {
  @override
  _UserUploadsScreenState createState() => _UserUploadsScreenState();
}

class _UserUploadsScreenState extends State<MySpottingsPage> {
  List<Upload> uploads = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUploads();
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
          uploads = data.map((item) => Upload.fromJson(item)).toList();
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch uploads.')),
        );
      }
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Network error occurred.')),
      );
    }
  }
void viewOnMap(Upload upload) {
  if (upload.location != null && upload.location?['coordinates'] != null && 
      upload.location?['coordinates'] is List && 
      upload.location?['coordinates'].length == 2) {
    
    double? latitude = double.tryParse(upload.location!['coordinates'][1].toString());
    double? longitude = double.tryParse(upload.location!['coordinates'][0].toString());

    if (latitude != null && longitude != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MySpottingsMapPage(
            latitude: latitude,
            longitude: longitude,
            title: upload.title,
            imageUrl: upload.image, // Pass image URL here
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Uploads')),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : uploads.isEmpty
              ? Center(child: Text('No uploads found.'))
              : ListView.builder(
                  itemCount: uploads.length,
                  itemBuilder: (context, index) {
                    final upload = uploads[index];
                    return Card(
                      margin: EdgeInsets.all(10),
                      child: ListTile(
                        leading: Image.network(
                          upload.image,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(Icons.image_not_supported);
                          },
                        ),
                        title: Text(upload.title),
                        subtitle: Text(upload.description),
                        trailing: ElevatedButton(
                          onPressed: () => viewOnMap(upload),
                          child: Text('View in Map'),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}

