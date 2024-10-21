// src/data/models/user_model.dart

class UserModel {
  final int? id;
  final String name;
  final String email;
  final String password;
  final String userType; // 'owner' or 'renter'
  final String notificationPreferences;

  UserModel({
    this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.userType,
    required this.notificationPreferences,
  });

  // Convert a UserModel into a Map. The keys must correspond to the names of the columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'userType': userType,
      'notificationPreferences': notificationPreferences,
    };
  }

  // Extract a UserModel object from a Map.
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      password: map['password'],
      userType: map['userType'],
      notificationPreferences: map['notificationPreferences'],
    );
  }
}
