import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

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






}



