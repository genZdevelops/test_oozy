// lib/services/api_service.dart

// ... (keep all the existing code like login, createEvent, etc.)

  // ✨ NEW: Method to get the list of all events
  Future<List<Event>> getEvents() async {
    final url = Uri.parse('$_baseUrl/events/');
    // This is a public endpoint in your code, so no auth headers needed for now.
    // If you protect it later, you'll need to add them.
    final headers = {'Content-Type': 'application/json; charset=UTF-8'};

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        // Decode the response body (which is a JSON array)
        final List<dynamic> eventData = json.decode(response.body);

        // Use our new Event.fromJson constructor to parse each event
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
