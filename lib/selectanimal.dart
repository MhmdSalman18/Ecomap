import 'package:ecomap/CustomDrawer.dart';
import 'package:ecomap/REGISTRATION/account.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SelectAnimal extends StatefulWidget {
  const SelectAnimal({super.key, required this.title});

  final String title;

  @override
  State<SelectAnimal> createState() => _SelectAnimalState();
}

class _SelectAnimalState extends State<SelectAnimal> {
  List<Map<String, dynamic>> speciesList = [];
  List<Map<String, dynamic>> filteredList = [];
  bool isLoading = true;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchSpecies();
    searchController.addListener(_filterSpecies);
  }

  Future<void> fetchSpecies() async {
    try {
      final response =
          await http.get(Uri.parse('http://192.168.1.3:3000/expert/get-species'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        print('API Response: $data'); // Debugging API response

        setState(() {
          speciesList = List<Map<String, dynamic>>.from(data);
          filteredList = speciesList; // Initially, both lists are the same
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load species');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching species: $e');
    }
  }

  void _filterSpecies() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredList = speciesList.where((species) {
        return species['common_name'].toLowerCase().contains(query) ||
               species['scientific_name'].toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF082517), // AppBar background color
        iconTheme: IconThemeData(
          color: Color(0xFFB4E576),
        ),
        actions: [
          Padding(
            padding:
                const EdgeInsets.only(right: 8.0), // Add padding to the right
            child: GestureDetector(
              onTap: () {
                // Navigate to HomePage
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AccountPage(),
                  ),
                );
              },
              child: CircleAvatar(),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            // Search Bar
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: "Search species...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 10),

            // Species Grid View
            Expanded(
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : filteredList.isEmpty
                      ? Center(
                          child: Text(
                            'No species found',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        )
                      : GridView.builder(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, // Number of items per row
                            crossAxisSpacing: 10.0, // Horizontal spacing between items
                            mainAxisSpacing: 10.0, // Vertical spacing between items
                            childAspectRatio: 0.75, // Aspect ratio of the grid item
                          ),
                          itemCount: filteredList.length,
                          itemBuilder: (context, index) {
                            return Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                children: [
                                  // Image
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      filteredList[index]['image'],
                                      width: double.infinity,
                                      height: 120,
                                      fit: BoxFit.cover, // Ensures image covers the area
                                      headers: {"User-Agent": "Flutter-App"}, // Fix for CORS issues
                                      loadingBuilder: (context, child, loadingProgress) {
                                        if (loadingProgress == null) return child;
                                        return Center(child: CircularProgressIndicator());
                                      },
                                      errorBuilder: (context, error, stackTrace) {
                                        print('Image Load Failed: ${filteredList[index]['image']}');
                                        return Icon(Icons.broken_image, size: 50, color: Colors.red);
                                      },
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  // Name & Scientific Name
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          filteredList[index]['common_name'],
                                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                                        ),
                                        Text(
                                          filteredList[index]['scientific_name'],
                                          style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: Colors.grey[700]),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          "Class: ${filteredList[index]['taxonomy_class']}",
                                          style: TextStyle(fontSize: 12, color: Colors.black54),
                                        ),
                                        Text(
                                          "Conservation: ${filteredList[index]['conservation_status']}",
                                          style: TextStyle(fontSize: 12, color: Colors.black54),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
