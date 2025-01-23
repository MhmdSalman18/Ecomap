import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http_parser/http_parser.dart';


class ApiService {
  // Set the base URL for your API
  final String baseUrl =
      'https://ecomap-zehf.onrender.com'; // Replace with your actual server URL

Future<String> registerUser(
  String name, String email, String password) async {
  try {
    final response = await http.post(
      Uri.parse('$baseUrl/user/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
      }),
    );

    print('Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    // Parse the response body
    final responseBody = jsonDecode(response.body);

    // Successful registration
    if (response.statusCode == 201) {
      return responseBody['message'];
    } 
    // Client-side errors (400-410)
    else if (response.statusCode >= 400 && response.statusCode < 410) {
      // Check if there's a specific error message in the response
      if (responseBody != null && responseBody['message'] != null) {
        throw Exception(responseBody['message']);
      }
      // Fallback error message
      throw Exception('Registration failed. Please check your details.');
    } 
    // Server-side errors (500 range)
    else if (response.statusCode >= 500) {
      throw Exception('Server error. Please try again later.');
    } 
    // Unexpected status codes
    else {
      throw Exception('An unexpected error occurred. Please try again.');
    }
  } on SocketException catch (_) {
    // Specifically catch network connectivity issues
    throw Exception('No internet connection. Please check your network.');
  } on FormatException catch (_) {
    // Catch JSON parsing errors
    throw Exception('Error processing server response');
  } on HttpException catch (_) {
    // Catch HTTP-specific errors
    throw Exception('Could not connect to the server');
  } catch (error) {
    // Catch any other unexpected errors
    throw Exception('An unexpected error occurred: ${error.toString()}');
  }
}



Future<String> loginUser(String email, String password) async {
  try {
    final response = await http.post(
      Uri.parse('$baseUrl/user/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    print('Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    // Parse the response body
    final responseBody = jsonDecode(response.body);

    // Successful login
    if (response.statusCode == 200) {
      // Check if token is present
      if (responseBody['token'] != null) {
        return responseBody['token'];
      } else {
        throw Exception('No authentication token received');
      }
    } 
    // Client-side errors (400-410)
    else if (response.statusCode >= 400 && response.statusCode < 410) {
      // Check if there's a specific error message in the response
      if (responseBody != null && responseBody['message'] != null) {
        throw Exception(responseBody['message']);
      }
      // Fallback error message
      throw Exception('Invalid credentials or login failed');
    } 
    // Server-side errors (500 range)
    else if (response.statusCode >= 500) {
      throw Exception('Server error. Please try again later.');
    } 
    // Unexpected status codes
    else {
      throw Exception('An unexpected error occurred. Please try again.');
    }
  } on SocketException catch (_) {
    // Specifically catch network connectivity issues
    throw Exception('No internet connection. Please check your network.');
  } on FormatException catch (_) {
    // Catch JSON parsing errors
    throw Exception('Error processing server response');
  } on HttpException catch (_) {
    // Catch HTTP-specific errors
    throw Exception('Could not connect to the server');
  } catch (error) {
    // Catch any other unexpected errors
    throw Exception('An unexpected error occurred: ${error.toString()}');
  }
}


Future<Map<String, dynamic>> sendOtp(String email) async {
  try {
    final response = await http.post(
      Uri.parse('$baseUrl/user/forgot-password'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
      }),
    );

    print('Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    final responseBody = jsonDecode(response.body);

    // Successful OTP Send
    if (response.statusCode == 200) {
      return {
        'success': true,
        'message': responseBody['message'] ?? 'OTP sent successfully'
      };
    } 
    // Client-side errors (400-410)
    else if (response.statusCode >= 400 && response.statusCode < 410) {
      return {
        'success': false,
        'message': responseBody['message'] ?? 'Failed to send OTP'
      };
    } 
    // Server-side errors (500 range)
    else if (response.statusCode >= 500) {
      return {
        'success': false,
        'message': 'Server error. Please try again later.'
      };
    } 
    // Unexpected status codes
    else {
      return {
        'success': false,
        'message': 'An unexpected error occurred. Please try again.'
      };
    }
  } on SocketException catch (_) {
    return {
      'success': false,
      'message': 'No internet connection. Please check your network.'
    };
  } catch (error) {
    return {
      'success': false,
      'message': 'An unexpected error occurred: ${error.toString()}'
    };
  }
}


Future<Map<String, dynamic>> verifyOtp(String email, String otp) async {
  try {
    final response = await http.post(
      Uri.parse('$baseUrl/user/verify-otp'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'otp': otp,
      }),
    );

    print('Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    final responseBody = jsonDecode(response.body);

    // Successful OTP Verification
    if (response.statusCode == 200) {
      return {
        'success': true,
        'message': responseBody['message'] ?? 'OTP verified successfully',
        'resetToken': responseBody['resetToken'], // New field to store reset token
      };
    } 
    // Client-side errors (400-410)
    else if (response.statusCode >= 400 && response.statusCode < 410) {
      return {
        'success': false,
        'message': responseBody['message'] ?? 'Invalid OTP'
      };
    } 
    // Server-side errors (500 range)
    else if (response.statusCode >= 500) {
      return {
        'success': false,
        'message': 'Server error. Please try again later.'
      };
    } 
    // Unexpected status codes
    else {
      return {
        'success': false,
        'message': 'An unexpected error occurred. Please try again.'
      };
    }
  } on SocketException catch (_) {
    return {
      'success': false,
      'message': 'No internet connection. Please check your network.'
    };
  } catch (error) {
    return {
      'success': false,
      'message': 'An unexpected error occurred: ${error.toString()}'
    };
  }
}

Future<Map<String, dynamic>> resetPassword({
  required String resetToken,
  required String newPassword,
}) async {
  try {
    final response = await http.post(
      Uri.parse('$baseUrl/user/reset-password'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'resetToken': resetToken,
        'newPassword': newPassword,
      }),
    );

    print('Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    final responseBody = jsonDecode(response.body);

    // Successful Password Reset
    if (response.statusCode == 200) {
      return {
        'success': true,
        'message': responseBody['message'] ?? 'Password reset successful'
      };
    } 
    // Client-side errors (400-410)
    else if (response.statusCode >= 400 && response.statusCode < 410) {
      return {
        'success': false,
        'message': responseBody['message'] ?? 'Failed to reset password'
      };
    } 
    // Server-side errors (500 range)
    else if (response.statusCode >= 500) {
      return {
        'success': false,
        'message': 'Server error. Please try again later.'
      };
    } 
    // Unexpected status codes
    else {
      return {
        'success': false,
        'message': 'An unexpected error occurred. Please try again.'
      };
    }
  } on SocketException catch (_) {
    return {
      'success': false,
      'message': 'No internet connection. Please check your network.'
    };
  } catch (error) {
    return {
      'success': false,
      'message': 'An unexpected error occurred: ${error.toString()}'
    };
  }
}



Future<Map<String, dynamic>> uploadData({
  required String title,
  required String description,
  required String date,
  required String imagePath,
  required String location,
}) async {
  // Retrieve the authentication token
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('auth_token');

  // Create a multipart request
  var request = http.MultipartRequest(
    'POST', 
    Uri.parse('$baseUrl/upload-image')
  );

  // Add X-AuthToken header instead of Authorization
  request.headers['x-authtoken'] = token ?? '';
  request.headers['Content-Type'] = 'multipart/form-data';

  // Add text fields matching the schema
  request.fields['title'] = title;
  request.fields['description'] = description;
  request.fields['date'] = date;

  // Parse location coordinates (assuming format is "Latitude, Longitude")
  List<String> coords = location.split(',');
  if (coords.length == 2) {
    request.fields['location[type]'] = 'Point';
    request.fields['location[coordinates][0]'] = coords[1].trim(); // Longitude
    request.fields['location[coordinates][1]'] = coords[0].trim(); // Latitude
  }

  // Add image file as jpg
  if (imagePath.isNotEmpty) {
    request.files.add(await http.MultipartFile.fromPath(
      'image', 
      imagePath,
      contentType: MediaType('image', 'jpg')
    ));
  }

  // Send the request
  try {
    final response = await request.send();
    final responseBody = await response.stream.bytesToString();
    
    if (response.statusCode == 200) {
      return {
        'success': true,
        'message': 'Upload successful',
        'data': json.decode(responseBody)
      };
    } else {
      return {
        'success': false,
        'message': 'Upload failed',
        'error': responseBody
      };
    }
  } catch (e) {
    return {
      'success': false,
      'message': 'Network error',
      'error': e.toString()
    };
  }
}





}



