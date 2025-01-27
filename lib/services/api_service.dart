import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http_parser/http_parser.dart';

class ApiService {
  // Set the base URL for your API
  final String baseUrl =
      'https://ecomap-zehf.onrender.com'; // Replace with your actual server URL

  Future<Map<String, String>> getUserDetails() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('user_email') ?? 'No email found';
    final name = prefs.getString('user_name') ?? 'No name found';
    return {
      'email': email,
      'name': name,
    };
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
        if (responseBody['token'] != null) {
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
  // Input validation
  if (title.trim().isEmpty || description.trim().isEmpty || imagePath.trim().isEmpty) {
    return {
      'success': false,
      'message': 'Title, description, and image are required',
      'error': 'Missing required fields',
    };
  }

  try {
    // Retrieve the authentication token
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (token == null || token.isEmpty) {
      return {
        'success': false,
        'message': 'Authentication required',
        'error': 'No auth token found',
      };
    }

    // Create a multipart request
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/user/upload-image'),
    );

    // Add headers
    request.headers.addAll({
      'x-authtoken': token,
      'Content-Type': 'multipart/form-data',
    });

    // Add basic fields
    request.fields.addAll({
      'title': title.trim(),
      'description': description.trim(),
      'date': date,
    });

    // Parse and validate location coordinates
    try {
      double latitude;
      double longitude;

      // Handle different location string formats
      if (location.contains('Latitude:') && location.contains('Longitude:')) {
        final latMatch = RegExp(r'Latitude:\s*([-+]?\d*\.?\d+)').firstMatch(location);
        final longMatch = RegExp(r'Longitude:\s*([-+]?\d*\.?\d+)').firstMatch(location);

        if (latMatch == null || longMatch == null) {
          throw FormatException('Could not extract coordinates from location string');
        }

        latitude = double.parse(latMatch.group(1)!);
        longitude = double.parse(longMatch.group(1)!);
      } else {
        final coords = location.split(',');
        if (coords.length != 2) {
          throw FormatException('Location must have two comma-separated values');
        }

        latitude = double.parse(coords[0].trim());
        longitude = double.parse(coords[1].trim());
      }

      if (latitude < -90 || latitude > 90) {
        throw FormatException('Latitude must be between -90 and 90 degrees');
      }
      if (longitude < -180 || longitude > 180) {
        throw FormatException('Longitude must be between -180 and 180 degrees');
      }

      request.fields['location.type'] = 'Point';
      request.fields['location.coordinates'] = '[$longitude, $latitude]';

    } catch (e) {
      print('Error parsing location: $e');
      return {
        'success': false,
        'message': 'Invalid location coordinates',
        'error': e.toString(),
      };
    }

    // Add image file
    if (imagePath.isNotEmpty) {
      try {
        final file = await http.MultipartFile.fromPath(
          'image',
          imagePath,
          contentType: MediaType('image', 'jpeg'),
        );
        request.files.add(file);
      } catch (e) {
        print('Error adding image file: $e');
        return {
          'success': false,
          'message': 'Error processing image file',
          'error': e.toString(),
        };
      }
    }

    // Send request with timeout and retry logic
    int retryCount = 0;
    const maxRetries = 3;
    const retryDelay = Duration(seconds: 2);

    while (retryCount < maxRetries) {
      try {
        final streamedResponse = await request.send().timeout(
          const Duration(seconds: 30),
          onTimeout: () {
            throw TimeoutException('Upload request timed out');
          },
        );

        final response = await http.Response.fromStream(streamedResponse);
        final responseBody = response.body;

        print('Server response status: ${response.statusCode}');
        print('Server response body: $responseBody');

        // Handle different status codes
        switch (response.statusCode) {
          case 200:
          case 201:
            return {
              'success': true,
              'message': 'Upload successful',
              'data': json.decode(responseBody),
            };
          
          case 503:
            if (retryCount < maxRetries - 1) {
              print('Server unavailable, retrying in ${retryDelay.inSeconds} seconds...');
              await Future.delayed(retryDelay);
              retryCount++;
              continue;
            }
            return {
              'success': false,
              'message': 'Server is temporarily unavailable. Please try again later.',
              'error': 'Service Unavailable (503)',
            };

          case 401:
            return {
              'success': false,
              'message': 'Authentication failed. Please log in again.',
              'error': 'Unauthorized (401)',
            };

          case 413:
            return {
              'success': false,
              'message': 'Image file is too large. Please choose a smaller image.',
              'error': 'Payload Too Large (413)',
            };

          default:
            return {
              'success': false,
              'message': 'Upload failed',
              'error': 'Server returned status ❤️ ${response.statusCode}: $responseBody',
            };
        }
      } catch (e) {
        if (e is TimeoutException || retryCount >= maxRetries - 1) {
          return {
            'success': false,
            'message': 'Network error occurred',
            'error': e.toString(),
          };
        }
        print('Attempt ${retryCount + 1} failed: $e');
        await Future.delayed(retryDelay);
        retryCount++;
      }
    }

    return {
      'success': false,
      'message': 'Upload failed after $maxRetries attempts',
      'error': 'Max retries exceeded',
    };

  } catch (e) {
    print('Unexpected error: $e');
    return {
      'success': false,
      'message': 'An unexpected error occurred',
      'error': e.toString(),
    };
  }
}
}
