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
    this.password = '', // Hacer que sea opcional si no se devuelve
    required this.userType,
    required this.notificationPreferences,
  });

  // Convertir un UserModel a Map
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

  // Convertir Map a UserModel
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      password: map['password'] ?? '', // En login puede no venir
      userType: map['userType'],
      notificationPreferences: map['notificationPreferences'] ?? 'all',
    );
  }
}
