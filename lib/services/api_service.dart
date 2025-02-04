import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

class ApiService {
  // Set the base URL for your API
  final String baseUrl =
      'https://ecomap-zehf.onrender.com/'; // Replace with your actual server URL

  //create an api for map
  

  Future<Map<String, String>> getUserDetails() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null) {
        throw Exception('User not authenticated. Please log in.');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/user/get-user'),
        headers: {
          'Content-Type': 'application/json',
          'x-authtoken': token, // Sending token in x-authtoken header
        },
      );

      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);

        // Extract name and email
        final name = responseBody['name'] ?? 'No name found';
        final email = responseBody['email'] ?? 'No email found';

        // Optionally update local storage
        await prefs.setString('user_name', name);
        await prefs.setString('user_email', email);

        return {
          'name': name,
          'email': email,
        };
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized access. Please log in again.');
      } else {
        throw Exception('Failed to fetch user details. Please try again.');
      }
    } on Exception catch (error) {
      throw Exception('An error occurred: ${error.toString()}');
    }
  }

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
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_email', email);
        await prefs.setString('user_name', name); // Save name here
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
        final prefs = await SharedPreferences.getInstance();

        // Save email to SharedPreferences
        await prefs.setString('user_email', email);

        // Save name if it exists in the response
        if (responseBody['name'] != null) {
          await prefs.setString('user_name', responseBody['name']);
        }

        // Return the token if it exists
        // Return the token if it exists
        if (responseBody['token'] != null) {
          await prefs.setString('auth_token', responseBody['token']);
          return responseBody['token'];
        } else {
          throw Exception('No authentication token received');
        }
      }
      // Handle errors
      else if (response.statusCode >= 400 && response.statusCode < 410) {
        if (responseBody != null && responseBody['message'] != null) {
          throw Exception(responseBody['message']);
        }
        throw Exception('Invalid credentials or login failed');
      }
      // Handle server-side errors
      else if (response.statusCode >= 500) {
        throw Exception('Server error. Please try again later.');
      }
      // Unexpected status codes
      else {
        throw Exception('An unexpected error occurred. Please try again.');
      }
    } on SocketException catch (_) {
      throw Exception('No internet connection. Please check your network.');
    } on FormatException catch (_) {
      throw Exception('Error processing server response');
    } on HttpException catch (_) {
      throw Exception('Could not connect to the server');
    } catch (error) {
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
          'resetToken':
              responseBody['resetToken'], // New field to store reset token
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
    if (title.trim().isEmpty ||
        description.trim().isEmpty ||
        imagePath.trim().isEmpty) {
      return {
        'success': false,
        'message': 'Title, description, and image are required',
        'error': 'Missing required fields',
      };
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null || token.isEmpty) {
        return {
          'success': false,
          'message': 'Authentication required',
          'error': 'No auth token found',
        };
      }

      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/user/upload-image'),
      );

      request.headers.addAll({
        'x-authtoken': token,
        'Content-Type': 'multipart/form-data',
      });

      request.fields.addAll({
        'title': title.trim(),
        'description': description.trim(),
        'date': date,
      });

      // Location validation and parsing
      try {
        // Print the original location string for debugging
        print('Received location: $location');

        // Refined Regex to handle whitespace and robust parsing
        final latRegex = RegExp(r'Latitude:\s*([-+]?[0-9]*\.?[0-9]+)');
        final lngRegex = RegExp(r'Longitude:\s*([-+]?[0-9]*\.?[0-9]+)');

        final latitudeMatch = latRegex.firstMatch(location);
        final longitudeMatch = lngRegex.firstMatch(location);

        if (latitudeMatch == null || longitudeMatch == null) {
          throw const FormatException(
            'Invalid location format. Ensure it follows "Latitude:<value>, Longitude:<value>"',
          );
        }

        final latitude = double.parse(latitudeMatch.group(1)!.trim());
        final longitude = double.parse(longitudeMatch.group(1)!.trim());

        if (latitude < -90 ||
            latitude > 90 ||
            longitude < -180 ||
            longitude > 180) {
          throw const FormatException('Latitude or longitude out of range');
        }

        // Print parsed latitude and longitude
        print('Parsed latitude: $latitude, longitude: $longitude');

        request.fields['location.type'] = 'Point';
        request.fields['location.coordinates[0]'] = longitude.toString();
        request.fields['location.coordinates[1]'] = latitude.toString();
      } catch (e) {
        return {
          'success': false,
          'message': 'Invalid location coordinates: $location',
          'error': e.toString(),
        };
      }

      // Image file attachment
      if (!File(imagePath).existsSync()) {
        return {
          'success': false,
          'message': 'Image file not found',
          'error': 'File does not exist at $imagePath',
        };
      }

      try {
        final mimeType =
            lookupMimeType(imagePath) ?? 'application/octet-stream';
        final file = await http.MultipartFile.fromPath(
          'image',
          imagePath,
          contentType: MediaType.parse(mimeType),
        );
        request.files.add(file);
      } catch (e) {
        return {
          'success': false,
          'message': 'Error processing image file',
          'error': e.toString(),
        };
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseBody = json.decode(response.body);

        return {
          'success': true,
          'message': 'Image uploaded successfully!',
          'upload': responseBody,
        };
      } else {
        print('Response: ${response.statusCode} ${response.body}');
        return {
          'success': false,
          'message': 'Upload failed',
          'error':
              'Server returned status ${response.statusCode}: ${response.body}',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'An unexpected error occurred',
        'error': e.toString(),
      };
    }
  }
}
