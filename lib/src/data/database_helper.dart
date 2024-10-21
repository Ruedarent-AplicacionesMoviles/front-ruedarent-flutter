import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  // Singleton instance
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  // Singleton factory
  factory DatabaseHelper() => _instance;

  // Database instance
  static Database? _database;

  // Private constructor
  DatabaseHelper._internal();

  // Get database (initialize if it's not already initialized)
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Initialize the database
  Future<Database> _initDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'vehicles_database.db');

    // Open or create the database
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  // Create the database tables
  Future<void> _onCreate(Database db, int version) async {
    await db.execute(
        '''
      CREATE TABLE vehicles (
        id INTEGER PRIMARY KEY AUTOINCREMENT, 
        name TEXT, 
        info TEXT, 
        image TEXT
      )
      '''
    );
  }

  // ********** CRUD Operations **********

  // Insert a new vehicle (category) into the database
  Future<int> insertVehicle(Map<String, dynamic> vehicle) async {
    final db = await database;
    return await db.insert('vehicles', vehicle);
  }

  // Get all vehicles (categories) from the database
  Future<List<Map<String, dynamic>>> getVehicles() async {
    final db = await database;
    return await db.query('vehicles');
  }

  // Update a vehicle (category) in the database
  Future<int> updateVehicle(Map<String, dynamic> vehicle, int id) async {
    final db = await database;
    return await db.update(
      'vehicles',
      vehicle,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Delete a vehicle (category) from the database
  Future<int> deleteVehicle(int id) async {
    final db = await database;
    return await db.delete(
      'vehicles',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}