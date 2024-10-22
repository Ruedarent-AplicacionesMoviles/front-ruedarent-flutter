import 'package:sqflite/sqflite.dart';
import '../models/address_model.dart';
import '../database/database_helper.dart'; // Asegúrate de que este import apunte correctamente a tu DatabaseHelper

class AddressRepository {
  // Obtener todas las direcciones de un usuario específico
  Future<List<AddressModel>> getAllAddresses(int userId) async {
    final db = await DatabaseHelper().database;
    final List<Map<String, dynamic>> maps = await db.query(
      'Address',
      where: 'userId = ?',
      whereArgs: [userId], // Filtra por el ID del usuario
    );

    // Convertir cada Map en un modelo de AddressModel
    return List.generate(maps.length, (i) {
      return AddressModel.fromMap(maps[i]);
    });
  }

  // Insertar una nueva dirección
  Future<int> insertAddress(AddressModel address) async {
    final db = await DatabaseHelper().database;
    return await db.insert('Address', address.toMap());
  }

  // Eliminar una dirección por su ID
  Future<int> deleteAddressById(int id) async {
    final db = await DatabaseHelper().database;
    return await db.delete(
      'Address',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Actualizar una dirección por su ID (si necesitas esta funcionalidad)
  Future<int> updateAddress(AddressModel address) async {
    final db = await DatabaseHelper().database;
    return await db.update(
      'Address',
      address.toMap(),
      where: 'id = ?',
      whereArgs: [address.id],
    );
  }

  // Método para eliminar una dirección de la base de datos
  Future<void> deleteAddress(int id) async {
    final db = await DatabaseHelper().database;
    await db.delete(
      'Address', // Asegúrate de que el nombre de la tabla sea el correcto
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}