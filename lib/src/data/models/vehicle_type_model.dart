// src/data/models/vehicle_type_model.dart

class VehicleTypeModel {
  final int? id;
  final String name; // e.g., 'bicycle', 'scooter', 'electric motorcycle'

  VehicleTypeModel({
    this.id,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  factory VehicleTypeModel.fromMap(Map<String, dynamic> map) {
    return VehicleTypeModel(
      id: map['id'],
      name: map['name'],
    );
  }
}
