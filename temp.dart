// lib/services/api_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  // IMPORTANT: Replace with your computer's IP address.
  // Do NOT use localhost or 127.0.0.1.
  // Your phone and computer must be on the same Wi-Fi network.
  // To find your IP address:
  // - Windows: Open Command Prompt and type `ipconfig`
  // - macOS/Linux: Open Terminal and type `ifconfig` or `ip a`
  static const String _baseUrl = 'http://192.168.1.10:8000'; // <--- CHANGE THIS

  // Create a secure storage instance to save the token
  final _storage = const FlutterSecureStorage();

  // Method to handle user login
  // It returns true on success, false on failure.
  Future<bool> login(String email, String password) async {
    // Your FastAPI /token endpoint expects form data, not JSON.
    // We create a Map to hold the email and password.
    final body = {
      'username': email,
      'password': password,
    };

    // The endpoint URL for login
    final url = Uri.parse('$_baseUrl/token');

    try {
      // We make a POST request with the form data in the body.
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: body,
      );

      // Check if the request was successful (status code 200)
      if (response.statusCode == 200) {
        // Decode the JSON response from the server
        final data = json.decode(response.body);
        final String? token = data['access_token'];

        if (token != null) {
          // If we get a token, save it securely
          await _storage.write(key: 'auth_token', value: token);
          print('Login successful, token saved!');
          return true; // Indicate success
        }
        return false; // Token was null
      } else {
        // If the server returns an error, print it
        final errorData = json.decode(response.body);
        print('Login failed: ${errorData['detail']}');
        return false; // Indicate failure
      }
    } catch (e) {
      // Handle any other errors, like network issues
      print('An error occurred during login: $e');
      return false;
    }
  }

  // You can add more methods here for other endpoints later!
  // For example:
  // Future<List<Event>> getEvents() async { ... }
  // Future<void> register(User user) async { ... }
}
