// lib/user_model.dart

class UserModel {
  final String name;
  final String email;
  final String password;
  final String phone;
  final String interests;
  final String meetupStyle;
  final String purpose;
  final String availability;
  final String preferredLocations;

  UserModel({
    required this.name,
    required this.email,
    required this.password,
    required this.phone,
    required this.interests,
    required this.meetupStyle,
    required this.purpose,
    required this.availability,
    required this.preferredLocations,
  });

  // Converts the UserModel object into a Map for JSON encoding
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'phone': phone,
      'interests': interests,
      'meetup_style': meetupStyle,
      'purpose': purpose,
      'availability': availability,
      'preferred_locations': preferredLocations,
    };
  }
}
