import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api_constants.dart';
import '../models/vehicle_type_model.dart';

class VehicleTypeRepository {
  final String _host = ApiConstants.host;
  final String _path = '/vehicle_type.php';

  // Obtener todos los tipos de vehículos
  Future<List<VehicleTypeModel>> getVehicleTypes() async {
    final response = await http.get(Uri.parse("$_host$_path"));

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => VehicleTypeModel.fromMap(e)).toList();
    } else {
      throw Exception('Error al obtener tipos de vehículo: ${response.body}');
    }
  }

  // Insertar un nuevo tipo de vehículo
  Future<int> insertVehicleType(VehicleTypeModel vehicleType) async {
    final response = await http.post(
      Uri.parse("$_host$_path"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(vehicleType.toMap()),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return data['id'];
    } else {
      throw Exception('Error al crear tipo de vehículo: ${response.body}');
    }
  }

  // Actualizar un tipo de vehículo
  Future<void> updateVehicleType(VehicleTypeModel vehicleType) async {
    final response = await http.put(
      Uri.parse("$_host$_path"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(vehicleType.toMap()),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al actualizar tipo de vehículo: ${response.body}');
    }
  }

  // Eliminar un tipo de vehículo por ID
  Future<void> deleteVehicleType(int id) async {
    final response = await http.delete(Uri.parse("$_host$_path?id=$id"));

    if (response.statusCode != 200) {
      throw Exception('Error al eliminar tipo de vehículo: ${response.body}');
    }
  }

  // Obtener tipo por ID
  Future<VehicleTypeModel?> getVehicleTypeById(int id) async {
    final response = await http.get(Uri.parse("$_host$_path?id=$id"));

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.isNotEmpty ? VehicleTypeModel.fromMap(data[0]) : null;
    } else {
      throw Exception('Error al obtener tipo por ID: ${response.body}');
    }
  }

  // Obtener tipo por nombre
  Future<VehicleTypeModel?> getVehicleTypeByName(String name) async {
    final response = await http.get(Uri.parse("$_host$_path?name=$name"));

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.isNotEmpty ? VehicleTypeModel.fromMap(data[0]) : null;
    } else {
      throw Exception('Error al obtener tipo por nombre: ${response.body}');
    }
  }

  // Obtener ID por nombre
  Future<int> getVehicleTypeIdByName(String name) async {
    final type = await getVehicleTypeByName(name);
    return type?.id ?? -1;
  }

  // Verificar si existe un tipo por nombre
  Future<bool> existsVehicleTypeByName(String name) async {
    final response = await http.get(Uri.parse("$_host$_path?name=$name"));

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.isNotEmpty;
    } else {
      throw Exception('Error al verificar existencia: ${response.body}');
    }
  }
}
