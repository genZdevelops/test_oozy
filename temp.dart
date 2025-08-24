// lib/services/api_service.dart

  // ... (keep all the other code like login, createEvent, etc.)

  // Method to get the list of all events
  Future<List<Event>> getEvents() async {
    final url = Uri.parse('$_baseUrl/events/');
    
    // ✨ ADD THESE HEADERS TO PREVENT CACHING
    final headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Cache-Control': 'no-cache, no-store, must-revalidate',
      'Pragma': 'no-cache',
      'Expires': '0',
    };

    try {
      // Pass the updated headers to the request
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final List<dynamic> eventData = json.decode(response.body);
        return eventData.map((data) => Event.fromJson(data)).toList();
      } else {
        final errorData = json.decode(response.body);
        print('Failed to load events: ${errorData['detail']}');
        throw Exception('Failed to load events');
      }
    } catch (e) {
      print('An error occurred while fetching events: $e');
      throw Exception('An error occurred while fetching events');
    }
  }
