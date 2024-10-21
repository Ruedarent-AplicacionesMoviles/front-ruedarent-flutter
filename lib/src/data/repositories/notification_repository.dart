// src/data/repositories/notification_repository.dart

import 'package:sqflite/sqflite.dart';
import '../database/database_helper.dart';
import '../models/notification_model.dart';

class NotificationRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  // Insertar una nueva notificación
  Future<int> insertNotification(NotificationModel notification) async {
    final db = await _databaseHelper.database;
    return await db.insert(
      'Notification',
      notification.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Obtener una notificación por ID
  Future<NotificationModel?> getNotificationById(int id) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'Notification',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return NotificationModel.fromMap(maps.first);
    }
    return null;
  }

  // Obtener todas las notificaciones para un usuario
  Future<List<NotificationModel>> getNotificationsByUser(int userId) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'Notification',
      where: 'userId = ?',
      whereArgs: [userId],
      orderBy: 'timestamp DESC',
    );

    return List.generate(maps.length, (i) {
      return NotificationModel.fromMap(maps[i]);
    });
  }

  // Marcar una notificación como leída
  Future<int> markAsRead(int id) async {
    final db = await _databaseHelper.database;
    return await db.update(
      'Notification',
      {'read': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Eliminar una notificación
  Future<int> deleteNotification(int id) async {
    final db = await _databaseHelper.database;
    return await db.delete(
      'Notification',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
