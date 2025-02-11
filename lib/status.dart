// ignore_for_file: prefer_const_constructors

import 'package:ecomap/BottomNavigationBar.dart';
import 'package:ecomap/CustomDrawer.dart';
import 'package:ecomap/REGISTRATION/account.dart';
import 'package:ecomap/services/database_helper.dart'; // Import DatabaseHelper
import 'package:ecomap/statushistory.dart';
import 'package:ecomap/UploadState.dart'; // Import UploadState
import 'package:flutter/material.dart';

class StatusPage extends StatefulWidget {
  const StatusPage({Key? key, required String title}) : super(key: key);

  @override
  State<StatusPage> createState() => _StatusPageState();
}

class _StatusPageState extends State<StatusPage> {
  List<Map<String, dynamic>> _drafts = [];
  final DatabaseHelper dbHelper = DatabaseHelper(); // DatabaseHelper instance

  @override
  void initState() {
    super.initState();
    _loadDrafts();
  }

  Future<void> _loadDrafts() async {
    final drafts = await dbHelper.getDrafts(); // Fetch all drafts from the database
    setState(() {
      _drafts = drafts;
    });
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'sent':
        return 'Send';
      case 'pending':
        return 'Pending';
      case 'cancelled':
        return 'Cancelled';
      default:
        return 'Unknown';
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'sent':
        return Color.fromARGB(255, 0, 255, 26);
      case 'pending':
        return Color.fromARGB(255, 0, 174, 255);
      case 'cancelled':
        return Color.fromARGB(255, 255, 0, 0);
      default:
        return Colors.grey;
    }
  }

  Color _getContainerColor(String status) {
    switch (status) {
      case 'sent':
        return Color.fromARGB(255, 184, 255, 188);
      case 'pending':
        return Color.fromARGB(255, 185, 238, 252);
      case 'cancelled':
        return Color.fromARGB(255, 253, 190, 190);
      default:
        return Colors.grey[300]!;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'sent':
        return Icons.send_to_mobile;
      case 'pending':
        return Icons.pending_actions;
      case 'cancelled':
        return Icons.cancel;
      default:
        return Icons.help_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF082517),
        iconTheme: IconThemeData(
          color: Color(0xFFB4E576),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AccountPage(),
                  ),
                );
              },
              child: CircleAvatar(
                radius: 18,
              ),
            ),
          ),
        ],
      ),
      drawer: CustomDrawer(),
      body: Container(
        color: Color(0xFF082517),
        child: Center(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const StatusHistoryPage(),
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.all(10.0),
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(
                          vertical: 5.0, horizontal: 16.0),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 251, 233, 233),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.history),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'History',
                            style: TextStyle(
                              color: Color.fromARGB(255, 122, 73, 73),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _drafts.length,
                  itemBuilder: (context, index) {
                    final draft = _drafts[index];
                    final status = draft['status'] ??
                        'pending'; // Assuming 'status' field exists in your draft data

                    return GestureDetector( // Wrap the container with GestureDetector
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UploadState(
                              imagePath: draft['imagePath'] ??
                                  '', // Pass imagePath or a default value
                              title: 'Edit Draft',
                              draftId: draft['id'] as int, // Pass the draft ID
                            ),
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.all(10.0),
                        padding: const EdgeInsets.all(20.0),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 49, 106, 35),
                          borderRadius: BorderRadius.circular(10.0),
                          boxShadow: [
                            BoxShadow(
                              color: const Color.fromARGB(255, 0, 0, 0)
                                  .withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        draft['title'] ?? 'No Title',
                                        style: TextStyle(
                                            color:
                                                Color.fromARGB(255, 255, 255, 255),
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(height: 8.0),
                                      Wrap(
                                        crossAxisAlignment:
                                            WrapCrossAlignment.center,
                                        spacing: 10.0,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                draft['date'] ?? 'No Date',
                                                style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 255, 255, 255),
                                                  fontSize: 14.0,
                                                ),
                                              ),
                                              SizedBox(width: 10),
                                              Container(
                                                alignment: Alignment.center,
                                                padding: const EdgeInsets.symmetric(
                                                    vertical: 5.0,
                                                    horizontal: 16.0),
                                                decoration: BoxDecoration(
                                                  color: _getContainerColor(status),
                                                  borderRadius:
                                                      BorderRadius.circular(5.0),
                                                ),
                                                child: Text(
                                                  _getStatusText(status),
                                                  style: TextStyle(
                                                    color: _getStatusColor(status),
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                CircleAvatar(
                                  backgroundColor: _getStatusColor(status),
                                  child: Icon(_getStatusIcon(status),
                                      color:
                                          const Color.fromARGB(255, 245, 245, 245)),
                                ),
                              ],
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
        ),
      ),
    );
  }
}
