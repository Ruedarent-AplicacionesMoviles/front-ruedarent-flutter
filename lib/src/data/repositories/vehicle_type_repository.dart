import 'package:sqflite/sqflite.dart';
import '../database/database_helper.dart';
import '../models/vehicle_type_model.dart';

class VehicleTypeRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  // Insertar un nuevo tipo de vehículo (categoría)
  Future<int> insertVehicleType(Map<String, dynamic> vehicleType) async {
    final db = await _databaseHelper.database;
    return await db.insert(
      'VehicleType',
      vehicleType,
      conflictAlgorithm: ConflictAlgorithm.replace, // Reemplaza si ya existe un conflicto
    );
  }

  // Obtener todos los tipos de vehículos (categorías) de la base de datos
  Future<List<Map<String, dynamic>>> getVehicleTypes() async {
    final db = await _databaseHelper.database;
    return await db.query('VehicleType');
  }

  // Actualizar un tipo de vehículo (categoría) en la base de datos
  Future<int> updateVehicleType(Map<String, dynamic> vehicleType, int id) async {
    final db = await _databaseHelper.database;
    return await db.update(
      'VehicleType',
      vehicleType,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Eliminar un tipo de vehículo (categoría) de la base de datos
  Future<int> deleteVehicleType(int id) async {
    final db = await _databaseHelper.database;
    return await db.delete(
      'VehicleType',
      where: 'id = ?',
      whereArgs: [id],
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
    return null;  // Retorna null si no encuentra el tipo de vehículo
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
    return null;  // Retorna null si no encuentra el tipo de vehículo
  }

  // Verificar si existe un tipo de vehículo por nombre
  Future<bool> existsVehicleTypeByName(String name) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'VehicleType',
      where: 'name = ?',
      whereArgs: [name],
    );

    return maps.isNotEmpty; // Retorna true si existe, false si no
  }
}