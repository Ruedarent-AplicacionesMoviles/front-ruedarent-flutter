// src/data/models/vehicle_model.dart

class VehicleModel {
  final int? id;
  final int ownerId;
  final int vehicleTypeId;
  final String brand;
  final String model;
  final String location;
  final String availability; // 'available', 'not available', 'under maintenance'
  final double price;
  final String? photos; // URL o path a la foto
  final String? description;

  VehicleModel({
    this.id,
    required this.ownerId,
    required this.vehicleTypeId,
    required this.brand,
    required this.model,
    required this.location,
    required this.availability,
    required this.price,
    this.photos,
    this.description,
  });

  // Convertir el modelo a un Map para interactuar con la base de datos
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'ownerId': ownerId,
      'vehicleTypeId': vehicleTypeId,
      'brand': brand,
      'model': model,
      'location': location,
      'availability': availability,
      'price': price,
      'photos': photos,
      'description': description,
    };
  }

  // Crear una instancia de VehicleModel a partir de un Map (al leer desde la base de datos)
  factory VehicleModel.fromMap(Map<String, dynamic> map) {
    return VehicleModel(
      id: map['id'],
      ownerId: map['ownerId'],
      vehicleTypeId: map['vehicleTypeId'],
      brand: map['brand'],
      model: map['model'],
      location: map['location'],
      availability: map['availability'],
      price: map['price'],
      photos: map['photos'],
      description: map['description'],
    );
  }

  // Método útil para debuggear, que devuelve una representación en String del objeto
  @override
  String toString() {
    return 'VehicleModel{id: $id, brand: $brand, model: $model, location: $location, price: $price}';
  }
}