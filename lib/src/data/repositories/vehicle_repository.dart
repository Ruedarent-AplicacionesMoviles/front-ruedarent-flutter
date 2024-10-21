import 'package:sqflite/sqflite.dart';
import '../database/database_helper.dart';
import '../models/vehicle_model.dart';
import '../repositories/vehicle_type_repository.dart'; // Importa el repositorio de tipos de vehículos

class VehicleRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  // Insertar un nuevo vehículo
  Future<int> insertVehicle(VehicleModel vehicle) async {
    final db = await _databaseHelper.database;
    return await db.insert(
      'Vehicle',
      vehicle.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Obtener un vehículo por ID
  Future<VehicleModel?> getVehicleById(int id) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'Vehicle',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return VehicleModel.fromMap(maps.first);
    }
    return null;
  }

  // Obtener todos los vehículos
  Future<List<VehicleModel>> getAllVehicles() async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('Vehicle');

    return List.generate(maps.length, (i) {
      return VehicleModel.fromMap(maps[i]);
    });
  }

  // Actualizar un vehículo
  Future<int> updateVehicle(VehicleModel vehicle) async {
    final db = await _databaseHelper.database;
    return await db.update(
      'Vehicle',
      vehicle.toMap(),
      where: 'id = ?',
      whereArgs: [vehicle.id],
    );
  }

  // Eliminar un vehículo
  Future<int> deleteVehicle(int id) async {
    final db = await _databaseHelper.database;
    return await db.delete(
      'Vehicle',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Obtener vehículos por propietario
  Future<List<VehicleModel>> getVehiclesByOwner(int ownerId) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'Vehicle',
      where: 'ownerId = ?',
      whereArgs: [ownerId],
    );

    return List.generate(maps.length, (i) {
      return VehicleModel.fromMap(maps[i]);
    });
  }

  // Buscar y filtrar vehículos
  Future<List<VehicleModel>> searchVehicles({
    String? type,
    String? location,
    double? minPrice,
    double? maxPrice,
    String? availability,
  }) async {
    final db = await _databaseHelper.database;
    String whereClause = '';
    List<dynamic> whereArgs = [];

    if (type != null) {
      int vehicleTypeId = await _getVehicleTypeIdByName(type); // Llama al método
      if (vehicleTypeId != -1) { // Solo agrega la cláusula si se encontró el ID
        whereClause += 'vehicleTypeId = ? AND ';
        whereArgs.add(vehicleTypeId);
      }
    }
    if (location != null) {
      whereClause += 'location LIKE ? AND ';
      whereArgs.add('%$location%');
    }
    if (minPrice != null) {
      whereClause += 'price >= ? AND ';
      whereArgs.add(minPrice);
    }
    if (maxPrice != null) {
      whereClause += 'price <= ? AND ';
      whereArgs.add(maxPrice);
    }
    if (availability != null) {
      whereClause += 'availability = ? AND ';
      whereArgs.add(availability);
    }

    // Eliminar el último ' AND ' si existe
    if (whereClause.endsWith(' AND ')) {
      whereClause = whereClause.substring(0, whereClause.length - 5);
    }

    final List<Map<String, dynamic>> maps = await db.query(
      'Vehicle',
      where: whereClause.isNotEmpty ? whereClause : null,
      whereArgs: whereArgs.isNotEmpty ? whereArgs : null,
    );

    return List.generate(maps.length, (i) {
      return VehicleModel.fromMap(maps[i]);
    });
  }

  // Método adicional para obtener el ID del tipo de vehículo por nombre
  Future<int> _getVehicleTypeIdByName(String name) async {
    final vehicleTypeRepository = VehicleTypeRepository();
    final vehicleType = await vehicleTypeRepository.getVehicleTypeByName(name);
    return vehicleType?.id ?? -1; // Retorna -1 si no se encuentra
  }
}