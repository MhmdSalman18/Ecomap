import 'package:flutter/material.dart';
import 'package:ecomap/services/api_service.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  // Stage management
  int _currentStage = 0; // 0: Email, 1: OTP, 2: New Password

  // Controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  // Validation
  bool _isEmailValid = true;
  bool _isOtpValid = true;
  bool _isPasswordValid = true;

  Widget _buildEmailStage() {
    return Column(
      children: [
        TextField(
          controller: _emailController,
          decoration: InputDecoration(
            labelText: 'Enter Email',
            labelStyle: TextStyle(color: Color(0xFFD1F5A0)),
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _currentStage = 1; // Move to OTP stage
            });
          },
          child: Text('Send OTP'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFFD1F5A0),
            minimumSize: Size(double.infinity, 50),
          ),
        )
      ],
    );
  }

  Widget _buildOtpStage() {
    return Column(
      children: [
        TextField(
          controller: _otpController,
          decoration: InputDecoration(
            labelText: 'Enter OTP',
            labelStyle: TextStyle(color: Color(0xFFD1F5A0)),
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _currentStage = 2; // Move to New Password stage
            });
          },
          child: Text('Verify OTP'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFFD1F5A0),
            minimumSize: Size(double.infinity, 50),
          ),
        )
      ],
    );
  }

  Widget _buildNewPasswordStage() {
    return Column(
      children: [
        TextField(
          controller: _newPasswordController,
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'New Password',
            labelStyle: TextStyle(color: Color(0xFFD1F5A0)),
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 20),
        TextField(
          controller: _confirmPasswordController,
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'Confirm Password',
            labelStyle: TextStyle(color: Color(0xFFD1F5A0)),
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            // TODO: Implement password reset logic
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Password Reset Successful')),
            );
          },
          child: Text('Reset Password'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFFD1F5A0),
            minimumSize: Size(double.infinity, 50),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1B3B13),
      appBar: AppBar(
        backgroundColor: Color(0xFF1B3B13),
        title: Text('Reset Password', style: TextStyle(color: Color(0xFFD1F5A0))),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Dynamic stage rendering
                if (_currentStage == 0) _buildEmailStage(),
                if (_currentStage == 1) _buildOtpStage(),
                if (_currentStage == 2) _buildNewPasswordStage(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
