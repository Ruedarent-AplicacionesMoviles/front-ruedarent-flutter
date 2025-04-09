import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/address_model.dart';
import '../api_constants.dart';

class AddressRepository {
  final String _host = ApiConstants.host;
  final String _path = '/address.php';

  // Obtener todas las direcciones de un usuario específico
  Future<List<AddressModel>> getAllAddresses(int userId) async {
    final uri = Uri.parse('$_host$_path?userId=$userId');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<AddressModel>.from(data.map((item) => AddressModel.fromMap(item)));
    } else {
      throw Exception("Error al obtener direcciones: ${response.body}");
    }
  }

  // Insertar una nueva dirección
  Future<int> insertAddress(AddressModel address) async {
    final uri = Uri.parse('$_host$_path');
    final response = await http.post(
      uri,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(address.toMap()),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return data['id']; // <- Retorna el ID insertado
    } else {
      throw Exception("Error al insertar dirección: ${response.body}");
    }
  }

  // Eliminar una dirección por su ID
  Future<bool> deleteAddressById(int id) async {
    final uri = Uri.parse('$_host$_path?id=$id');
    final response = await http.delete(uri);

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception("Error al eliminar dirección: ${response.body}");
    }
  }

  // Actualizar una dirección
  Future<bool> updateAddress(AddressModel address) async {
    final uri = Uri.parse('$_host$_path');
    final response = await http.put(
      uri,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(address.toMap()),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception("Error al actualizar dirección: ${response.body}");
    }
  }
}
