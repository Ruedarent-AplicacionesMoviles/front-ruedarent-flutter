import 'dart:convert';
import 'package:front_ruedarent_flutter/src/data/api_constants.dart';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

class UserRepository {
  final String _host = ApiConstants.host;
  final String _usersPath = '/users.php';
  final String _loginPath = '/login.php';

  // Insertar un nuevo usuario (registro)
  Future<void> insertUser(UserModel user) async {
    final uri = Uri.parse('$_host$_usersPath');

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(user.toMap()),
    );

    if (response.statusCode != 201) {
      print('Respuesta del backend: ${response.body}');
      throw Exception('Error al registrar usuario');
    }
  }

  // Obtener un usuario por email (para verificar si ya existe)
  Future<UserModel?> getUserByEmail(String email) async {
    final uri = Uri.parse('$_host$_usersPath?email=$email');

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data is List && data.isNotEmpty) {
        return UserModel.fromMap(data.first);
      }
      return null;
    } else {
      throw Exception('Error al buscar usuario: ${response.body}');
    }
  }

  // Método para iniciar sesión (login)
  Future<UserModel> loginUser(String email, String password) async {
    final uri = Uri.parse('$_host$_loginPath');

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return UserModel.fromMap(data['user']);
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['error'] ?? 'Error al iniciar sesión');
    }
  }

  // Obtener usuario por ID
  Future<UserModel?> getUserById(int id) async {
    final uri = Uri.parse('$_host$_usersPath?id=$id');

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data is List && data.isNotEmpty) {
        return UserModel.fromMap(data.first);
      }
      return null;
    } else {
      throw Exception('Error al obtener usuario por ID: ${response.body}');
    }
  }

  // Actualizar usuario
  Future<void> updateUser(UserModel user) async {
    final uri = Uri.parse('$_host$_usersPath');

    final response = await http.put(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(user.toMap()),
    );

    if (response.statusCode != 200) {
      final error = jsonDecode(response.body);
      throw Exception(error['error'] ?? 'Error al actualizar usuario');
    }
  }
}
