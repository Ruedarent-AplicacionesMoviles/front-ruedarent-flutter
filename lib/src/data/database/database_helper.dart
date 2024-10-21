// src/data/database/database_helper.dart

import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

// Importar modelos
import '../models/user_model.dart';
import '../models/vehicle_model.dart';
import '../models/reservation_model.dart';
import '../models/notification_model.dart';
import '../models/vehicle_type_model.dart';
import '../models/review_model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    // Si _database es null, lo inicializamos
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    // Obtener la ruta donde se almacenará la base de datos
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'rental_platform.db');

    // Abrir la base de datos, creando las tablas si no existen
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      // Puedes añadir onUpgrade si necesitas actualizar la estructura
    );
  }

  Future _onCreate(Database db, int version) async {
    // Crear tablas en el orden adecuado para respetar las dependencias
    await db.execute('''
      CREATE TABLE VehicleType (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL UNIQUE
      )
    ''');

    await db.execute('''
      CREATE TABLE "User" (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL,
        userType TEXT NOT NULL CHECK (userType IN ('owner', 'renter')),
        notificationPreferences TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE Vehicle (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        ownerId INTEGER NOT NULL,
        vehicleTypeId INTEGER NOT NULL,
        brand TEXT NOT NULL,
        model TEXT NOT NULL,
        location TEXT NOT NULL,
        availability TEXT NOT NULL CHECK (availability IN ('available', 'not available', 'under maintenance')),
        price REAL NOT NULL,
        photos TEXT,
        description TEXT,
        FOREIGN KEY (ownerId) REFERENCES "User"(id) ON DELETE CASCADE,
        FOREIGN KEY (vehicleTypeId) REFERENCES VehicleType(id) ON DELETE RESTRICT
      )
    ''');

    await db.execute('''
      CREATE TABLE Reservation (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        renterId INTEGER NOT NULL,
        vehicleId INTEGER NOT NULL,
        startDate TEXT NOT NULL,
        endDate TEXT NOT NULL,
        pickupLocation TEXT NOT NULL,
        dropoffLocation TEXT NOT NULL,
        reservationStatus TEXT NOT NULL CHECK (reservationStatus IN ('confirmed', 'canceled')),
        totalPrice REAL NOT NULL,
        paymentMethod TEXT NOT NULL,
        FOREIGN KEY (renterId) REFERENCES "User"(id) ON DELETE CASCADE,
        FOREIGN KEY (vehicleId) REFERENCES Vehicle(id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE Notification (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId INTEGER NOT NULL,
        notificationType TEXT NOT NULL,
        content TEXT NOT NULL,
        timestamp TEXT NOT NULL DEFAULT (datetime('now')),
        read INTEGER NOT NULL DEFAULT 0,
        FOREIGN KEY (userId) REFERENCES "User"(id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE Review (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        vehicleId INTEGER NOT NULL,
        userId INTEGER NOT NULL,
        rating INTEGER NOT NULL CHECK (rating >= 1 AND rating <= 5),
        comment TEXT,
        timestamp TEXT NOT NULL DEFAULT (datetime('now')),
        FOREIGN KEY (vehicleId) REFERENCES Vehicle(id) ON DELETE CASCADE,
        FOREIGN KEY (userId) REFERENCES "User"(id) ON DELETE CASCADE
      )
    ''');
  }

  // Métodos para cerrar la base de datos si es necesario
  Future close() async {
    final db = await database;
    db.close();
  }
}