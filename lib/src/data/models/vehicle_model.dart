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
  final String? photos; // URL or path to the photo
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
}
