import 'package:ecomap/REGISTRATION/login.dart';
import 'package:flutter/material.dart';
import 'package:ecomap/services/api_service.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final ApiService _apiService = ApiService();
  
  // Stage management
  int _currentStage = 0; // 0: Email, 1: OTP, 2: New Password

  // Controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  // State variables
  bool _isLoading = false;
  String _email = ''; // Store email for subsequent stages
  String _resetToken = '';
  

  // Validation
  bool _isEmailValid = true;
  bool _isOtpValid = true;
  bool _isPasswordValid = true;

  void _sendOtp() async {
    setState(() {
      _isLoading = true;
      _isEmailValid = true;
    });

    try {
      // Validate email format
      if (!_isValidEmail(_emailController.text)) {
        setState(() {
          _isEmailValid = false;
          _isLoading = false;
        });
        return;
      }

      final result = await _apiService.sendOtp(_emailController.text);

      setState(() {
        _isLoading = false;
      });

      if (result['success']) {
        setState(() {
          _email = _emailController.text;
          _currentStage = 1;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message']),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message']),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

void _verifyOtp() async {
    setState(() {
      _isLoading = true;
      _isOtpValid = true;
    });

    try {
      final result = await _apiService.verifyOtp(_email, _otpController.text);

      setState(() {
        _isLoading = false;
      });

      if (result['success']) {
        setState(() {
          _currentStage = 2;
          // Store the reset token
          _resetToken = result['resetToken'];
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message']),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        setState(() {
          _isOtpValid = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message']),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _resetPassword() async {
    // Validate passwords match
    if (_newPasswordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Passwords do not match'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _isPasswordValid = true;
    });

    try {
      final result = await _apiService.resetPassword(
        resetToken: _resetToken,
        newPassword: _newPasswordController.text,
      );

      setState(() {
        _isLoading = false;
      });

      if (result['success']) {
        // Show success dialog or snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message']),
            backgroundColor: Colors.green,
          ),
        );

        // Navigate back to login page
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => LoginPage(title: "",)),
        );
      } else {
        setState(() {
          _isPasswordValid = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message']),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Email validation regex
  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  Widget _buildEmailStage() {
    return Column(
      children: [
        TextField(
          controller: _emailController,
          decoration: InputDecoration(
            labelText: 'Enter Email',
            labelStyle: TextStyle(color: Color(0xFFD1F5A0)),
            border: OutlineInputBorder(),
            errorText: _isEmailValid ? null : 'Invalid email format',
            errorStyle: TextStyle(color: Colors.red),
          ),
          onChanged: (value) {
            setState(() {
              _isEmailValid = _isValidEmail(value);
            });
          },
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: _isLoading ? null : _sendOtp,
          child: _isLoading 
            ? CircularProgressIndicator(color: Colors.white)
            : Text('Send OTP'),
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
            errorText: _isOtpValid ? null : 'Invalid OTP',
            errorStyle: TextStyle(color: Colors.red),
          ),
          onChanged: (value) {
            setState(() {
              _isOtpValid = value.length == 6; // Assuming 6-digit OTP
            });
          },
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: _isLoading ? null : _verifyOtp,
          child: _isLoading 
            ? CircularProgressIndicator(color: Colors.white)
            : Text('Verify OTP'),
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
          onPressed: _isLoading ? null : _resetPassword,
          child: _isLoading 
            ? CircularProgressIndicator(color: Colors.white)
            : Text('Reset Password'),
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

  @override
  void dispose() {
    _emailController.dispose();
    _otpController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
