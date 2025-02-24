import 'package:ecomap/REGISTRATION/account.dart';
import 'package:ecomap/mapviewspecies.dart';
import 'package:flutter/material.dart';
import 'package:ecomap/services/api_service.dart';
import 'package:lottie/lottie.dart';

class ViewSpeciesPage extends StatefulWidget {
  const ViewSpeciesPage({super.key, required this.title});
  final String title;

  @override
  State<ViewSpeciesPage> createState() => _ViewSpeciesPageState();
}

class _ViewSpeciesPageState extends State<ViewSpeciesPage> {
  final ApiService _apiService = ApiService();
  List<Map<String, dynamic>> speciesList = [];
  List<Map<String, dynamic>> filteredList = [];
  bool isLoading = true;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSpecies();
    searchController.addListener(_filterSpecies);
  }

  Future<void> _loadSpecies() async {
    try {
      setState(() {
        isLoading = true;
      });

      final species = await _apiService.fetchSpeciesWithLocations();

      setState(() {
        speciesList = species;
        filteredList = speciesList;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load species: $e')),
      );
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

  void _viewOnMap(Map<String, dynamic> species) {
    if (!species.containsKey('location') || species['location'] == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No location available for this species")),
      );
      return;
    }

    if (!species.containsKey('_id')) {
      debugPrint("Species ID is missing!");
      return;
    }

    final location = species['location'];

    if (!location.containsKey('coordinates') || location['coordinates'].length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid location data")),
      );
      return;
    }

    final coordinates = location['coordinates'];

    debugPrint("Navigating to map with speciesId: ${species['_id']}");

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MapViewSpeciesPage(
          speciesId: species['_id'],
          latitude: coordinates[1], // Latitude
          longitude: coordinates[0], // Longitude
          speciesImage: species['image'],
          commonName: species['common_name'],
          scientificName: species['scientific_name'],
          conservationStatus: species['conservation_status'],
        ),
      ),
    );
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
          'Explore Species',
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
                      width: 100,
                      height: 100,
                    ),
                  )
                : filteredList.isEmpty
                    ? Center(
                        child: Text(
                          'No species found',
                          style: TextStyle(color: Colors.white70, fontSize: 18),
                        ),
                      )
                    : ListView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        itemCount: filteredList.length,
                        itemBuilder: (context, index) {
                          final species = filteredList[index];

                          return Card(
                            color: Color(0xFF0E3B2C), // Dark Greenish
                            elevation: 5,
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
                                      species['image'],
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
                                          species['common_name'],
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          species['scientific_name'],
                                          style: TextStyle(
                                            color: Colors.white70,
                                            fontSize: 14,
                                            fontStyle: FontStyle.italic,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  ElevatedButton.icon(
                                    onPressed: () => _viewOnMap(species),
                                    icon: Icon(Icons.location_pin, color: Color(0xFF082517)),
                                    label: Text(
                                      "View",
                                      style: TextStyle(color: Color(0xFF082517)),
                                    ),
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
