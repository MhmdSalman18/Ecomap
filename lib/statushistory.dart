import 'dart:convert';
import 'package:ecomap/CustomDrawer.dart';
import 'package:ecomap/REGISTRATION/account.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class StatusHistoryPage extends StatefulWidget {
  const StatusHistoryPage({super.key, required String title});

  @override
  State<StatusHistoryPage> createState() => _StatusHistoryPageState();
}

class _StatusHistoryPageState extends State<StatusHistoryPage> {
  List<dynamic> uploads = [];
  List<dynamic> filteredUploads = [];
  bool isLoading = true;
  final TextEditingController searchController = TextEditingController();
  int selectedIndex = 0;
  final List<String> statuses = ['All', 'Approved', 'Declined', 'Waiting'];

  @override
  void initState() {
    super.initState();
    fetchUploads();
  }

  Future<void> fetchUploads() async {
    const String apiUrl = 'https://ecomap-zehf.onrender.com/user/uploads';
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      if (token == null) throw Exception('Authentication token not found');
      
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json', 'x-authtoken': token},
      );
      
      if (response.statusCode == 200) {
        setState(() {
          uploads = jsonDecode(response.body);
          uploads.sort((a, b) => DateTime.parse(b['date']).compareTo(DateTime.parse(a['date'])));
          filteredUploads = uploads;
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load uploads');
      }
    } catch (e) {
      setState(() => isLoading = false);
      print('Error fetching data: $e');
    }
  }

  void filterResults() {
    setState(() {
      String query = searchController.text.toLowerCase();
      String selectedStatus = statuses[selectedIndex].toLowerCase();
      
      filteredUploads = uploads.where((upload) {
        final title = upload['title']?.toLowerCase() ?? '';
        final status = upload['status']?.toLowerCase() ?? '';
        
        bool matchesSearch = title.contains(query);
        bool matchesStatus = selectedStatus == 'all' || status == selectedStatus;
        
        return matchesSearch && matchesStatus;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF061D0F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF082517),
        title: const Text(
          '',
          style: TextStyle(color: Color(0xFFB4E576), fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Color(0xFFB4E576)),
        actions: [
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AccountPage()),
            ),
            child:  Padding(
              padding: EdgeInsets.only(right: 8.0),
               child: Padding(
              padding:  EdgeInsets.only(right: 12.0), // Add padding to the left and right
              child: Image.asset(
                'assets/assets/ecomap_banner.png',
                width: 100, // Adjust the width as needed
                height: 50, // Adjust the height as needed
              ),
              ),
            ),
          ),
        ],
      ),
      drawer: CustomDrawer(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: searchController,
              onChanged: (query) => filterResults(),
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search species...',
                hintStyle: const TextStyle(color: Colors.white70),
                prefixIcon: const Icon(Icons.search, color: Colors.white70),
                filled: true,
                fillColor: const Color(0xFF0E3B2C),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Wrap(
              spacing: 8,
              children: List.generate(statuses.length, (index) {
                return ChoiceChip(
                  label: Text(statuses[index], style: const TextStyle(color: Colors.white)),
                  selected: selectedIndex == index,
                  selectedColor: const Color(0xFFB4E576),
                  backgroundColor: const Color(0xFF0E3B2C),
                  onSelected: (bool selected) {
                    setState(() => selectedIndex = index);
                    filterResults();
                  },
                );
              }),
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator(color: Color(0xFFB4E576)))
                : filteredUploads.isEmpty
                    ? const Center(
                        child: Text(
                          'No uploads found',
                          style: TextStyle(fontSize: 18, color: Colors.white70),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: filteredUploads.length,
                        itemBuilder: (context, index) {
                          final upload = filteredUploads[index];
                          return Card(
                            color: const Color(0xFF133D2C),
                            margin: const EdgeInsets.only(bottom: 15),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            elevation: 6,
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: upload['image'] != null
                                        ? Image.network(
                                            upload['image'],
                                            width: 60,
                                            height: 60,
                                            fit: BoxFit.cover,
                                          )
                                        : const Icon(Icons.image, size: 60, color: Colors.white70),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          upload['title'] ?? 'No Title',
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          "📅 ${DateFormat.yMMMMd().format(DateTime.parse(upload['date']).toLocal())}",
                                          style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: Colors.white54),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: _getStatusColor(upload['status']),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      upload['status'] ?? 'Unknown',
                                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
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

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'approved':
        return Colors.green;
      case 'declined':
        return Colors.red;
      case 'waiting':
        return Colors.yellow;
      default:
        return Colors.grey;
    }
  }
}
