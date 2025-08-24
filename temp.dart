// lib/event_list_screen.dart

import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'event_card.dart';
import 'event_model.dart';
import 'create_event_screen.dart';
import 'services/api_service.dart'; // Import the ApiService

class EventListScreen extends StatefulWidget {
  const EventListScreen({super.key});

  @override
  State<EventListScreen> createState() => _EventListScreenState();
}

class _EventListScreenState extends State<EventListScreen> {
  final ApiService _apiService = ApiService();
  late Future<List<Event>> _eventsFuture;

  @override
  void initState() {
    super.initState();
    // Start fetching events as soon as the screen loads
    _eventsFuture = _apiService.getEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const SizedBox(height: 50),
            const Text(
              'Join an Event',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryText,
              ),
            ),
            const SizedBox(height: 32),
            // ✨ Use FutureBuilder to handle the async API call
            Expanded(
              child: FutureBuilder<List<Event>>(
                future: _eventsFuture,
                builder: (context, snapshot) {
                  // Show a loading circle while waiting for data
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  // Show an error message if something went wrong
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.red)));
                  }
                  // If we have data and it's not empty, build the list
                  if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    final events = snapshot.data!;
                    return ListView.builder(
                      itemCount: events.length,
                      itemBuilder: (context, index) {
                        return EventCard(event: events[index]);
                      },
                    );
                  }
                  // Show a message if there are no events
                  return const Center(
                    child: Text(
                      'No events found.',
                      style: TextStyle(color: AppColors.primaryText),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CreateEventScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryText,
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Text(
                'Create an Event',
                style: TextStyle(
                  color: AppColors.background,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
