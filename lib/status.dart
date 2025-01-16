// ignore_for_file: prefer_const_constructors

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
        backgroundColor: Color(0xFF1B3B13), // 
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
      drawer: CustomDrawer(),
      body: Container(
        color: Color(0xFF1B3B13),
        child: Center(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment
                    .end, // Align the row's content to the right
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
                      child:  Row(
                        children: [
                          Icon(Icons.history),
                          SizedBox(width: 10,),
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
              Container(
                margin: const EdgeInsets.all(10.0),
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 49, 106, 35),
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(255, 0, 0, 0)
                          .withOpacity(0.2), // Shadow color
                      spreadRadius: 2, // Spread of the shadow
                      blurRadius: 10, // Blur radius
                      offset: Offset(0, 4), // Horizontal and vertical offset
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize:
                      MainAxisSize.min, // Adjust height based on content
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Tiger',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              const Text(
                                'Munnar, reservation forest analu',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    fontSize: 14.0),
                              ),
                              const SizedBox(height: 8.0), // Add spacing
                              Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                spacing:
                                    10.0, // Spacing between "date" and "Send"
                                children: [
                                  Row(
                                    children: [
                                      const Text(
                                        '29th December 2024',
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
                                            vertical: 5.0, horizontal: 16.0),
                                        decoration: BoxDecoration(
                                          color: const Color.fromARGB(255, 184, 255, 188),
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                        ),
                                        child: const Text(
                                          'Send',
                                          style: TextStyle(
                                            color:
                                                Color.fromARGB(255, 0, 255, 26),
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
                          backgroundColor: const Color.fromARGB(255, 47, 255, 0),
                          child: Icon(Icons.send_to_mobile,
                              color: const Color.fromARGB(255, 245, 245, 245)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.all(10.0),
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 49, 106, 35),
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(255, 0, 0, 0)
                          .withOpacity(0.2), // Shadow color
                      spreadRadius: 2, // Spread of the shadow
                      blurRadius: 10, // Blur radius
                      offset: Offset(0, 4), // Horizontal and vertical offset
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize:
                      MainAxisSize.min, // Adjust height based on content
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Alfin Albert',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              const Text(
                                'Munnar, reservation forest analu',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    fontSize: 14.0),
                              ),
                              const SizedBox(height: 8.0), // Add spacing
                              Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                spacing:
                                    10.0, // Spacing between "date" and "Send"
                                children: [
                                  Row(
                                    children: [
                                      const Text(
                                        '29th December 2024',
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
                                            vertical: 5.0, horizontal: 16.0),
                                        decoration: BoxDecoration(
                                          color: const Color.fromARGB(255, 185, 238, 252),
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                        ),
                                        child: const Text(
                                          'Pending',
                                          style: TextStyle(
                                            color:
                                                Color.fromARGB(255, 0, 174, 255),
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
                          backgroundColor: const Color.fromARGB(255, 0, 208, 255),
                          child: Icon(Icons.pending_actions,
                              color: const Color.fromARGB(255, 245, 245, 245)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              Container(
                margin: const EdgeInsets.all(10.0),
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 49, 106, 35),
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(255, 0, 0, 0)
                          .withOpacity(0.2), // Shadow color
                      spreadRadius: 2, // Spread of the shadow
                      blurRadius: 10, // Blur radius
                      offset: Offset(0, 4), // Horizontal and vertical offset
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize:
                      MainAxisSize.min, // Adjust height based on content
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Tiger',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              const Text(
                                'Munnar, reservation forest analu',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    fontSize: 14.0),
                              ),
                              const SizedBox(height: 8.0), // Add spacing
                              Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                spacing:
                                    10.0, // Spacing between "date" and "Send"
                                children: [
                                  Row(
                                    children: [
                                      const Text(
                                        '29th December 2024',
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
                                            vertical: 5.0, horizontal: 16.0),
                                        decoration: BoxDecoration(
                                          color: const Color.fromARGB(
                                              255, 253, 190, 190),
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                        ),
                                        child: const Text(
                                          'Cancelled',
                                          style: TextStyle(
                                            color:
                                                Color.fromARGB(255, 255, 0, 0),
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
                          backgroundColor: const Color.fromARGB(255, 255, 0, 0),
                          child: Icon(Icons.cancel,
                              color: const Color.fromARGB(255, 245, 245, 245)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
