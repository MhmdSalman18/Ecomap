import 'package:ecomap/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';



class ac extends StatefulWidget {
  @override
  _acState createState() => _acState();
}

class _acState extends State<ac> {
  String _email = '';
  String _name = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  Future<void> _fetchUserDetails() async {
    try {
      final details = await ApiService().getUserDetails();
      setState(() {
        _email = details['email']!;
        _name = details['name']!;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _email = 'Error fetching details';
        _name = '';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Account Page'),
      ),
      body: Center(
        child: _isLoading
            ? Lottie.asset(
                'assets/animations/main_scene.json',
                width: 100, // Adjust the width as needed
                height: 100, // Adjust the height as needed
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'User Name: $_name',
                    style: TextStyle(fontSize: 20),
                  ),
                  Text(
                    'User Email: $_email',
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
      ),
    );
  }
}