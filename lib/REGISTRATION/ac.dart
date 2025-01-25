import 'package:ecomap/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';



class ac extends StatefulWidget {
  @override
  _acState createState() => _acState();
}

class _acState extends State<ac> {
  String _email = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserEmail();
  }

  Future<void> _fetchUserEmail() async {
  try {
    final email = await ApiService().getUserEmail();
    setState(() {
      _email = email;
      _isLoading = false;
    });
  } catch (e) {
    print('Error fetching email: $e'); // Add this line for debugging
    setState(() {
      _email = 'Error fetching email: $e';
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
            ? CircularProgressIndicator()
            : Text(
                'User Email: $_email',
                style: TextStyle(fontSize: 20),
              ),
      ),
    );
  }
}