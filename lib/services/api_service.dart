import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class ApiService {
  // Set the base URL for your API
  final String baseUrl =
      'https://ecomap-zehf.onrender.com'; // Replace with your actual server URL
  // Replace with your actual server URL

  //create an api for map

Future<Map<String, String>> getUserDetails() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (token == null || token.isEmpty) {
      throw Exception('User not authenticated. Please log in.');
    }

    final String apiUrl = '$baseUrl/user/get-user';
    print('Fetching user details from: $apiUrl');
    print('Auth Token: $token');

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'x-authtoken': token,
      },
    ).timeout(const Duration(seconds: 10)); // Timeout after 10 seconds

    print('Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);

      // Validate response data
      if (responseBody is! Map || !responseBody.containsKey('name') || !responseBody.containsKey('email')) {
        throw Exception('Invalid response format.');
      }

      final name = responseBody['name']?.toString() ?? 'No name found';
      final email = responseBody['email']?.toString() ?? 'No email found';

      // Save to local storage
      await prefs.setString('user_name', name);
      await prefs.setString('user_email', email);

      return {
        'name': name,
        'email': email,
      };
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized access. Please log in again.');
    } else {
      throw Exception('Failed to fetch user details. Server error: ${response.statusCode}');
    }
  } on http.ClientException catch (error) {
    throw Exception('Network error: ${error.toString()}');
  } on FormatException {
    throw Exception('Invalid response format. Please try again later.');
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

    final responseBody = jsonDecode(response.body);

    if (response.statusCode == 200) {
      final prefs = await SharedPreferences.getInstance();

      // Save email
      await prefs.setString('user_email', email);

      // Save name if exists
      if (responseBody['name'] != null) {
        await prefs.setString('user_name', responseBody['name']);
      }

      // Extract and store token
      if (responseBody['token'] != null) {
        String token = responseBody['token'];
        await prefs.setString('auth_token', token);

        // Decode JWT token to extract userId
        Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
        String userId = decodedToken['id'] ?? ""; // Ensure userId is not null
        await prefs.setString('user_id', userId);

        print("User ID: $userId");
        return token; // Return token instead of userId
      } else {
        throw Exception('No authentication token received');
      }
    } else if (response.statusCode >= 400 && response.statusCode < 410) {
      throw Exception(responseBody['message'] ?? 'Invalid credentials or login failed');
    } else if (response.statusCode >= 500) {
      throw Exception('Server error. Please try again later.');
    } else {
      throw Exception('An unexpected error occurred. Please try again.');
    }
  } on SocketException {
    throw Exception('No internet connection. Please check your network.');
  } on FormatException {
    throw Exception('Error processing server response');
  } on HttpException {
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

 Future<List<Map<String, dynamic>>> fetchSpeciesWithLocations() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (token == null) {
      throw Exception('User not authenticated');
    }

    // Fetch species list
    final speciesResponse = await http.get(
      Uri.parse('$baseUrl/expert/get-species'),
      headers: {'Content-Type': 'application/json', 'x-authtoken': token},
    );

    if (speciesResponse.statusCode != 200) {
      throw Exception('Failed to fetch species list');
    }

    List<dynamic> speciesData = json.decode(speciesResponse.body);
    List<Map<String, dynamic>> speciesList = List<Map<String, dynamic>>.from(speciesData);

    // Fetch location data for each species
    for (var species in speciesList) {
      String speciesId = species['_id'];

      final locationResponse = await http.get(
        Uri.parse('$baseUrl/expert/species-map/$speciesId'),
        headers: {'Content-Type': 'application/json', 'x-authtoken': token},
      );

      if (locationResponse.statusCode == 200) {
        Map<String, dynamic> locationData = json.decode(locationResponse.body);

        if (locationData.containsKey('features') && (locationData['features'] as List).isNotEmpty) {
          // Use the first feature's geometry as the main location
          species['location'] = locationData['features'][0]['geometry'];
        } else {
          species['location'] = null; // No location data
        }
      } else {
        species['location'] = null; // If API fails, keep location null
      }
    }

    return speciesList;
  } catch (e) {
    print('Error fetching species with locations: $e');
    rethrow;
  }
}


//map route

 


  //route for myspottings
  
}
