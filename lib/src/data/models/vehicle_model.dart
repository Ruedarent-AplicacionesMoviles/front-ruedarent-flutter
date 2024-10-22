// src/data/models/vehicle_model.dart

class VehicleModel {
  final int? id;                      // ID del vehículo, puede ser nulo si se está creando un nuevo vehículo
  final int ownerId;                  // ID del propietario
  final int vehicleTypeId;            // ID del tipo de vehículo
  final String brand;                 // Marca del vehículo
  final String model;                 // Modelo del vehículo
  final String location;              // Ubicación del vehículo
  final String availability;           // Disponibilidad: 'available', 'not available', 'under maintenance'
  final double price;                 // Precio del vehículo
  final String? photos;               // URL o path a la foto
  final String? description;          // Descripción del vehículo

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
      id: map['id'] as int?,  // Asegúrate de que esto se maneje correctamente
      ownerId: map['ownerId'] as int,
      vehicleTypeId: map['vehicleTypeId'] as int,
      brand: map['brand'] as String,
      model: map['model'] as String,
      location: map['location'] as String,
      availability: map['availability'] as String,
      price: (map['price'] as num).toDouble(),  // Convierte a double para asegurar el tipo
      photos: map['photos'] as String?,
      description: map['description'] as String?,
    );
  }

  // Método útil para debuggear, que devuelve una representación en String del objeto
  @override
  String toString() {
    return 'VehicleModel{id: $id, brand: $brand, model: $model, location: $location, price: $price}';
  }
}

