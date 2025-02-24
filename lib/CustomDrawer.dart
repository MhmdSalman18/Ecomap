import 'package:ecomap/BottomNavigationBar.dart';
import 'package:ecomap/REGISTRATION/account.dart';
import 'package:ecomap/REGISTRATION/firstpage.dart';
import 'package:ecomap/draft.dart';  // Import DraftPage
import 'package:ecomap/draft1.dart';
import 'package:ecomap/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomDrawer extends StatefulWidget {
  CustomDrawer({super.key});

  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
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
    return Drawer(
      child: Container(
        color: Color(0xFF061D0F), // Set the background color for the drawer
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF101C08), Color(0xFF061D0F)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ), // Custom gradient background
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  _isLoading
                      ? CircularProgressIndicator(color: Color(0xFFB4E576))
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _name,
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              _email,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                ],
              ),
            ),
            _drawerItem(
              icon: Icons.account_box,
              text: 'Account',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AccountPage(),
                  ),
                );
              },
            ),
            _drawerItem(
              icon: Icons.drafts,
              text: 'Drafts',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DraftPage(title: '',), // Directly navigate to DraftPage
                  ),
                );
              },
            ),
            _drawerItem(
                icon: Icons.admin_panel_settings,
              text: 'Expert',
              onTap: () {
                Navigator.pop(context);
                // Add navigation to Map
              },
            ),
            _drawerItem(
              icon: Icons.settings,
              text: 'Settings',
              onTap: () {
                Navigator.pop(context);
                // Add navigation to Settings
              },
            ),
            Divider(color: Colors.white24),
            _drawerItem(
              icon: Icons.logout,
              text: 'Logout',
              iconColor: Colors.red,
              textColor: Colors.red,
              onTap: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.remove('auth_token');
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => FirstPage(title: '', imagePath: ''),
                  ),
                );
              },
            ),
            // Add space at the bottom of the drawer
            SizedBox(height: 50),
            // Close button at the bottom
            ListTile(
              leading: Icon(
                Icons.close,
                color: Colors.white,
                size: 30,
              ),
              title: Text(
                'Close Drawer',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              onTap: () {
                Navigator.pop(context); // Close the drawer
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _drawerItem({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
    Color iconColor = const Color(0xFFB4E576),
    Color textColor = const Color(0xFFD1F5A0),
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: iconColor,
        size: 28,
      ),
      title: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      onTap: onTap,
    );
  }
}
