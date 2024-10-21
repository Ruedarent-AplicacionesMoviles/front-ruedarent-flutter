// src/data/repositories/reservation_repository.dart

import 'package:sqflite/sqflite.dart';
import '../database/database_helper.dart';
import '../models/reservation_model.dart';

class ReservationRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  // Insertar una nueva reserva
  Future<int> insertReservation(ReservationModel reservation) async {
    final db = await _databaseHelper.database;
    return await db.insert(
      'Reservation',
      reservation.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Obtener una reserva por ID
  Future<ReservationModel?> getReservationById(int id) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'Reservation',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return ReservationModel.fromMap(maps.first);
    }
    return null;
  }

  // Obtener todas las reservas
  Future<List<ReservationModel>> getAllReservations() async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('Reservation');

    return List.generate(maps.length, (i) {
      return ReservationModel.fromMap(maps[i]);
    });
  }

  // Actualizar una reserva
  Future<int> updateReservation(ReservationModel reservation) async {
    final db = await _databaseHelper.database;
    return await db.update(
      'Reservation',
      reservation.toMap(),
      where: 'id = ?',
      whereArgs: [reservation.id],
    );
  }

  // Eliminar una reserva
  Future<int> deleteReservation(int id) async {
    final db = await _databaseHelper.database;
    return await db.delete(
      'Reservation',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Obtener reservas por rentador
  Future<List<ReservationModel>> getReservationsByRenter(int renterId) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'Reservation',
      where: 'renterId = ?',
      whereArgs: [renterId],
    );

    return List.generate(maps.length, (i) {
      return ReservationModel.fromMap(maps[i]);
    });
  }

  // Obtener reservas por vehículo
  Future<List<ReservationModel>> getReservationsByVehicle(int vehicleId) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'Reservation',
      where: 'vehicleId = ?',
      whereArgs: [vehicleId],
    );

    return List.generate(maps.length, (i) {
      return ReservationModel.fromMap(maps[i]);
    });
  }
}
