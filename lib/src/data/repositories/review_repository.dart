// src/data/repositories/review_repository.dart

import 'package:sqflite/sqflite.dart';
import '../database/database_helper.dart';
import '../models/review_model.dart';

class ReviewRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  // Insertar una nueva reseña
  Future<int> insertReview(ReviewModel review) async {
    final db = await _databaseHelper.database;
    return await db.insert(
      'Review',
      review.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Obtener una reseña por ID
  Future<ReviewModel?> getReviewById(int id) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'Review',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return ReviewModel.fromMap(maps.first);
    }
    return null;
  }

  // Obtener todas las reseñas para un vehículo
  Future<List<ReviewModel>> getReviewsByVehicle(int vehicleId) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'Review',
      where: 'vehicleId = ?',
      whereArgs: [vehicleId],
      orderBy: 'timestamp DESC',
    );

    return List.generate(maps.length, (i) {
      return ReviewModel.fromMap(maps[i]);
    });
  }

  // Obtener todas las reseñas hechas por un usuario
  Future<List<ReviewModel>> getReviewsByUser(int userId) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'Review',
      where: 'userId = ?',
      whereArgs: [userId],
      orderBy: 'timestamp DESC',
    );

    return List.generate(maps.length, (i) {
      return ReviewModel.fromMap(maps[i]);
    });
  }

  // Actualizar una reseña
  Future<int> updateReview(ReviewModel review) async {
    final db = await _databaseHelper.database;
    return await db.update(
      'Review',
      review.toMap(),
      where: 'id = ?',
      whereArgs: [review.id],
    );
  }

  // Eliminar una reseña
  Future<int> deleteReview(int id) async {
    final db = await _databaseHelper.database;
    return await db.delete(
      'Review',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
