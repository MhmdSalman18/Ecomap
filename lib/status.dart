import 'package:ecomap/BottomNavigationBar.dart';
import 'package:ecomap/CustomDrawer.dart';
import 'package:ecomap/REGISTRATION/account.dart';
import 'package:ecomap/statushistory.dart';
import 'package:flutter/material.dart';

class StatusPage extends StatefulWidget {
  const StatusPage({super.key, required String title});

  @override
  State<StatusPage> createState() => _StatusPageState();
}

class _StatusPageState extends State<StatusPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text('Status'),
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
                    builder: (context) => const AccountPage(title: 'Home'),
                  ),
                );
              },
              child: CircleAvatar(
                backgroundImage: NetworkImage(
                    'https://via.placeholder.com/150'), // Replace with your image URL
                radius: 18, // Adjust the size
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Text("status page"),
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.end, // Align the row's content to the right
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
                    margin: const EdgeInsets.all(6.0),
                    padding: const EdgeInsets.all(6.0),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Row(
                      mainAxisSize:
                          MainAxisSize.min, // Makes the width wrap the content
                      children: const [
                        Icon(Icons.history, color: Colors.white),
                        SizedBox(width: 10.0),
                        Text(
                          'History',
                          style: TextStyle(color: Colors.white, fontSize: 18.0),
                        ),
                      ],
                    ),
                  ),
                ),
            
              ],
            ),
            Container(
              margin: const EdgeInsets.all(10.0),
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(10.0),
              ),
              width: MediaQuery.of(context).size.width * 010,
              height: 100.0,
              child: const Center(
                child: Text(
                  'Responsive Box',
                  style: TextStyle(color: Colors.white, fontSize: 18.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
