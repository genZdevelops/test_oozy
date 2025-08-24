// lib/event_model.dart

class Event {
  // Fields for creating an event
  final String title;
  final String date;
  final String location;
  final String interestTags;
  final int groupSize;
  final String duration;

  // Fields received from the backend
  final int? id;
  final int? hostId;
  final String? status;
  // In the future, you can create a User model and parse this list
  final List<dynamic>? attendees; 

  Event({
    required this.title,
    required this.date,
    required this.location,
    required this.interestTags,
    required this.groupSize,
    required this.duration,
    // These are optional since they don't exist when we first create an event
    this.id,
    this.hostId,
    this.status,
    this.attendees,
  });

  // ✨ NEW: A factory constructor to create an Event from JSON data
  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      title: json['title'],
      date: json['date'],
      location: json['location'],
      interestTags: json['interest_tags'],
      groupSize: json['group_size'],
      duration: json['duration'],
      hostId: json['host_id'],
      status: json['status'],
      attendees: json['attendees'] as List<dynamic>?,
    );
  }

  // Method to convert our Event object into JSON for sending to the backend
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'date': date,
      'location': location,
      'interest_tags': interestTags,
      'group_size': groupSize,
      'duration': duration,
    };
  }
}
