// lib/event_card.dart

import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'event_model.dart';
import 'event_details_screen.dart';

class EventCard extends StatefulWidget {
  final Event event;

  const EventCard({
    super.key,
    required this.event,
  });

  @override
  State<EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  bool _isExpanded = false;

  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    // ✨ FIXED: Calculate the number of attendees from the attendees list
    final attendeeCount = widget.event.attendees?.length ?? 0;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: AppColors.secondaryBackground,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _toggleExpansion,
          borderRadius: BorderRadius.circular(16.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  widget.event.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryText,
                  ),
                ),
                if (_isExpanded) ...[
                  const SizedBox(height: 8),
                  // ✨ FIXED: Use the correct fields from the Event model
                  Text(
                    'Status: ${widget.event.status}\n'
                    'Location: ${widget.event.location}\n'
                    'Joined: $attendeeCount / ${widget.event.groupSize}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.primaryText,
                      height: 1.5, // Adds a bit of space between lines
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EventDetailsScreen(event: widget.event),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryText,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          minimumSize: Size.zero,
                        ),
                        child: const Text('Details', style: TextStyle(color: AppColors.background)),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          // TODO: Implement join logic using the ApiService
                          print('Joined event: ${widget.event.title}');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryText,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          minimumSize: Size.zero,
                        ),
                        child: const Text('Join Now', style: TextStyle(color: AppColors.background)),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
