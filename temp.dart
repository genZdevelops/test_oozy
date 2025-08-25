// lib/services/api_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../event_model.dart';
import '../user_model.dart'; // ✨ Import the new user model

class ApiService {
  // ... (keep all your existing code: _baseUrl, login, createEvent, getEvents, etc.)

  // ✨ NEW: Method to handle user registration
  Future<String> register(UserModel newUser) async {
    final url = Uri.parse('$_baseUrl/users/register');
    
    // The registration endpoint does not require an auth token
    final headers = {'Content-Type': 'application/json; charset=UTF-8'};
    
    // Encode the UserModel object into a JSON string
    final body = json.encode(newUser.toJson());

    try {
      final response = await http.post(url, headers: headers, body: body);

      // Status code 201 means "Created"
      if (response.statusCode == 201) {
        print('Registration successful!');
        return "Success";
      } else {
        // Handle errors, like "Email already registered" (which is status code 400)
        final errorData = json.decode(response.body);
        final errorMessage = errorData['detail'] ?? 'An unknown error occurred.';
        print('Registration failed: $errorMessage');
        return errorMessage; // Return the specific error message from the server
      }
    } catch (e) {
      print('An error occurred during registration: $e');
      return 'An error occurred. Please check your connection.';
    }
  }
}
