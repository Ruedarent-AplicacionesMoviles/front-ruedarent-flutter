// src/data/repositories/user_repository.dart

import 'package:sqflite/sqflite.dart';
import '../database/database_helper.dart';
import '../models/user_model.dart';

class UserRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  // Insertar un nuevo usuario
  Future<int> insertUser(UserModel user) async {
    final db = await _databaseHelper.database;
    return await db.insert(
      'User',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Obtener un usuario por ID
  Future<UserModel?> getUserById(int id) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'User',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return UserModel.fromMap(maps.first);
    }
    return null;
  }

  // Obtener un usuario por email
  Future<UserModel?> getUserByEmail(String email) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'User',
      where: 'email = ?',
      whereArgs: [email],
    );

    if (maps.isNotEmpty) {
      return UserModel.fromMap(maps.first);
    }
    return null;
  }

  // Actualizar un usuario
  Future<int> updateUser(UserModel user) async {
    final db = await _databaseHelper.database;
    return await db.update(
      'User',
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  // Eliminar un usuario
  Future<int> deleteUser(int id) async {
    final db = await _databaseHelper.database;
    return await db.delete(
      'User',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Obtener todos los usuarios (opcional)
  Future<List<UserModel>> getAllUsers() async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('User');

    return List.generate(maps.length, (i) {
      return UserModel.fromMap(maps[i]);
    });
  }
}
