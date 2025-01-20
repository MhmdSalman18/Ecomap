import 'dart:convert';
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
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 201) {
        return jsonDecode(
            response.body)['message']; // Success message from backend
      } else {
        final responseData = jsonDecode(response.body);
        throw Exception(responseData['message']); // Error message from backend
      }
    } catch (error) {
      throw Exception(
          'Failed to connect to the server. Please check your internet connection.'); // Network error
    }
  }
}




