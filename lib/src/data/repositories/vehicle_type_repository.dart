// src/data/repositories/vehicle_type_repository.dart

import 'package:sqflite/sqflite.dart';
import '../database/database_helper.dart';
import '../models/vehicle_type_model.dart';

class VehicleTypeRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  // Insertar un nuevo tipo de vehículo
  Future<int> insertVehicleType(VehicleTypeModel vehicleType) async {
    final db = await _databaseHelper.database;
    return await db.insert(
      'VehicleType',
      vehicleType.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Obtener un tipo de vehículo por ID
  Future<VehicleTypeModel?> getVehicleTypeById(int id) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'VehicleType',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return VehicleTypeModel.fromMap(maps.first);
    }
    return null;
  }

  // Obtener un tipo de vehículo por nombre
  Future<VehicleTypeModel?> getVehicleTypeByName(String name) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'VehicleType',
      where: 'name = ?',
      whereArgs: [name],
    );

    if (maps.isNotEmpty) {
      return VehicleTypeModel.fromMap(maps.first);
    }
    return null;
  }

  // Obtener todos los tipos de vehículos
  Future<List<VehicleTypeModel>> getAllVehicleTypes() async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('VehicleType');

    return List.generate(maps.length, (i) {
      return VehicleTypeModel.fromMap(maps[i]);
    });
  }

  // Actualizar un tipo de vehículo
  Future<int> updateVehicleType(VehicleTypeModel vehicleType) async {
    final db = await _databaseHelper.database;
    return await db.update(
      'VehicleType',
      vehicleType.toMap(),
      where: 'id = ?',
      whereArgs: [vehicleType.id],
    );
  }

  // Eliminar un tipo de vehículo
  Future<int> deleteVehicleType(int id) async {
    final db = await _databaseHelper.database;
    return await db.delete(
      'VehicleType',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
