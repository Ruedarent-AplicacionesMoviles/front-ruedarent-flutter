import 'dart:convert';
import 'package:front_ruedarent_flutter/src/data/api_constants.dart';
import 'package:http/http.dart' as http;

import '../models/vehicle_model.dart';

class VehicleRepository {
  final String _baseUrl = ApiConstants.host;
  final String _path = '/vehicles.php';

  // Insertar un nuevo vehículo
  Future<bool> insertVehicle(VehicleModel vehicle) async {
    final uri = Uri.http(_baseUrl, _path);

    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(vehicle.toMap()),
    );

    if (response.statusCode == 201) {
      return true;
    } else {
      final error = jsonDecode(response.body);
      throw Exception('Error al registrar vehículo: ${error['error']}');
    }
  }

  // Obtener un vehículo por ID
  Future<VehicleModel?> getVehicleById(int id) async {
    final uri = Uri.http(_baseUrl, _path, {'id': id.toString()});

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data is List && data.isNotEmpty) {
        return VehicleModel.fromMap(data.first);
      } else if (data is Map && data.containsKey('vehiculo')) {
        return VehicleModel.fromMap(data['vehiculo']);
      } else {
        return null;
      }
    } else {
      throw Exception('Error al obtener vehículo: ${response.body}');
    }
  }

  // Obtener todos los vehículos
  Future<List<VehicleModel>> getAllVehicles() async {
    final uri = Uri.http(_baseUrl, _path);

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data is List) {
        return data.map((v) => VehicleModel.fromMap(v)).toList();
      } else if (data['vehiculos'] != null) {
        return List<VehicleModel>.from(data['vehiculos'].map((v) => VehicleModel.fromMap(v)));
      } else {
        throw Exception('Respuesta inesperada del servidor');
      }
    } else {
      throw Exception('Error al obtener vehículos: ${response.statusCode}');
    }
  }

  // Actualizar un vehículo
  Future<bool> updateVehicle(VehicleModel vehicle) async {
    final uri = Uri.http(_baseUrl, _path);

    final response = await http.put(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(vehicle.toMap()),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Error al actualizar vehículo: ${response.body}');
    }
  }

  // Eliminar un vehículo
  Future<bool> deleteVehicle(int id, int ownerId) async {
    final uri = Uri.http(_baseUrl, _path, {
      'id': id.toString(),
      'ownerId': ownerId.toString(),
    });

    final response = await http.delete(uri);

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Error al eliminar vehículo: ${response.body}');
    }
  }

  // Obtener vehículos por propietario
  Future<List<VehicleModel>> getVehiclesByOwner(int ownerId) async {
    final uri = Uri.http(_baseUrl, _path, {'ownerId': ownerId.toString()});

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final jsonBody = jsonDecode(response.body);
      final List<dynamic> vehiclesJson = jsonBody['vehiculos'];

      return vehiclesJson.map((json) => VehicleModel.fromMap(json)).toList();
    } else {
      throw Exception('Error al obtener vehículos del propietario: ${response.body}');
    }
  }

  // Buscar y filtrar vehículos
  Future<List<VehicleModel>> searchVehicles({
    String? type,
    String? location,
    double? minPrice,
    double? maxPrice,
    String? availability,
  }) async {
    final Map<String, String> queryParams = {};

    if (type != null && type.isNotEmpty) queryParams['type'] = type;
    if (location != null && location.isNotEmpty) queryParams['location'] = location;
    if (minPrice != null) queryParams['minPrice'] = minPrice.toString();
    if (maxPrice != null) queryParams['maxPrice'] = maxPrice.toString();
    if (availability != null && availability.isNotEmpty) queryParams['availability'] = availability;

    final uri = Uri.http(_baseUrl, _path, queryParams);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final jsonBody = jsonDecode(response.body);
      final List<dynamic> vehiclesJson = jsonBody['vehiculos'];
      return vehiclesJson.map((v) => VehicleModel.fromMap(v)).toList();
    } else {
      throw Exception('Error al filtrar vehículos: ${response.body}');
    }
  }

  // Actualizar disponibilidad (alternar entre available <-> not available)
  Future<void> updateVehicleAvailability(int vehicleId) async {
    final getUri = Uri.http(_baseUrl, _path, {'id': vehicleId.toString()});
    final getResponse = await http.get(getUri);

    if (getResponse.statusCode != 200) {
      throw Exception('Error al obtener el vehículo con ID $vehicleId');
    }

    final vehicleData = jsonDecode(getResponse.body);

    if (vehicleData is! List || vehicleData.isEmpty) {
      throw Exception('Vehículo no encontrado');
    }

    final vehicle = VehicleModel.fromMap(vehicleData[0]);

    final newAvailability = (vehicle.availability == 'available') ? 'not available' : 'available';

    final updatedVehicle = VehicleModel(
      id: vehicle.id,
      ownerId: vehicle.ownerId,
      vehicleTypeId: vehicle.vehicleTypeId,
      brand: vehicle.brand,
      model: vehicle.model,
      location: vehicle.location,
      availability: newAvailability,
      price: vehicle.price,
      photos: vehicle.photos,
      description: vehicle.description,
    );

    final putUri = Uri.http(_baseUrl, _path);

    final putResponse = await http.put(
      putUri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(updatedVehicle.toMap()),
    );

    if (putResponse.statusCode != 200) {
      throw Exception('Error al actualizar disponibilidad del vehículo');
    }
  }
}
