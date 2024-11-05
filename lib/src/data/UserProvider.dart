import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  int _userId = 1; // Valor por defecto, puede cargarse desde una sesión previa

  int get userId => _userId;

  void setUserId(int id) {
    _userId = id;
    notifyListeners();
  }
}