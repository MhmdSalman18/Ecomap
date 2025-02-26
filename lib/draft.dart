// ignore_for_file: prefer_const_constructors, unused_import

import 'package:ecomap/BottomNavigationBar.dart';
import 'package:ecomap/CustomDrawer.dart';
import 'package:ecomap/REGISTRATION/account.dart';
import 'package:ecomap/home.dart';
import 'package:ecomap/services/database_helper.dart';
import 'package:ecomap/statushistory.dart';
import 'package:ecomap/UploadState.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class DraftPage extends StatefulWidget {
  const DraftPage({Key? key, required String title}) : super(key: key);

  @override
  State<DraftPage> createState() => _DraftPageState();
}

class _DraftPageState extends State<DraftPage> {
  List<Map<String, dynamic>> _drafts = [];
  final DatabaseHelper dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _loadDrafts();
  }

  Future<void> _loadDrafts() async {
    final drafts = await dbHelper.getDrafts();
    setState(() {
      _drafts = drafts;
    });
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'sent':
        return 'Sent';
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
        return Colors.greenAccent;
      case 'pending':
        return Colors.blueAccent;
      case 'cancelled':
        return Colors.redAccent;
      default:
        return Colors.grey;
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
                    builder: (context) =>
                        const BottomNavigationBarExample(title: 'HomePage'),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: Image.asset(
                  'assets/assets/ecomap_banner.png',
                  width: 100,
                  height: 50,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Container(
        color: Color(0xFF082517),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Draft Images",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: _drafts.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.folder_open,
                            size: 80,
                            color: Colors.white54,
                          ),
                          SizedBox(height: 10),
                          Text(
                            "No drafts available",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Captured images will appear here.",
                            style: TextStyle(
                              color: Colors.white38,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    )
                  : GridView.builder(
                      padding: EdgeInsets.all(12),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.8,
                      ),
                      itemCount: _drafts.length,
                      itemBuilder: (context, index) {
                        final draft = _drafts[index];
                        final status = draft['status'] ?? 'pending';

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UploadState(
                                  imagePath: draft['imagePath'] ?? '',
                                  title: 'Edit Draft',
                                  draftId: draft['id'] as int,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white12,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(12)),
                                    child: draft['imagePath'] != null &&
                                            draft['imagePath'].isNotEmpty
                                        ? Image.file(
                                            File(draft['imagePath']),
                                            fit: BoxFit.cover,
                                          )
                                        : Container(
                                            color: Colors.grey.shade800,
                                            child: Icon(
                                              Icons.image_not_supported,
                                              size: 50,
                                              color: Colors.white54,
                                            ),
                                          ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        draft['title'] ?? 'No Title',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(height: 6),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: _getStatusColor(status)
                                                  .withOpacity(0.2),
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            child: Text(
                                              _getStatusText(status),
                                              style: TextStyle(
                                                color: _getStatusColor(status),
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Icon(
                                            Icons.arrow_forward_ios,
                                            size: 14,
                                            color: Colors.white54,
                                          ),
                                        ],
                                      ),
                                    ],
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
      ),
    );
  }
}
