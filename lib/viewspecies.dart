import 'package:ecomap/map.dart';
import 'package:ecomap/mapmyspottings.dart';
import 'package:flutter/material.dart';
import 'package:ecomap/services/api_service.dart'; // Update import path as needed

class ViewSpeciesPage extends StatefulWidget {
  const ViewSpeciesPage({super.key, required this.title});
  final String title;

  @override
  State<ViewSpeciesPage> createState() => _SelectAnimalState();
}

class _SelectAnimalState extends State<ViewSpeciesPage> {
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

      final species = await _apiService.fetchSpecies();

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
  final spot = species['spotId']; // Check if spotId exists
  if (spot == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("No location available for this species")),
    );
    return;
  }

  final location = spot['location']; // Check if location exists
  if (location == null || location['coordinates'] == null || location['coordinates'].length < 2) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Invalid location data")),
    );
    return;
  }

  final coordinates = location['coordinates'];
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => MySpottingsMapPage(
        latitude: coordinates[1], // Latitude is the second value
        longitude: coordinates[0], // Longitude is the first value
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
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search species...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : filteredList.isEmpty
                    ? Center(
                        child: Text(
                          'No species found',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      )
                    : ListView.builder(
                        itemCount: filteredList.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: Image.network(
                              filteredList[index]['image'],
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                              headers: {"User-Agent": "Flutter-App"},
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(Icons.broken_image,
                                    size: 50, color: Colors.red);
                              },
                            ),
                            title: Text(filteredList[index]['common_name']),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(filteredList[index]['scientific_name'],
                                    style: TextStyle(
                                        fontStyle: FontStyle.italic,
                                        color: Colors.grey[700])),
                                Text("Class: ${filteredList[index]['taxonomy_class']}",
                                    style:
                                        TextStyle(fontSize: 12, color: Colors.black54)),
                                Text(
                                    "Conservation: ${filteredList[index]['conservation_status']}",
                                    style:
                                        TextStyle(fontSize: 12, color: Colors.black54)),
                              ],
                            ),
                            trailing: ElevatedButton(
                              onPressed: () => _viewOnMap(filteredList[index]),
                              child: Text("View in Map",
                                  style: TextStyle(fontSize: 12)),
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                minimumSize: Size(80, 30),
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
