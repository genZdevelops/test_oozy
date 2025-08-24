// lib/services/api_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../event_model.dart'; // We will create this file next

class ApiService {
  // IMPORTANT: Make sure this IP is correct for your network.
  static const String _baseUrl = 'http://192.168.1.2:8000';

  final _storage = const FlutterSecureStorage();

  // Helper method to get the authentication token
  Future<String?> _getToken() async {
    return await _storage.read(key: 'auth_token');
  }

  // Helper method to get authenticated headers
  Future<Map<String, String>> _getHeaders() async {
    final token = await _getToken();
    return {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    };
  }

  // Login method (your existing code)
  Future<bool> login(String email, String password) async {
    final body = {'username': email, 'password': password};
    final url = Uri.parse('$_baseUrl/token');

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: body,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final String? token = data['access_token'];
        if (token != null) {
          await _storage.write(key: 'auth_token', value: token);
          print('Login successful, token saved!');
          return true;
        }
        return false;
      } else {
        final errorData = json.decode(response.body);
        print('Login failed: ${errorData['detail']}');
        return false;
      }
    } catch (e) {
      print('An error occurred during login: $e');
      return false;
    }
  }

  // ✨ NEW: Method to create an event
  Future<bool> createEvent(Event newEvent) async {
    final url = Uri.parse('$_baseUrl/events');
    final headers = await _getHeaders();

    // The backend expects a JSON object, so we encode our Event object.
    final body = json.encode(newEvent.toJson());

    try {
      final response = await http.post(url, headers: headers, body: body);

      // A status code of 201 means "Created"
      if (response.statusCode == 201) {
        print('Event created successfully!');
        return true;
      } else {
        // Handle potential errors (like validation errors or server issues)
        final errorData = json.decode(response.body);
        print('Failed to create event: ${errorData['detail']}');
        return false;
      }
    } catch (e) {
      print('An error occurred while creating the event: $e');
      return false;
    }
  }
}
