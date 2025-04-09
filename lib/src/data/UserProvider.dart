import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider with ChangeNotifier {
  int? _userId;

  int? get userId => _userId;

  // Verifica si el usuario está logueado
  bool get isLoggedIn => _userId != null;

  // Cargar el ID del usuario desde SharedPreferences
  Future<void> loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    _userId = prefs.getInt('userId');
    notifyListeners();
  }

  // Guardar el ID del usuario en memoria y SharedPreferences
  Future<void> setUserId(int id) async {
    _userId = id;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('userId', id);
    notifyListeners();
  }

  // Cerrar sesión: limpiar memoria y SharedPreferences
  Future<void> clearUser() async {
    _userId = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
    notifyListeners();
  }
}
