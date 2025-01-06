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
                    margin: const EdgeInsets.all(10.0),
                    padding: const EdgeInsets.all(6.0),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(5.0),
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
              // width: MediaQuery.of(context).size.width * 0.9,
              height: 100.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Responsive Box',
                    style: TextStyle(color: Colors.white, fontSize: 18.0),
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    child:
                        Icon(Icons.pending_actions_sharp, color: Colors.blue),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.all(10.0),
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(10.0),
              ),
              height: 140.0, // Increased to accommodate text
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Text(
                          ' Tiger',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold),
                        ),
                        const Text(
                          'Munnar,reservation forest analu',
                          style: TextStyle(color: Colors.white, fontSize: 14.0),
                        ),
                        const Text(
                          ' 29th December 2024',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.0,
                              fontStyle: FontStyle.italic),
                        ),
                      ],
                    ),
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    child:
                        Icon(Icons.pending_actions_sharp, color: Colors.blue),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.all(10.0),
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(10.0),
              ),
              // width: MediaQuery.of(context).size.width * 0.9,
              height: 100.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Responsive Box',
                    style: TextStyle(color: Colors.white, fontSize: 18.0),
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    child:
                        Icon(Icons.pending_actions_sharp, color: Colors.blue),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
