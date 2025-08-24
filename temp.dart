// lib/event_model.dart

class Event {
  final String title;
  final String date;
  final String location;
  final String interestTags;
  final int groupSize;
  final String duration;

  Event({
    required this.title,
    required this.date,
    required this.location,
    required this.interestTags,
    required this.groupSize,
    required this.duration,
  });

  // Method to convert our Event object into a Map (for JSON encoding)
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
